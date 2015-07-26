defeat = {}
defeat.width = love.graphics.getWidth()
defeat.height = love.graphics.getHeight()
defeat.menu_button_x = 0.25 * defeat.width
defeat.menu_button_y = .28 * defeat.width
defeat.menu_button_w = 0.5 * defeat.width
defeat.menu_button_h = .1 * defeat.width
defeat.menu_button_fontsize = .04 * defeat.width
defeat.menu_button_font = love.graphics.newFont("assets/font/kenvector_future_thin.ttf",defeat.menu_button_fontsize)
defeat.replay_button_y = (defeat.menu_button_y + defeat.menu_button_h) + defeat.width * .035
defeat.bgcolor = {0xDB,0x4D,0x4D}

function defeat:enter()
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

  defeat.name_font = love.graphics.newFont("assets/font/kenvector_future_thin.ttf",.16*defeat.width)
end

function defeat.exit_game()
  love.event.quit()
end

function defeat.return_menu()
  Gamestate.switch(menu)
end

function defeat.play_again()
  Gamestate.switch(game)
end

function defeat:mousepressed(x,y,btn)
  defeat.mgr:mousepressed(x,y,btn)
end

function defeat:draw() 
  love.graphics.setBackgroundColor(defeat.bgcolor)
  love.graphics.setColor({0xff, 0xff, 0xff})

  love.graphics.setColor {0,0,0}
  love.graphics.setFont(self.name_font)

  love.graphics.printf("Game Over",0,-.02*defeat.width,1.02*defeat.width,"center") --for some reason was not centering properly with 1*screen width as size

  defeat.mgr:draw()
end

return defeat