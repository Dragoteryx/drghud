DrGHUD.StatusEnabled = DrGBase.ClientConVar("drghud_status", "1")
DrGHUD.StatusEffects = DrGBase.ClientConVar("drghud_status_effects", "1")
DrGHUD.StatusInfoEnabled = DrGBase.ClientConVar("drghud_status_info", "1")

local function GetText(placeholder, ...)
  return DrGBase.GetText("drghud.status."..placeholder, ...)
end

hook.Add("DrGHUD/ShouldDraw", "DrGHUD/HideStatus", function(name)
  if not DrGHUD.StatusEnabled:GetBool() then return end
  if name == "CHudHealth" or name == "CHudBattery"
  or name == "CHudPoisonDamageIndicator" then
    return false
  end
end)

local FPS = -1
local LAST_FPS_REFRESH = 0
hook.Add("Think", "DrGHUD/StatusInfoFPS", function()
  if CurTime() < LAST_FPS_REFRESH + 0.25 then return end
  FPS = math.Round(1 / FrameTime())
  LAST_FPS_REFRESH = CurTime()
end)

local function DrawHealthBar(me)
  local health = me:Health()
  local maxHealth = me:GetMaxHealth()
  DrGHUD.DrawText(1, 1, GetText("health"))
  DrGHUD.DrawText(21, 1, health.." / "..maxHealth, {xAlign = TEXT_ALIGN_RIGHT})
  local fullHealth = DrGHUD.FullHealthColor.Value
  local lowHealth = DrGHUD.LowHealthColor.Value
  local healthRatio = math.Clamp(health/maxHealth, 0, 1)
  DrGHUD.DrawBar(1, 3, 20, 2, health, maxHealth, Color(
    Lerp(healthRatio, lowHealth.r, fullHealth.r),
    Lerp(healthRatio, lowHealth.g, fullHealth.g),
    Lerp(healthRatio, lowHealth.b, fullHealth.b)
  ))
end

local function DrawPerfInfo(me)
  if not DrGHUD.StatusInfoEnabled:GetBool() then return end
  local veh = me:IsPlayer() and me:DrG_GetVehicle() or NULL
  local ply = LocalPlayer()
  DrGHUD.DrawWindow(22, 3, "left")

  local speed
  if IsValid(veh) then speed = veh:GetVelocity():Length()
  else speed = me:GetVelocity():Length() end
  local converted = DrGHUD.ConvertSpeedUnits(speed)
  local text = "???????"
  if converted then
    local unit = DrGHUD.SpeedUnit:GetString()
    text = math.Round(converted).." "..unit
  end
  if IsValid(veh) then
    local icon = DrGHUD.GetVehicleIcon(veh)
    DrGHUD.PrepareSquare(1.5, 1.6, 2)
    DrGHUD.Fill(DrGHUD.MainColor.Value, icon)
  else
    DrGHUD.PrepareSquare(1.5, 1.5, 2)
    DrGHUD.Fill(DrGHUD.MainColor.Value, DrGHUD.SpeedIcon)
  end
  DrGHUD.DrawText(8, 1, text, {xAlign = TEXT_ALIGN_RIGHT})
  DrGHUD.DrawLine(9, 0, 9, 3)

  DrGHUD.PrepareSquare(10.5, 1.55, 1.8)
  DrGHUD.Fill(DrGHUD.MainColor.Value, DrGHUD.FPSIcon)
  DrGHUD.DrawText(14.5, 1, FPS, {xAlign = TEXT_ALIGN_RIGHT})
  DrGHUD.DrawLine(15.5, 0, 15.5, 3)

  local ping = math.Round(ply:Ping())
  DrGHUD.PrepareSquare(17.2, 1.6, 2.3)
  DrGHUD.Fill(DrGHUD.MainColor.Value, DrGHUD.PingIcon)
  DrGHUD.DrawText(21, 1, ping, {xAlign = TEXT_ALIGN_RIGHT})
end

hook.Add("DrGHUD/Paint", "DrGHUD/Status", function()
  if not DrGHUD.StatusEnabled:GetBool() then return end
  if not LocalPlayer():Alive() then return end
  local ply = LocalPlayer()
  if ply:DrG_IsPossessing() then
    local nb = ply:DrG_GetPossessing()
    DrGHUD.SetOrigin(1.5, -7)
    DrGHUD.DrawWindow(22, 6, "left")
    DrawHealthBar(nb)

    DrGHUD.SetOrigin(1.5, -11)
    DrawPerfInfo(nb)
  else
    DrGHUD.SetOrigin(1.5, -12)
    DrGHUD.DrawWindow(22, 11, "left")
    DrawHealthBar(ply)

    local armor = ply:Armor()
    local maxArmor = ply:GetMaxArmor()
    DrGHUD.DrawText(1, 6, GetText("armor"))
    DrGHUD.DrawText(21, 6, armor.." / "..maxArmor, {xAlign = TEXT_ALIGN_RIGHT})
    DrGHUD.DrawBar(1, 8, 20, 2, armor, maxArmor, DrGHUD.ArmorColor.Value)

    DrGHUD.SetOrigin(1.5, -16)
    DrawPerfInfo(ply)
  end
end)