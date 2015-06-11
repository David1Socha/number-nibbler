menu = {}

function menu:enter()
  menu.width = love.graphics.getWidth()
  menu.height = love.graphics.getHeight()
  local fontsize = .045 * menu.width
  menu.font = love.graphics.newFont("assets/font/kenvector_future_thin.ttf",fontsize)
  menu.bgcolor = {255,255,153}
  menu.title = love.graphics.newImage("assets/image/title.png")
  menu.title_scale = 0.00077 * menu.width
  menu.startbutton = loveframes.Create("button")
  menu.startbutton:SetWidth(600)
  menu.startbutton:SetHeight(100)
  menu.startbutton:Center()
  menu.startbutton:SetText("Start Game")
  menu.startbutton:SetFont(menu.font)
  menu.startbutton.OnClick = function(object,x,y)
    menu:exit(game)
  end
end

function menu:exit(phase)
  menu.startbutton:Remove()
  Gamestate.switch(phase)
end

function menu:draw() 
  love.graphics.setBackgroundColor(menu.bgcolor)
  love.graphics.setColor({0xff, 0xff, 0xff})
  love.graphics.draw(self.title,.5*menu.width,0.01*menu.height,0,menu.title_scale,menu.title_scale,menu.title:getWidth()*.5,0)
  loveframes.draw()
end

return menu