DrGHUD.EntityInfoAllowed = DrGBase.ConVar("drghud_entity_info_allowed", "1")

if SERVER then
  util.AddNetworkString("DrGHUD/EntityInfo")

  hook.Add("Think", "DrGHUD/UpdateEntityInfo", function()
    if not DrGHUD.EntityInfoAllowed:GetBool() then return end
    for _, ply in ipairs(player.GetHumans()) do
      local ent = ply:GetEyeTraceNoCursor().Entity
      local me = ply:DrG_GetPossessingOrSelf()
      if not IsValid(ent) then continue end
      net.Start("DrGHUD/EntityInfo")
      net.WriteFloat(ent:Health())
      net.WriteFloat(ent:GetMaxHealth())
      net.WriteBool(DrGBase.IsTarget(ent))
      net.WriteUInt(ent:DrG_GetDisposition(me), 3)
      net.Send(ply)
    end
  end)

else

  DrGHUD.EntityInfoEnabled = DrGBase.ClientConVar("drghud_entity_info", "1")

  local HEALTH = 0
  local MAX_HEALTH = 0
  local IS_TARGET = false
  local DISPOSITION = D_ER
  net.Receive("DrGHUD/EntityInfo", function()
    HEALTH = net.ReadFloat()
    MAX_HEALTH = net.ReadFloat()
    IS_TARGET = net.ReadBool()
    DISPOSITION = net.ReadUInt(3)
  end)

  local function GetText(placeholder, ...)
    return DrGBase.GetText("drghud.entity_info."..placeholder, ...)
  end

  hook.Add("DrGHUD/Paint", "DrGHUD/EntityInfo", function()
    if not DrGHUD.EntityInfoAllowed:GetBool() then return end
    if not DrGHUD.EntityInfoEnabled:GetBool() then return end
    local ply = LocalPlayer()
    if ply:InVehicle() then return end
    local ent = ply:GetEyeTraceNoCursor().Entity
    if IsValid(ent) and ent ~= ply:DrG_GetPossessing() then
      DrGHUD.SetOrigin(1.5, 1)
      DrGHUD.DrawWindow(22, 8, "left")
      if ent:IsPlayer() then DrGHUD.DrawText(1, 1, ent:Nick(), {maxLength = 20})
      else DrGHUD.DrawText(1, 1, language.GetPhrase(ent:GetClass()), {maxLength = 20}) end
      DrGHUD.DrawText(1, 3, GetText("health"))
      DrGHUD.DrawText(21, 3, HEALTH.." / "..MAX_HEALTH, {xAlign = TEXT_ALIGN_RIGHT})
      local color = DrGHUD.GetDispositionColor(DISPOSITION)
      DrGHUD.DrawBar(1, 5, 20, 2, HEALTH, MAX_HEALTH, color)
    end
  end)

end