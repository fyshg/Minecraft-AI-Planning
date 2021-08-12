function resetLog()
    local h=fs.open("log.txt","w")
    h.write(os.date('%Y-%m-%d %H:%M:%S'))
end
function log(text)
    local h=fs.open("log.txt","a")
    h.write(text)
    h.close()
end