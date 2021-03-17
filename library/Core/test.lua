local int = require 'library.Core.initialization'
require "library.Archetype.Entity"
--require 'library.Core.Registe'
--local BaseCompenents = require 'library.Component.BaseCompenents'
require 'library.Core.Registry'
int.Int()
local d = {}
for i = 1, 10, 1 do
    -- statements
    local p1 = Entity.Item:new()
    p1.ID = i
    local com = p1:getComponent("AttributeComponents")
    com:SetData("智力", i)
    com:SetData("力量", i)
    com.ID = i
    local com1 = p1:getComponent("BaseCompenents")
    com1:SetData("ID", i)
    table.insert(d, p1)
    -----------------------------------------
    --local R = Registe:Instance()
    -- local b = Registry.newObject("BaseCompenents")--BaseCompenents:new()
    -- b:SetData("ID", i)
    -- table.insert(d, b)
end
for i = 1, #d, 1 do
    -- statements
    print(d[i].ID)
    local com = d[i]:getComponent("AttributeComponents")
    print(com:GetData("智力"))
    print("力量"..com:GetData("力量"))
    print(com.ID)
    local com1 = d[i]:getComponent("BaseCompenents")
    print(com1:GetData("ID"))
    print(d[i].Guid)
    print(com1.Guid)
    local dota = com1.Data
    for  k, v in pairs(dota) do
        -- statements
        print(k)
    end
    ---------------------------------------
    -- print(d[i]:GetData("ID"))
    -- print(d[i].Guid)
    print("---------------------")
end
--local p1 = Entity.Item:new()
--print(".............."..p1.name)
--print(p1["测试"])
--local s = p1:getComponent("BaseCompenents")
--s:GetData()
--print(s.Data["力量"].Value)
--print("说明"..s:GetData("说明"))
--print("ds")