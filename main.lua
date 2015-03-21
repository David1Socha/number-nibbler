Gamestate = require "hump.gamestate"
menu = require("menu")
game = require("game")
require "monocle.monocle"
Monocle.new({})

function love.load()
  Gamestate.registerEvents()
  Gamestate.switch(menu)
end

function love.update(dt)
  Monocle.update()
end

function love.draw()
  Monocle.draw()
end

function love.textinput(t)
  Monocle.textinput(t)
end

function love.keypressed(text)
  Monocle.keypressed(text)
end