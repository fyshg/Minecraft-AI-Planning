function tableSize(table)
    local i=0
    for t in pairs(table) do
        i=i+1
    end
    return i
end