-- Find peripherals
local detector = peripheral.find("playerDetector")



-- List of players to track
local targets = detector.getOnlinePlayers()
local tracking = true

-- Create tables to store tracking status and notification status
local trackingStatus = {}
for i, name in ipairs(targets) do
    trackingStatus[name] = false
end

while tracking do
    -- Clear the monitor
    term.clear()
    term.setCursorPos(1, 1)
    
    -- Write the header
    term.setTextColor(colors.yellow)
    term.write("===== TheStalkinator =====")
    term.setCursorPos(1, 2)
    term.setTextColor(colors.white)
    
    local playersOnline = 0
    local currentLine = 3
    
    -- Process each target
    for i, name in ipairs(targets) do
        local targetPos = detector.getPlayerPos(name)
        
        if targetPos and targetPos.x and targetPos.y and targetPos.z then
            
            term.setCursorPos(1, currentLine)
            term.setTextColor(colors.lime)
            term.write(name)
            
            currentLine = currentLine + 1
            term.setCursorPos(1, currentLine)
            term.write("X: " .. targetPos.x)
            
            currentLine = currentLine + 1
            term.setCursorPos(1, currentLine)
            term.write("Y: " .. targetPos.y)
            
            currentLine = currentLine + 1
            term.setCursorPos(1, currentLine)
            term.write("Z: " .. targetPos.z)
            
            
            trackingStatus[name] = true
            playersOnline = playersOnline + 1
    
            currentLine = currentLine + 1  -- Only move down after showing player info
        else
            trackingStatus[name] = false
            -- Do not increase currentLine or draw anything if offline
        end
    end
    
    
    -- Write the footer
    term.setCursorPos(1, currentLine + 1)
    term.setTextColor(colors.yellow)
    term.write("=======================")
    
    term.setCursorPos(1, currentLine + 2)
    term.setTextColor(colors.white)
    term.write(playersOnline .. " out of " .. #targets .. " players online")
    
    sleep(3)
end