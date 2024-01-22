require "Jukebox/Sound"
require "Jukebox/Objects"

local Jukebox = {}

local JukeboxSound = require("Jukebox/Sound")

Jukebox.version = 7

Jukebox.translation = {
	playNow = getText("UI_TrueMusicJukebox_playNow"),
	playNext = getText("UI_TrueMusicJukebox_playNext"),
	playLast = getText("UI_TrueMusicJukebox_playLast"),
	viewPlaylist = getText("UI_TrueMusicJukebox_viewPlaylist"),
	viewQueue = getText("UI_TrueMusicJukebox_viewQueue"),
	lockQueue = getText("UI_TrueMusicJukebox_lockQueue"),
	dequeue = getText("UI_TrueMusicJukebox_dequeue"),
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
	queueSpecificTrack = getText("UI_TrueMusicJukebox_queueSpecificTrack"),
	statusReport = getText("UI_TrueMusicJukebox_statusReport"),
	portableJukeboxKeys = getText("UI_TrueMusicJukebox_portableJukeboxKeys"),
	enablePortableJukeboxKey = getText("UI_TrueMusicJukebox_enablePortableJukeboxKey"),
	disablePortableJukeboxKey = getText("UI_TrueMusicJukebox_disablePortableJukeboxKey"),
	renameJukebox = getText("UI_TrueMusicJukebox_renameJukebox"),

	renameKeyBelow = getText("UI_TrueMusicJukebox_feedback_renameKeyBelow"),
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

	hideMenuIcons = getText("UI_TrueMusicJukebox_MO_hideMenuIcons"),
	hideTracklistFromContextMenu = getText("UI_TrueMusicJukebox_MO_hideTracklistFromContextMenu"),
	showEveryTrackInPortablePlaylist = getText("UI_TrueMusicJukebox_MO_showEveryTrackInPortablePlaylist"),
	showEveryTrackInJukeboxPlaylist = getText("UI_TrueMusicJukebox_MO_showEveryTrackInJukeboxPlaylist"),
	showEveryTrackInJukeboxQueue = getText("UI_TrueMusicJukebox_MO_showEveryTrackInJukeboxQueue"),
	threeDimensionalAudio = getText("UI_TrueMusicJukebox_MO_threeDimensionalAudio"),
	invertToggleIconFeedback = getText("UI_TrueMusicJukebox_MO_invertToggleIconFeedback"),
	ignoreDistanceWhenPlayingOverride = getText("UI_TrueMusicJukebox_MO_ignoreDistanceWhenPlayingOverride"),
	considerDistanceWhenPlayingOverride = getText("UI_TrueMusicJukebox_MO_considerDistanceWhenPlayingOverride"),
	alwaysTellMyFriends = getText("UI_TrueMusicJukebox_MO_alwaysTellMyFriends"),
	feedbackAccessibilityMode = getText("UI_TrueMusicJukebox_MO_feedbackAccessibilityMode"),
	accessibilityModeDisplayTime = getText("UI_TrueMusicJukebox_MO_accessibilityModeDisplayTime"),

	hideMenuIconsTooltip = getText("UI_TrueMusicJukebox_MO_hideMenuIcons_tooltip"),
	hideTracklistFromContextMenuTooltip = getText("UI_TrueMusicJukebox_MO_hideTracklistFromContextMenu_tooltip"),
	showEveryTrackInPortablePlaylistTooltip = getText("UI_TrueMusicJukebox_MO_showEveryTrackInPortablePlaylist_tooltip"),
	showEveryTrackInJukeboxPlaylistTooltip = getText("UI_TrueMusicJukebox_MO_showEveryTrackInJukeboxPlaylist_tooltip"),
	showEveryTrackInJukeboxQueueTooltip = getText("UI_TrueMusicJukebox_MO_showEveryTrackInJukeboxQueue_tooltip"),
	threeDimensionalAudioTooltip = getText("UI_TrueMusicJukebox_MO_threeDimensionalAudio_tooltip"),
	invertToggleIconFeedbackTooltip = getText("UI_TrueMusicJukebox_MO_invertToggleIconFeedback_tooltip"),
	ignoreDistanceWhenPlayingOverrideTooltip = getText("UI_TrueMusicJukebox_MO_ignoreDistanceWhenPlayingOverride_tooltip"),
	considerDistanceWhenPlayingOverrideTooltip = getText("UI_TrueMusicJukebox_MO_considerDistanceWhenPlayingOverride_tooltip"),
	alwaysTellMyFriendsTooltip = getText("UI_TrueMusicJukebox_MO_alwaysTellMyFriends_tooltip"),
	feedbackAccessibilityModeTooltip = getText("UI_TrueMusicJukebox_MO_feedbackAccessibilityMode_tooltip"),
	accessibilityModeDisplayTimeTooltip = getText("UI_TrueMusicJukebox_MO_accessibilityModeDisplayTime_tooltip"),

	jukeboxHero = getText("UI_TrueMusicJukebox_jukeboxHero"),
	jukeboxHeroTooltip = getText("UI_TrueMusicJukebox_jukeboxHero_tooltip")
}

Jukebox.mod = {

    options = {
		hideMenuIcons = false,
		invertToggleIconFeedback = false,
        hideTracklistFromContextMenu = false,
        showEveryTrackInPortablePlaylist = false,
        showEveryTrackInJukeboxPlaylist = false,
        showEveryTrackInJukeboxQueue = false,
		threeDimensionalAudio = false,
		ignoreDistanceWhenPlayingOverride = false,
		considerDistanceWhenPlayingOverride = false,
		alwaysTellMyFriends = false,
		feedbackAccessibilityMode = false,
		accessibilityModeDisplayTime = 4
    },

    names = {
		hideMenuIcons = Jukebox.translation.hideMenuIcons,
		invertToggleIconFeedback = Jukebox.translation.invertToggleIconFeedback,
        hideTracklistFromContextMenu = Jukebox.translation.hideTracklistFromContextMenu,
        showEveryTrackInPortablePlaylist = Jukebox.translation.showEveryTrackInPortablePlaylist,
        showEveryTrackInJukeboxPlaylist = Jukebox.translation.showEveryTrackInJukeboxPlaylist,
        showEveryTrackInJukeboxQueue = Jukebox.translation.showEveryTrackInJukeboxQueue,
		threeDimensionalAudio = Jukebox.translation.threeDimensionalAudio,
		ignoreDistanceWhenPlayingOverride = Jukebox.translation.ignoreDistanceWhenPlayingOverride,
		considerDistanceWhenPlayingOverride = Jukebox.translation.considerDistanceWhenPlayingOverride,
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

        local hideMenuIcons = Jukebox.modSettings:getData("hideMenuIcons")
        local hideTracklistFromContextMenu = Jukebox.modSettings:getData("hideTracklistFromContextMenu")
        local showEveryTrackInPortablePlaylist = Jukebox.modSettings:getData("showEveryTrackInPortablePlaylist")
        local showEveryTrackInJukeboxPlaylist = Jukebox.modSettings:getData("showEveryTrackInJukeboxPlaylist")
        local showEveryTrackInJukeboxQueue = Jukebox.modSettings:getData("showEveryTrackInJukeboxQueue")
		local threeDimensionalAudio = Jukebox.modSettings:getData("threeDimensionalAudio")
		local invertToggleIconFeedback = Jukebox.modSettings:getData("invertToggleIconFeedback")
		local ignoreDistanceWhenPlayingOverride = Jukebox.modSettings:getData("ignoreDistanceWhenPlayingOverride")
		local considerDistanceWhenPlayingOverride = Jukebox.modSettings:getData("considerDistanceWhenPlayingOverride")
		local alwaysTellMyFriends = Jukebox.modSettings:getData("alwaysTellMyFriends")
		local feedbackAccessibilityMode = Jukebox.modSettings:getData("feedbackAccessibilityMode")
		local accessibilityModeDisplayTime = Jukebox.modSettings:getData("accessibilityModeDisplayTime")

		hideMenuIcons.tooltip = Jukebox.translation.hideMenuIconsTooltip
        hideTracklistFromContextMenu.tooltip = Jukebox.translation.hideTracklistFromContextMenuTooltip
        showEveryTrackInPortablePlaylist.tooltip = Jukebox.translation.showEveryTrackInPortablePlaylistTooltip
        showEveryTrackInJukeboxPlaylist.tooltip = Jukebox.translation.showEveryTrackInJukeboxPlaylistTooltip
        showEveryTrackInJukeboxQueue.tooltip = Jukebox.translation.showEveryTrackInJukeboxQueueTooltip
		threeDimensionalAudio.tooltip = Jukebox.translation.threeDimensionalAudioTooltip
		invertToggleIconFeedback.tooltip = Jukebox.translation.invertToggleIconFeedbackTooltip
		ignoreDistanceWhenPlayingOverride.tooltip = Jukebox.translation.ignoreDistanceWhenPlayingOverrideTooltip
		considerDistanceWhenPlayingOverride.tooltip = Jukebox.translation.considerDistanceWhenPlayingOverrideTooltip
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

		function ignoreDistanceWhenPlayingOverride:onUpdate(value)
			if value then
				considerDistanceWhenPlayingOverride:set(false)
			end
		end

		function considerDistanceWhenPlayingOverride:onUpdate(value)
			if value then
				ignoreDistanceWhenPlayingOverride:set(false)
			end
		end
    end

end

Jukebox.loadModOptions()

-- For storing active jukebox data based on location keys as well as song data.
Jukebox.activeLocations = {}
Jukebox.activeTracks = {}
Jukebox.keyRing = {}

-- Default if not set by SandboxVars.
Jukebox.maxRange = 50

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

-- Client-Server Packet Commands

-- These are commands embedded in packets that won't be stored
-- in the jukeboxData referenced by said packets; they are used
-- to trigger events either clientside or serverside.
Jukebox.command = {
	afterSync = true,
	enqueue = true,
	dequeue = true,
	remove = true,
	increaseIndex = true,
	decreaseIndex = true,
	enqueueIndex = true,
	-- For Shuffling
	startIndex = true,
	shuffleJump = true,
	-- Last three exclusively for making generic commands unique.
	targetIndex = true,
	priorTrack = true,
	nextTrack = true 
}

-- Process results of sync commands. Needs to happen separately
-- on client and server to maximize speed.
Jukebox.process = function(jukeboxData, packet)

	if packet.remove then
		Jukebox.removeTrack(jukeboxData, packet.remove)
	end
	
	if packet.enqueue then
		Jukebox.enqueueTrack(jukeboxData, packet.enqueue, packet.enqueueIndex)
	elseif packet.dequeue then
		Jukebox.dequeueTrack(jukeboxData, packet.dequeue)
	end
	
	if packet.increaseIndex then
		Jukebox.increaseIndex(jukeboxData)
		if packet.afterSync and #jukeboxData.queue > 0 and not jukeboxData.queueLocked then
			local priorTrack = Jukebox.getPriorTrack(jukeboxData)
			Jukebox.dequeueTrack(jukeboxData, priorTrack)
		end
	elseif packet.decreaseIndex then
		Jukebox.decreaseIndex(jukeboxData)
	end
	
	return packet.afterSync

end

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

-- Icon Stuff

Jukebox.getIcon = function(optionTag)
	if Jukebox.mod.options.hideMenuIcons then return end

	if optionTag == "Main Menu"  then
		return getTexture("media/ui/TrueMusicJukebox/machine.png")
	elseif optionTag == "Rename Jukebox" then
		return getTexture("media/ui/TrueMusicJukebox/rename.png")
	elseif optionTag == "On"  then
		if Jukebox.mod.options.invertToggleIconFeedback then
			-- When the jukebox is able to be turned ON (meaning the jukebox is OFF), the image will be ON.
			return getTexture("media/ui/TrueMusicJukebox/on.png")
		else
			-- When the jukebox is able to be turned ON, the image (and jukebox) will be OFF.
			return getTexture("media/ui/TrueMusicJukebox/off.png")
		end
	elseif optionTag == "Off"  then
		if Jukebox.mod.options.invertToggleIconFeedback then
			-- When the jukebox is able to be turned OFF (meaning the jukebox is ON), the image will be OFF.
			return getTexture("media/ui/TrueMusicJukebox/off.png")
		else
			-- When the jukebox is able to be turned OFF, the image (and jukebox) will be ON.
			return getTexture("media/ui/TrueMusicJukebox/on.png")
		end
	elseif optionTag == "Playlist"  then
		return getTexture("media/ui/TrueMusicJukebox/playlist.png")
	elseif optionTag == "Queue" then
		return getTexture("media/ui/TrueMusicJukebox/queue.png")
	elseif optionTag == "Locked Queue" then
		return getTexture("media/ui/TrueMusicJukebox/looping.png")
	elseif optionTag == "Volume" then
		return getTexture("media/ui/TrueMusicJukebox/volume.png")
	elseif optionTag == "Play Now" then
		return getTexture("media/ui/TrueMusicJukebox/now.png")
	elseif optionTag == "Play Next" then
		return getTexture("media/ui/TrueMusicJukebox/next.png")
	elseif optionTag == "Play Last" then
		return getTexture("media/ui/TrueMusicJukebox/last.png")
	elseif optionTag == "Lock Queue" then
		if Jukebox.mod.options.invertToggleIconFeedback then
			return getTexture("media/ui/TrueMusicJukebox/unlockable.png")
		else
			return getTexture("media/ui/TrueMusicJukebox/lockable.png")
		end
	elseif optionTag == "Unlock Queue" then
		if Jukebox.mod.options.invertToggleIconFeedback then
			return getTexture("media/ui/TrueMusicJukebox/lockable.png")
		else
			return getTexture("media/ui/TrueMusicJukebox/unlockable.png")
		end
	elseif optionTag == "Skip Current" then
		return getTexture("media/ui/TrueMusicJukebox/forward.png")
	elseif optionTag == "Replay Current" then
		return getTexture("media/ui/TrueMusicJukebox/replay.png")
	elseif optionTag == "Replay Last" then
		return getTexture("media/ui/TrueMusicJukebox/back.png")
	elseif optionTag == "Dequeue" then
		return getTexture("media/ui/TrueMusicJukebox/dequeue.png")
	elseif optionTag == "Random" then
		return getTexture("media/ui/TrueMusicJukebox/random.png")
	elseif optionTag == "Shuffle" then
		return getTexture("media/ui/TrueMusicJukebox/shuffle.png")
	elseif optionTag == "Enable Key" then
		if Jukebox.mod.options.invertToggleIconFeedback then
			return getTexture("media/ui/TrueMusicJukebox/enabled.png")
		else
			return getTexture("media/ui/TrueMusicJukebox/disabled.png")
		end
	elseif optionTag == "Disable Key" then
		if Jukebox.mod.options.invertToggleIconFeedback then
			return getTexture("media/ui/TrueMusicJukebox/disabled.png")
		else
			return getTexture("media/ui/TrueMusicJukebox/enabled.png")
		end
	elseif optionTag == "Check Track" then
		return getTexture("media/ui/TrueMusicJukebox/information.png")
	elseif optionTag == "Check Status" then
		return getTexture("media/ui/TrueMusicJukebox/status.png")
	end
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

	local JukeboxFeedback = require("Jukebox/Feedback")

	Jukebox.feedback = Jukebox.feedback or JukeboxFeedback:new(0, 60, { r = 0, g = 0, b = 0, a = 1 })

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
	Jukebox.keyRing = ModData.getOrCreate("Jukebox.keyRing")
	Jukebox.batchedKeyData = {}

	for index = 1, Jukebox.batches do
		Jukebox.batchedKeyData[index] = {}
	end
end

if not isServer() then Events.OnInitGlobalModData.Add(Jukebox.processClientsideLocationData) end

-- Checking for Game Sounds

Jukebox.getSoundFile = function(itemType)
	return itemType and GameSounds.getSound(itemType) and GameSounds.getSound(itemType):getRandomClip():getFile()
end

-- Jukebox Remote Key Management

Jukebox.addJukeboxKey = function(key)
	Jukebox.removeJukeboxKey(key) 
	Jukebox.keyRing[key] = "Jukebox at " .. key
	table.insert(Jukebox.keyRing, key)
end

Jukebox.removeJukeboxKey = function(key)
	if not Jukebox.keyRing[key] then return end

	for index, value in ipairs(Jukebox.keyRing) do
		if value == key then
			table.remove(Jukebox.keyRing, index)
			Jukebox.keyRing[key] = nil
			return index
		end
	end
end

-- Track Utility Functions

Jukebox.itemTypeContains = function(item, name)

    -- Pure Aesthetics
    local String = string

    local simplifiedElementName = String.lower(item:getType()):gsub("%s+", ""):gsub("%-+","")

    -- :gsub("%s+", "") removes spaces from the string if it has any to remove and returns result.
    local elementHasGivenName = String.find(simplifiedElementName, name) ~= nil
   
    return elementHasGivenName

end

Jukebox.prettyName = function(displayName)
	-- Example: Cassette - Michael Cassette - My Name Is Michael Cassette
	prettyName = displayName:gsub("Vinyl %-", "", 1) -- Remove first instance of the word Vinyl followed by a hyphen.
	prettyName = prettyName:gsub("Cassette %-", "", 1) -- Remove first instance of the word Cassette followed by a hyphen.
	prettyName = prettyName:gsub("Vinyl", "", 1) -- Remove first instance of the word Vinyl (if no "Vinyl -" found, this will be found).
	prettyName = prettyName:gsub("Cassette", "", 1) -- Remove first instance of the word Cassette (same as above for cassettes).
	prettyName = prettyName:gsub("^%s*(.-)%s*$", "%1") -- Remove leading and trailing whitespace.
	return prettyName --> Michael Cassette - My Name Is Michael Cassette
end

Jukebox.increaseIndex = function(jukeboxData)
	if #jukeboxData.queue > 0 then
		jukeboxData.queueIndex = jukeboxData.queueIndex % #jukeboxData.queue + 1
	else
		jukeboxData.playlistIndex = jukeboxData.playlistIndex % #jukeboxData.playlist + 1
	end
end

Jukebox.decreaseIndex = function(jukeboxData)
	if #jukeboxData.queue > 0 then
		jukeboxData.queueIndex = jukeboxData.queueIndex - 1 == 0 and #jukeboxData.queue or jukeboxData.queueIndex - 1
	else
		jukeboxData.playlistIndex = jukeboxData.playlistIndex - 1 == 0 and #jukeboxData.playlist or jukeboxData.playlistIndex - 1
	end
end

Jukebox.enqueueTrack = function(jukeboxData, trackType, index)
	local shift = Jukebox.dequeueTrack(jukeboxData, trackType) -- Always dequeue before enqueueing; never queue same track twice.
	
	index = index and index + shift or nil

	jukeboxData.queue[trackType] = true
	
	if index then
		table.insert(jukeboxData.queue, index, trackType)
	else
		table.insert(jukeboxData.queue, trackType)
	end
end

Jukebox.dequeueTrack = function(jukeboxData, trackType)
	local shift = 0
	if jukeboxData.queue[trackType] then
		jukeboxData.queue[trackType] = nil
		for index = 1, #jukeboxData.queue do
			if jukeboxData.queue[index] == trackType then
				if index < jukeboxData.queueIndex then
					jukeboxData.queueIndex = jukeboxData.queueIndex - 1
					shift = -1
				end
				table.remove(jukeboxData.queue, index)
				return shift
			end
		end
	end
	return shift
end

-- Add track to current playlist
Jukebox.insertTrack = function(jukeboxData, trackType, trackName, trackIndex) 
    local playlist = jukeboxData.playlist 

	trackIndex = trackIndex or (#playlist + 1)

	table.insert(jukeboxData.playlist, trackIndex, trackType)

	jukeboxData.playlist[trackType] = true

	-- Used to convert types to full names.

	if not trackName then return end

	jukeboxData.titles[trackType] = Jukebox.prettyName(trackName)
end

-- Remove trackType from playlist
Jukebox.removeTrack = function(jukeboxData, trackType)
    local playlist = jukeboxData.playlist
    if not (playlist and playlist[trackType]) then return end -- The playlist for this jukebox has never been created, or track isn't loaded.

	local currentPlaylistIndex = Jukebox.getPlaylistIndex(jukeboxData, trackType)
	local currentTrack = Jukebox.getCurrentTrack(jukeboxData)
    for playlistIndex, value in ipairs(playlist) do
        if value == trackType then
			jukeboxData.inventorySize = jukeboxData.inventorySize - 1 -- Attempt to avoid needless reset.

			local skipNeeded = false
			local shift = 0

			Jukebox.dequeueTrack(jukeboxData, trackType)
			
            table.remove(playlist, playlistIndex)

			playlist[trackType] = nil

			if playlistIndex < currentPlaylistIndex then 
				-- Tracks just shifted; fix current playlistIndex.
				-- currentIndex must be at least 2, or else this will not happen.
				jukeboxData.playlistIndex = currentPlaylistIndex - 1
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
				jukeboxData.hasPlayableTracks = false
			end

            return #jukeboxData.queue > 0 and queueIndex or playlistIndex
        end
    end
end

Jukebox.clearQueue = function(jukeboxData)

	if not jukeboxData then return end

	jukeboxData.queue = {}
	jukeboxData.queueIndex = 0

end

-------------------------
-- Last, Current, Next --
-------------------------
Jukebox.getPriorIndex = function(jukeboxData)
	local currentIndex = #jukeboxData.queue > 0 and jukeboxData.queueIndex or jukeboxData.playlistIndex
	local lastIndex = #jukeboxData.queue > 0 and #jukeboxData.queue or #jukeboxData.playlist
	return currentIndex - 1 == 0 and lastIndex or currentIndex - 1
end
Jukebox.getCurrentIndex = function(jukeboxData)
	local currentIndex = #jukeboxData.queue > 0 and jukeboxData.queueIndex or jukeboxData.playlistIndex
	return currentIndex
end
Jukebox.getNextIndex = function(jukeboxData)
	local currentIndex = #jukeboxData.queue > 0 and jukeboxData.queueIndex or jukeboxData.playlistIndex
	local size = #jukeboxData.queue > 0 and #jukeboxData.queue or #jukeboxData.playlist
	return (currentIndex % size) + 1
end
Jukebox.getPriorTrack = function(jukeboxData)
	local tracklist = #jukeboxData.queue > 0 and jukeboxData.queue or jukeboxData.playlist
	return tracklist[Jukebox.getPriorIndex(jukeboxData)]
end
Jukebox.getCurrentTrack = function(jukeboxData)
	local tracklist = #jukeboxData.queue > 0 and jukeboxData.queue or jukeboxData.playlist
	return tracklist[Jukebox.getCurrentIndex(jukeboxData)]
end
Jukebox.getNextTrack = function(jukeboxData)
	local tracklist = #jukeboxData.queue > 0 and jukeboxData.queue or jukeboxData.playlist
	return tracklist[Jukebox.getNextIndex(jukeboxData)]
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
Jukebox.getPlaylistIndex = function(jukeboxData, trackType)
	if not (jukeboxData and trackType) then return end

	local array = jukeboxData.playlist

	if not array then return end

	if #array > 0 then
		for index, value in ipairs(array) do
			if value == trackType then return index end
		end
	end
end
Jukebox.getQueueIndex = function(jukeboxData, trackType)
	if not (jukeboxData and trackType) then return end

	local array = jukeboxData.queue

	if not array then return end

	if #array > 0 then
		for index, value in ipairs(array) do
			if value == trackType then return index end
		end
	end
end
Jukebox.getIndex = function(jukeboxData, trackType)
	if not (jukeboxData and trackType) then return end

	local array = #jukeboxData.queue > 0 and jukeboxData.queue or jukeboxData.playlist

	if not array then return end

	if #array > 0 then
		for index, value in ipairs(array) do
			if value == trackType then return index end
		end
	end
end

Jukebox.random = function(max)
    return ZombRand(max) + 1
end

Jukebox.shuffle = function(jukeboxData, packet)

	if not jukeboxData then return {} end

	local shuffleJump = packet.shuffleJump

	local startIndex = packet.startIndex

	local currentIndex = startIndex

	local currentTrack = Jukebox.getCurrentTrack(jukeboxData)

	local playlist = jukeboxData.playlist

	local playlistShuffled = {}
	
	while #playlist > 0 do
		playlistShuffled[#playlistShuffled + 1] = playlist[currentIndex]
		table.remove(playlist, currentIndex)
		if #playlist == 0 then break end
		local nextIndex = (currentIndex + shuffleJump) % #playlist + 1
        while #playlist > 5 and math.abs(nextIndex - currentIndex) < 3 do
            nextIndex = nextIndex % #playlist + 1
        end
		currentIndex = nextIndex
	end

	jukeboxData.playlist = playlistShuffled

	if jukeboxData.queueLocked then
		local queue = jukeboxData.queue

		local queueShuffled = {}

		-- Reduce to something that fits in queue. Jump size can stay the same.
		currentIndex = #queue > 0 and currentIndex % #queue + 1 or "trash" 
		
		while #queue > 0 do
			queueShuffled[#queueShuffled + 1] = queue[currentIndex]
			queueShuffled[queue[currentIndex]] = true
			table.remove(queue, currentIndex)
			if #queue == 0 then break end
			local nextIndex = (currentIndex + shuffleJump) % #queue + 1
			while #queue > 5 and math.abs(nextIndex - currentIndex) < 3 do
				nextIndex = nextIndex % #queue + 1
			end
			currentIndex = nextIndex
		end

		jukeboxData.queue = queueShuffled
	else
		Jukebox.clearQueue(jukeboxData)
	end

	if currentTrack then
		local newIndex = Jukebox.getIndex(jukeboxData, currentTrack) or 1
		
		if #jukeboxData.queue > 0 then
			jukeboxData.queueIndex = newIndex
			jukeboxData.playlistIndex = 1
		else
			jukeboxData.queueIndex = 0
			jukeboxData.playlistIndex = newIndex
		end
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
		jukeboxData.playlistIndex = 1
		jukeboxData.queue = {}
		jukeboxData.queueIndex = 0
		jukeboxData.inventorySize = 0
		jukeboxData.hasPlayableTracks = false

		sendClientCommand("TrueMusicJukebox", "sync", {
			key = key, hasPlayableTracks = jukeboxData.hasPlayableTracks, inventorySize = jukeboxData.inventorySize,
			playlist = jukeboxData.playlist, playlistIndex = jukeboxData.playlistIndex, 
			queue = jukeboxData.queue, queueIndex = jukeboxData.queueIndex
		})
		return 
	end

	-- If this playlist has the right size, we assume we're good; otherwise we recreate it now.
	if jukeboxData.inventorySize == jukeboxItems:size() and jukeboxData.version == Jukebox.version then 
		return true
	else
		local tracksRequiringRequeue = {}

		local currentTrack = Jukebox.getCurrentTrack(jukeboxData)

		jukeboxData.playlist = {}
		jukeboxData.playlistIndex = 1
		jukeboxData.inventorySize = 0
		jukeboxData.hasPlayableTracks = false

		local loaded = {}
		-- Save titles so we can pass them without complex objects from server to client.
		for index = 1, jukeboxItems:size() do
			local item = jukeboxItems:get(index - 1)
			if item and item.getType and item.getDisplayName and 
			   Jukebox.getSoundFile(item:getType()) and not loaded[item:getType()] then
				loaded[item:getType()] = true
				if jukeboxData.queue[item:getType()] then
					tracksRequiringRequeue[#tracksRequiringRequeue + 1] = item:getType()
				end
				Jukebox.insertTrack(jukeboxData, item:getType(), item:getDisplayName())
				if (not jukeboxData.hasPlayableTracks) and Jukebox.getSoundFile(item:getType()) then
					jukeboxData.hasPlayableTracks = true
				end
			end
		end

		jukeboxData.queue = {}

		for index, trackType in ipairs(tracksRequiringRequeue) do
			Jukebox.enqueueTrack(jukeboxData, trackType)
		end

		if currentTrack and loaded[currentTrack] then
			jukeboxData.playlistIndex = Jukebox.getPlaylistIndex(jukeboxData, currentTrack) or 1 -- Just in case.
			jukeboxData.queueIndex = Jukebox.getQueueIndex(jukeboxData, currentTrack) or 1 -- Just in case.
		end

		if #jukeboxData.queue == 0 then 
			jukeboxData.queueIndex = 0 
		end

		jukeboxData.inventorySize = jukeboxItems:size()
	end

	sendClientCommand("TrueMusicJukebox", "sync", {
		key = key, hasPlayableTracks = jukeboxData.hasPlayableTracks, inventorySize = jukeboxData.inventorySize,
		titles = jukeboxData.titles, playlist = jukeboxData.playlist, playlistIndex = jukeboxData.playlistIndex, 
		queue = jukeboxData.queue, queueIndex = jukeboxData.queueIndex
	})

	return true
end

Jukebox.playSound = function(jukeboxData, trackType, playNow, beginMuted)
	if not (jukeboxData and trackType) then return end

	local key = Jukebox.dataToKey(jukeboxData)

	local bail = false

	if Jukebox.activeTracks[key] then 
		-- elapsed is used for stutter-start prevention.
		if playNow and Jukebox.activeTracks[key].elapsed > 9 or not Jukebox.activeTracks[key].sound:isPlaying() then
			Jukebox.activeTracks[key].sound:stop()
		else 
			bail = true
		end
	end

	if bail then return end

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
	
	local sound = JukeboxSound:new(Jukebox.maxRange, Jukebox.mod.options.threeDimensionalAudio)

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

		jukeboxData.key = key
		
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
		
		-- jukeboxData.currentIndex = 1
		jukeboxData.volume = Jukebox.volumes[6]

		jukeboxData.hasPlayableTracks = false

		-- Number of Items Loaded Into Jukebox
		jukeboxData.inventorySize = 0

		-- Types
		jukeboxData.playlist = {}
		-- Index of Playlist
		jukeboxData.playlistIndex = 1
		-- Queue
		jukeboxData.queue = jukeboxData.queue or {} --> Preserves old queue
		-- Index of Queue
		jukeboxData.queueIndex = #jukeboxData.queue > 0 and 1 or 0

		-- Queue Mode
		jukeboxData.queueLocked = false

		-- Get Pretty Title of Type
		-- Never needs to be reordered or adjusted because
		-- once there is a stored pretty name for a given type (i.e., 
		-- for a given track id), that track's pretty name
		-- can be recovered from its type no matter the order of the
		-- playlist; we don't even need to care if titles get
		-- removed from Jukebox because space used here is trivial. 
		jukeboxData.titles = jukeboxData.titles or {}

		-- Used to force updates on existing jukeboxes.
		jukeboxData.version = Jukebox.version

		-- ModData.transmit("Jukebox.activeLocations")

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

Jukebox.playAtThisRange = function(distance)
	return (SandboxVars.TrueMusicJukebox and SandboxVars.TrueMusicJukebox.ignoreDistanceWhenPlaying and 
			not Jukebox.mod.options.considerDistanceWhenPlayingOverride) or distance < Jukebox.maxRange or
		   Jukebox.mod.options.ignoreDistanceWhenPlayingOverride
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
			-- ModData.transmit("Jukebox.activeLocations")
			break
		end

		local location = Jukebox.keyToLocation(key)

		local square = getSquare(location.x, location.y, location.z)

		local jukebox = square and Jukebox.getEvolvedJukebox(square)
	
		if square and not jukebox then --> Jukebox moved, destroy active location.
			Jukebox.activeLocations[key] = nil
			Jukebox.removeBatchedKey(key, jukeboxData.batch, index)
			sendClientCommand("TrueMusicJukebox", "clear", {[key] = true, x = location.x, y = location.y, z = location.z})
			break
		end

		if jukebox then 
			Jukebox.initializePlaylist(jukebox, jukeboxData)
		end

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

		if not (jukeboxData and jukeboxData.on) then --> Jukebox off. Destroy sound record.
			if sound then
				sound:stop()
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

		local playlist = jukeboxData.playlist

		local distance = Jukebox.getDistance(jukeboxData)

		if (not activeTrack) and jukeboxData.on and (#playlist > 0) and Jukebox.playAtThisRange(distance) then
			-- A sound was never initialized on this location for this client.
			-- Would presumably result from joining server far away from an
			-- active jukebox, thus preventing it from getting logged in this
			-- client's activeTracks object. If we detect a jukebox at a location
			-- we expect to be playing something, let's try to make that happen.

			Jukebox.playSound(jukeboxData, Jukebox.getCurrentTrack(jukeboxData))

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
		
		sound:tick()
		
		if sound:isPlaying() then
			if jukebox and not Jukebox.hasLoaded(jukebox:getContainer(), sound:getSoundType()) then
				if #jukeboxData.playlist == 0 then
					Jukebox.activeTracks[key].sound:stop()
					Jukebox.activeTracks[key] = nil
				elseif not sound.changing then
					-- This variable is set when a command has been issued to the server
					-- and the client is awaiting the completion of said command to reduce
					-- spamming server with pointless requests. 
					sound.changing = true

					local nextIndex = Jukebox.getNextIndex(jukeboxData)
					-- Letting server handle skip will utilize jukebox tick to prevent
					-- double-skipping after tracks in playlist end.
					sendClientCommand("TrueMusicJukebox", "sync", {key = key, increaseIndex = true, targetIndex = nextIndex, afterSync = "skip"})
				end
				break
			end

			if jukebox and SandboxVars.TrueMusicJukebox and SandboxVars.TrueMusicJukebox.jukeboxesAttractZombies then
				-- Pulling too many zombies to one location crashes the server hard. This should reduce this issue when using massive ranges.
				local maxRangeAdjustedForServerSafety = math.min(Jukebox.maxRange, 110)
				addSound(jukebox, jukebox:getX(), jukebox:getY(), jukebox:getZ(), maxRangeAdjustedForServerSafety, maxRangeAdjustedForServerSafety)
			end

			if sound:getVolume() ~= jukeboxData.volume or sound:getLastDistance() ~= distance then
				sound:setVolume(jukeboxData.volume, distance)
			end
		elseif readyForNextTrack and not sound.changing then
			-- Letting server handle skip will utilize jukebox tick to prevent
			-- double-skipping after tracks in playlist end.
			sound.changing = true

			local nextIndex = Jukebox.getNextIndex(jukeboxData)

			sendClientCommand("TrueMusicJukebox", "sync", {key = key, increaseIndex = true, targetIndex = nextIndex, afterSync = "skip"})
		end
	until true end
end

if not isServer() then Events.OnTick.Add(Jukebox.updateSound) end

-- Function for checking whether joypad player is active safely from Wookiee Gamepad Support.

Jukebox.getJoypadData = function(playerIndex)

    if not playerIndex then playerIndex = 0 end

    return JoypadState.players[playerIndex + 1]

end

Jukebox.isJoypadDisconnected = function(playerIndex) 
	local controller = JoypadState.controllers[playerIndex]
	if not controller then return end
	local joypadData = controller.joypad
	if not joypadData then return end
	if joypadData.disconnectedUI then return true end
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

return Jukebox