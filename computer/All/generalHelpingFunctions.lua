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