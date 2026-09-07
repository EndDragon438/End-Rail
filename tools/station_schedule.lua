mon = peripheral.wrap("left")
dis = peripheral.wrap("top")
dis.resize(64, 8)

mon.setBackgroundColor(colors.black)
mon.clear()


cached = {
    "2  min ELR Passenger 01 Central Station A1",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
}

while true do
    local dump = dis.dump()
    for local i = 1, #dump do
        local cleaned = string.gsub(dump[i], "[ \n,]")
        if cached[i] ~= dump[i] then
            cached[i] = dump[i]
        end
    end
    
    for local j = 1, 4 do
        mon.setCursorPos(0, j)
        mon.write(dis.getLine(j))
    end
    
    for local k = 1, 4 do
        mon.setCursorPos(0, k + 5)
        mon.write(dis.getLine(k + 4))
    end
    sleep(0.05)
end