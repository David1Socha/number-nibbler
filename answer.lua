local MIN_DELTA = 1
local MAX_DELTA = 1

function gen_addend_pairs(x)
  local ps = {}
  for i=1,x/2 do
    local p = {i, x-i}
    table.insert(ps, p)
  end
  return ps
end

function gen_non_addend_pairs(x)
  local nps = {}
  local ps = gen_addend_pairs(x)
  table.foreach(ps, function(i)
    p = ps[i]
    for i=p[1]-MIN_DELTA,p[1]+MAX_DELTA do --range of near values to try in order to trick player
      for j=p[2]-MIN_DELTA,p[2]+MAX_DELTA do
        if (i>0 and j>0 and i+j~=x) then --don't want to give away the falseness by going out of original range
          local np = {i,j}
          table.insert(nps, np)
        end
      end
    end
  end
  )
  return nps
end
