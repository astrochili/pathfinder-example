local pathfinder = { }

pathfinder.strategies = {
  astar = "astar"
}

--- Find a path by the A-star algoritm
--- Thanks to the article: https://www.gabrielgambetta.com/generic-search.html
--- Also thanks to this: https://www.redblobgames.com/pathfinding/a-star/introduction.html
-- @param grid table: a map with [x][y] coordinates and 0 (empty) or 1 (solid) values
-- @param start table: a start point { x, y }
-- @param target table: a target point { x, y }
-- @return table: an array with path coordinates
local function astar(grid, start, target)
  local startPoint = { x = start.x, y = start.y, cost = 0 }
  local targetPoint = { x = target.x, y = target.y }
  local reachablePoints = { startPoint }
  local exploredPoints = { }

  -- Path builder
  local function reverseTailChain(headPoint)
    local path = { }
    local point = headPoint

    while point.tailPoint do
      table.insert(path, point)
      point = point.tailPoint
    end

    return path
  end

  -- Pending point chooser
  local function choosePendingPoint(reachablePoints, targetPoint)
    local bestPoint
    local minCost

    -- Choose the most short and cheap point
    for _, reachablePoint in ipairs(reachablePoints) do
      local distance = math.abs(targetPoint.x - reachablePoint.x) + math.abs(targetPoint.y - reachablePoint.y)
      local preCost = reachablePoint.cost + distance

      if not minCost or minCost > preCost then
        minCost = preCost
        bestPoint = reachablePoint
      end
    end

    return bestPoint
  end

  -- Nearby points finder
  local function findNearbyPoints(point, grid)
    local nearbyPoints = { }

    local leftPoint = { x = point.x - 1, y = point.y }
    if leftPoint.x > 0 and grid[leftPoint.x][leftPoint.y] == false then
      table.insert(nearbyPoints, leftPoint)
    end

    local rightPoint = { x = point.x + 1, y = point.y }
    if rightPoint.x <= #grid and grid[rightPoint.x][rightPoint.y] == false then
      table.insert(nearbyPoints, rightPoint)
    end

    local topPoint = { x = point.x , y = point.y - 1 }
    if topPoint.y > 0 and grid[topPoint.x][topPoint.y] == false then
      table.insert(nearbyPoints, topPoint)
    end

    local bottomPoint = { x = point.x, y = point.y + 1}
    if bottomPoint.y <= #grid[bottomPoint.x] and grid[bottomPoint.x][bottomPoint.y] == false then
      table.insert(nearbyPoints, bottomPoint)
    end

    return nearbyPoints
  end

  while #reachablePoints > 0 do
    local pendingPoint = choosePendingPoint(reachablePoints, targetPoint)

    -- Check the end of search
    if pendingPoint.x == targetPoint.x and pendingPoint.y == targetPoint.y then
      local path = reverseTailChain(pendingPoint)
      return path
    end

    -- Remove the point from reachable points and add to explored points
    for index = 1, #reachablePoints do
      if reachablePoints[index] == pendingPoint then
        table.remove(reachablePoints, index)
        break
      end
    end
    table.insert(exploredPoints, pendingPoint)

    -- Find nearby points and remove unwanted points from them
    local nearbyPoints = findNearbyPoints(pendingPoint, grid)
    for index = #nearbyPoints, 1, -1 do
      local nearbyPoint = nearbyPoints[index]

      -- Remove the point if it's explored
      for _, exploredPoint in ipairs(exploredPoints) do
        if nearbyPoint.x == exploredPoint.x and nearbyPoint.y == exploredPoint.y then
          table.remove(nearbyPoints, index)
        end
      end

      -- Remove the point if it's reachable
      for _, reachablePoint in ipairs(reachablePoints) do
        if reachablePoint.x == nearbyPoint.x and reachablePoint.y == nearbyPoint.y then
          table.remove(nearbyPoints, index)
        end
      end
    end

    for _, nearbyPoint in ipairs(nearbyPoints) do
      table.insert(reachablePoints, nearbyPoint)

      -- Update cost of a nearby point's path if the current path cost is more adequate
      if not nearbyPoint.cost or pendingPoint.cost + 1 < nearbyPoint.cost then
        nearbyPoint.tailPoint = pendingPoint
        nearbyPoint.cost = pendingPoint.cost + 1
      end
    end
  end

  return nil
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