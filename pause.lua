pause = {}
pause.width = love.graphics.getWidth()
pause.height = love.graphics.getHeight()
pause.resume_button_x = 0.1 * pause.width
pause.resume_button_y = .22 * pause.width
pause.resume_button_w = 0.8 * pause.width
pause.resume_button_h = .1 * pause.width
pause.resume_button_fontsize = .04 * pause.width
pause.resume_button_font = love.graphics.newFont(main_font_path,pause.resume_button_fontsize)
pause.menu_button_y = (pause.resume_button_y + pause.resume_button_h) + pause.width * .04
pause.menu_button_h = pause.resume_button_h
pause.menu_button_w = .375 * pause.width
pause.exit_button_x = pause.resume_button_x + pause.menu_button_w + 0.05 * pause.width
pause.text = love.graphics.newImage("assets/image/paused.png")
pause.text_scale = 0.00077 * pause.width
pause.bgcolor = {255,255,153}

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
    width=pause.menu_button_w,
    height=pause.menu_button_h,
    font=pause.resume_button_font,
    text="Return to menu",
    onclick=pause.return_menu,
    outline_width=.00391*pause.width,
  }

  pause.exit_button = pause.mgr:new_button {
    x=pause.exit_button_x,
    y=pause.menu_button_y,
    width=pause.menu_button_w,
    height=pause.menu_button_h,
    font=pause.resume_button_font,
    text="Quit Game",
    onclick=pause.exit_game,
    outline_width=.00391*pause.width,
  }

  pause.name_font = love.graphics.newFont(main_font_path,.16*pause.width)
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

  --love.graphics.printf("Paused",0,-.02*pause.width,1.02*pause.width,"center") --for some reason was not centering properly with 1*screen width as size

  love.graphics.setColor({0xff, 0xff, 0xff})
  love.graphics.draw(self.text,.5*pause.width,0.01*pause.height,0,pause.text_scale,pause.text_scale,pause.text:getWidth()*.5,0)

  pause.mgr:draw()
end

return pause