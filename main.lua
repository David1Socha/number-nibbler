require("menu")
require("game")

function love.load()
  menu.load()
  phase = "menu"
end

function love.update(dt)
  if phase == "game" then
    game.update(dt)
  end
end

function love.mousepressed(x, y, button)
  if (phase == "menu") then
    menu.mousepressed()
  else
    game.mousepressed(x, y, button)
  end
end

function love.draw()
  if phase == "menu" then
    menu.draw()
  else
    game.draw()
  end
end