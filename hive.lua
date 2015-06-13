require("answer")

local ADDITION = 0
local SUBTRACTION = 1
local ADDITION_MIN_ANS = 8
local ADDITION_MAX_ANS = 20
local SUBTRACTION_MIN_ANS = 0
local SUBTRACTION_MAX_ANS = 12

local map = function (a, fn)
  local new_array = {}
  for i,v in ipairs(a) do
    new_array[i] = fn(v)
  end
  return new_array
end

local prepare_hive_helper = function(hive, min, max, question_prefix, gen_answers, gen_traps, to_text)
  hive.value = math.random(min, max)
  hive.question = question_prefix .. hive.value
  local as = gen_answers(hive.value)
  local ts = gen_traps(hive.value)
  hive.answers = map(as, to_text)
  hive.traps = map(ts, to_text)
  function hive:get_answer()
    return self.answers[math.random(table.getn(self.answers))]
  end
  function hive:get_trap()
    return self.traps[math.random(table.getn(self.traps))]
  end
end

local build_addition_hive = function ()
  local hive = {}
  local to_text = function(p)
    local txt = ""
    if math.random() > .5 then
      txt = p[1].."+"..p[2]
    else
      txt = p[2].."+"..p[1]
    end
    return txt
  end
  prepare_hive_helper(hive, ADDITION_MIN_ANS, ADDITION_MAX_ANS, "Make ", gen_addition_answers, gen_addition_traps, to_text)
  return hive
end

local build_subtraction_hive = function ()
  -- body
end

local hive_builders = {}
hive_builders[ADDITION] = build_addition_hive
hive_builders[SUBTRACTION] = build_subtraction_hive

function new_hive(question_type)
  question_type = question_type or ADDITION
  local hive = hive_builders[question_type]()

  function hive:new_fly(col, row, box_size, offx, prob_correct)
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

    fly_offx = (box_size - fly.img:getWidth() * fly.scale) / 2 + offx
    fly_offy = 0
    fly.off = vector(fly_offx,fly_offy)
    if c then
      fly.text = self:get_answer()
    else
      fly.text = self:get_trap()
    end

    function fly:draw(box_size) 
      love.graphics.setColor(255, 255, 255)
      love.graphics.setFont(self.font)
      rowcol_scaled = vector(self.row, self.col) * box_size + self.off
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

