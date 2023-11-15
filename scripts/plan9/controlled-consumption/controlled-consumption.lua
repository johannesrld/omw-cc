local types = require 'openmw.types'
local ItemUsage = require 'openmw.interfaces'.ItemUsage
local async = require 'openmw.async'

---@type boolean
local disableConsumption = false

local enableConsumption =
  async:registerTimerCallback('enableConsumption',
    function()
      disableConsumption = false
    end)

ItemUsage.addHandlerForType(types.Potion,
  function(_, actor)
    if actor.type ~= types.Player then return true end
    if disableConsumption == true then
      actor:sendEvent '__PLAN9_ControlledConsumption_consumptionDenied'
      return false
    end
    async:newSimulationTimer(5, enableConsumption)
    disableConsumption = true
    return true
  end)
