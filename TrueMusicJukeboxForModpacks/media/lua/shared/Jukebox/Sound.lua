local JukeboxSound = ISBaseObject:derive("JukeboxSound")

-- Not a true default; just initialized here to guarantee 
-- safe calling of functions that depend on it.
JukeboxSound.mainVolume = 0

JukeboxSound.mainVolumeBoost = 1

JukeboxSound.mainVolumeDivisor = 5

JukeboxSound.mainVolumeBoostDivisor = 15

JukeboxSound.mainVolumeSelectedDefault = 5

JukeboxSound.mainVolumeBoostSelectedDefault = 0

JukeboxSound.getMainVolume = function()
	return JukeboxSound.mainVolumeSelected / JukeboxSound.mainVolumeDivisor
end

JukeboxSound.getMainVolumeBoost = function()
	local mainVolumeBoostNumerator = JukeboxSound.mainVolumeBoostSelected + JukeboxSound.mainVolumeBoostDivisor
	return mainVolumeBoostNumerator / JukeboxSound.mainVolumeBoostDivisor
end 

function JukeboxSound:new(maxRange, threeDimensionalAudio)
	local o = {}
	setmetatable(o, self)
	self.__index = self

	o.changing = false
	o.maxRange = maxRange
	o.distance = maxRange
	o.emitter = nil
	o.id = nil
	o.x = 0
	o.y = 0
	o.z = 0
	o.volume = 0
	o.sound3d = (SandboxVars.TrueMusicJukebox and SandboxVars.TrueMusicJukebox.forceThreeDimensionalAudio) or threeDimensionalAudio

	return o
end

function JukeboxSound:setEmitter(emitter)
	self.emitter = emitter
end

function JukeboxSound:setPosition(x, y, z)
	self.x = x
	self.y = y
	self.z = z

	if self.emitter then
		self.emitter:setPos(x, y, z)
		self.emitter:tick()
	end
end

function JukeboxSound:getVolume()

	return self.volume

end

function JukeboxSound:getLastDistance()

	return self.distance

end

function JukeboxSound:getSoundType()

	return self.soundType

end

function JukeboxSound:setVolume(volume, distance)
	if not self.id then return end

	local mainVolume = JukeboxSound.mainVolume
	local mainVolumeBoost = JukeboxSound.mainVolumeBoost

	self.volume = volume or 0

	-- Determines how far away zombies will be able to hear the box.
	self.zombieRange = self.volume * self.maxRange

	-- Default if not supplied.
	self.distance = distance or self.distance or self.maxRange

	if self.sound3d then
		-- Let game handle distance in 3D mode.
		local modifier = 1.1

		-- Gives vanilla 3D sound similar max perceived loudness to our 3D sound.
		self.modifiedVolume = self.volume * modifier

		local maxRangeIn3D = 70

		local estimatedRangeImpact = maxRangeIn3D == 0 and 0 or 
			((maxRangeIn3D - math.min(maxRangeIn3D, self.distance)) / maxRangeIn3D) ^ 2

		self.audibleVolume = self.modifiedVolume * estimatedRangeImpact
	else
		local modifier = ((self.maxRange - math.min(self.maxRange, self.distance)) / self.maxRange) ^ 2

		self.modifiedVolume = self.volume * modifier

		self.audibleVolume = self.modifiedVolume
	end

	-- A volume higher than 2.2 could not be achieved except through console hacking,
	-- but I don't want any newbies blaming me when they blow out their speakers. Gotta read
	-- this warning before they do it: If you are a newbie, don't blow out your speakers.
	-- Godspeed, decorators.
	self.emitter:setVolume(self.id, math.min(self.modifiedVolume * mainVolume * mainVolumeBoost, 5))
	
	self.emitter:tick()
end

function JukeboxSound:set3D(toggle)
	toggle = toggle or false

	self.sound3d = toggle

	if self.id then
		self.emitter:set3D(self.id, toggle)
		self.emitter:tick()
	end
end

function JukeboxSound:stop()
	if self.emitter and self.id then
		self.emitter:stopSound(self.id)
	end

	self.id = nil
end

function JukeboxSound:isPlaying()
	return self.emitter and self.id and self.emitter:isPlaying(self.id) or false
end

function JukeboxSound:tick()
	if not self:isPlaying() then return end
	self.emitter:tick()
end

function JukeboxSound:play(soundType)
	self.soundType = soundType

	local foundEmitter = self.emitter

	if foundEmitter then
		self:stop()
	elseif IsoWorld.instance:getFreeEmitter(self.x, self.y, self.z) then
		self.emitter = IsoWorld.instance:getFreeEmitter(self.x, self.y, self.z)
		self:stop()
	else
		self.emitter = IsoWorld.instance:getFreeEmitter()
		self:setPosition(self.x, self.y, self.z)
	end

	local newSound = GameSounds.getSound(soundType)
	local newClip = newSound:getRandomClip()

	self.id = self.emitter:playClip(newClip, nil)

	self.emitter:setVolume(self.id, self.volume)
	self.emitter:set3D(self.id, self.sound3d)
	self.emitter:tick()
end

return JukeboxSound
