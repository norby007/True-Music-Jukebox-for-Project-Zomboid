if isServer() then return end

require "Jukebox/Menu"
require "Jukebox/Utility"

Jukebox = Jukebox or {}

Jukebox.playTrackFromInventory = function(playerIndex, menu, stack)
    local item = nil
    local items = nil
    if stack and stack[1] and stack[1].items then
            items = stack[1].items
            item = items[1]
    elseif stack and stack[1] then
        item = stack[1]
    end

    if not item then return end

    if item:getContainer() and item:getContainer():getType() == "jukebox" then
        local tracklist = item:getContainer()

        local player = getSpecificPlayer(playerIndex)

        local jukebox = tracklist:getParent()

        local square = jukebox:getSquare()

        if jukebox:getModData().version ~= Jukebox.version then
            jukebox = Jukebox.getEvolvedJukebox(square) -- Upgrades jukebox if necessary.
        end
        
        Jukebox.initializePlaylist(jukebox)

        -- local objects = square:getWorldObjects()

        local jukeboxData = jukebox:getModData()

        local trackType = item:getType()

        local key = Jukebox.locationToKey(jukeboxData)

        local activeTrack = Jukebox.activeTracks[key]

	    -- wookieesWereHere is nonexistent; it is a nil label used to indicate unused variables in function calls.
        if not jukeboxData.on then

            menu:addOptionOnTop(Jukebox.translation.turnOnJukebox, wookieesWereHere,
                function()
                    jukeboxData.currentIndex = Jukebox.getTrackIndex(jukeboxData, trackType)
                    JukeboxMenus.onUseJukebox(wookieesWereHere, player, jukebox, "On")
                end
            )

        else

            menu:addOptionOnTop(Jukebox.translation.turnOffJukebox, wookieesWereHere,
                function()
                    JukeboxMenus.onUseJukebox(wookieesWereHere, player, jukebox, "Off")
                end
            )

            if not Jukebox.getSoundFile(trackType) then return end

            -- Main Menu
            local volumeMenu = menu:getNew(menu)

            menu:addSubMenu(menu:addOptionOnTop(Jukebox.translation.setJukeboxVolume), volumeMenu)
    
            for index = 1, 11 do
                if index == Jukebox.volumesIndex[jukeboxData.volume] then	
                    -- No need to send nil, and just send #.
                    volumeMenu:addOption("" .. index .. "  <---", wookieesWereHere, 
                        JukeboxMenus.onUseJukebox, player, jukebox, index) 
                else
                    -- No need to send nil, and just send #.
                    volumeMenu:addOption("" .. index, wookieesWereHere, 
                        JukeboxMenus.onUseJukebox, player, jukebox, index) 
                end
            end

            local toggleQueueLockText = (jukeboxData.queueLocked and Jukebox.translation.unlockQueue) or Jukebox.translation.lockQueue

            -- These options are meaningless with only a single song in the box.
            if #jukeboxData.playlist > 1 then

                local jukeboxMainMenu = menu:getNew(menu)
    
                menu:addSubMenu(menu:addOptionOnTop(Jukebox.translation.jukeboxMainMenu), jukeboxMainMenu)
    
                jukeboxMainMenu:addOption(Jukebox.translation.skipCurrentTrack, wookieesWereHere, JukeboxMenus.onUseJukebox,
                    player, jukebox, "Skip Current")
    
                jukeboxMainMenu:addOption(Jukebox.translation.replayCurrentTrack, wookieesWereHere, JukeboxMenus.onUseJukebox,
                    player,	jukebox, "Replay Current")
    
                jukeboxMainMenu:addOption(Jukebox.translation.replayLastTrack, wookieesWereHere, JukeboxMenus.onUseJukebox,
                    player,	jukebox, "Replay Last")
    
                jukeboxMainMenu:addOption(Jukebox.translation.playRandomTrack, wookieesWereHere, JukeboxMenus.onUseJukebox,
                    player,	jukebox, "Random")
    
                jukeboxMainMenu:addOption(Jukebox.translation.shuffleLoadedTracks, wookieesWereHere, JukeboxMenus.onUseJukebox,	
                    player,	jukebox, "Shuffle")

                jukeboxMainMenu:addOption(toggleQueueLockText, wookieesWereHere, JukeboxMenus.onUseJukebox,
					player,	jukebox, "Toggle Queue Lock")
            
            end

            -- Queue Menu

            if (activeTrack or jukeboxData.queueSize > 0) and jukeboxData.hasPlayableTracks then
				-- Menu -> Queue Menu
				local queueMenu = menu:getNew(menu)
				menu:addSubMenu(menu:addOptionOnTop(Jukebox.translation.viewQueue), queueMenu)

				-- local nowPlaying = Jukebox.getCurrentTitle(jukeboxData) .. " (" .. Jukebox.translation.nowPlaying .. ")"

				local nowPlaying = "{ " .. Jukebox.getCurrentTitle(jukeboxData) .. " } ~ " .. Jukebox.translation.nowPlaying

				local skipMenu = queueMenu:getNew(queueMenu)

				skipMenu:addOption(Jukebox.translation.skipCurrentTrack, wookieesWereHere, JukeboxMenus.onUseJukebox,
					player, jukebox, "Skip Current")

				skipMenu:addOption(Jukebox.translation.replayCurrentTrack, wookieesWereHere, JukeboxMenus.onUseJukebox,
					player,	jukebox, "Replay Current")

				skipMenu:addOption(Jukebox.translation.replayLastTrack, wookieesWereHere, JukeboxMenus.onUseJukebox,
					player,	jukebox, "Replay Last")

                skipMenu:addOption(toggleQueueLockText, wookieesWereHere, JukeboxMenus.onUseJukebox,
					player,	jukebox, "Toggle Queue Lock")

                if Jukebox.getSoundFile(Jukebox.getCurrentTrack(jukeboxData)) then
                    queueMenu:addSubMenu(queueMenu:addOption(nowPlaying), skipMenu)
                end

				local loopingIndex = (jukeboxData.currentIndex % #jukeboxData.playlist) + 1
				
				-- Limit to showing 30 songs by default to avoid menu lag.
				local queuedRemaining = Jukebox.mod.options.showEveryTrackUsingContextMenu and jukeboxData.queueSize or 30

				alreadyLoaded = {}

				while queuedRemaining > 0 and loopingIndex ~= jukeboxData.currentIndex and jukeboxData.currentIndex do
					local trackType = jukeboxData.playlist[loopingIndex]
					if jukeboxData.queue[trackType] and not alreadyLoaded[trackType] then
						alreadyLoaded[trackType] = true
						local trackDisplayName = jukeboxData.titles[trackType] or false
						-- if trackDisplayName then -- If not, something is wonky...
						queuedRemaining = queuedRemaining - 1

						-- Track Menu -> Individual Track Play Menu
						local playMenu = queueMenu:getNew(queueMenu)

						playMenu:addOption(Jukebox.translation.playNow, player, 
							function() 
								JukeboxMenus.onUseJukebox(wookieesWereHere, player, jukebox, "Play Now", trackType)
							end
						)

						if Jukebox.activeTracks[key] then						
							playMenu:addOption(Jukebox.translation.playNext, player, 
								function()
									JukeboxMenus.onUseJukebox(wookieesWereHere, player, jukebox, "Play Next", trackType)
								end
							)
						end

						if jukeboxData.queueSize > 0 then						
							playMenu:addOption(Jukebox.translation.playLast, player, 
								function() 
									JukeboxMenus.onUseJukebox(wookieesWereHere, player, jukebox, "Play Last", trackType)
								end
							)
						end
			
                        playMenu:addOption(Jukebox.translation.dequeue, wookieesWereHere, 
                            function() 
                                JukeboxMenus.onUseJukebox(wookieesWereHere, player, jukebox, "Dequeue Track", trackType)
                            end
                        )

						queueMenu:addSubMenu(queueMenu:addOption(trackDisplayName), playMenu)
					end
					loopingIndex = (loopingIndex % #jukeboxData.playlist) + 1
				end
            end
			
            if jukeboxData.queue[trackType] then
                menu:addOptionOnTop(Jukebox.translation.dequeue, wookieesWereHere, 
                    function() 
                        JukeboxMenus.onUseJukebox(wookieesWereHere, player, jukebox, "Dequeue Track", trackType)
                    end
                )
            end

            menu:addOptionOnTop(Jukebox.translation.playNow, player,
                function()
                    JukeboxMenus.onUseJukebox(wookieesWereHere, player, jukebox, "Play Now", trackType)
                end
            )

            if not activeTrack then return end

            menu:addOptionOnTop(Jukebox.translation.playNext, player,
                function()
                    JukeboxMenus.onUseJukebox(wookieesWereHere, player, jukebox, "Play Next", trackType)
                end
            )

            if not (jukeboxData.queueSize > 0) then return end

            menu:addOptionOnTop(Jukebox.translation.playLast, player,
                function()
                    JukeboxMenus.onUseJukebox(wookieesWereHere, player, jukebox, "Play Last", trackType)
                end
            )

        end
    end
end

Events.OnFillInventoryObjectContextMenu.Add(Jukebox.playTrackFromInventory)