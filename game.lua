require("player")
require("node")
vector = require "hump.vector"
Gamestate = require "hump.gamestate"

game = {}

function game:enter()
  game.grid_units = 4
  game.grid = {}
  for i=0,game.grid_units do
    game.grid[i] = {}
    for j=0,game.grid_units do
      game.grid[i][j] = new_node()
    end
  end
  game.grid[0][0].correct = false
  game.score = 0
  game.bg = {0x33, 0xff, 0xff}
  game.grid_box_size = love.graphics.getHeight() / (game.grid_units + 1)
  game.player = new_player(game.grid_units, game.grid_box_size)
  game.plain_font = love.graphics.newFont(20)
  game.select = love.audio.newSource("assets/sound/select.ogg", "static")
  Monocle.watch("player pos x", function() return game.player.pos.x end)
  Monocle.watch("player pos y", function() return game.player.pos.y end)
  Monocle.watch("player d x", function() return game.player.dest.x end)
  Monocle.watch("player d y", function() return game.player.dest.y end)
end


function game:update(dt)
  game.player:update(dt)
end

function game:draw()
  love.graphics.setFont(game.plain_font)
  love.graphics.setBackgroundColor(game.bg)
  --love.graphics.printf(msg, 100, 100, 100)
  game.player:draw(game.grid_box_size)
  love.graphics.setColor(0, 0, 0)
  love.graphics.printf("Score: "..game.score, 0, love.graphics.getHeight() - game.plain_font:getHeight(), love.graphics.getWidth(), "center")
end

function game:mousepressed(x, y, grid)
  local grid_x = math.floor(x / game.grid_box_size)
  local grid_y = math.floor(y / game.grid_box_size)

  if grid_y == game.player.pos.y and grid_x == game.player.pos.x then
    choose_square()
  end
  game.player.dest.y = grid_y
  game.player.dest.x = grid_x
end

function choose_square()
  local curr_node = game.grid[game.player.pos.y][game.player.pos.x]
  if not curr_node.correct then
    Gamestate.switch(menu)
  else
    game.score = game.score + curr_node.score
    love.audio.play(game.select)
  end
end

return game