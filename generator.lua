local generator = { }

--- Generate a random seed
-- @return number: a random seed
local function randomSeed()
  local seed = os.clock() * 100000000000
  return seed
end

--- Generate a random number
-- @param from number: a lower bound of range
-- @param to number: a higher bound of range
-- @param seed number: an optional seed
-- @return number: a random number
local function randomInt(from, to, seed)
  local seed = seed or randomSeed()
  math.randomseed(seed)
  local result = math.random(from, to)
  return result
end

--- Generate a random map
-- @param size table: a size table like { width = 32, height = 32 }
-- @param dense number: a percent of walls from 0.0 to 1.0
-- @return table: a map
function generator.randomMap(size, dense)
  local grid = { }

  for x = 1, size.width do
    local row = { }

    for y = 1, size.height do
      local isWall = randomInt(0, 100) < 100 * dense
      row[y] = isWall
    end

    grid[x] = row
  end

  local map = {
    ['grid'] = grid,
    ['size'] = size
  }

  return map
end

--- Find a random free point on the map grid
-- @param grid table: a map grid
-- @return table: a random free point like { x = 3, y = 5 }
function generator.randomFreePoint(grid)
  local freePoints = { }

  -- Find free points
  for x, row in ipairs(grid) do
    for y, isWall in ipairs(row) do
      if not isWall then
        local point = {
          ['x'] = x,
          ['y'] = y
        }
        table.insert(freePoints, point)
      end
    end
  end

  -- Select a random free point
  local randomIndex = randomInt(1, #freePoints)
  local result = freePoints[randomIndex]

  return result
end

return generator