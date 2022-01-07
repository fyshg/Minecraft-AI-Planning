function resetLog()
    local h=fs.open("log.txt","w")
    h.write(os.date('%Y-%m-%d %H:%M:%S').."\n")
end
function log(text, name, silent)
    if text==nil
    then log("nil",name)
        return
    end

    if name~=nil then
        local h=fs.open("log.txt","a")
        if not silent then print("<"..name..">  ") end
        h.write("<"..name..">  ")
        h.close()
    end


    if type(text)=="table" then
        for i in pairs(text) do
            log(text[i],i, silent)
        end
        return
    end

    if type(text)=="boolean" then
        text=tostring(text)
    end



    local h=fs.open("log.txt","a")
    if not silent then print(text.."\n") end
    text2=getStackTrace(2,3)..": "
    text=text2..string.rep(" ",100-text2:len())..text
    h.write(text.."\n")
    h.close()
end