function love.load()
  love.window.setMode(1280,720)
  Categories = require "categories"
  ButtonManager = require "button_manager"
  Gamestate = require "hump.gamestate"
  menu = require "menu"
  vector = require "hump.vector"
  game = require "game"
  pause = require "pause"
  Timer = require "hump.timer"
  require "equality"
  math.randomseed(os.time())
  line_width = 0.0078125 * love.window.getWidth()
  Gamestate.registerEvents()
  love.graphics.setLineWidth(line_width)
  Gamestate.switch(menu)
  d = 0
end

function love.update(dt)
  if not game.paused then
    d=dt
    Timer.update(dt)
  end
end
