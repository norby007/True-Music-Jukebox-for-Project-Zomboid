if isClient() then return end

JukeboxServer = {}

JukeboxServer.activeLocations = {}

JukeboxServer.tick = 0

-- last[key][command] = lastTickThatIssuedThisCommand
JukeboxServer.last = {}

JukeboxServer.directClients = function(module, command, args)
	if not isClient() and not isServer() then
		triggerEvent("OnServerCommand", module, command, args);     -- Singleplayer
	else
		sendServerCommand(module, command, args)                    -- Multiplayer
	end
end

JukeboxServer.play = function(jukeboxData)

	jukeboxData.playNow = jukeboxData.skip

	if jukeboxData.queueLocked then
		local priorTrackType = Jukebox.getPriorTrack(jukeboxData)

		jukeboxData.priorTrackType = priorTrackType
	end

	local trackType = Jukebox.getCurrentTrack(jukeboxData)

	if jukeboxData.queueSize > 0 and not jukeboxData.queue[trackType] then repeat
		local nextInQueue = Jukebox.seekNextQueuedIndex(jukeboxData)

		if nextInQueue then
			jukeboxData.currentIndex = nextInQueue
			break
		end
		-- Error: if queueSize > 0, next track should be in the queue. Reset queue and report error. 	

		jukeboxData.error = "Queue should have existed but had no tracks in box."
		JukeboxServer.directClients("Jukebox", "error", jukeboxData)

	until true end

	jukeboxData.currentIndex = jukeboxData.currentIndex and math.max(math.min(jukeboxData.currentIndex, #jukeboxData.playlist), 1) or false
	
	if not jukeboxData.currentIndex then 
		jukeboxData.currentIndex = 1
		jukeboxData.error = "jukeboxData.currentIndex became invalid; suggests that an active jukebox has no tracks loaded somehow."
		JukeboxServer.directClients("Jukebox", "error", jukeboxData)
		return 
	end

    JukeboxServer.directClients("Jukebox", "play", jukeboxData)
end

JukeboxServer.skip = function(jukeboxData)
	jukeboxData.currentIndex = Jukebox.getNextIndex(jukeboxData)
	JukeboxServer.play(jukeboxData)
end

JukeboxServer.update = function()
	ModData.transmit("JukeboxServer.activeLocations")
    JukeboxServer.directClients("Jukebox", "update", JukeboxServer.activeLocations)
end

JukeboxServer.transmit = function(jukeboxLocations)
	print("Server is trying to store new locations...")
    for key, value in pairs(jukeboxLocations) do
		JukeboxServer.activeLocations[key] = value
	end
	JukeboxServer.update()
end

JukeboxServer.clear = function(jukeboxLocations)
    for key in pairs(jukeboxLocations) do
		JukeboxServer.activeLocations[key] = nil
	end
	ModData.transmit("JukeboxServer.activeLocations")
    JukeboxServer.directClients("Jukebox", "clear", jukeboxLocations)
end

JukeboxServer.logCommand = function(key, command, tick)
	JukeboxServer.last[key] = {}
	JukeboxServer.last[key][command] = tick
end

JukeboxServer.processClientCommand = function(module, command, player, args)
	if not (module == "Jukebox" and JukeboxServer[command]) then return end

	Jukebox.initializeTimeVariables()

	if args.x and args.y and args.z then
	
		local key = args.x .. ", " .. args.y .. ", " .. args.z

		local tickDifference = Jukebox.oneRealHalfSecond

		local hoursPerDay = 24

		local lastTick = JukeboxServer.last[key] and JukeboxServer.last[key][command]
		
		if lastTick then
			-- This may be a duplicate command; check the time difference.
			local currentTick = (args.tick >= lastTick) and args.tick or (hoursPerDay + args.tick)
			tickDifference = currentTick - lastTick
		end

		JukeboxServer.logCommand(key, command, args.tick)

		if tickDifference < Jukebox.oneRealHalfSecond then 
			args.error = "Tick difference was too small... args.tick was " .. args.tick .. 
				" and the difference was " .. tickDifference .. "."
			return JukeboxServer.directClients("Jukebox", "error", args)
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