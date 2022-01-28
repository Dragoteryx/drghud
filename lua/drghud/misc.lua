DrGBase.IncludeFolder("drghud/cl_langs")

if CLIENT then

  DrGHUD.Enabled = DrGBase.ClientConVar("drghud", "1")
  DrGHUD.BlurQuality = DrGBase.ClientConVar("drghud_blur", "3")
  DrGHUD.Scale = DrGBase.ClientConVar("drghud_scale", "1")
  DrGHUD.HideZoom = DrGBase.ClientConVar("drghud_hide_zoom", "1")

  hook.Add("HUDPaint", "DrGHUD/Paint", function()
    if DrGHUD.Enabled:GetBool() then hook.Run("DrGHUD/Paint") end
  end)

  hook.Add("HUDShouldDraw", "DrGHUD/ShouldDraw", function(name)
    if DrGHUD.Enabled:GetBool() then return hook.Run("DrGHUD/ShouldDraw", name) end
  end)

  hook.Add("DrGHUD/ShouldDraw", "DrGHUD/HideZoom", function(name)
    if name == "CHudZoom" and DrGHUD.HideZoom:GetBool() then return false end
  end)

  -- Materials --

  DrGHUD.DeathMaterial = Material("drghud/death.png")
  DrGHUD.SpeedMaterial = Material("drghud/speed.png")
  DrGHUD.FPSMaterial = Material("drghud/fps.png")
  DrGHUD.PingMaterial = Material("drghud/ping.png")

  -- Colors --

  local function HUDColor(name, color)
    local red = DrGBase.ClientConVar("drghud_color_"..name.."_r", tostring(color.r))
    local green = DrGBase.ClientConVar("drghud_color_"..name.."_g", tostring(color.g))
    local blue = DrGBase.ClientConVar("drghud_color_"..name.."_b", tostring(color.b))
    local color = Color(red:GetInt(), green:GetInt(), blue:GetInt(), color.a)
    cvars.AddChangeCallback(red:GetName(), function() color.r = red:GetInt() end)
    cvars.AddChangeCallback(green:GetName(), function() color.g = green:GetInt() end)
    cvars.AddChangeCallback(blue:GetName(), function() color.b = blue:GetInt() end)
    return {
      Red = red,
      Green = green,
      Blue = blue,
      Value = color,
      Reset = function()
        red:Revert()
        green:Revert()
        blue:Revert()
      end
    }
  end

  DrGHUD.MainColor = HUDColor("main", DrGBase.CLR_SOFT_WHITE)
  DrGHUD.FullHealthColor = HUDColor("full_health", DrGBase.CLR_GREEN)
  DrGHUD.LowHealthColor = HUDColor("low_health", DrGBase.CLR_RED)
  DrGHUD.ArmorColor = HUDColor("armor", DrGBase.CLR_ORANGE)
  DrGHUD.AmmoColor = HUDColor("ammo", DrGBase.CLR_SOFT_WHITE)
  DrGHUD.Ammo2Color = HUDColor("ammo2", DrGBase.CLR_ORANGE)
  DrGHUD.NeutralColor = HUDColor("radar_neutral", DrGBase.CLR_SOFT_WHITE)
  DrGHUD.AllyColor = HUDColor("radar_ally", DrGBase.CLR_GREEN)
  DrGHUD.EnemyColor = HUDColor("radar_enemy", DrGBase.CLR_RED)
  DrGHUD.RadarVehicleColor = HUDColor("radar_vehicle", DrGBase.CLR_ORANGE)
  DrGHUD.RadarWeaponColor = HUDColor("radar_weapon", DrGBase.CLR_ORANGE)

  concommand.Add("drghud_cmd_colors_reset", function()
    DrGHUD.MainColor:Reset()
    DrGHUD.FullHealthColor:Reset()
    DrGHUD.LowHealthColor:Reset()
    DrGHUD.SuitColor:Reset()
    DrGHUD.AmmoColor:Reset()
    DrGHUD.Ammo2Color:Reset()
    DrGHUD.NeutralColor:Reset()
    DrGHUD.AllyColor:Reset()
    DrGHUD.EnemyColor:Reset()
    DrGHUD.RadarVehicleColor:Reset()
    DrGHUD.RadarWeaponColor:Reset()
  end)

  function DrGHUD.GetDispositionColor(disp)
    if disp == D_HT or disp == D_FR then
      return DrGHUD.EnemyColor.Value
    elseif disp == D_LI then
      return DrGHUD.AllyColor.Value
    else
      return DrGHUD.NeutralColor.Value
    end
  end

  -- Fonts --

  local function CreateFont(name, size)
    local scale = DrGHUD.Scale:GetFloat()
    surface.CreateFont(name, {
      size = (size/1080)*ScrH()*scale,
      weight = 1000
    })
  end

  local function CreateFonts()
    CreateFont("DrGHUD/Default", 15)
    CreateFont("DrGHUD/Compass", 18)
    CreateFont("DrGHUD/Humongous", 80)
  end

  CreateFonts()
  hook.Add("OnScreenSizeChanged", "DrGHUD/CreateFonts", CreateFonts)
  cvars.AddChangeCallback(DrGHUD.Scale:GetName(), CreateFonts)

  -- Util --

  DrGHUD.SpeedUnit = DrGBase.ClientConVar("drghud_speed_unit", "hu/s")
  function DrGHUD.ConvertSpeedUnits(speed)
    local unit = DrGHUD.SpeedUnit:GetString()
    if unit == "hu/s" then
      return speed
    elseif unit == "m/s" then
      return speed*0.01905
    elseif unit == "km/h" then
      return speed*0.06858
    elseif unit == "mph" then
      return speed*0.04261362318
    end
  end

end