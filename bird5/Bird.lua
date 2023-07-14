Bird = Class {}

local GRAVITY = 17

function Bird:init()
    self.image = love.graphics.newImage('bird.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    -- center the bird with his height and width in consideration
    self.x = VIRTUAL_WIDTH / 2  - (self.width / 2 )
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2 ) 
    -- Y velocity; gravity
    self.dy = 0
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end


function Bird:update(dt)
    self.dy = self.dy + GRAVITY * dt
  

    if love.keyboard.wasPressed('space') then
        self.dy = -5    
    end

    self.y = self.y  + self.dy
end