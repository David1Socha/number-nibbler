menu = {}
menu.width = love.graphics.getWidth()
menu.height = love.graphics.getHeight()
menu.start_button_x = 0.25 * menu.width
menu.start_button_y = .18 * menu.width
menu.start_button_w = 0.5 * menu.width
menu.start_button_h = .075 * menu.width
menu.start_button_fontsize = .04 * menu.width
menu.start_button_font = love.graphics.newFont("assets/font/kenvector_future_thin.ttf",menu.start_button_fontsize)
menu.bgcolor = {255,255,153}
menu.title = love.graphics.newImage("assets/image/title.png")
menu.title_scale = 0.00077 * menu.width

function menu:enter()
  menu.mgr = ButtonManager()
  menu.start_button = menu.mgr:new_button {
    x=menu.start_button_x,
    y=menu.start_button_y,
    width=menu.start_button_w,
    height=menu.start_button_h,
    font=menu.start_button_font,
    text="Play Game",
    onclick=menu.start_game,
  }

  menu.category_left_button = menu.mgr:new_button {
    x=600,
    y=400,
    text="",
    image=love.graphics.newImage("assets/image/button_left.png"),
    outline_width=0,
  }
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