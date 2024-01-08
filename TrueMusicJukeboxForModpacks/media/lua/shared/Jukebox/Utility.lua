require "Jukebox/Sound"
require "Jukebox/Objects"

Jukebox = Jukebox or {}

Jukebox.version = 6

Jukebox.translation = {
	playNow = getText("UI_TrueMusicJukebox_playNow"),
	playNext = getText("UI_TrueMusicJukebox_playNext"),
	playLast = getText("UI_TrueMusicJukebox_playLast"),
	dequeue = getText("UI_TrueMusicJukebox_dequeue"),
	viewQueue = getText("UI_TrueMusicJukebox_viewQueue"),
	lockQueue = getText("UI_TrueMusicJukebox_lockQueue"),
	unlockQueue = getText("UI_TrueMusicJukebox_unlockQueue"),
	nowPlaying = getText("UI_TrueMusicJukebox_nowPlaying"),
	turnOnJukebox = getText("UI_TrueMusicJukebox_turnOnJukebox"),
	turnOffJukebox = getText("UI_TrueMusicJukebox_turnOffJukebox"),
	setJukeboxVolume = getText("UI_TrueMusicJukebox_setJukeboxVolume"),
	jukeboxMainMenu = getText("UI_TrueMusicJukebox_jukeboxMainMenu"),
	playLoadedTracks = getText("UI_TrueMusicJukebox_playLoadedTracks"),
	shuffleLoadedTracks = getText("UI_TrueMusicJukebox_shuffleLoadedTracks"),
	playRandomTrack = getText("UI_TrueMusicJukebox_playRandomTrack"),
	replayCurrentTrack = getText("UI_TrueMusicJukebox_replayCurrentTrack"),
	replayLastTrack = getText("UI_TrueMusicJukebox_replayLastTrack"),
	skipCurrentTrack = getText("UI_TrueMusicJukebox_skipCurrentTrack"),
	showCurrentTrack = getText("UI_TrueMusicJukebox_showCurrentTrack"),
	playSpecificTrack = getText("UI_TrueMusicJukebox_playSpecificTrack"),
	queueSpecificTrack = getText("UI_TrueMusicJukebox_queueSpecificTrack"),
	statusReport = getText("UI_TrueMusicJukebox_statusReport"),

	cannotReadLoadedItem = getText("UI_TrueMusicJukebox_feedback_cannotReadLoadedItem"),
	isCurrentlyPlaying = getText("UI_TrueMusicJukebox_feedback_isCurrentlyPlaying"),
	willNeedGenerator = getText("UI_TrueMusicJukebox_feedback_willNeedGenerator"),
	noMusicInJukebox = getText("UI_TrueMusicJukebox_feedback_noMusicInJukebox"),
	unreachableJukebox = getText("UI_TrueMusicJukebox_feedback_unreachableJukebox"),
	restarting = getText("UI_TrueMusicJukebox_feedback_restarting"),
	playing = getText("UI_TrueMusicJukebox_feedback_playing"),
	skippedPriorSong = getText("UI_TrueMusicJukebox_feedback_skippedPriorSong"),
	queueLocked = getText("UI_TrueMusicJukebox_feedback_queueLocked"),
	queueUnlocked = getText("UI_TrueMusicJukebox_feedback_queueUnlocked"),
	removedFromQueue = getText("UI_TrueMusicJukebox_feedback_removedFromQueue"),
	songsNoLongerRemovedAutomatically = getText("UI_TrueMusicJukebox_feedback_songsNoLongerRemovedAutomatically"),
	songsRemovedAutomatically = getText("UI_TrueMusicJukebox_feedback_songsRemovedAutomatically"),
	shuffleToClearQueue = getText("UI_TrueMusicJukebox_feedback_shuffleToClearQueue"),
	randomlySelected = getText("UI_TrueMusicJukebox_feedback_randomlySelected"),
	trackWillPlayNow = getText("UI_TrueMusicJukebox_feedback_trackWillPlayNow"),
	allTracksShuffled = getText("UI_TrueMusicJukebox_feedback_allTracksShuffled"),
	willPlay = getText("UI_TrueMusicJukebox_feedback_willPlay"),
	willPlayLast = getText("UI_TrueMusicJukebox_feedback_willPlayLast"),
	now = getText("UI_TrueMusicJukebox_feedback_now"),
	next = getText("UI_TrueMusicJukebox_feedback_next"),
	movingTooFast = getText("UI_TrueMusicJukebox_feedback_movingTooFast"),

	hideTracklistFromContextMenu = getText("UI_TrueMusicJukebox_MO_hideTracklistFromContextMenu"),
	showEveryTrackInJukeboxPlaylist = getText("UI_TrueMusicJukebox_MO_showEveryTrackInJukeboxPlaylist"),
	showEveryTrackInJukeboxQueue = getText("UI_TrueMusicJukebox_MO_showEveryTrackInJukeboxQueue"),
	threeDimensionalAudio = getText("UI_TrueMusicJukebox_MO_threeDimensionalAudio"),
	alwaysTellMyFriends = getText("UI_TrueMusicJukebox_MO_alwaysTellMyFriends"),
	feedbackAccessibilityMode = getText("UI_TrueMusicJukebox_MO_feedbackAccessibilityMode"),
	accessibilityModeDisplayTime = getText("UI_TrueMusicJukebox_MO_accessibilityModeDisplayTime"),

	hideTracklistFromContextMenuTooltip = getText("UI_TrueMusicJukebox_MO_hideTracklistFromContextMenu_tooltip"),
	showEveryTrackInJukeboxPlaylistTooltip = getText("UI_TrueMusicJukebox_MO_showEveryTrackInJukeboxPlaylist_tooltip"),
	showEveryTrackInJukeboxQueueTooltip = getText("UI_TrueMusicJukebox_MO_showEveryTrackInJukeboxQueue_tooltip"),
	threeDimensionalAudioTooltip = getText("UI_TrueMusicJukebox_MO_threeDimensionalAudio_tooltip"),
	alwaysTellMyFriendsTooltip = getText("UI_TrueMusicJukebox_MO_alwaysTellMyFriends_tooltip"),
	feedbackAccessibilityModeTooltip = getText("UI_TrueMusicJukebox_MO_feedbackAccessibilityMode_tooltip"),
	accessibilityModeDisplayTimeTooltip = getText("UI_TrueMusicJukebox_MO_accessibilityModeDisplayTime_tooltip"),

	jukeboxHero = getText("UI_TrueMusicJukebox_jukeboxHero"),
	jukeboxHeroTooltip = getText("UI_TrueMusicJukebox_jukeboxHero_tooltip")
}

Jukebox.mod = {

    options = {
        hideTracklistFromContextMenu = false,
        showEveryTrackInJukeboxPlaylist = false,
        showEveryTrackInJukeboxQueue = false,
		threeDimensionalAudio = false,
		alwaysTellMyFriends = false,
		feedbackAccessibilityMode = false,
		accessibilityModeDisplayTime = 4
    },

    names = {
        hideTracklistFromContextMenu = Jukebox.translation.hideTracklistFromContextMenu,
        showEveryTrackInJukeboxPlaylist = Jukebox.translation.showEveryTrackInJukeboxPlaylist,
        showEveryTrackInJukeboxQueue = Jukebox.translation.showEveryTrackInJukeboxQueue,
		threeDimensionalAudio = Jukebox.translation.threeDimensionalAudio,
		alwaysTellMyFriends = Jukebox.translation.alwaysTellMyFriends,
		feedbackAccessibilityMode = Jukebox.translation.feedbackAccessibilityMode,
		accessibilityModeDisplayTime = Jukebox.translation.accessibilityModeDisplayTime
    },

    mod_id = "TrueMusicJukebox",

    mod_shortname = "True Music Jukebox"

}

Jukebox.loadModOptions = function()

    -- Connecting the options to the menu, so user can change and save them.
    if ModOptions and ModOptions.getInstance then

        Jukebox.modSettings = ModOptions:getInstance(Jukebox.mod)

        local hideTracklistFromContextMenu = Jukebox.modSettings:getData("hideTracklistFromContextMenu")
        local showEveryTrackInJukeboxPlaylist = Jukebox.modSettings:getData("showEveryTrackInJukeboxPlaylist")
        local showEveryTrackInJukeboxQueue = Jukebox.modSettings:getData("showEveryTrackInJukeboxQueue")
		local threeDimensionalAudio = Jukebox.modSettings:getData("threeDimensionalAudio")
		local alwaysTellMyFriends = Jukebox.modSettings:getData("alwaysTellMyFriends")
		local feedbackAccessibilityMode = Jukebox.modSettings:getData("feedbackAccessibilityMode")
		local accessibilityModeDisplayTime = Jukebox.modSettings:getData("accessibilityModeDisplayTime")

        hideTracklistFromContextMenu.tooltip = Jukebox.translation.hideTracklistFromContextMenuTooltip
        showEveryTrackInJukeboxPlaylist.tooltip = Jukebox.translation.showEveryTrackInJukeboxPlaylistTooltip
        showEveryTrackInJukeboxQueue.tooltip = Jukebox.translation.showEveryTrackInJukeboxQueueTooltip
		threeDimensionalAudio.tooltip = Jukebox.translation.threeDimensionalAudioTooltip
		alwaysTellMyFriends.tooltip = Jukebox.translation.alwaysTellMyFriendsTooltip
		feedbackAccessibilityMode.tooltip = Jukebox.translation.feedbackAccessibilityModeTooltip
		accessibilityModeDisplayTime.tooltip = Jukebox.translation.accessibilityModeDisplayTimeTooltip

        accessibilityModeDisplayTime[1] = "1 " .. getText("IGUI_Gametime_second")   
        accessibilityModeDisplayTime[2] = "2 " .. getText("IGUI_Gametime_secondes")
        accessibilityModeDisplayTime[3] = "3 " .. getText("IGUI_Gametime_secondes")
        accessibilityModeDisplayTime[4] = "4 " .. getText("IGUI_Gametime_secondes")
        accessibilityModeDisplayTime[5] = "5 " .. getText("IGUI_Gametime_secondes")
        accessibilityModeDisplayTime[6] = "6 " .. getText("IGUI_Gametime_secondes")
        accessibilityModeDisplayTime[7] = "7 " .. getText("IGUI_Gametime_secondes")
        accessibilityModeDisplayTime[8] = "8 " .. getText("IGUI_Gametime_secondes")
        accessibilityModeDisplayTime[9] = "9 " .. getText("IGUI_Gametime_secondes")
        accessibilityModeDisplayTime[10] = "10 " .. getText("IGUI_Gametime_secondes")
        accessibilityModeDisplayTime[11] = "11 " .. getText("IGUI_Gametime_secondes")

    end

end

Jukebox.loadModOptions()

-- Number of batches for updating sound.
-- New jukeboxes are randomly assigned a batch number from 1 to batches (below).
-- OnTick, if the jukebox's batch number is up, it will update. This makes it so that
-- a server running 10 jukeboxes will not update them all on the same tick, but on unique ticks.
-- Running hundreds of jukeboxes would start to require more than one jukebox to update per tick, 
-- but this should be manageable within reason, and much more manageable than the alternative of 
-- updating every jukebox on the same tick.
Jukebox.batches = 10

-- Cycles from 1 - batches during updateSound.
Jukebox.batchIndex = Jukebox.batches

-- Used to prevent sending duplicate signals through server from multiple clients.
Jukebox.ticksBeforeCycle = 100000

-- Nonlinear volume magic.
Jukebox.volumes = {
	[1] = 0.02,
	[2] = 0.05,
	[3] = 0.10,
	[4] = 0.20,
	[5] = 0.30,
	[6] = 0.40,
	[7] = 0.50,
	[8] = 0.60,
	[9] = 0.70,
	[10] = 0.80,
	[11] = 1.00
}

Jukebox.volumesIndex = {
	[Jukebox.volumes[1]] = 1,
	[Jukebox.volumes[2]] = 2,
	[Jukebox.volumes[3]] = 3,
	[Jukebox.volumes[4]] = 4,
	[Jukebox.volumes[5]] = 5,
	[Jukebox.volumes[6]] = 6,
	[Jukebox.volumes[7]] = 7,
	[Jukebox.volumes[8]] = 8,
	[Jukebox.volumes[9]] = 9,
	[Jukebox.volumes[10]] = 10,
	[Jukebox.volumes[11]] = 11
}

-- Time of Day Conversion Factor
Jukebox.realHoursPerDayIndex = {
	[1] = 0.25, [2] = 0.50, [3] = 1, [4] = 2, [5] = 3, 
	[6] = 4, [7] = 5, [8] = 6, [9] = 7, [10] = 8, [11] = 9, 
	[12] = 10, [13] = 11, [14] = 12, [15] = 12, [16] = 14, 
	[17] = 15, [19] = 16, [20] = 17, [21] = 18, [22] = 19, 
	[23] = 20, [24] = 21, [25] = 22, [26] = 23, [27] = 24
}

Jukebox.getTime = function() 
	return GameTime.getInstance():getTimeOfDay()
end

-- In this mod:
-- position => float x, y, z
-- location => floored { x, y, z } (as a table where [x] = floored x coordinate)
-- key => floored "x, y, z" (as a string with spaces)
Jukebox.dataToKey = function(jukeboxData)
	if not jukeboxData then return end

	local x = math.floor(jukeboxData.x)
	local y = math.floor(jukeboxData.y)
	local z = math.floor(jukeboxData.z)

	return x .. ", " .. y .. ", " .. z
end

Jukebox.squareToKey = function(square)
	if not square then return end

	local x = math.floor(square:getX())
	local y = math.floor(square:getY())
	local z = math.floor(square:getZ())

	return x .. ", " .. y .. ", " .. z
end

Jukebox.keyToLocation = function(key)
	if not key then return end

	local xyz = string.split(key, ", ")

	local x = tonumber(xyz[1])
	local y = tonumber(xyz[2])
	local z = tonumber(xyz[3])

	return { x = x, y = y, z = z } 
end

-- Shallow table copy. We only use this to copy queues during various updates.
Jukebox.shallowCopy = function(original)
	if not original then return end
	
	local copy = {}

	for key, value in pairs(original) do
		copy[key] = value
	end

	return copy
end

----------------------------------

Jukebox.addBatchedKey = function(key, batch)
	if not (key and batch) then return end

	local keyData = Jukebox.batchedKeyData[batch]

	if not keyData[key] then 
		keyData[key] = true -- location is now in the table
		keyData[#keyData + 1] = key
	end
end

Jukebox.removeBatchedKey = function(key, batch, index)
	if not (key and batch) then return end

	local keyData = Jukebox.batchedKeyData[batch]

	if keyData[key] then
		if index and keyData[index] == key then
			table.remove(keyData, index)
			keyData[key] = nil
			return
		end

		for index, value in ipairs(keyData) do
			if value == key then
				table.remove(keyData, index)
				keyData[key] = nil
				return
			end
		end 
	end
end
----------------------------------

Jukebox.initializeTimeVariables = function()
	if Jukebox.timeVariablesInitialized then return end

	Jukebox.timeVariablesInitialized = true

	-- Initialize realHoursPerDay
	Jukebox.realHoursPerDay = Jukebox.realHoursPerDayIndex[SandboxVars.DayLength]

	Jukebox.oneRealHalfSecond = (1 / 7200) * (24 / Jukebox.realHoursPerDay)
end

Jukebox.beginActiveTracks = function()

	if Jukebox.ready then return end
	-- Initialize max range based on sandbox options.
	Jukebox.maxRange = SandboxVars.TrueMusicJukebox and SandboxVars.TrueMusicJukebox.maxRange or Jukebox.maxRange

	Jukebox.initializeTimeVariables()

	Jukebox.feedback = Jukebox.feedback or JukeboxFeedback:new(0, 60, { r = 0, g = 0, b = 0, a = 1 })

	local locationsNeedingCleared = {}

	local locationsNeedCleared = false

	for key, jukeboxData in pairs(Jukebox.activeLocations) do repeat
		if jukeboxData == true then -- Prior version of this mod. Clear data and be done.
			Jukebox.activeLocations[key] = nil
			locationsNeedingCleared[key] = true
			locationsNeedCleared = true
			break
		end
		
		local location = Jukebox.keyToLocation(key)

		if not location then break end

		local x = location.x
		local y = location.y
		local z = location.z
 
		local square = getSquare(x, y, z)

		local jukebox = square and Jukebox.getEvolvedJukebox(square)

		if square and not jukebox then -- Jukebox moved; clear data and move along.
			Jukebox.removeBatchedKey(key, jukeboxData.batch)
			Jukebox.activeLocations[key] = nil
			locationsNeedingCleared[key] = true
			locationsNeedCleared = true
			break
		end
		
		Jukebox.addBatchedKey(key, jukeboxData.batch)

		-- Guarantee that these variables exist.
		jukeboxData.x = x
		jukeboxData.y = y
		jukeboxData.z = z

		local player = getPlayer() -- Doesn't really matter if player 1 or 2 in splitscreen.
		
		jukeboxData.player = {
			x = math.floor(player:getX()),
			y = math.floor(player:getY()),
			z = math.floor(player:getZ())
		}

		-- Just accept latest mod data if you can't check the object to confirm.
		local playlistReady = true

		-- By default, playlist assumed ready, but if we can access jukebox and find it's empty,
		-- we'll change our minds. As far as I know this is not easily reduced to one line in
		-- combination with the line above. :(
		if jukebox then playlistReady = Jukebox.initializePlaylist(jukebox, jukeboxData) end

		if playlistReady then
			local playlistSize = #jukeboxData.playlist
			jukeboxData.currentIndex = (jukeboxData.currentIndex and math.min(math.max(jukeboxData.currentIndex, 1), playlistSize)) or 1
		end

		if playlistReady and jukeboxData.hasPlayableTracks and jukeboxData.on then
			jukeboxData.currentIndex = jukeboxData.currentIndex or 1
			-- Only play locally (for this client when it connects).
			-- First song will end early as though skipped to stay in
			-- sync with other players.
			Jukebox.playSound(jukeboxData, Jukebox.getCurrentTrack(jukeboxData), false, true)
		end

	until true end

	if locationsNeedCleared then
		sendClientCommand("TrueMusicJukebox", "clear", locationsNeedingCleared)
	end

	ModData.transmit("Jukebox.activeLocations")

	sendClientCommand("TrueMusicJukebox", "transmit", Jukebox.activeLocations)

	-- Requests missing locations; updateSound will handle them eventually.
	sendClientCommand(getPlayer(), "TrueMusicJukebox", "request", {}) -- Any player on this client is fine.

	Jukebox.ready = true

end

Jukebox.awaitClientCommandAbility = function()
	Jukebox.waitTicks = (Jukebox.waitTicks and (Jukebox.waitTicks - 1)) or 5

	if Jukebox.waitTicks == 5 then
		Events.OnTick.Add(Jukebox.awaitClientCommandAbility)
	elseif Jukebox.waitTicks == 0 then
		Jukebox.waitTicks = nil
		Events.OnTick.Remove(Jukebox.awaitClientCommandAbility)
		Jukebox.beginActiveTracks()
	end
end

Events.OnCreatePlayer.Add(Jukebox.awaitClientCommandAbility)

Jukebox.processClientsideLocationData = function()
	Jukebox.activeLocations = ModData.getOrCreate("Jukebox.activeLocations")
	Jukebox.batchedKeyData = {}

	for index = 1, Jukebox.batches do
		Jukebox.batchedKeyData[index] = {}
	end

	ModData.transmit("Jukebox.activeLocations")
end

if not isServer() then Events.OnInitGlobalModData.Add(Jukebox.processClientsideLocationData) end

-- Checking for Game Sounds

Jukebox.getSoundFile = function(itemType)
	return itemType and GameSounds.getSound(itemType) and GameSounds.getSound(itemType):getRandomClip():getFile()
end

-- Track Utility Functions

Jukebox.prettyName = function(displayName)
	-- Example: Cassette - Michael Cassette - My Name Is Michael Cassette
	prettyName = displayName:gsub("Vinyl %-", "", 1) -- Remove first instance of the word Vinyl followed by a hyphen.
	prettyName = prettyName:gsub("Cassette %-", "", 1) -- Remove first instance of the word Cassette followed by a hyphen.
	prettyName = prettyName:gsub("Vinyl", "", 1) -- Remove first instance of the word Vinyl (if no "Vinyl -" found, this will be found).
	prettyName = prettyName:gsub("Cassette", "", 1) -- Remove first instance of the word Cassette (same as above for cassettes).
	prettyName = prettyName:gsub("^%s*(.-)%s*$", "%1") -- Remove leading and trailing whitespace.
	return prettyName --> Michael Cassette - My Name Is Michael Cassette
end

Jukebox.enqueueTrack = function(jukeboxData, trackType)
	if not jukeboxData.queue[trackType] then
		jukeboxData.queue[trackType] = true
		jukeboxData.queueSize = jukeboxData.queueSize + 1
	end
end

Jukebox.dequeueTrack = function(jukeboxData, trackType)
	if jukeboxData.queue[trackType] then
		jukeboxData.queue[trackType] = nil
		jukeboxData.queueSize = jukeboxData.queueSize - 1
	end
end

Jukebox.requeueTrack = function(jukeboxData, trackType)
	if not trackType then return end

	Jukebox.removeTrack(jukeboxData, trackType)
	-- Must do this after the dequeue adjusts the playlist's index.
	local nextIndex = Jukebox.getNextIndex(jukeboxData)
	local possibleNext = (nextIndex + jukeboxData.queueSize) % #jukeboxData.playlist
	nextIndex = (possibleNext == 0 and #jukeboxData.playlist) or possibleNext
	Jukebox.enqueueTrack(jukeboxData, trackType)
	Jukebox.insertTrack(jukeboxData, trackType, nil, nextIndex)
end

-- Intended to avoid throwing away queue data when timing of commands is unpredictable.
Jukebox.mergeQueues = function(jukeboxDataClientside, jukeboxDataInbound)

	if not (type(jukeboxDataClientside) == "table" and type(jukeboxDataInbound) == "table") then return end 

	local newQueue = {}

	newQueueSize = 0

	for key in pairs(jukeboxDataClientside.queue) do
		if not newQueue[key] then
			newQueue[key] = true
			newQueueSize = newQueueSize + 1
		end
	end

	for key in pairs(jukeboxDataInbound.queue) do
		if not newQueue[key] then
			newQueue[key] = true
			newQueueSize = newQueueSize + 1
		end
	end

	return { queue = newQueue, queueSize = newQueueSize }

end

-- Add track to current playlist
Jukebox.insertTrack = function(jukeboxData, trackType, trackName, trackIndex) 
    local playlist = jukeboxData.playlist 

	trackIndex = trackIndex or (#playlist + 1)

	table.insert(jukeboxData.playlist, trackIndex, trackType)

	-- Used to convert types to full names.

	if not trackName then return end

	jukeboxData.titles[trackType] = Jukebox.prettyName(trackName)
end

-- Remove trackType from playlist
Jukebox.removeTrack = function(jukeboxData, trackType)
    local playlist = jukeboxData.playlist
    if not playlist then return end -- The playlist for this jukebox has never been created.

	local currentIndex = jukeboxData.currentIndex
    for index, value in ipairs(playlist) do
        if value == trackType then
			local skipNeeded = false
			local shift = 0

			if index == currentIndex then
				skipNeeded = true
			end

			Jukebox.dequeueTrack(jukeboxData, trackType)
			
            table.remove(jukeboxData.playlist, index)

			if index < currentIndex then 
				-- Tracks just shifted; fix current index.
				-- currentIndex must be at least 2, or else this will not happen.
				jukeboxData.currentIndex = currentIndex - 1
				shift = -1
			end

			if #jukeboxData.playlist == 0 then
				local key = Jukebox.dataToKey(jukeboxData)
				if Jukebox.activeTracks[key] and Jukebox.activeTracks[key].sound then
					Jukebox.activeTracks[key].sound:stop()
					Jukebox.activeTracks[key] = nil
				end
				if jukeboxData.on then
					local square = getSquare(jukeboxData.x, jukeboxData.y, jukeboxData.z)
					if square then square:playSound("LightSwitch") end
					jukeboxData.on = false
				end
				sendClientCommand("TrueMusicJukebox", "transmit", {[key] = jukeboxData})
			elseif skipNeeded then
				sendClientCommand("TrueMusicJukebox", "transmit", {[key] = jukeboxData})
				sendClientCommand("TrueMusicJukebox", "move", jukeboxData)
			end

			ModData.transmit("Jukebox.activeLocations")

            return index, shift
        end
    end
end

Jukebox.clearQueue = function(jukeboxData)

	if not jukeboxData then return end

	jukeboxData.queue = {}
	jukeboxData.queueSize = 0

end

-------------------------
-- Last, Current, Next --
-------------------------
Jukebox.getPriorIndex = function(jukeboxData)
	local currentIndex = jukeboxData.currentIndex
	local lastIndex = #jukeboxData.playlist
	return currentIndex - 1 == 0 and lastIndex or currentIndex - 1
end
Jukebox.getNextIndex = function(jukeboxData)
	local currentIndex = jukeboxData.currentIndex
	return (currentIndex % #jukeboxData.playlist) + 1
end
Jukebox.getPriorTrack = function(jukeboxData)
	return jukeboxData.playlist[Jukebox.getPriorIndex(jukeboxData)]
end
Jukebox.getCurrentTrack = function(jukeboxData)
	return jukeboxData.playlist[jukeboxData.currentIndex]
end
Jukebox.getNextTrack = function(jukeboxData)
	return jukeboxData.playlist[Jukebox.getNextIndex(jukeboxData)]
end
Jukebox.getPriorTitle = function(jukeboxData)
	return jukeboxData.titles[Jukebox.getPriorTrack(jukeboxData)]
end
Jukebox.getCurrentTitle = function(jukeboxData)
	return jukeboxData.titles[Jukebox.getCurrentTrack(jukeboxData)]
end
Jukebox.getNextTitle = function(jukeboxData)
	return jukeboxData.titles[Jukebox.getNextTrack(jukeboxData)]
end
Jukebox.getTrackIndex = function(jukeboxData, trackType)
	for index in ipairs(jukeboxData.playlist) do
		if jukeboxData.playlist[index] == trackType then return index end
	end
end

Jukebox.random = function(max)
    return ZombRand(max) + 1
end

Jukebox.shuffle = function(jukeboxData)

	if not jukeboxData then return {} end

	local currentTrack = Jukebox.getCurrentTrack(jukeboxData)

	local playlist = jukeboxData.playlist

	local playlistShuffled = {}
	local tracksRequiringRequeue = {}
	
	while #playlist > 0 do
		local next = Jukebox.random(#playlist)
		if jukeboxData.queue[playlist[next]] then
			tracksRequiringRequeue[#tracksRequiringRequeue + 1] = playlist[next]
		else
			playlistShuffled[#playlistShuffled + 1] = playlist[next]
		end
		
		table.remove(playlist, next)
	end

	jukeboxData.playlist = playlistShuffled

	if currentTrack then
		local newIndex = Jukebox.getTrackIndex(jukeboxData, currentTrack)
		jukeboxData.currentIndex = newIndex or 1
	end

	for index, value in ipairs(tracksRequiringRequeue) do
		local adjustment = index -- if track not in the queue, i.e., if queue is unlocked.
		if currentTrack and jukeboxData.queue[currentTrack] then 
			-- queue is locked because otherwise now playing track would dequeue.
			adjustment = adjustment - 1 
		end
		table.insert(jukeboxData.playlist, jukeboxData.currentIndex + adjustment, value)
	end

end

Jukebox.initializePlaylist = function(jukebox, jukeboxData)

	local jukeboxItems = jukebox:getItemContainer():getItems()

	local key = Jukebox.dataToKey(jukeboxData)

	-- Making sure hasPlayableTracks is true will prevent this from spamming
	-- the network with transmit calls; clients will do this exactly once each at most before
	-- data will hopefully be synced. Some clients may never do this if another client fixes
	-- their data by network transfer before this event triggers.
	if jukeboxData.hasPlayableTracks and (not jukeboxItems or jukeboxItems:size() == 0) then 
		jukeboxData.playlist = {}
		jukeboxData.playlistSize = 0
		jukeboxData.hasPlayableTracks = false
		sendClientCommand("TrueMusicJukebox", "transmit", {[key] = jukeboxData})
		ModData.transmit("Jukebox.activeLocations")
		return 
	end

	local tracksRequiringRequeue = {}

	-- If this playlist has the right size, we assume we're good; otherwise we recreate it now.
	if jukeboxData.playlistSize == jukeboxItems:size() then 
		return true
	else
		local currentTrack = Jukebox.getCurrentTrack(jukeboxData)

		jukeboxData.playlist = {}
		jukeboxData.playlistSize = 0
		jukeboxData.hasPlayableTracks = false

		local alreadyInserted = {}
		-- Save titles so we can pass them without complex objects from server to client.
		for index = 1, jukeboxItems:size() do
			local item = jukeboxItems:get(index - 1)
			if item and item.getType and item.getDisplayName and 
			   Jukebox.getSoundFile(item:getType()) and not alreadyInserted[item:getType()] then
				alreadyInserted[item:getType()] = true
				if jukeboxData.queue[item:getType()] then
					tracksRequiringRequeue[#tracksRequiringRequeue + 1] = item:getType()
				end
				Jukebox.insertTrack(jukeboxData, item:getType(), item:getDisplayName())
				if (not jukeboxData.hasPlayableTracks) and Jukebox.getSoundFile(item:getType()) then
					jukeboxData.hasPlayableTracks = true
				end
			end
		end

		if currentTrack then
			jukeboxData.currentIndex = Jukebox.getTrackIndex(jukeboxData, currentTrack) or 1 -- Fuckin woops.
		end

		jukeboxData.queue = {}
		jukeboxData.queueSize = 0

		for index, trackType in ipairs(tracksRequiringRequeue) do
			if Jukebox.getTrackIndex(jukeboxData, trackType) then
				Jukebox.removeTrack(jukeboxData, trackType)
				Jukebox.insertTrack(jukeboxData, trackType, nil, jukeboxData.currentIndex + index)
				Jukebox.enqueueTrack(jukeboxData, trackType)
			end
		end

		jukeboxData.playlistSize = jukeboxItems:size()
	end

	sendClientCommand("TrueMusicJukebox", "transmit", {[key] = jukeboxData})
	ModData.transmit("Jukebox.activeLocations")

	return true
end

Jukebox.seekNextQueuedIndex = function(jukeboxData)
	local loopingIndex = (jukeboxData.currentIndex % #jukeboxData.playlist) + 1

	local somethingInTheWay = {}

	local targetIndex = jukeboxData.currentIndex

	while loopingIndex ~= jukeboxData.currentIndex and jukeboxData.currentIndex do
		local trackType = jukeboxData.playlist[loopingIndex]
		if jukeboxData.queue[trackType] then
			targetIndex = loopingIndex
			break
		else
			somethingInTheWay[trackType] = true
			table.remove(jukeboxData.playlist, loopingIndex)
			loopingIndex = ((loopingIndex - 1) == 0 and #jukeboxData.playlist) or (loopingIndex - 1)			
		end
		loopingIndex = (loopingIndex % #jukeboxData.playlist) + 1
	end

	local rawIndexAfterQueue = (jukeboxData.currentIndex + jukeboxData.queueSize + 1) % #jukeboxData.playlist
	
	local realIndexAfterQueue = (rawIndexAfterQueue == 0 and #jukeboxData.playlist) or rawIndexAfterQueue

	for trackType in pairs(somethingInTheWay) do
		
		table.insert(jukeboxData.playlist, realIndexAfterQueue, trackType)
	end

	return targetIndex
end

Jukebox.activeTracks = {}
Jukebox.activeLocations = {}

-- Default if not set by SandboxVars.
Jukebox.maxRange = 50

Jukebox.playSound = function(jukeboxData, trackType, playNow, beginMuted)
	if not (jukeboxData and trackType) then return end

	local key = Jukebox.dataToKey(jukeboxData)

	local bail = false

	if Jukebox.activeTracks[key] then 
		-- elapsed is used for stutter-start prevention.
		if playNow and Jukebox.activeTracks[key].elapsed > 15 then
			Jukebox.activeTracks[key].sound:stop()
		else 
			bail = true
		end
	end

	jukeboxData.skip = false
	
	jukeboxData.replayedFromQueue = false

	if bail then return end

	Jukebox.dequeueTrack(jukeboxData, trackType)

	local player = getPlayer() -- Just needs to be any local player with a valid location.

	if player and player:getX() then
		jukeboxData.player = {
			x = math.floor(player:getX()),
			y = math.floor(player:getY()),
			z = math.floor(player:getZ())
		}
	else return end
	
	-- We get this every time because it may change and it doesn't take long.
	-- In the future, we could use a global variable here and a Mod Options update
	-- function, but that's micro-optimization in Burryaga's stupid opinion.
	local threeDimensionalAudio = (SandboxVars.TrueMusicJukebox and SandboxVars.TrueMusicJukebox.forceThreeDimensionalAudio) or Jukebox.mod.options.threeDimensionalAudio
	
	local sound = JukeboxSound:new()

	sound.priorThreeDimensionalAudioState = threeDimensionalAudio

	if threeDimensionalAudio then
		sound:setPosition(jukeboxData.x, jukeboxData.y, jukeboxData.z)
	else
		sound:setPosition(jukeboxData.player.x, jukeboxData.player.y, jukeboxData.player.z)
	end

	if beginMuted then
		sound:setVolume(0, Jukebox.maxRange)
	else
		sound:setVolume(jukeboxData.volume, Jukebox.getDistance(jukeboxData))
	end

	sound:set3D(threeDimensionalAudio)
	sound:play(trackType)

	Jukebox.activeTracks[key] = {
		sound = sound,
		trackType = trackType,
		x = jukeboxData.x,
		y = jukeboxData.y,
		z = jukeboxData.z,
		player = jukeboxData.player,
		batch = jukeboxData.batch,
		elapsed = 0
	}
	
	Jukebox.activeLocations[key] = jukeboxData
	Jukebox.addBatchedKey(key, jukeboxData.batch)
	sendClientCommand("TrueMusicJukebox", "transmit", {[key] = jukeboxData, x = jukeboxData.x, y = jukeboxData.y, z = jukeboxData.z})
	ModData.transmit("Jukebox.activeLocations")
	
	return Jukebox.activeTracks[key]
end

Jukebox.getDistanceToPlayer = function(jukeboxData, player)

	local xDifferenceSquared = (player:getX() - jukeboxData.x) ^ 2
	local yDifferenceSquared = (player:getY() - jukeboxData.y) ^ 2
	local zDifferenceSquared = (player:getZ() - jukeboxData.z) ^ 2

	return math.sqrt(xDifferenceSquared + yDifferenceSquared + zDifferenceSquared)

end

Jukebox.hasLoaded = function(container, trackType) 

	return container and trackType and container:getItemFromType(trackType) and true or false

end

Jukebox.getDistance = function(jukeboxData)

	local distance = 0

	local activePlayersFound = 0

	for index = 0, getNumActivePlayers() do repeat
				
		local player = getSpecificPlayer(index)

		if not player then break end

		activePlayersFound = activePlayersFound + 1
		
		-- Distance is average of all local players. 
		-- Sound will be loudest if both players are
		-- near the jukebox.
		distance = distance + Jukebox.getDistanceToPlayer(jukeboxData, player)

	until true end

	-- Mute sound if no players can be found.
	if activePlayersFound < 1 then 
		distance = Jukebox.maxRange 
	else
		distance = distance / activePlayersFound
	end

	return distance

end

Jukebox.replace = function(jukebox)
	local key = Jukebox.squareToKey(jukebox:getSquare())

	-- If value is not true, then it is either nil or a table.
	Jukebox.activeLocations[key] = (Jukebox.activeLocations[key] ~= true and Jukebox.activeLocations[key]) or {}

	local jukeboxData = Jukebox.activeLocations[key]

	if jukeboxData.version ~= Jukebox.version or not jukebox:getContainer() then
		local square = jukebox:getSquare()
		local sprite = jukebox:getSprite():getName()
		local index = jukebox:getObjectIndex()

		if not jukebox:getContainer() then -- Otherwise, it's already an evolved jukebox.
			sledgeDestroy(jukebox)
			jukebox:getSquare():transmitRemoveItemFromSquareOnServer(jukebox)
			jukebox:getSquare():transmitRemoveItemFromSquare(jukebox)

			jukebox = IsoThumpable.new(getCell(), square, sprite, false, ISWoodenContainer:new(sprite, nil))
			jukebox:setIsContainer(true)
			jukebox:getContainer():setType("jukebox")
			-- Our capacity goes to eleventy
			jukebox:getContainer():setCapacity(110)

			square:AddTileObject(jukebox, index)
			square:transmitAddObjectToSquare(jukebox, jukebox:getObjectIndex())
			square:transmitModdata()
			jukebox:transmitCompleteItemToServer()
			jukebox:transmitUpdatedSpriteToServer()

			-- New jukebox, new mod data.
			-- jukeboxData = jukebox:getModData()
			Jukebox.activeLocations[key] = {}

			jukeboxData = Jukebox.activeLocations[key]	
		end

		jukeboxData.x = math.floor(jukebox:getX())
		jukeboxData.y = math.floor(jukebox:getY())
		jukeboxData.z = math.floor(jukebox:getZ())	

		-- See Jukebox/Utility.lua
		-- batchIndex changes OnTick, so Jukebox
		-- will be assigned a somewhat unpredictable index
		-- between 1 and batches (the max number of batches).
		-- This is better than starting at 1, because then when
		-- Jukeboxes sync between clients on play, it is highly
		-- unlikely they will all stack up in batch 1 (i.e.,
		-- in the same batch, thus defeating the purpose of batches).
		jukeboxData.batch = Jukebox.batchIndex

		-- jukeboxData.tick = 0

		jukeboxData.on = false
		jukeboxData.skip = false
		
		jukeboxData.currentIndex = 1
		jukeboxData.volume = Jukebox.volumes[6]

		jukeboxData.hasPlayableTracks = false

		-- Types
		jukeboxData.playlist = {}
		-- Size of Playlist
		jukeboxData.playlistSize = 0
		-- Queue
		jukeboxData.queue = jukeboxData.queue or {} --> Preserves old queue
		-- Size of Queue
		jukeboxData.queueSize = jukeboxData.queueSize or 0 --> Preserves old queueSize

		-- Queue Mode
		jukeboxData.queueLocked = false

		-- Get Index of Type in the Above List
		-- jukeboxData.playlistIndex = {}

		-- Get Pretty Title of Type
		-- Never needs to be reordered or adjusted because
		-- once there is a stored pretty name for a given type (i.e., 
		-- for a given track id), that track's pretty name
		-- can be recovered from its type no matter the order of the
		-- playlist; we don't even need to care if titles get
		-- removed from Jukebox because space used here is trivial. 
		jukeboxData.titles = {}

		-- Used to force updates on existing jukeboxes.
		jukeboxData.version = Jukebox.version

		ModData.transmit("Jukebox.activeLocations")

		sendClientCommand("TrueMusicJukebox", "transmit", {[key] = jukeboxData})
	end

	return jukebox
end

-- Only called by getEvolvedJukebox, so square must exist.
Jukebox.getVanillaMachine = function(square)
	local objects = square:getObjects()
	for index = 1, objects:size() - 1 do
		local thisObject = objects:get(index)
		local sprite = thisObject:getSprite()
		if sprite then
			local properties = sprite:getProperties()
			if properties:Val("CustomName") == "Jukebox" then
				return thisObject
			end
		end
	end
end

Jukebox.getEvolvedJukebox = function(square)
	if not square then return end

    local jukebox = Jukebox.getVanillaMachine(square)

    if jukebox then
        return Jukebox.replace(jukebox)
    end
end

Jukebox.logCurrentTime = function()
	print(Jukebox.getTime() * 3600)
end

Jukebox.updateSound = function()
	if not Jukebox.ready then return end --> True Music Jukebox has not yet initialized properly.

	Jukebox.batchIndex = (Jukebox.batchIndex % Jukebox.batches) + 1

	local threeDimensionalAudio = (SandboxVars.TrueMusicJukebox and SandboxVars.TrueMusicJukebox.forceThreeDimensionalAudio) or Jukebox.mod.options.threeDimensionalAudio

	local keyData = Jukebox.batchedKeyData[Jukebox.batchIndex]
	
	-- For each jukebox that is playing music in this batch...
	for index = #keyData, 1, -1 do repeat
		local key = keyData[index]
		local jukeboxData = key and Jukebox.activeLocations[key]

		if not jukeboxData then break end -- Something wonky; maybe transitioning.
	
		-- Destroy deprecated Jukebox data.
		if jukeboxData == true then 
			Jukebox.activeLocations[key] = nil
			sendClientCommand("TrueMusicJukebox", "clear", {[key] = true})
			ModData.transmit("Jukebox.activeLocations")
			break
		end

		-- In theory no longer needed
		-- if jukeboxData.batch ~= Jukebox.batchIndex then break end

		local activeTrack = Jukebox.activeTracks[key]

		if jukeboxData and not jukeboxData.on then 
			if Jukebox.activeTracks[key] then
				activeTrack.sound:stop()
				Jukebox.activeTracks[key] = nil
			end
			break 
		end

		if activeTrack then
			activeTrack.elapsed = activeTrack.elapsed + 1
		end

		local sound = activeTrack and activeTrack.sound

		local location = Jukebox.keyToLocation(key)

		local square = getSquare(location.x, location.y, location.z)

		local jukebox = square and Jukebox.getEvolvedJukebox(square)
	
		if square and not jukebox then --> Jukebox moved, destroy active location.
			Jukebox.activeLocations[key] = nil
			Jukebox.removeBatchedKey(key, jukeboxData.batch, index)
			sendClientCommand("TrueMusicJukebox", "clear", {[key] = true, x = location.x, y = location.y, z = location.z})
			ModData.transmit("Jukebox.activeLocations")
			break
		end

		if not (jukeboxData and jukeboxData.on) then --> Jukebox off. Destroy sound record.
			if sound then
				activeTrack.sound:stop()
				Jukebox.activeTracks[key] = nil
			end
			break 
		end

		local powerProblems = square and not ((SandboxVars.AllowExteriorGenerator and square:haveElectricity()) or (SandboxVars.ElecShutModifier > -1 
			and GameTime:getInstance():getNightsSurvived() < SandboxVars.ElecShutModifier and square:isOutside() == false))

		if jukeboxData.on and powerProblems then
			jukeboxData.on = false
			if activeTrack then
				activeTrack.sound:stop()
				Jukebox.activeTracks[key] = nil
			end
			break
		end

		if jukebox then 
			Jukebox.initializePlaylist(jukebox, jukeboxData)
		end

		local playlist = jukeboxData.playlist

		jukeboxData.currentIndex = (jukeboxData.currentIndex and math.min(jukeboxData.currentIndex, #playlist)) or 1
		
		if (not activeTrack) and jukeboxData.on and (#playlist > 0) and not jukeboxData.skip then
			jukeboxData.currentIndex = (jukeboxData.currentIndex and math.min(math.max(jukeboxData.currentIndex, 1), #playlist)) or 1
			-- A sound was never initialized on this location for this client.
			-- Would presumably result from joining server far away from an
			-- active jukebox, thus preventing it from getting logged in this
			-- client's activeTracks object. If we detect a jukebox at a location
			-- we expect to be playing something, let's try to make that happen.
			-- Jukebox.playSound(jukeboxData, Jukebox.getCurrentTrack(jukeboxData), false, false)

			-- Maaaybe not...
			sendClientCommand("TrueMusicJukebox", "play", jukeboxData)
			break
		end
		
		local readyForNextTrack = activeTrack and jukeboxData.on and #playlist > 0

		if not sound then break end

		-- Toggle 3D Audio Safely at Long Range
		if sound.priorThreeDimensionalAudioState ~= threeDimensionalAudio then
			sound:set3D(threeDimensionalAudio)
			if threeDimensionalAudio then
				sound:setPosition(jukeboxData.x, jukeboxData.y, jukeboxData.z)
			else
				sound:setPosition(jukeboxData.player.x, jukeboxData.player.y, jukeboxData.player.z)
				if not square then
					sound:play(Jukebox.getCurrentTrack(jukeboxData)) -- Need to replay this sound to make it audible.
				end
			end
		end

		sound.priorThreeDimensionalAudioState = threeDimensionalAudio
		
		local tracksWereRequeued = false

		if Jukebox.delayedRequeueRequests and Jukebox.delayedRequeueRequests[key] then
			for index = #Jukebox.delayedRequeueRequests[key], 1, -1 do
				local requeueData = Jukebox.delayedRequeueRequests[key][index]
				requeueData.delay = requeueData.delay - 1

				if requeueData.delay == 0 then
					tracksWereRequeued = true
					Jukebox.delayedRequeueRequests[key][requeueData.trackType] = nil
					Jukebox.requeueTrack(jukeboxData, requeueData.trackType)
					table.remove(Jukebox.delayedRequeueRequests[key], index)
				end
			end
			
			if #Jukebox.delayedRequeueRequests[key] == 0 then
				Jukebox.delayedRequeueRequests[key] = nil
			end
		end

		if tracksWereRequeued then
			sendClientCommand("TrueMusicJukebox", "transmit", {[key] = jukeboxData})
			ModData.transmit("Jukebox.activeLocations")
		end

		sound:tick()
		
		if sound:isPlaying() then
			if jukeboxData.skip then
				sendClientCommand("TrueMusicJukebox", "play", jukeboxData)
				jukeboxData.skip = false
			elseif jukebox and not Jukebox.hasLoaded(jukebox:getContainer(), sound:getSoundType()) then
				if #jukeboxData.playlist == 0 then
					Jukebox.activeTracks[key].sound:stop()
					Jukebox.activeTracks[key] = nil
				elseif not sound.changing then
					-- This variable is set when a command has been issued to the server
					-- and the client is awaiting the completion of said command to reduce
					-- spamming server with pointless requests. 
					sound.changing = true

					-- Letting server handle skip will utilize jukebox tick to prevent
					-- double-skipping after tracks in playlist end.
					sendClientCommand("TrueMusicJukebox", "skip", {key = key})
				end
				break
			end

			if jukebox and SandboxVars.TrueMusicJukebox and SandboxVars.TrueMusicJukebox.jukeboxesAttractZombies then
				-- Pulling too many zombies to one location crashes the server hard. This should reduce this issue when using massive ranges.
				local maxRangeAdjustedForServerSafety = math.min(Jukebox.maxRange, 110)
				addSound(jukebox, jukebox:getX(), jukebox:getY(), jukebox:getZ(), maxRangeAdjustedForServerSafety, maxRangeAdjustedForServerSafety)
			end

			local distance = Jukebox.getDistance(jukeboxData)

			if sound:getVolume() ~= jukeboxData.volume or sound:getLastDistance() ~= distance then
				sound:setVolume(jukeboxData.volume, distance)
			end
		elseif readyForNextTrack and not sound.changing then
			-- Letting server handle skip will utilize jukebox tick to prevent
			-- double-skipping after tracks in playlist end.
			sound.changing = true
			sendClientCommand("TrueMusicJukebox", "skip", {key = key})
		end
	until true end
end

if not isServer() then Events.OnTick.Add(Jukebox.updateSound) end

-- Function for checking whether joypad player is active safely from Wookiee Gamepad Support.

Jukebox.getJoypadData = function(playerIndex)

    if not playerIndex then playerIndex = 0 end

    return JoypadState.players[playerIndex + 1]

end

-- Function for helping people read jukebox feedback if the Say font is too small for them.

Jukebox.reportMessage = function(player, message)

	if not (player and message) then return end

	if Jukebox.feedback and player:isAlive() and not Jukebox.mod.options.feedbackAccessibilityMode then
		if not Jukebox.mod.options.alwaysTellMyFriends then
			player:Say(message)
		end		
	else
		Jukebox.feedback:show(message)
	end 

	if Jukebox.mod.options.alwaysTellMyFriends then
		player:SayShout(message)
	end	

end
