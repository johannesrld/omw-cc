local async = require "openmw.async"
local types = require "openmw.types"
local I = require "openmw.interfaces"

local disableConsumption = false
local enableConsumption = async:registerTimerCallback("enableConsumption", function () disableConsumption = false end)

---@param actor GameObject
local function ConsumptionCheck(_, actor)
	if actor.type ~= types.Player then return true end
	if disableConsumption == true then
		actor:sendEvent("__PLAN9_ControledConsumption_consumptionDenied")
		return false
	end
	disableConsumption = true
	async:newSimulationTimer(5, enableConsumption)
	return true
end

I.ItemUsage.addHandlerForType(types.Potion, ConsumptionCheck)
