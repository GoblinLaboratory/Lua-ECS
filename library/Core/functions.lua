require 'string'
require 'math'
local functions = {}
--[[--
输出格式化字符串
~~~ lua
printf("The value = %d", 100)
~~~
@param string fmt 输出格式
@param [mixed ...] 更多参数
]]
function functions.printf(fmt, ...) print(string.format(tostring(fmt), ...)) end
--[[--
检查并尝试转换为数值，如果无法转换则返回 0
@param mixed value 要检查的值
@param [integer base] 进制，默认为十进制
@return number
]]
function functions.checknumber(value, base) return tonumber(value, base) or 0 end

--[[--
检查并尝试转换为整数，如果无法转换则返回 0
@param mixed value 要检查的值
@return integer
]]
-- function functions.checkint(value)
--     return math.round(functions.checknumber(value))
-- end

--[[--
检查并尝试转换为布尔值，除了 nil 和 false，其他任何值都会返回 true
@param mixed value 要检查的值
@return boolean
]]
function functions.checkbool(value) return (value ~= nil and value ~= false) end

--[[--
检查值是否是一个表格，如果不是则返回一个空表格
@param mixed value 要检查的值
@return table
]]
function functions.checktable(value)
    if type(value) ~= "table" then value = {} end
    return value
end
--[[--
如果表格中指定 key 的值为 nil，或者输入值不是表格，返回 false，否则返回 true
@param table hashtable 要检查的表格
@param mixed key 要检查的键名
@return boolean
]]
function functions.isset(hashtable, key)
    local t = type(hashtable)
    return (t == "table" or t == "userdata") and hashtable[key] ~= nil
end
--[[--
深度克隆一个值
~~~ lua
-- 下面的代码，t2 是 t1 的引用，修改 t2 的属性时，t1 的内容也会发生变化
local t1 = {a = 1, b = 2}
local t2 = t1
t2.b = 3    -- t1 = {a = 1, b = 3} <-- t1.b 发生变化
-- clone() 返回 t1 的副本，修改 t2 不会影响 t1
local t1 = {a = 1, b = 2}
local t2 = clone(t1)
t2.b = 3    -- t1 = {a = 1, b = 2} <-- t1.b 不受影响
~~~
@param mixed object 要克隆的值
@return mixed
]]
function functions.clone(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for key, value in pairs(object) do
            new_table[_copy(key)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end
    return _copy(object)
end
--[[--
根据系统时间初始化随机数种子，让后续的 math.random() 返回更随机的值
]]
function functions.newrandomseed()
    local ok, socket = pcall(function() return require("socket") end)

    if ok then
        -- 如果集成了 socket 模块，则使用 socket.gettime() 获取随机数种子
        math.randomseed(socket.gettime())
    else
        math.randomseed(os.time())
    end
    math.random()
    math.random()
    math.random()
    math.random()
end
--[[--
对数值进行四舍五入，如果不是数值则返回 0
@param number value 输入值
@return number
]]
function functions.round(value) return math.floor(value + 0.5) end

function functions.angle2radian(angle) return angle * math.pi / 180 end

function functions.radian2angle(radian) return radian / math.pi * 180 end
--[[--
检查指定的文件或目录是否存在，如果存在返回 true，否则返回 false
可以使用 CCFileUtils:fullPathForFilename() 函数查找特定文件的完整路径，例如：
~~~ lua
local path = CCFileUtils:sharedFileUtils():fullPathForFilename("gamedata.txt")
if io.exists(path) then
    ....
end
~~~
@param string path 要检查的文件或目录的完全路径
@return boolean
]]
function functions.exists(path)
    local file = io.open(path, "r")
    if file then
        io.close(file)
        return true
    end
    return false
end

--[[--
读取文件内容，返回包含文件内容的字符串，如果失败返回 nil
io.readfile() 会一次性读取整个文件的内容，并返回一个字符串，因此该函数不适宜读取太大的文件。
@param string path 文件完全路径
@return string
]]
function functions.readfile(path)
    local file = io.open(path, "r")
    if file then
        local content = file:read("*a")
        io.close(file)
        return content
    end
    return nil
end

--[[--
以字符串内容写入文件，成功返回 true，失败返回 false
"mode 写入模式" 参数决定 io.writefile() 如何写入内容，可用的值如下：
-   "w+" : 覆盖文件已有内容，如果文件不存在则创建新文件
-   "a+" : 追加内容到文件尾部，如果文件不存在则创建文件
此外，还可以在 "写入模式" 参数最后追加字符 "b" ，表示以二进制方式写入数据，这样可以避免内容写入不完整。
**Android 特别提示:** 在 Android 平台上，文件只能写入存储卡所在路径，assets 和 data 等目录都是无法写入的。
@param string path 文件完全路径
@param string content 要写入的内容
@param [string mode] 写入模式，默认值为 "w+b"
@return boolean
]]
function functions.writefile(path, content, mode)
    mode = mode or "w+b"
    local file = io.open(path, mode)
    if file then
        if file:write(content) == nil then return false end
        io.close(file)
        return true
    else
        return false
    end
end
--[[--
拆分一个路径字符串，返回组成路径的各个部分
~~~ lua
local pathinfo  = io.pathinfo("/var/app/test/abc.png")
-- 结果:
-- pathinfo.dirname  = "/var/app/test/"
-- pathinfo.filename = "abc.png"
-- pathinfo.basename = "abc"
-- pathinfo.extname  = ".png"
~~~
@param string path 要分拆的路径字符串
@return table
]]
function functions.pathinfo(path)
    local pos = string.len(path)
    local extpos = pos + 1
    while pos > 0 do
        local b = string.byte(path, pos)
        if b == 46 then -- 46 = char "."
            extpos = pos
        elseif b == 47 then -- 47 = char "/"
            break
        end
        pos = pos - 1
    end

    local dirname = string.sub(path, 1, pos)
    local filename = string.sub(path, pos + 1)
    extpos = extpos - pos
    local basename = string.sub(filename, 1, extpos - 1)
    local extname = string.sub(filename, extpos)
    return {
        dirname = dirname,
        filename = filename,
        basename = basename,
        extname = extname
    }
end
--[[--
返回指定文件的大小，如果失败返回 false
@param string path 文件完全路径
@return integer
]]
function functions.filesize(path)
    local size = false
    local file = io.open(path, "r")
    if file then
        local current = file:seek()
        size = file:seek("end")
        file:seek("set", current)
        io.close(file)
    end
    return size
end
--[[--
计算表格包含的字段数量
Lua table 的 "#" 操作只对依次排序的数值下标数组有效，table.nums() 则计算 table 中所有不为 nil 的值的个数。
@param table t 要检查的表格
@return integer
]]
function functions.nums(t)
    local count = 0
    for _, _ in pairs(t) do count = count + 1 end
    return count
end
--[[--
返回指定表格中的所有键
~~~ lua
local hashtable = {a = 1, b = 2, c = 3}
local keys = table.keys(hashtable)
-- keys = {"a", "b", "c"}
~~~
@param table hashtable 要检查的表格
@return table
]]
function functions.keys(hashtable)
    local keys = {}
    for k, _ in pairs(hashtable) do keys[#keys + 1] = k end
    return keys
end
--[[--
返回指定表格中的所有值
~~~ lua
local hashtable = {a = 1, b = 2, c = 3}
local values = table.values(hashtable)
-- values = {1, 2, 3}
~~~
@param table hashtable 要检查的表格
@return table
]]
function functions.values(hashtable)
    local values = {}
    for _, v in pairs(hashtable) do values[#values + 1] = v end
    return values
end
--[[--
将来源表格中所有键及其值复制到目标表格对象中，如果存在同名键，则覆盖其值
~~~ lua
local dest = {a = 1, b = 2}
local src  = {c = 3, d = 4}
table.merge(dest, src)
-- dest = {a = 1, b = 2, c = 3, d = 4}
~~~
@param table dest 目标表格
@param table src 来源表格
]]
function functions.merge(dest, src) for k, v in pairs(src) do dest[k] = v end end
--[[--
在目标表格的指定位置插入来源表格，如果没有指定位置则连接两个表格
~~~ lua
local dest = {1, 2, 3}
local src  = {4, 5, 6}
table.insertto(dest, src)
-- dest = {1, 2, 3, 4, 5, 6}
dest = {1, 2, 3}
table.insertto(dest, src, 5)
-- dest = {1, 2, 3, nil, 4, 5, 6}
~~~
@param table dest 目标表格
@param table src 来源表格
@param [integer begin] 插入位置
]]
function functions.insertto(dest, src, begin)
    begin = functions.checkint(begin)
    if begin <= 0 then begin = #dest + 1 end

    local len = #src
    for i = 0, len - 1 do dest[i + begin] = src[i + 1] end
end
--[[
从表格中查找指定值，返回其索引，如果没找到返回 false
~~~ lua
local array = {"a", "b", "c"}
print(table.indexof(array, "b")) -- 输出 2
~~~
@param table array 表格
@param mixed value 要查找的值
@param [integer begin] 起始索引值
@return integer
]]
function functions.indexof(array, value, begin)
    for i = begin or 1, #array do if array[i] == value then return i end end
    return false
end
--[[--
从表格中查找指定值，返回其 key，如果没找到返回 nil
~~~ lua
local hashtable = {name = "dualface", comp = "chukong"}
print(table.keyof(hashtable, "chukong")) -- 输出 comp
~~~
@param table hashtable 表格
@param mixed value 要查找的值
@return string 该值对应的 key
]]
function functions.keyof(hashtable, value)
    for k, v in pairs(hashtable) do if v == value then return k end end
    return nil
end
--[[--
从表格中删除指定值，返回删除的值的个数
~~~ lua
local array = {"a", "b", "c", "c"}
print(table.removebyvalue(array, "c", true)) -- 输出 2
~~~
@param table array 表格
@param mixed value 要删除的值
@param [boolean removeall] 是否删除所有相同的值
@return integer
]]
function functions.removebyvalue(array, value, removeall)
    local c, i, max = 0, 1, #array
    while i <= max do
        if array[i] == value then
            table.remove(array, i)
            c = c + 1
            i = i - 1
            max = max - 1
            if not removeall then break end
        end
        i = i + 1
    end
    return c
end
--[[--
对表格中每一个值执行一次指定的函数，并用函数返回值更新表格内容
~~~ lua
local t = {name = "dualface", comp = "chukong"}
table.map(t, function(v, k)
    -- 在每一个值前后添加括号
    return "[" .. v .. "]"
end)
-- 输出修改后的表格内容
for k, v in pairs(t) do
    print(k, v)
end
-- 输出
-- name [dualface]
-- comp [chukong]
~~~
fn 参数指定的函数具有两个参数，并且返回一个值。原型如下：
~~~ lua
function map_function(value, key)
    return value
end
~~~
@param table t 表格
@param function fn 函数
]]
function functions.map(t, fn) for k, v in pairs(t) do t[k] = fn(v, k) end end
--[[--
对表格中每一个值执行一次指定的函数，但不改变表格内容
~~~ lua
local t = {name = "dualface", comp = "chukong"}
table.walk(t, function(v, k)
    -- 输出每一个值
    print(v)
end)
~~~
fn 参数指定的函数具有两个参数，没有返回值。原型如下：
~~~ lua
function map_function(value, key)
end
~~~
@param table t 表格
@param function fn 函数
]]
function functions.walk(t, fn) for k, v in pairs(t) do fn(v, k) end end
--[[--
对表格中每一个值执行一次指定的函数，如果该函数返回 false，则对应的值会从表格中删除
~~~ lua
local t = {name = "dualface", comp = "chukong"}
table.filter(t, function(v, k)
    return v ~= "dualface" -- 当值等于 dualface 时过滤掉该值
end)
-- 输出修改后的表格内容
for k, v in pairs(t) do
    print(k, v)
end
-- 输出
-- comp chukong
~~~
fn 参数指定的函数具有两个参数，并且返回一个 boolean 值。原型如下：
~~~ lua
function map_function(value, key)
    return true or false
end
~~~
@param table t 表格
@param function fn 函数
]]
function functions.filter(t, fn)
    for k, v in pairs(t) do if not fn(v, k) then t[k] = nil end end
end
--[[--
遍历表格，确保其中的值唯一
~~~ lua
local t = {"a", "a", "b", "c"} -- 重复的 a 会被过滤掉
local n = table.unique(t)
for k, v in pairs(n) do
    print(v)
end
-- 输出
-- a
-- b
-- c
~~~
@param table t 表格
@return table 包含所有唯一值的新表格
]]
function functions.unique(t)
    local check = {}
    local n = {}
    for k, v in pairs(t) do
        if not check[v] then
            n[k] = v
            check[v] = true
        end
    end
    return n
end
--[[--
去除输入字符串头部的空白字符，返回结果
~~~ lua
local input = "  ABC"
print(string.ltrim(input))
-- 输出 ABC，输入字符串前面的两个空格被去掉了
~~~
空白字符包括：
-   空格
-   制表符 \t
-   换行符 \n
-   回到行首符 \r
@param string input 输入字符串
@return string 结果
@see string.rtrim, string.trim
]]
function functions.ltrim(input) return string.gsub(input, "^[ \t\n\r]+", "") end

--[[--
去除输入字符串尾部的空白字符，返回结果
~~~ lua
local input = "ABC  "
print(string.ltrim(input))
-- 输出 ABC，输入字符串最后的两个空格被去掉了
~~~
@param string input 输入字符串
@return string 结果
@see string.ltrim, string.trim
]]
function functions.rtrim(input) return string.gsub(input, "[ \t\n\r]+$", "") end

--[[--
去掉字符串首尾的空白字符，返回结果
@param string input 输入字符串
@return string 结果
@see string.ltrim, string.rtrim
]]
function functions.trim(input)
    input = string.gsub(input, "^[ \t\n\r]+", "")
    return string.gsub(input, "[ \t\n\r]+$", "")
end
--[[--
将字符串的第一个字符转为大写，返回结果
~~~ lua
local input = "hello"
print(string.ucfirst(input))
-- 输出 Hello
~~~
@param string input 输入字符串
@return string 结果
]]
function functions.ucfirst(input)
    return string.upper(string.sub(input, 1, 1)) .. string.sub(input, 2)
end
--[[--
载入一个模块
import() 与 require() 功能相同，但具有一定程度的自动化特性。
假设我们有如下的目录结构：
~~~
app/
app/classes/
app/classes/MyClass.lua
app/classes/MyClassBase.lua
app/classes/data/Data1.lua
app/classes/data/Data2.lua
~~~
MyClass 中需要载入 MyClassBase 和 MyClassData。如果用 require()，MyClass 内的代码如下：
~~~ lua
local MyClassBase = require("app.classes.MyClassBase")
local MyClass = class("MyClass", MyClassBase)
local Data1 = require("app.classes.data.Data1")
local Data2 = require("app.classes.data.Data2")
~~~
假如我们将 MyClass 及其相关文件换一个目录存放，那么就必须修改 MyClass 中的 require() 命令，否则将找不到模块文件。
而使用 import()，我们只需要如下写：
~~~ lua
local MyClassBase = import(".MyClassBase")
local MyClass = class("MyClass", MyClassBase)
local Data1 = import(".data.Data1")
local Data2 = import(".data.Data2")
~~~
当在模块名前面有一个"." 时，import() 会从当前模块所在目录中查找其他模块。因此 MyClass 及其相关文件不管存放到什么目录里，我们都不再需要修改 MyClass 中的 import() 命令。
这在开发一些重复使用的功能组件时，会非常方便。
我们可以在模块名前添加多个"." ，这样 import() 会从更上层的目录开始查找模块。
~
不过 import() 只有在模块级别调用（也就是没有将 import() 写在任何函数中）时，才能够自动得到当前模块名。如果需要在函数中调用 import()，那么就需要指定当前模块名：
~~~ lua
# MyClass.lua
# 这里的 ... 是隐藏参数，包含了当前模块的名字，所以最好将这行代码写在模块的第一行
local CURRENT_MODULE_NAME = ...
local function testLoad()
    local MyClassBase = import(".MyClassBase", CURRENT_MODULE_NAME)
    # 更多代码
end
~~~
@param string moduleName 要载入的模块的名字
@param [string currentModuleName] 当前模块名
@return module
]]
function functions.import(moduleName, currentModuleName)
    local currentModuleNameParts
    local moduleFullName -- = moduleName
    local offset = 1

    while true do
        if string.byte(moduleName, offset) ~= 46 then -- .
            moduleFullName = string.sub(moduleName, offset)
            if currentModuleNameParts and #currentModuleNameParts > 0 then
                moduleFullName = table.concat(currentModuleNameParts, ".") ..
                                     "." .. moduleFullName
            end
            break
        end
        offset = offset + 1

        if not currentModuleNameParts then
            if not currentModuleName then
                local _, v = debug.getlocal(3, 1)
                currentModuleName = v
            end

            currentModuleNameParts = string.split(currentModuleName, ".")
        end
        table.remove(currentModuleNameParts, #currentModuleNameParts)
    end

    return require(moduleFullName)
end
-- function functions.split(str, delimiter)
--     if str == nil or str == '' or delimiter == nil then return nil end

--     local result = {}
--     for match in (str .. delimiter):gmatch("(.-)" .. delimiter) do
--         table.insert(result, match)
--     end
--     return result
-- end
return functions
