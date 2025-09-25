
local detector = peripheral.find("playerDetector")
local monitor = peripheral.find("monitor") or peripheral.wrap("right")
local chatbox = peripheral.find("chatBox") or peripheral.wrap("front")


if not monitor then
  print("No monitor found! Using terminal instead.")
  monitor = term
end


if not chatbox then
  print("No chatbox found! Warning messages will not be sent.")
end


local targets = detector.getOnlinePlayers()
local tracking = true


local trackingStatus = {}
local notifiedPlayers = {}
for i, name in ipairs(targets) do
    trackingStatus[name] = false
    notifiedPlayers[name] = false
end


monitor.setTextScale(1)

print("Enter your computer's coordinates:")
io.write("X coordinate: ")
local computerX = tonumber(io.read()) or 0
io.write("Y coordinate: ")
local computerY = tonumber(io.read()) or 0
io.write("Z coordinate: ")
local computerZ = tonumber(io.read()) or 0

print("Computer position set to: " .. computerX .. ", " .. computerY .. ", " .. computerZ)


local function getDistance(pos)
    local dx = pos.x - computerX
    local dy = pos.y - computerY
    local dz = pos.z - computerZ
    
    return math.sqrt(dx*dx + dy*dy + dz*dz)
end

while tracking do

    monitor.clear()
    monitor.setCursorPos(1, 1)
    

    monitor.setTextColor(colors.yellow)
    monitor.write("===== TheStalkinator =====")
    monitor.setCursorPos(1, 2)
    monitor.setTextColor(colors.white)
    
    local playersOnline = 0
    local currentLine = 3
    

    for i, name in ipairs(targets) do
        local targetPos = detector.getPlayerPos(name)
        
        monitor.setCursorPos(1, currentLine)
        
        if targetPos and targetPos.x and targetPos.y and targetPos.z then
            local distance = getDistance(targetPos)
            monitor.setTextColor(colors.lime)
            monitor.write(name .. " at X:" .. targetPos.x .. " Y:" .. targetPos.y .. " Z:" .. targetPos.z)
            

            currentLine = currentLine + 1
            monitor.setCursorPos(1, currentLine)
            monitor.write("  Distance: " .. math.floor(distance) .. " blocks")
            

            if distance <= 100 and not notifiedPlayers[name] and chatbox then
                chatbox.sendMessageToPlayer("You are being tracked by TheStalkinator!", name)
                notifiedPlayers[name] = true
                

                currentLine = currentLine + 1
                monitor.setCursorPos(1, currentLine)
                monitor.setTextColor(colors.orange)
                monitor.write("  WARNING SENT!")
                monitor.setTextColor(colors.lime)
            end
            

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
    

    monitor.setCursorPos(1, currentLine + 1)
    monitor.setTextColor(colors.yellow)
    monitor.write("=======================")
    
    monitor.setCursorPos(1, currentLine + 2)
    monitor.setTextColor(colors.white)
    monitor.write(playersOnline .. " out of " .. #targets .. " players online")
    
    sleep(3)
end