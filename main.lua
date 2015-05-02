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
  Monocle.watch("player pos", function() if game.player then return game.player.pos end end)
  Monocle.watch("player dest", function() if game.player then return game.player.dest end end)
  Monocle.watch("player act", function() if game.player then return game.player.act end end)
  Monocle.watch("yes flies", function() return game.yes_flies end)
  Monocle.watch("curr level", function() return game.curr_level end)
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