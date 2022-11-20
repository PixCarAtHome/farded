local runService = game:GetService("RunService")
local plr = game.Players.LocalPlayer
local char = plr.Character
local websocketfunc = syn and syn.websocket and syn.websocket.connect or Krnl and Krnl.WebSocket.connect or WebSocket and WebSocket.connect or websocket and websocket.connect
local suc, web
if syn and syn.toast_notification then 
    suc, web = pcall(function() 
        local socket = WebsocketClient.new("ws://127.0.0.1:6892/")
        socket:Connect()
        return socket 
    end)
else
    suc, web = pcall(function() return websocketfunc("ws://127.0.0.1:6892/") end)
end
repeat 
    task.wait(1)
    if not suc or suc and type(web) == "boolean" then
        if syn and syn.toast_notification then 
            suc, web = pcall(function() 
                local socket = WebsocketClient.new("ws://127.0.0.1:6892/")
                socket:Connect()
                return socket 
            end)
        else
            suc, web = pcall(function() return websocketfunc("ws://127.0.0.1:6892/") end)
        end
        if not suc or suc and type(web) == "boolean" then
            print("websocket error:", web)
        end
    end
until suc and type(web) ~= "boolean"
local readsettings = Instance.new("BindableEvent")
local modules = {}
local modulefunctions = {}
local modulesenabled = {}
local players = game:GetService("Players")
local lplr = players.LocalPlayer
local uis = game:GetService("UserInputService")
local cam = workspace.CurrentCamera
local RenderStepTable = {}

local function BindToRenderStep(name, num, func)
	if RenderStepTable[name] == nil then
		RenderStepTable[name] = game:GetService("RunService").RenderStepped:connect(func)
	end
end
local function UnbindFromRenderStep(name)
	if RenderStepTable[name] then
		RenderStepTable[name]:Disconnect()
		RenderStepTable[name] = nil
	end
end

local function isAlive(plr)
	if plr then
		return plr and plr.Character and plr.Character.Parent ~= nil and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Head") and plr.Character:FindFirstChild("Humanoid")
	end
	return lplr and lplr.Character and lplr.Character.Parent ~= nil and lplr.Character:FindFirstChild("HumanoidRootPart") and lplr.Character:FindFirstChild("Head") and lplr.Character:FindFirstChild("Humanoid")
end

local function getplayersnear(range)
    if isAlive() then
        for i,v in pairs(players:GetChildren()) do 
            if v ~= lplr and v:GetAttribute("Team") ~= lplr:GetAttribute("Team") and isAlive(v) and (lplr.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).magnitude <= range then 
                return v
            end
        end
    end 
    return nil
end

local function sendrequest(tab)
    local newstr = game:GetService("HttpService"):JSONEncode(tab)
    if suc then
        web:Send(newstr)
    end
end

local function addModule(name, desc, func)
    local tab = {
        name = name,
        desc = desc,
        options = {}
    }
    table.insert(modules, tab)
    modulefunctions[name] = func
    modulesenabled[name] = false
    return {
        addToggle = function(name2, func2)
            table.insert(tab.options, {
                name = name2,
                type = "Toggle",
                toggled = false
            })
            modulefunctions[name..name2] = func2
        end,
        addSlider = function(name2, min, max, default, func2)
            table.insert(tab.options, {
                name = name2,
                type = "Slider",
                min = min,
                max = max,
                state = default
            })
            modulefunctions[name..name2] = func2
        end
    }
end 

local function makerandom(min, max)
	return Random.new().NextNumber(Random.new(), min, max)
end

local function findModule(name)
    for i,v in pairs(modules) do 
        if v.name == name then 
            return v
        end
    end
    return nil
end

local function findOption(name, name2)
    for i,v in pairs(modules) do 
        if v.name == name then 
            for i2,v2 in pairs(v.options) do 
                if v2.name == name2 then
                    return v2
                end
            end
        end
    end
    return nil
end
local uninjectfunc = lplr.OnTeleport:connect(function(state)
    shared.noinject = true
end)

if suc and type(web) ~= "boolean" then
    local vapelite
    local vapelite2
    local draw
    local textguitextdrawings = {}
    local textguitextdrawings2 = {}
    pcall(function()
        draw = Drawing.new("Text")
        draw.Visible = false
        vapelite = Drawing.new("Image")
        vapelite2 = Drawing.new("Image")
        local logocheck = syn and "VapeLiteLogoSyn.png" or "VapeLiteLogo.png"
        vapelite.Data = shared.VapeDeveloper and readfile(logocheck) or game:HttpGet("https://raw.githubusercontent.com/7GrandDadPGN/VapeLiteForRoblox/main/"..logocheck, true) or ""
        vapelite.Size = Vector2.new(140, 64)
        vapelite.ZIndex = 2
        vapelite.Position = Vector2.new(3, 36)
        vapelite.Visible = false
        vapelite2.Data = shared.VapeDeveloper and readfile("VapeLiteLogoShadow.png") or game:HttpGet("https://raw.githubusercontent.com/7GrandDadPGN/VapeLiteForRoblox/main/VapeLiteLogoShadow.png", true) or ""
        vapelite2.Size = Vector2.new(140, 64)
        vapelite2.Position = Vector2.new(5, 38)
        vapelite2.ZIndex = 1
        vapelite2.Visible = false
    end)
    local robloxgui = game:GetService("CoreGui"):WaitForChild("RobloxGui", 10)

    if game.PlaceId == 8821374215 then
    local wepspeed = addModule("Weapon Speed %", "PlaceHolder", function(callback)
        if callback then
            
        end
    end)
    
    local infstam = addModule("Infinite Stamina", "Grants you Infinite Stamina", function(callback)
        while callback do
            game:GetService("Players").LocalPlayer.Backpack.Stamina:Destroy()
            local new = Instance.new("IntValue", game:GetService("Players").LocalPlayer.Backpack)
            new.Name = "Stamina"
            new.Value = "100"
            task.wait(2)
        end
    end)
    
    local infdodge = addModule("Infinite Dodge", "PlaceHolder", function(callback)
        while callback do
            game:GetService("ReplicatedStorage").Dash:InvokeServer()
            runService.Heartbeat:Wait()
        end
    end)
    
    local wlkspd = addModule("Walkspeed", "PlaceHolder", function(callback)
        if callback then
            
        end
    end)
    
    end
    local function datafunc(msg)
        local tab = game:GetService("HttpService"):JSONDecode(msg)
        if tab.msg == "togglemodule" then
            local module = findModule(tab.module)
            if module then 
                modulefunctions[tab.module](tab.state)
                module.toggled = tab.state
                modulesenabled[tab.module] = tab.state
                sendrequest({
                    msg = "writesettings",
                    id = (game.PlaceId == 8821374215 and saisei),
                    content = game:GetService("HttpService"):JSONEncode(modulesenabled)
                })
            end
            UpdateHud()
        elseif tab.msg == "togglebuttontoggle" then
            local module = findOption(tab.module, tab.setting)
            if module then 
                modulefunctions[tab.module..tab.setting](tab.state)
                module.toggled = tab.state
                modulesenabled[tab.module.."/"..tab.setting] = tab.state
                sendrequest({
                    msg = "writesettings",
                    id = (game.PlaceId == 8821374215 and saisei),
                    content = game:GetService("HttpService"):JSONEncode(modulesenabled)
                })
            end
        elseif tab.msg == "togglebuttonslider" then
            local module = findOption(tab.module, tab.setting)
            if module then 
                modulefunctions[tab.module..tab.setting](tab.state)
                module.state = tab.state
                modulesenabled[tab.module.."/"..tab.setting] = tab.state
                sendrequest({
                    msg = "writesettings",
                    id = (game.PlaceId == 8821374215 and saisei),
                    content = game:GetService("HttpService"):JSONEncode(modulesenabled)
                })
            end
        elseif tab.msg == "readsettings" then
            readsettings:Fire(tab.result)
        end
    end

    if syn and syn.toast_notification then 
        web.DataReceived:Connect(datafunc)
    else
        web.OnMessage:Connect(datafunc)
    end
    sendrequest({
        msg = "readsettings",
        id = (game.PlaceId == 8821374215 and saisei)
    })
    local settingss = readsettings.Event:Wait()
    local suc2, settingstab = pcall(function() return game:GetService("HttpService"):JSONDecode(settingss) end)
    local loaded = false
    if suc2 then
        for i,v in pairs(settingstab) do 
            local module = i:find("/") and findOption(unpack(i:split("/"))) or findModule(i)
            local modulename = i:gsub("/", "")
            if module then
                if module.type then
                    if module.type == "Toggle" and v == true then
                        modulefunctions[modulename](true)
                        module.toggled = true
                        modulesenabled[i] = true
                    elseif module.type == "Slider" then 
                        modulefunctions[modulename](v)
                        module.state = v
                        modulesenabled[i] = v
                    end
                elseif v == true then
                    modulefunctions[modulename](true)
                    module.toggled = true
                    modulesenabled[modulename] = true
                    UpdateHud()
                end
            end
        end
        loaded = true
    else
        sendrequest({
            msg = "writesettings",
            id = (game.PlaceId == 8821374215 and saisei),
            content = "{}"
        })
        loaded = true
    end
    repeat task.wait() until loaded
    sendrequest({
        msg = "connectrequest",
        modules = modules
    })

    local function connectionclose()
        for i,v in pairs(modulefunctions) do 
            local ok = findModule(i)
            if ok ~= nil and modulesenabled[i] then
                v(false)
                modulesenabled[i] = false
            end
        end
        spawn(function()
            if shared.noinject == nil then
                repeat task.wait() until game:IsLoaded()
                repeat task.wait(5) until isfile("vapelite.injectable.txt")
                delfile("vapelite.injectable.txt")
                loadstring(readfile("vapelite.lua"))()
            end
        end)
    end

    if syn and syn.toast_notification then 
        web.ConnectionClosed:Connect(connectionclose)
    else
        web.OnClose:Connect(connectionclose)
    end
else
    print("websocket error:", web)
end
