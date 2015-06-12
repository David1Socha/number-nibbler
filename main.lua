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
  mgr = ButtonManager()
  button = mgr:new_button({x=300,y=250,width=600,height=70,font=love.graphics.newFont(40),text="Play Game",onclick=function() print("shrekpls") end})
end

function love.update(dt)
  d=dt
  Timer.update(dt)
end

function love.draw()
  mgr:draw()
end

function love.mousepressed(x,y,code)
  mgr:mousepressed(x,y,code)
end