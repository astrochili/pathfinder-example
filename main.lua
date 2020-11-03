local generator = require('generator')
local pathfinder = require('pathfinder')
local display = require('display')

local mapSize = { width = 16, height = 16 }
local mapDense = 0.3

local map = generator.randomMap(mapSize, mapDense)
local startPoint = generator.randomFreePoint(map.grid)
local endPoint = generator.randomFreePoint(map.grid)
local path = pathfinder.find(map.grid, startPoint, endPoint)

display.display(map, startPoint, endPoint, path)
