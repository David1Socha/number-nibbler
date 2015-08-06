local MIN_DELTA = 1
local MAX_DELTA = 1

function gen_addition_answers(x)
  local as = {}
  for addend=1,x/2 do
    local a = {addend, x-addend}
    table.insert(as, a)
  end
  return as
end

function gen_addition_traps(x)
  local ts = {}
  local as = gen_addition_answers(x)
  table.foreach(as, function(i)
    a = as[i]
    for i=a[1]-MIN_DELTA,a[1]+MAX_DELTA do --range of near values to try in order to trick player
      for j=a[2]-MIN_DELTA,a[2]+MAX_DELTA do
        if (i>0 and j>0 and i+j~=x) then --don't want to give away the falseness by going out of original range
          local t = {i,j}
          table.insert(ts, t)
        end
      end
    end
  end
  )
  return ts
end

function gen_subtraction_answers(x)
  local as = {}
  for minuend=x,x+10 do
    local subtrahend = minuend - x
    local a = {minuend, subtrahend}
    table.insert(as, a)
  end
  return as
end

function gen_subtraction_traps(x)
  local ts = {}
  local as = gen_subtraction_answers(x)
  table.foreach(as, function(i)
    a = as[i]
    for i=a[1]-MIN_DELTA,a[1]+MAX_DELTA do --range of near values to try in order to trick player
      for j=a[2]-MIN_DELTA,a[2]+MAX_DELTA do
        if (i>0 and j>0 and i-j~=x) then --don't want to give away the falseness by going out of original range
          local t = {i,j}
          table.insert(ts, t)
        end
      end
    end
  end)
  return ts
end

function gen_multiplication_answers(x)
  local as = {}
  local prev_large_factor = x
  for small_factor=1,math.sqrt(x) do
    for large_factor=prev_large_factor,small_factor,-1 do
      if small_factor * large_factor == x then
        local a = {small_factor, large_factor}
        table.insert(as, a)
        break
      end
    end
  end
  return as
end

function gen_multiplication_traps(x)
  local ts = {}
  local as = gen_multiplication_answers(x)
  for k,a in ipairs(as) do
    for i=a[1]-MIN_DELTA,a[1]+MAX_DELTA do
      for j=a[2]-MIN_DELTA,a[2]+MAX_DELTA do
        if (i>0 and j>0 and i*j~=x) then
          local t = {i,j}
          table.insert(ts,t)
        end
      end
    end
  end
  return ts
end

function gen_multiples_answers(x)
  local as = {}
  for i=2,8 do
    local a = x * i
    table.insert(as, a)
  end
  return as
end

function gen_multiples_traps(x)
  local ts = {}
  table.insert(ts, "TRAP")
  return ts
end