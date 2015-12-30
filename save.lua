local json = require("dkjson.dkjson")

local save = {}
save.file_path = "number_nibbler_data.json"

function save:read_data()
  local data = {}
  if love.filesystem.exists(self.file_path) then
    local data_json = love.filesystem.read(self.file_path)
    data = json.decode(data_json)
  end
  return data
end

function save:write_data(data)
  local data_json = json.encode(data)
  love.filesystem.write(self.file_path,data_json)
end

return save