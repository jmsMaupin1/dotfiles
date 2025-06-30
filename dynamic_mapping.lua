-- Dynamic mapping script that queries systems at runtime
local function query_aerospace_monitors()
    local handle = io.popen("aerospace list-monitors --json")
    if not handle then return {} end
    
    local result = handle:read("*a")
    handle:close()
    
    -- Parse JSON (simplified - in real implementation you'd use a JSON library)
    local monitors = {}
    for monitor_id, monitor_name in result:gmatch('"monitor%-id"%s*:%s*(%d+).-"monitor%-name"%s*:%s*"([^"]+)"') do
        table.insert(monitors, {
            monitor_id = tonumber(monitor_id),
            monitor_name = monitor_name
        })
    end
    
    return monitors
end

local function query_sketchybar_displays()
    local handle = io.popen("sketchybar --query displays")
    if not handle then return {} end
    
    local result = handle:read("*a")
    handle:close()
    
    -- Parse sketchybar output (simplified)
    local displays = {}
    for arrangement_id, direct_id, x, y, w, h in result:gmatch('"arrangement%-id":(%d+).-"DirectDisplayID":(%d+).-"x":([%d%.]+).-"y":([%d%.]+).-"w":([%d%.]+).-"h":([%d%.]+)') do
        table.insert(displays, {
            arrangement_id = tonumber(arrangement_id),
            DirectDisplayID = tonumber(direct_id),
            frame = {
                x = tonumber(x),
                y = tonumber(y),
                w = tonumber(w),
                h = tonumber(h)
            }
        })
    end
    
    return displays
end

local function query_system_displays()
    local handle = io.popen("system_profiler SPDisplaysDataType")
    if not handle then return {} end
    
    local result = handle:read("*a")
    handle:close()
    
    -- Parse system display info
    local displays = {}
    local current_display = nil
    
    for line in result:gmatch("[^\r\n]+") do
        local name = line:match("^%s*([^:]+):$")
        if name and name ~= "Displays" and name ~= "Graphics/Displays" and name ~= "Apple M2 Pro" then
            current_display = name
            displays[current_display] = {}
        elseif line:match("Resolution:") and current_display then
            local resolution = line:match("Resolution:%s*(.+)")
            if resolution then
                displays[current_display].resolution = resolution
            end
        end
    end
    
    return displays
end

local function build_mapping()
    print("Querying aerospace monitors...")
    local aerospace_monitors = query_aerospace_monitors()
    
    print("Querying sketchybar displays...")
    local sketchybar_displays = query_sketchybar_displays()
    
    print("Querying system displays...")
    local system_displays = query_system_displays()
    
    print("\n=== Aerospace Monitors ===")
    for _, monitor in ipairs(aerospace_monitors) do
        print(string.format("ID: %d, Name: %s", monitor.monitor_id, monitor.monitor_name))
    end
    
    print("\n=== Sketchybar Displays ===")
    for _, display in ipairs(sketchybar_displays) do
        print(string.format("Arrangement ID: %d, DirectDisplayID: %d, Position: (%d, %d), Size: %dx%d", 
            display.arrangement_id, display.DirectDisplayID, 
            display.frame.x, display.frame.y, display.frame.w, display.frame.h))
    end
    
    print("\n=== System Displays ===")
    for name, info in pairs(system_displays) do
        print(string.format("Name: %s, Resolution: %s", name, info.resolution or "Unknown"))
    end
    
    -- Build mapping based on position and size
    local mapping = {}
    
    print("\n=== Building Dynamic Mapping ===")
    for _, aero_monitor in ipairs(aerospace_monitors) do
        for _, sketchybar_display in ipairs(sketchybar_displays) do
            -- Match by position (leftmost, middle, bottom)
            if sketchybar_display.frame.x == 0 and sketchybar_display.frame.y == 0 then
                -- Leftmost display
                if aero_monitor.monitor_name:find("Sceptre") then
                    mapping[aero_monitor.monitor_id] = sketchybar_display.arrangement_id
                    print(string.format("Mapped: Aerospace '%s' (ID: %d) -> Sketchybar arrangement-id: %d (leftmost)", 
                        aero_monitor.monitor_name, aero_monitor.monitor_id, sketchybar_display.arrangement_id))
                end
            elseif sketchybar_display.frame.x > 1000 and sketchybar_display.frame.y > 1000 then
                -- Bottom display (likely built-in)
                if aero_monitor.monitor_name:find("Built%-in") or aero_monitor.monitor_name:find("Retina") then
                    mapping[aero_monitor.monitor_id] = sketchybar_display.arrangement_id
                    print(string.format("Mapped: Aerospace '%s' (ID: %d) -> Sketchybar arrangement-id: %d (bottom)", 
                        aero_monitor.monitor_name, aero_monitor.monitor_id, sketchybar_display.arrangement_id))
                end
            elseif sketchybar_display.frame.x > 0 and sketchybar_display.frame.y == 0 then
                -- Middle display
                if aero_monitor.monitor_name:find("USB") then
                    mapping[aero_monitor.monitor_id] = sketchybar_display.arrangement_id
                    print(string.format("Mapped: Aerospace '%s' (ID: %d) -> Sketchybar arrangement-id: %d (middle)", 
                        aero_monitor.monitor_name, aero_monitor.monitor_id, sketchybar_display.arrangement_id))
                end
            end
        end
    end
    
    print("\n=== Final Mapping ===")
    for aero_id, sketchybar_id in pairs(mapping) do
        print(string.format("Aerospace monitor %d -> Sketchybar arrangement-id %d", aero_id, sketchybar_id))
    end
    
    return mapping
end

-- Run the dynamic mapping
local mapping = build_mapping() 