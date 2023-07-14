push = require 'push'

WINDOW_WIDTH = 1280
WINDOWS_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

-- local means i can only acces the variable in this file
local background = love.graphics.newImage('background.png')
local ground = love.graphics.newImage('ground.png')


function love.load()
    love.graphics.setDefaultFilter( 'nearest', 'nearest')
    love.window.setTitle('CCHE Flappy Bird')

    push:setupScreen( VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOWS_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

end

function love:resize(w,h)
    push:resize(w,h)
end

function love:keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love:draw()
    push:start()
        love.graphics.draw(background, 0, 0 )
        love.graphics.draw(ground, 0, VIRTUAL_HEIGHT - 10)
    push:finish()
end