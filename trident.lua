local m_thread = task
setreadonly(m_thread, false)
function m_thread.spawn_loop(p_time, p_callback)
  m_thread.spawn(
  function()
    while true do
      p_callback()
      m_thread.wait(p_time)
    end
  end
  )
end
setreadonly(m_thread, true)


--// Macros
if not LPH_OBFUSCATED then
  LPH_JIT = function(...) return ... end
  LPH_JIT_MAX = function(...) return ... end
  LPH_JIT_ULTRA = function(...) return ... end
  LPH_NO_VIRTUALIZE = function(...) return ... end
  LPH_NO_UPVALUES = function(f) return(function(...) return f(...) end) end
  LPH_ENCSTR = function(...) return ... end
  LPH_STRENC = function(...) return ... end
  LPH_HOOK_FIX = function(...) return ... end
  LPH_CRASH = function() return print(debug.traceback()) end
  end;

  local Config = {
    Esp = {
      Box               = false,
      BoxFilled         = false,
      BoxOutline        = false,
      BoxTransparency   = 1,
      BoxColor          = Color3.fromRGB(255,255,255),
      BoxOutlineColor   = Color3.fromRGB(0,0,0),
      HealthBar         = false,
      HealthBarSide     = "Left", -- Left,Bottom,Right
      HealthBarColor = Color3.fromRGB(0,255,0),
      Names             = false,
      NamesOutline      = false,
      NamesColor        = Color3.fromRGB(255,255,255),
      NamesOutlineColor = Color3.fromRGB(0,0,0),
      NamesFont         = 2, -- 1,2,3
      NamesSize         = 13,
      Distance          = false,
      Tracer            = false
    },
  }

  -- *_SilentAim_* --

  local BulletModule = getrenv()._G.NEXT

  local SilentAimOn = false
  local SilentTarget = nil

  local Camera = game:GetService("Workspace").Camera;

  local fovcircle = Drawing.new("Circle")
  fovcircle.Visible = false
  fovcircle.Radius = 0
  fovcircle.Color = Color3.fromRGB(255,255,255)
  fovcircle.Thickness = 1
  fovcircle.Filled = false
  fovcircle.Transparency = 1
  fovcircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)





  local function viewportPoint(ret, ...)
    if type(ret) == "boolean" then
      local pos, vis = workspace.CurrentCamera:WorldToViewportPoint(...)
      return pos
    else
      return workspace.CurrentCamera:WorldToViewportPoint(ret, ...)
    end
  end


  local function GetPlayer()
    local last_distance = fovcircle.Radius
    local target = nil

    for i, v in pairs(workspace:GetChildren()) do
      if v:IsA("Model") and v.Name ~= "Player" then
        if v.PrimaryPart ~= nil and v:FindFirstChild("Head") then
          local sp, visible = viewportPoint(v:WaitForChild("HumanoidRootPart", math.huge).Position)
          local mouse_loc = game:GetService("UserInputService"):GetMouseLocation()
          local distance = (Vector2.new(mouse_loc.X, mouse_loc.Y) - Vector2.new(sp.X, sp.Y)).Magnitude

          local pos = Camera.WorldToViewportPoint(Camera, v.PrimaryPart.Position)



          local d = (Vector2.new(pos.X, pos.Y) - fovcircle.Position).magnitude
          if d <= fovcircle.Radius and distance < last_distance then
            last_distance = distance
            target = v
          else
            SilentTarget = nil
          end
        end
      end
    end

    return target
  end





  local function CalculateVelocity(Before, After, deltaTime)
    -- // Vars
    local Displacement = (After - Before)
    local Velocity = Displacement / deltaTime

    -- // Return
    return Velocity
  end

  local OrginalGetCFrame = BulletModule.GetCFrame

  local Prediction = Vector3.new(0, 0, 0)
  local TurnOnPrediction = false

  local Middle = game.Workspace.Ignore.LocalCharacter.Middle

  local PredictionAmmount = 0

  task.spawn(function()
  game:GetService("RunService").RenderStepped:Connect(function(dt)
  if SilentAimOn and SilentTarget then
    local p = nil
    if not TargetRN then
      p = GetPlayer()
      if p then
        TargetRN = p
      end
    else
      p = TargetRN
    end
    if not p then return end

    if p ~= nil then
      local CurrentPosition = p.HumanoidRootPart.Position
      if OldPosition == nil then
        OldPosition = CurrentPosition
      end
      local Velocity = CalculateVelocity(OldPosition,CurrentPosition,dt)
      Prediction = Vector3.new(0, 0, 0)
      if TurnOnPrediction == true then
        Prediction = Velocity * (PredictionAmmount / 10) * (Middle.Position - p.Head.Position).magnitude / 100
      end

      OldPosition = CurrentPosition
    end
  end
  end)
  end)



  local SpooferNigger
  if SilentAimOn and SilentTarget then
    SpooferNigger = hookfunction(SilentTarget.Position.Position, function()
    return OrginalGetCFrame();
    end)
  end


  local SpooferNigger2
  if SilentAimOn and SilentTarget then
    SpooferNigger2 = hookfunction(BulletModule.GetCFrame, function()
    return OrginalGetCFrame();
    end)
  end



  local SpooferNigger3
  local CFrameP = BulletModule.GetCFrame().p
  if SilentAimOn and SilentTarget then
    SpooferNigger3 = hookfunction(CFrameP, function()
    return OrginalGetCFrame();
    end)
  end


  BulletModule.GetCFrame = function()
  if SilentAimOn and SilentTarget then
    return CFrame.new(OrginalGetCFrame().p, SilentTarget.Position + Prediction + Vector3.new(0, 0.5 * 196.2 * 0.05 * 0.05, 0));
  else
    return OrginalGetCFrame();
  end
end




-- *_AcBypass_* --

local set_identity = typeof(syn)=="table" and syn.set_thread_identity or setthreadcontext or set_thread_context or setthreadidentity or set_thread_identity



local DisableAntiCheat = function(Table, Return)
for i,v in ipairs(getgc(true)) do
  if typeof(v) == "table" and rawget(v, Table) then
    set_identity(2)
    table.foreach(v, function(i, sus)
    local Anti = sus
    v[i] = function()
    return Return
  end
  end)
  set_identity(7)
end
end
end




DisableAntiCheat("checkRecoil", false)
DisableAntiCheat("checkForHitboxes", false)
DisableAntiCheat("checkLighting", false)
DisableAntiCheat("checkLightingValues", false)
DisableAntiCheat("checkXRAY", false)
DisableAntiCheat("checkGetCamHooked", false)
DisableAntiCheat("checkWorkspace", false)
DisableAntiCheat("checkFOVSpoof", false)
DisableAntiCheat("checkItemConfigTamper", false)













--// Create UI

local library, pointers = loadstring(game:HttpGet("https://raw.githubusercontent.com/freshlocaliar2mgiadawdpaklsd/OP-SHIT/main/UI"))()
local window = library:New({name = "Jugar.lua", size = Vector2.new(535,570), Accent = Color3.fromRGB(116, 55, 164)})
library:UpdateColor("Accent",Color3.fromRGB(0,255,0))library:UpdateColor("lightcontrast",Color3.fromRGB(20,20,20))library:UpdateColor("darkcontrast",Color3.fromRGB(20,20,20))library:UpdateColor("outline",Color3.fromRGB(0,0,0))library:UpdateColor("inline",Color3.fromRGB(14,14,14)) -- Autoload Theme

Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/freshlocaliar2mgiadawdpaklsd/OP-SHIT/main/Shit"))({
cheatname = 'Jugar.lua',
gamename = 'Trident Survival',
fileext = '.json'
})
Utility = Library.utility
Library:init()



--* Pages *--

local CombatPage = window:Page({name = "Combat", size = 110})

local VisualPage = window:Page({name = "Visuals", size = 110})



--* Sections *--

local CombatSection = CombatPage:Section({Name = "Silent Aim", Fill = false, Side = "Left"})
local CombatSection2 = CombatPage:Section({Name = "Gun Mods", Fill = false, Side = "Right"})

local VisualSection = VisualPage:Section({Name = "ESP", Fill = false, Side = "Left"})
local VisualSection2 = VisualPage:Section({Name = "Mods", Fill = false, Side = "Right"})


local ChangeESPOnTarget = false
local DrawLineToTarget = false

-- *_SilentAim_* --

CombatSection:Toggle(
{
name = "Silent Aim",
default = false,
callback = function(x)
SilentAimOn = x
end
})


CombatSection:Toggle(
{
name = "Show FOV",
default = false,
callback = function(x)
fovcircle.Visible = x
end
})

CombatSection:Toggle(
{
name = "Prediction",
default = false,
callback = function(x)
TurnOnPrediction = x
end
})

CombatSection:Toggle(
{
name = "Draw Line To Target",
default = false,
callback = function(x)
DrawLineToTarget = x
end
})


CombatSection:Toggle(
{
name = "Change ESP On Target",
default = false,
callback = function(x)
ChangeESPOnTarget = x
end
})



CombatSection:Slider(
{
Name = "FOV Size",
Minimum = 0,
Maximum = 500,
Default = 0,
Decimals = .01,
suffix = "",
Pointer = "FOV Size",
callback = function(a)
fovcircle.Radius = a
end
})


CombatSection:Slider(
{
Name = "Prediction Amount",
Minimum = 0,
Maximum = 10,
Default = 0,
Decimals = .01,
suffix = "",
Pointer = "Prediction Amount",
callback = function(a)
PredictionAmmount = a
end
})




-- *_Gun Mods_* --

CombatSection2:Toggle(
{
name = "No Recoil",
default = false,
callback = function(x)
if x then

else

end
end
})


CombatSection2:Toggle(
{
name = "No Blunderbuss Spread",
default = false,
callback = function(x)

end
})














-- *_ESP_* --


VisualSection:Toggle(
{
name = "Box ESP",
default = false,
callback = function(x)
Config.Esp.Box = x
Config.Esp.BoxOutline = x
end
})


VisualSection:Toggle(
{
name = "Player ESP",
default = false,
callback = function(x)
Config.Esp.Names = x
Config.Esp.NamesOutline = x
end
})


VisualSection:Toggle(
{
name = "Visual Health Bar ESP",
default = false,
callback = function(x)
Config.Esp.HealthBar = x
end
})


VisualSection:Toggle(
{
name = "Distance ESP",
default = false,
callback = function(x)
Config.Esp.Distance = x
end
})


VisualSection:Toggle(
{
name = "Tracer ESP",
default = false,
callback = function(x)
Config.Esp.Tracer = x
end
})

--// Field Of View \--



local Color = Color3.fromRGB(0,255,0)

local BulletTracers = false


VisualSection2:Toggle(
{
name = "Bullet Tracers",
default = false,
callback = function(x)
BulletTracers = x

game:GetService("RunService").RenderStepped:Connect(function()
if BulletTracers == true then
game:GetService("ReplicatedStorage").Arrow.Trail.Color = ColorSequence.new{
ColorSequenceKeypoint.new(0, Color),
ColorSequenceKeypoint.new(0.25, Color),
ColorSequenceKeypoint.new(0.5, Color),
ColorSequenceKeypoint.new(0.75, Color),
ColorSequenceKeypoint.new(1, Color)
}
elseif BulletTracers == false then
game:GetService("ReplicatedStorage").Arrow.Trail.Color = ColorSequence.new{
ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(0.25, Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(0.75, Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(255,255,255))
}
end
end)
end
}):Colorpicker(
{
pointer = "Bullet Tracer Color",
name = "Bullet Tracer Color",
default = Color3.fromRGB(0, 255, 0),
callback = function(p_state)
if BulletTracers then
Color = p_state
end
end
})





















































--* Menu, Configuration *--

local settings_page = window:Page({name = "Configuration", size = 110})
local config_section = settings_page:Section({name = "Configuration", side = "Left"})

local current_list = {}
local function update_config_list()
local list = {}
for idx, file in ipairs(listfiles("Atlanta/configs")) do
local file_name = file:gsub("Atlanta/configs\\", ""):gsub(".txt", "")
list[#list + 1] = file_name
end

local is_new = #list ~= #current_list
if not is_new then
for idx, file in ipairs(list) do
if file ~= current_list[idx] then
is_new = true
break
end
end
end
end

config_section:List({pointer = "settings/configuration/list"})
config_section:TextBox(
{
pointer = "settings/configuration/name",
placeholder = "Config Name",
text = "",
middle = true,
reset_on_focus = false
})

config_section:ButtonHolder({Buttons = {{"Create",  function()local config_name = pointers["settings/configuration/name"]:get()
if config_name == "" or isfile("Atlanta/configs/" .. config_name .. ".txt") then
return
end

writefile("Atlanta/configs/" .. config_name .. ".txt", "")
update_config_list() end}, {"Delete", function()
local selected_config = pointers["settings/configuration/list"]:get()[1][1]
if selected_config then
delfile("Atlanta/configs/" .. selected_config .. ".txt")
update_config_list()
end
end}}})
config_section:ButtonHolder({Buttons = {{"Load", function()
local selected_config = pointers["settings/configuration/list"]:get()[1][1]
if selected_config then
window:LoadConfig(readfile("Atlanta/configs/" .. selected_config .. ".txt"))
end
end}, {"Save", function()
local selected_config = pointers["settings/configuration/list"]:get()[1][1]
if selected_config then
writefile("Atlanta/configs/" .. selected_config .. ".txt", window:GetConfig())
end
end}}})

m_thread.spawn_loop(3, update_config_list)

local menu_section = settings_page:Section({name = "Menu"})
local function gs(a)
return game:GetService(a)
end

local actionservice = gs("ContextActionService")

menu_section:Keybind(
{
pointer = "settings/menu/bind",
name = "Open / Close",
default = Enum.KeyCode.RightShift,
callback = function(p_state)
window.uibind = p_state
end
})

local Visuals_Cursor = menu_section:Toggle(
{
pointer = "sabcd_aa",
name = "Cursor",
default = true,
callback = function(p_state)
local userInputService = game:GetService("UserInputService")
if p_state == true then
userInputService.MouseIconEnabled = true
else
userInputService.MouseIconEnabled = false
end
end
})

Visuals_Cursor:Colorpicker({Info = "Cursor Color", Alpha = 0, Default = Color3.fromRGB(255, 255, 255), pointer = "Cursor_Color"})
Visuals_Cursor:Colorpicker({Info = "Cursor Outline", Alpha = 0, Default = Color3.fromRGB(255, 255, 255), pointer = "Cursor_Outline"})

menu_section:Toggle(
{
pointer = "settings/menu/watermark",
name = "Watermark",
default = false,
callback = function(p_state)
window.watermark:Update("Visible", p_state)
end
})
menu_section:Toggle(
{
pointer = "settings/menu/keybind_list",
name = "Keybind List",
callback = function(p_state)
window.keybindslist:Update("Visible", p_state)
end
})

menu_section:Toggle(
{
pointer = "freezemovement",
name = "Disable Movement if UI Open",
callback = function(bool)
if bool and window.isVisible then
actionservice:BindAction(
"FreezeMovement",
function()
return Enum.ContextActionResult.Sink
end,
false,
unpack(Enum.PlayerActions:GetEnumItems())
)
else
actionservice:UnbindAction("FreezeMovement")
end
end
})

menu_section:Button(
{
name = "Unload",
confirmation = true,
callback = function()
window:Unload()
end
})

menu_section:Button(
{
name = "Force Close",
confirmation = true,
callback = function()
window:Fade()
end
})

local other_section = settings_page:Section({name = "Other", side = "Right"})

other_section:Label({Name = game:GetService("Players").LocalPlayer.PlayerGui.UI.ServerInfo.Text, Middle = true})

other_section:Button(
{
name = "Copy JobId",
callback = function()
setclipboard(game.JobId)
end
})

other_section:Button(
{
name = "Copy Discord",
confirmation = true,
callback = function()
if pcall(setclipboard,"https://discord.gg/beamedsolutions") then
Library:SendNotification(("Successfully copied discord link to your clipboard!"), 5, Color3.fromHSV(tick() % 5 / 5, 1, 1))
end
end
})

other_section:Button(
{
name = "Copy GameID",
callback = function()
setclipboard(game.GameId)
end
})

other_section:Button(
{
name = "Copy Game Invite",
callback = function()
setclipboard(
"Roblox.GameLauncher.joinGameInstance(" .. game.PlaceId .. ',"' .. game.JobId .. '")'
)
end
})

other_section:Button(
{
name = "Rejoin",
confirmation = true,
callback = function()
local Rejoin = coroutine.create(function()
local Success, ErrorMessage = pcall(function()
game:GetService("TeleportService"):Teleport(game.PlaceId, plr)
end)

if ErrorMessage and not Success then
warn(ErrorMessage)
end
end)

coroutine.resume(Rejoin)
end
})

local themes_section = settings_page:Section({name = "Themes", side = "Right"})

themes_section:Dropdown({
Name = "Theme",
Options = {"Default", "ZeeBot", "Abyss", "Spotify", "Zeebot v2", "Solix", "nomercy.rip", "Abyss V2", "Anorix", "Octel", "LegitSneeze", "AimWare", "x15","Gamesense", "Mint", "Ubuntu", "BitchBot", "BubbleGum", "Slime"},
Default = "Default",
Pointer = "themes/xd/",
callback = function(callback)
if callback == "Default" then
library:UpdateColor("Accent", Color3.fromRGB(255, 73, 225))
library:UpdateColor("lightcontrast", Color3.fromRGB(20, 20, 20))
library:UpdateColor("darkcontrast", Color3.fromRGB(20, 20, 20))
library:UpdateColor("outline", Color3.fromRGB(0, 0, 0))
library:UpdateColor("inline", Color3.fromRGB(14, 14, 14))
elseif callback == "Spotify" then
library:UpdateColor("Accent", Color3.fromRGB(103, 212, 91))
library:UpdateColor("lightcontrast", Color3.fromRGB(30, 30, 30))
library:UpdateColor("darkcontrast", Color3.fromRGB(25, 25, 25))
library:UpdateColor("outline", Color3.fromRGB(0, 0, 0))
library:UpdateColor("inline", Color3.fromRGB(46, 46, 46))
elseif callback == "AimWare" then
library:UpdateColor("Accent", Color3.fromRGB(250, 47, 47))
library:UpdateColor("lightcontrast", Color3.fromRGB(41, 40, 40))
library:UpdateColor("darkcontrast", Color3.fromRGB(38, 38, 38))
library:UpdateColor("outline", Color3.fromRGB(0, 0, 0))
library:UpdateColor("inline", Color3.fromRGB(46, 46, 46))
elseif callback == "nomercy.rip" then
library:UpdateColor("Accent", Color3.fromRGB(242, 150, 92))
library:UpdateColor("lightcontrast", Color3.fromRGB(22, 12, 46))
library:UpdateColor("darkcontrast", Color3.fromRGB(17, 8, 31))
library:UpdateColor("outline", Color3.fromRGB(0, 0, 0))
library:UpdateColor("inline", Color3.fromRGB(46, 46, 46))
elseif callback == "Abyss" then
library:UpdateColor("Accent", Color3.fromRGB(81, 72, 115))
library:UpdateColor("lightcontrast", Color3.fromRGB(41, 41, 41))
library:UpdateColor("darkcontrast", Color3.fromRGB(31, 30, 30))
library:UpdateColor("outline", Color3.fromRGB(0, 0, 0))
library:UpdateColor("inline", Color3.fromRGB(50, 50, 50))
elseif callback == "Abyss V2" then
library:UpdateColor("Accent", Color3.fromRGB(161, 144, 219))
library:UpdateColor("lightcontrast", Color3.fromRGB(27, 27, 27))
library:UpdateColor("darkcontrast", Color3.fromRGB(18, 18, 18))
library:UpdateColor("outline", Color3.fromRGB(0, 0, 0))
library:UpdateColor("inline", Color3.fromRGB(50, 50, 50))
elseif callback == "Gamesense" then
library:UpdateColor("Accent", Color3.fromRGB(163, 248, 105))
library:UpdateColor("lightcontrast", Color3.fromRGB(25, 25, 25))
library:UpdateColor("darkcontrast", Color3.fromRGB(16, 16, 16))
library:UpdateColor("outline", Color3.fromRGB(0, 0, 0))
library:UpdateColor("inline", Color3.fromRGB(50, 50, 50))
elseif callback == "Mint" then
library:UpdateColor("Accent", Color3.fromRGB(0, 255, 139))
library:UpdateColor("lightcontrast", Color3.fromRGB(20, 20, 20))
library:UpdateColor("darkcontrast", Color3.fromRGB(20, 20, 20))
library:UpdateColor("outline", Color3.fromRGB(0, 0, 0))
library:UpdateColor("inline", Color3.fromRGB(50, 50, 50))
elseif callback == "Ubuntu" then
library:UpdateColor("Accent", Color3.fromRGB(226, 88, 30))
library:UpdateColor("lightcontrast", Color3.fromRGB(62,62,62))
library:UpdateColor("darkcontrast", Color3.fromRGB(50, 50, 50))
library:UpdateColor("outline", Color3.fromRGB(0, 0, 0))
library:UpdateColor("inline", Color3.fromRGB(50, 50, 50))
elseif callback == "BitchBot" then
library:UpdateColor("Accent", Color3.fromRGB(126,72,163))
library:UpdateColor("lightcontrast", Color3.fromRGB(62,62,62))
library:UpdateColor("darkcontrast", Color3.fromRGB(50, 50, 50))
library:UpdateColor("outline", Color3.fromRGB(0, 0, 0))
library:UpdateColor("inline", Color3.fromRGB(50, 50, 50))
elseif callback == "Anorix" then
library:UpdateColor("Accent", Color3.fromRGB(105,156,164))
library:UpdateColor("lightcontrast", Color3.fromRGB(51,51,51))
library:UpdateColor("darkcontrast", Color3.fromRGB(41,41,41))
library:UpdateColor("outline", Color3.fromRGB(37, 37, 37))
library:UpdateColor("inline", Color3.fromRGB(39, 39, 39))
elseif callback == "Zeebot v2" then
library:UpdateColor("Accent", Color3.fromRGB(117,96,175))
library:UpdateColor("lightcontrast", Color3.fromRGB(51,51,51))
library:UpdateColor("darkcontrast", Color3.fromRGB(41,41,41))
library:UpdateColor("outline", Color3.fromRGB(37, 37, 37))
library:UpdateColor("inline", Color3.fromRGB(39, 39, 39))
elseif callback == "BubbleGum" then
library:UpdateColor("Accent", Color3.fromRGB(169, 83, 245))
library:UpdateColor("lightcontrast", Color3.fromRGB(22, 12, 46))
library:UpdateColor("darkcontrast", Color3.fromRGB(17, 8, 31))
library:UpdateColor("outline", Color3.fromRGB(0, 0, 0))
library:UpdateColor("inline", Color3.fromRGB(46, 46, 46))
elseif callback == "Slime" then
library:UpdateColor("Accent", Color3.fromRGB(64, 247, 141))
library:UpdateColor("lightcontrast", Color3.fromRGB(22, 12, 46))
library:UpdateColor("darkcontrast", Color3.fromRGB(17, 8, 31))
library:UpdateColor("outline", Color3.fromRGB(0, 0, 0))
library:UpdateColor("inline", Color3.fromRGB(46, 46, 46))
elseif callback == "Octel" then
library:UpdateColor("Accent", Color3.fromRGB(255, 201, 254))
library:UpdateColor("lightcontrast", Color3.fromRGB(32, 32, 32))
library:UpdateColor("darkcontrast", Color3.fromRGB(25, 25, 25))
library:UpdateColor("outline", Color3.fromRGB(0, 0, 0))
library:UpdateColor("inline", Color3.fromRGB(30, 28, 30))
elseif callback == "LegitSneeze" then
library:UpdateColor("Accent", Color3.fromRGB(135,206,250))
library:UpdateColor("lightcontrast", Color3.fromRGB(43,41,48))
library:UpdateColor("darkcontrast", Color3.fromRGB(44,41,48))
library:UpdateColor("outline", Color3.fromRGB(0, 0, 0))
library:UpdateColor("inline", Color3.fromRGB(50,50,50))
elseif callback == "x15" then
library:UpdateColor("Accent", Color3.fromRGB(92,57,152))
library:UpdateColor("lightcontrast", Color3.fromRGB(32, 32, 32))
library:UpdateColor("darkcontrast", Color3.fromRGB(25, 25, 25))
library:UpdateColor("outline", Color3.fromRGB(0, 0, 0))
library:UpdateColor("inline", Color3.fromRGB(30, 28, 30))
elseif callback == "ZeeBot" then
library:UpdateColor("Accent", Color3.fromRGB(59,84,154))
library:UpdateColor("lightcontrast", Color3.fromRGB(32, 33, 32))
library:UpdateColor("darkcontrast", Color3.fromRGB(25, 26, 25))
library:UpdateColor("outline", Color3.fromRGB(0, 0, 0))
library:UpdateColor("inline", Color3.fromRGB(30, 31, 30))
elseif callback == "Solix" then
library:UpdateColor("Accent", Color3.fromRGB(120, 93, 166))
library:UpdateColor("lightcontrast", Color3.fromRGB(33,33,33))
library:UpdateColor("darkcontrast", Color3.fromRGB(24,24,24))
library:UpdateColor("outline", Color3.fromRGB(0, 0, 0))
library:UpdateColor("inline", Color3.fromRGB(30, 29, 30))
end
end
})

themes_section:Dropdown(
{
Name = "Accent Effects",
Options = {"Rainbow", "Fade", "Disguard Fade", "Disguard Rainbow"},
Default = "None",
Pointer = "themes/xd/",
callback = function(callback)
if callback == "Rainbow" then
if callback then

ching =
game:GetService("RunService").Heartbeat:Connect(
function()
chings:Disconnect()
library:UpdateColor("Accent", Color3.fromHSV(tick() % 5 / 5, 1, 1))
end
)
else
if ching then
ching:Disconnect()
end
end

elseif callback == "Disguard Rainbow" then
ching:Disconnect()


elseif callback == "Disguard Fade" then

chings:Disconnect()

elseif callback == "Fade" then
if callback then

chings =
game:GetService("RunService").Heartbeat:Connect(
function()
ching:Disconnect()
local r = (math.sin(workspace.DistributedGameTime/2)/2)+0.5
local g = (math.sin(workspace.DistributedGameTime)/2)+0.5
local b = (math.sin(workspace.DistributedGameTime*1.5)/2)+0.5
local color = Color3.new(r, g, b)
library:UpdateColor("Accent", color)
end
)
else
if chings then
chings:Disconnect()
end
end
end
end
})

themes_section:Slider(
{
Name = "Switch Speed",
Minimum = 0,
Maximum = 10,
Default = 1,
Decimals = 1,
suffix = "",
Pointer = "reload delay",
callback = function(a)
end
})

themes_section:Colorpicker(
{
pointer = "themes/menu/accent",
name = "Accent",
default = Color3.fromRGB(100, 61, 200),
callback = function(p_state)
library:UpdateColor("Accent", p_state)
end
})

themes_section:Colorpicker(
{
pointer = "settings/menu/accent",
name = "Light Contrast",
default = Color3.fromRGB(30, 30, 30),
callback = function(p_state)
library:UpdateColor("lightcontrast", p_state)
end
})

themes_section:Colorpicker(
{
pointer = "settings/menu/accent",
name = "Dark Constrast",
default = Color3.fromRGB(25, 25, 25),
callback = function(p_state)
library:UpdateColor("darkcontrast", p_state)
end
})

themes_section:Colorpicker(
{
pointer = "settings/menu/accent",
name = "Outline",
default = Color3.fromRGB(0, 0, 0),
callback = function(p_state)
library:UpdateColor("outline", p_state)
end
})

themes_section:Colorpicker(
{
pointer = "settings/menu/accent",
name = "Inline",
default = Color3.fromRGB(50, 50, 50),
callback = function(p_state)
library:UpdateColor("inline", p_state)
end
})

themes_section:Colorpicker(
{
pointer = "settings/menu/accent",
name = "Text Color",
default = Color3.fromRGB(255, 255, 255),
callback = function(p_state)
library:UpdateColor("textcolor", p_state)
end
})

themes_section:Colorpicker(
{
pointer = "settings/menu/accent",
name = "Text Border",
default = Color3.fromRGB(0, 0, 0),
callback = function(p_state)
library:UpdateColor("textborder", p_state)
end
})

themes_section:Colorpicker(
{
pointer = "settings/menu/accent",
name = "Cursor Outline",
default = Color3.fromRGB(10, 10, 10),
callback = function(p_state)
library:UpdateColor("cursoroutline", p_state)
end
})

local load_section = settings_page:Section({name = "Load Menu", side = "Left"})
load_section:Toggle({name = "Auto Load Config"})

window.uibind = Enum.KeyCode.RightShift
window:Initialize()

--// Discord Invite













































































local c = workspace.CurrentCamera
local function getdistancefc(part)
return (part.Position - c.CFrame.Position).Magnitude
end




function CreateEsp(Player)
local Box,BoxOutline,Name,HealthBar,HealthBarOutline,Distance,Tracer = Drawing.new("Square"),Drawing.new("Square"),Drawing.new("Text"),Drawing.new("Square"),Drawing.new("Square"),Drawing.new("Text"),Drawing.new("Line")
local Updater = game:GetService("RunService").RenderStepped:Connect(function()
if Player ~= nil and Player:FindFirstChild("HumanoidRootPart") ~= nil and Player:FindFirstChild("Head") ~= nil then
local Target2dPosition,IsVisible = workspace.CurrentCamera:WorldToViewportPoint(Player.HumanoidRootPart.Position)
local scale_factor = 1 / (Target2dPosition.Z * math.tan(math.rad(workspace.CurrentCamera.FieldOfView * 0.5)) * 2) * 100
local width, height = math.floor(40 * scale_factor), math.floor(60 * scale_factor)
if Config.Esp.Box then
Box.Visible = IsVisible
Box.Color = Config.Esp.BoxColor
Box.Size = Vector2.new(width,height)
Box.Position = Vector2.new(Target2dPosition.X - Box.Size.X / 2,Target2dPosition.Y - Box.Size.Y / 2)
Box.Filled = Config.Esp.BoxFilled
Box.Thickness = 1
Box.Transparency = Config.Esp.BoxTransparency
Box.ZIndex = 69
if SilentAimOn and SilentTarget then
if SilentTarget.Position == Player.Head.Position then
Box.Visible = IsVisible
Box.Color = Color3.fromRGB(255,0,0)
Box.Size = Vector2.new(width,height)
Box.Position = Vector2.new(Target2dPosition.X - Box.Size.X / 2,Target2dPosition.Y - Box.Size.Y / 2)
Box.Filled = Config.Esp.BoxFilled
Box.Thickness = 1
Box.Transparency = Config.Esp.BoxTransparency
Box.ZIndex = 69
end
end
if Config.Esp.BoxOutline then
BoxOutline.Visible = IsVisible
BoxOutline.Color = Config.Esp.BoxOutlineColor
BoxOutline.Size = Vector2.new(width,height)
BoxOutline.Position = Vector2.new(Target2dPosition.X - Box.Size.X / 2,Target2dPosition.Y - Box.Size.Y / 2)
BoxOutline.Filled = false
BoxOutline.Thickness = 2.2
BoxOutline.ZIndex = 1
else
BoxOutline.Visible = false
end
else
Box.Visible = false
BoxOutline.Visible = false
end
if Config.Esp.Names then
Name.Visible = IsVisible
Name.Color = Config.Esp.NamesColor
Name.Text = "Player"
Name.Center = true
Name.Outline = Config.Esp.NamesOutline
Name.OutlineColor = Config.Esp.NamesOutlineColor
Name.Position = Vector2.new(Target2dPosition.X,Target2dPosition.Y - height * 0.5 + -15)
Name.Font = Config.Esp.NamesFont
Name.Size = Config.Esp.NamesSize
if SilentAimOn and SilentTarget then
if SilentTarget.Position == Player.Head.Position then
Name.Visible = IsVisible
Name.Color = Color3.fromRGB(255,0,0)
Name.Text = "Player"
Name.Center = true
Name.Outline = Config.Esp.NamesOutline
Name.OutlineColor = Config.Esp.NamesOutlineColor
Name.Position = Vector2.new(Target2dPosition.X,Target2dPosition.Y - height * 0.5 + -15)
Name.Font = Config.Esp.NamesFont
Name.Size = Config.Esp.NamesSize
end
end
else
Name.Visible = false
end
if Config.Esp.HealthBar then
HealthBarOutline.Visible = IsVisible
HealthBarOutline.Color = Color3.fromRGB(0,0,0)
HealthBarOutline.Filled = true
HealthBarOutline.ZIndex = 1

HealthBar.Visible = IsVisible
HealthBar.Color = Config.Esp.HealthBarColor
HealthBar.Thickness = 90
HealthBar.Filled = true
HealthBar.ZIndex = 69
if Config.Esp.HealthBarSide == "Left" then
HealthBarOutline.Size = Vector2.new(2,height)
HealthBarOutline.Position = Vector2.new(Target2dPosition.X - Box.Size.X / 2,Target2dPosition.Y - Box.Size.Y / 2) + Vector2.new(-3,0)

HealthBar.Size = Vector2.new(1,-(HealthBarOutline.Size.Y - 2))
HealthBar.Position = HealthBarOutline.Position + Vector2.new(1,-1 + HealthBarOutline.Size.Y)
elseif Config.Esp.HealthBarSide == "Bottom" then
HealthBarOutline.Size = Vector2.new(width,3)
HealthBarOutline.Position = Vector2.new(Target2dPosition.X - Box.Size.X / 2,Target2dPosition.Y - Box.Size.Y / 2) + Vector2.new(0,height + 2)

HealthBar.Size = Vector2.new((HealthBarOutline.Size.X - 2),1)
HealthBar.Position = HealthBarOutline.Position + Vector2.new(1,-1 + HealthBarOutline.Size.Y)
elseif Config.Esp.HealthBarSide == "Right" then
HealthBarOutline.Size = Vector2.new(2,height)
HealthBarOutline.Position = Vector2.new(Target2dPosition.X - Box.Size.X / 2,Target2dPosition.Y - Box.Size.Y / 2) + Vector2.new(width + 1,0)

HealthBar.Size = Vector2.new(1,-(HealthBarOutline.Size.Y - 2))
HealthBar.Position = HealthBarOutline.Position + Vector2.new(1,-1 + HealthBarOutline.Size.Y)
end
else
HealthBar.Visible = false
HealthBarOutline.Visible = false
end


if Config.Esp.Distance then
Distance.Visible = IsVisible
Distance.Center = true
Distance.Outline = true
Distance.Font = 2
Distance.Color = Color3.fromRGB(255,255,255)
Distance.Size = 12
Distance.Position = Vector2.new(Target2dPosition.X, Target2dPosition.Y + height / 2 + 5)
Distance.Text = '['..tostring(math.floor(getdistancefc(Player.HumanoidRootPart)))..']'
if SilentAimOn and SilentTarget then
if SilentTarget.Position == Player.Head.Position then
Distance.Visible = IsVisible
Distance.Center = true
Distance.Outline = true
Distance.Font = 2
Distance.Color = Color3.fromRGB(255,0,0)
Distance.Size = 12
Distance.Position = Vector2.new(Target2dPosition.X, Target2dPosition.Y + height / 2 + 5)
Distance.Text = '['..tostring(math.floor(getdistancefc(Player.HumanoidRootPart)))..']'
end
end
else
Distance.Visible = false
end


if Config.Esp.Tracer then
Tracer.Visible = IsVisible
Tracer.Color = Color3.fromRGB(255,255,255)
Tracer.Thickness = 1
Tracer.Transparency = 1

Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.X / 1.5)
Tracer.To = Vector2.new(Target2dPosition.X, Target2dPosition.Y + height / 2 + 15)
if SilentAimOn and SilentTarget then
if SilentTarget.Position == Player.Head.Position then
Tracer.Visible = IsVisible
Tracer.Color = Color3.fromRGB(255,0,0)
Tracer.Thickness = 1
Tracer.Transparency = 1

Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.X / 1.5)
Tracer.To = Vector2.new(Target2dPosition.X, Target2dPosition.Y + height / 2 + 15)
end
end
else
Tracer.Visible = false
end
else
Distance.Visible = false
Box.Visible = false
BoxOutline.Visible = false
Tracer.Visible = false
Name.Visible = false
HealthBar.Visible = false
HealthBarOutline.Visible = false
if not Player then
Box:Remove()
BoxOutline:Remove()
Name:Remove()
HealthBar:Remove()
HealthBarOutline:Remove()
Updater:Disconnect()
end
end
end)
end
for _,i in pairs(game:GetService("Workspace"):GetChildren()) do
if i ~= game.Players.LocalPlayer.Character and i:FindFirstChild("HumanoidRootPart") and i.Head:FindFirstChild("Nametag") then
CreateEsp(i)
end
end

game.Workspace.DescendantAdded:Connect(function(i)
if i ~= game.Players.LocalPlayer.Character and i:FindFirstChild("HumanoidRootPart") and i.Head:FindFirstChild("Nametag") then
CreateEsp(i)
end
end)

task.spawn(function()
while task.wait() do
if SilentAimOn then
local Target;
Target = GetPlayer();
if Target then
SilentTarget = Target:FindFirstChild("Head");
end
else
SilentTarget = nil;
end
end
end)

local Line = Drawing.new("Line")
Line.Thickness = 0
Line.Visible = false
Line.Transparency = 1
Line.Color = Color3.fromRGB(255,255,255)
Line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

task.spawn(function()
while task.wait() do
if SilentAimOn and SilentTarget and DrawLineToTarget then
local HumPos, OnScreen = Camera:WorldToViewportPoint(SilentTarget.Position)
if OnScreen then
Line.Visible = true
Line.To = Vector2.new(HumPos.X, HumPos.Y)
else
Line.Visible = false
end
else
Line.Visible = false
end
end
end)
