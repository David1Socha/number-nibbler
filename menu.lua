menu = {}

function menu:enter()
  menu.width = love.graphics.getWidth()
  print(love.graphics.getWidth())
  menu.height = love.graphics.getHeight()
  local fontsize = .045 * menu.width
  menu.font = love.graphics.newFont("assets/font/kenvector_future_thin.ttf",fontsize)
  menu.bgcolor = {255,255,153}
  menu.title = love.graphics.newImage("assets/image/title.png")
  menu.title_scale = 0.0008 * menu.width
  local button = loveframes.Create("button")
  button:SetPos(10, 10)
end

function menu:draw() 
  love.graphics.setBackgroundColor(menu.bgcolor)
  love.graphics.setFont(menu.font)
  love.graphics.setColor({0, 0, 0})
  love.graphics.printf("Press to start", 0, 0.36*menu.height, love.graphics.getWidth(), "center")
  love.graphics.setColor({0xff, 0xff, 0xff})
  love.graphics.draw(self.title,.5*menu.width,0.01*menu.height,0,menu.title_scale,menu.title_scale,menu.title:getWidth()*.5,0)
end

function menu:mousepressed()
  Gamestate.switch(game)
end

return menu