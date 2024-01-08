if isClient() then return end

JukeboxServer = {}

JukeboxServer.activeLocations = {}

JukeboxServer.tick = 0

-- history[key][command] => table containing last tick and
-- command hash for last command sent for this key.
JukeboxServer.history = {}

JukeboxServer.hashed = {
	["play"] = true,
	["move"] = true,
}

JukeboxServer.directClients = function(module, command, args, player)
	-- -------------------DEBUG-------------------
	-- print("---------JUKEBOX COMMAND " .. command .. " FINISHED SERVERSIDE----------")
	-- Jukebox.logCurrentTime()
	-- print("---------JUKEBOX COMMAND " .. command .. " FINISHED SERVERSIDE----------")
	-- -------------------------------------------

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

	local currentTick = Jukebox.getTime()

	jukeboxData.playNow = jukeboxData.skip

	jukeboxData.skip = false

	if jukeboxData.queueLocked and not jukeboxData.replayedFromQueue then
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
		JukeboxServer.directClients("TrueMusicJukebox", "error", jukeboxData)

	until true end

	jukeboxData.currentIndex = jukeboxData.currentIndex and math.max(math.min(jukeboxData.currentIndex, #jukeboxData.playlist), 1) or false
	
	if not jukeboxData.currentIndex then 
		jukeboxData.currentIndex = 1
		jukeboxData.error = "jukeboxData.currentIndex became invalid; suggests that an active jukebox has no tracks loaded somehow."
		JukeboxServer.directClients("TrueMusicJukebox", "error", jukeboxData)
		return 
	end

	ModData.transmit("JukeboxServer.activeLocations")
    JukeboxServer.directClients("TrueMusicJukebox", "play", jukeboxData)
end

JukeboxServer.skip = function(skipData)
	if not skipData.key then return end
	local jukeboxData = JukeboxServer.activeLocations[skipData.key]
	jukeboxData.skip = true
	jukeboxData.currentIndex = Jukebox.getNextIndex(jukeboxData)
	JukeboxServer.play(jukeboxData)
end

-- JukeboxServer.skip = function(jukeboxData)
-- 	jukeboxData.skip = true
-- 	jukeboxData.currentIndex = Jukebox.getNextIndex(jukeboxData)
-- 	JukeboxServer.play(jukeboxData)
-- end

JukeboxServer.next = function(jukeboxData)
	jukeboxData.currentIndex = Jukebox.getNextIndex(jukeboxData)
	JukeboxServer.play(jukeboxData)
end

-- New data set to currentIndex does not get used until songs end or the skip
-- command tells the move to happen early.
JukeboxServer.move = function(jukeboxData)
	jukeboxData.skip = true
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

JukeboxServer.hashCommand = function(key, args)

	if not (key and type(args) == "table") then return end

	local prior = Jukebox.getPriorTrack(args) or ""
	local current = Jukebox.getCurrentTrack(args) or ""
	local next = Jukebox.getNextTrack(args) or ""

	return (key .. args.playlistSize .. args.queueSize .. args.currentIndex ..
		tostring(args.queueLocked) .. tostring(args.skip) .. prior .. current .. next)

end

JukeboxServer.logCommand = function(key, command, tick, hash)
	JukeboxServer.history[key] = JukeboxServer.history[key] or {}
	JukeboxServer.history[key][command] = {
		priorTick = tick,
		priorHash = hash
	}
end

JukeboxServer.request = function(player)
    JukeboxServer.directClients("TrueMusicJukebox", "update", JukeboxServer.activeLocations, player)
end

JukeboxServer.processClientCommand = function(module, command, player, args)
	if not (module == "TrueMusicJukebox" and JukeboxServer[command]) then return end

	Jukebox.initializeTimeVariables()
	
	-- -------------------DEBUG-------------------
	-- print("---------JUKEBOX COMMAND " .. command .. " RECEIVED SERVERSIDE----------")
	-- Jukebox.logCurrentTime()
	-- print("---------JUKEBOX COMMAND " .. command .. " RECEIVED SERVERSIDE----------")
	-- -------------------------------------------

	if command == "request" then
		JukeboxServer.request(player)
		return
	end

	if not args then return end

	if args.x and args.y and args.z then
	
		local key = args.x .. ", " .. args.y .. ", " .. args.z

		local tickDifference = (21 * Jukebox.oneRealHalfSecond) -- Safe until we determine otherwise.

		local hoursPerDay = 24

		local priorTick = JukeboxServer.history[key] and type(JukeboxServer.history[key][command]) == "table" and 
			JukeboxServer.history[key][command].priorTick

		local priorHash = JukeboxServer.history[key] and type(JukeboxServer.history[key][command]) == "table" and 
			JukeboxServer.history[key][command].priorHash
	
		local currentTick = Jukebox.getTime()

		local currentHash = JukeboxServer.hashed[command] and JukeboxServer.hashCommand(key, args)

		local receivedDuplicateCommand = false

		if priorTick then
			-- This may be a duplicate command; check the time difference.
			local currentTickAdjusted = (currentTick >= priorTick) and currentTick or (hoursPerDay + currentTick)
			
			tickDifference = currentTickAdjusted - priorTick
			
		end

		if priorHash and currentHash and priorHash == currentHash then
			receivedDuplicateCommand = true		
		end

		local halfSecondsBeforeDuplicatesAllowed = receivedDuplicateCommand and 20 or 1.5

		JukeboxServer.logCommand(key, command, currentTick)

		if tickDifference < (halfSecondsBeforeDuplicatesAllowed * Jukebox.oneRealHalfSecond) then
			print("That tick difference was too small, so the command was ignored.")
			args.error = "Tick difference was too small... currentTick was " .. currentTick .. 
				" and the difference was " .. tickDifference .. "."
			return JukeboxServer.directClients("TrueMusicJukebox", "error", args)
		end

		if JukeboxServer.hashed[command] and key then
			JukeboxServer.activeLocations[key] = args
			ModData.transmit("JukeboxServer.activeLocations")
			-- Store data as it goes by during play, move, and skip commands.
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