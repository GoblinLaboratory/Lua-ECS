require 'library.lib.Guid'
require 'library.lib.lib'
local Registry = require 'library.Core.Registry'
local class = lib.class
GameObject = class('GameObject')

function GameObject:initialize()
    self.ID = 0
    self.Guid = Guid.New()
    self.components_ = {}
    print("创建了游戏实体...")
end
-- 组件列表
--GameObject.components_ = {}
function GameObject:checkComponent(name) return self.components_[name] ~= nil end
-- 添加组件
function GameObject:addComponent(name)
    print("添加了组件")
    local component = Registry.newObject(name)
    self.components_[name] = component
    --self.components_[ID] = component
    component:bind_(self)
    return component
end
-- 移除组件
function GameObject:removeComponent(name)
    local component = self.components_[name]
    if component then component:unbind_() end
    self.components_[name] = nil
end
-- 获取组件
function GameObject:getComponent(name) return self.components_[name] end
return GameObject
