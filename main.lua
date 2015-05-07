Gamestate = require "hump.gamestate"
menu = require("menu")
vector = require("hump.vector")
game = require("game")
Timer = require "hump.timer"
require "equality"

function love.load()
  line_width = 10
  Gamestate.registerEvents()
  love.graphics.setLineWidth(line_width)
  Gamestate.switch(menu)
  d = 0
end

function love.update(dt)
  d=dt
  Timer.update(dt)
end

function love.draw()
end

function love.textinput(t)
end

function love.keypressed(text)
end