defeat = {}

function defeat:enter()
  self.font = love.graphics.newFont("assets/font/kenvector_future_thin.ttf",54)
  self.bgcolor = {214,89,48}
  self.time = 0
  self.delay = 1
end

function defeat:draw() 
  love.graphics.setBackgroundColor(defeat.bgcolor)
  love.graphics.setFont(defeat.font)
  love.graphics.setColor({0xff, 0xff, 0xff})
  love.graphics.printf("Game over (Touch to return to menu)", 0, love.graphics.getHeight() / 2 - 100, love.graphics.getWidth(), "center")
end

function defeat:mousepressed()
  if defeat.can_quit then
    Gamestate.switch(menu)
  end
end

function defeat:update(dt)
  self.time = self.time + dt
  self.can_quit = self.time >= self.delay
end
return defeat