if isServer() then return end

local JukeboxClient = {}

JukeboxClient.error = function(jukeboxData)
	print(jukeboxData.error)
end

JukeboxClient.play = function(jukeboxDataDrop)
	if not jukeboxDataDrop then return end
	
	-- -------------------DEBUG-------------------
	-- print("---------JUKEBOX CLIENT RECEIVED PLAY INSTRUCTION----------")
	-- Jukebox.logCurrentTime()
	-- print("---------JUKEBOX CLIENT RECEIVED PLAY INSTRUCTION----------")
	-- -------------------------------------------

	local key = Jukebox.dataToKey(jukeboxDataDrop)
	local playNow = jukeboxDataDrop.playNow -- Need to grab from server's data
	local priorTrackType = jukeboxDataDrop.priorTrackType
	
	jukeboxDataDrop.priorTrackType = nil --> We don't want to leave this set.
	jukeboxDataDrop.playNow = nil --> We don't want to leave this set.
	
	local square = getSquare(jukeboxDataDrop.x, jukeboxDataDrop.y, jukeboxDataDrop.z)

	local jukebox = square and Jukebox.getVanillaMachine(square)

	if square and not jukebox then --> jukebox was moved and can't possibly be playing anymore.
		Jukebox.removeBatchedKey(key, jukeboxDataDrop.batch)
		sendClientCommand("TrueMusicJukebox", "clear", {[key] = true, x = jukeboxDataDrop.x, y = jukeboxDataDrop.y, z = jukeboxDataDrop.z})		
		return
	end

	local trackType = Jukebox.getCurrentTrack(jukeboxDataDrop)

	Jukebox.activeLocations[key] = jukeboxDataDrop

	local jukeboxData = Jukebox.activeLocations[key]

	Jukebox.playSound(jukeboxData, trackType, playNow)

	if priorTrackType then
		Jukebox.delayedRequeueRequests = Jukebox.delayedRequeueRequests or {}

		Jukebox.delayedRequeueRequests[key] = Jukebox.delayedRequeueRequests[key] or {}
		
		if not Jukebox.delayedRequeueRequests[key][priorTrackType] then
			Jukebox.delayedRequeueRequests[key][priorTrackType] = true
			Jukebox.delayedRequeueRequests[key][#Jukebox.delayedRequeueRequests[key] + 1] = {
				trackType = priorTrackType,
				delay = 2 -- ticks
			}
		end
	end
	-- Skips tick check because another transmit fires immediately before this.
	sendClientCommand("TrueMusicJukebox", "transmit", {[key] = jukeboxData, x = jukeboxData.x, y = jukeboxData.y, z = jukeboxData.z, doNotReply = true})

	ModData.transmit("Jukebox.activeLocations")
end

JukeboxClient.update = function(jukeboxLocations)

	-- -------------------DEBUG-------------------
	-- print("---------JUKEBOX CLIENT RECEIVED UPDATE INSTRUCTION----------")
	-- Jukebox.logCurrentTime()
	-- print("---------JUKEBOX CLIENT RECEIVED UPDATE INSTRUCTION----------")
	-- -------------------------------------------

	if not jukeboxLocations then return end
	-- Set local activeLocations table from server's mod data.
	for key, jukeboxData in pairs(jukeboxLocations) do
		Jukebox.activeLocations[key] = jukeboxData
		Jukebox.addBatchedKey(key, jukeboxData.batch)
	end
	ModData.transmit("Jukebox.activeLocations")
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
	ModData.transmit("Jukebox.activeLocations")
end

JukeboxClient.processServerCommand = function(module, command, args)
	if not (module == "TrueMusicJukebox" and JukeboxClient[command]) then return end
	JukeboxClient[command](args)
end

Events.OnServerCommand.Add(JukeboxClient.processServerCommand)

return JukeboxClient
