<h1 align="center"><a href="https://github.com/halo-dev" target="_blank">Lua-ECS</a></h1>

> Lua-ECS 是一款现lua实现的ECS系统，主要为魔兽地图编辑器使用。

------------------------------

## 简介

ECS，即 Entity-Component-System（实体-组件-系统） 的缩写，其模式遵循组合优于继承原则，游戏内的每一个基本单元都是一个实体，每个实体又由一个或多个组件构成，每个组件仅仅包含代表其特性的数据（即在组件中没有任何方法），例如：移动相关的组件MoveComponent包含速度、位置、朝向等属性，一旦一个实体拥有了MoveComponent组件便可以认为它拥有了移动的能力，系统便是来处理拥有一个或多个相同组件的实体集合的工具，其只拥有行为（即在系统中没有任何数据），在这个例子中，处理移动的系统仅仅关心拥有移动能力的实体，它会遍历所有拥有MoveComponent组件的实体，并根据相关的数据（速度、位置、朝向等），更新实体的位置。

参考了Cocoas游戏引擎的“实体组件系统”架构代码
## 依赖 
middleclass
## 快速开始
所有组件继承Components。
```lua
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
    self.Data = {
        ["力量"] = {Tag = {}, Value = 0},
        ["敏捷"] = {Tag = {}, Value = 0},
        ["智力"] = {Tag = {}, Value = 0},
        ["生命值"] = {Tag = {}, Value = 0},
        ["生命回复速度"] = {Tag = {}, Value = 0},
        ["魔法值"] = {Tag = {}, Value = 0},
        ["魔法回复速度"] = {Tag = {}, Value = 0},
        ["护甲"] = {Tag = {}, Value = 0},
        ["攻击力"] = {Tag = {}, Value = 0},
        ["移动速度"] = {Tag = {}, Value = 0},
        ["攻击速度"] = {Tag = {}, Value = 0}
    }
end
return testComponents
```
在initialization.lua内注册组件
```lua
local functions = require 'library.functions'
local Registry = require 'library.Core.Registry'
require 'library.Component.testComponents'

local initialization = {}
function initialization.Int()
    -- statements
    -- 将所有组件注册
    Registry.add(functions.import('library.Component.testComponents'))
end
return initialization
```
所有游戏对象继承GameObject。
```lua
require 'library.lib.lib'
-- require 'library.lib.Guid'
local GameObject = require 'library.Core.GameObject'
local class = lib.class
Hero = class('Hero', GameObject)
function Hero:initialize()
    GameObject.initialize(self)
    self:addComponent("testCompenents")
end
return Hero
```
测试
```lua
local int = require 'library.Core.initialization'
require "library.Archetype.Entity"
--require 'library.Core.Registe'
--local BaseCompenents = require 'library.Component.BaseCompenents'
require 'library.Core.Registry'
int.Int()
local d = {}
for i = 1, 10, 1 do
    -- statements
    local p1 = Hero.Item:new()
    p1.ID = i
    local com = p1:getComponent("testComponents")
com:SetData("智力", i)  
    com:SetData("力量", i)
end
for i = 1, #d, 1 do
    -- statements
    print(d[i].ID)
    local com = d[i]:getComponent("testComponents")
    print(com:GetData("智力"))
    print("力量"..com:GetData("力量"))
    print(com.ID)
    print("---------------------")
end
```

## 许可证

[![license](https://img.shields.io/github/license/halo-dev/halo.svg?style=flat-square)](https://github.com/halo-dev/halo/blob/master/LICENSE)

> Lua-ECS 使用 GPL-v3.0 协议开源，请尽量遵守开源协议。
