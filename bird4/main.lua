push = require 'push'

-- classic OOP class library
Class = require 'class'

-- bird class we've written
require 'Bird'


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

local BACKGROUND_LOOPING_POINT = 413

local bird = Bird()

function love.load()
    love.graphics.setDefaultFilter( 'nearest', 'nearest')
    love.window.setTitle('CCHE Flappy Bird')

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
    backgroundScroll = ( backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
    groundScroll = ( groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH

    bird:update(dt) 
    
    -- reset input table
    love.keyboard.keysPressed = {}
end


function love:draw()
    push:start()
        love.graphics.draw(background, -backgroundScroll, 0 )
        love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 10)
        bird:render()
    push:finish()
end