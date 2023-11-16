local API_REVISION = require 'openmw.core'.API_REVISION
if API_REVISION < 45 then
  print 'ERR: API_REVISION < 45'
  return
end
local types = require 'openmw.types'
local ItemUsage = require 'openmw.interfaces'.ItemUsage
local async = require 'openmw.async'

---@type boolean
local async = require "openmw.async"
local types = require "openmw.types"
local I = require "openmw.interfaces"
local disableConsumption = false
local enableConsumption = async:registerTimerCallback("enableConsumption", function() disableConsumption = false end)

---@type table<string, {max: number, current: number}>
local players = {}


---@param actor GameObject
local function ConsumptionCheck(_, actor)
	if actor.type ~= types.Player then return true end
	if disableConsumption == true then
		actor:sendEvent("__PLAN9_ControlledConsumption_consumptionDenied")
		return false
	end
	disableConsumption = true
	async:newSimulationTimer(5, enableConsumption)
	return true
end

I.ItemUsage.addHandlerForType(types.Potion, ConsumptionCheck)

return {
	eventHandlers = {
		---@param data {plr_id: string, new_max: number}
		__PLAN9_ControlledConsumption_updatePlayerData_newMax = function(data)
			if players[data.plr_id] == nil then
				players[data.plr_id] = { max = 1, current = 0 }
			end
			players[data.plr_id].max = math.max(data.new_max, 1)
		end,
		---@param data {plr_id: string}
		__PLAN9_ControlledConsumption_updatePlayerData_potionExpired = function(data)
			if players[data.plr_id] == nil then
				players[data.plr_id] = { max = 1, current = 0 }
			end
			players[data.plr_id].current = math.max((players[data.plr_id].current - 1), 0)
		end
	}
}
