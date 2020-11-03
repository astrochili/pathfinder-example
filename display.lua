local display = { }

local graphic = {
  borders = {
    left = '|',
    right = '|',
    top = '__',
    bottom = '\'\''
  },
  tiles = {
    floor = '  ',
    wall = '[]'
  },
  objects = {
    start = '@j',
    target = '><',
    path = '.*'
  }
}

--- Print to console the map with objects
-- @param map table: a map to display
-- @param start table: a start point { x, y }
-- @param target table: a target point { x, y }
-- @param path table: an array with path coordinates { { x, y }, { x, y }, ... }
function display.displayMap(map, start, target, path)
  local render = { }
  local output = ''

  -- Fill the render with map tiles
  for x, row in ipairs(map.grid) do
    for y, isWall in ipairs(row) do
      local column = render[y] or { }
      local tile = isWall and graphic.tiles.wall or graphic.tiles.floor
      table.insert(column, tile)
      render[y] = column
    end
  end

  -- Place path steps on the render
  if path then
    for _, step in ipairs(path) do
      render[step.y][step.x] = graphic.objects.path
    end
  end

  -- Place start and end points on the render
  if start then
    render[start.y][start.x] = graphic.objects.start
  end
  if target then
    render[target.y][target.x] = graphic.objects.target
  end

  -- Fill left and right borders
  for _, row in ipairs(render) do
    table.insert(row, 1, graphic.borders.left)
    table.insert(row, graphic.borders.right)
  end

  -- Fill the top border
  local topBorder = ''
  for _ = 1, #render + 1 do
    topBorder = topBorder .. graphic.borders.top
  end
  table.insert(render, 1, { topBorder })

  -- Fill the bottom border
  local bottomBorder = ''
  for x = 1, #render do
    bottomBorder = bottomBorder .. graphic.borders.bottom
  end
  table.insert(render, { bottomBorder })

  -- Convert the render to console output
  for x, row in ipairs(render) do
    for _, tile in ipairs(row) do
      output = output .. tile
    end
    output = output .. (x ~= #render and '\n' or '')
  end

  print(output)
end

--- Print to console the path step by step
-- @param path table: an array of path points
function display.displayLog(path)
  local output = 'Steps:'

  if path then
    for _, step in ipairs(path) do
      output = output .. ' > ' .. step.x .. ':' .. step.y
    end
  else
    output = output .. ' path is not found, sorry!'
  end

  print(output)
end

return display