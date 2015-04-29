function gen_addend_pairs(x)
  local ps = {}
  for i=1,x/2 do
    local p = {i, x-i}
    table.insert(ps, p)
  end
  return ps
end

--t = gen_addend_pairs(10)
--table.foreachi(t , function(i) print(t[i][1],t[i][2]) end)