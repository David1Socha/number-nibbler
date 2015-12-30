local json = require("dkjson.dkjson")

local save = {}
save.file_path = "number_nibbler_data.json"
save.data_read = false

function save:read_data()
  local data = {}
  if love.filesystem.exists(self.file_path) then
    local data_json = love.filesystem.read(self.file_path)
    data = json.decode(data_json)
  end
  self.data = data
end

function save:write_data()
  local data_json = json.encode(self.data)
  love.filesystem.write(self.file_path,data_json)
end

function save:get_saved_high(category,difficulty)
  if not self.data_read then
    self:read_data()
    self.data_read = true
  end
  cstr = tostring(category)
  dstr = tostring(difficulty)
  local high
  local has_high = false
  if self.data then
    local cdata = self.data[cstr]
    if cdata then
      high = cdata[dstr]
      if high then
        has_high = true
      end
    end
  end
  return has_high, high
end

b, h = save:get_saved_high(0,1)
print(b)
print(h)

save:get_saved_high(0,1)

return save