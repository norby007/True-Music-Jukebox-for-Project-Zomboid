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
                ModData.transmit("Jukebox.activeLocations")
                sendClientCommand("TrueMusicJukebox", "transmit", {[key] = jukeboxData})
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

    local jukebox = item:getContainer():getParent()

    if not jukebox then return end

	local key = Jukebox.squareToKey(jukebox:getSquare())

    local location = Jukebox.keyToLocation(key)

	local jukeboxData = Jukebox.activeLocations[key]

    if not jukeboxData then return end

    Jukebox.removeTrack(jukeboxData, item:getType())

    ModData.transmit("Jukebox.activeLocations")

    sendClientCommand("TrueMusicJukebox", "transmit", {[key] = jukeboxData})
end
