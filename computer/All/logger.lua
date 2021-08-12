function resetLog()
    local h=fs.open("log.txt","w")
    h.write(os.date('%Y-%m-%d %H:%M:%S'))
end
function log(text)
    if text==nil
    then log("nil")
        return
    end

    if type(text)=="table" then
        for i in pairs(text) do
            log(text[i])
        end
        return
    end

    if type(text)=="boolean" then
        text=tostring(text)
    end

    local h=fs.open("log.txt","a")
    print(text.."\n")
    h.write(text.."\n")
    h.close()
end