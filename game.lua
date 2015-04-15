require("player")
require("lilypad")
require "fly"

local game = { }

function game:enter()
  game.grid_units = 3
  game.grid_box_size = love.graphics.getHeight() / (game.grid_units + 1)
  self:build_fly_grid()
  game.fly_grid[0][0].correct = false
  game.fly_grid[0][0].text = "FALSE"
  game.score = 0
  game.lilypad = new_lilypad(game.grid_box_size)
  game.select_cd = .3
  game.since_selected = 0
  game.can_select = true
  game.debug = false
  game.bg = {0x33, 0xff, 0xff}
  game.player = new_player(game.grid_units, game.grid_box_size)
  game.plain_font = love.graphics.newFont(20)
  game.select = love.audio.newSource("assets/sound/select.ogg", "static")
  Monocle.watch("player pos", function() return game.player.pos end)
  Monocle.watch("player dest", function() return game.player.dest end)
  Monocle.watch("player act", function() return game.player.act end)
end


function game:update(dt)
  self.player:update(dt)
  if not can_select then
    self.since_selected = self.since_selected + dt
    if self.since_selected > self.select_cd then
      self.since_selected = 0
      self.can_select = true
    end
  end
end

function game:draw()
  love.graphics.setBackgroundColor(game.bg)
  self:draw_grid()
  game.player:draw(game.grid_box_size)
  love.graphics.setColor({0,0,0})
  love.graphics.setFont(game.plain_font)
  love.graphics.printf("Score: "..game.score, 0, 0, love.graphics.getWidth(), "center")
end

function game:draw_grid()
  for i=0,self.grid_units do
    for j=0,self.grid_units do
      x = j * self.grid_box_size
      y = i * self.grid_box_size
      if self.debug then
        love.graphics.setColor({255,255,255})
        love.graphics.rectangle("line", x, y, self.grid_box_size, self.grid_box_size)
      end
      self.fly_grid[i][j]:draw(i,j,self.grid_box_size)
      --self.grid[i][j]:draw(i,j,self.grid_box_size)
    end
  end
end

function game:mousepressed(x, y, grid)
  local grid_x = math.floor(x / game.grid_box_size)
  local grid_y = math.floor(y / game.grid_box_size)
  local grid_vec = vector(grid_x, grid_y)
  if neareq_vec(grid_vec, game.player.act) and self.can_select then
    self.can_select = false
    self.since_selected = 0
    self:choose_square()
  end
  game.player.dest = grid_vec
end

function game:keypressed(key)
  if key == "`" then
    self.debug = not self.debug
  end
end

function game:choose_square()
  local curr_fly = self.fly_grid[self.player.pos.y][self.player.pos.x]
  if not curr_fly.correct then
    Gamestate.switch(menu)
  else
    self.score = self.score + curr_fly.score
    love.audio.play(self.select)
    self.player.start_anim_eat()
  end
end

function game:build_fly_grid() 
  self.fly_grid = {}
  for i=0,self.grid_units do
    self.fly_grid[i] = {}
    for j=0,self.grid_units do
      self.fly_grid[i][j] = new_fly(self.grid_box_size)
    end
  end
end

return game