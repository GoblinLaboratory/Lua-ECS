--local functions = require 'library.functions'
require 'library.lib.lib'
local Component = require 'library.Core.Components'
local class = lib.class
local testComponents = class("testComponents",Component)
--testComponents = {}
function testComponents:initialize()
    --print("组件被创建")
    Component.initialize(self,"testComponents","testComponents")
    --self:Information()
    self.name = "testComponents"
    self:Information()
    --self.depends_ = functions.checktable(depends)
end
--local t = testComponents:new()
--print(t.name)
return testComponents