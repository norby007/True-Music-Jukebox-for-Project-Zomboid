if isServer() then return end

require "Jukebox/Sound"
require "Jukebox/Objects"
require "Jukebox/Utility"

--

JukeboxMenus = {};

JukeboxMenus.doBuildMenus = function(playerIndex, menu, worldObjects)

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

	local jukeboxData = jukebox:getModData()

	jukeboxData.x = jukebox:getX()
	jukeboxData.y = jukebox:getY()
	jukeboxData.z = jukebox:getZ()

	-- Log time of this command.
	jukeboxData.tick = Jukebox.getTime()

	Jukebox.initializePlaylist(jukebox)

	local key = Jukebox.locationToKey(jukeboxData)

	-- wookieesWereHere is nonexistent; it is a nil label used to indicate unused variables in function calls.
	if not jukeboxData.on then
		menu:addOptionOnTop(Jukebox.translation.turnOnJukebox, wookieesWereHere, JukeboxMenus.onUseJukebox,
			player, jukebox, "On")
	else
		menu:addOptionOnTop(Jukebox.translation.turnOffJukebox, wookieesWereHere, JukeboxMenus.onUseJukebox,
			player, jukebox, "Off")

		if (getCore():getDebug() or isAdmin()) then
			menu:addOption(Jukebox.translation.statusReport, wookieesWereHere, JukeboxMenus.onUseJukebox, 
				player, jukebox, "Status")
		end

		local playlistSize = #jukeboxData.playlist

		local toggleQueueLockText = (jukeboxData.queueLocked and Jukebox.translation.unlockQueue) or Jukebox.translation.lockQueue
		
		repeat
			if playlistSize > 0 and jukeboxData.hasPlayableTracks then
				-- Menu -> Queue Menu
				local queueMenu = menu:getNew(menu)
				menu:addSubMenu(menu:addOptionOnTop(Jukebox.translation.viewQueue), queueMenu)

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

				if jukeboxData.queueSize > 0 then
					local loopingIndex = (jukeboxData.currentIndex % #jukeboxData.playlist) + 1
					
					-- Limit to showing 30 songs by default to avoid menu lag.
					local queuedRemaining = Jukebox.mod.options.showEveryTrackUsingContextMenu and jukeboxData.queueSize or 30

					local alreadyLoaded = {}

					while queuedRemaining > 0 and loopingIndex ~= jukeboxData.currentIndex and jukeboxData.currentIndex do
						local trackType = jukeboxData.playlist[loopingIndex]
						if jukeboxData.queue[trackType] and not alreadyLoaded[trackType] then
							alreadyLoaded[trackType] = true
							local trackDisplayName = jukeboxData.titles[trackType] or false
							
							queuedRemaining = queuedRemaining - 1

							-- Track Menu -> Individual Track Play Menu
							local playMenu = queueMenu:getNew(queueMenu)

							playMenu:addOption(Jukebox.translation.playNow, wookieesWereHere, 
								function() 
									JukeboxMenus.onUseJukebox(wookieesWereHere, player, jukebox, "Play Now", trackType)
								end
							)

							if Jukebox.activeTracks[key] then						
								playMenu:addOption(Jukebox.translation.playNext, wookieesWereHere, 
									function()
										JukeboxMenus.onUseJukebox(wookieesWereHere, player, jukebox, "Play Next", trackType)
									end
								)
							end

							if jukeboxData.queueSize > 0 then						
								playMenu:addOption(Jukebox.translation.playLast, wookieesWereHere, 
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

				local firstIndex = (jukeboxData.currentIndex - 25 == 0 and playlistSize) or (jukeboxData.currentIndex - 25 % playlistSize)
				local lastIndex = ((jukeboxData.currentIndex + 25) % playlistSize) + 1

				-- Can   be   super   fucking   slow.
				if Jukebox.mod.options.showEveryTrackUsingContextMenu then
					firstIndex = 1
					lastIndex = playlistSize
				end
				
				if Jukebox.mod.options.hideTracklistFromContextMenu then break end
				-- Menu -> Track Menu
				local trackMenu = menu:getNew(menu)
				menu:addSubMenu(menu:addOptionOnTop(Jukebox.translation.playSpecificTrack), trackMenu)

				alreadyLoaded = {}
				
				local index = firstIndex

				while index ~= lastIndex do
					local trackType = jukeboxData.playlist[index]
					local trackDisplayName = jukeboxData.titles[trackType] or false
					if trackDisplayName and Jukebox.getSoundFile(trackType) and not alreadyLoaded[trackDisplayName] then
						alreadyLoaded[trackDisplayName] = true

						-- Track Menu -> Individual Track Play Menu
						local playMenu = trackMenu:getNew(trackMenu)

						playMenu:addOption(Jukebox.translation.playNow, wookieesWereHere, 
							function() 
								JukeboxMenus.onUseJukebox(wookieesWereHere, player, jukebox, "Play Now", trackType)
							end
						)

						if Jukebox.activeTracks[key] then						
							playMenu:addOption(Jukebox.translation.playNext, wookieesWereHere, 
								function()
									JukeboxMenus.onUseJukebox(wookieesWereHere, player, jukebox, "Play Next", trackType)
								end
							)
						end

						if jukeboxData.queueSize > 0 then						
							playMenu:addOption(Jukebox.translation.playLast, wookieesWereHere, 
								function() 
									JukeboxMenus.onUseJukebox(wookieesWereHere, player, jukebox, "Play Last", trackType)
								end
							)
						end

						if jukeboxData.currentIndex and jukeboxData.currentIndex == index then
							trackDisplayName = "{ " .. trackDisplayName .. " } ~ " .. Jukebox.translation.nowPlaying
						end

						trackMenu:addSubMenu(trackMenu:addOption(trackDisplayName), playMenu)
					end
					index = (index % #jukeboxData.playlist) + 1
				end
			end
		until true

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

		-- These options are meaningless with no tracks in the jukebox.
		if #jukeboxData.playlist > 0 then

			local jukeboxMainMenu = menu:getNew(menu)

			menu:addSubMenu(menu:addOptionOnTop(Jukebox.translation.jukeboxMainMenu), jukeboxMainMenu)
		
			-- If already active, this function is pointless.
			if not Jukebox.activeTracks[key] then
				jukeboxMainMenu:addOption(Jukebox.translation.playLoadedTracks, wookieesWereHere, JukeboxMenus.onUseJukebox,
					player,	jukebox, "All")
			end

			-- These options are meaningless without songs in the jukebox.
			if #jukeboxData.playlist < 1 then return end

			-- These options are meaningless without more than one song in the jukebox.
			if #jukeboxData.playlist > 1 then
				jukeboxMainMenu:addOption(Jukebox.translation.skipCurrentTrack, wookieesWereHere, JukeboxMenus.onUseJukebox,
					player, jukebox, "Skip Current")
			end

			jukeboxMainMenu:addOption(Jukebox.translation.replayCurrentTrack, wookieesWereHere, JukeboxMenus.onUseJukebox,
				player,	jukebox, "Replay Current")

			-- These options are meaningless without more than one song in the jukebox.
			if #jukeboxData.playlist > 1 then
				jukeboxMainMenu:addOption(Jukebox.translation.replayLastTrack, wookieesWereHere, JukeboxMenus.onUseJukebox,
					player,	jukebox, "Replay Last")

				jukeboxMainMenu:addOption(Jukebox.translation.playRandomTrack, wookieesWereHere, JukeboxMenus.onUseJukebox,
					player,	jukebox, "Random")

				jukeboxMainMenu:addOption(Jukebox.translation.shuffleLoadedTracks, wookieesWereHere, JukeboxMenus.onUseJukebox,	
					player,	jukebox, "Shuffle")

				jukeboxMainMenu:addOption(toggleQueueLockText, wookieesWereHere, JukeboxMenus.onUseJukebox,
					player,	jukebox, "Toggle Queue Lock")
			end

			jukeboxMainMenu:addOption(Jukebox.translation.showCurrentTrack, wookieesWereHere,
				function()
					jukeboxData.currentIndex = jukeboxData.currentIndex or Jukebox.random(#jukeboxData.playlist)
	
					if Jukebox.getSoundFile(Jukebox.getCurrentTrack(jukeboxData)) then
						Jukebox.reportMessage(player, Jukebox.getCurrentTitle(jukeboxData) .. " is currently playing.")
					else
						Jukebox.reportMessage(player, Jukebox.translation.cannotReadLoadedItem .. Jukebox.getCurrentTitle(jukeboxData) .. ".")
					end
				end
			)
		
		end
	end
end

Jukebox.reportUnpowered = function(player)
	Jukebox.reportMessage(player, Jukebox.translation.willNeedGenerator)
end

Jukebox.reportEmpty = function(player)
	Jukebox.reportMessage(player, Jukebox.translation.noMusicInJukebox)
end

Jukebox.adjustVolume = function(player, jukebox, volume)
	jukebox:getModData().volume = Jukebox.volumes[volume]
	jukebox:transmitModData()
end

Jukebox.printStatus = function(player, jukebox)
	print("current jukebox status")
	print("x = " .. jukebox:getX())
	print("y = " .. jukebox:getY())
	print("z = " .. jukebox:getZ())

	print("On, Volume, Playing, Skip?")
	print(jukebox:getModData().on)
	print(jukebox:getModData().skip)
	print(jukebox:getModData().volume)

	print("Playlist 1, 2, 3?")
	print(jukebox:getModData().playlist[1])
	print(jukebox:getModData().playlist[2])
	print(jukebox:getModData().playlist[3])
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

JukeboxMenus.walkToFront = function(player, jukebox)
	local spriteName = jukebox:getSprite():getName()
	if not spriteName then
		return false
	end

	local properties = jukebox:getSprite():getProperties()
	local facing = JukeboxMenus.getFacing(properties, jukebox:getSquare())
	if facing == nil then
		Jukebox.reportMessage(player, Jukebox.translation.unreachableJukebox)
		return false
	end

	local frontSquare = JukeboxMenus.getFrontSquare(jukebox:getSquare(), facing)
	local turn = JukeboxMenus.getFrontSquare(frontSquare, facing)

	if not frontSquare then
		return false
	end

	local jukeboxSquare = jukebox:getSquare()
	
	if AdjacentFreeTileFinder.privTrySquare(jukeboxSquare, frontSquare) then
		ISTimedActionQueue.add(ISWalkToTimedAction:new(player, frontSquare))
		if turn then
			player:faceLocation(jukeboxSquare:getX(), jukeboxSquare:getY())
		end
		return true
	end
	
	return false
end

-- worldObjects below is not necessary, but the vanilla game wants to send a variable there in the
-- functions used for building menu options. Since it is a waste of memory to pass it unused data,
-- wookieesWereHere (a nil label) is always passed to this function instead.
JukeboxMenus.onUseJukebox = function(worldObjects, player, jukebox, musicChoice, trackType)
	
	if (not JukeboxMenus.walkToFront(player, jukebox) and jukebox:getContainer()) then return end

	local square = jukebox:getSquare()

	local jukeboxData = jukebox:getModData()
	
	-- Log time of this command.
	
	if jukeboxData.tick then
		local hoursPerDay = 24

		local currentTime = Jukebox.getTime()
		
		local currentTick = (currentTime >= jukeboxData.tick) and currentTime or (hoursPerDay + currentTime)

		if (currentTick - jukeboxData.tick) < Jukebox.oneRealHalfSecond then
			return print("Command sent too quickly after another. Most likely a duplicate command.")
		end
	end

	jukeboxData.tick = Jukebox.getTime()
	
	local playlist = jukeboxData.playlist

	-- Ensure that if this jukebox attempts to play a song, index will be a positive integer from 1 to #playlist.
	-- currentIndex may be automatically set to 0 during dequeue process, but will not attempt to play on index 0
	-- due to #playlist == 0.
	jukeboxData.currentIndex = jukeboxData.currentIndex and math.max(math.min(jukeboxData.currentIndex, #playlist), 1) or 1

	jukeboxData.x = jukebox:getX() 
	jukeboxData.y = jukebox:getY()
	jukeboxData.z = jukebox:getZ()

	local powerProblems = not ((SandboxVars.AllowExteriorGenerator and square:haveElectricity()) or (SandboxVars.ElecShutModifier > -1 
						  and GameTime:getInstance():getNightsSurvived() < SandboxVars.ElecShutModifier and square:isOutside() == false))

	if musicChoice == "Status" then
		Jukebox.printStatus(player, jukebox)
		return
	elseif musicChoice == "Off" then
		square:playSound("LightSwitch")
		jukeboxData.on = false

		if jukeboxData.queueSize > 0 then
			-- Let's go ahead and enqueue this as we turn off the jukebox so that it
			-- will play again when we turn it back on.
			Jukebox.enqueueTrack(jukeboxData, Jukebox.getCurrentTrack(jukeboxData))
		end

		jukebox:transmitModData()
		return
	end

	if powerProblems then
		Jukebox.reportUnpowered(player)
		square:playSound("LightSwitch")
		jukeboxData.on = false
		jukebox:transmitModData()
		return
	elseif musicChoice == "On" then -- NOW we're done
		square:playSound("LightSwitch")
		jukeboxData.on = true
		jukebox:transmitModData()

		if #jukeboxData.playlist < 1 then return end
		-- Used for delayed playing of the last jukebox activated by the player.
		Jukebox.latest = {
			player = player,
			jukebox = jukebox,
			musicChoice = "Play Now",
			trackType = Jukebox.getCurrentTrack(jukeboxData)
		}

		if Jukebox.latest.trackType and Jukebox.getSoundFile(Jukebox.latest.trackType) then
			Events.OnTick.Add(Jukebox.playLater)
		end

		return
	end

	if not Jukebox.initializePlaylist(jukebox) then 
		Jukebox.reportEmpty(player)
		return
	end

	if type(musicChoice) == "number" then
		Jukebox.adjustVolume(player, jukebox, musicChoice)
		return
	end

	local priorTrack = Jukebox.getPriorTrack(jukeboxData)
	local currentTrack = Jukebox.getCurrentTrack(jukeboxData)
	local nextTrack = Jukebox.getNextTrack(jukeboxData)

	local priorTitle = Jukebox.getPriorTitle(jukeboxData)
	local currentTitle = Jukebox.getCurrentTitle(jukeboxData)

	local playNow = musicChoice == "Play Now"
	local playNext = musicChoice == "Play Next"
	local playLast = musicChoice == "Play Last"

	local key = Jukebox.locationToKey(jukeboxData)

	if musicChoice == "Replay Current" then
		if (Jukebox.getSoundFile(currentTrack)) then	
			Jukebox.reportMessage(player, Jukebox.translation.restarting .. currentTitle .. ".")
		end
	
		-- Must enqueue to avoid skipping to the next queued track.
		Jukebox.enqueueTrack(jukeboxData, Jukebox.getCurrentTrack(jukeboxData))

		Jukebox.skipCurrentTrack(jukebox) 

		return
	elseif musicChoice == "Replay Last" then
		if (Jukebox.getSoundFile(priorTrack)) then	
			Jukebox.reportMessage(player, Jukebox.translation.playing .. priorTitle .. ".")
		end
		
		-- Must enqueue to avoid skipping to the next queued track.
		Jukebox.enqueueTrack(jukeboxData, Jukebox.getPriorTrack(jukeboxData))
		
		-- Requeue the current track to keep it in the list of songs that will play next in queue.
		Jukebox.enqueueTrack(jukeboxData, Jukebox.getCurrentTrack(jukeboxData))

		jukeboxData.currentIndex = Jukebox.getPriorIndex(jukeboxData)

		Jukebox.skipCurrentTrack(jukebox) -- transmits mod data

		return
	elseif musicChoice == "Skip Current" then

		if jukeboxData.queueSize > 0 and not jukeboxData.queue[Jukebox.getNextTrack(jukeboxData)] then
			local nextInQueue = Jukebox.seekNextQueuedIndex(jukeboxData)
	
			if nextInQueue then
				jukeboxData.currentIndex = nextInQueue
			end
		else
			jukeboxData.currentIndex = Jukebox.getNextIndex(jukeboxData)
		end

		local nextTitle = Jukebox.getCurrentTitle(jukeboxData)
		
		local nextTrack = Jukebox.getCurrentTrack(jukeboxData)

		if Jukebox.getSoundFile(nextTrack) then	
			Jukebox.reportMessage(player, Jukebox.translation.skippedPriorSong .. nextTitle .. ".")
		end

		Jukebox.skipCurrentTrack(jukebox)
		
		jukebox:transmitModData()

		return
	elseif musicChoice == "Toggle Queue Lock" then
		jukeboxData.queueLocked = not jukeboxData.queueLocked
		jukebox:transmitModData()

		if jukeboxData.queueLocked then
			Jukebox.reportMessage(player, Jukebox.translation.queueLocked)
			Jukebox.reportMessage(player, Jukebox.translation.songsNoLongerRemovedAutomatically)
			Jukebox.reportMessage(player, Jukebox.translation.shuffleToClearQueue)
		else
			Jukebox.reportMessage(player, Jukebox.translation.queueUnlocked)
			Jukebox.reportMessage(player, Jukebox.translation.songsRemovedAutomatically)
			Jukebox.reportMessage(player, Jukebox.translation.shuffleToClearQueue)
		end

		return
	elseif musicChoice == "Dequeue Track" then		
		Jukebox.removeTrack(jukebox, trackType)
	
		-- Must do this after the dequeue adjusts the playlist's index.
		local nextIndex = Jukebox.getNextIndex(jukeboxData)

		local possibleNext = (nextIndex + jukeboxData.queueSize) % #playlist
		nextIndex = (possibleNext == 0 and #playlist) or possibleNext

		Jukebox.insertTrack(jukebox, trackType, nil, nextIndex)

		jukebox:transmitModData()

		Jukebox.reportMessage(player, jukeboxData.titles[trackType] .. Jukebox.translation.removedFromQueue)

		return
	elseif musicChoice == "Random" then
		Jukebox.clearQueue(jukebox)

		jukeboxData.currentIndex = Jukebox.random(#playlist)
		-- New nextTrack now.
		currentTrack = Jukebox.getCurrentTrack(jukeboxData)

		if (Jukebox.getSoundFile(currentTrack)) then	
			Jukebox.reportMessage(player, Jukebox.translation.randomlySelected .. Jukebox.getCurrentTitle(jukeboxData) .. ". " .. Jukebox.translation.trackWillPlayNow)
		end

		Jukebox.skipCurrentTrack(jukebox)
	elseif musicChoice == "Shuffle" then
		Jukebox.clearQueue(jukebox)
		Jukebox.shuffle(jukebox)

		local nextTrack = Jukebox.getNextTrack(jukeboxData)

		if (Jukebox.getSoundFile(nextTrack)) then	
			Jukebox.reportMessage(player, Jukebox.translation.allTracksShuffled)
		end
	elseif (playNow or playNext or playLast) and (#playlist > 1) then
		BS = BS or {}
		BS.jukebox = jukebox
		BS.jukeboxData = jukebox:getModData()
		BS.jukeboxPlaylist = jukebox:getModData().playlist

		Jukebox.removeTrack(jukebox, trackType)
	
		-- Must do this after the dequeue adjusts the playlist's index.
		local nextIndex = Jukebox.getNextIndex(jukeboxData)

		if playLast then
			local possibleNext = (nextIndex + jukeboxData.queueSize) % #playlist
			nextIndex = (possibleNext == 0 and #playlist) or possibleNext
		end

		Jukebox.enqueueTrack(jukeboxData, trackType)

		Jukebox.insertTrack(jukebox, trackType, nil, nextIndex)

		if playNow or not Jukebox.activeTracks[key] then
			-- We may have said Play Next, but if jukebox is
			-- not active, just treat this as a Play Now
			-- request from here.
			playNow = true
			jukeboxData.currentIndex = nextIndex
		end

		jukebox:transmitModData()

		if playLast then 
			Jukebox.reportMessage(player, jukeboxData.titles[trackType] .. Jukebox.translation.willPlayLast)
			return 
		end
	end
	
	-- May need an update if we made it this far.
	local selectedTitle = playNow and Jukebox.getCurrentTitle(jukeboxData) or Jukebox.getNextTitle(jukeboxData)
	local selectedTrack = playNow and Jukebox.getCurrentTrack(jukeboxData) or Jukebox.getNextTrack(jukeboxData)

	if playNow and Jukebox.activeTracks[key] then
		Jukebox.skipCurrentTrack(jukebox)
	elseif not Jukebox.activeTracks[key] then -- Play Next, Play Now, or Random Song, and nothing is playing.
		sendClientCommand('Jukebox', 'play', jukeboxData)
	end

	if Jukebox.getSoundFile(selectedTrack) then
		Jukebox.reportMessage(player, "" .. selectedTitle .. Jukebox.translation.willPlay .. (playNow and Jukebox.translation.now or Jukebox.translation.next))
	end
end

Events.OnPreFillWorldObjectContextMenu.Add(JukeboxMenus.doBuildMenus)

-- if not isClient() then Events.LoadGridsquare.Add(Jukebox.getEvolvedJukebox) end
