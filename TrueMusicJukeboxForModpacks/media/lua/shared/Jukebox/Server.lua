if isClient() then return end

JukeboxServer = {}

JukeboxServer.activeLocations = {}

JukeboxServer.tick = 0

-- last[key][command] = lastTickThatIssuedThisCommand
JukeboxServer.last = {}

JukeboxServer.directClients = function(module, command, args, player)
	if not isClient() and not isServer() then
		triggerEvent("OnServerCommand", module, command, args)		-- Singleplayer
	else
		if player then
			sendServerCommand(player, module, command, args)		-- Multiplayer
		else
			sendServerCommand(module, command, args)				-- Multiplayer
		end
	end
end

JukeboxServer.play = function(jukeboxData)

	jukeboxData.playNow = jukeboxData.skip

	if jukeboxData.queueLocked and not jukeboxData.replayedFromQueue then
		local priorTrackType = Jukebox.getPriorTrack(jukeboxData)

		jukeboxData.priorTrackType = priorTrackType
	end

	jukeboxData.replayedFromQueue = nil

	local trackType = Jukebox.getCurrentTrack(jukeboxData)

	if jukeboxData.queueSize > 0 and not jukeboxData.queue[trackType] then repeat
		local nextInQueue = Jukebox.seekNextQueuedIndex(jukeboxData)

		if nextInQueue then
			jukeboxData.currentIndex = nextInQueue
			break
		end
		-- Error: if queueSize > 0, next track should be in the queue. Reset queue and report error. 	

		jukeboxData.error = "Queue should have existed but had no tracks in box."
		JukeboxServer.directClients("TrueMusicJukebox", "error", jukeboxData)

	until true end

	jukeboxData.currentIndex = jukeboxData.currentIndex and math.max(math.min(jukeboxData.currentIndex, #jukeboxData.playlist), 1) or false
	
	if not jukeboxData.currentIndex then 
		jukeboxData.currentIndex = 1
		jukeboxData.error = "jukeboxData.currentIndex became invalid; suggests that an active jukebox has no tracks loaded somehow."
		JukeboxServer.directClients("TrueMusicJukebox", "error", jukeboxData)
		return 
	end

    JukeboxServer.directClients("TrueMusicJukebox", "play", jukeboxData)
end

JukeboxServer.skip = function(jukeboxData)
	jukeboxData.skip = true
	jukeboxData.currentIndex = Jukebox.getNextIndex(jukeboxData)
	JukeboxServer.play(jukeboxData)
end

JukeboxServer.update = function(jukeboxLocations)
    JukeboxServer.directClients("TrueMusicJukebox", "update", jukeboxLocations)
end

JukeboxServer.transmit = function(jukeboxLocations)
    for key, value in pairs(jukeboxLocations) do repeat
		if key == "doNotReply" or value == true then break end
		JukeboxServer.activeLocations[key] = value
	until true end
	
	ModData.transmit("JukeboxServer.activeLocations")

	if jukeboxLocations.doNotReply then return end
	
	JukeboxServer.update(jukeboxLocations)
end

JukeboxServer.clear = function(jukeboxLocations)
    for key in pairs(jukeboxLocations) do
		JukeboxServer.activeLocations[key] = nil
	end
	ModData.transmit("JukeboxServer.activeLocations")
    JukeboxServer.directClients("TrueMusicJukebox", "clear", jukeboxLocations)
end

JukeboxServer.logCommand = function(key, command, tick)
	JukeboxServer.last[key] = {}
	JukeboxServer.last[key][command] = tick
end

JukeboxServer.request = function(player)
    JukeboxServer.directClients("TrueMusicJukebox", "update", JukeboxServer.activeLocations, player)
end

JukeboxServer.processClientCommand = function(module, command, player, args)
	if not (module == "TrueMusicJukebox" and JukeboxServer[command]) then return end

	Jukebox.initializeTimeVariables()

	if command == "request" then
		JukeboxServer.request(player)
		return
	end

	if args.x and args.y and args.z then
	
		local key = args.x .. ", " .. args.y .. ", " .. args.z

		local tickDifference = Jukebox.oneRealHalfSecond

		local hoursPerDay = 24

		local lastTick = JukeboxServer.last[key] and JukeboxServer.last[key][command]
		
		local currentTick = Jukebox.getTime()

		if lastTick then
			-- This may be a duplicate command; check the time difference.
			local currentTickAdjusted = (currentTick >= lastTick) and currentTick or (hoursPerDay + currentTick)
			tickDifference = currentTickAdjusted - lastTick
		end

		JukeboxServer.logCommand(key, command, currentTick)

		if tickDifference < Jukebox.oneRealHalfSecond then 
			args.error = "Tick difference was too small... currentTick was " .. currentTick .. 
				" and the difference was " .. tickDifference .. "."
			return JukeboxServer.directClients("TrueMusicJukebox", "error", args)
		end

		if command == "transmit" then
			-- We only need these to reduce double-commands. This data doesn't get stored clientside
			args.x = nil
			args.y = nil
			args.z = nil
		end
		
	end

	JukeboxServer[command](args)
end

Events.OnClientCommand.Add(JukeboxServer.processClientCommand)

JukeboxServer.processServersideLocationData = function()
	JukeboxServer.activeLocations = ModData.getOrCreate("JukeboxServer.activeLocations")
	ModData.transmit("JukeboxServer.activeLocations")
end

Events.OnInitGlobalModData.Add(JukeboxServer.processServersideLocationData)