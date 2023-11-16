local ui = require "openmw.ui"
local NPC = require "openmw.types".NPC
local self = require "openmw.self"
local core = require "openmw.core"

local playerEndurance = NPC.baseType.stats.attributes.endurance(self)
local playerAlchemy = NPC.stats.skills.alchemy(self)
local currentMaximum = 1
local function calculateMaximumPotions()
	local maximumActivePotions = math.max(math.floor((playerEndurance.base + playerAlchemy.base) / 25), 1)
	if maximumActivePotions ~= currentMaximum then
		core.sendGlobalEvent("__PLAN9_ControlledConsumption_updatePlayerData_newMax",
			{ plr_id = self.object.id, new_max = maximumActivePotions })
	end
end

local a = NPC.baseType.activeEffects(self)
return {
	engineHandlers = {
		onUpdate = calculateMaximumPotions
	},
	eventHandlers = {
		__PLAN9_ControlledConsumption_consumptionDenied = function()
			ui.showMessage("You have already consumed a potion within the last 5 seconds.")
		end
	}
}
