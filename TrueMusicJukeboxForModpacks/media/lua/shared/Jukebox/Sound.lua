local JukeboxSound = ISBaseObject:derive("JukeboxSound")

function JukeboxSound:new(maxRange, threeDimensionalAudio)
	local o = {}
	setmetatable(o, self)
	self.__index = self

	o.changing = false
	o.baseMaxRange = maxRange
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

	self.volume = volume or 0

	if self.sound3d then
		-- Let game handle distance in 3D mode.
		local modifier = self.volume * 1.2

		self.emitter:setVolume(self.id, self.volume * modifier) --> Gives 3D similar max loudness to non-3D.
	else
		-- Default if not supplied.
		self.distance = distance or self.distance or self.maxRange

		self.maxRange = self.baseMaxRange * math.min(1.5, math.max(1, self.volume))

		local modifier = (self.maxRange - math.min(self.maxRange, self.distance)) / self.maxRange

		self.emitter:setVolume(self.id, self.volume * modifier)
	end
	
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
