PlayState = Class{__includes = BaseState}

PIPE_SPEED = 60
PIPE_WIDTH = 70
PIPE_HEIGHT = 288

BIRD_WIDTH = 38
BIRD_HEIGHT = 24

function PlayState:enter(params)
	self.bird = params.bird or Bird()
	self.pipePairs = params.pipes or {}
	self.timer = params.timer or 0
	self.interval = math.random(2, 5)
	self.score = params.score or 0

 self.lastY = -PIPE_HEIGHT + math.random(80) + 20

 scrolling = true
end

function PlayState:update(dt)
	-- update timer for pipe spawning
	self.timer = self.timer + dt

	-- spawn a new pipe pair every second and a half
	if self.timer > self.interval then

		local y = math.max(-PIPE_HEIGHT + 10, 
		math.min(self.lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
		self.lastY = y

	-- add a new pipe pair at the end of the screen at our new Y
		table.insert(self.pipePairs, PipePair(y))

	-- reset timer
		self.timer = 0
	-- sets interval to a new random value
		self.interval = math.random(2, 5)
	end

	-- for every pair of pipes..
	for k, pair in pairs(self.pipePairs) do

		if not pair.scored then
			if pair.x + PIPE_WIDTH < self.bird.x then
				self.score = self.score + 1
				pair.scored = true
				sounds['score']:play()
			end
		end

		-- update position of pair
		pair:update(dt)
	end


	for k, pair in pairs(self.pipePairs) do
		if pair.remove then
			table.remove(self.pipePairs, k)
		end
	end

	-- simple collision between bird and all pipes in pairs
	for k, pair in pairs(self.pipePairs) do
		for l, pipe in pairs(pair.pipes) do
			if self.bird:collides(pipe) then
				sounds['explosion']:play()
				sounds['hurt']:play()

				gStateMachine:change('score', {
				score = self.score
				})
			end
		end
	end

	-- update bird based on gravity and input
	self.bird:update(dt)

	if love.keyboard.wasPressed('p') then
		gStateMachine:change('pause', {
		bird = self.bird,
		score = self.score,
		pipes = self.pipePairs,
		timer = self.timer
		})
	end

	-- reset if we get to the ground
	if self.bird.y > VIRTUAL_HEIGHT - 15 then
		sounds['explosion']:play()
		sounds['hurt']:play()

		gStateMachine:change('score', {
		score = self.score
		})
	end
end

function PlayState:render()
	for k, pair in pairs(self.pipePairs) do
		pair:render()
	end

	love.graphics.setFont(flappyFont)
	love.graphics.print('Score: ' .. tostring(self.score), 8, 8)

	self.bird:render()
end

function PlayState:exit()
	-- stop scrolling for the death/score screen
	scrolling = false
end