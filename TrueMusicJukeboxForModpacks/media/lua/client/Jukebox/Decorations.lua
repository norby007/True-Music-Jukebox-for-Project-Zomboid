local Jukebox = require("Jukebox/Utility")
local JukeboxMenus = require("Jukebox/Menu")
local JukeboxSound = require("Jukebox/Sound")

-- Protects Against a Known Options Bug

if not Exterminator then

    Exterminator = {}

    Exterminator.onEnterFromGame = MainScreen.onEnterFromGame

    function MainScreen:onEnterFromGame()

        Exterminator.onEnterFromGame(self)

        -- Guarantee that when you ENTER the options menu, the game does not think you've already changed your damn options.

        MainOptions.instance.gameOptions.changed = false

    end

end

Jukebox.ISInventoryPane = {}

Jukebox.ISInventoryPane.lootAll = ISInventoryPane.lootAll

function ISInventoryPane:lootAll()
    local playerIndex = self.player
    if getPlayerLoot(playerIndex).inventory:getType() == "jukebox" then
        local jukebox = getPlayerLoot(playerIndex).inventory:getParent()
        if (jukebox and jukebox.getSquare) then
            local key = Jukebox.squareToKey(jukebox:getSquare())
            local jukeboxData = Jukebox.activeLocations[key]
            if jukeboxData then
                jukeboxData.on = false
                sendClientCommand("TrueMusicJukebox", "sync", {key = jukeboxData.key, on = false})
            end
        end 
    end
    Jukebox.ISInventoryPane.lootAll(self)
end

Jukebox.ISInventoryPaneContextMenu = {}

Jukebox.ISInventoryPaneContextMenu.onGrabItems = ISInventoryPaneContextMenu.onGrabItems

ISInventoryPaneContextMenu.onGrabItems = function(stack, playerIndex)
    Jukebox.stack = stack

    if stack and stack[1] and stack[1].items then
        items = stack[1].items
        item = items[1]
    elseif stack and stack[1] then
        item = stack[1]
    end

	Jukebox.ISInventoryPaneContextMenu.onGrabItems(stack, playerIndex)

    if not (item and item.getType and item.getContainer) then return end

    local player = getSpecificPlayer(playerIndex)

    if not player then return end

    local jukebox = item:getContainer() and item:getContainer():getParent()

    if not jukebox then return end

	local key = Jukebox.squareToKey(jukebox:getSquare())

    local location = Jukebox.keyToLocation(key)

	local jukeboxData = Jukebox.activeLocations[key]

    if not jukeboxData then return end

    Jukebox.removeTrack(jukeboxData, item:getType()) -- player will attempt to do this again, but it won't do anything.

    sendClientCommand("TrueMusicJukebox", "sync", {key = key, remove = item:getType()})
end

Jukebox.ISEmoteRadialMenu = {}

Jukebox.ISEmoteRadialMenu.emote = ISEmoteRadialMenu.emote

function ISEmoteRadialMenu:emote(emote)
	if string.sub(emote,1,string.len('BobTA'))=='BobTA' then
		-- This is a True Actions Dance.
		local playerIndex = self.character:getPlayerNum()

		Jukebox.dancing[playerIndex] = true
        
        Events.OnTick.Remove(Jukebox.cancelDanceBonus)
        Events.OnTick.Add(Jukebox.cancelDanceBonus)
	end
    
	Jukebox.ISEmoteRadialMenu.emote(self, emote)
end

function ISInventoryPane:transferAllTrueMusic(mode)
    local onlyTransferExtras = mode == "Extra"
    local onlyTransferUniques = mode == "Unique"
    local playerIndex = self.player
	local playerLoot = getPlayerLoot(playerIndex).inventory
	local hotBar = getPlayerHotbar(playerIndex)
    local items = self.inventory:getItems()
	if luautils.walkToContainer(self.inventory, playerIndex) then
        local found = {}
        local extras = {}
        local moveables = {}
		local toFloor = getPlayerLoot(playerIndex).inventory:getType() == "floor"
		for index = 0, items:size()-1 do repeat
			local item = items:get(index)
            local name = item:getName()
            if not Jukebox.playableCassetteOrVinyl(item) then break end
			local ok = not item:isEquipped() and item:getType() ~= "KeyRing" and not hotBar:isInHotbar(item)
			if item:isFavorite() then
				ok = false
			end
			if toFloor and instanceof(item, "Moveable") and item:getSpriteGrid() == nil and not item:CanBeDroppedOnFloor() then
				ok = false
			end

			if not ok then break end

            if onlyTransferUniques and not found[name] and playerLoot:getItemFromType(item:getType()) then
                found[name] = true
            end

            local validItem = (not onlyTransferExtras or extras[name]) and not (onlyTransferUniques and found[name])

            if validItem then
				table.insert(moveables, item)
                found[name] = true
			elseif onlyTransferExtras then
                extras[name] = true
            end
		until true end
		self:transferItemsByWeight(moveables, playerLoot)
	end
    self.selected = {}
    getPlayerLoot(playerIndex).inventoryPane.selected = {}
    getPlayerInventory(playerIndex).inventoryPane.selected = {}
end

function ISInventoryPage:transferAllTrueMusic(mode)
    self.inventoryPane:transferAllTrueMusic(mode)
end

function ISInventoryPage:transferAllExtraTrueMusic()
    self:transferAllTrueMusic("Extra")
end

function ISInventoryPage:transferAllUniqueTrueMusic()
    self:transferAllTrueMusic("Unique")
end

function ISInventoryPane:lootAllTrueMusic(mode)
    local onlyLootExtras = mode == "Extra"
    local onlyLootUniques = mode == "Unique"
    local playerIndex = self.player
	local player = getSpecificPlayer(playerIndex)
	if luautils.walkToContainer(self.inventory, playerIndex) then
        local found = {}
        local extras = {}
        local moveables = {}
        local heavyItem = nil
        local items = self.inventory:getItems()
		for index = 0, items:size()-1 do repeat
			local item = items:get(index)
            local name = item:getName()
            if not Jukebox.isOrHasCassetteOrVinyl(item) then break end

            if onlyLootUniques and not found[name] and player:HasItem(item:getType()) then
                found[name] = true
            end

            local validItem = (not onlyLootExtras or extras[name]) and not (onlyLootUniques and found[name])

			if isForceDropHeavyItem(item) then
				heavyItem = item
            elseif validItem then
                table.insert(moveables, item)
                found[name] = true
			elseif onlyLootExtras then
                extras[name] = true
            end
		until true end
		if heavyItem and items:size() == 1 then
			ISInventoryPaneContextMenu.equipHeavyItem(player, heavyItem)
			return
		end
		self:transferItemsByWeight(moveables, getPlayerInventory(playerIndex).inventory)
	end
	self.selected = {}
	getPlayerLoot(playerIndex).inventoryPane.selected = {}
	getPlayerInventory(playerIndex).inventoryPane.selected = {}
end

function ISInventoryPage:lootAllTrueMusic(mode)
    self.inventoryPane:lootAllTrueMusic(mode)
end

function ISInventoryPage:lootAllExtraTrueMusic()
    self:lootAllTrueMusic("Extra")
end

function ISInventoryPage:lootAllUniqueTrueMusic()
    self:lootAllTrueMusic("Unique")
end

-- Lifestyle Compatibility and Integrations

Jukebox.enableLifestyleIntegrations = function()
    require("JukeboxContextMenu")

    -- Lifestyle Muting Edits

    if JukeboxMenu then -- NOT JukeboxMenus; JukeboxMenu is a global table from Lifestyle.
        Jukebox.unmuteLifestyle = function(jukebox, square)
            local key = Jukebox.squareToKey(square)
    
            if jukebox:getModData().SilenceMusic ~= "no" then
                jukebox:getModData().SilenceMusic = "no"
                jukebox:transmitModData()
                sendClientCommand("TrueMusicJukebox", "sync", {key = key, volume = 0})
            end
        end        

        Jukebox.muteLifestyle = function(jukebox)
            if jukebox:getModData().SilenceMusic ~= "yes" then
                jukebox:getModData().SilenceMusic = "yes" -- Lifestyle Variable
                jukebox:transmitModData()
                -- After this, volume can resync two different ways.
            end
        end

        Jukebox.canDance = function()
            local dancingRequiresMusic = Jukebox.options.requireMusicForLifestyleDance or 
                SandboxVars.TrueMusicJukebox.requireMusicForLifestyleDance
                
            return not (Jukebox.silentForLocals and dancingRequiresMusic)
        end
    
        -- Decoration of Lifestyle Function

        if JukeboxMenu.onPlay then
            Jukebox.LifestyleMenu = {}
            
            Jukebox.LifestyleMenu.onPlay = JukeboxMenu.onPlay
    
            JukeboxMenu.onPlay = function(worldObjects, player, jukebox, ...)
                local square = jukebox and jukebox:getSquare()
                
                if square then Jukebox.unmuteLifestyle(jukebox, square) end
    
                Jukebox.LifestyleMenu.onPlay(worldObjects, player, jukebox, ...)
            end
        end
    end

    -- Lifestyle Dancing Edits Will Go Here

    local PlayerIsDancingToMusic = require("TimedActions/PlayerIsDancingToMusic")
    
    if PlayerIsDancingToMusic then
        Jukebox.knownLifestyleMusicStyles = {
            [1] = "default", [2] = "salsa", [3] = "csalsa", [4] = "beach", [5] = "cbeach",
            [6] = "reggae", [7] = "creggae", [8] = "metal", [9] = "cmetal",
            [10] = "electronic", [11] = "celectronic", [12] = "rap", [13] = "crap",
            [14] = "pop", [15] = "cpop", [16] = "holiday", [17] = "choliday",
            [18] = "muzak", [19] = "cmuzak", [20] = "country", [21] = "ccountry",
            [22] = "world", [23] = "cworld", [24] = "jazz", [25] = "cjazz",
            [26] = "classical", [27] = "cclassical"
        }
    
        -- Decoration of Lifestyle Function

        Jukebox.PlayerIsDancingToLifestyleMusic = {}
    
        Jukebox.PlayerIsDancingToLifestyleMusic.update = PlayerIsDancingToMusic.update
    
        function PlayerIsDancingToMusic:isCoolWithTrueMusicJukebox(playerModData)
            return self.triggeredByTrueMusicJukebox and Jukebox.canDance() and playerModData and 
                not playerModData.IsListeningToJukebox and not playerModData.IsListeningToDJ
        end
    
        function PlayerIsDancingToMusic:update()
            local player = self.character

            local playerModData = player and player:getModData()
    
            if self:isCoolWithTrueMusicJukebox(playerModData) then
                -- Line below will accept false or nil as needed.
                self.oldValueForIsListeningToJukebox = playerModData.IsListeningToJukebox 
                -- Pretend player can hear Lifestyle Music when we call update().
                playerModData.IsListeningToJukebox = true
    
                self.oldValueForIsListeningToMusicStyle = playerModData.IsListeningToMusicStyle
    
                -- We don't nil this variable because we want this to last until the end of the action.
                self.dancingStyleForTrueMusicJukebox = self.dancingStyleForTrueMusicJukebox or
                    Jukebox.knownLifestyleMusicStyles[Jukebox.random(#Jukebox.knownLifestyleMusicStyles)]

                playerModData.IsListeningToMusicStyle = self.dancingStyleForTrueMusicJukebox
    
                self.updateDeceivedByTrueMusicJukebox = true
            end
    
            -- Perform all original behaviors.
            Jukebox.PlayerIsDancingToLifestyleMusic.update(self)
    
            if self.updateDeceivedByTrueMusicJukebox then
                -- Revert to original value before this update even ends.
                if Jukebox.silentForLocals or not SandboxVars.TrueMusicJukebox.enableLifestyleFavoriteEffects then
                    playerModData.IsListeningToJukebox = self.oldValueForIsListeningToJukebox
                    playerModData.IsListeningToMusicStyle = self.oldValueForIsListeningToMusicStyle
                end
    
                -- Return values used by this trick to nil.
                self.updateDeceivedByTrueMusicJukebox = nil
                self.oldValueForIsListeningToJukebox = nil
                self.oldValueForIsListeningToMusicStyle = nil
            end
        end

        -- End Decoration of Lifestyle Function
    
        Jukebox.triggerLifestyleDance = function(player)    
            local actionType = "Bob_PreDancingDefault"
    
            local action = PlayerIsDancingToMusic:new(player, actionType)
    
            action.triggeredByTrueMusicJukebox = true
            
            ISTimedActionQueue.add(action);
        end

        Jukebox.triggerLifestyleMoodleEffects = function()
            if Jukebox.silentForLocals or not SandboxVars.TrueMusicJukebox.enableLifestyleFavoriteEffects then return end
            
            for playerIndex = 0, getNumActivePlayers() - 1 do repeat
                local player = getSpecificPlayer(playerIndex)
                
                if not (player and player:isAlive()) then break end
                
                local playerModData = player:getModData()
                
                if not playerModData.IsListeningToJukebox then break end
                
                PlayerIsListeningToMusic(player, 8)
            until true end
        end

        Events.EveryOneMinute.Add(Jukebox.triggerLifestyleMoodleEffects)

        -- Lifestyle Dance Option
        JukeboxMenus.insertDanceOption = function(menu, player, optionName)
            local option = nil

            if optionName then
                option = menu:insertOptionAfter(optionName, getText("ContextMenu_Dancing_Option"), 
                    player, Jukebox.triggerLifestyleDance)
            else
                option = menu:addOptionOnTop(getText("ContextMenu_Dancing_Option"),
                    player, Jukebox.triggerLifestyleDance)
            end

            option.iconTexture = Jukebox.getIcon("Dance")
        end

        JukeboxMenus.addLifestyleDance = function(playerIndex, menu)
            local player = getPlayer(playerIndex)

            -- If triggerLifestyleDance was never created, something went wrong patching Lifestyle.
            if not (player and player:isAlive() and Jukebox.triggerLifestyleDance) then return end

            local onOption = menu:getOptionFromName(Jukebox.translation.turnOnJukebox)
            local offOption = menu:getOptionFromName(Jukebox.translation.turnOffJukebox)
            local danceOption = menu:getOptionFromName(getText("ContextMenu_Dancing_Option"))
            local sitOnGroundOption = menu:getOptionFromName(getText("ContextMenu_SitGround"))
            local sitOnGroundMeditationOption = menu:getOptionFromName("Sit on Ground") -- Meditation Edit.

            if Jukebox.canDance() and not danceOption then
                if offOption then
                    JukeboxMenus.insertDanceOption(menu, player, Jukebox.translation.turnOffJukebox)
                elseif onOption then
                    JukeboxMenus.insertDanceOption(menu, player, Jukebox.translation.turnOnJukebox)
                elseif Jukebox.options.dancingComesFirst then
                    JukeboxMenus.insertDanceOption(menu, player)
                elseif sitOnGroundOption then
                    JukeboxMenus.insertDanceOption(menu, player, getText("ContextMenu_SitGround"))
                elseif sitOnGroundMeditationOption then
                    JukeboxMenus.insertDanceOption(menu, player, "Sit on Ground")
                end
            end
        end

		Events.OnFillWorldObjectContextMenu.Add(JukeboxMenus.addLifestyleDance)
    end
end

Jukebox.hostEnabledLifestyleIntegrations = function()
    return SandboxVars and SandboxVars.TrueMusicJukebox and SandboxVars.TrueMusicJukebox.enableLifestyleIntegrations
end

Jukebox.checkLifestyleIntegrations = function(playerIndex, player)
    if Jukebox.enabledLifestyleIntegrations then return end

    Jukebox.enabledLifestyleIntegrations = Jukebox.hostEnabledLifestyleIntegrations()

    -- Only happens once per client launch.
    if Jukebox.enabledLifestyleIntegrations then 
        Jukebox.enableLifestyleIntegrations()
    end
end

Events.OnCreatePlayer.Add(Jukebox.checkLifestyleIntegrations)

-- All decorations in this file can be required after the game has begun
-- because Jukebox above can be imported from "Jukebox/Utility"; this can
-- be required from "shared", but Decorations above will remain inaccessible
-- until "client" has loaded.
