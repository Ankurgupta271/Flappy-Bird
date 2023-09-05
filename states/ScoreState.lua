ScoreState = Class{__includes = BaseState}

local BRONZE_TROPHY = love.graphics.newImage('bronze.png')
local SILVER_TROPHY = love.graphics.newImage('silver.png')
local GOLD_TROPHY = love.graphics.newImage('gold.png')

function ScoreState:enter(params)
	self.score = params.score
end

function ScoreState:update(dt)
	-- go back to play if enter is pressed
	if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
	gStateMachine:change('countdown')
	end
end

function ScoreState:drawTrophy()
	local x = VIRTUAL_WIDTH / 2 - GOLD_TROPHY:getWidth() / 2

	if self.score > 5 then
	love.graphics.setFont(flappyFont)
	love.graphics.printf('Congratulation!, You received Gold Trophy!', 0, 50, VIRTUAL_WIDTH, 'center')
	love.graphics.draw(GOLD_TROPHY, x, 150)
	elseif self.score >= 3 then
	love.graphics.setFont(flappyFont)
	love.graphics.printf('Oof!, You received Silver Trophy!', 0, 68, VIRTUAL_WIDTH, 'center')
	love.graphics.draw(SILVER_TROPHY, x, 150)
	else
	love.graphics.setFont(flappyFont)
	love.graphics.printf('Try Again!, You received Bronze Trophy!', 0, 44, VIRTUAL_WIDTH, 'center')
	love.graphics.draw(BRONZE_TROPHY, x, 150)
	end
end

function ScoreState:render()
	-- simply render the score to the middle of the screen
	

	love.graphics.setFont(mediumFont)
	love.graphics.printf('Score: ' .. tostring(self.score), 0, 120, VIRTUAL_WIDTH, 'center')

	love.graphics.printf('Press Enter to Play Again!', 0, 190, VIRTUAL_WIDTH, 'center')

	-- displays the correct trophy according to the score
	self:drawTrophy()	
end