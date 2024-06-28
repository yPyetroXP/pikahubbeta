-- Cria um novo ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.CoreGui

-- Cria um novo ImageButton
local imageButton = Instance.new("ImageButton")
imageButton.Parent = screenGui
imageButton.Size = UDim2.new(0, 100, 0, 100) -- Define o tamanho do botão
imageButton.Position = UDim2.new(0, 10, 0, 10) -- Define a posição do botão
imageButton.Image = "rbxassetid://17591781966" -- Substitua pelo ID da imagem que você deseja usar
imageButton.BackgroundTransparency = 1 -- Torna o fundo do botão transparente

local function simulateLeftControl()
    local VirtualUser = game:GetService("VirtualUser")
    VirtualUser:CaptureController()
    VirtualUser:SetKeyDown(Enum.KeyCode.LeftControl) -- Usa a enumeração correta para a tecla
    wait(0.1) -- Tempo que a tecla será "segurada"
    VirtualUser:SetKeyUp(Enum.KeyCode.LeftControl)
end

-- Conecta a função ao evento de clique do botão
imageButton.MouseButton1Click:Connect(simulateLeftControl)

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Fluent " .. Fluent.Version,
    SubTitle = "by dawid",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true, 
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

do
    Fluent:Notify({
        Title = "Notification",
        Content = "This is a notification",
        SubContent = "SubContent",
        Duration = 5
    })

    Tabs.Main:AddParagraph({
        Title = "Paragraph",
        Content = "This is a paragraph.\nSecond line!"
    })

    Tabs.Main:AddButton({
        Title = "Button",
        Description = "Very important button",
        Callback = function()
            Window:Dialog({
                Title = "Title",
                Content = "This is a dialog",
                Buttons = {
                    {
                        Title = "Confirm",
                        Callback = function()
                            print("Confirmed the dialog.")
                        end
                    },
                    {
                        Title = "Cancel",
                        Callback = function()
                            print("Cancelled the dialog.")
                        end
                    }
                }
            })
        end
    })

    local Toggle = Tabs.Main:AddToggle("MyToggle", {Title = "Toggle", Default = false })

    Toggle:OnChanged(function()
        print("Toggle changed:", Options.MyToggle.Value)
    end)

    Options.MyToggle:SetValue(false)

    local Slider = Tabs.Main:AddSlider("Slider", {
        Title = "Slider",
        Description = "This is a slider",
        Default = 2,
        Min = 0,
        Max = 5,
        Rounding = 1,
        Callback = function(Value)
            print("Slider was changed:", Value)
        end
    })

    Slider:OnChanged(function(Value)
        print("Slider changed:", Value)
    end)

    Slider:SetValue(3)

    local Dropdown = Tabs.Main:AddDropdown("Dropdown", {
        Title = "Dropdown",
        Values = {"one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "eleven", "twelve", "thirteen", "fourteen"},
        Multi = false,
        Default = 1,
    })

    Dropdown:SetValue("four")

    Dropdown:OnChanged(function(Value)
        print("Dropdown changed:", Value)
    end)

    local MultiDropdown = Tabs.Main:AddDropdown("MultiDropdown", {
        Title = "Dropdown",
        Description = "You can select multiple values.",
        Values = {"one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "eleven", "twelve", "thirteen", "fourteen"},
        Multi = true,
        Default = {"seven", "twelve"},
    })

    MultiDropdown:SetValue({
        three = true,
        five = true,
        seven = false
    })

    MultiDropdown:OnChanged(function(Value)
        local Values = {}
        for Value, State in next, Value do
            table.insert(Values, Value)
        end
        print("Mutlidropdown changed:", table.concat(Values, ", "))
    end)

    local Colorpicker = Tabs.Main:AddColorpicker("Colorpicker", {
        Title = "Colorpicker",
        Default = Color3.fromRGB(96, 205, 255)
    })

    Colorpicker:OnChanged(function()
        print("Colorpicker changed:", Colorpicker.Value)
    end)
    
    Colorpicker:SetValueRGB(Color3.fromRGB(0, 255, 140))

    local TColorpicker = Tabs.Main:AddColorpicker("TransparencyColorpicker", {
        Title = "Colorpicker",
        Description = "but you can change the transparency.",
        Transparency = 0,
        Default = Color3.fromRGB(96, 205, 255)
    })

    TColorpicker:OnChanged(function()
        print(
            "TColorpicker changed:", TColorpicker.Value,
            "Transparency:", TColorpicker.Transparency
        )
    end)

    local Keybind = Tabs.Main:AddKeybind("Keybind", {
        Title = "KeyBind",
        Mode = "Toggle",
        Default = "LeftControl",

        Callback = function(Value)
            print("Keybind clicked!", Value)
        end,

        ChangedCallback = function(New)
            print("Keybind changed!", New)
        end
    })

    Keybind:OnClick(function()
        print("Keybind clicked:", Keybind:GetState())
    end)

    Keybind:OnChanged(function()
        print("Keybind changed:", Keybind.Value)
    end)

    task.spawn(function()
        while true do
            wait(1)

            local state = Keybind:GetState()
            if state then
                print("Keybind is being held down")
            end

            if Fluent.Unloaded then break end
        end
    end)

    Keybind:SetValue("MB2", "Toggle")

    local Input = Tabs.Main:AddInput("Input", {
        Title = "Input",
        Default = "Default",
        Placeholder = "Placeholder",
        Numeric = false,
        Finished = false,
        Callback = function(Value)
            print("Input changed:", Value)
        end
    })

    Input:OnChanged(function()
        print("Input updated:", Input.Value)
    end)
end

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})

-- Adiciona novas funcionalidades específicas para Roblox
local FruitList = {
    "Bomb-Bomb",
    "Spike-Spike",
    "Chop-Chop",
    "Spring-Spring",
    "Kilo-Kilo",
    "Spin-Spin",
    "Bird: Falcon",
    "Smoke-Smoke",
    "Flame-Flame",
    "Ice-Ice",
    "Sand-Sand",
    "Dark-Dark",
    "Ghost-Ghost",
    "Diamond-Diamond",
    "Light-Light",
    "Love-Love",
    "Rubber-Rubber",
    "Barrier-Barrier",
    "Magma-Magma",
    "Portal-Portal",
    "Quake-Quake",
    "Human-Human: Buddha",
    "Spider-Spider",
    "Bird-Bird: Phoenix",
    "Rumble-Rumble",
    "Pain-Pain",
    "Gravity-Gravity",
    "Dough-Dough",
    "Venom-Venom",
    "Shadow-Shadow",
    "Control-Control",
    "Soul-Soul",
    "Dragon-Dragon",
    "Leopard-Leopard"
}

local FruitDropdown = Tabs.Main:AddDropdown("Dropdown", {
    Title = "Chọn Fruit Để Mua",
    Values = FruitList,
    Multi = false,
    Default = 1,
})

FruitDropdown:SetValue("")

FruitDropdown:OnChanged(function(Value)
    _G.SelectFruit = Value
end)

local AutoRandomFruitToggle = Tabs.Main:AddToggle("MyToggle", {Title = "Auto Random Fruit", Default = false })

AutoRandomFruitToggle:OnChanged(function(Value)
    _G.RandomFruit = Value
end)

spawn(function()
    while wait(.1) do
        if _G.RandomFruit then
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Cousin","Buy")
        end 
    end
end)

local AutoStoreFruitToggle = Tabs.Main:AddToggle("MyToggle", {Title = "Tự Động Cất Fruit", Default = false })

AutoStoreFruitToggle:OnChanged(function(Value)
    _G.AutoStoreFruit = Value
end)

spawn(function()
    while task.wait() do
        if _G.AutoStoreFruit then
            pcall(function()
                for _, fruit in pairs({"Bomb Fruit", "Spike Fruit", "Chop Fruit", "Spring Fruit", "Kilo Fruit", "Smoke Fruit", "Spin Fruit", "Flame Fruit", "Bird: Falcon Fruit", "Ice Fruit", "Sand Fruit", "Dark Fruit", "Revive Fruit", "Diamond Fruit", "Light Fruit", "Love Fruit", "Rubber Fruit", "Barrier Fruit", "Magma Fruit", "Portal Fruit", "Quake Fruit", "Human-Human: Buddha Fruit", "Spider Fruit", "Bird: Phoenix Fruit", "Rumble Fruit", "Paw Fruit", "Gravity Fruit", "Dough Fruit", "Shadow Fruit", "Venom Fruit", "Control Fruit", "Spirit Fruit", "Dragon Fruit", "Leopard Fruit"}) do
                    local fruitName = fruit:gsub(" ", "-"):gsub(":", "")
                    local charFruit = game:GetService("Players").LocalPlayer.Character:FindFirstChild(fruit)
                    local backpackFruit = game:GetService("Players").LocalPlayer.Backpack:FindFirstChild(fruit)
                    if charFruit or backpackFruit then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", fruitName)
                    end
                end
            end)
        end
    end
end)

local AutoDropFruitToggle = Tabs.Main:AddToggle("MyToggle", {Title = "Tự Động Vứt Fruit", Default = false })

AutoDropFruitToggle:OnChanged(function(Value)
    _G.AutoDropFruit = Value
end)

spawn(function()
    while task.wait() do
        if _G.AutoDropFruit then
            pcall(function()
                for _, fruit in pairs({"Bomb Fruit", "Spike Fruit", "Chop Fruit", "Spring Fruit", "Kilo Fruit", "Smoke Fruit", "Spin Fruit", "Flame Fruit", "Bird: Falcon Fruit", "Ice Fruit", "Sand Fruit", "Dark Fruit", "Revive Fruit", "Diamond Fruit", "Light Fruit", "Love Fruit", "Rubber Fruit", "Barrier Fruit", "Magma Fruit", "Portal Fruit", "Quake Fruit", "Human-Human: Buddha Fruit", "Spider Fruit", "Bird: Phoenix Fruit", "Rumble Fruit", "Paw Fruit", "Gravity Fruit", "Dough Fruit", "Shadow Fruit", "Venom Fruit", "Control Fruit", "Spirit Fruit", "Dragon Fruit", "Leopard Fruit"}) do
                    local charFruit = game:GetService("Players").LocalPlayer.Character:FindFirstChild(fruit)
                    local backpackFruit = game:GetService("Players").LocalPlayer.Backpack:FindFirstChild(fruit)
                    if charFruit then
                        charFruit:Destroy()
                    end
                    if backpackFruit then
                        backpackFruit:Destroy()
                    end
                end
            end)
        end
    end
end)

local AutoBuyFruitToggle = Tabs.Main:AddToggle("MyToggle", {Title = "Tự Động Mua Fruit", Default = false })

AutoBuyFruitToggle:OnChanged(function(Value)
    _G.AutoBuyFruit = Value
end)

spawn(function()
    while wait() do
        if _G.AutoBuyFruit then
            if game.Players.LocalPlayer.Data.Beli.Value >= 2500000 then
                if _G.SelectFruit then
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyFruit", _G.SelectFruit)
                end
            end
        end
    end
end)

local AutoAwakenFruitToggle = Tabs.Main:AddToggle("MyToggle", {Title = "Auto Awaken Fruit", Default = false })

AutoAwakenFruitToggle:OnChanged(function(Value)
    _G.AutoAwakenFruit = Value
end)

spawn(function()
    while wait() do
        if _G.AutoAwakenFruit then
            game.Players.LocalPlayer.Character.Remotes.CommF_:InvokeServer("Awakened")
        end
    end
end)

InterfaceManager:BuildInterface()

SaveManager:LoadAutoloadConfig()
