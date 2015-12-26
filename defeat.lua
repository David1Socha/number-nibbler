defeat = {}
defeat.width = love.graphics.getWidth()
defeat.height = love.graphics.getHeight()

defeat.replay_button_x = 0.1 * defeat.width
defeat.menu_button_y = .28 * defeat.width
defeat.replay_button_w = .8 * defeat.width
defeat.replay_button_h = .1 * defeat.width
defeat.replay_button_fontsize = .04 * defeat.width
defeat.replay_button_font = love.graphics.newFont(main_font_path,defeat.replay_button_fontsize)
defeat.info_font = love.graphics.newFont(main_font_path,.07*defeat.width)

defeat.category_txt = {
  x = .1 * defeat.width,
  y = .13 * defeat.width,
  font = defeat.info_font,
  draw = function(self)
    love.graphics.setColor{0,0,0}
    love.graphics.setFont(self.font)
    floor_print(Categories.Names[menu.category].." - "..Difficulties.Names[menu.difficulty],self.x,self.y,.8*defeat.width,"center")
  end
}

defeat.score_txt = {
  x = .1 * defeat.width,
  y = .2 * defeat.width,
  font = defeat.info_font,
  draw = function(self) 
    love.graphics.setColor({0,0,0})
    love.graphics.setFont(self.font)
    floor_print("Score: "..game.score.value,self.x,self.y,defeat.width)
  end
}

defeat.high_txt = {
  x = 0,
  y = .2 * defeat.width,
  font = defeat.info_font,
  draw = function(self) 
    love.graphics.setColor({0,0,0})
    love.graphics.setFont(self.font)
    floor_print("Best: "..game.high,self.x,self.y,.9*defeat.width,"right")
  end
}

defeat.replay_button_y = (defeat.menu_button_y + defeat.replay_button_h) + defeat.width * .035
defeat.menu_button_w = .375 * defeat.width

defeat.exit_button_x = defeat.replay_button_x + defeat.menu_button_w + 0.05 * defeat.width

defeat.bgcolor = {255,255,153}
defeat.text = love.graphics.newImage("assets/image/defeat.png")
defeat.text_scale = 0.0008 * defeat.width
defeat.outline_width = .00391*defeat.width

function defeat:enter()
  defeat.time = 0
  defeat.cd = .35
  defeat.mgr = ButtonManager()
  defeat.replay_button = defeat.mgr:new_button {
    x=defeat.replay_button_x,
    y=defeat.replay_button_y,
    width=defeat.menu_button_w,
    height=defeat.replay_button_h,
    font=defeat.replay_button_font,
    text="Return to menu",
    onclick=defeat.return_menu,
    outline_width=defeat.outline_width,
  }

  defeat.replay_button = defeat.mgr:new_button {
    x=defeat.replay_button_x,
    y=defeat.menu_button_y,
    width=defeat.replay_button_w,
    height=defeat.replay_button_h,
    font=defeat.replay_button_font,
    text="Play Again",
    onclick=defeat.play_again,
    outline_width=defeat.outline_width,
  }

  defeat.exit_button = defeat.mgr:new_button {
    x=defeat.exit_button_x,
    y=defeat.replay_button_y,
    width=defeat.menu_button_w,
    height=defeat.replay_button_h,
    font=defeat.replay_button_font,
    text="Quit Game",
    onclick=defeat.exit_game,
    outline_width=defeat.outline_width,
  }

  defeat.name_font = love.graphics.newFont(main_font_path,.16*defeat.width)
end

function defeat.exit_game()
  if (defeat.time > defeat.cd) then
    love.event.quit()
  end
end

function defeat.return_menu()
  if (defeat.time > defeat.cd) then
    Gamestate.switch(menu)
  end
end


function defeat.play_again()
  if (defeat.time > defeat.cd) then
    Gamestate.switch(game)
  end
end

function defeat:mousepressed(x,y,btn)
  defeat.mgr:mousepressed(x,y,btn)
end

function defeat:update(dt)
  self.time = self.time + dt
end

function defeat:draw() 
  love.graphics.setBackgroundColor(defeat.bgcolor)
  love.graphics.setColor({0xff, 0xff, 0xff})

  love.graphics.setColor {0,0,0}
  love.graphics.setFont(self.name_font)

  love.graphics.setColor({0xff, 0xff, 0xff})
  love.graphics.draw(self.text,.5*defeat.width,0.01*defeat.height,0,defeat.text_scale,defeat.text_scale,defeat.text:getWidth()*.5,0)

  self.score_txt:draw()
  self.high_txt:draw()
  self.category_txt:draw()

  defeat.mgr:draw()
end

return defeat