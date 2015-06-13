local MIN_DELTA = 1
local MAX_DELTA = 1

function gen_addition_answers(x)
  local as = {}
  for i=1,x/2 do
    local a = {i, x-i}
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
          print(t[1],t[2])
          table.insert(ts, t)
        end
      end
    end
  end)
end