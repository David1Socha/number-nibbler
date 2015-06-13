require("answer")

local ADDITION_MIN_ANS = 8
local ADDITION_MAX_ANS = 20
local SUBTRACTION_MIN_ANS = 2
local SUBTRACTION_MAX_ANS = 12
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

local prepare_hive_helper = function(hive, min, max, question_prefix, gen_answers, gen_traps, to_texts)
  hive.value = math.random(min, max)
  hive.question = question_prefix .. hive.value
  local as = gen_answers(hive.value)
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

local build_addition_hive = function()
  local hive = {}
  prepare_hive_helper(hive, ADDITION_MIN_ANS, ADDITION_MAX_ANS, MAKE_PREFIX, gen_addition_answers, gen_addition_traps, addition_to_texts)
  return hive
end

local build_subtraction_hive = function()
  local hive = {}
  prepare_hive_helper(hive, SUBTRACTION_MIN_ANS, SUBTRACTION_MAX_ANS, MAKE_PREFIX, gen_subtraction_answers, gen_subtraction_traps, subtraction_to_texts)
  return hive
end

local hive_builders = {}
hive_builders[Categories.ADDITION] = build_addition_hive
hive_builders[Categories.SUBTRACTION] = build_subtraction_hive

function new_hive(question_type)
  question_type = question_type or Categories.ADDITION
  local hive = hive_builders[question_type]()

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
      font = love.graphics.newFont("assets/font/kenvector_future_thin.ttf",0.015 * game.width),
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

