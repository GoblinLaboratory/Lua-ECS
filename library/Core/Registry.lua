local Registry = {}
--组件列表
Registry.classes_ = {}
Registry.objects_ = {}
-- 添加组件
function Registry.add(cls, name)
    assert(type(cls) == "table" and cls.name ~= nil,
           "Registry.add() - invalid class")
    print("添加组件时名称"..cls.name)
    -- 设置组件名
    if not name then name = cls.name end
    assert(Registry.classes_[name] == nil, string.format(
               "Registry.add() - class \"%s\" already exists", tostring(name)))
    -- 添加组件
    Registry.classes_[name] = cls
end
-- 移除组件
function Registry.remove(name)
    assert(Registry.classes_[name] ~= nil,
           string.format("Registry.remove() - class \"%s\" not found", name))
    -- 移除组件
    Registry.classes_[name] = nil
end
-- 判断是否有组件
function Registry.exists(name) return Registry.classes_[name] ~= nil end
-- 新建组件实例
function Registry.newObject(name, ...)
    local cls = Registry.classes_[name]
    if not cls then
        -- auto load
        pcall(function()
            cls = require(name)
            Registry.add(cls, name)
        end)
    end
    assert(cls ~= nil, string.format(
               "Registry.newObject() - invalid class \"%s\"", tostring(name)))
    -- 返回组件实例
    print("返回组件实例")
    return cls:new(...)
end
-- 设置组件实例
function Registry.setObject(object, name)
    assert(Registry.objects_[name] == nil,
           string.format("Registry.setObject() - object \"%s\" already exists",
                         tostring(name)))
    assert(object ~= nil, "Registry.setObject() - object \"%s\" is nil",
           tostring(name))
    Registry.objects_[name] = object
end
-- 获取组件实例
function Registry.getObject(name)
    assert(Registry.objects_[name] ~= nil, string.format(
               "Registry.getObject() - object \"%s\" not exists", tostring(name)))
    return Registry.objects_[name]
end
-- 移除组件实例
function Registry.removeObject(name)
    assert(Registry.objects_[name] ~= nil,
           string.format("Registry.removeObject() - object \"%s\" not exists",
                         tostring(name)))
    Registry.objects_[name] = nil
end

function Registry.isObjectExists(name) return Registry.objects_[name] ~= nil end
function Registry.test()
    -- statements
    print("Registry测试...")
end
return Registry
