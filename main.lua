function love.load()
  love.window.setMode(1280,720)
  Gamestate = require "hump.gamestate"
  menu = require "menu"
  vector = require "hump.vector"
  game = require "game"
  Timer = require "hump.timer"
  loveframes = require("loveframes")
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
  loveframes.update(dt)
end

function love.draw()
end

function love.mousepressed(x,y,button)
  loveframes.mousepressed(x,y,button)
end

function love.mousereleased(x, y, button)
  loveframes.mousereleased(x, y, button)
end