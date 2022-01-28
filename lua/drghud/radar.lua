DrGHUD.RadarAllowed = DrGBase.ConVar("drghud_radar_allowed", "1")
DrGHUD.RadarTickrate = DrGBase.ConVar("drghud_radar_tickrate", "10")
DrGHUD.RadarRange = DrGBase.ConVar("drghud_radar_range", "1500")
DrGHUD.RadarSweep = DrGBase.ConVar("drghud_radar_sweep", "1")
DrGHUD.CompassRotate = DrGBase.ConVar("drghud_compass_rotate", "0")

local function SweepEnabled()
  return DrGHUD.RadarSweep:GetFloat() >= 0
end

local function Sweep()
  return CurTime() % (DrGHUD.RadarSweep:GetFloat() + 1)
end

if SERVER then
  util.AddNetworkString("DrGHUD/PlayerDeath")
  util.AddNetworkString("DrGHUD/RadarData")

  hook.Add("PostPlayerDeath", "DrGHUD/SendDeathPosToRadar", function(ply)
    net.Start("DrGHUD/PlayerDeath")
    net.WriteVector(ply:GetPos())
    net.Send(ply)
  end)

  local function ShowOnRadar(ent)
    return DrGBase.IsTarget(ent) or ent:IsVehicle()
    or (ent:IsWeapon() and not IsValid(ent:GetOwner()))
  end

  local LAST_SWEEP = -1
  local LAST_UPDATE = 0
  local SENT_ENTITIES = {}
  hook.Add("Think", "DrGHUD/UpdateRadar", function()
    if not DrGHUD.RadarAllowed:GetBool() then return end
    local delay = 1/DrGHUD.RadarTickrate:GetFloat()
    if CurTime() < LAST_UPDATE + delay then return end
    LAST_UPDATE = CurTime()
    local entities = {}
    for _, ent in ipairs(ents.GetAll()) do
      if IsValid(ent) and ShowOnRadar(ent) then
        table.insert(entities, ent)
      end
    end
    local sweep = Sweep()
    local sweepEnabled = SweepEnabled()
    local range = DrGHUD.RadarRange:GetFloat()
    local sweepDist = (sweep/0.9)*range
    if sweep < LAST_SWEEP then
      SENT_ENTITIES = {}
    end LAST_SWEEP = sweep
    for _, ply in ipairs(player.GetHumans()) do
      local me = ply:DrG_GetPossessingOrSelf()
      local data = {}
      for _, ent in ipairs(entities) do
        if ent == ply or ent == me then continue end
        local dist = (me:GetPos()-ent:GetPos()):Length2D()
        if dist > range then continue end
        if sweepEnabled then
          if SENT_ENTITIES[ent] then continue end
          if dist > sweepDist then continue end
          SENT_ENTITIES[ent] = true
        end
        local entData = {}
        entData.InPVS = ply:TestPVS(ent)
        entData.Pos = ent:WorldSpaceCenter()
        entData.Disp = ent:DrG_GetDisposition(me)
        data[ent] = entData
      end
      net.Start("DrGHUD/RadarData")
      net.WriteUInt(table.Count(data), 32)
      for ent, entData in pairs(data) do
        net.WriteEntity(ent)
        net.WriteBool(entData.InPVS)
        net.WriteVector(entData.Pos)
        net.WriteUInt(entData.Disp, 3)
      end
      net.Send(ply)
    end
  end)

else

  DrGHUD.RadarEnabled = DrGBase.ClientConVar("drghud_radar", "1")
  DrGHUD.RadarScale = DrGBase.ClientConVar("drghud_radar_scale", "1")
  DrGHUD.RadarLastDeath = DrGBase.ConVar("drghud_radar_last_death", "1")
  DrGHUD.CompassEnabled = DrGBase.ClientConVar("drghud_compass", "1")
  DrGHUD.CompassNorthOnly = DrGBase.ClientConVar("drghud_compass_north_only", "0")

  local LAST_DEATH = nil
  net.Receive("DrGHUD/PlayerDeath", function()
    LAST_DEATH = {
      Pos = net.ReadVector(),
      Time = CurTime()
    }
  end)
  hook.Add("PostCleanupMap", "DrGHUD/ClearLastDeath", function()
    LAST_DEATH = nil
  end)

  local RADAR_DATA = {}
  net.Receive("DrGHUD/RadarData", function()
    for _ = 1, net.ReadUInt(32) do
      local ent = net.ReadEntity()
      RADAR_DATA[ent] = {
        InPVS = net.ReadBool(),
        Pos = net.ReadVector(),
        Disp = net.ReadUInt(3),
        LastUpdate = CurTime()
      }
    end
  end)

  local function GetCompassText(placeholder, ...)
    return DrGBase.GetText("drghud.compass."..placeholder, ...)
  end

  hook.Add("DrGHUD/Paint", "DrGHUD/Radar", function()
    if not DrGHUD.RadarAllowed:GetBool() then return end
    if not DrGHUD.RadarEnabled:GetBool() then return end
    local ply = LocalPlayer()
    local me = ply:DrG_GetPossessingOrSelf()
    local radius = 15*DrGHUD.RadarScale:GetFloat()
    local sweepEnabled = SweepEnabled()
    local sweep = Sweep()
    DrGHUD.SetOrigin(-radius - 1, radius + 1)
    DrGHUD.PrepareCircle(0, 0, radius, 80)
    DrGHUD.Fill(DrGHUD.Background)
    DrGHUD.Blur()
    DrGHUD.PrepareCirclePiece(0, 0, radius, 80, nil, 50, 70)
    DrGHUD.Fill(DrGHUD.Border)
    DrGHUD.Blur()
    DrGHUD.PrepareCircle(0, 0, radius, 80)
    DrGHUD.Stroke(DrGHUD.Border)
    DrGHUD.PrepareCircle(0, 0, radius/3*2, 80)
    DrGHUD.Stroke(DrGHUD.Border)
    DrGHUD.PrepareCircle(0, 0, radius/3, 80)
    DrGHUD.Stroke(DrGHUD.Border)
    if sweep >= 0 and sweep <= 1 then
      DrGHUD.PrepareCircle(0, 0, radius*sweep, 80)
      DrGHUD.Stroke(DrGHUD.Border)
    end
    -- util
    local eyes = EyeAngles()
    local myPos = me:GetPos()
    local function CalcAngle(pos)
      return math.AngleDifference((pos - myPos):Angle().y, eyes.y)
    end
    local function ToRadarCoords(pos)
      local range = DrGHUD.RadarRange:GetFloat()
      local dist = math.min((myPos-pos):Length2D(), range)
      local coords = Vector(radius*(dist/range)*0.9, 0)
      coords:Rotate(Angle(0, -CalcAngle(pos) - 90, 0))
      return coords.x, coords.y
    end
    -- entities
    for ent, data in pairs(RADAR_DATA) do
      if not IsValid(ent) then continue end
      local time = math.max(0, CurTime() - data.LastUpdate)
      if time > 1 and sweepEnabled then continue end
      local usePVS = data.InPVS and not sweepEnabled
      local entPos = usePVS and ent:WorldSpaceCenter() or data.Pos
      local heightDiff = entPos.z - EyePos().z
      local hitWorld, angle = util.TraceLine({
        start = EyePos(), endpos = entPos,
        filter = ply
      }).HitWorld, CalcAngle(entPos)
      local visible = not hitWorld and math.abs(angle) < 45
      local x, y = ToRadarCoords(entPos)
      if ent:IsVehicle() then
        -- todo
      elseif ent:IsWeapon() then
        -- todo
      else
        local color = DrGHUD.GetDispositionColor(data.Disp)
        if sweepEnabled then color.a = (1 - time)*255 end
        if heightDiff > 100 then DrGHUD.PrepareTriangle(x, y, 0.6, -90)
        elseif heightDiff < -100 then DrGHUD.PrepareTriangle(x, y, 0.6, 90)
        else DrGHUD.PrepareDiamond(x, y, 0.6) end
        if visible then DrGHUD.Fill(color)
        else DrGHUD.Stroke(color) end
        color.a = 255
      end
    end
    -- compass
    if DrGHUD.CompassEnabled:GetBool() then
      local rotate = DrGHUD.CompassRotate:GetFloat()
      local north = Vector(999999999, 0)
      north:Rotate(Angle(0, -rotate, 0))
      local northX, northY = ToRadarCoords(north)
      DrGHUD.DrawText(northX, northY, GetCompassText("north"), {
        font = "DrGHUD/Compass",
        xAlign = TEXT_ALIGN_CENTER,
        yAlign = TEXT_ALIGN_CENTER
      })
      if not DrGHUD.CompassNorthOnly:GetBool() then
        local south = -north
        local southX, southY = ToRadarCoords(south)
        DrGHUD.DrawText(southX, southY, GetCompassText("south"), {
          font = "DrGHUD/Compass",
          xAlign = TEXT_ALIGN_CENTER,
          yAlign = TEXT_ALIGN_CENTER
        })
        local west = Vector(0, 999999999)
        west:Rotate(Angle(0, -rotate, 0))
        local westX, westY = ToRadarCoords(west)
        DrGHUD.DrawText(westX, westY, GetCompassText("west"), {
          font = "DrGHUD/Compass",
          xAlign = TEXT_ALIGN_CENTER,
          yAlign = TEXT_ALIGN_CENTER
        })
        local east = -west
        local eastX, eastY = ToRadarCoords(east)
        DrGHUD.DrawText(eastX, eastY, GetCompassText("east"), {
          font = "DrGHUD/Compass",
          xAlign = TEXT_ALIGN_CENTER,
          yAlign = TEXT_ALIGN_CENTER
        })
      end
      -- last death
      if LAST_DEATH and DrGHUD.RadarLastDeath:GetBool() then
        local x, y = ToRadarCoords(LAST_DEATH.Pos)
        DrGHUD.PrepareSquare(x, y, 1.5)
        DrGHUD.Fill(DrGHUD.MainColor.Value, DrGHUD.DeathMaterial)
      end
      -- draw center
      DrGHUD.PrepareDiamond(0, 0, 0.6)
      DrGHUD.Fill(DrGHUD.MainColor.Value)
    end
  end)

end

