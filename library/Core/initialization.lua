local functions = require 'library.Core.functions'
-- require "library.Archetype.testArchetype"
--Registry   = functions.import("..Registry")
local Registry = require 'library.Core.Registry'
--require 'library.Core.Registe'
require 'library.Component.testComponents'

local initialization = {}
function initialization.Int()
    -- statements
    -- local R = Registry:Instance()
    Registry.add(functions.import('library.Component.testComponents'))
end
return initialization

