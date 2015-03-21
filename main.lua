Gamestate = require "hump.gamestate"
menu = require("menu")
vector = require("hump.vector")
game = require("game")
Timer = require "hump.timer"
require "monocle.monocle"
require "equality"
Monocle.new({})

function love.load()
  Gamestate.registerEvents()
  Gamestate.switch(menu)
  d = 0
  Monocle.watch("dt", function() return d end)
end

function love.update(dt)
  d=dt
  Monocle.update()
  Timer.update(dt)
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