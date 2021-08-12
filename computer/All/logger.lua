function resetLog()
    local h=fs.open("log.txt","w")
    h.write(os.date('%Y-%m-%d %H:%M:%S').."\n")
end
function log(text, name)
    if text==nil
    then log("nil",name)
        return
    end

    if name~=nil then
        local h=fs.open("log.txt","a")
        print("<"..name..">  ")
        h.write("<"..name..">  ")
        h.close()
    end


    if type(text)=="table" then
        for i in pairs(text) do
            log(text[i],i)
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