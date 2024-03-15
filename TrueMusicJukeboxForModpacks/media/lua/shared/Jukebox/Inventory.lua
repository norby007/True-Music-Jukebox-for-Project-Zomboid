if isServer() then return end

local Jukebox = require("Jukebox/Utility")

local JukeboxMenus = require("Jukebox/Menu")

local JukeboxInventory = {}

JukeboxInventory.grabManual = function(player, item)
    local playerInventory = player:getInventory()
    local jukeboxInstructionManual = "TrueMusicJukebox.InstructionManual"
    playerInventory:AddItem(jukeboxInstructionManual)
    item:getModData().jukeboxManualTaken = true
end

JukeboxInventory.addGrabManual = function(playerIndex, menu, stack)
    local item = nil
    local items = nil
    if stack and stack[1] and stack[1].items then
        items = stack[1].items
        item = items[1]
    elseif stack and stack[1] then
        item = stack[1]
    end

    if not (item and item.getType and item.getContainer and item.isInPlayerInventory) then return end

    local player = getSpecificPlayer(playerIndex)

    if item:isInPlayerInventory() and not player:HasItem("TrueMusicJukebox.InstructionManual") and
       item:getName() == getItemNameFromFullType("TrueMusicJukebox.StarterKit") and
       not item:getModData().jukeboxManualTaken then
        menu:addOptionOnTop(Jukebox.translation.grabManual, 
            player, JukeboxInventory.grabManual, item)
    end
end

Events.OnFillInventoryObjectContextMenu.Add(JukeboxInventory.addGrabManual)

JukeboxInventory.trackTransferMenu = function(playerIndex, menu, stack)
    local item = nil
    local items = nil
    if stack and stack[1] and stack[1].items then
        items = stack[1].items
        item = items[1]
    elseif stack and stack[1] then
        item = stack[1]
    end

    if not (item and item.getType and item.getContainer and item.isInPlayerInventory) then return end
        
    if Jukebox.options.hideTransferAllTrueMusic or not Jukebox.isOrHasCassetteOrVinyl(item) then return end

    local context = item:isInPlayerInventory() and Jukebox.playableCassetteOrVinyl(item) and "Inventory"

    context = context or ((not item:isInPlayerInventory()) and "Loot")

    if context then JukeboxMenus.addTransferMenu(playerIndex, menu, item, context) end
end

Events.OnFillInventoryObjectContextMenu.Add(JukeboxInventory.trackTransferMenu)

JukeboxInventory.manageTracksFromJukebox = function(playerIndex, menu, stack)
    local item = nil
    local items = nil
    if stack and stack[1] and stack[1].items then
        items = stack[1].items
        item = items[1]
    elseif stack and stack[1] then
        item = stack[1]
    end

    if not item then return end

    if item:getContainer() and item:getContainer():getType() == "jukebox" then
        local tracklist = item:getContainer()

        local player = getSpecificPlayer(playerIndex)

        local jukebox = tracklist:getParent()

        local square = jukebox:getSquare()
    
        local key = Jukebox.squareToKey(square)

        local jukeboxData = Jukebox.activeLocations[key]

        if (not jukeboxData) or (jukeboxData == true) or (jukeboxData.version ~= Jukebox.version) then
            jukebox = Jukebox.getEvolvedJukebox(square) -- Upgrades jukebox if necessary.
            jukeboxData = Jukebox.activeLocations[key]
        end

        jukeboxData.player = {
            x = math.floor(player:getX()),
            y = math.floor(player:getY()),
            z = math.floor(player:getZ())
        }
        
        if not Jukebox.initializePlaylist(jukebox, jukeboxData) then return end

        local playlistSize = #jukeboxData.playlist

        jukeboxData.playlistIndex = (jukeboxData.playlistIndex and math.min(math.max(jukeboxData.playlistIndex, 1), #jukeboxData.playlist)) or 1
        jukeboxData.queueIndex = (jukeboxData.queueIndex and math.min(math.max(jukeboxData.queueIndex, 1), #jukeboxData.queue)) or 1

        local trackType = item:getType()

        local key = Jukebox.dataToKey(jukeboxData)

        local activeTrack = Jukebox.activeTracks[key]

        if not jukeboxData.on then

            menu:addOptionOnTop(Jukebox.translation.turnOnJukebox, player,
                JukeboxMenus.interact, jukebox, key, "On", trackType).iconTexture = Jukebox.getIcon("On")

        else

            menu:addOptionOnTop(Jukebox.translation.turnOffJukebox, player,
                JukeboxMenus.interact, jukebox, key, "Off").iconTexture = Jukebox.getIcon("Off")

            if not Jukebox.getSoundFile(trackType) then return end

            local toggleQueueLockText = (jukeboxData.queueLocked and Jukebox.translation.unlockQueue) or Jukebox.translation.lockQueue

            -- Order intended to maximize convenience to inventory menu users.

            JukeboxMenus.addJukeboxMainMenu(menu, player, jukebox, key, jukeboxData, activeTrack, toggleQueueLockText)
            
            JukeboxMenus.addJukeboxVolume(menu, player, jukebox, key, jukeboxData)

            JukeboxMenus.addJukeboxQueue(menu, player, jukebox, key, jukeboxData, activeTrack, toggleQueueLockText, "Standing by Jukebox")
			
            -- Unique to Inventory Menu

            if jukeboxData.queue[trackType] then
                menu:addOptionOnTop(Jukebox.translation.dequeueTrack, player, 
                    JukeboxMenus.interact, jukebox, key, "Dequeue Track", trackType).iconTexture = Jukebox.getIcon("Dequeue")
            end

            menu:addOptionOnTop(Jukebox.translation.playNow, player,
                JukeboxMenus.interact, jukebox, key, "Play Now", trackType).iconTexture = Jukebox.getIcon("Play Now")

            if item:getType() == Jukebox.getCurrentTrack(jukeboxData) or not (activeTrack and #jukeboxData.playlist > 1) then return end

            menu:addOptionOnTop(Jukebox.translation.playNext, player,
                JukeboxMenus.interact, jukebox, key, "Play Next", trackType).iconTexture = Jukebox.getIcon("Play Next")

            if not (#jukeboxData.queue > 0) then return end

            menu:addOptionOnTop(Jukebox.translation.playLast, player, 
                JukeboxMenus.interact, jukebox, key, "Play Last", trackType).iconTexture = Jukebox.getIcon("Play Last")

        end
    end
end

Events.OnFillInventoryObjectContextMenu.Add(JukeboxInventory.manageTracksFromJukebox)

JukeboxInventory.loadRemoteControlMenu = function(playerIndex, menu, stack)
    if not (SandboxVars and SandboxVars.TrueMusicJukebox.allowPortableJukeboxKeys) then return end

    local item = nil
    local items = nil
    if stack and stack[1] and stack[1].items then
        items = stack[1].items
        item = items[1]
    elseif stack and stack[1] then
        item = stack[1]
    end

    if not item then return end

    if item:getType() and Jukebox.itemTypeContains(item, "keyring") and item:isInPlayerInventory() then
        local player = getSpecificPlayer(playerIndex)
        JukeboxMenus.addKeyRingData(menu, player)
    end
end

Events.OnFillInventoryObjectContextMenu.Add(JukeboxInventory.loadRemoteControlMenu)

return JukeboxInventory
