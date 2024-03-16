-- DOME Options Page Decoration

local Jukebox = require("Jukebox/Utility")
local JukeboxMenus = require("Jukebox/Menu")
local JukeboxSound = require("Jukebox/Sound")

local DOME = Jukebox.DOME or require("DOME")
local GameOption = DOME.require("GameOption")
local GameOptions = DOME.require("GameOptions")

local JukeboxOptions = {}

JukeboxOptions.refresh = function()
    if Jukebox.MainOptions and Jukebox.MainOptions.instance then
        Jukebox.MainOptions.instance.gameOptions:toUI()
        Jukebox.MainOptions.instance.gameOptions.changed = true
    end
end

Jukebox.GameOptions = {} 

Jukebox.GameOptions.apply = GameOptions.apply

function GameOptions:apply()

    if Jukebox.GameOptions.flipper == nil then
        Jukebox.GameOptions.flipper = Jukebox.options.considerDistanceWhenPlayingOverride
    end

    local considerDistanceWasOn = Jukebox.options.considerDistanceWhenPlayingOverride
    local ignoreDistanceWasOn = Jukebox.options.ignoreDistanceWhenPlayingOverride

    Jukebox.GameOptions.apply(self)

    local considerDistanceIsOn = Jukebox.options.considerDistanceWhenPlayingOverride
    local ignoreDistanceIsOn = Jukebox.options.ignoreDistanceWhenPlayingOverride

    local considerDistanceActivated = considerDistanceIsOn and not considerDistanceWasOn
    local ignoreDistanceActivated = ignoreDistanceIsOn and not ignoreDistanceWasOn

    -- Mutual exclusivity was a headache.
    if ignoreDistanceIsOn and considerDistanceIsOn then
        Jukebox.GameOptions.flipper = not Jukebox.GameOptions.flipper
        if Jukebox.GameOptions.flipper then -- Activate ugliest workaround in the entire mod!
            JukeboxOptions.ignoreDistanceWhenPlayingOverride.control.selected[1] = false
            Jukebox.options.ignoreDistanceWhenPlayingOverride = false
        else
            JukeboxOptions.considerDistanceWhenPlayingOverride.control.selected[1] = false
            Jukebox.options.considerDistanceWhenPlayingOverride = false
        end
    end

    Jukebox.writeSettings()
end

Jukebox.MainOptions = {}

Jukebox.MainOptions.create = MainOptions.create

function MainOptions:create()
    -- I don't think this is actually necessary; it's protective.
    local creation = Jukebox.MainOptions.create(self)

    Jukebox.MainOptions.instance = self

    Jukebox.readSettings()

    self:addPage(Jukebox.translation.pageTitle)
    
    self.addY = 0

    local y = 20;
    
    local splitPoint = self:getWidth() / 2;

    local comboWidth = 300
    
    JukeboxOptions.mainVolume = JukeboxMenus.addMainVolumeOption(self, splitPoint, y, comboWidth)

    JukeboxOptions.mainVolumeBoost = JukeboxMenus.addMainVolumeBoostOption(self, splitPoint, y, comboWidth)

    JukeboxOptions.hideMenuIcons = JukeboxMenus.addCheckboxOption(self, 
        "hideMenuIcons", splitPoint, y, comboWidth)
    JukeboxOptions.invertToggleIconFeedback = JukeboxMenus.addCheckboxOption(self, 
        "invertToggleIconFeedback", splitPoint, y, comboWidth)
    JukeboxOptions.hideTracklistFromContextMenu = JukeboxMenus.addCheckboxOption(self, 
        "hideTracklistFromContextMenu", splitPoint, y, comboWidth)
    JukeboxOptions.showEveryTrackInPortablePlaylist = JukeboxMenus.addCheckboxOption(self, 
        "showEveryTrackInPortablePlaylist", splitPoint, y, comboWidth)
    JukeboxOptions.showEveryTrackInJukeboxPlaylist = JukeboxMenus.addCheckboxOption(self, 
        "showEveryTrackInJukeboxPlaylist", splitPoint, y, comboWidth)
    JukeboxOptions.showEveryTrackInJukeboxQueue = JukeboxMenus.addCheckboxOption(self, 
        "showEveryTrackInJukeboxQueue", splitPoint, y, comboWidth)
    JukeboxOptions.threeDimensionalAudio = JukeboxMenus.addCheckboxOption(self, 
        "threeDimensionalAudio", splitPoint, y, comboWidth)
    JukeboxOptions.invertToggleIconFeedback = JukeboxMenus.addCheckboxOption(self, 
        "invertToggleIconFeedback", splitPoint, y, comboWidth)
    JukeboxOptions.ignoreDistanceWhenPlayingOverride = JukeboxMenus.addCheckboxOption(self, 
        "ignoreDistanceWhenPlayingOverride", splitPoint, y, comboWidth)
    JukeboxOptions.considerDistanceWhenPlayingOverride = JukeboxMenus.addCheckboxOption(self, 
        "considerDistanceWhenPlayingOverride", splitPoint, y, comboWidth)
    JukeboxOptions.alwaysTellMyFriends = JukeboxMenus.addCheckboxOption(self, 
        "alwaysTellMyFriends", splitPoint, y, comboWidth)
    JukeboxOptions.hideTransferAllTrueMusic = JukeboxMenus.addCheckboxOption(self, 
        "hideTransferAllTrueMusic", splitPoint, y, comboWidth)
    JukeboxOptions.dancingComesFirst = JukeboxMenus.addCheckboxOption(self, 
        "dancingComesFirst", splitPoint, y, comboWidth)
    JukeboxOptions.requireMusicForLifestyleDance = JukeboxMenus.addCheckboxOption(self, 
        "requireMusicForLifestyleDance", splitPoint, y, comboWidth)
    JukeboxOptions.feedbackAccessibilityMode = JukeboxMenus.addCheckboxOption(self, 
        "feedbackAccessibilityMode", splitPoint, y, comboWidth)
    
    JukeboxOptions.accessibilityModeDisplayTime = JukeboxMenus.addAccessibilityModeDisplayTimeOption(self, splitPoint, y, comboWidth)
    
    self.mainPanel:setScrollHeight(y + self.addY + 20)

    return creation
end

JukeboxMenus.addMainVolumeOption = function(mainOptions, splitPoint, y, comboWidth)
    local control = mainOptions:addMegaVolumeControl(splitPoint, y, comboWidth, 20, 
        Jukebox.translation.mainVolume, JukeboxSound.mainVolumeSelected)
    
    control:setVolume(JukeboxSound.mainVolumeSelected)
    
    -- Overrides this object's render function with a new
    -- one that uses green as the special color for maximum.
    control.render = JukeboxMenus.renderGreenMax

    control.tooltip = Jukebox.translation.mainVolumeTooltip

    local gameOption = GameOption:new('mainVolumeTrueMusicJukebox', control)

    function gameOption:toUI() return end

    function gameOption:apply()
        JukeboxSound.mainVolumeSelected = self.control:getVolume()
        JukeboxSound.mainVolume = JukeboxSound.getMainVolume()
        Jukebox.updateActiveJukeboxVolumes()
    end

    mainOptions.gameOptions:add(gameOption)

    return gameOption
end

JukeboxMenus.addMainVolumeBoostOption = function(mainOptions, splitPoint, y, comboWidth)
    local control = mainOptions:addMegaVolumeControl(splitPoint, y, comboWidth, 20, 
        Jukebox.translation.mainVolumeBoost, JukeboxSound.mainVolumeBoostSelected)

    -- Overrides this object's render function with a new
    -- one that uses green as the special color for maximum.
    control.render = JukeboxMenus.renderGreenMax

    control.tooltip = Jukebox.translation.mainVolumeBoostTooltip

    local gameOption = GameOption:new('mainVolumeBoostTrueMusicJukebox', control)

    function gameOption:toUI()
        control:setVolume(JukeboxSound.mainVolumeBoostSelected)
    end

    function gameOption:apply()
        JukeboxSound.mainVolumeBoostSelected = self.control:getVolume()
        JukeboxSound.mainVolumeBoost = JukeboxSound.getMainVolumeBoost()
        Jukebox.updateActiveJukeboxVolumes()
    end

    mainOptions.gameOptions:add(gameOption)

    return gameOption
end

JukeboxMenus.addAccessibilityModeDisplayTimeOption = function(mainOptions, splitPoint, y, comboWidth)
    local control = mainOptions:addMegaVolumeControl(splitPoint, y, comboWidth, 20, 
        Jukebox.translation.accessibilityModeDisplayTime, Jukebox.options.accessibilityModeDisplayTime)

    -- Overrides this object's render function with a new
    -- one that uses no special color for maximum.
    control.render = JukeboxMenus.renderNormalMax

    control.tooltip = Jukebox.translation.accessibilityModeDisplayTimeTooltip

    local gameOption = GameOption:new('accessibilityModeDisplayTimeTrueMusicJukebox', control)

    function gameOption:toUI()
        control:setVolume(Jukebox.options.accessibilityModeDisplayTime - 1)
    end

    function gameOption:apply()
        local state = self.control:getVolume() + 1
        Jukebox.options.accessibilityModeDisplayTime = state
    end

    mainOptions.gameOptions:add(gameOption)

    return gameOption
end

JukeboxMenus.addCheckboxOption = function(mainOptions, checkboxName, splitPoint, y, comboWidth)
    local control = mainOptions:addYesNo(splitPoint, y, comboWidth, 20, getText("UI_TrueMusicJukebox_options_" .. checkboxName))
    
    control.isMouseOver = JukeboxMenus.isMouseOver

    control.tooltip = getText("UI_TrueMusicJukebox_options_" .. checkboxName .. "_tooltip")

    gameOption = GameOption:new(checkboxName .. "TrueMusicJukebox", control)

    function gameOption:toUI()
		self.control:setSelected(1, Jukebox.options[checkboxName] or false)
    end

    function gameOption:apply() 
        local state = self.control:isSelected(1)
        Jukebox.options[checkboxName] = state
    end
    
    mainOptions.gameOptions:add(gameOption)

    return gameOption
end

JukeboxMenus.isMouseOver = function(option)
    local trueMouseOver = ISUIElement.isMouseOver(option)

    if not trueMouseOver then
        if option.tooltipUI and option.tooltipUI:isMouseOver() then return true end
    else return trueMouseOver end
end

-- Just a barely-edited override of an Indie Stone function that only 
-- applies to objects found on the True Music Jukebox options page.
JukeboxMenus.renderGreenMax = function(option)
    option:drawRect(0, 0, option.width, option.height, option.backgroundColor.a, option.backgroundColor.r, option.backgroundColor.g, option.backgroundColor.b)
    local alpha = math.min(option.borderColor.a + 0.2 * option.fade:fraction(), 1.0)
    option:drawRectBorder(0, 0, option.width, option.height, alpha, option.borderColor.r, option.borderColor.g, option.borderColor.b)

    local padX = 8
    local oneTenth = math.floor((option:getWidth() - padX * 2) / 11)
    local sliderWidth = 16
    local sliderPadX = 1
    local sliderPadY = 4
    padX = padX + (option:getWidth() - padX * 2 - oneTenth * 11) / 2
    local sliderX = padX + oneTenth * option.volume - sliderWidth / 2
    local rgb1 = 0.1 + 0.1 * option.fade:fraction()
    local rgb2 = 0.3 + 0.1 * option.fade:fraction()
    option:drawRect(2, sliderPadY, padX - sliderPadX - 2, option:getHeight() - sliderPadY * 2,
        1, rgb2, rgb2, rgb2)
    for index = 1, 11 do
        local rgb = (index <= option.volume) and rgb2 or rgb1
        local elevenGreenBonus = 0.0
        if ((option.volume > 10) and (index > 10)) then
            elevenGreenBonus =  0.420 -- Heh heh heh
        end
        option:drawRect(padX + (index-1) * oneTenth + sliderPadX, sliderPadY,
            oneTenth - sliderPadX * 2, option:getHeight() - sliderPadY * 2,
            1, rgb, rgb + elevenGreenBonus, rgb)
    end

    local x = padX + oneTenth * 11 + sliderPadX
    option:drawRect(x, sliderPadY, option:getWidth() - x - 2, option:getHeight() - sliderPadY * 2,
        1, rgb1, rgb1, rgb1)

    option:drawRect(sliderX, 2, sliderWidth, option:getHeight() - 2 * 2, 1.0, 0.5, 0.5, 0.5)

    option:drawRect(sliderX, 2, sliderWidth, 1, 1.0, 0.75, 0.75, 0.75)
    option:drawRect(sliderX + sliderWidth - 1, 2, 1, option:getHeight() - 2 * 2, 1.0, 0.25, 0.25, 0.25)
    option:drawRect(sliderX, 2, 1, option:getHeight() - 2 * 2, 1.0, 0.75, 0.75, 0.75)
    option:drawRect(sliderX, option:getHeight() - 2 - 1, sliderWidth, 1, 1.0, 0.25, 0.25, 0.25)
end

-- Just a barely-edited override of an Indie Stone function that only 
-- applies to objects found on the True Music Jukebox options page.
JukeboxMenus.renderNormalMax = function(option)
    option:drawRect(0, 0, option.width, option.height, option.backgroundColor.a, option.backgroundColor.r, option.backgroundColor.g, option.backgroundColor.b)
    local alpha = math.min(option.borderColor.a + 0.2 * option.fade:fraction(), 1.0)
    option:drawRectBorder(0, 0, option.width, option.height, alpha, option.borderColor.r, option.borderColor.g, option.borderColor.b)

    local padX = 8
    local oneTenth = math.floor((option:getWidth() - padX * 2) / 11)
    local sliderWidth = 16
    local sliderPadX = 1
    local sliderPadY = 4
    padX = padX + (option:getWidth() - padX * 2 - oneTenth * 11) / 2
    local sliderX = padX + oneTenth * option.volume - sliderWidth / 2
    local rgb1 = 0.1 + 0.1 * option.fade:fraction()
    local rgb2 = 0.3 + 0.1 * option.fade:fraction()
    option:drawRect(2, sliderPadY, padX - sliderPadX - 2, option:getHeight() - sliderPadY * 2,
        1, rgb2, rgb2, rgb2)
    for index = 1, 11 do
        local rgb = (index <= option.volume) and rgb2 or rgb1
        option:drawRect(padX + (index-1) * oneTenth + sliderPadX, sliderPadY,
            oneTenth - sliderPadX * 2, option:getHeight() - sliderPadY * 2,
            1, rgb, rgb, rgb)
    end

    local x = padX + oneTenth * 11 + sliderPadX
    option:drawRect(x, sliderPadY, option:getWidth() - x - 2, option:getHeight() - sliderPadY * 2,
        1, rgb1, rgb1, rgb1)

    option:drawRect(sliderX, 2, sliderWidth, option:getHeight() - 2 * 2, 1.0, 0.5, 0.5, 0.5)

    option:drawRect(sliderX, 2, sliderWidth, 1, 1.0, 0.75, 0.75, 0.75)
    option:drawRect(sliderX + sliderWidth - 1, 2, 1, option:getHeight() - 2 * 2, 1.0, 0.25, 0.25, 0.25)
    option:drawRect(sliderX, 2, 1, option:getHeight() - 2 * 2, 1.0, 0.75, 0.75, 0.75)
    option:drawRect(sliderX, option:getHeight() - 2 - 1, sliderWidth, 1, 1.0, 0.25, 0.25, 0.25)
end

return JukeboxOptions
