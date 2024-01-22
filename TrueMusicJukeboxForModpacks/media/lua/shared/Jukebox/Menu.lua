if isServer() then return end

local Jukebox = require("Jukebox/Utility")

local JukeboxSound = require("Jukebox/Sound")

local JukeboxMenus = {}

-------------------------------------------------------------------

JukeboxMenus.addTurnOnJukebox = function(menu, player, jukebox, key, trackType) 
    menu:addOptionOnTop(Jukebox.translation.turnOnJukebox, player, 
        JukeboxMenus.process, jukebox, key, "On", trackType)
end

JukeboxMenus.addTurnOffJukebox = function(menu, player, jukebox, key)
    menu:addOptionOnTop(Jukebox.translation.turnOffJukebox, player, 
        JukeboxMenus.process, jukebox, key, "Off")
end

JukeboxMenus.addCheckStatus = function(menu, player, jukebox, key) 
    if (getCore():getDebug() or isAdmin()) then
        menu:addOption(Jukebox.translation.statusReport, player, 
            JukeboxMenus.process, jukebox, key, "Status").iconTexture = Jukebox.getIcon("Check Status")
    end
end

JukeboxMenus.addJukeboxVolume = function(menu, player, jukebox, key, jukeboxData)
    local volumeMenu = menu:getNew(menu)

	local volumeMenuOption = menu:addOptionOnTop(Jukebox.translation.setJukeboxVolume)

	volumeMenuOption.iconTexture = Jukebox.getIcon("Volume")

    menu:addSubMenu(volumeMenuOption, volumeMenu)

    for index = 1, 11 do
        if index == Jukebox.volumesIndex[jukeboxData.volume] then	
            -- No need to send nil, and just send #.
            volumeMenu:addOption("" .. index .. "  <---", player, 
                JukeboxMenus.process, jukebox, key, index) 
        else
            -- No need to send nil, and just send #.
            volumeMenu:addOption("" .. index, player, 
                JukeboxMenus.process, jukebox, key, index) 
        end
    end
end

JukeboxMenus.addJukeboxMainMenu = function(menu, player, jukebox, key, jukeboxData, activeTrack, toggleQueueLockText)
	local jukeboxMainMenu = menu:getNew(menu)
	
	local jukeboxMainMenuOption = menu:addOptionOnTop(Jukebox.translation.jukeboxMainMenu)

	jukeboxMainMenuOption.iconTexture = Jukebox.getIcon("Main Menu")

	menu:addSubMenu(jukeboxMainMenuOption, jukeboxMainMenu)

    if #jukeboxData.playlist > 0 then
		-- wookieesWereHere is nonexistent; it is a nil label used to indicate unused variables in function calls.
		jukeboxMainMenu:addOption(Jukebox.translation.showCurrentTrack, wookieesWereHere,
			function()
				-- jukeboxData.playlistIndex = jukeboxData.playlistIndex or Jukebox.random(#jukeboxData.playlist)
				if Jukebox.getSoundFile(Jukebox.getCurrentTrack(jukeboxData)) then
					Jukebox.reportMessage(player, Jukebox.getCurrentTitle(jukeboxData) .. Jukebox.translation.isCurrentlyPlaying)
				else
					Jukebox.reportMessage(player, Jukebox.translation.cannotReadLoadedItem .. Jukebox.getCurrentTitle(jukeboxData) .. ".")
				end
			end
		).iconTexture = Jukebox.getIcon("Check Track")

        jukeboxMainMenu:addOption(Jukebox.translation.replayCurrentTrack, player,
            JukeboxMenus.process, jukebox, key, "Replay Current").iconTexture = Jukebox.getIcon("Replay Current")

        -- These options are meaningless without more than one song in the jukebox.
        if #jukeboxData.playlist > 1 then
            jukeboxMainMenu:addOption(Jukebox.translation.skipCurrentTrack, player, 
				JukeboxMenus.process, jukebox, key, "Skip Current").iconTexture = Jukebox.getIcon("Skip Current")

            jukeboxMainMenu:addOption(Jukebox.translation.replayLastTrack, player, 
				JukeboxMenus.process, jukebox, key, "Replay Last").iconTexture = Jukebox.getIcon("Replay Last")

            jukeboxMainMenu:addOption(Jukebox.translation.playRandomTrack, player, 
				JukeboxMenus.process, jukebox, key, "Random").iconTexture = Jukebox.getIcon("Random")

            jukeboxMainMenu:addOption(Jukebox.translation.shuffleLoadedTracks, player, 
				JukeboxMenus.process, jukebox, key, "Shuffle").iconTexture = Jukebox.getIcon("Shuffle")

			local toggleQueueIconTexture = (jukeboxData.queueLocked and Jukebox.getIcon("Unlock Queue")) or Jukebox.getIcon("Lock Queue")

            jukeboxMainMenu:addOption(toggleQueueLockText, player, 
				JukeboxMenus.process, jukebox, key, "Toggle Queue Lock").iconTexture = toggleQueueIconTexture
        end
    end

	if SandboxVars and SandboxVars.TrueMusicJukebox.allowPortableJukeboxKeys then
		if Jukebox.keyRing[key] then
			jukeboxMainMenu:addOption(Jukebox.translation.disablePortableJukeboxKey, key, Jukebox.removeJukeboxKey).iconTexture = Jukebox.getIcon("Disable Key")
		else
			jukeboxMainMenu:addOption(Jukebox.translation.enablePortableJukeboxKey, key, Jukebox.addJukeboxKey).iconTexture = Jukebox.getIcon("Enable Key")
		end
	end
end

JukeboxMenus.addJukeboxPlaylist = function(menu, player, jukebox, key, jukeboxData, activeTrack, portableAccessState)
	local playlistSize = #jukeboxData.playlist
	if playlistSize > 0 and jukeboxData.hasPlayableTracks then
        local firstIndex = (jukeboxData.playlistIndex - 24 == 0 and playlistSize) or (jukeboxData.playlistIndex - 24)
        local lastIndex = ((jukeboxData.playlistIndex + 24) % playlistSize) + 1

		if firstIndex < 0 then firstIndex = playlistSize + firstIndex end -- Because apparently modulo arithmetic does not work in Zomboid.

        -- Can   be   super   fucking   slow.
		if Jukebox.mod.options.hideTracklistFromContextMenu and not portableAccessState then return end

        if Jukebox.mod.options.showEveryTrackInJukeboxPlaylist or portableAccessState == "Unlimited" or #jukeboxData.playlist < 50 then
            firstIndex = 1
            lastIndex = playlistSize
		end

        -- Menu -> Track Menu
        local trackMenu = menu:getNew(menu)
		
		local trackMenuOption = menu:addOptionOnTop(Jukebox.translation.viewPlaylist)

		trackMenuOption.iconTexture = Jukebox.getIcon("Playlist")

        menu:addSubMenu(trackMenuOption, trackMenu)

        alreadyLoaded = {}
        
        local index = firstIndex

        while index ~= lastIndex do
            local trackType = jukeboxData.playlist[index]
            local trackDisplayName = jukeboxData.titles[trackType] or false
            if trackDisplayName and Jukebox.getSoundFile(trackType) and not alreadyLoaded[trackDisplayName] then
                alreadyLoaded[trackDisplayName] = true

                -- Track Menu -> Individual Track Play Menu
                local playMenu = trackMenu:getNew(trackMenu)

                playMenu:addOption(Jukebox.translation.playNow, player, 
					JukeboxMenus.process, jukebox, key, "Play Now", trackType).iconTexture = Jukebox.getIcon("Play Now")

                if activeTrack and #jukeboxData.playlist > 1 then						
                    playMenu:addOption(Jukebox.translation.playNext, player, 
						JukeboxMenus.process, jukebox, key, "Play Next", trackType).iconTexture = Jukebox.getIcon("Play Next")
                end

                if #jukeboxData.queue > 0 then						
                    playMenu:addOption(Jukebox.translation.playLast, player,
						JukeboxMenus.process, jukebox, key, "Play Last", trackType).iconTexture = Jukebox.getIcon("Play Last")
                end

                if jukeboxData.playlistIndex and jukeboxData.playlistIndex == index then
                    trackDisplayName = "{ " .. trackDisplayName .. " } ~ " .. Jukebox.translation.nowPlaying
                end

                trackMenu:addSubMenu(trackMenu:addOption(trackDisplayName), playMenu)
            end
            index = (index % #jukeboxData.playlist) + 1
        end
    end
end

JukeboxMenus.addJukeboxQueue = function(menu, player, jukebox, key, jukeboxData, activeTrack, toggleQueueLockText)
    if (activeTrack or #jukeboxData.queue > 0) and jukeboxData.hasPlayableTracks then
        -- Menu -> Queue Menu
        local queueMenu = menu:getNew(menu)
		
		local queueMenuOption = menu:addOptionOnTop(Jukebox.translation.viewQueue)

		queueMenuOption.iconTexture = jukeboxData.queueLocked and Jukebox.getIcon("Locked Queue") or Jukebox.getIcon("Queue")

        menu:addSubMenu(queueMenuOption, queueMenu)

        local nowPlaying = "{ " .. Jukebox.getCurrentTitle(jukeboxData) .. " } ~ " .. Jukebox.translation.nowPlaying

        local skipMenu = queueMenu:getNew(queueMenu)

        skipMenu:addOption(Jukebox.translation.skipCurrentTrack, player, 
			JukeboxMenus.process, jukebox, key, "Skip Current").iconTexture = Jukebox.getIcon("Skip Current")

        skipMenu:addOption(Jukebox.translation.replayCurrentTrack, player, 
			JukeboxMenus.process, jukebox, key, "Replay Current").iconTexture = Jukebox.getIcon("Replay Current")

        skipMenu:addOption(Jukebox.translation.replayLastTrack, player, 
			JukeboxMenus.process, jukebox, key, "Replay Last").iconTexture = Jukebox.getIcon("Replay Last")

		local toggleQueueIconTexture = (jukeboxData.queueLocked and Jukebox.getIcon("Unlock Queue")) or Jukebox.getIcon("Lock Queue")

        skipMenu:addOption(toggleQueueLockText, player, 
			JukeboxMenus.process, jukebox, key, "Toggle Queue Lock").iconTexture = toggleQueueIconTexture

        if Jukebox.getSoundFile(Jukebox.getCurrentTrack(jukeboxData)) then
            queueMenu:addSubMenu(queueMenu:addOption(nowPlaying), skipMenu)
        end

        local loopingIndex = (jukeboxData.queueIndex % #jukeboxData.queue) + 1
        
        -- Limit to showing 30 songs by default to avoid menu lag.
        local queuedRemaining = Jukebox.mod.options.showEveryTrackInJukeboxQueue and #jukeboxData.queue - 1 or math.min(#jukeboxData.queue - 1, 30)

        while queuedRemaining > 0 do
            local trackType = jukeboxData.queue[loopingIndex]
			
			local trackDisplayName = jukeboxData.titles[trackType]

			-- Track Menu -> Individual Track Play Menu
			local playMenu = queueMenu:getNew(queueMenu)

			playMenu:addOption(Jukebox.translation.playNow, player, 
				JukeboxMenus.process, jukebox, key, "Play Now", trackType).iconTexture = Jukebox.getIcon("Play Now")

			if activeTrack and #jukeboxData.playlist > 1 then						
				playMenu:addOption(Jukebox.translation.playNext, player,
					JukeboxMenus.process, jukebox, key, "Play Next", trackType).iconTexture = Jukebox.getIcon("Play Next")
			end

			if #jukeboxData.queue > 1 then						
				playMenu:addOption(Jukebox.translation.playLast, player, 
					JukeboxMenus.process, jukebox, key, "Play Last", trackType).iconTexture = Jukebox.getIcon("Play Last")
			end

			playMenu:addOption(Jukebox.translation.dequeue, player, 
				JukeboxMenus.process, jukebox, key, "Dequeue Track", trackType).iconTexture = Jukebox.getIcon("Dequeue")

			queueMenu:addSubMenu(queueMenu:addOption(trackDisplayName), playMenu)

            loopingIndex = (loopingIndex % #jukeboxData.queue) + 1

			queuedRemaining = queuedRemaining - 1
        end
    end
end

JukeboxMenus.renameKey = function(player, key)
	local screenWidth = getCore():getScreenWidth()
	local screenHeight = getCore():getScreenHeight()
	local width = math.max(660, math.floor((getTextManager():MeasureStringX(UIFont.Medium, Jukebox.translation.renameKeyBelow) + 50) / 100) * 100)
	local height = 3 * (getTextManager():getFontHeight(UIFont.Small) + 20) + 20
	local x = (screenWidth - width) / 2
	local y = (screenHeight - height) / 2
	local JukeboxRenamePanel = require("Jukebox/Rename")
	local modal = JukeboxRenamePanel:new(x, y, width, height, player, key)
	modal:initialise()
	modal:addToUIManager()
	setJoypadFocus(modal.playerIndex, modal)
end

JukeboxMenus.getMenuName = function(key)
	return tostring(Jukebox.keyRing[key]) or "No Name Stored"
end

JukeboxMenus.addKeyRingData = function(menu, player)

    if #Jukebox.keyRing > 0 then
        -- Menu -> Queue Menu
        local keyRingMenu = menu:getNew(menu)
		
		local keyRingMenuOption = menu:addOptionOnTop(Jukebox.translation.portableJukeboxKeys)

		keyRingMenuOption.iconTexture = Jukebox.getIcon("Main Menu")
		
        menu:addSubMenu(keyRingMenuOption, keyRingMenu)

		for index, key in ipairs(Jukebox.keyRing) do repeat
			local jukeboxData = Jukebox.activeLocations[key]

			if not jukeboxData then 
				Jukebox.removeJukeboxKey(key)
				break
			end

			local activeTrack = Jukebox.activeTracks[key]

			local keyMenu = keyRingMenu:getNew(keyRingMenu)

			keyMenu:addOptionOnTop(Jukebox.translation.renameJukebox, player, JukeboxMenus.renameKey, key).iconTexture = Jukebox.getIcon("Rename Jukebox")

			local jukebox = nil -- This menu doesn't pass the jukebox to the interact function.

			if not jukeboxData.on then
				keyMenu:addOptionOnTop(Jukebox.translation.turnOnJukebox, player, 
					JukeboxMenus.process, jukebox, key, "On").iconTexture = Jukebox.getIcon("On")
			else
				keyMenu:addOptionOnTop(Jukebox.translation.turnOffJukebox, player, 
					JukeboxMenus.process, jukebox, key, "Off").iconTexture = Jukebox.getIcon("Off")
		
				if (getCore():getDebug() or isAdmin()) then
					keyMenu:addOptionOnTop(Jukebox.translation.statusReport, player,
						JukeboxMenus.process, jukebox, key, "Status").iconTexture = Jukebox.getIcon("Check Status")
				end
		
				local playlistSize = #jukeboxData.playlist
		
				local toggleQueueLockText = (jukeboxData.queueLocked and Jukebox.translation.unlockQueue) or Jukebox.translation.lockQueue

				local portableAccessState = Jukebox.mod.options.showEveryTrackInPortablePlaylist and "Unlimited" or "Limited"
				
				-- Order intended to maximize convenience to world context menu users.
		
				JukeboxMenus.addJukeboxQueue(keyMenu, player, jukebox, key, jukeboxData, activeTrack, toggleQueueLockText)
		
				JukeboxMenus.addJukeboxPlaylist(keyMenu, player, jukebox, key, jukeboxData, activeTrack, portableAccessState)
		
				JukeboxMenus.addJukeboxVolume(keyMenu, player, jukebox, key, jukeboxData)
		
				JukeboxMenus.addJukeboxMainMenu(keyMenu, player, jukebox, key, jukeboxData, activeTrack, toggleQueueLockText)
				
			end

			keyRingMenu:addSubMenu(keyRingMenu:addOption(JukeboxMenus.getMenuName(key)), keyMenu)
			
		until true end

	end

end

-------------------------------------------------------------------

JukeboxMenus.load = function(playerIndex, menu, worldObjects)

	if #worldObjects == 0 then return end
	
	local object = worldObjects[1]

	local square = object:getSquare()

	local player = getSpecificPlayer(playerIndex)

	if Jukebox.getJoypadData(playerIndex) then
		local direction = player:getForwardDirection()
		local x = player:getX() + direction:getX()
		local y = player:getY() + direction:getY()
		square = getSquare(x, y, player:getZ())
	end
	
	local jukebox = Jukebox.getEvolvedJukebox(square)

	if not (jukebox and jukebox:getContainer()) then return end

	local key = Jukebox.squareToKey(square)
	
	local activeTrack = Jukebox.activeTracks[key]

	local jukeboxData = Jukebox.activeLocations[key]

	jukeboxData.player = {
		x = math.floor(player:getX()),
		y = math.floor(player:getY()),
		z = math.floor(player:getZ())
	}

	Jukebox.initializePlaylist(jukebox, jukeboxData)

	if not jukeboxData.on then
		menu:addOptionOnTop(Jukebox.translation.turnOnJukebox, player, 
			JukeboxMenus.process, jukebox, key, "On").iconTexture = Jukebox.getIcon("On")
	else
		menu:addOptionOnTop(Jukebox.translation.turnOffJukebox, player, 
			JukeboxMenus.process, jukebox, key, "Off").iconTexture = Jukebox.getIcon("Off")

		if (getCore():getDebug() or isAdmin()) then
			menu:addOptionOnTop(Jukebox.translation.statusReport, player,
				JukeboxMenus.process, jukebox, key, "Status").iconTexture = Jukebox.getIcon("Check Status")
		end

		local playlistSize = #jukeboxData.playlist

		local toggleQueueLockText = (jukeboxData.queueLocked and Jukebox.translation.unlockQueue) or Jukebox.translation.lockQueue
		
        -- Order intended to maximize convenience to world context menu users.

		JukeboxMenus.addJukeboxQueue(menu, player, jukebox, key, jukeboxData, activeTrack, toggleQueueLockText)

		JukeboxMenus.addJukeboxPlaylist(menu, player, jukebox, key, jukeboxData, activeTrack)

		JukeboxMenus.addJukeboxVolume(menu, player, jukebox, key, jukeboxData)

		JukeboxMenus.addJukeboxMainMenu(menu, player, jukebox, key, jukeboxData, activeTrack, toggleQueueLockText)
		
	end
end

Events.OnPreFillWorldObjectContextMenu.Add(JukeboxMenus.load)

---------------------------------------------------------------------

Jukebox.reportUnpowered = function(player)
	Jukebox.reportMessage(player, Jukebox.translation.willNeedGenerator)
end

Jukebox.reportEmpty = function(player)
	Jukebox.reportMessage(player, Jukebox.translation.noMusicInJukebox)
end

Jukebox.adjustVolume = function(player, jukeboxData, volumeDisplayed)
	jukeboxData.volume = Jukebox.volumes[volumeDisplayed]
end

Jukebox.printStatus = function(player, jukeboxData)
	print("current jukebox status")
	print("x = " .. jukeboxData.x)
	print("y = " .. jukeboxData.y)
	print("z = " .. jukeboxData.z)

	print("On, Volume?")
	print(jukeboxData.on)
	print(jukeboxData.volume)

	print("Playlist 1, 2, 3?")
	print(jukeboxData.playlist[1])
	print(jukeboxData.playlist[2])
	print(jukeboxData.playlist[3])
end

JukeboxMenus.getFrontSquare = function(square, facing)
	local value = nil

	if facing == "S" then
		value = square:getS()
	elseif facing == "E" then
		value = square:getE()
	elseif facing == "W" then
		value = square:getW()
	elseif facing == "N" then
		value = square:getN()
	end

	return value
end

JukeboxMenus.getFacing = function(properties, square)
	local facing = nil

	if properties:Is("Facing") then
		facing = properties:Val("Facing")
	end

	if square:getE() and facing == "E" then
		facing = "E"
	elseif square:getS() and facing == "S" then
		facing = "S"
	elseif square:getW() and facing == "W" then
		facing = "W"
	elseif square:getN() and facing == "N" then
		facing = "N"
	else
		facing = nil
	end

	return facing
end

JukeboxMenus.process = function(player, jukebox, key, musicChoice, selectedTrack)
	if jukebox and jukebox:getContainer() then
		JukeboxMenus.go(player, jukebox, key, musicChoice, selectedTrack)
	else
		JukeboxMenus.interact(player, jukebox, key, musicChoice, selectedTrack)
	end
end

JukeboxMenus.go = function(player, jukebox, key, musicChoice, selectedTrack)
	local jukeboxSquare = jukebox:getSquare()

	local adjacent = AdjacentFreeTileFinder.Find(jukeboxSquare, player)

	if adjacent ~= nil then
		local action = ISWalkToTimedAction:new(player, adjacent)
		
		action.player = player
		action.jukebox = jukebox
		action.key = key
		action.musicChoice = musicChoice
		action.selectedTrack = selectedTrack
		
		action.first = action.update
		
		action.update = function(self)
			self:first()

			if self.result == BehaviorResult.Failed then return end

			local distance = Jukebox.getDistanceToPlayer(Jukebox.activeLocations[key], self.character)

			if distance <= 2 then
				self.result = BehaviorResult.Succeeded

				JukeboxMenus.interact(self.player, self.jukebox, self.key, self.musicChoice, self.selectedTrack)

				self:forceComplete()
			end
		end
		
		ISTimedActionQueue.add(action)

		player:faceLocation(jukeboxSquare:getX(), jukeboxSquare:getY())
	else
		Jukebox.reportMessage(player, Jukebox.translation.unreachableJukebox)
	end
end

JukeboxMenus.interact = function(player, jukebox, key, musicChoice, selectedTrack)
	local jukeboxData = Jukebox.activeLocations[key]
	
	local square = getSquare(jukeboxData.x, jukeboxData.y, jukeboxData.z)

	if not jukeboxData.key then jukeboxData.key = key end -- Upgrade old jukes with keys.

	if Jukebox.activeTracks[key] and Jukebox.activeTracks[key].elapsed < 10 then 
		Jukebox.reportMessage(player, Jukebox.translation.movingTooFast)
		return
	end
	
	local playlist = jukeboxData.playlist


	jukeboxData.player = {
		x = math.floor(player:getX()),
		y = math.floor(player:getY()),
		z = math.floor(player:getZ())
	}

	local powerProblems = square and not ((SandboxVars.AllowExteriorGenerator and square:haveElectricity()) or (SandboxVars.ElecShutModifier > -1 
						  and GameTime:getInstance():getNightsSurvived() < SandboxVars.ElecShutModifier and square:isOutside() == false))

	if musicChoice == "Status" then
		Jukebox.printStatus(player, jukeboxData)
		return
	elseif musicChoice == "Off" then
		if square then square:playSound("LightSwitch") end

		sendClientCommand("TrueMusicJukebox", "sync", {key = key, on = false})

		return
	end

	if powerProblems then
		if square then square:playSound("LightSwitch") end

		Jukebox.reportUnpowered(player)
		
		sendClientCommand("TrueMusicJukebox", "sync", {key = key, on = false})
		
		return
	elseif musicChoice == "On" then -- NOW we're done
		if square then square:playSound("LightSwitch") end

		local size = #jukeboxData.queue > 0 and #jukeboxData.queue or #jukeboxData.playlist
		local index = Jukebox.random(size) -- playlist or queue index.

		if selectedTrack then
			index = Jukebox.getIndex(jukeboxData, selectedTrack)
		end

		local indexType = #jukeboxData.queue > 0 and "queueIndex" or "playlistIndex"

		sendClientCommand("TrueMusicJukebox", "sync", {key = key, on = true, [indexType] = index})
		return
	end

	if jukebox and not Jukebox.initializePlaylist(jukebox, jukeboxData) then 
		Jukebox.reportEmpty(player)
		return
	end

	if type(musicChoice) == "number" then		
		sendClientCommand("TrueMusicJukebox", "sync", {key = key, volume = Jukebox.volumes[musicChoice]})
		return
	end

	local selectedTitle = jukeboxData.titles[selectedTrack]

	local priorIndex = Jukebox.getPriorTrack(jukeboxData)
	local currentIndex = Jukebox.getIndex(jukeboxData)
	local nextIndex = Jukebox.getNextIndex(jukeboxData)

	local priorTrack = Jukebox.getPriorTrack(jukeboxData)
	local currentTrack = Jukebox.getCurrentTrack(jukeboxData)
	local nextTrack = Jukebox.getNextTrack(jukeboxData)

	local priorTitle = Jukebox.getPriorTitle(jukeboxData)
	local currentTitle = Jukebox.getCurrentTitle(jukeboxData)
	local nextTitle = Jukebox.getNextTitle(jukeboxData)

	local playNow = musicChoice == "Play Now"
	local playNext = musicChoice == "Play Next"
	local playLast = musicChoice == "Play Last"

	if (playNow and Jukebox.getCurrentTrack(jukeboxData) == selectedTrack) then
		playNow = false
		musicChoice = "Replay Current"
	end

	if musicChoice == "Replay Current" then
		if (Jukebox.getSoundFile(currentTrack)) then	
			Jukebox.reportMessage(player, Jukebox.translation.restarting .. currentTitle .. ".")
		end

		-- Just tells this key to change nothing and play the current song now on all clients.
		sendClientCommand("TrueMusicJukebox", "sync", {key = key, afterSync = "skip"})
		
		return
	elseif musicChoice == "Replay Last" then				
		if (Jukebox.getSoundFile(priorTrack)) then	
			Jukebox.reportMessage(player, Jukebox.translation.playing .. priorTitle .. ".")
		end

		sendClientCommand("TrueMusicJukebox", "sync", {key = key, decreaseIndex = true, targetIndex = priorIndex, afterSync = "skip"})

		return
	elseif musicChoice == "Skip Current" then
		if #jukeboxData.queue == 1 and not jukeboxData.queueLocked then -- Next song falls outside queue. Feedback should reflect this.
			nextTrack = jukeboxData.playlist[jukeboxData.playlistIndex]
			nextTitle = jukeboxData.titles[nextTrack]
		end

		if Jukebox.getSoundFile(nextTrack) then	
			Jukebox.reportMessage(player, Jukebox.translation.skippedPriorSong .. nextTitle .. ".")
		end
		
		sendClientCommand("TrueMusicJukebox", "sync", {key = key, increaseIndex = true, targetIndex = nextIndex, afterSync = "skip"})
		
		return
	elseif musicChoice == "Toggle Queue Lock" then
		jukeboxData.queueLocked = not jukeboxData.queueLocked
		sendClientCommand("TrueMusicJukebox", "sync", {key = key, queueLocked = jukeboxData.queueLocked})
		
		if jukeboxData.queueLocked then
			Jukebox.reportMessage(player, Jukebox.translation.queueLocked)
			Jukebox.reportMessage(player, Jukebox.translation.songsNoLongerRemovedAutomatically)
			-- Jukebox.reportMessage(player, Jukebox.translation.shuffleToClearQueue)
		else
			Jukebox.reportMessage(player, Jukebox.translation.queueUnlocked)
			Jukebox.reportMessage(player, Jukebox.translation.songsRemovedAutomatically)
			Jukebox.reportMessage(player, Jukebox.translation.shuffleToClearQueue)
		end

		return
	elseif musicChoice == "Dequeue Track" then
		sendClientCommand("TrueMusicJukebox", "sync", {key = key, dequeue = selectedTrack})
		
		Jukebox.dequeueTrack(jukeboxData, selectedTrack)

		Jukebox.reportMessage(player, jukeboxData.titles[selectedTrack] .. Jukebox.translation.removedFromQueue)

		return
	elseif musicChoice == "Random" then
		-- New nextTrack now.
		local randomIndex = Jukebox.random(#jukeboxData.queue > 0 and #jukeboxData.queue or #jukeboxData.playlist)

		local randomTrack = #jukeboxData.queue > 0 and jukeboxData.queue[randomIndex] or jukeboxData.playlist[randomIndex]

		if (Jukebox.getSoundFile(randomTrack)) then	
			Jukebox.reportMessage(player, Jukebox.translation.randomlySelected .. jukeboxData.titles[randomTrack] .. ". " .. Jukebox.translation.trackWillPlayNow)
		end

		local tracklistIndex = #jukeboxData.queue > 0 and "queueIndex" or "playlistIndex"

		-- Set relevant index and play it immediately on all clients.
		sendClientCommand("TrueMusicJukebox", "sync", {key = key, [tracklistIndex] = randomIndex, afterSync = "skip"})
		
		return
	elseif musicChoice == "Shuffle" then
		jukeboxData.triggeredShufflePersonally = true

		local length = #jukeboxData.playlist

		if length < 2 then return end -- Something seriously borked. Shuffle shouldn't have been available. How to shuffle 1 track?

		local quarter = math.floor(length / 4)

		local half = math.floor(length / 2)

		local startIndex = Jukebox.random(length - 1) + 1 -- Will never leave first track in position 1.
		
		-- Base jump size will be somewhere between 125% and 175% of length. Minimum 2 to guarantee randomness here.
		local shuffleJump = length + quarter + Jukebox.random(math.max(2, half)) 

		local packet = {key = key, priorTrack = priorTrack, nextTrack = nextTrack, startIndex = startIndex, shuffleJump = shuffleJump, afterSync = "shuffle"}

		Jukebox.shuffle(jukeboxData, packet)

		local nextTitleAfterShuffle = Jukebox.getNextTitle(jukeboxData)

		Jukebox.reportMessage(player, Jukebox.translation.allTracksShuffled)
		
		Jukebox.reportMessage(player, "" .. nextTitleAfterShuffle .. Jukebox.translation.willPlay .. Jukebox.translation.next)

		sendClientCommand("TrueMusicJukebox", "sync", packet)

		return
	elseif playLast then
		local lastQueueIndex = jukeboxData.queueIndex -- We'll be inserting here and moving the current index.

		sendClientCommand("TrueMusicJukebox", "sync", {key = key, enqueue = selectedTrack, enqueueIndex = lastQueueIndex, increaseIndex = true})

		if Jukebox.getSoundFile(selectedTrack) then
			Jukebox.reportMessage(player, jukeboxData.titles[selectedTrack] .. Jukebox.translation.willPlayLast)
		end

		return
	elseif playNext then
		local alreadyEnqueued = false
		local queueIndex = jukeboxData.queueIndex
		local nextQueueIndex = jukeboxData.queueIndex + 1 -- We'll be inserting here and retaining the current index.
		
		if queueIndex == 0 then -- Queue was naturally emptied before this request.
			queueIndex = 1
			nextQueueIndex = nextQueueIndex + 1
			-- We also move the playlist index to the next some when we begin queueing things so that we exit the queue into a new song.
			local newPlaylistIndex = (jukeboxData.playlistIndex % #jukeboxData.playlist) + 1
			sendClientCommand("TrueMusicJukebox", "sync", {key = key, queueIndex = queueIndex, playlistIndex = newPlaylistIndex, enqueue = currentTrack, enqueueIndex = queueIndex})

			alreadyEnqueued = currentTrack == selectedTrack
		end

		if not alreadyEnqueued then -- pulling this out right before adding it will force a queue shift
			sendClientCommand("TrueMusicJukebox", "sync", {key = key, enqueue = selectedTrack, enqueueIndex = nextQueueIndex})
		end
		
		if Jukebox.getSoundFile(selectedTrack) then
			Jukebox.reportMessage(player, "" .. jukeboxData.titles[selectedTrack] .. Jukebox.translation.willPlay .. Jukebox.translation.next)
		end

		return
	elseif playNow then
		if #jukeboxData.queue > 0 then
			local selectedQueueIndex = jukeboxData.queueIndex + 1
			sendClientCommand("TrueMusicJukebox", "sync", {key = key, enqueue = selectedTrack, enqueueIndex = selectedQueueIndex, increaseIndex = true, afterSync = "skip"})
		else
			local newPlaylistIndex = Jukebox.getPlaylistIndex(jukeboxData, selectedTrack)
			sendClientCommand("TrueMusicJukebox", "sync", {key = key, playlistIndex = newPlaylistIndex, afterSync = "skip"})
		end

		if Jukebox.getSoundFile(selectedTrack) then
			Jukebox.reportMessage(player, "" .. selectedTitle .. Jukebox.translation.willPlay .. Jukebox.translation.now)
		end
	end
end

return JukeboxMenus
