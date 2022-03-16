require("logger")
function tableSize(table)
    local i=0
    for t in pairs(table) do
        i=i+1
    end
    return i
end

function has_value (tab, val)
    tab = tab or {}
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

function getStackTrace(depht, minus)
    s=debug.traceback()
    words={}
    for w in s:gmatch("\n\t([^\n]*): ") do
        table.insert(words, w)
    end
    ret=""
    for i = minus,(depht+minus) do
        --words[i]=words[i]:gsub("\n","")
        ret=ret.."["..words[i].."]"
    end
    return ret
end


-- https://stackoverflow.com/questions/9168058/how-to-dump-a-table-to-console
function print_table(node)
local cache, stack, output = {},{},{}
local depth = 1
local output_str = "{\n"

while true do
    local size = 0
    for k,v in pairs(node) do
        size = size + 1
    end

    local cur_index = 1
    for k,v in pairs(node) do
        if (cache[node] == nil) or (cur_index >= cache[node]) then

            if (string.find(output_str,"}",output_str:len())) then
                output_str = output_str .. ",\n"
            elseif not (string.find(output_str,"\n",output_str:len())) then
                output_str = output_str .. "\n"
            end

            -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
            table.insert(output,output_str)
            output_str = ""

            local key
            if (type(k) == "number" or type(k) == "boolean") then
                key = "["..tostring(k).."]"
            else
                key = "['"..tostring(k).."']"
            end

            if (type(v) == "number" or type(v) == "boolean") then
                output_str = output_str .. string.rep('\t',depth) .. key .. " = "..tostring(v)
            elseif (type(v) == "table") then
                output_str = output_str .. string.rep('\t',depth) .. key .. " = {\n"
                table.insert(stack,node)
                table.insert(stack,v)
                cache[node] = cur_index+1
                break
            else
                output_str = output_str .. string.rep('\t',depth) .. key .. " = '"..tostring(v).."'"
            end

            if (cur_index == size) then
                output_str = output_str .. "\n" .. string.rep('\t',depth-1) .. "}"
            else
                output_str = output_str .. ","
            end
        else
            -- close the table
            if (cur_index == size) then
                output_str = output_str .. "\n" .. string.rep('\t',depth-1) .. "}"
            end
        end

        cur_index = cur_index + 1
    end

    if (size == 0) then
        output_str = output_str .. "\n" .. string.rep('\t',depth-1) .. "}"
    end

    if (#stack > 0) then
        node = stack[#stack]
        stack[#stack] = nil
        depth = cache[node] == nil and depth + 1 or depth - 1
    else
        break
    end
end

-- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
table.insert(output,output_str)
output_str = table.concat(output)

log(output_str)
end