local abs = math.abs
local tinsert = table.insert
local tremove = table.remove
local pathfinder = { }

pathfinder.strategies = {
  astar = "astar"
}

--- Reverse path from the last point to the first point
-- @param headPoint table: the last point
-- @return table: an array of path points from the first point to the last point
local function reverseTailChain(headPoint)
  local path = { }
  local point = headPoint

  while point.tailPoint do
    tinsert(path, point)
    point = point.tailPoint
  end

  return path
end

--- Choose the best next pending point
-- @param reachablePoints table: an array of current reachable points
-- @param targetPoint table: the goal point
-- @return table: the best next pending point
local function choosePendingPoint(reachablePoints, targetPoint)
  local bestPoint
  local minCost

  -- Choose the most short and cheap point
  for _, reachablePoint in ipairs(reachablePoints) do
    local distance = abs(targetPoint.x - reachablePoint.x) + abs(targetPoint.y - reachablePoint.y)
    local preCost = reachablePoint.cost + distance

    if not minCost or preCost < minCost then
      minCost = preCost
      bestPoint = reachablePoint
    end
  end

  return bestPoint
end

--- Find available nearby points
-- @param point table: the current point
-- @param grid table: a grid where we will look for the nearby points
-- @return table: an array of nearby points
local function findNearbyPoints(point, grid)
  local nearbyPoints = { }

  local leftPoint = { x = point.x - 1, y = point.y }
  if leftPoint.x > 0 and grid[leftPoint.x][leftPoint.y] == false then
    tinsert(nearbyPoints, leftPoint)
  end

  local rightPoint = { x = point.x + 1, y = point.y }
  if rightPoint.x <= #grid and grid[rightPoint.x][rightPoint.y] == false then
    tinsert(nearbyPoints, rightPoint)
  end

  local topPoint = { x = point.x , y = point.y - 1 }
  if topPoint.y > 0 and grid[topPoint.x][topPoint.y] == false then
    tinsert(nearbyPoints, topPoint)
  end

  local bottomPoint = { x = point.x, y = point.y + 1 }
  if bottomPoint.y <= #grid[bottomPoint.x] and grid[bottomPoint.x][bottomPoint.y] == false then
    tinsert(nearbyPoints, bottomPoint)
  end

  return nearbyPoints
end

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
        tremove(reachablePoints, index)
        break
      end
    end
    tinsert(exploredPoints, pendingPoint)

    -- Find nearby points and remove unwanted points from them
    local nearbyPoints = findNearbyPoints(pendingPoint, grid)
    for index = #nearbyPoints, 1, -1 do
      local nearbyPoint = nearbyPoints[index]

      -- Remove the point if it's explored
      for _, exploredPoint in ipairs(exploredPoints) do
        if nearbyPoint.x == exploredPoint.x and nearbyPoint.y == exploredPoint.y then
          tremove(nearbyPoints, index)
        end
      end

      -- Remove the point if it's reachable
      for _, reachablePoint in ipairs(reachablePoints) do
        if reachablePoint.x == nearbyPoint.x and reachablePoint.y == nearbyPoint.y then
          tremove(nearbyPoints, index)
        end
      end
    end

    for _, nearbyPoint in ipairs(nearbyPoints) do
      tinsert(reachablePoints, nearbyPoint)

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
