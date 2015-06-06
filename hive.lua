require("answer")

ADDENDS = 0
local ADDEND_MIN_ANS = 8
local ADDEND_MAX_ANS = 20

function map(a, fn)
  local new_array = {}
  for i,v in ipairs(a) do
    new_array[i] = fn(v)
  end
  return new_array
end

function prepare_hive_addends(hive)
  hive.value = math.random(ADDEND_MIN_ANS, ADDEND_MAX_ANS)
  hive.question = "Add to "..hive.value
  local ps = gen_addend_pairs(hive.value)
  local nps = gen_non_addend_pairs(hive.value)
  local pair_to_sum_text = function(p)
    local txt = ""
    if math.random() > .5 then
      txt = p[1].." + "..p[2]
    else
      txt = p[2].." + "..p[1]
    end
    return txt
  end
  hive.answers = map(ps, pair_to_sum_text)
  hive.traps = map(nps, pair_to_sum_text)
  function hive:get_answer()
    return self.answers[math.random(table.getn(self.answers))]
  end
  function hive:get_trap()
    return self.traps[math.random(table.getn(self.traps))]
  end
end

function new_hive(question_type)
  question_type = question_type or ADDENDS
  local hive = {}
  if question_type == ADDENDS then
    prepare_hive_addends(hive)
  else
    assert(false) -- no other type currently supported
  end

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
      text_off = vector(.022*game.width, 0.033*game.width),
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
      love.graphics.printf(self.text, rowcol_scaled.x + self.text_off.x, rowcol_scaled.y + self.text_off.y,game.width)
    end

    return fly
  end

  function hive:empty_fly()
    return { draw = function() end, real = false}
  end

  return hive
end

