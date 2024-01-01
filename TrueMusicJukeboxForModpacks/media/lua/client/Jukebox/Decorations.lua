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
        local jukeboxData = jukebox:getModData()
        local key = Jukebox.locationToKey(jukeboxData)
        if Jukebox.activeTracks[key] then
            Jukebox.activeTracks[key].sound:stop()
            Jukebox.activeTracks[key] = nil
            Jukebox.activeLocations[key] = nil
            sendClientCommand("Jukebox", "clear", {[key] = true})
            jukeboxData.on = false
            jukebox:transmitModData()
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

    Jukebox.removeTrack(jukebox, item:getType())
end
