if isServer() then return end

local JukeboxClient = {}

JukeboxClient.error = function(jukeboxData)
	print(jukeboxData.error)
end

JukeboxClient.play = function(jukeboxData)
	if not jukeboxData then return end

	local playNow = jukeboxData.playNow
	local square = getSquare(jukeboxData.x, jukeboxData.y, jukeboxData.z)
	local jukebox = false
	local priorTrackType = jukeboxData.priorTrackType

	if square then 
		for index = 1, square:getObjects():size() do
			local thisObject = square:getObjects():get(index - 1)
			if thisObject:getSprite() then
				local properties = thisObject:getSprite():getProperties()
				jukebox = (properties and properties:Is("CustomName") 
								and properties:Val("CustomName") == "Jukebox" 
								and thisObject) or false
				if jukebox then
					-- Skip behavior has now been processed; reset it.
					jukebox:getModData().skip = false
					-- Possibly adjusted serverside.
					jukebox:getModData().currentIndex = jukeboxData.currentIndex
					-- Possibly rearranged serverside. Size should not have changed.
					for index, value in ipairs(jukeboxData.playlist) do
						jukebox:getModData().playlist[index] = value
					end
					jukeboxData = jukebox:getModData() --> Necessary to dequeue tracks from jukebox's actual mod data.
					break
				end
			end
		end
	end

	local trackType = Jukebox.getCurrentTrack(jukeboxData)

	Jukebox.playSound(jukeboxData, trackType, playNow)

	if jukebox then
		if priorTrackType then
			Jukebox.removeTrack(jukebox, priorTrackType)
	
			-- Must do this after the dequeue adjusts the playlist's index.
			local nextIndex = Jukebox.getNextIndex(jukeboxData)

			local possibleNext = (nextIndex + jukeboxData.queueSize) % #jukeboxData.playlist

			nextIndex = (possibleNext == 0 and #jukeboxData.playlist) or possibleNext

			Jukebox.enqueueTrack(jukeboxData, priorTrackType)
	
			Jukebox.insertTrack(jukebox, priorTrackType, nil, nextIndex)
		end
		jukebox:transmitModData()
	end
end

JukeboxClient.update = function(jukeboxLocations)
	print("Updating locations clientside.")
	-- Set local activeLocations table from server's mod data.
	for key, value in pairs(jukeboxLocations) do	
		Jukebox.activeLocations[key] = value
	end
	ModData.transmit("Jukebox.activeLocations")
	print("Transmitted the mod data...")
end

JukeboxClient.clear = function(jukeboxLocations)
	-- Set local activeLocations table from server's mod data.
	for key in pairs(jukeboxLocations) do	
		Jukebox.activeLocations[key] = nil
		if Jukebox.activeTracks[key] then
			Jukebox.activeTracks[key].sound:stop()
			Jukebox.activeTracks[key] = nil
		end
		print("Clearing null location..." .. key)
	end
	ModData.transmit("Jukebox.activeLocations")
end

JukeboxClient.processServerCommand = function(module, command, args)
	if not (module == "Jukebox" and JukeboxClient[command]) then return end
	JukeboxClient[command](args)
end

Events.OnServerCommand.Add(JukeboxClient.processServerCommand)

return JukeboxClient
