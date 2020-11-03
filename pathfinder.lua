local pathfinder = { }

local mock = { { x =  2, y = 2 }, { x = 2, y = 3 }, { x = 3, y = 3 }, { x = 4, y = 3 }, { x = 4, y = 4 }, { x = 4, y = 5 } }

pathfinder.strategies = {
  astar = "astar"
}

--- Find a path by the A-star algoritm
--- Thanks to the article: https://habr.com/ru/post/444828/
-- @param grid table: a map with [x][y] coordinates and 0 (empty) or 1 (solid) values
-- @param startPoint table: a start point { x, y }
-- @param endPoint table: a target point { x, y }
-- @return table: an array with path coordinates
local function astar(grid, startPoint, endPoint)
  -- TODO: Make A-star algoritm
  return mock
end

--- Find a path
-- @param grid table: a map with [x][y] coordinates and false (floor) or true (solid) values
-- @param startPoint table: a start point
-- @param endPoint table: a target point
-- @param strategy string: pathfinder.strategies value
-- @return table: an array with path coordinates
function pathfinder.find(grid, startPoint, endPoint, strategy)
  local strategy = strategy or pathfinder.strategies.astar

  if strategy == pathfinder.strategies.astar then
    return astar(grid, startPoint, endPoint)
  end

  assert('Path finding strategy \'' .. strategy .. '\' is not supported')
  return nil
end

return pathfinder