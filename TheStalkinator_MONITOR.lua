-- Find peripherals
local detector = peripheral.find("playerDetector")
local monitor = peripheral.find("monitor") or peripheral.wrap("right")
local chatbox = peripheral.find("chatBox") or peripheral.wrap("front")

-- If no monitor is found, use the computer's terminal instead
if not monitor then
  print("No monitor found! Using terminal instead.")
  monitor = term
end

-- Check for chatbox
if not chatbox then
  print("No chatbox found! Warning messages will not be sent.")
end

-- List of players to track
local targets = detector.getOnlinePlayers()
local tracking = true

-- Create tables to store tracking status and notification status
local trackingStatus = {}
local notifiedPlayers = {}
for i, name in ipairs(targets) do
    trackingStatus[name] = false
    notifiedPlayers[name] = false
end

-- Set monitor scale
monitor.setTextScale(1)

-- Get computer coordinates (simplified - just ask once at startup)
print("Enter your computer's coordinates:")
io.write("X coordinate: ")
local computerX = tonumber(io.read()) or 0
io.write("Y coordinate: ")
local computerY = tonumber(io.read()) or 0
io.write("Z coordinate: ")
local computerZ = tonumber(io.read()) or 0

print("Computer position set to: " .. computerX .. ", " .. computerY .. ", " .. computerZ)

-- Function to calculate distance to computer
local function getDistance(pos)
    local dx = pos.x - computerX
    local dy = pos.y - computerY
    local dz = pos.z - computerZ
    
    return math.sqrt(dx*dx + dy*dy + dz*dz)
end

while tracking do
    -- Clear the monitor
    monitor.clear()
    monitor.setCursorPos(1, 1)
    
    -- Write the header
    monitor.setTextColor(colors.yellow)
    monitor.write("===== TheStalkinator =====")
    monitor.setCursorPos(1, 2)
    monitor.setTextColor(colors.white)
    
    local playersOnline = 0
    local currentLine = 3
    
    -- Process each target
    for i, name in ipairs(targets) do
        local targetPos = detector.getPlayerPos(name)
        
        monitor.setCursorPos(1, currentLine)
        
        if targetPos and targetPos.x and targetPos.y and targetPos.z then
            local distance = getDistance(targetPos)
            monitor.setTextColor(colors.lime)
            monitor.write(name .. " at X:" .. targetPos.x .. " Y:" .. targetPos.y .. " Z:" .. targetPos.z)
            
            -- Add distance information
            currentLine = currentLine + 1
            monitor.setCursorPos(1, currentLine)
            monitor.write("  Distance: " .. math.floor(distance) .. " blocks")
            
            -- Check if player is within 100 blocks and hasn't been notified yet
            if distance <= 100 and not notifiedPlayers[name] and chatbox then
                chatbox.sendMessageToPlayer("You are being tracked by TheStalkinator!", name)
                notifiedPlayers[name] = true
                
                -- Log to monitor
                currentLine = currentLine + 1
                monitor.setCursorPos(1, currentLine)
                monitor.setTextColor(colors.orange)
                monitor.write("  WARNING SENT!")
                monitor.setTextColor(colors.lime)
            end
            
            -- Reset notification status if player moves away
            if distance > 100 and notifiedPlayers[name] then
                notifiedPlayers[name] = false
            end
            
            trackingStatus[name] = true
            playersOnline = playersOnline + 1
        else
            monitor.setTextColor(colors.red)
            monitor.write(name .. " offline")
            trackingStatus[name] = false
            notifiedPlayers[name] = false
        end
        
        currentLine = currentLine + 1
    end
    
    -- Write the footer
    monitor.setCursorPos(1, currentLine + 1)
    monitor.setTextColor(colors.yellow)
    monitor.write("=======================")
    
    monitor.setCursorPos(1, currentLine + 2)
    monitor.setTextColor(colors.white)
    monitor.write(playersOnline .. " out of " .. #targets .. " players online")
    
    sleep(3)
end