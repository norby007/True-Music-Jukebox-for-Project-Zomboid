-- Based on QuickMessage from Wookiee Gamepad Support (Fades Out and Hides Itself)

local Jukebox = require("Jukebox/Utility")

local JukeboxFeedback = ISPanel:derive("JukeboxFeedback")

function JukeboxFeedback:show(message)

    self.displayTime = Jukebox.options.accessibilityModeDisplayTime * (2 * Jukebox.oneRealHalfSecond)

	if self.fadeTicks and self.fadeTicks > 0 then
		self.messageQueue[#self.messageQueue + 1] = message
        return
	end

	self.time = Jukebox.getTime()

    self.message = message or "ERROR: No message provided."
    self.fadeTicks = 100 -- Used for fadeout and message queue.

    self.font = UIFont.Large

    self:setWidth(getTextManager():MeasureStringX(self.font, self.message) + 20)

    self:setX((getCore():getScreenWidth() / 2) - (self:getWidth() / 2))

    self:addToUIManager()
    self:setVisible(true)

    self:draw()

end

function JukeboxFeedback:draw()

    local opacity = math.min(1, self.fadeTicks / 100)

    local textHeight = getTextManager():getFontHeight(self.font)

    self:drawRectStatic(0, 0, self.width, self.height, opacity, self.backgroundColor.r, self.backgroundColor.g, self.backgroundColor.b);
    
    self:drawRectBorderStatic(0, 0, self.width, self.height, opacity, self.borderColor.r, self.borderColor.g, self.borderColor.b);

    self:drawTextCentre(self.message, self.width / 2, self.height / 2 - (textHeight / 2), 1, 0.6, 0, opacity, UIFont.Medium)

end

function JukeboxFeedback:prerender()

    if not (self.message and self.fadeTicks) then return end

    self:draw()

	local now = Jukebox.getTime()

	local minuend = (now > self.time and now) or (24 + now)

	local difference = minuend - self.time

	-- Gives at least 5 seconds before fadeout.
	
	if difference < self.displayTime then return end

    self.fadeTicks = self.fadeTicks - 1

    if self.fadeTicks < 90 and #self.messageQueue > 0 then
        self.fadeTicks = 0
        local message = self.messageQueue[1]
        self:show(message)
        table.remove(self.messageQueue, 1)
        return
    end

    if self.fadeTicks == 0 then 
        self.message = nil
        self.fadeTicks = nil
        self:close()
        self:removeFromUIManager()
    end

end

function JukeboxFeedback:new(width, height, background)

    local o = {}

    local x = (getCore():getScreenWidth() / 2) - (width / 2)
    local y = (getCore():getScreenHeight() / 2) - (height / 2) - 200

	o = ISPanel:new(x, y, width, height)

    setmetatable(o, self)

    self.__index = self

    o.backgroundColor = background
    o.fadeTicks = fadeTicks
    o.message = message

	o.displayTime = Jukebox.options.accessibilityModeDisplayTime * (2 * Jukebox.oneRealHalfSecond)

	o.messageQueue = {}

	o.time = Jukebox.getTime()

    o:initialise()
    
    return o

end

return JukeboxFeedback
