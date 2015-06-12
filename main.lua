function love.load()
  love.window.setMode(1280,720)
  ButtonManager = require "button.button_manager"
  Gamestate = require "hump.gamestate"
  menu = require "menu"
  vector = require "hump.vector"
  game = require "game"
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
  d=dt
  Timer.update(dt)
end

function love.draw()
end
