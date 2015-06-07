menu = {}

function menu:enter()
  menu.font = love.graphics.newFont("assets/font/kenvector_future_thin.ttf",54)
  menu.bgcolor = {255,255,153}
  menu.title = love.graphics.newImage("assets/image/title.png")
end

function menu:draw() 
  love.graphics.setBackgroundColor(menu.bgcolor)
  love.graphics.setFont(menu.font)
  love.graphics.setColor({0xff, 0xff, 0xff})
  love.graphics.printf("Press to start", 0, love.graphics.getHeight() / 2 - 100, love.graphics.getWidth(), "center")
  love.graphics.draw(self.title,150,10,0,1,1)
end

function menu:mousepressed()
  Gamestate.switch(game)
end

return menu