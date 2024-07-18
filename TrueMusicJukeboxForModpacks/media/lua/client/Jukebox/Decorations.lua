local Jukebox = require("Jukebox/Utility")
local JukeboxMenus = require("Jukebox/Menu")
local JukeboxSound = require("Jukebox/Sound")

if not Exterminator then
    -- Protects Against a Known Options Bug
    Exterminator = {}

    Exterminator.onEnterFromGame = MainScreen.onEnterFromGame

    function MainScreen:onEnterFromGame()
        Exterminator.onEnterFromGame(self)

        -- Guarantee that when you ENTER the options menu, the game does not think you've already changed your damn options.
        MainOptions.instance.gameOptions.changed = false
    end
end

-- Inventory Pane Decorations

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

-- Causes pop-up that cannot be closed when this mod is improperly reuploaded (as in a bad modpack).
-- If you're a true modder, ping me on Discord for access to this.
local JukeboxMisuseAlert = ISPanelJoypad:derive("JukeboxMisuseAlert") 

JukeboxMisuseAlert.fontHeightLarge = getTextManager():getFontHeight(UIFont.Large)

function JukeboxMisuseAlert:onClick()
    self.clickCount = self.clickCount + 1

    -- Opens a maximum of 4 times if people spam click this or need to open the URL twice.
    if self.clickCount > 1 and self.clickCount % 3 ~= 0 then return end
    if self.clickCount > 3 and self.clickCount % 6 ~= 0 then return end
    if self.clickCount > 12 then return end

	openUrl(self.url)
end

function JukeboxMisuseAlert:initialise()
    ISPanelJoypad.initialise(self)
    self.visitWorkshop = ISButton:new(0, 0, self.width, self.height, "", self, JukeboxMisuseAlert.onClick)
    self.visitWorkshop.internal = "OK"
    self.visitWorkshop.anchorTop = false
    self.visitWorkshop.anchorBottom = true
    self.visitWorkshop:initialise()
    self.visitWorkshop:instantiate()
    self.visitWorkshop.borderColor = { r = 0, g = 1, b = 0, a = 0.2 }
    self.visitWorkshop.backgroundColor = { r = 0, g = 0, b = 0, a = 0 }
    self.visitWorkshop.backgroundColorPressed = { r = 0.9, g = 0.6, b = 0.2, a = 0.5 }
    self.visitWorkshop.backgroundColorMouseOver = { r = 0.5, g = 1, b = 0.5, a = 0.1 }
    self:addChild(self.visitWorkshop)
end

function JukeboxMisuseAlert:prerender()
    if not self.red and self.clickCount > 12 then
        self.visitWorkshop.backgroundColorMouseOver = { r = 1, g = 0.5, b = 0.5, a = 0.2 }
        self.red = true
    end

    self:drawRect(0, 0, self.width, self.height, self.backgroundColor.a, self.backgroundColor.r, self.backgroundColor.g, self.backgroundColor.b)
    self:drawRectBorder(0, 0, self.width, self.height, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b)
    self:drawText(self.alert, self.textX1, self.textY1, self.alertColor.r, self.alertColor.g, self.alertColor.b, self.alertColor.a, UIFont.Large)
    self:drawText(self.subtext, self.textX2, self.textY2, self.subtextColor.r, self.subtextColor.g, self.subtextColor.b, self.subtextColor.a, UIFont.Large)
    self:drawText(self.workshop, self.textX3, self.textY3, self.workshopColor.r, self.workshopColor.g, self.workshopColor.b, self.workshopColor.a, UIFont.Large)
	self:bringToTop()
end

function JukeboxMisuseAlert:new(x, y, width, height, player, url, alert, subtext, workshop)
    local o = ISPanelJoypad.new(self, x, y, width, height)

    o.clickCount = 0
    o.moveWithMouse = true
    o.borderColor = { r = 1.0, g = 1.0, b = 0.0, a = 0.5 }
    o.buttonBorderColor = { r = 0.7, g = 0.7, b = 0.7, a = 0.5 }
    o.backgroundColor = { r = 0.0, g = 0.0, b = 0.0, a = 1.0 }
    o.alertColor = { r = 1.0, g = 0.6, b = 0.0, a = 1.0 }
    o.subtextColor = { r = 0.2, g = 0.6, b = 0.2, a = 1.0 }
    o.workshopColor = { r = 1.0, g = 0.6, b = 0.6, a = 1.0 }
    o.playerIndex = player:getPlayerNum()
    o.player = player
    o.url = url
    o.alert = alert
    o.subtext = subtext
    o.workshop = workshop
    o.textX1 = (width / 2) - (getTextManager():MeasureStringX(UIFont.Large, o.alert) / 2)
    o.textX2 = (width / 2) - (getTextManager():MeasureStringX(UIFont.Large, o.subtext) / 2)
    o.textX3 = (width / 2) - (getTextManager():MeasureStringX(UIFont.Large, o.workshop) / 2)
    o.textY1 = (height / 2) - (3 * (JukeboxMisuseAlert.fontHeightLarge / 2)) - 10
    o.textY2 = (height / 2) - (JukeboxMisuseAlert.fontHeightLarge / 2)
    o.textY3 = (height / 2) + (JukeboxMisuseAlert.fontHeightLarge / 2) + 10

    JukeboxMisuseAlert.instance = o

    Events.OnTick.Add(JukeboxMisuseAlert.ruthlessBehavior)

    return o
end

JukeboxMisuseAlert.ruthlessBehavior = function()
    if JukeboxMisuseAlert.instance and not JukeboxMisuseAlert.instance:isVisible() then
        JukeboxMisuseAlert.instance:setVisible(true)
        JukeboxMisuseAlert.instance:addToUIManager()
    end
end

Jukebox.modInfo = getModInfoByID("TrueMusicJukebox")

Jukebox.misuseDetected = Jukebox.modInfo and Jukebox.modInfo:getWorkshopID() and 
    Jukebox.modInfo:getWorkshopID() ~= "3118990099" and Jukebox.modInfo:getWorkshopID() ~= "3059476842"

Jukebox.noSoupForYou = function(playerIndex, player)
    local location = "https://steamcommunity.com/sharedfiles/filedetails/?id=" .. Jukebox.modInfo:getWorkshopID()

	local modal = JukeboxMisuseAlert:new(0, 0, getCore():getScreenWidth(), getCore():getScreenHeight() / 3, 
        player, location, Jukebox.translation.changeModID, Jukebox.translation.cannotCloseThis, 
        getText("UI_TrueMusicJukebox_feedback_fixOrUnsubscribe", Jukebox.modInfo:getWorkshopID()))

	modal:initialise()

	modal:addToUIManager()
end

if Jukebox.misuseDetected then
    Events.OnCreatePlayer.Add(Jukebox.noSoupForYou)
end

-- Lifestyle Compatibility and Integrations

Jukebox.enableLifestyleIntegrations = function()
    require("JukeboxContextMenu")

    -- Lifestyle Muting Edits

    if JukeboxMenu then -- NOT JukeboxMenus; JukeboxMenu is a global table from Lifestyle.
        Jukebox.muteTrueMusicJukebox = function(jukebox, square)
            local key = Jukebox.squareToKey(square)
    
            sendClientCommand("TrueMusicJukebox", "sync", {key = key, volume = 0})
        end        

        Jukebox.muteLifestyle = function(jukebox)
            local emitter = jukebox:getModData().Emitter
            -- 
            if emitter and not emitter:isEmpty() then
                emitter:stopAll()
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
                
                if square then Jukebox.muteTrueMusicJukebox(jukebox, square) end
    
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
