require("player")
require("lilypad")
require("hive")

math.randomseed(os.time())

local game = { }

function game:enter_level()
  game.yes_flies = 0
  game.no_flies = 0
  game.hive = new_hive()
  self:build_fly_grid()

  game.since_selected = 0
  game.can_select = true

  game.player = new_player(game.grid_units, game.grid_box_size, self.offx)
end

function game:enter()
  game.grid_units = 3
  game.offx = 200
  game.grid_box_size = love.graphics.getHeight() / (game.grid_units + 1)

  game.min_yes_flies = 1
  game.max_yes_flies = 1

  game.select_cd = .3

  self:enter_level()

  game.score = {
    value = 0,
    font = love.graphics.newFont(40),
    draw = function(self)
      love.graphics.setColor({0,0,0})
      love.graphics.setFont(self.font)
      love.graphics.printf("Score: "..self.value, 0, love.graphics.getHeight() - self.font:getHeight(), love.graphics.getWidth())
    end
  }

  game.question = {
    value = function() return game.hive.question end,
    font = love.graphics.newFont(40),
    draw = function(self)
      love.graphics.setColor({0,0,0})
      love.graphics.setFont(self.font)
      love.graphics.printf(self.value(), 0, love.graphics.getHeight() - self.font:getHeight() * 2, love.graphics.getWidth())
    end
  }

  game.bg = {
    color = {0x33, 0xff, 0xff},
    draw = function (self)
      love.graphics.setBackgroundColor(self.color)
    end
  }

  game.lilypad = new_lilypad(game.grid_box_size, self.offx)

  game.debug = false
  game.select = love.audio.newSource("assets/sound/select.ogg", "static")
  game.level_complete = love.audio.newSource("assets/sound/level_complete.ogg", "static")
  game.level_complete_delay = .7
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
  self.bg:draw()
  self:draw_lilypads()
  self.player:draw()
  self:draw_flies()
  self.score:draw()
  self.question:draw()
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
      love.graphics.rectangle("line", x + self.offx, y, self.grid_box_size, self.grid_box_size)
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
  local grid_x = math.floor((x - self.offx) / game.grid_box_size)
  local grid_y = math.floor(y / game.grid_box_size)
  --TODO handle non grid clicks here, afterwards assume click is for grid movement
  if grid_x < 0 or grid_y < 0 or grid_x > self.grid_units or grid_y > self.grid_units then return end --can't let user go off grid
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

function game:finish_level()
  love.audio.play(self.level_complete)
  print("Level Complete")
end

function game:choose_square()
  local curr_fly = self.fly_grid[self.player.pos.y][self.player.pos.x]
  if curr_fly.real then
    if not curr_fly.correct then
      Gamestate.switch(menu)
    else
      self.score.value = self.score.value + curr_fly.score
      love.audio.play(self.select)
      self.player.start_anim_eat()
      self:replace_fly(curr_fly)
      if (self.yes_flies == 0) then
        Timer.add(self.level_complete_delay, function() self:finish_level() end)
      end
    end
  end
end

function game:replace_fly(fly)
  self.yes_flies = self.yes_flies - 1
  self.fly_grid[fly.col][fly.row] = self.hive.empty_fly()
end

function game:build_fly_grid() 
  self.fly_grid = {}
  for i=0,self.grid_units do
    self.fly_grid[i] = {}
    for j=0,self.grid_units do
      local newfly = self.hive:new_fly(i,j,self.grid_box_size, self.offx)
      self.fly_grid[i][j] = newfly
      if newfly.correct then
        self.yes_flies = self.yes_flies + 1
      else
        self.no_flies = self.no_flies + 1
      end
    end
  end
  while(self.yes_flies < self.min_yes_flies) do
    i = math.random(4) - 1
    j = math.random(4) - 1
    if not self.fly_grid[i][j].correct then
      self.fly_grid[i][j] = self.hive:new_fly(i,j,self.grid_box_size, self.offx, 1)
      self.yes_flies = self.yes_flies + 1
      self.no_flies = self.no_flies - 1
    end
  end
  while(self.yes_flies > self.max_yes_flies) do
    i = math.random(4) - 1
    j = math.random(4) - 1
    if self.fly_grid[i][j].correct then
      self.fly_grid[i][j] = self.hive:new_fly(i,j,self.grid_box_size, self.offx, 0)
      self.yes_flies = self.yes_flies - 1
      self.no_flies = self.no_flies + 1
    end
  end
end

return game