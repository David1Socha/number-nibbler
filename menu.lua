menu = {}

function menu:enter()
  menu.width = love.graphics.getWidth()
  menu.height = love.graphics.getHeight()
  local fontsize = .045 * menu.width
  menu.font = love.graphics.newFont("assets/font/kenvector_future_thin.ttf",fontsize)
  menu.bgcolor = {255,255,153}
  menu.title = love.graphics.newImage("assets/image/title.png")
  menu.title_scale = 0.00077 * menu.width
  menu.mgr = ButtonManager()
  menu.start_button = menu.mgr:new_button({x=340,y=250,width=600,height=70,font=love.graphics.newFont("assets/font/kenvector_future_thin.ttf",40),text="Play Game",onclick=menu.start_game})
end

function menu.start_game()
  Gamestate.switch(game)
end

function menu:mousepressed(x,y,btn)
  menu.mgr:mousepressed(x,y,btn)
end

function menu:draw() 
  love.graphics.setBackgroundColor(menu.bgcolor)
  love.graphics.setColor({0xff, 0xff, 0xff})
  love.graphics.draw(self.title,.5*menu.width,0.01*menu.height,0,menu.title_scale,menu.title_scale,menu.title:getWidth()*.5,0)
  menu.mgr:draw()
end

return menu