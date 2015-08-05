require("answer")

local Ranges = {}
Ranges[Categories.ADDITION] = {}
Ranges[Categories.ADDITION][Difficulties.EASY] = {
  Min = 4,
  Max = 12,
}
Ranges[Categories.ADDITION][Difficulties.HARD] = {
  Min = 10,
  Max = 25,
}

Ranges[Categories.SUBTRACTION] = {}
Ranges[Categories.SUBTRACTION][Difficulties.EASY] = {
  Min = 2,
  Max = 8,
}
Ranges[Categories.SUBTRACTION][Difficulties.HARD] = {
  Min = 4,
  Max = 15,
}

Ranges[Categories.MULTIPLICATION] = {}
Ranges[Categories.MULTIPLICATION][Difficulties.EASY] = {
  Min = 4,
  Max = 15,
}
Ranges[Categories.MULTIPLICATION][Difficulties.HARD] = {
  Min = 8,
  Max = 30,
}

local MIN_ANSWERS = 2
local MAKE_PREFIX = "Make "

local flat_map = function (a, fn)
  local mapped = {}
  local int i = 0
  for _,v in ipairs(a) do
    local map_results = fn(v)
    for _,mv in ipairs(map_results) do
      mapped[i] = mv
      i = i + 1
    end
  end
  return mapped
end

local subtraction_to_texts = function (p)
  local txts = {}
  txts[1] = p[1].."-"..p[2]
  return txts
end

local addition_to_texts = function(p)
  local txts = {}
  txts[1] = p[1].."+"..p[2]
  txts[2] = p[2].."+"..p[1]
  return txts
end

local multiplication_to_texts = function(p)
  local txts = {}
  txts[1] = p[1].."*"..p[2]
  txts[2] = p[2].."*"..p[1]
  return txts
end

local prepare_hive_helper = function(hive, min, max, question_prefix, gen_answers, gen_traps, to_texts)
  local enough_answers = false
  local as
  while (not enough_answers) do
    hive.value = math.random(min, max)
    hive.question = question_prefix .. hive.value
    as = gen_answers(hive.value)
    if (#as >= MIN_ANSWERS) then
      enough_answers = true
    end
  end
  local ts = gen_traps(hive.value)
  hive.answers = flat_map(as, to_texts)
  hive.traps = flat_map(ts, to_texts)
  function hive:get_answer()
    return self.answers[math.random(table.getn(self.answers))]
  end
  function hive:get_trap()
    return self.traps[math.random(table.getn(self.traps))]
  end
end

local build_addition_hive = function(difficulty)
  local hive = {}
  print(Categories.ADDITION)
  print(difficulty)
  prepare_hive_helper(hive, Ranges[Categories.ADDITION][difficulty].Min, Ranges[Categories.ADDITION][difficulty].Max, MAKE_PREFIX, gen_addition_answers, gen_addition_traps, addition_to_texts)
  return hive
end

local build_subtraction_hive = function(difficulty)
  local hive = {}
  prepare_hive_helper(hive, Ranges[Categories.SUBTRACTION][difficulty].Min, Ranges[Categories.SUBTRACTION][difficulty].Max, MAKE_PREFIX, gen_subtraction_answers, gen_subtraction_traps, subtraction_to_texts)
  return hive
end

local build_multiplication_hive = function(difficulty)
  local hive = {}
  prepare_hive_helper(hive, Ranges[Categories.MULTIPLICATION][difficulty].Min, Ranges[Categories.MULTIPLICATION][difficulty].Max, MAKE_PREFIX, gen_multiplication_answers, gen_multiplication_traps, multiplication_to_texts)
  return hive
end

local hive_builders = {}
hive_builders[Categories.ADDITION] = build_addition_hive
hive_builders[Categories.SUBTRACTION] = build_subtraction_hive
hive_builders[Categories.MULTIPLICATION] = build_multiplication_hive

function new_hive(question_type, difficulty)
  question_type = question_type or Categories.ADDITION
  local hive = hive_builders[question_type](difficulty)

  function hive:new_fly(col, row, prob_correct)
    prob_correct = prob_correct or .5
    local c = math.random() < prob_correct
    local fly = {
      score = 5,
      scale = 0.00048 * game.width,
      row = row,
      real = true,
      col = col,
      correct = c,
      font = love.graphics.newFont("assets/font/Roboto-Black.ttf",0.015 * game.width),
      text_off = vector(.021*game.width, 0.033*game.width),
      img = love.graphics.newImage "assets/image/fly.png",
    }

    fly_offx = (game.grid_box_size - fly.img:getWidth() * fly.scale) / 2 + game.offx
    fly_offy = 0
    fly.off = vector(fly_offx,fly_offy)
    if c then
      fly.text = self:get_answer()
    else
      fly.text = self:get_trap()
    end

    function fly:draw() 
      love.graphics.setColor(255, 255, 255)
      love.graphics.setFont(self.font)
      rowcol_scaled = vector(self.row, self.col) * game.grid_box_size + self.off
      love.graphics.draw(self.img, rowcol_scaled.x, rowcol_scaled.y, 0, self.scale, self.scale)
      love.graphics.setColor(0, 0, 0)
      love.graphics.printf(self.text, rowcol_scaled.x + self.text_off.x, rowcol_scaled.y + self.text_off.y,0.05*game.width,"center")
    end

    return fly
  end

  function hive:empty_fly()
    return { draw = function() end, real = false}
  end

  return hive
end

