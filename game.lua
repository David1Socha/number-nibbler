require("player")
require("lilypad")
require("hive")
require("enemy")

local game = { }

function game:draw_txt(t, n)
  local color = t.color or {0,0,0}
  love.graphics.setColor(color)
  local font = t.font or self.info_font
  love.graphics.setFont(font)
  local x = self.left_margin
  local y = love.graphics.getHeight() - (self.info_font:getHeight() + self.info_margin) * n
  love.graphics.printf(t:text(),x,y,love.graphics.getWidth())
  if t.warned then
    love.graphics.setColor(self.warning_color)
    love.graphics.rectangle("line",x-line_width,y,game.offx - game.board_margin - line_width,self.info_font:getHeight())
  end
end

function game:play_alone(s)
  love.audio.stop()
  love.audio.play(s)
end

function game:enter_level()
  game.yes_flies = 0
  game.no_flies = 0
  game.hive = new_hive()
  self:build_fly_grid()

  game.enemy_delay = 5
  game.enemy_warning_delay = game.enemy_delay - 3
  game.enemy_warned = false
  game.enemy_spawned = false
  game.danger = false

  game.timer_warn_threshold = 10

  game.time = 0
  game.time_limit = math.max(game.time_limit - 5,25)
  game.max_time_score = 25
  function game:time_score() return math.max(0,math.ceil(game.max_time_score - game.time)) end
  game.time_left = {
    value = function() return game.time_limit - game.time end,
    text = function(self) return "Time: "..(game.active and math.ceil(self.value()) or "") end,
  }

  game.warn_txt = {
    text = function(self) return (game.active and game.danger) and "DANGER" or "" end,
    color = game.warning_color,
    font = love.graphics.newFont("assets/font/kenvector_future_thin.ttf",.05*game.width)
  }

  game.restart_txt = {
    text = function(self) return (game.can_restart and game.player.defeated) and "Tap: retry" or "" end,
    color = {51,51,153}
  }

  game.since_selected = 0
  game.active = true
  game.can_select = true

  game.player = new_player(game.grid_box_size, self.offx)
  game.enemies = {}
end

function game:enter()

  game.width = love.graphics.getWidth()
  game.height = love.graphics.getHeight()
  game.warning_color = {255,0,0}
  game.grid_units = 3
  game.offx = .28 * game.width
  game.board_margin = 50
  game.info_margin = 8
  game.left_margin = 0.01171875 * game.width
  game.grid_box_size = love.graphics.getHeight() / (game.grid_units + 1)
  game.info_font = love.graphics.newFont("assets/font/kenvector_future_thin.ttf",.038*game.width)
  game.score_bg = {
    color = {255,255,153},
    border_width = 10,
    draw = function(self)
      love.graphics.setColor(self.color)
      love.graphics.rectangle("fill",0,0,game.offx - game.board_margin,game.width)
      love.graphics.setColor({224,224,102})
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
  game.ouch = love.audio.newSource("assets/sound/ouch.ogg", "static")
  game.level_complete_delay = .7
  game.restart_delay = 1.5
  game.can_restart = true
end

function game:warn_enemy()
  self.spawn_i = math.random(0,self.grid_units)
  self.spawn_j = math.random(0,self.grid_units)
  self:play_warning()
  self.enemy_warned = true
  self.danger = true
end

function game:spawn_enemy()
  self.enemy_spawned = true
  self.danger = false
  local enemy = new_enemy(vector(self.spawn_j,self.spawn_i),self.grid_box_size,self.offx,self.grid_units)
  table.insert(self.enemies,enemy)
  --gen enemy
end

function game:warn_timer()
  self.time_left.warned = true
  self.danger = true
  self:play_warning()
end

function game:play_warning()
  if not self.level_complete:isPlaying() then
    self:play_alone(self.warning)
  end
end

function game:update(dt)
  self.time = self.time + dt
  self.player:update(dt)
  self:update_enemies(dt)
  if not self.can_restart and self.time >= self.restart_time then
    self.can_restart = true
  end

  if self.active then
    for i,enemy in pairs(self.enemies) do
      if neareq_vec(enemy.act,self.player.act) then
        self:defeat()
      end
    end
    if not self.time_left.warned and self.time_left.value() <= self.timer_warn_threshold then
      self:warn_timer()
    end
    if self.time_left.value() <= 0 then
      self:defeat()
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
end

function game:update_enemies(dt)
  for i,enemy in pairs(self.enemies) do
    enemy:update(dt)
  end
end

function game:draw()
  self.bg:draw()
  self.score_bg:draw()
  self:draw_lilypads()
  self.player:draw()
  self:draw_flies()
  self:draw_txts(self.score,self.level,self.time_left,self.question,self.warn_txt,self.restart_txt)
  if self.enemy_warned and not self.enemy_spawned then
    self:draw_enemy_warning()
  end
  self:draw_enemies()
end

function game:draw_enemies()
  if self.active then
    for i,enemy in pairs(self.enemies) do
      enemy:draw()
    end
  end
end

function game:draw_enemy_warning()
  local x = self.spawn_j * self.grid_box_size
  local y = self.spawn_i * self.grid_box_size
  love.graphics.setColor(self.warning_color)
  love.graphics.rectangle("line", x + self.offx, y, self.grid_box_size, self.grid_box_size)
end

function game:draw_txts(...)
  --love.graphics.scale(1800)
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
  if self.can_restart and self.player.defeated then
    Gamestate.switch(menu)
  end
  local grid_x = math.floor((x - self.offx) / game.grid_box_size)
  local grid_y = math.floor(y / game.grid_box_size)
  --TODO handle non grid clicks here, afterwards assume click is for grid movement
  if self.active then
    if grid_x < 0 or grid_y < 0 or grid_x > self.grid_units or grid_y > self.grid_units then return end --can't let user go off grid
    local grid_vec = vector(grid_x, grid_y)
    if grid_vec == self.player.pos and self.can_select and not self.player.tweening then
      self.can_select = false
      self.since_selected = 0
      self:choose_square()
    end
    self.player:move(grid_vec)
  end
end

function game:keypressed(key)
  if key == "`" then
    self.debug = not self.debug
  end
end

function game:finish_level()
  self:play_alone(self.level_complete)
  self.level.value = self.level.value + 1
  self.score.value = self.score.value + self.time_score() + 10
  self:enter_level()
end

function game:choose_square()
  local curr_fly = self.fly_grid[self.player.pos.y][self.player.pos.x]
  if curr_fly.real then
    if not curr_fly.correct then
      self:defeat()
    else
      self.score.value = self.score.value + curr_fly.score
      love.audio.play(self.select)
      self.player.start_anim_eat()
      self:replace_fly(curr_fly)
      if (self.yes_flies == 0) then
        self.active = false
        Timer.add(self.level_complete_delay, function() self:finish_level() end)
      end
    end
  end
end

function game:defeat()
  if not self.player.defeated then
    self.active = false
    love.audio.play(self.ouch)
    self.player.defeated = true
    self.can_restart = false
    self.restart_time = self.time + self.restart_delay
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