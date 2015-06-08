menu = {}

function menu:enter()
  local fontsize = .07 * love.graphics.getWidth()
  menu.font = love.graphics.newFont("assets/font/kenvector_future_thin.ttf",fontsize)
  menu.bgcolor = {255,255,153}
  menu.title = love.graphics.newImage("assets/image/title.png")
  menu.title_scale = 0.0012 * love.graphics.getWidth()
end

function menu:draw() 
  love.graphics.setBackgroundColor(menu.bgcolor)
  love.graphics.setFont(menu.font)
  love.graphics.setColor({0, 0, 0})
  love.graphics.printf("Press to start", 0, 0.36*love.graphics.getHeight(), love.graphics.getWidth(), "center")
  love.graphics.setColor({0xff, 0xff, 0xff})
  love.graphics.draw(self.title,.5*love.graphics.getWidth(),0.01*love.graphics.getHeight(),0,menu.title_scale,menu.title_scale,menu.title:getWidth()*.5,0)
end

function menu:mousepressed()
  Gamestate.switch(game)
end

return menu