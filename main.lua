local generator = require('generator')
local pathfinder = require('pathfinder')
local display = require('display')

local mapSize = { width = 32, height = 16 }
local mapDense = 0.3

local map = generator.randomMap(mapSize, mapDense)
local start = generator.randomFreePoint(map.grid)
local target = generator.randomFreePoint(map.grid, { start })
local path = pathfinder.find(map.grid, start, target, pathfinder.strategies.astar)

display.displayMap(map, start, target, path)
display.displayLog(path)