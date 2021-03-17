local functions = require 'library.Core.functions'
require 'library.lib.lib'
local class = lib.class
local Component = class("Component")
require 'library.lib.Guid'
-- name 组件名
-- depends 依赖
function Component:initialize(n, depends)
    self.name = n
    print("组件名" .. self.name)
    self.ID = 0
    self.depends = functions.checktable(depends)
    self.Guid = Guid.New()
    -- self.Data = {}
end
function Component:getName() return self.name end

function Component:getDepends() return self.depends end

function Component:getTarget() return self.target_ end
-- 导出方法
-- function Component:exportMethods_(methods)
--     self.exportedMethods_ = methods
--     local target = self.target_
--     local com = self
--     for _, key in ipairs(methods) do
--         if not target[key] then
--             local m = com[key]
--             target[key] = function(__, ...) return m(com, ...) end
--         end
--     end
--     return self
-- end
-- 绑定
function Component:bind_(target)
    self.target_ = target
    -- print(#self.depends)
    for _, name in ipairs(self.depends) do
        if not target:checkComponent(name) then target:addComponent(name) end
    end
    self:onBind_(target)
end
-- 解绑
function Component:unbind_()
    if self.exportedMethods_ then
        local target = self.target_
        for _, key in ipairs(self.exportedMethods_) do target[key] = nil end
    end
    self:onUnbind_()
end

function Component:onBind_() end

function Component:onUnbind_() end
function Component:GetData(data)
    -- statements
    if functions.isset(self.Data, data) then
        -- statements
        return self.Data[data].Value
    end
    return 0
end
function Component:SetData(data, value)
    -- statements
    self.Data[data].Value = value
end
function Component:Information()
    -- statements
    print(self.name)
end
return Component
