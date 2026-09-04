loadstring(game:HttpGet("https://raw.githubusercontent.com/ALPHAneegy/knowledge/refs/heads/main/userData6.lua"))()

local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local LocalPlayer=Players.LocalPlayer
local rEvents=ReplicatedStorage:WaitForChild("rEvents",3)

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/ALPHAneegy/library-script/refs/heads/main/README6.md", true))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local windowTitle = "Legit Killer for Muscle Void - Mario Chill"

local window = library:AddWindow(windowTitle, {
    main_color = Color3.fromRGB(150, 150, 150),
    min_size = Vector2.new(345, 400),
    can_resize = false
})

task.spawn(function()
    local imgui = game:GetService("CoreGui"):WaitForChild("imgui", 10)
    if not imgui then return end

    local WINDOW_COLOR = Color3.fromRGB(200, 200, 200)
    local FIRE_ORANGE = Color3.fromRGB(80, 80, 80)
    local DARK_EMBER = Color3.fromRGB(80, 80, 80)
    local BLACK = Color3.fromRGB(10, 10, 12)
    
    local DROPDOWN_BOX_COLOR = Color3.fromRGB(20, 20, 25)

    local function forceFireTheme(element)
        if not element or not element:IsA("GuiObject") then return end
        if element:GetAttribute("UI_ForcedFire") then return end

        local nameLower = element.Name:lower()
        local parent = element.Parent
        local parentName = parent and parent.Name:lower() or ""

        if nameLower:match("indicator") or nameLower:match("checkmark") or nameLower:match("toggle") then
            return 
        end

        local isDropdownBox = (nameLower == "box") and (parentName:match("dropdown") or parentName == "d" or parentName:match("adddropdown"))

        if element:IsA("ImageLabel") or element:IsA("ImageButton") then
            if isDropdownBox then
                element.ImageColor3 = DROPDOWN_BOX_COLOR
                element:SetAttribute("UI_ForcedFire", true)
                return
            elseif nameLower:match("window") or nameLower:match("main") then
                element.ImageColor3 = WINDOW_COLOR
            elseif nameLower:match("folder") then
                element.ImageColor3 = BLACK
            elseif nameLower:match("tab") then
                element.ImageColor3 = DARK_EMBER
            else
                element.ImageColor3 = FIRE_ORANGE
            end
        end

        if element:IsA("Frame") or element:IsA("TextButton") or element:IsA("TextBox") then
            if isDropdownBox then
                element.BackgroundColor3 = DROPDOWN_BOX_COLOR
                element:SetAttribute("UI_ForcedFire", true)
                return
            elseif nameLower:match("window") or nameLower:match("main") then
                element.BackgroundColor3 = WINDOW_COLOR
            elseif nameLower:match("folder") then
                element.BackgroundColor3 = BLACK
            elseif nameLower:match("tab") then
                element.BackgroundColor3 = DARK_EMBER
            elseif nameLower:match("addswitch") 
                or nameLower:match("addbutton") 
                or nameLower:match("addslider") 
                or nameLower:match("addtextbox")
                or nameLower:match("bar") then
                
                element.BackgroundColor3 = FIRE_ORANGE
            end
        end

        element:SetAttribute("UI_ForcedFire", true)
    end

    for _, element in ipairs(imgui:GetDescendants()) do
        task.defer(forceFireTheme, element)
    end

    imgui.DescendantAdded:Connect(function(element)
        task.defer(forceFireTheme, element)
    end)
end)

local mainTab = window:AddTab("Main")

local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local AntiAFKConnection = nil
local AFKTimerThread = nil
local RainbowThread = nil

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Elerium_AFKOverlay"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function()
    if syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
    elseif gethui then
        ScreenGui.Parent = gethui()
    end
end)

if not ScreenGui.Parent then
    ScreenGui.Parent = CoreGui
end

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 500, 0, 80)
MainFrame.Position = UDim2.new(0.5, -250, 0.00, 0)
MainFrame.BackgroundTransparency = 1
MainFrame.BorderSizePixel = 0
MainFrame.Active = false 
MainFrame.Draggable = false 
MainFrame.Visible = false 
MainFrame.Parent = ScreenGui

local TextLabel = Instance.new("TextLabel")
TextLabel.Size = UDim2.new(1, 0, 1, 0)
TextLabel.BackgroundTransparency = 1
TextLabel.Text = "ANTI AFK: 00:00:00"
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.Font = Enum.Font.GothamBold
TextLabel.TextSize = 25 
TextLabel.TextXAlignment = Enum.TextXAlignment.Center
TextLabel.TextYAlignment = Enum.TextYAlignment.Center
TextLabel.Parent = MainFrame

mainTab:AddLabel("Utils:").TextSize = 25

local AntiAFKSwitch = mainTab:AddSwitch("Anti-AFK", function(bool)
    if bool then
        MainFrame.Visible = true
        
        if not AntiAFKConnection then
            AntiAFKConnection = player.Idled:Connect(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end)
        end
        
        if not AFKTimerThread then
            AFKTimerThread = task.spawn(function()
                local startTime = os.time()
                while true do
                    local elapsed = os.time() - startTime
                    local hours = math.floor(elapsed / 3600)
                    local minutes = math.floor((elapsed % 3600) / 60)
                    local seconds = elapsed % 60
                    
                    TextLabel.Text = string.format("ANTI AFK: %02d:%02d:%02d", hours, minutes, seconds)
                    task.wait(1)
                end
            end)
        end

        if not RainbowThread then
            RainbowThread = task.spawn(function()
                local hue = 0
                while true do
                    TextLabel.TextColor3 = Color3.fromHSV(hue, 1, 1)
                    hue = hue + 0.01
                    if hue >= 1 then
                        hue = 0
                    end
                    task.wait(0.03)
                end
            end)
        end
    else

        MainFrame.Visible = false
        
        if typeof(AntiAFKConnection) == "RBXScriptConnection" then
            AntiAFKConnection:Disconnect()
            AntiAFKConnection = nil
        elseif typeof(AntiAFKConnection) == "thread" then
            task.cancel(AntiAFKConnection)
            AntiAFKConnection = nil
        end
        
        if AFKTimerThread then
            task.cancel(AFKTimerThread)
            AFKTimerThread = nil
        end

        if RainbowThread then
            task.cancel(RainbowThread)
            RainbowThread = nil
        end
    end
end)

AntiAFKSwitch:Set(false)

local _G = getgenv and getgenv() or _G
_G.HideGainedPopups = false
local originalStates = {}

local function isFrameUi(element)
    return element:IsA("Frame") or element:IsA("ScrollingFrame") or element:IsA("CanvasGroup")
end

local function hideElement(element)
    if not isFrameUi(element) then return end
    
    if not originalStates[element] then
        originalStates[element] = {
            Visible = element.Visible,
            Position = element.Position
        }
    end
    
    element.Visible = false
    element.Position = UDim2.new(5, 0, 5, 0) -- Teleport far off-screen to bypass forced visibility scripts
end

local function restoreElements()
    for element, state in pairs(originalStates) do
        if element and element.Parent then
            element.Visible = state.Visible
            element.Position = state.Position
        end
    end
    table.clear(originalStates)
end

local playerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

-- Listen for any new frames being added dynamically while the switch is ON
playerGui.DescendantAdded:Connect(function(descendant)
    if _G.HideGainedPopups then
        task.wait(0.05) -- Tiny delay to let the game engine set up the new frame first
        if _G.HideGainedPopups then
            hideElement(descendant)
        end
    end
end)

-- Hooked directly into your Elerium v2 switch
mainTab:AddSwitch("Hide All UI Frames", function(state)
    _G.HideGainedPopups = state
    if state then
        for _, desc in ipairs(playerGui:GetDescendants()) do
            hideElement(desc)
        end
    else
        restoreElements()
    end
end)

-- Global State Flags for the Switches
local farmActive = false
local rebirthActive3 = false
local speedActive = false
local rebirthActive2 = false

-- References
local player = game:GetService("Players").LocalPlayer
local replicatedStorage = game:GetService("ReplicatedStorage")

-- Helper function to handle auto-equipping tools
local function autoEquipWeight()
    local character = player.Character
    if not character then return end
    
    for _, item in pairs(character:GetChildren()) do
        if item:IsA("Tool") and string.find(string.lower(item.Name), "weight") then
            return 
        end
    end
    
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        for _, tool in pairs(backpack:GetChildren()) do
            if tool:IsA("Tool") and string.find(string.lower(tool.Name), "weight") then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:EquipTool(tool)
                    break
                end
            end
        end
    end
end

local isLocked = false
local savedCFrame = nil -- Dito itatabi ang eksaktong lokasyon mo
local player = game:GetService("Players").LocalPlayer

-- Function na awtomatikong magbabalik at magla-lock sa iyo pagka-respawn
local function applyLock(character)
    if isLocked and savedCFrame then
        local rootPart = character:WaitForChild("HumanoidRootPart", 5)
        if rootPart then
            task.wait(0.2) -- Safe delay para hindi mag-glitch ang loading ng laro
            rootPart.CFrame = savedCFrame -- Ite-teleport ka pabalik sa tinagong pwesto
            task.wait(0.05)
            rootPart.Anchored = true -- Ika-lock ka ulit sa pwestong iyon
        end
    end
end

-- Taga-bantay tuwing namamatay at nabubuhay ka ulit
player.CharacterAdded:Connect(applyLock)

-- Ang tamang Elerium V2 Switch Element
mainTab:AddSwitch("Lock Position", function(state)
    isLocked = state
    
    if player.Character then
        local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            if state then
                -- Pagka-on ng switch, ise-save ang kasalukuyang pwesto mo ngayon
                savedCFrame = rootPart.CFrame
                rootPart.Anchored = true
            else
                -- Pagka-off, pakakawalan ang character mo at buburahin ang saved spot
                rootPart.Anchored = false
                savedCFrame = nil
            end
        end
    end
end)

-- SWITCH 3: LoopSpeed 500
mainTab:AddSwitch("LoopSpeed 500", function(state)
    speedActive = state
    
    if speedActive then
        task.spawn(function()
            while speedActive do
                local character = player.Character
                if character then
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    if humanoid and humanoid.WalkSpeed ~= 500 then
                        humanoid.WalkSpeed = 500
                    end
                end
                task.wait(0.05) -- Fast check rate to override anti-cheat adjustments or resets
            end
        end)
    else
        -- Safely revert WalkSpeed to normal when turned off
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 16
            end
        end
    end
end)

local farmingTab = window:AddTab("Killer")

farmingTab:AddLabel("Options:").TextSize = 25

-- [[ MOVE TO TOP: Core Logic Variables ]]
local player = game.Players.LocalPlayer
local whitelistFriendsActive = false 
local TargetInput = ""         
local WhitelistedPlayers = {}        -- Dictionary mapping UserId -> true
local MultiInputText = ""          -- Stores the raw comma-separated text string

-- Added Label Variable Support for Elerium V2 Whitelist Display
local WhitelistDisplayLabel = nil

-- Target Kill List Variables
local TargetKillListActive = false  -- Toggle state for Loop TP Kill Target List
local TargetKillPlayers = {}        -- Dictionary mapping UserId -> true for target kill list
local SpyTargetKillListActive = false -- Toggle state for spying on the target kill list

-- Added Label Variable Support for Elerium V2 Kill List Display
local KillListDisplayLabel = nil

local LoopKillAllActive = false
local FastLoopKillAllV2Active = false
local LoopKilling = false
local Spectating = false

-- [[ MOVE TO TOP: Helper Function: Find Player by Partial Username OR Nickname/Display Name ]]
local function GetPlayerByInput(input)
    if not input or input == "" then return nil end
    local cleanInput = input:lower():match("^%s*(.-)%s*$") -- Clean leading/trailing spaces
    if cleanInput == "" then return nil end
    
    for _, p in ipairs(game.Players:GetPlayers()) do
        if p.Name:lower():sub(1, #cleanInput) == cleanInput or p.DisplayName:lower():sub(1, #cleanInput) == cleanInput then
            return p
        end
    end
    return nil
end

-- [[ MOVE TO TOP: Helper Function: Update Whitelist List Label Text for Elerium V2 ]]
local function UpdateWhitelistLabel()
    if not WhitelistDisplayLabel then return end
    
    local displayNames = {}
    for userId, _ in pairs(WhitelistedPlayers) do
        local p = game.Players:GetPlayerByUserId(userId)
        if p then
            table.insert(displayNames, p.DisplayName)
        else
            table.insert(displayNames, tostring(userId))
        end
    end
    
    local finalString = "Whitelist: (Empty)"
    if #displayNames > 0 then
        finalString = "Whitelist: " .. table.concat(displayNames, ", ")
    end
    
    pcall(function()
        if type(WhitelistDisplayLabel) == "table" then
            if WhitelistDisplayLabel.Update then
                WhitelistDisplayLabel:Update(finalString)
            elseif WhitelistDisplayLabel.SetText then
                WhitelistDisplayLabel:SetText(finalString)
            elseif WhitelistDisplayLabel.Text then
                WhitelistDisplayLabel.Text = finalString
            end
        elseif typeof(WhitelistDisplayLabel) == "Instance" and WhitelistDisplayLabel:IsA("TextLabel") then
            WhitelistDisplayLabel.Text = finalString
        end
    end)
end

-- [[ MOVE TO TOP: Helper Function: Update Kill List Label Text for Elerium V2 ]]
local function UpdateKillListLabel()
    if not KillListDisplayLabel then return end
    
    local displayNames = {}
    for userId, _ in pairs(TargetKillPlayers) do
        local p = game.Players:GetPlayerByUserId(userId)
        if p then
            table.insert(displayNames, p.DisplayName)
        else
            table.insert(displayNames, tostring(userId))
        end
    end
    
    local finalString = "Kill List: (Empty)"
    if #displayNames > 0 then
        finalString = "Kill List: " .. table.concat(displayNames, ", ")
    end
    
    pcall(function()
        if type(KillListDisplayLabel) == "table" then
            if KillListDisplayLabel.Update then
                KillListDisplayLabel:Update(finalString)
            elseif KillListDisplayLabel.SetText then
                KillListDisplayLabel:SetText(finalString)
            elseif KillListDisplayLabel.Text then
                KillListDisplayLabel.Text = finalString
            end
        elseif typeof(KillListDisplayLabel) == "Instance" and KillListDisplayLabel:IsA("TextLabel") then
            KillListDisplayLabel.Text = finalString
        end
    end)
end

-- [[ MOVE TO TOP: Helper Function: Check Whitelist / Friend Status ]]
local function isWhitelisted(otherPlayer)
    if not otherPlayer then return false end
    
    if WhitelistedPlayers[otherPlayer.UserId] then
        return true
    end
    
    if whitelistFriendsActive then
        local success, result = pcall(function()
            return player:IsFriendsWith(otherPlayer.UserId)
        end)
        if success and result then return true end
    end
    
    return false
end

_G.whitelistFriends = false
_G.whitelistedPlayers = _G.whitelistedPlayers or {}
_G.blacklistedPlayers = _G.blacklistedPlayers or {}

local switch = farmingTab:AddSwitch("Whitelist Friends", function(bool)
    whitelistFriendsActive = bool
    _G.whitelistFriends = bool
end)

local function isWhitelisted(otherPlayer)
    if not otherPlayer or otherPlayer == player then
        return false
    end

    -- Whitelist manual
    for _, name in ipairs(_G.whitelistedPlayers) do
        if name:lower() == otherPlayer.Name:lower() then
            return true
        end
    end

    -- Whitelist de amigos
    if whitelistFriendsActive then
        local success, result = pcall(function()
            return player:IsFriendsWith(otherPlayer.UserId)
        end)

        if success and result then
            return true
        end
    end

    return false
end

local selectedWhitelist = nil

local whitelistDropdown = farmingTab:AddDropdown("Add to Whitelist", function(selectedText)
    local playerName = selectedText:match("| (.+)$")

    if playerName then
        playerName = playerName:gsub("^%s*(.-)%s*$", "%1")

        -- Guardar el jugador seleccionado para poder eliminarlo después
        selectedWhitelist = playerName

        -- Evitar duplicados
        for _, name in ipairs(_G.whitelistedPlayers) do
            if name:lower() == playerName:lower() then
                return
            end
        end

        table.insert(_G.whitelistedPlayers, playerName)
        print(playerName .. " añadido a Whitelist")
    end
end)

local function getPlayerDisplayText(p)
    if not p then
        return ""
    end

    return p.DisplayName .. " | " .. p.Name
end

local function RefreshWhitelistDropdown()
    pcall(function()
        for _, p in ipairs(game.Players:GetPlayers()) do
            if p ~= player then
                whitelistDropdown:Add(getPlayerDisplayText(p))
            end
        end
    end)
end

RefreshWhitelistDropdown()

game.Players.PlayerAdded:Connect(function(p)
    task.wait(1)

    if p ~= player then
        whitelistDropdown:Add(getPlayerDisplayText(p))
    end
end)

farmingTab:AddButton("Remove Selected Whitelist", function()
    if not selectedWhitelist then
        warn("No hay ningún jugador seleccionado.")
        return
    end

    for i = #_G.whitelistedPlayers, 1, -1 do
        if _G.whitelistedPlayers[i]:lower() == selectedWhitelist:lower() then
            table.remove(_G.whitelistedPlayers, i)
            print(selectedWhitelist .. " eliminado de Whitelist")
            selectedWhitelist = nil
            return
        end
    end

    warn(selectedWhitelist .. " no está en la Whitelist.")
end)

-- [[ UI Elements Setup ]]

farmingTab:AddSwitch("Loop TP Auto Kill All", function(Value)
    LoopKillAllActive = Value
    if Value then
        task.spawn(function()
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            
            while LoopKillAllActive do
                local myChar = player.Character
                local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
                local myHumanoid = myChar and myChar:FindFirstChildOfClass("Humanoid")

                if myChar and myRoot and myHumanoid then
                    local targetList = game.Players:GetPlayers()
                    
                    for _, targetPlayer in ipairs(targetList) do
                        if not LoopKillAllActive then break end
                        
                        if targetPlayer ~= player and targetPlayer.Character and not isWhitelisted(targetPlayer) then
                            local tRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                            local timeSpent = 0
                            
                            while LoopKillAllActive and tRoot and targetPlayer.Parent == game.Players and timeSpent < 2 do
                                myChar = player.Character
                                myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
                                myHumanoid = myChar and myChar:FindFirstChildOfClass("Humanoid")
                                
                                if not (myChar and myRoot and myHumanoid) then break end
                                
                                myRoot.CFrame = tRoot.CFrame * CFrame.new(0, 0, 3)
                                
                                local tool = myChar:FindFirstChild("Punch")
                                if not tool then
                                    local backpack = player:FindFirstChild("Backpack")
                                    local bpTool = backpack and backpack:FindFirstChild("Punch")
                                    if bpTool then
                                        myHumanoid:EquipTool(bpTool)
                                        tool = bpTool
                                    end
                                end
                                
                                if tool then
                                    tool:Activate()
                                end
                                
                                local remotes = ReplicatedStorage:FindFirstChild("RemotesEvent")
                                if remotes and remotes:FindFirstChild("SizeChanged") then
                                    remotes.SizeChanged:FireServer(1)
                                end
                                
                                task.wait(0.05)
                                timeSpent = timeSpent + 0.05
                            end
                        end
                    end
                end
                task.wait(0.1) 
            end
        end)
    end
end)

farmingTab:AddSwitch("Loop TP Auto Kill All V2", function(Value)
    FastLoopKillAllV2Active = Value
    if Value then
        task.spawn(function()
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            
            while FastLoopKillAllV2Active do
                local myChar = player.Character
                local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
                local myHumanoid = myChar and myChar:FindFirstChildOfClass("Humanoid")

                if myChar and myRoot and myHumanoid then
                    local targetList = game.Players:GetPlayers()
                    
                    for _, targetPlayer in ipairs(targetList) do
                        if not FastLoopKillAllV2Active then break end
                        
                        if targetPlayer ~= player and targetPlayer.Character and not isWhitelisted(targetPlayer) then
                            local tRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                            local tHumanoid = targetPlayer.Character:FindFirstChild("Humanoid")
                            
                            if tRoot and tHumanoid and tHumanoid.Health > 0 then
                                for _ = 1, 3 do
                                    if not FastLoopKillAllV2Active or tHumanoid.Health <= 0 then break end
                                    
                                    myRoot.CFrame = tRoot.CFrame * CFrame.new(0, 0, 3)
                                    
                                    local tool = myChar:FindFirstChild("Punch")
                                    if not tool then
                                        local backpack = player:FindFirstChild("Backpack")
                                        local bpTool = backpack and backpack:FindFirstChild("Punch")
                                        if bpTool then
                                            myHumanoid:EquipTool(bpTool)
                                            tool = bpTool
                                        end
                                    end
                                    
                                    if tool then
                                        tool:Activate()
                                    end
                                    
                                    local remotes = ReplicatedStorage:FindFirstChild("RemotesEvent")
                                    if remotes and remotes:FindFirstChild("SizeChanged") then
                                        pcall(function()
                                            remotes.SizeChanged:FireServer(1)
                                        end)
                                    end
                                    
                                    task.wait(2)
                                end
                            end
                        end
                    end
                end
                task.wait(0.05)
            end
        end)
    end
end)

farmingTab:AddLabel("Target killer:").TextSize = 23

-- [[ SINGLE TARGET DROPDOWN ]]
local singleTargetDropdown = farmingTab:AddDropdown("Target Player", function(text)
    TargetInput = text
end)

-- Function to refresh options for dropdowns dynamically (Display Name only)
local function RefreshDropdowns()
    pcall(function()
        for _, p in ipairs(game.Players:GetPlayers()) do
            if p ~= player then
                singleTargetDropdown:Add(p.DisplayName)
            end
        end
    end)
end

RefreshDropdowns()

game.Players.PlayerAdded:Connect(function(p)
    task.wait(1)
    if p ~= player then
        singleTargetDropdown:Add(p.DisplayName)
    end
end)

farmingTab:AddSwitch("TP Kill Target", function(state)
    LoopKilling = state
    if LoopKilling then
        task.spawn(function()
            while LoopKilling do
                local target = GetPlayerByInput(TargetInput)
                
                if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and 
                    player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    
                    player.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                    
                    local tool = player.Character:FindFirstChild("Punch")
                    if not tool then
                        local backpackTool = player:FindFirstChild("Backpack") and player.Backpack:FindFirstChild("Punch")
                        if backpackTool then
                            player.Character.Humanoid:EquipTool(backpackTool)
                            tool = backpackTool
                        end
                    end
                    
                    if tool then
                        tool:Activate() 
                    end
                end
                task.wait(0.5) 
            end
        end)
    end
end)

farmingTab:AddSwitch("Spy Target", function(state)
    Spectating = state
    local camera = workspace.CurrentCamera
    
    if state then
        task.spawn(function()
            while Spectating do
                local target = GetPlayerByInput(TargetInput)
                if target and target.Character and target.Character:FindFirstChild("Humanoid") then
                    camera.CameraSubject = target.Character.Humanoid
                else
                    if player.Character and player.Character:FindFirstChild("Humanoid") then
                        camera.CameraSubject = player.Character.Humanoid
                    end
                end
                task.wait(0.1)
            end
        end)
    else
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            camera.CameraSubject = player.Character.Humanoid
        end
    end
end)

local AutoServerHop = false
local AutoServerHopRunning = false
local SERVER_HOP_TIME = 120

local function serverHop()
    local HttpService = game:GetService("HttpService")
    local TeleportService = game:GetService("TeleportService")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    local placeId = game.PlaceId
    local serversUrl =
        "https://games.roblox.com/v1/games/" ..
        placeId ..
        "/servers/Public?sortOrder=Asc&limit=100"

    local success, result = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(serversUrl))
    end)

    if not success or not result or not result.data then
        warn("No se pudo obtener la lista de servidores.")
        return false
    end

    for _, server in ipairs(result.data) do
        if server.id ~= game.JobId
            and server.playing < server.maxPlayers then

            local ok = pcall(function()
                TeleportService:TeleportToPlaceInstance(
                    placeId,
                    server.id,
                    LocalPlayer
                )
            end)

            if ok then
                return true
            end
        end
    end

    warn("No se encontró otro servidor disponible.")
    return false
end

local function queueCurrentScript()
    local scriptCode = [[
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ALPHAneegy/MuscleLegendsKiller/refs/heads/main/killer.lua"))()
    ]]

    if typeof(queue_on_teleport) == "function" then
        queue_on_teleport(scriptCode)
        return true
    end

    if syn and typeof(syn.queue_on_teleport) == "function" then
        syn.queue_on_teleport(scriptCode)
        return true
    end

    warn("Este executor no tiene queue_on_teleport.")
    return false
end

local function startAutoServerHop()
    if AutoServerHopRunning then
        return
    end

    AutoServerHopRunning = true

    task.spawn(function()
        while AutoServerHop do
            task.wait(SERVER_HOP_TIME)

            if not AutoServerHop then
                break
            end

            -- Deja preparado el script para el siguiente servidor
            queueCurrentScript()

            -- Cambia de servidor
            local success = serverHop()

            if success then
                -- El servidor actual cambiará y el script se volverá a cargar
                break
            end

            -- Si falló, vuelve a intentarlo después de otros 120 segundos
        end

        AutoServerHopRunning = false
    end)
end

farmingTab:AddSwitch("Auto Server Hop - 2 Minutes", function(state)
    AutoServerHop = state

    if state then
        print("Auto Server Hop activado: 2 minutos")
        startAutoServerHop()
    else
        print("Auto Server Hop desactivado")
    end
end)

local Tab = window:AddTab("Misc") -- Name of tab

local misc = Tab:AddFolder("Misc")

-- 4. Server Hop Function Definition
local function serverHop()
    local HttpService = game:GetService("HttpService")
    local TeleportService = game:GetService("TeleportService")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    
    local placeId = game.PlaceId
    local serversUrl = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100"
    
    local success, result = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(serversUrl))
    end)
    
    if success and result and result.data then
        for _, server in ipairs(result.data) do
            -- Ensure the server has room and isn't the one you are currently in
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                pcall(function()
                    TeleportService:TeleportToPlaceInstance(placeId, server.id, LocalPlayer)
                end)
                return -- Stop executing once teleport is initiated
            end
        end
        print("❌ No alternative public servers found.")
    else
        warn("⚠️ Failed to fetch server list. Retrying native teleport...")
        -- Fallback: basic teleport if API lookup is blocked or rate-limited
        pcall(function()
            TeleportService:Teleport(placeId, LocalPlayer)
        end)
    end
end

-- 5. Add the Server Hop Button to Elerium
misc:AddButton("Server Hop", function()
    print("🔄 Initializing Server Hop...")
    serverHop()
end)

-- 4. Rejoin Function Definition
local function rejoinServer()
    local TeleportService = game:GetService("TeleportService")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    
    local placeId = game.PlaceId
    local jobId = game.JobId

    -- If there's only 1 player in the server, a standard Teleport works best as a fallback
    if #Players:GetPlayers() <= 1 then
        pcall(function()
            TeleportService:Teleport(placeId, LocalPlayer)
        end)
    else
        -- Force a teleport directly back into the current active server instance
        pcall(function()
            TeleportService:TeleportToPlaceInstance(placeId, jobId, LocalPlayer)
        end)
    end
end

-- 5. Add the Rejoin Button to Elerium
misc:AddButton("Rejoin Server", function()
    print("🔄 Reconnecting to current server...")
    rejoinServer()
end)

local mainTab = Tab:AddFolder("Misc V2")

local function mk(n, c)
    local g = Instance.new("ScreenGui", game:GetService("Players").LocalPlayer.PlayerGui)
    g.Name, g.ResetOnSpawn, g.DisplayOrder, g.IgnoreGuiInset = n, false, 9999999, true
    local f = Instance.new("Frame", g)
    f.Size, f.BackgroundColor3, f.BorderSizePixel, f.Visible = UDim2.new(1,0,1,0), c, 0, false
    return f
end

local bF, wF = mk("B", Color3.new(0,0,0)), mk("W", Color3.new(1,1,1))
mainTab:AddSwitch("Black Screen", function(s) bF.Visible = s end)
mainTab:AddSwitch("White Screen", function(s) wF.Visible = s end)

local fb, orig = false, {game:GetService("Lighting").Ambient, game:GetService("Lighting").OutdoorAmbient, game:GetService("Lighting").Brightness, game:GetService("Lighting").ClockTime, game:GetService("Lighting").GlobalShadows}
task.spawn(function()
    while task.wait(0.5) do
        if fb then game:GetService("Lighting").Ambient, game:GetService("Lighting").OutdoorAmbient, game:GetService("Lighting").Brightness, game:GetService("Lighting").ClockTime, game:GetService("Lighting").GlobalShadows = Color3.new(1,1,1), Color3.new(1,1,1), 2, 14, false end
    end
end)
mainTab:AddSwitch("Fullbright", function(s)
    fb = s
    if not s then game:GetService("Lighting").Ambient, game:GetService("Lighting").OutdoorAmbient, game:GetService("Lighting").Brightness, game:GetService("Lighting").ClockTime, game:GetService("Lighting").GlobalShadows = unpack(orig) end
end)

local be, ne, he, c = false, false, false, {}

local function esp(p)
    if c[p] or p == game:GetService("Players").LocalPlayer then return end
    local hl = Instance.new("Highlight")
    hl.FillColor, hl.FillTransparency, hl.OutlineColor = Color3.new(1,0,0), 0.5, Color3.new(1,1,1)
    
    local nt = Instance.new("BillboardGui")
    nt.Size, nt.AlwaysOnTop, nt.ExtentsOffset = UDim2.new(0,200,0,50), true, Vector3.new(0,3,0)
    local tx = Instance.new("TextLabel", nt)
    tx.Size, tx.BackgroundTransparency, tx.Text, tx.TextColor3, tx.TextSize, tx.Font, tx.TextStrokeTransparency = UDim2.new(1,0,1,0), 1, p.Name, Color3.new(1,1,1), 14, Enum.Font.SourceSansBold, 0

    local hb = Instance.new("BillboardGui")
    hb.Size, hb.AlwaysOnTop, hb.ExtentsOffset = UDim2.new(0,5,0,45), true, Vector3.new(-2.2,0.5,0)
    local bg = Instance.new("Frame", hb)
    bg.Size, bg.BackgroundColor3, bg.BorderSizePixel = UDim2.new(1,0,1,0), Color3.fromRGB(40,40,40), 0
    local hm = Instance.new("Frame", bg)
    hm.Size, hm.Position, hm.AnchorPoint, hm.BackgroundColor3, hm.BorderSizePixel = UDim2.new(1,0,1,0), UDim2.new(0,0,1,0), Vector2.new(0,1), Color3.fromRGB(0,255,0), 0

    c[p] = {H = hl, N = nt, B = hb, M = hm}

    local function up()
        local ch = p.Character
        local hd, hu = ch and ch:WaitForChild("Head", 5), ch and ch:WaitForChild("Humanoid", 5)
        if ch and hd and hu then
            hl.Parent, hl.Enabled = ch, be
            nt.Adornee, nt.Parent, nt.Enabled = hd, hd, ne
            hb.Adornee, hb.Parent, hb.Enabled = hd, hd, he
            if c[p].Cn then c[p].Cn:Disconnect() end
            c[p].Cn = hu:GetPropertyChangedSignal("Health"):Connect(function()
                local pct = math.clamp(hu.Health / hu.MaxHealth, 0, 1)
                hm.Size = UDim2.new(1, 0, pct, 0)
                hm.BackgroundColor3 = Color3.fromHSV(pct * 0.35, 1, 1)
            end)
        end
    end
    p.CharacterAdded:Connect(function() task.wait(0.5) up() end)
    up()
end

for _, p in ipairs(game:GetService("Players"):GetPlayers()) do esp(p) end
game:GetService("Players").PlayerAdded:Connect(esp)
game:GetService("Players").PlayerRemoving:Connect(function(p)
    if c[p] then
        for _, v in pairs(c[p]) do if typeof(v) == "Instance" then v:Destroy() elseif typeof(v) == "RBXScriptConnection" then v:Disconnect() end end
        c[p] = nil
    end
end)

mainTab:AddSwitch("Box ESP", function(s) be = s for _, d in pairs(c) do if d.H then d.H.Enabled = s end end end)
mainTab:AddSwitch("Player Name ESP", function(s) ne = s for _, d in pairs(c) do if d.N then d.N.Enabled = s end end end)
mainTab:AddSwitch("Health Bar ESP", function(s) he = s for _, d in pairs(c) do if d.B then d.B.Enabled = s end end end)
	
local fps1 = Tab:AddFolder("Misc V3")

	fps1:AddButton('Remove Textures', function()
		local v1194, v1195, v1196 = pairs(game:GetDescendants())
		while true do
			local v1197
			v1196, v1197 = v1194(v1195, v1196)
			if v1196 == nil then
				break
			end
			if v1197:IsA('Decal') or v1197:IsA('Texture') then
				v1197.Transparency = 1
			end
		end
		game:GetService('StarterGui'):SetCore('SendNotification', {
			Title = 'Performance',
			Text = 'Textures removed!',
			Duration = 5,
		})
	end)
	fps1:AddButton('Reduce Graphics', function()
		settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
		game:GetService('StarterGui'):SetCore('SendNotification', {
			Title = 'Performance',
			Text = 'Graphics reduced!',
			Duration = 5,
		})
	end)
	fps1:AddButton('Disable Shadows', function()
		game:GetService('Lighting').GlobalShadows = false
		game:GetService('StarterGui'):SetCore('SendNotification', {
			Title = 'Performance',
			Text = 'Shadows disabled!',
			Duration = 5,
		})
	end)
	fps1:AddButton('Disable Effects', function()
		local v1198, v1199, v1200 = pairs(game:GetDescendants())
		while true do
			local v1201
			v1200, v1201 = v1198(v1199, v1200)
			if v1200 == nil then
				break
			end
			if v1201:IsA('ParticleEmitter') or (v1201:IsA('Smoke') or (v1201:IsA('Fire') or v1201:IsA('Sparkles'))) then
				v1201.Enabled = false
			end
		end
		local _Lighting2 = game:GetService('Lighting')
		local v1203, v1204, v1205 = pairs(_Lighting2:GetChildren())
		while true do
			local v1206
			v1205, v1206 = v1203(v1204, v1205)
			if v1205 == nil then
				break
			end
			if v1206:IsA('BlurEffect') or (v1206:IsA('SunRaysEffect') or (v1206:IsA('ColorCorrectionEffect') or (v1206:IsA('BloomEffect') or v1206:IsA('DepthOfFieldEffect')))) then
				v1206.Enabled = false
			end
		end
		game:GetService('StarterGui'):SetCore('SendNotification', {
			Title = 'Performance',
			Text = 'Effects disabled!',
			Duration = 5,
		})
	end)
	fps1:AddButton('Simplify Materials', function()
		local v1207, v1208, v1209 = pairs(game:GetDescendants())
		while true do
			local v1210
			v1209, v1210 = v1207(v1208, v1209)
			if v1209 == nil then
				break
			end
			if v1210:IsA('BasePart') and not v1210:IsA('MeshPart') then
				v1210.Material = Enum.Material.SmoothPlastic
				if not (v1210.Parent and (v1210.Parent:FindFirstChild('Humanoid') or v1210.Parent.Parent:FindFirstChild('Humanoid'))) then
					v1210.Reflectance = 0
				end
			end
		end
		game:GetService('StarterGui'):SetCore('SendNotification', {
			Title = 'Performance',
			Text = 'Materials simplified!',
			Duration = 5,
		})
	end)
fps1:AddButton('Remove Fog', function()
		game:GetService('Lighting').FogEnd = 10000000000
		game:GetService('StarterGui'):SetCore('SendNotification', {
			Title = 'Performance',
			Text = 'Fog removed!',
			Duration = 5,
		})
	end)
	fps1:AddButton('Anti Lag (Advanced)', function()
		local v1211, v1212, v1213 = pairs(game:GetDescendants())
		while true do
			local v1214
			v1213, v1214 = v1211(v1212, v1213)
			if v1213 == nil then
				break
			end
			if v1214:IsA('Decal') or v1214:IsA('Texture') then
				v1214:Destroy()
			end
		end
		local _Terrain = workspace:FindFirstChildOfClass('Terrain')
		if _Terrain then
			_Terrain.WaterWaveSize = 0
			_Terrain.WaterWaveSpeed = 0
			_Terrain.WaterReflectance = 0
			_Terrain.WaterTransparency = 1
			_Terrain.Decorations = false
		end
		local v1216, v1217, v1218 = pairs(workspace:GetDescendants())
		while true do
			local v1219
			v1218, v1219 = v1216(v1217, v1218)
			if v1218 == nil then
				break
			end
			if v1219:IsA('Explosion') or v1219:IsA('Debris') then
				v1219:Destroy()
			elseif v1219:IsA('BasePart') and v1219.Name:lower():find('debris') then
				v1219:Destroy()
			end
		end
		local v1220, v1221, v1222 = pairs(game:GetDescendants())
		while true do
			local v1223
			v1222, v1223 = v1220(v1221, v1222)
			if v1222 == nil then
				break
			end
			if v1223:IsA('PointLight') or (v1223:IsA('SurfaceLight') or v1223:IsA('SpotLight')) then
				v1223.Enabled = false
			end
		end
		local v1224, v1225, v1226 = pairs(workspace:GetDescendants())
		while true do
			local v1227
			v1226, v1227 = v1224(v1225, v1226)
			if v1226 == nil then
				break
			end
			if v1227:IsA('Sound') then
				v1227:Stop()
			end
		end
		print('Anti-Lag Activated: Textures, lighting, sounds, and effects removed.')
	end)
	fps1:AddButton('Ultra FPS Booster', function()
		settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
		settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01
		settings().Rendering.EagerBulkExecution = true
		settings().Rendering.ReloadAssets = false
		local _Lighting3 = game:GetService('Lighting')
		_Lighting3.GlobalShadows = false
		_Lighting3.FogEnd = 10000000000
		_Lighting3.Brightness = 0
		_Lighting3.EnvironmentDiffuseScale = 0
		_Lighting3.EnvironmentSpecularScale = 0
		local v1229, v1230, v1231 = ipairs(game:GetDescendants())
		while true do
			local v1232
			v1231, v1232 = v1229(v1230, v1231)
			if v1231 == nil then
				break
			end
			if v1232:IsA('ParticleEmitter') or (v1232:IsA('Trail') or (v1232:IsA('Smoke') or (v1232:IsA('Fire') or v1232:IsA('Sparkles')))) then
				v1232:Destroy()
			elseif v1232:IsA('PointLight') or (v1232:IsA('SpotLight') or v1232:IsA('SurfaceLight')) then
				v1232.Enabled = false
			end
		end
		local v1233, v1234, v1235 = pairs(game:GetDescendants())
		while true do
			local v1236
			v1235, v1236 = v1233(v1234, v1235)
			if v1235 == nil then
				break
			end
			if v1236:IsA('Sound') then
				v1236:Stop()
				v1236.Volume = 0
			end
		end
		local v1237, v1238, v1239 = ipairs(game:GetDescendants())
		while true do
			local v1240
			v1239, v1240 = v1237(v1238, v1239)
			if v1239 == nil then
				break
			end
			if v1240:IsA('Decal') or v1240:IsA('Texture') then
				v1240:Destroy()
			end
		end
		local _Terrain2 = workspace:FindFirstChildOfClass('Terrain')
		if _Terrain2 then
			_Terrain2.WaterWaveSize = 0
			_Terrain2.WaterWaveSpeed = 0
			_Terrain2.WaterReflectance = 0
			_Terrain2.WaterTransparency = 1
			_Terrain2.Decorations = false
		end
		local _LocalPlayer60 = game.Players.LocalPlayer
		local _PlayerGui3 = _LocalPlayer60:FindFirstChild('PlayerGui')
		if _PlayerGui3 then
			local v1244, v1245, v1246 = ipairs(_PlayerGui3:GetDescendants())
			while true do
				local v1247
				v1246, v1247 = v1244(v1245, v1246)
				if v1246 == nil then
					break
				end
				if v1247:IsA('TextLabel') or (v1247:IsA('ImageLabel') or v1247:IsA('ImageButton')) then
					v1247.Visible = false
				end
			end
		end
		local v1248, v1249, v1250 = ipairs(_LocalPlayer60.Character:GetChildren())
		while true do
			local v1251
			v1250, v1251 = v1248(v1249, v1250)
			if v1250 == nil then
				break
			end
			if v1251:IsA('Accessory') or v1251:IsA('Clothing') then
				v1251:Destroy()
			end
		end
		local _Humanoid8 = _LocalPlayer60.Character:FindFirstChildWhichIsA('Humanoid')
		if _Humanoid8 then
			local v1253, v1254, v1255 = pairs(_Humanoid8:GetPlayingAnimationTracks())
			while true do
				local v1256
				v1255, v1256 = v1253(v1254, v1255)
				if v1255 == nil then
					break
				end
				v1256:Stop()
			end
		end
		print('Ultra FPS Boost applied. Maximum rendering and resource optimization complete.')
	end)
	fps1:AddButton('Full Optimization', function()
		local v1257, v1258, v1259 = pairs(game:GetDescendants())
		while true do
			local v1260
			v1259, v1260 = v1257(v1258, v1259)
			if v1259 == nil then
				break
			end
			if v1260:IsA('ParticleEmitter') or (v1260:IsA('Smoke') or (v1260:IsA('Fire') or v1260:IsA('Sparkles'))) then
				v1260.Enabled = false
			end
		end
		local _Lighting4 = game:GetService('Lighting')
		_Lighting4.GlobalShadows = false
		_Lighting4.FogEnd = 9000000000
		_Lighting4.Brightness = 0
		settings().Rendering.QualityLevel = 1
		local v1262, v1263, v1264 = pairs(game:GetDescendants())
		while true do
			local v1265
			v1264, v1265 = v1262(v1263, v1264)
			if v1264 == nil then
				break
			end
			if v1265:IsA('Decal') or v1265:IsA('Texture') then
				v1265.Transparency = 1
			elseif v1265:IsA('BasePart') and not v1265:IsA('MeshPart') then
				v1265.Material = Enum.Material.SmoothPlastic
				if not (v1265.Parent and (v1265.Parent:FindFirstChild('Humanoid') or v1265.Parent.Parent:FindFirstChild('Humanoid'))) then
					v1265.Reflectance = 0
				end
			end
		end
		local v1266, v1267, v1268 = pairs(_Lighting4:GetChildren())
		while true do
			local v1269
			v1268, v1269 = v1266(v1267, v1268)
			if v1268 == nil then
				break
			end
			if v1269:IsA('BlurEffect') or (v1269:IsA('SunRaysEffect') or (v1269:IsA('ColorCorrectionEffect') or (v1269:IsA('BloomEffect') or v1269:IsA('DepthOfFieldEffect')))) then
				v1269.Enabled = false
			end
		end
		game:GetService('StarterGui'):SetCore('SendNotification', {
			Title = 'Optimization',
			Text = 'Full optimization applied!',
			Duration = 5,
		})
	end)

    local infoTab = window:AddTab("Info")
infoTab:Show()
local wLabel = infoTab:AddLabel("Version: Beta")
wLabel.TextSize = 30
wLabel.Font = Enum.Font.Arcade
infoTab:AddLabel("")
infoTab:AddLabel("Made by none").TextSize = 25
