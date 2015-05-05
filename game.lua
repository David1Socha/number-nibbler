require("player")
require("lilypad")
require("hive")

math.randomseed(os.time())

local game = { }

function game:draw_txt(t, n)
  love.graphics.setColor({0,0,0})
  love.graphics.setFont(self.info_font)
  love.graphics.printf(t:text(), 0, love.graphics.getHeight() - self.info_font:getHeight() * n, love.graphics.getWidth())
end

function game:enter_level()
  game.yes_flies = 0
  game.no_flies = 0
  game.hive = new_hive()
  self:build_fly_grid()

  game.time = 0
  game.time_limit = math.max(game.time_limit - 5,20)
  game.time_left = {
    value = function() return game.time_limit - game.time end,
    text = function(self) return "Time left: "..math.ceil(self.value()) end,
  }

  game.since_selected = 0
  game.can_move = true
  game.can_select = true

  game.player = new_player(game.grid_units, game.grid_box_size, self.offx)
end

function game:enter()
  game.grid_units = 3
  game.offx = 400
  game.grid_box_size = love.graphics.getHeight() / (game.grid_units + 1)
  game.info_font = love.graphics.newFont(60)

  game.min_yes_flies = 4
  game.max_yes_flies = 12

  game.select_cd = .3

  game.time_limit = 65

  self:enter_level()

  game.score = {
    value = 0,
    text = function(self) return "Score: "..self.value end
  }

  game.question = {
    text = function(self) return game.hive.question end,
  }

  game.level = {
    value = 1,
    text = function(self) return "Level: "..self.value end
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
  self.time = self.time + dt
  if self.time_left.value() <= 0 then
    Gamestate.switch(menu)
  end
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
  self:draw_txts(self.score,self.level,self.question,self.time_left)
end

function game:draw_txts(...)
  for k,v in ipairs({...}) do
    self:draw_txt(v,k)
  end
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
  if self.can_move then
    if grid_x < 0 or grid_y < 0 or grid_x > self.grid_units or grid_y > self.grid_units then return end --can't let user go off grid
    local grid_vec = vector(grid_x, grid_y)
    if neareq_vec(grid_vec, game.player.act) and self.can_select then
      self.can_select = false
      self.since_selected = 0
      self:choose_square()
    end
    game.player.dest = grid_vec
  end
end

function game:keypressed(key)
  if key == "`" then
    self.debug = not self.debug
  end
end

function game:finish_level()
  love.audio.play(self.level_complete)
  print("Level Complete")
  self.level.value = self.level.value + 1
  self.score.value = self.score.value + math.ceil(self.time_left.value())
  self:enter_level()
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
        self.can_select = false
        self.can_move = false
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