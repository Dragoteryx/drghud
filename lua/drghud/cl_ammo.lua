DrGHUD.AmmoEnabled = DrGBase.ClientConVar("drghud_ammo", "1")

hook.Add("DrGHUD/ShouldDraw", "DrGHUD/HideAmmo", function(name)
  if not DrGHUD.AmmoEnabled:GetBool() then return end
  if name == "CHudAmmo" or name == "CHudSecondaryAmmo" then return false end
end)

hook.Add("DrGHUD/Paint", "DrGHUD/Ammo", function()
  if not DrGHUD.AmmoEnabled:GetBool() then return end
  if not LocalPlayer():Alive() then return end
  local ply = LocalPlayer()
  if ply:InVehicle() then return end
  local wep = ply:GetActiveWeapon()
  if IsValid(wep) then
    DrGHUD.SetOrigin(-23.5, -12)
    DrGHUD.DrawWindow(22, 11, "right")
    DrGHUD.DrawText(1, 0.635, wep:GetPrintName(), {maxLength = 20})
    DrGHUD.DrawLine(0, 2.5, 22, 2.5)

    for i = 1, 2 do
      local pieX, pieY, pieR, textX, textY
      local ammo, clipsize, ammoType, color
      if i == 1 then
        pieX, pieY, pieR = 4, 6.75, 3
        textX, textY = 8, 3.5
        ammo = wep:Clip1()
        clipsize = wep:GetMaxClip1()
        ammoType = wep:GetPrimaryAmmoType()
        color = DrGHUD.AmmoColor.Value
      else
        pieX, pieY, pieR = 10, 8, 2
        textX, textY = 13, 6.5
        ammo = wep:Clip2()
        clipsize = wep:GetMaxClip2()
        ammoType = wep:GetSecondaryAmmoType()
        color = DrGHUD.Ammo2Color.Value
      end
      local ammoCount = ply:GetAmmoCount(ammoType)
      if clipsize > 0 then
        DrGHUD.DrawText(textX, textY, ammo.." / "..clipsize.." | "..ammoCount, {color = color})
        DrGHUD.DrawPie(pieX, pieY, pieR, ammo, clipsize, color)
      elseif ammoType ~= -1 then
        DrGHUD.DrawText(textX, textY, ammoCount.." remaining", {color = color})
        DrGHUD.PrepareHexagon(pieX, pieY, pieR)
        if ammoCount <= 0 then
          DrGHUD.Fill(DrGHUD.Background)
          DrGHUD.Stroke(DrGHUD.Border)
        else DrGHUD.Fill(color) end
      elseif i == 1 then
        DrGHUD.DrawText(4, 6.5, "∞", {
          color = color, font = "DrGHUD/Humongous",
          xAlign = TEXT_ALIGN_CENTER,
          yAlign = TEXT_ALIGN_CENTER
        })
      end
    end
  end
end)