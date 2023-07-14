push = require 'push'

-- classic OOP class library
Class = require 'class'

-- bird class we've written
require 'Bird'

require 'Pipe'

require 'PipePair'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720 

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

-- local means i can only acces the variable in this file
local background = love.graphics.newImage('background.png')
local backgroundScroll = 0

local ground = love.graphics.newImage('ground.png')
local groundScroll  = 0

local BACKGROUND_SCROLL_SPEED = 30 
local GROUND_SCROLL_SPEED = 60

-- point at which we should loop our background back to X 0
local BACKGROUND_LOOPING_POINT = 413
-- point at which we should loop our ground back to X 0
local GROUND_LOOPING_POINT = 514

local bird = Bird()

local pipePairs = {}
local timer = 0


-- initialize our last recorded Y value for a gap placement to base other gaps off of
local lastY = -PIPE_HEIGHT + math.random(80) + 20

-- scrolling variable to pause the game when we collide with a pipe
local scrolling = true

function love.load()
    love.graphics.setDefaultFilter( 'nearest', 'nearest')
    love.window.setTitle('CCHE Flappy Bird')

    math.randomseed(os.time())

    push:setupScreen( VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    -- initialize input table
    love.keyboard.keysPressed = {}

end

function love.resize(w,h)
    push:resize(w,h)
end

function love.keypressed(key)
    -- add to our table of keys pressed this frame
    love.keyboard.keysPressed[key] = true
    
    if key == 'escape' then
        love.event.quit()
    end
end

function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true    
    else
        return false
    end    
end


function love.update(dt)
    if scrolling then 
        backgroundScroll = ( backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
        groundScroll = ( groundScroll + GROUND_SCROLL_SPEED * dt) % GROUND_LOOPING_POINT
        
        timer = timer + dt
        
        if timer > 2 then
            -- modify the last Y coordinate we placed so pipe gaps aren't too far apart
            -- no higher than 10 pixels below the top edge of the screen,
            -- and no lower than a gap length (90 pixels) from the bottom
            local y = math.max(-PIPE_HEIGHT + 10, 
                math.min(lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
            lastY = y

            table.insert(pipePairs, PipePair(y))
            timer = 0
        end
        
        bird:update(dt) 

        for k, pair in pairs(pipePairs) do
            pair:update(dt)

            -- check to see if bird collided with pipe
            for l, pipe in pairs(pair.pipes) do
                if bird:collides(pipe) then
                    -- pause the game to show collision
                    scrolling = false
                end
            end

            -- if pipe is no longer visible past left edge, remove it from scene
            if pair.x < -PIPE_WIDTH then
                pair.remove = true
            end
        end

        
        -- remove any flagged pipes
        -- we need this second loop, rather than deleting in the previous loop, because
        -- modifying the table in-place without explicit keys will result in skipping the
        -- next pipe, since all implicit keys (numerical indices) are automatically shifted
        -- down after a table removal
        for k, pair in pairs(pipePairs) do
            if pair.remove then
                table.remove(pipePairs, k)
            end
        end
    end
    -- reset input table
    love.keyboard.keysPressed = {}
end


function love:draw()
    push:start()
        love.graphics.draw(background, -backgroundScroll, 0 )
        
        -- rendering pies
        for k , pair in  pairs(pipePairs) do
            pair:render()
        end

        love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 10)
        bird:render()
    push:finish()
end