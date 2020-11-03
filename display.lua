local display = { }

local tiles = {
  floor = '  ',
  wall = '[]',
  start = '@j',
  exit = '><',
  path = '.*'
}

--- Print to console the map with objects
-- @param map table: a map to display
-- @param start table: a start point { x, y }
-- @param exit table: a target point { x, y }
-- @param path table: an array with path coordinates { { x, y }, { x, y }, ... }
function display.display(map, start, exit, path)
  local render = { }
  local output = ''

  -- Fill the render with map tiles
  for _, row in ipairs(map.grid) do
    local line = { }
    for _, isWall in ipairs(row) do
      local tile = isWall and tiles.wall or tiles.floor
      table.insert(line, tile)
    end
    table.insert(render, line)
  end

  -- Place path steps on the render
  for _, step in ipairs(path) do
    render[step.x][step.y] = tiles.path
  end

  -- Place start and end points on the render
  render[start.x][start.y] = tiles.start
  render[exit.x][exit.y] = tiles.exit

  -- Convert the render to console output
  for _, row in ipairs(render) do
    for _, tile in ipairs(row) do
      output = output .. tile
    end
    output = output .. '\n'
  end

  print(output)
end

return display