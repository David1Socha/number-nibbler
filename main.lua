function love.load()
  love.window.setMode(1280,720)
  Categories = require "categories"
  Difficulties = require "difficulties"
  ButtonManager = require "button_manager"
  Gamestate = require "hump.gamestate"
  menu = require "menu"
  vector = require "hump.vector"
  game = require "game"
  pause = require "pause"
  defeat = require "defeat"
  Timer = require "hump.timer"
  require "equality"
  math.randomseed(os.time())
  Gamestate.registerEvents()
  Gamestate.switch(menu)
  d = 0
end

function love.update(dt)
  if not game.paused then
    d=dt
    Timer.update(dt)
  end
end
