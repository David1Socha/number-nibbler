require("player")
require("lilypad")
require "fly"

math.randomseed(os.time())

local game = { }

function game:enter()
  game.grid_units = 3
  game.grid_box_size = love.graphics.getHeight() / (game.grid_units + 1)
  game.yes_flies = 0
  game.no_flies = 0
  game.min_yes_flies = 4
  game.max_yes_flies = 12
  self:build_fly_grid()
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
  Monocle.watch("yes flies", function() return game.yes_flies end)
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
  self:draw_lilypads()
  game.player:draw(game.grid_box_size)
  love.graphics.setColor({0,0,0})
  love.graphics.setFont(game.plain_font)
  self:draw_flies()
  love.graphics.printf("Score: "..game.score, 0, 0, love.graphics.getWidth(), "center")
end

function enumerate_2d(imax,jmax,action)
  for i=0,imax do
    for j=0,jmax do
      action(i,j)
    end
  end
end

function game:draw_flies()
  local action = function(i,j)
    x = j * self.grid_box_size
    y = i * self.grid_box_size
    if self.debug then
      love.graphics.setColor({255,255,255})
      love.graphics.rectangle("line", x, y, self.grid_box_size, self.grid_box_size)
    end
    self.fly_grid[i][j]:draw(self.grid_box_size)
  end
  enumerate_2d(self.grid_units, self.grid_units, action)
end

function game:draw_lilypads()
  local action = function(i,j) self.lilypad:draw(i,j) end
  enumerate_2d(self.grid_units, self.grid_units, action)
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
  if curr_fly.real then
    if not curr_fly.correct then
      Gamestate.switch(menu)
    else
      self.score = self.score + curr_fly.score
      love.audio.play(self.select)
      self.player.start_anim_eat()
      self:replace_fly(curr_fly)
    end
  end
end

function game:replace_fly(fly)
  self.yes_flies = self.yes_flies - 1
  self.fly_grid[fly.col][fly.row] = empty_fly()
end

function game:build_fly_grid() 
  self.fly_grid = {}
  for i=0,self.grid_units do
    self.fly_grid[i] = {}
    for j=0,self.grid_units do
      local newfly = new_fly(i,j,self.grid_box_size)
      self.fly_grid[i][j] = newfly
      if newfly.correct then
        self.yes_flies = self.yes_flies + 1
      else
        self.no_flies = self.no_flies + 1
      end
    end
  end
  while(self.yes_flies < self.min_yes_flies) do
    i = math.random(4)
    j = math.random(4)
    if not self.fly_grid[i][j].correct then
      --self.fly_grid[math.random(4)][math.random[4]] = new_yes_fly()
      --self.yes_flies = self.yes_flies + 1
      --self.no_flies = self.no_flies - 1
    end
  end
  while(self.yes_flies > self.max_yes_flies) do
    --self.fly_grid[math.random(4)][math.random[4]] = new_no_fly()
    --self.yes_flies = self.yes_flies + 1
    --self.no_flies = self.no_flies - 1
  end
end

return game