if isClient() then return end

local Jukebox = require("Jukebox/Utility")

local JukeboxServer = {}

JukeboxServer.activeLocations = {}

JukeboxServer.deliveryQueue = {}

-- history[key][command] => table containing last time and
-- command hash for last command sent for this key.
JukeboxServer.history = {}

JukeboxServer.hashed = {
	["play"] = true,
	["move"] = true,
}

JukeboxServer.directClients = function(module, command, packet, player)
	if not isClient() and not isServer() then
		triggerEvent("OnServerCommand", module, command, packet)		-- Singleplayer
	else
		if player then
			sendServerCommand(player, module, command, packet)		-- Multiplayer
		else
			sendServerCommand(module, command, packet)				-- Multiplayer
		end
	end
end

JukeboxServer.sync = function(packet)
	if isServer() then -- I.e., don't do this on single player; causes doubling of signals.
		local jukeboxData = JukeboxServer.activeLocations[packet.key]
		
		if not jukeboxData then return end -- Location hasn't yet been initialized by a transmit call.

		for key, value in pairs(packet) do repeat
			-- Jukebox.command = {
			-- 		afterSync = true, enqueue = true, dequeue = true, remove = true,
			-- 		increaseIndex = true, decreaseIndex = true, enqueueIndex = true
			-- }
			if Jukebox.command[key] then break end
			jukeboxData[key] = value
		until true end

		local command = Jukebox.process(jukeboxData, packet)
		
		if command == "shuffle" then
			Jukebox.shuffle(jukeboxData, packet)
		end
	end

	-- Just forward data along if this is single-player.
	JukeboxServer.directClients("TrueMusicJukebox", "sync", packet)
end

JukeboxServer.transmit = function(jukeboxLocations)
    for key, value in pairs(jukeboxLocations) do repeat
		JukeboxServer.activeLocations[key] = value
	until true end
	
	JukeboxServer.update(jukeboxLocations)
end

JukeboxServer.update = function(jukeboxLocations)
    JukeboxServer.directClients("TrueMusicJukebox", "update", jukeboxLocations)
end

JukeboxServer.clear = function(jukeboxLocations)
    for key in pairs(jukeboxLocations) do
		JukeboxServer.activeLocations[key] = nil
	end
	
    JukeboxServer.directClients("TrueMusicJukebox", "clear", jukeboxLocations)
end

JukeboxServer.hash = function(packet)
	local hash = ""
	for key, value in pairs(packet) do
		hash = hash .. "[ " .. tostring(key) .. " : " .. tostring(value) .. " ] "
	end
	return hash
end

JukeboxServer.log = function(key, command, time, hash)
	JukeboxServer.history[key] = JukeboxServer.history[key] or {}
	JukeboxServer.history[key][command] = {
		priorTime = time,
		priorHash = hash
	}
end

JukeboxServer.request = function(player)
	if JukeboxServer.deliveryQueue[player] then
		return JukeboxServer.deliver(player)
	end

	JukeboxServer.deliveryQueue[player] = {}
	
	-- Will be unloaded in reverse, so we insert this first. We will always have at least
	-- this data to send, even on a fresh server, to ensure that request completes successfully.
	table.insert(JukeboxServer.deliveryQueue[player], { activeLocationsLoaded = true })

	local jukeboxDataQueueSize = 0

	for key, jukeboxData in pairs(JukeboxServer.activeLocations) do
		local deliverThisJukebox = true

		if SandboxVars.TrueMusicJukebox.onlyRequestAudibleJukeboxData then
			local distance = Jukebox.getDistanceToPlayer(jukeboxData, player)
			local withinAudibleRange = Jukebox.playAtThisRange(distance)
			deliverThisJukebox = withinAudibleRange
		end

		if deliverThisJukebox then 
			jukeboxDataQueueSize = jukeboxDataQueueSize + 1
			if jukeboxDataQueueSize > SandboxVars.TrueMusicJukebox.maximumJukeboxesDeliveredOnConnect then break end
			table.insert(JukeboxServer.deliveryQueue[player], {[key] = jukeboxData})
		end
	end

	JukeboxServer.deliver(player)
end

JukeboxServer.deliver = function(player)
	-- for player in pairs(JukeboxServer.deliveryQueue) do
	local playerDeliveryQueue = JukeboxServer.deliveryQueue[player]

	if playerDeliveryQueue.activeLocationsLoaded then return end
	
	local endpoint = #playerDeliveryQueue - 4 -- Used to loop from #pDQ through #pDQ - 4 (5 iterations max).

	for index = #playerDeliveryQueue, 1, -1 do
		local packet = playerDeliveryQueue[index]
		JukeboxServer.directClients("TrueMusicJukebox", "update", packet, player)
		table.remove(playerDeliveryQueue, index)
		if index == endpoint then break end -- Maximum 3 jukeboxes per player per request from server.
	end

	if #playerDeliveryQueue == 0 then
		playerDeliveryQueue.activeLocationsLoaded = true -- We're finished updating this newly connected client.
	end
end

JukeboxServer.checkForTimingProblems = function(key, command, packet)
	local timeDifference = (21 * Jukebox.oneRealHalfSecond) -- Safe until we determine otherwise.

	local hoursPerDay = 24

	local priorTime = JukeboxServer.history[key] and type(JukeboxServer.history[key][command]) == "table" and 
		JukeboxServer.history[key][command].priorTime

	local priorHash = JukeboxServer.history[key] and type(JukeboxServer.history[key][command]) == "table" and 
		JukeboxServer.history[key][command].priorHash		

	local currentTime = Jukebox.getTime()

	local currentHash = JukeboxServer.hash(packet)

	local receivedDuplicateCommand = false

	if priorTime then
		-- This may be a duplicate command; check the time difference.
		local currentTimeAdjusted = (currentTime >= priorTime) and currentTime or (hoursPerDay + currentTime)
		
		timeDifference = currentTimeAdjusted - priorTime

		if priorHash and currentHash and priorHash == currentHash then
			receivedDuplicateCommand = true		
		end
	end

	local halfSecondsBeforeDuplicatesAllowed = receivedDuplicateCommand and 20 or 0

	local commandTimingProblem = timeDifference < (halfSecondsBeforeDuplicatesAllowed * Jukebox.oneRealHalfSecond)

	if not commandTimingProblem then JukeboxServer.log(key, command, currentTime, currentHash) end

	-- Time required before another command is allowed. 
	-- 0 seconds if command is unique, or about 10 seconds if command is a duplicate.	
	return commandTimingProblem
end

JukeboxServer.processClientCommand = function(module, command, player, packet)
	if not (module == "TrueMusicJukebox" and JukeboxServer[command]) then return end

	Jukebox.initializeTimeVariables()

	if command == "request" then
		JukeboxServer.request(player)
		return
	end

	if not packet then return end

	if packet.key then
		local commandTimingProblem = JukeboxServer.checkForTimingProblems(packet.key, command, packet)

		if commandTimingProblem then
			-- print("That time difference was too small, so the command was ignored.")
			packet.error = "Time difference was too small."
			return JukeboxServer.directClients("TrueMusicJukebox", "error", packet)
		end
	end

	JukeboxServer[command](packet)
end

Events.OnClientCommand.Add(JukeboxServer.processClientCommand)

-- Only the server stores permanent mod data in this version.
JukeboxServer.processServersideLocationData = function()
	JukeboxServer.activeLocations = ModData.getOrCreate("JukeboxServer.activeLocations")
end

Events.OnInitGlobalModData.Add(JukeboxServer.processServersideLocationData)

return JukeboxServer
