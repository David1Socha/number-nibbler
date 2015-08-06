defeat = {}
defeat.width = love.graphics.getWidth()
defeat.height = love.graphics.getHeight()

defeat.menu_button_x = 0.1 * defeat.width
defeat.menu_button_y = .28 * defeat.width
defeat.menu_button_w = 0.8 * defeat.width
defeat.menu_button_h = .1 * defeat.width
defeat.menu_button_fontsize = .04 * defeat.width
defeat.menu_button_font = love.graphics.newFont("assets/font/Roboto-Black.ttf",defeat.menu_button_fontsize)

defeat.score_txt = {
  x = .1 * defeat.width,
  y = .175 * defeat.width,
  font = love.graphics.newFont("assets/font/Roboto-Black.ttf",.07*defeat.width),
  draw = function(self) 
    love.graphics.setColor({0,0,0})
    love.graphics.setFont(self.font)
    love.graphics.printf("Score: "..game.score.value, self.x,self.y,defeat.width)
  end
}

defeat.high_txt = {
  x = 0,
  y = .175 * defeat.width,
  font = love.graphics.newFont("assets/font/Roboto-Black.ttf",.07*defeat.width),
  draw = function(self) 
    love.graphics.setColor({0,0,0})
    love.graphics.setFont(self.font)
    love.graphics.printf("Best: "..game.high,self.x,self.y,.9*defeat.width,"right")
  end
}

defeat.replay_button_y = (defeat.menu_button_y + defeat.menu_button_h) + defeat.width * .035
defeat.bgcolor = {255,255,153}
defeat.text = love.graphics.newImage("assets/image/defeat.png")
defeat.text_scale = 0.0008 * defeat.width

function defeat:enter()
  defeat.time = 0
  defeat.cd = .35
  defeat.mgr = ButtonManager()
  defeat.menu_button = defeat.mgr:new_button {
    x=defeat.menu_button_x,
    y=defeat.menu_button_y,
    width=defeat.menu_button_w,
    height=defeat.menu_button_h,
    font=defeat.menu_button_font,
    text="Return to menu",
    onclick=defeat.return_menu,
    outline_width=.00391*defeat.width,
  }

  defeat.replay_button = defeat.mgr:new_button {
    x=defeat.menu_button_x,
    y=defeat.replay_button_y,
    width=defeat.menu_button_w,
    height=defeat.menu_button_h,
    font=defeat.menu_button_font,
    text="Play Again",
    onclick=defeat.play_again,
    outline_width=.00391*defeat.width,
  }

  defeat.name_font = love.graphics.newFont("assets/font/Roboto-Black.ttf",.16*defeat.width)
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

  defeat.mgr:draw()
end

return defeat