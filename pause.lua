pause = {}
pause.width = love.graphics.getWidth()
pause.height = love.graphics.getHeight()
pause.resume_button_x = 0.25 * pause.width
pause.resume_button_y = .19 * pause.width
pause.resume_button_w = 0.5 * pause.width
pause.resume_button_h = .075 * pause.width
pause.resume_button_fontsize = .04 * pause.width
pause.resume_button_font = love.graphics.newFont("assets/font/kenvector_future_thin.ttf",pause.resume_button_fontsize)
pause.menu_button_y = (pause.resume_button_y + pause.resume_button_h) + pause.width * .035
pause.exit_button_y = (pause.menu_button_y + pause.resume_button_h) + pause.width * .035
pause.bgcolor = {255,204,0}

function pause:enter()
  pause.mgr = ButtonManager()
  pause.resume_button = pause.mgr:new_button {
    x=pause.resume_button_x,
    y=pause.resume_button_y,
    width=pause.resume_button_w,
    height=pause.resume_button_h,
    font=pause.resume_button_font,
    text="Resume Game",
    onclick=pause.resume_game,
    outline_width=.00391*pause.width,
  }

  pause.menu_button = pause.mgr:new_button {
    x=pause.resume_button_x,
    y=pause.menu_button_y,
    width=pause.resume_button_w,
    height=pause.resume_button_h,
    font=pause.resume_button_font,
    text="Return to menu",
    onclick=pause.return_menu,
    outline_width=.00391*pause.width,
  }

  pause.exit_button = pause.mgr:new_button {
    x=pause.resume_button_x,
    y=pause.exit_button_y,
    width=pause.resume_button_w,
    height=pause.resume_button_h,
    font=pause.resume_button_font,
    text="Quit Game",
    onclick=pause.exit_game,
    outline_width=.00391*pause.width,
  }

  pause.name_font = love.graphics.newFont("assets/font/kenvector_future_thin.ttf",.16*pause.width)
end

function pause.exit_game()
  love.event.quit()
end

function pause.return_menu()
  game.paused = false
  Gamestate.switch(menu)
end

function pause.resume_game()
  Gamestate.switch(game)
end

function pause:mousepressed(x,y,btn)
  pause.mgr:mousepressed(x,y,btn)
end

function pause:draw() 
  love.graphics.setBackgroundColor(pause.bgcolor)
  love.graphics.setColor({0xff, 0xff, 0xff})

  love.graphics.setColor {0,0,0}
  love.graphics.setFont(self.name_font)

  love.graphics.printf("Paused",0,-.02*pause.width,1.02*pause.width,"center") --for some reason was not centering properly with 1*screen width as size

  pause.mgr:draw()
end

return pause