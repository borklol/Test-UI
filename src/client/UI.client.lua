local Fusion = require(game:GetService("ReplicatedStorage"):WaitForChild("Common"):WaitForChild("Fusion"))

local New = Fusion.New
local Computed = Fusion.Computed
local Tween = Fusion.Tween
local Children = Fusion.Children
local Value = Fusion.Value

-- Variables
local Open = Value(false)

local Transparency = Value(1)
local Position = Value(UDim2.fromScale(0.5, 0.45))

local Tween1 = Tween(Transparency, TweenInfo.new(0.25))
local Tween2 = Tween(Position, TweenInfo.new(0.25))

local function addStroke(props)
    return New "UIStroke" {
        Color = props.Color or Color3.fromRGB(255, 255, 255),
        Thickness = props.Thickness or 1.5,
        Transparency = props.Transparency or 1,
    }
end

local function addCorner()
    return New "UICorner" {
        CornerRadius = UDim.new(0, 16)
    }
end

local function backplate(props)
    return New "Frame" {
        Position = Tween2,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.fromScale(0.55, 0.525),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = Computed(function()
            return math.clamp(Tween1:get(), 0.5, 1)
        end),

        [Children] = {
            addCorner(),

            New "ScrollingFrame" {
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(0.95, 0.95),
                BackgroundTransparency = 1,
                ScrollBarThickness = 0,
                BorderSizePixel = 0,

                [Children] = props[Children],
            },
        }
    }
end

local function button(props)
    local thickness = Value(0)
    return New "TextButton" {
        BackgroundTransparency = 1,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Text = props.Text,
        TextScaled = true,
        Font = "Gotham",
        TextTransparency = Tween1,
        Active = Computed(function()
            return Transparency:get() == 0 and true or false
        end),

        [Children] = {
            addCorner(),
            addStroke({Thickness = Tween(thickness, TweenInfo.new(0.25)), Transparency = Tween1, Color = Color3.fromRGB(0, 0, 0)})
        },

        [Fusion.OnEvent "MouseEnter"] = function()
            thickness:set(3)
        end,

        [Fusion.OnEvent "MouseLeave"] = function()
            thickness:set(0)
        end,
    }
end

game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.All, false)

New "ScreenGui" {
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"),

    [Children] = backplate({

        [Children] = {
            New "UIGridLayout" {
                CellSize = UDim2.new(.225, 0, 0, workspace.CurrentCamera.ViewportSize.Y * 0.175),
                CellPadding = UDim2.fromScale(0.025, 0)
            },

            button {
                Text = "Test",
            }
        }
    }),
}

game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessedEvent)
    if (gameProcessedEvent) then return end

    if (input.KeyCode == Enum.KeyCode.Tab) then
        Open:set(not Open:get())

        if (Open:get()) then
            Position:set(UDim2.fromScale(0.5, 0.5))
            Transparency:set(0)
        else
            Position:set(UDim2.fromScale(0.5, 0.45))
            Transparency:set(1)
        end
    end
end)