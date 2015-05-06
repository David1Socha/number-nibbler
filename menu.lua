Gamestate = require "hump.gamestate"
menu = {}

function menu:enter()
  menu.font = love.graphics.newFont("assets/font/kenvector_future_thin.ttf",54)
  menu.bgcolor = {20, 60, 20}
end

function menu:draw() 
  love.graphics.setBackgroundColor(menu.bgcolor)
  love.graphics.setFont(menu.font)
  love.graphics.setColor({0xff, 0xff, 0xff})
  love.graphics.printf("Press to start", 0, love.graphics.getHeight() / 2 - 100, love.graphics.getWidth(), "center")
end

function menu:mousepressed()
  Gamestate.switch(game)
end

return menu