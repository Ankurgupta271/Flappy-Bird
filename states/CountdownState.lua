CountdownState = Class{__includes = BaseState}

COUNTDOWN_TIME = 0.75

function CountdownState:init()
	self.count = 3
	self.timer = 0
end

function CountdownState:enter()
	scrolling = true
end

function CountdownState:update(dt)
	self.timer = self.timer + dt

	if self.timer > COUNTDOWN_TIME then
		self.timer = self.timer % COUNTDOWN_TIME
		self.count = self.count - 1

		if self.count == 0 then
			gStateMachine:change('play', {})
		end
	end
end

function CountdownState:render()
	-- render count big in the middle of the screen
	love.graphics.setFont(hugeFont)
	love.graphics.printf(tostring(self.count), 0, 120, VIRTUAL_WIDTH, 'center')
end