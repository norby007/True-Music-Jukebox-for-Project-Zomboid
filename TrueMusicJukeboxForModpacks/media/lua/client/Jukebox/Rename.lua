
local Jukebox = require("Jukebox/Utility")

local JukeboxMenus = require("Jukebox/Menu")

local JukeboxRenamePanel = ISPanelJoypad:derive("JukeboxRenamePanel")

JukeboxRenamePanel.fontHeightSmall = getTextManager():getFontHeight(UIFont.Small)
JukeboxRenamePanel.fontHeightMedium = getTextManager():getFontHeight(UIFont.Medium)

JukeboxRenamePanel.messages = {}

function JukeboxRenamePanel:initialise()
    ISPanelJoypad.initialise(self)

    self.buttonWidth = 100
    self.buttonHeight = math.max(25, JukeboxRenamePanel.fontHeightSmall + 3 * 2)
    self.padBottom = 10

    self.entryX = 10
    self.entryY = 20 + JukeboxRenamePanel.fontHeightMedium + 20
    self.entryWidth = self.width - (self.entryX * 2)

    self.entry = ISTextEntryBox:new(JukeboxMenus.getMenuName(self.key), self.entryX, self.entryY, self.entryWidth, JukeboxRenamePanel.fontHeightSmall + 2 * 2)
    self.entry.font = UIFont.Small
    self.entry:initialise()
    self.entry:instantiate()
    self:addChild(self.entry)

    self.ok = ISButton:new(10, self.entry:getBottom() + 20, self.buttonWidth, self.buttonHeight, getText("IGUI_ServerToolBox_Accept"), self, JukeboxRenamePanel.onClick)
    self.ok.internal = "OK"
    self.ok:initialise()
    self.ok:instantiate()
    self.ok.borderColor = { r = 1, g = 1, b = 1, a = 0.1 }
    self:addChild(self.ok)

    self.edit = ISButton:new((self.width / 2) - (self.buttonWidth / 2), self.ok.y, self.buttonWidth, self.buttonHeight, getText("IGUI_TextBox_Edit"), self, JukeboxRenamePanel.onClick);    
    self.edit.internal = "EDIT"
    self.edit:initialise()
    self.edit:instantiate()
    self.edit.borderColor = { r = 1, g = 1, b = 1, a = 0.1 }
    self:addChild(self.edit)

    if not Jukebox.getJoypadData(self.playerIndex) then
        self.edit:setVisible(false)
    end

    self.no = ISButton:new(self:getWidth() - self.buttonWidth, self.ok.y, self.buttonWidth, self.buttonHeight, getText("UI_Cancel"), self, JukeboxRenamePanel.onClick)
    self.no.internal = "CANCEL"
    self.no:initialise()
    self.no:instantiate()
    self.no.borderColor = { r = 1, g = 1, b = 1, a = 0.1 }
    self:addChild(self.no)

    self:setHeight(self.no:getBottom() + self.padBottom)
end

function JukeboxRenamePanel:onGainJoypadFocus(joypadData)
    ISPanelJoypad.onGainJoypadFocus(self, joypadData)
    
    self:setISButtonForA(self.edit)
    self:setISButtonForB(self.no)
    self:setISButtonForY(self.ok)

    self.edit:setVisible(true)
    self.no:setVisible(true)
    self.ok:setVisible(true)

    self.no:setX(self.no:getX() - 20)
end

function JukeboxRenamePanel:onLoseJoypadFocus(joypadData)
    ISPanelJoypad.onLoseJoypadFocus(self, joypadData)

    self.edit:setVisible(false)
    self.no:setVisible(false)
    self.ok:setVisible(false)
    
    self.no:setX(self.no:getX() + 20)
end

function JukeboxRenamePanel:onJoypadDown(button, joypadData)
    if button == Joypad.AButton then -- I believe this summons the keyboard.
        self.entry:onJoypadDown(button, joypadData)
    elseif button == Joypad.YButton and self.ok.enable then
        self:onClick({ internal = "OK" })
    elseif button == Joypad.YButton then
        Jukebox.reportMessage(self.player, "That key seems a bit long.")
    elseif button == Joypad.BButton then
        self:onClick({ internal = "CANCEL" })
    end
end

function JukeboxRenamePanel:render()
    self:updateButtons()
    if self.player:isDead() then self:onClick({ internal = "CANCEL", disconnect = true }) end
    if Jukebox.isJoypadDisconnected(self.playerIndex) then self:onClick({ internal = "CANCEL", disconnect = true }) end
end

function JukeboxRenamePanel:prerender()
    self:drawRect(0, 0, self.width, self.height, self.backgroundColor.a, self.backgroundColor.r, self.backgroundColor.g, self.backgroundColor.b)
    self:drawRectBorder(0, 0, self.width, self.height, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b)
    self:drawText(Jukebox.translation.renameKeyBelow, (self.width / 2) - (getTextManager():MeasureStringX(UIFont.Medium, Jukebox.translation.renameKeyBelow) / 2), 20, 1, 1, 1, 1, UIFont.Medium)
	self:bringToTop()
end

function JukeboxRenamePanel:updateButtons()
    self.ok.enable = true

    local tagName = self.entry:getInternalText()

    if getTextManager():MeasureStringX(UIFont.Small, tagName) > self.entryWidth - 5 then
        self.ok.enable = false
        self.borderColor = { r = 1.0, g = 0.0, b = 0.0, a = 0.666 }
    else 
        self.borderColor = { r = 1.0, g = 1.0, b = 0.0, a = 0.5 }
    end
end

function JukeboxRenamePanel:onClick(button)
    if button.internal == "CANCEL" then
        self:setVisible(false)
        self:removeFromUIManager()
        if button.disconnect then return end
    end
    if button.internal == "OK" then
        Jukebox.keyRing[self.key] = self.entry:getText()
        self:setVisible(false)
        self:removeFromUIManager()
    end
    local inventory = getPlayerInventory(self.playerIndex)
    setJoypadFocus(self.playerIndex, inventory)
end

function JukeboxRenamePanel:new(x, y, width, height, player, key)
    local o = {}

    o = ISPanelJoypad:new(x, y, width, height)

    setmetatable(o, self)
    self.__index = self

    o.moveWithMouse = true
    o.borderColor = { r = 1.0, g = 1.0, b = 0.0, a = 0.5 }
    o.buttonBorderColor = { r = 0.7, g = 0.7, b = 0.7, a = 0.5 }
    o.backgroundColor = { r = 0.0, g = 0.0, b = 0.0, a = 1.0 }
    o.playerIndex = player:getPlayerNum()
    o.player = player
    o.key = key
    
    return o
end

-- Because I am a bit OCD about grammar and I hate looking at this spelling:

if not getTextOriginal then
    getTextOriginal = getText
    getText = function(text, ...)
        if text == "IGUI_ServerToolBox_Accept" then
            return getTextOriginal("IGUI_ServerToolBox_acccept")
        else
            return getTextOriginal(text, ...)
        end
    end
end

return JukeboxRenamePanel
