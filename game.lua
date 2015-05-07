require("player")
require("lilypad")
require("hive")

math.randomseed(os.time())

local game = { }

function game:draw_txt(t, n)
  love.graphics.setColor({0,0,0})
  love.graphics.setFont(self.info_font)
  love.graphics.printf(t:text(), self.left_margin, love.graphics.getHeight() - (self.info_font:getHeight() + self.info_margin) * n, love.graphics.getWidth())
end

function game:enter_level()
  game.yes_flies = 0
  game.no_flies = 0
  game.hive = new_hive()
  self:build_fly_grid()

  game.enemy_delay = math.random(7,17)
  game.enemy_warning_delay = game.enemy_delay - 3
  game.enemy_warned = false
  game.enemy_spawned = false

  game.timer_warned = false
  game.timer_warn_threshold = 10

  game.time = 0
  game.time_limit = math.max(game.time_limit - 5,25)
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

  game.warning_color = {255,0,0}
  game.grid_units = 3
  game.offx = 500
  game.board_margin = 50
  game.info_margin = 5
  game.left_margin = 15
  game.grid_box_size = love.graphics.getHeight() / (game.grid_units + 1)
  game.info_font = love.graphics.newFont("assets/font/kenvector_future_thin.ttf",59)
  game.score_bg = {
    color = {255,255,153},
    border_width = 10,
    draw = function(self)
      love.graphics.setColor(self.color)
      love.graphics.rectangle("fill",0,0,game.offx - game.board_margin,love.graphics.getWidth())
      love.graphics.setColor({184,184,110})
      love.graphics.rectangle("fill",game.offx - game.board_margin,0,self.border_width,love.graphics.getWidth())
      --love.graphics.rectangle("fill",0,0,self.border_width,love.graphics.getWidth())
      --love.graphics.rectangle("fill",0,0,game.offx - game.board_margin,self.border_width)
      --love.graphics.rectangle("fill",0,love.graphics.getHeight() -self.border_width,game.offx - game.board_margin,self.border_width)
    end
  }

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
  game.warning = love.audio.newSource("assets/sound/warning.ogg", "static")
  game.level_complete = love.audio.newSource("assets/sound/level_complete.ogg", "static")
  game.level_complete_delay = .7
end

function game:warn_enemy()
  self.spawn_i = math.random(0,self.grid_units)
  self.spawn_j = math.random(0,self.grid_units)
  love.audio.play(self.warning)
  self.enemy_warned = true
end

function game:spawn_enemy()
  print("spawned @ i:"..self.spawn_i.." j:"..self.spawn_j)
  self.enemy_spawned = true
  --gen enemy
end

function game:warn_timer()
  self.timer_warned = true
  love.audio.play(self.warning)
end

function game:update(dt)
  self.player:update(dt)
  self.time = self.time + dt
  if not self.timer_warned and self.time_left.value() <= self.timer_warn_threshold then
    self:warn_timer()
  end
  if self.time_left.value() <= 0 then
    Gamestate.switch(menu)
  end
  if not self.enemy_warned and self.enemy_warning_delay <= self.time then
    self:warn_enemy()
  end
  if not self.enemy_spawned and self.enemy_delay <= self.time then
    self:spawn_enemy()
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
  self.score_bg:draw()
  self:draw_lilypads()
  self.player:draw()
  self:draw_flies()
  self:draw_txts(self.score,self.level,self.question,self.time_left)
  if self.enemy_warned and not self.enemy_spawned then
    self:draw_enemy_warning()
  end
end

function game:draw_enemy_warning()
  local x = self.spawn_j * self.grid_box_size
  local y = self.spawn_i * self.grid_box_size
  love.graphics.setColor(self.warning_color)
  love.graphics.rectangle("line", x + self.offx, y, self.grid_box_size, self.grid_box_size)
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
    local x = j * self.grid_box_size
    local y = i * self.grid_box_size
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
    local i = math.random(4) - 1
    local j = math.random(4) - 1
    if not self.fly_grid[i][j].correct then
      self.fly_grid[i][j] = self.hive:new_fly(i,j,self.grid_box_size, self.offx, 1)
      self.yes_flies = self.yes_flies + 1
      self.no_flies = self.no_flies - 1
    end
  end
  while(self.yes_flies > self.max_yes_flies) do
    local i = math.random(4) - 1
    local j = math.random(4) - 1
    if self.fly_grid[i][j].correct then
      self.fly_grid[i][j] = self.hive:new_fly(i,j,self.grid_box_size, self.offx, 0)
      self.yes_flies = self.yes_flies - 1
      self.no_flies = self.no_flies + 1
    end
  end
end

return game