if isServer() then return end

local Jukebox = require("Jukebox/Utility")

local JukeboxClient = {}

JukeboxClient.error = function(jukeboxData)
	-- print(jukeboxData.error)
end

JukeboxClient.play = function(packet, now)

	local key = packet.key

	local jukeboxData = Jukebox.activeLocations[key]

	local square = getSquare(jukeboxData.x, jukeboxData.y, jukeboxData.z)

	local jukebox = square and Jukebox.getVanillaMachine(square)

	if square and not jukebox then --> jukebox was moved and can't possibly be playing anymore.
		Jukebox.removeBatchedKey(key, jukeboxData.batch)
		sendClientCommand("TrueMusicJukebox", "clear", {[key] = true, x = jukeboxData.x, y = jukeboxData.y, z = jukeboxData.z})		
		return
	end

	local trackType = Jukebox.getCurrentTrack(jukeboxData)

	local distance = Jukebox.getDistance(jukeboxData)

	if not Jukebox.playAtThisRange(distance) then 
		local sound = Jukebox.activeTracks[key] and Jukebox.activeTracks[key].sound
		if sound then sound:stop() end
		Jukebox.activeTracks[key] = nil
		return
	end

	Jukebox.playSound(jukeboxData, trackType, now)

end

JukeboxClient.skip = function(packet)
	JukeboxClient.play(packet, true)
end

JukeboxClient.update = function(jukeboxLocations)
	if not jukeboxLocations then return end
	-- Set local activeLocations table from server's mod data.
	for key, jukeboxData in pairs(jukeboxLocations) do
		Jukebox.activeLocations[key] = jukeboxData
		Jukebox.addBatchedKey(key, jukeboxData.batch)
	end
end

JukeboxClient.clear = function(jukeboxLocations)
	if not jukeboxLocations then return	end
	-- Set local activeLocations table from server's mod data.
	for key in pairs(jukeboxLocations) do
		local batch = (type(Jukebox.activeLocations[key]) == "table") and Jukebox.activeLocations[key].batch
		Jukebox.activeLocations[key] = nil
		if Jukebox.activeTracks[key] then
			Jukebox.activeTracks[key].sound:stop()
			Jukebox.activeTracks[key] = nil
		end
		if batch then Jukebox.removeBatchedKey(key, batch) end
	end
end

JukeboxClient.shuffle = function(packet)
	local jukeboxData = Jukebox.activeLocations[packet.key]
	if jukeboxData.triggeredShufflePersonally then -- This was the first client to shuffle.
		jukeboxData.triggeredShufflePersonally = nil
		return
	end
	Jukebox.shuffle(jukeboxData, packet)
end

JukeboxClient.sync = function(packet)
	local jukeboxData = Jukebox.activeLocations[packet.key]
	
	if not jukeboxData then return end -- Location hasn't yet been initialized by an update call.

	for key, value in pairs(packet) do repeat
		-- Jukebox.command = {
		-- 		afterSync = true, enqueue = true, dequeue = true, remove = true,
		-- 		increaseIndex = true, decreaseIndex = true, enqueueIndex = true
		-- }
		if Jukebox.command[key] then break end
		jukeboxData[key] = value
	until true end

	local command = Jukebox.process(jukeboxData, packet)

	if JukeboxClient[command] then
		JukeboxClient[command](packet)
	end
end

JukeboxClient.processServerCommand = function(module, command, packet)
	if not (module == "TrueMusicJukebox" and JukeboxClient[command]) then return end
	JukeboxClient[command](packet)
end

Events.OnServerCommand.Add(JukeboxClient.processServerCommand)

return JukeboxClient
