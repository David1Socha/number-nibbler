function new_enemy(pos,box_size, offx, num)

  num = num or math.random(1,4)
  local enemy = {
    pos = pos,
    act = pos,
    dest = pos,
    time_moving = 0,
    box_size = box_size,
    movetime = 1,
    scale = .69,
    tweening = false,
    img = love.graphics.newImage("assets/image/gator_"..num..".png")
  }

  return enemy

end