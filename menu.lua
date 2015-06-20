menu = {}
menu.width = love.graphics.getWidth()
menu.height = love.graphics.getHeight()
menu.start_button_x = 0.25 * menu.width
menu.start_button_y = .16 * menu.width
menu.start_button_w = 0.5 * menu.width
menu.start_button_h = .075 * menu.width
menu.start_button_fontsize = .04 * menu.width
menu.start_button_font = love.graphics.newFont("assets/font/kenvector_future_thin.ttf",menu.start_button_fontsize)
menu.bgcolor = {255,255,153}
menu.title = love.graphics.newImage("assets/image/title.png")
menu.title_scale = 0.00077 * menu.width
menu.category = Categories.ADDITION
menu.category_name = Categories.Names[menu.category]

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
    outline_width=.00391*menu.width,
  }

  menu.exit_button = menu.mgr:new_button {
    x=menu.start_button_x,
    y=menu.width * .27,
    width=menu.start_button_w,
    height=menu.start_button_h,
    font=menu.start_button_font,
    text="Exit",
    onclick=menu.exit_game,
    outline_width=.00391*menu.width,
  }

  menu.category_left_button = menu.mgr:new_button {
    x=0.0078 * menu.width,
    y=0.453 * menu.width,
    text="",
    image=love.graphics.newImage("assets/image/button_left.png"),
    outline_width=0,
    onclick=function() menu:change_category(-1) end,
  }

  menu.category_left_button = menu.mgr:new_button {
    x=.461*menu.width,
    y=0.453 * menu.width,
    text="",
    image=love.graphics.newImage("assets/image/button_right.png"),
    outline_width=0,
    onclick=function() menu:change_category(1) end,
  }

  menu.name_font = love.graphics.newFont("assets/font/kenvector_future_thin.ttf",.0469*menu.width)
end

function menu:change_category(delta)
  menu.category = menu.category + delta
  if menu.category < 1 then
    menu.category = Categories.NUM_CATEGORIES
  elseif menu.category > Categories.NUM_CATEGORIES then
    menu.category = 1
  end
  menu.category_name = Categories.Names[menu.category]
end

function menu.exit_game()
  love.event.quit()
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

  love.graphics.setColor {0,0,0}
  love.graphics.setFont(self.name_font)
  love.graphics.printf(self.category_name,.063*menu.width,.469*menu.width,.39*menu.width,"center")

  menu.mgr:draw()
end

return menu