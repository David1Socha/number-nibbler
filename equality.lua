function neareq(d1, d2)
  return math.abs(d1 - d2) < 0.00015625 * game.width
end

function neareq_vec(v1, v2)
  return neareq(v1.x, v2.x) and neareq(v1.y, v2.y)
end