if SERVER then
  util.AddNetworkString("DrGHUD/EntityDeath")

  local function SendToKillfeed(ent, attacker)
    for _, ply in pairs(player.GetHumans()) do
      local me = ply:DrG_GetPossessingOrSelf()
      net.Start("DrGHUD/EntityDeath")
      if ent:IsPlayer() then
        net.WriteString(ent:Nick())
        net.WriteBool(true)
      else
        net.WriteString(ent:GetClass())
        net.WriteBool(false)
      end
      net.WriteUInt(ent:DrG_GetDisposition(me), 3)
      if attacker:IsPlayer() then
        net.WriteString(attacker:Nick())
        net.WriteBool(true)
      else
        net.WriteString(attacker:GetClass())
        net.WriteBool(false)
      end
      net.WriteUInt(attacker:DrG_GetDisposition(me), 3)
      net.Send(ply)
    end
  end

  hook.Add("PlayerDeath", "DrGHUD/SendPlayerDeathToKillfeed", function(ply, _, attacker)
    SendToKillfeed(ply, attacker)
  end)

  hook.Add("OnNPCKilled", "DrGHUD/SendNPCDeathToKillfeed", function(npc, attacker)
    SendToKillfeed(npc, attacker)
  end)

else

  DrGHUD.KillfeedEnabled = DrGBase.ClientConVar("drghud_killfeed", "1")
  DrGHUD.KillfeedMaximum = DrGBase.ClientConVar("drghud_killfeed_maximum", "10")
  DrGHUD.KillfeedDuration = DrGBase.ClientConVar("drghud_killfeed_duration", "10")

  local KILLFEED = {}
  net.Receive("DrGHUD/EntityDeath", function()
    table.insert(KILLFEED, {
      ent = net.ReadString(),
      entPlayer = net.ReadBool(),
      entDisp = net.ReadUInt(3),
      attacker = net.ReadString(),
      attackerPlayer = net.ReadBool(),
      attackerDisp = net.ReadUInt(3),
      inflictor = net.ReadString()
    })
    timer.Simple(DrGHUD.KillfeedDuration:GetFloat(), function()
      table.remove(KILLFEED, 1)
    end)
  end)

  hook.Add("DrawDeathNotice", "DrGHUD/HideKillfeed", function()
    if DrGHUD.Enabled:GetBool() and DrGHUD.KillfeedEnabled:GetBool() then
      return false
    end
  end)

  hook.Add("DrGHUD/Paint", "DrGHUD/Killfeed", function()
    if not DrGHUD.KillfeedEnabled:GetBool() then return end
    if DrGHUD.RadarAllowed:GetBool() and DrGHUD.RadarEnabled:GetBool() then
      DrGHUD.SetOrigin(-23.5, 3 + 30*DrGHUD.RadarScale:GetFloat())
    else DrGHUD.SetOrigin(-23.5, 1) end
    for i = 1, math.min(#KILLFEED, DrGHUD.KillfeedMaximum:GetInt()) do
      local death = KILLFEED[i]
      DrGHUD.DrawWindow(22, 3, "right")
      DrGHUD.PrepareSquare(11, 1.5, 2)
      DrGHUD.Fill(DrGHUD.MainColor.Value, DrGHUD.DeathMaterial)
      if death.attackerPlayer then DrGHUD.DrawText(1, 0.75, death.attacker, {color = DrGHUD.GetDispositionColor(death.attackerDisp), maxLength = 8})
      else DrGHUD.DrawText(1, 0.75, language.GetPhrase(death.attacker), {color = DrGHUD.GetDispositionColor(death.attackerDisp), maxLength = 8}) end
      if death.entPlayer then DrGHUD.DrawText(21, 0.75, death.ent, {color = DrGHUD.GetDispositionColor(death.entDisp), xAlign = TEXT_ALIGN_RIGHT, maxLength = 8})
      else DrGHUD.DrawText(21, 0.75, language.GetPhrase(death.ent), {color = DrGHUD.GetDispositionColor(death.entDisp), xAlign = TEXT_ALIGN_RIGHT, maxLength = 8}) end
      local x, y = DrGHUD.GetOrigin()
      DrGHUD.SetOrigin(x, y + 4)
    end
  end)

end