local ui = require 'openmw.ui'

return {
  eventHandler = {
    __PLAN9_ControlledConsumption_consumptionDenied = function()
      ui.showMessage 'You have already consumed a potion within the last 5 seconds.'
    end,
  },
}
