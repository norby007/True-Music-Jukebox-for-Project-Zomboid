if isServer() then return end

local JukeboxClient = {}

JukeboxClient.error = function(jukeboxData)
	print(jukeboxData.error)
end

JukeboxClient.play = function(jukeboxDataDrop)
	if not jukeboxDataDrop then return end

	local key = Jukebox.dataToKey(jukeboxDataDrop)
	local playNow = jukeboxDataDrop.playNow -- Need to grab from server's data
	local priorTrackType = jukeboxDataDrop.priorTrackType
	
	jukeboxDataDrop.priorTrackType = nil --> We don't want to leave this set.
	jukeboxDataDrop.playNow = nil --> We don't want to leave this set.
	
	local square = getSquare(jukeboxDataDrop.x, jukeboxDataDrop.y, jukeboxDataDrop.z)

	local jukebox = false

	if square then 
		for index = 1, square:getObjects():size() do
			local thisObject = square:getObjects():get(index - 1)
			if thisObject:getSprite() then
				local properties = thisObject:getSprite():getProperties()
				jukebox = (properties and properties:Is("CustomName") 
								and properties:Val("CustomName") == "Jukebox" 
								and thisObject) or false
				if jukebox then break end
			end
		end
	end

	if square and not jukebox then --> jukebox was moved and can't possibly be playing anymore.
		sendClientCommand("TrueMusicJukebox", "clear", {[key] = true, x = jukeboxDataDrop.x, y = jukeboxDataDrop.y, z = jukeboxDataDrop.z})		
		return
	end

	local trackType = Jukebox.getCurrentTrack(jukeboxDataDrop)

	-- Hopefully global mod data...

	Jukebox.activeLocations[key] = jukeboxDataDrop

	local jukeboxData = Jukebox.activeLocations[key] 

	Jukebox.playSound(jukeboxData, trackType, playNow)

	if priorTrackType then
		Jukebox.delayedRequeueRequests = Jukebox.delayedRequeueRequests or {}

		Jukebox.delayedRequeueRequests[key] = Jukebox.delayedRequeueRequests[key] or {}

		Jukebox.delayedRequeueRequests[key][#Jukebox.delayedRequeueRequests[key] + 1] = {
			trackType = priorTrackType,
			delay = 2 -- ticks
		}
	end
	-- Skips tick check because another transmit fires immediately before this.
	sendClientCommand("TrueMusicJukebox", "transmit", {[key] = jukeboxData, doNotReply = true})

	ModData.transmit("Jukebox.activeLocations")
end

JukeboxClient.update = function(jukeboxLocations)
	if not jukeboxLocations then return end
	-- Set local activeLocations table from server's mod data.
	for key, value in pairs(jukeboxLocations) do
		Jukebox.activeLocations[key] = value
	end
	ModData.transmit("Jukebox.activeLocations")
end

JukeboxClient.clear = function(jukeboxLocations)
	if not jukeboxLocations then return	end
	-- Set local activeLocations table from server's mod data.
	for key in pairs(jukeboxLocations) do	
		Jukebox.activeLocations[key] = nil
		if Jukebox.activeTracks[key] then
			Jukebox.activeTracks[key].sound:stop()
			Jukebox.activeTracks[key] = nil
		end
	end
	ModData.transmit("Jukebox.activeLocations")
end

JukeboxClient.processServerCommand = function(module, command, args)
	if not (module == "TrueMusicJukebox" and JukeboxClient[command]) then return end
	JukeboxClient[command](args)
end

Events.OnServerCommand.Add(JukeboxClient.processServerCommand)

return JukeboxClient
