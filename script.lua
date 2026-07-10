-- ==========================================
-- ĐẠT TẬP LÀM CODE - PREMIUM HUB V2
-- ==========================================

-- [ ANTI-KICK / FAKE ANTI-BAN ] --
pcall(function()
    local mt = getrawmetatable(game)
    local oldNamecall = mt.__namecall
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if not checkcaller() and self == game:GetService("Players").LocalPlayer and (method == "Kick" or method == "kick") then
            return nil
        end
        return oldNamecall(self, ...)
    end)
    setreadonly(mt, true)
end)

-- [ SERVICES & VARIABLES ] --
local p = game:GetService("Players").LocalPlayer
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")
local vu = game:GetService("VirtualUser")
local cam = workspace.CurrentCamera

local toggles = {
    AntiAFK = false, Fly = false, Noclip = false, 
    Speed = false, Jump = false, ESP = false, Aimbot = false
}

local values = { Fly = 50, Speed = 30, Jump = 50 }
local keys = { Fly = "F", Noclip = "N", Speed = "Z", Jump = "X", ESP = "E", Aimbot = "C" }
local bv

-- [ GUI SETUP ] --
local g = Instance.new("ScreenGui")
g.Name = tostring(math.random(10000, 99999)) -- Tên ngẫu nhiên chống phát hiện
g.Parent = game:GetService("CoreGui")
g.ResetOnSpawn = false

local main = Instance.new("Frame", g)
main.Size = UDim2.new(0, 420, 0, 500)
main.Position = UDim2.new(0.5, -210, 0.5, -250)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
title.Text = " 🚀 Đạt Tập Làm Code V2"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 20
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 10)

local closeBtn = Instance.new("TextButton", main)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)

local miniBtn = Instance.new("TextButton", main)
miniBtn.Size = UDim2.new(0, 30, 0, 30)
miniBtn.Position = UDim2.new(1, -70, 0, 5)
miniBtn.Text = "-"
miniBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
miniBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
miniBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", miniBtn).CornerRadius = UDim.new(0, 8)

local scroll = Instance.new("ScrollingFrame", main)
scroll.Size = UDim2.new(1, -20, 1, -60)
scroll.Position = UDim2.new(0, 10, 0, 50)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 4
scroll.CanvasSize = UDim2.new(0, 0, 0, 500)

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 10)
layout.SortOrder = Enum.SortOrder.LayoutOrder

local miniIcon = Instance.new("TextButton", g)
miniIcon.Size = UDim2.new(0, 50, 0, 50)
miniIcon.Position = UDim2.new(0, 20, 0.5, -25)
miniIcon.Text = "Đ"
miniIcon.TextSize = 25
miniIcon.Font = Enum.Font.GothamBold
miniIcon.Visible = false
miniIcon.Active = true
miniIcon.Draggable = true
miniIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", miniIcon).CornerRadius = UDim.new(1, 0)

-- RGB Mini Icon
task.spawn(function()
    while task.wait(0.05) do
        miniIcon.BackgroundColor3 = Color3.fromHSV(tick() % 5 / 5, 1, 1)
    end
end)

-- [ GUI FUNCTIONS ] --
closeBtn.MouseButton1Click:Connect(function() g:Destroy() end)
miniBtn.MouseButton1Click:Connect(function() main.Visible = false; miniIcon.Visible = true end)
miniIcon.MouseButton1Click:Connect(function() main.Visible = true; miniIcon.Visible = false end)

local function getChar() return p.Character or p.CharacterAdded:Wait() end

-- [ MODULE CREATOR ] --
local function createModule(name, hasValue, defaultVal, defaultKey)
    local frame = Instance.new("Frame", scroll)
    frame.Size = UDim2.new(1, -10, 0, 45)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0.4, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = " " .. name .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(255, 100, 100)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.TextXAlignment = Enum.TextXAlignment.Left

    local valBox, keyBox

    if hasValue then
        valBox = Instance.new("TextBox", frame)
        valBox.Size = UDim2.new(0.25, 0, 0.7, 0)
        valBox.Position = UDim2.new(0.45, 0, 0.15, 0)
        valBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        valBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        valBox.Text = tostring(defaultVal)
        valBox.Font = Enum.Font.Gotham
        valBox.PlaceholderText = "Value"
        Instance.new("UICorner", valBox).CornerRadius = UDim.new(0, 5)
    end

    if defaultKey then
        keyBox = Instance.new("TextBox", frame)
        keyBox.Size = UDim2.new(0.2, 0, 0.7, 0)
        keyBox.Position = UDim2.new(0.75, 0, 0.15, 0)
        keyBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        keyBox.TextColor3 = Color3.fromRGB(255, 210, 0)
        keyBox.Text = defaultKey
        keyBox.Font = Enum.Font.GothamBold
        keyBox.PlaceholderText = "Key"
        Instance.new("UICorner", keyBox).CornerRadius = UDim.new(0, 5)
    end

    return btn, valBox, keyBox
end

-- [ CREATE UI ELEMENTS ] --
local btnAFK = createModule("Anti-AFK", false, nil, nil)
local btnFly, valFly, keyFly = createModule("Fly", true, values.Fly, keys.Fly)
local btnSpeed, valSpeed, keySpeed = createModule("Speed", true, values.Speed, keys.Speed)
local btnJump, valJump, keyJump = createModule("Jump", true, values.Jump, keys.Jump)
local btnNoclip, _, keyNoclip = createModule("Noclip", false, nil, keys.Noclip)
local btnESP, _, keyESP = createModule("ESP", false, nil, keys.ESP)
local btnAimbot, _, keyAimbot = createModule("Aimbot", false, nil, keys.Aimbot)

-- [ FEATURE LOGIC ] --
local function toggleButton(btn, state, name)
    btn.Text = " " .. name .. ": " .. (state and "ON" or "OFF")
    btn.TextColor3 = state and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
end

-- Anti AFK
btnAFK.MouseButton1Click:Connect(function()
    toggles.AntiAFK = not toggles.AntiAFK
    toggleButton(btnAFK, toggles.AntiAFK, "Anti-AFK")
end)
p.Idled:Connect(function()
    if toggles.AntiAFK then
        vu:CaptureController()
        vu:ClickButton2(Vector2.new())
    end
end)

-- Fly
local function toggleFly()
    toggles.Fly = not toggles.Fly
    toggleButton(btnFly, toggles.Fly, "Fly")
    local hrp = getChar():FindFirstChild("HumanoidRootPart")
    if toggles.Fly and hrp then
        bv = Instance.new("BodyVelocity", hrp)
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bv.Velocity = Vector3.zero
    elseif bv then
        bv:Destroy()
        bv = nil
    end
end
btnFly.MouseButton1Click:Connect(toggleFly)

-- Speed
local function toggleSpeed()
    toggles.Speed = not toggles.Speed
    toggleButton(btnSpeed, toggles.Speed, "Speed")
    local hum = getChar():FindFirstChild("Humanoid")
    if hum and not toggles.Speed then hum.WalkSpeed = 16 end
end
btnSpeed.MouseButton1Click:Connect(toggleSpeed)

-- Jump
local function toggleJump()
    toggles.Jump = not toggles.Jump
    toggleButton(btnJump, toggles.Jump, "Jump")
    local hum = getChar():FindFirstChild("Humanoid")
    if hum and not toggles.Jump then hum.JumpPower = 50 end
end
btnJump.MouseButton1Click:Connect(toggleJump)

-- Noclip
local function toggleNoclip()
    toggles.Noclip = not toggles.Noclip
    toggleButton(btnNoclip, toggles.Noclip, "Noclip")
end
btnNoclip.MouseButton1Click:Connect(toggleNoclip)

-- ESP
local function toggleESP()
    toggles.ESP = not toggles.ESP
    toggleButton(btnESP, toggles.ESP, "ESP")
    if not toggles.ESP then
        for _, v in pairs(game.Workspace:GetDescendants()) do
            if v:IsA("Highlight") and v.Name == "ĐạtESP" then v:Destroy() end
        end
    end
end
btnESP.MouseButton1Click:Connect(toggleESP)

-- Aimbot
local function toggleAimbot()
    toggles.Aimbot = not toggles.Aimbot
    toggleButton(btnAimbot, toggles.Aimbot, "Aimbot")
end
btnAimbot.MouseButton1Click:Connect(toggleAimbot)

local function getClosestPlayerToMouse()
    local closest, shortest = nil, math.huge
    local mouse = p:GetMouse()
    for _, v in pairs(game:GetService("Players"):GetPlayers()) do
        if v ~= p and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid").Health > 0 then
            local pos, onScreen = cam:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
            if onScreen then
                local dist = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(pos.X, pos.Y)).Magnitude
                if dist < shortest then closest = v; shortest = dist end
            end
        end
    end
    return closest
end

-- [ MAIN LOOPS ] --
rs.RenderStepped:Connect(function()
    local char = p.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")

    -- Fly Loop
    if toggles.Fly and bv and hrp then
        values.Fly = tonumber(valFly.Text) or 50
        local move = Vector3.zero
        if uis:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
        if uis:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
        if uis:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
        if uis:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end
        bv.Velocity = move.Magnitude > 0 and move.Unit * values.Fly or Vector3.zero
    end

    -- Speed & Jump Loop
    if hum then
        if toggles.Speed then 
            hum.WalkSpeed = tonumber(valSpeed.Text) or 30 
        end
        if toggles.Jump then 
            hum.UseJumpPower = true
            hum.JumpPower = tonumber(valJump.Text) or 50 
        end
    end

    -- Aimbot Loop
    if toggles.Aimbot and uis:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = getClosestPlayerToMouse()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            cam.CFrame = CFrame.new(cam.CFrame.Position, target.Character.Head.Position)
        end
    end
end)

rs.Stepped:Connect(function()
    -- Noclip Loop
    if toggles.Noclip and p.Character then
        for _, v in pairs(p.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end

    -- ESP Loop
    if toggles.ESP then
        for _, v in pairs(game:GetService("Players"):GetPlayers()) do
            if v ~= p and v.Character and not v.Character:FindFirstChild("ĐạtESP") then
                local hl = Instance.new("Highlight", v.Character)
                hl.Name = "ĐạtESP"
                hl.FillColor = Color3.fromRGB(255, 0, 0)
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
            end
        end
    end
end)

-- [ KEYBINDS HANDLER ] --
uis.InputBegan:Connect(function(input, gp)
    if gp then return end
    local key = input.KeyCode.Name

    if keyFly and key == string.upper(keyFly.Text) then toggleFly() end
    if keySpeed and key == string.upper(keySpeed.Text) then toggleSpeed() end
    if keyJump and key == string.upper(keyJump.Text) then toggleJump() end
    if keyNoclip and key == string.upper(keyNoclip.Text) then toggleNoclip() end
    if keyESP and key == string.upper(keyESP.Text) then toggleESP() end
    if keyAimbot and key == string.upper(keyAimbot.Text) then toggleAimbot() end
end)
