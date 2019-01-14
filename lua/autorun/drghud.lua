
DrGHUD = DrGHUD or {}
DrGHUD.AllowEntityInfo = CreateConVar("drghud_allow_entityinfo", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED})
DrGHUD.AllowRadar = CreateConVar("drghud_allow_radar", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED})
DrGHUD.RadarRange = CreateConVar("drghud_radar_range", "500", {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED})
DrGHUD.RadarDeath = CreateConVar("drghud_radar_death", "-1", {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED})
DrGHUD.CompassRotate = CreateConVar("drghud_compass_rotate", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED})

DRGHUD_IGNORE = -1
DRGHUD_NEUTRAL = 0
DRGHUD_ALLY = 1
DRGHUD_ENEMY = 2
DRGHUD_WEAPON = 3
DRGHUD_ITEM = 4
DRGHUD_VEHICLE = 5

DRGHUD_TYPE_DEFAULT = 0
DRGHUD_TYPE_MATERIAL = 1
DRGHUD_TYPE_TEXT = 2

if CLIENT then
  local ply

  DrGHUD.Enable = CreateClientConVar("drghud", "1")
  DrGHUD.Scale = CreateClientConVar("drghud_scale", "1")
  DrGHUD.Blur = CreateClientConVar("drghud_blur", "3")
  DrGHUD.Zoom = CreateClientConVar("drghud_zoom", "1")

  DrGHUD.Status = CreateClientConVar("drghud_status", "1")
  DrGHUD.StatusEffects = CreateClientConVar("drghud_status_effects", "1")
  DrGHUD.Info = CreateClientConVar("drghud_info", "1")
  DrGHUD.EntityInfo = CreateClientConVar("drghud_entityinfo", "1")
  DrGHUD.Ammo = CreateClientConVar("drghud_ammo", "1")
  DrGHUD.Weapons = CreateClientConVar("drghud_weapons", "0")
  DrGHUD.Vehicle = CreateClientConVar("drghud_vehicles", "0")

  DrGHUD.Radar = CreateClientConVar("drghud_radar", "1")
  DrGHUD.RadarScale = CreateClientConVar("drghud_radar_scale", "1")
  DrGHUD.Compass = CreateClientConVar("drghud_compass", "1")
  DrGHUD.CompassNorthOnly = CreateClientConVar("drghud_compass_north_only", "0")

  DrGHUD.Crosshair = CreateClientConVar("drghud_crosshair", "1")
  DrGHUD.CrosshairColorChange = CreateClientConVar("drghud_crosshair_color_change", "1")
  DrGHUD.CrosshairCenter = CreateClientConVar("drghud_crosshair_center", "1")
  DrGHUD.CrosshairCenterSize = CreateClientConVar("drghud_crosshair_center_size", "1")
  DrGHUD.CrosshairCenterFull = CreateClientConVar("drghud_crosshair_center_full", "1")
  DrGHUD.CrosshairCenterR = CreateClientConVar("drghud_crosshair_center_r", "200")
  DrGHUD.CrosshairCenterG = CreateClientConVar("drghud_crosshair_center_g", "200")
  DrGHUD.CrosshairCenterB = CreateClientConVar("drghud_crosshair_center_b", "200")
  DrGHUD.CrosshairCenterA = CreateClientConVar("drghud_crosshair_center_a", "200")
  DrGHUD.CrosshairSides = CreateClientConVar("drghud_crosshair_sides", "0")
  DrGHUD.CrosshairSidesSize = CreateClientConVar("drghud_crosshair_sides_size", "1")
  DrGHUD.CrosshairSidesOffset = CreateClientConVar("drghud_crosshair_sides_rotation", "0")
  DrGHUD.CrosshairSidesDistance = CreateClientConVar("drghud_crosshair_sides_distance", "1")
  DrGHUD.CrosshairSidesFull = CreateClientConVar("drghud_crosshair_sides_full", "1")
  DrGHUD.CrosshairSidesR = CreateClientConVar("drghud_crosshair_sides_r", "200")
  DrGHUD.CrosshairSidesG = CreateClientConVar("drghud_crosshair_sides_g", "200")
  DrGHUD.CrosshairSidesB = CreateClientConVar("drghud_crosshair_sides_b", "200")
  DrGHUD.CrosshairSidesA = CreateClientConVar("drghud_crosshair_sides_a", "200")

  DrGHUD.MainColorR = CreateClientConVar("drghud_main_r", "200")
  DrGHUD.MainColorG = CreateClientConVar("drghud_main_g", "200")
  DrGHUD.MainColorB = CreateClientConVar("drghud_main_b", "200")

  DrGHUD.HealthR = CreateClientConVar("drghud_health_r", "150")
  DrGHUD.HealthG = CreateClientConVar("drghud_health_g", "255")
  DrGHUD.HealthB = CreateClientConVar("drghud_health_b", "40")

  DrGHUD.DamageR = CreateClientConVar("drghud_damage_r", "255")
  DrGHUD.DamageG = CreateClientConVar("drghud_damage_g", "50")
  DrGHUD.DamageB = CreateClientConVar("drghud_damage_b", "50")

  DrGHUD.ArmorR = CreateClientConVar("drghud_armor_r", "230")
  DrGHUD.ArmorG = CreateClientConVar("drghud_armor_g", "100")
  DrGHUD.ArmorB = CreateClientConVar("drghud_armor_b", "35")

  DrGHUD.AmmoR = CreateClientConVar("drghud_ammo_r", "200")
  DrGHUD.AmmoG = CreateClientConVar("drghud_ammo_g", "200")
  DrGHUD.AmmoB = CreateClientConVar("drghud_ammo_b", "200")

  DrGHUD.SecAmmoR = CreateClientConVar("drghud_secammo_r", "230")
  DrGHUD.SecAmmoG = CreateClientConVar("drghud_secammo_g", "100")
  DrGHUD.SecAmmoB = CreateClientConVar("drghud_secammo_b", "35")

  DrGHUD.RadarNeutralR = CreateClientConVar("drghud_radar_neutral_r", "200")
  DrGHUD.RadarNeutralG = CreateClientConVar("drghud_radar_neutral_g", "200")
  DrGHUD.RadarNeutralB = CreateClientConVar("drghud_radar_neutral_b", "200")

  DrGHUD.RadarAllyR = CreateClientConVar("drghud_radar_ally_r", "150")
  DrGHUD.RadarAllyG = CreateClientConVar("drghud_radar_ally_g", "255")
  DrGHUD.RadarAllyB = CreateClientConVar("drghud_radar_ally_b", "40")

  DrGHUD.RadarEnemyR = CreateClientConVar("drghud_radar_enemy_r", "255")
  DrGHUD.RadarEnemyG = CreateClientConVar("drghud_radar_enemy_g", "50")
  DrGHUD.RadarEnemyB = CreateClientConVar("drghud_radar_enemy_b", "50")

  DrGHUD.RadarWeaponR = CreateClientConVar("drghud_radar_weapon_r", "230")
  DrGHUD.RadarWeaponG = CreateClientConVar("drghud_radar_weapon_g", "100")
  DrGHUD.RadarWeaponB = CreateClientConVar("drghud_radar_weapon_b", "35")

  DrGHUD.RadarVehicleR = CreateClientConVar("drghud_radar_vehicle_r", "230")
  DrGHUD.RadarVehicleG = CreateClientConVar("drghud_radar_vehicle_g", "100")
  DrGHUD.RadarVehicleB = CreateClientConVar("drghud_radar_vehicle_b", "35")

  -- globals
  local radar = {}
  local statusEffectDuration = 3
  local lastDamage = 0
  local lastBurn = 0
  local lastRadiation = 0
  local lastPoison = 0
  local lastDeathTime = 0
  local lastDeathPos
  local infoRefreshDelay = 0
  local ping = -1
  local fps = -1

  -- scale globals
  local scale
  local scrHeight
  local scrWidth
  local distance
  local larg
  local long
  local ecart
  local ep
  local function RefreshScale()
    scale = DrGHUD.Scale:GetFloat()
    scrHeight = ScrH()
    scrWidth = ScrW()
    distance = scrWidth/75
    larg = (scrHeight/8)*scale
    long = larg*2.5
    ecart = larg/10
    ep = ecart/2
    surface.CreateFont("DrGHUDFontFat", {
      size = larg,
      weight = 600
    })
    surface.CreateFont("DrGHUDFont", {
      size = ecart*1.5,
      weight = 600
    })
  end

  -- materials
  local materials = {
    ["drghud_death"] = Material("drghud/death.png")
  }
  local blur = Material("pp/blurscreen")
  local fire_on = Material("drghud/fire_on.png")
  local fire_off = Material("drghud/fire_off.png")
  local rad_on = Material("drghud/radiation_on.png")
  local rad_off = Material("drghud/radiation_off.png")
  local poison_on = Material("drghud/poison_on.png")
  local poison_off = Material("drghud/poison_off.png")
  function DrGHUD.DefineMaterial(name, path, force)
    if string.StartWith(name, "drghud") then return false end
    if materials[name] ~= nil and not force then return false end
    materials[name] = Material(path)
    return true
  end
  function DrGHUD.PickMaterial(name)
    return materials[name]
  end

  local colors = {}
  function DrGHUD.PickColor(name)
    return colors[name]
  end

  local names = {
    ["weapon_crowbar"] = "Crowbar",
    ["weapon_ar2"] = "AR2",
    ["weapon_357"] = ".357 Magnum",
    ["weapon_pistol"] = "9mm Pistol",
    ["weapon_smg1"] = "SMG",
    ["weapon_slam"] = "SLAM",
    ["weapon_rpg"] = "RPG",
    ["weapon_stunstick"] = "Stunstick",
    ["weapon_frag"] = "Grenade",
    ["weapon_shotgun"] = "Shotgun",
    ["weapon_bugbait"] = "Bug Bait",
    ["weapon_physcannon"] = "Gravity Gun",
    ["weapon_physgun"] = "Physics Gun",
    ["gmod_tool"] = "Tool Gun",
    ["weapon_camera"] = "Camera",
    ["weapon_crossbow"] = "Crossbow",
    ["weapon_hands"] = "None",
    ["hands"] = "None"
  }
  function DrGHUD.WeaponName(weapon)
    return weapon.PrintName or names[weapon:GetClass()] or weapon:GetClass()
  end

  -- beacons
  local beacons = {}
  function DrGHUD.DefineBeacon(name, pos, color)
    DrGHUD.RemoveBeacon(name)
    table.insert(beacons, {
      type = DRGHUD_TYPE_TEXT,
      text = name,
      pos = pos,
      color = color or DrGHUD.PickColor("main"),
      outside = true
    })
  end
  function DrGHUD.RemoveBeacon(name)
    local beacons2 = {}
    for i, beacon in ipairs(beacons) do
      if beacon.text ~= name then table.insert(beacons2, beacon) end
    end
    beacons = beacons2
  end

  hook.Add("Think", "DrGHUDThink", function()
    if scale ~= DrGHUD.Scale:GetFloat() or scrHeight ~= ScrH() or scrWidth ~= ScrW() then
      RefreshScale()
    end
    if CurTime() > infoRefreshDelay then
      infoRefreshDelay = CurTime() + 1
      fps = 1/RealFrameTime()
      ping = LocalPlayer():Ping()
    end
    if IsValid(LocalPlayer()) and not ply then
      ply = LocalPlayer()
    end
    colors = {
      [DRGHUD_IGNORE] = Color(0, 0, 0, 0),
      ["white"] = Color(255, 255, 255, 200),
      ["background"] = Color(0, 0, 0, 50),
      ["dark"] = Color(0, 0, 0, 125),
      ["border"] = Color(100, 100, 100, 25),
      ["main"] = Color(
        DrGHUD.MainColorR:GetInt(),
        DrGHUD.MainColorG:GetInt(),
        DrGHUD.MainColorB:GetInt(),
        200
      ),
      ["health"] = Color(
        DrGHUD.HealthR:GetInt(),
        DrGHUD.HealthG:GetInt(),
        DrGHUD.HealthB:GetInt(),
        200
      ),
      ["damage"] = Color(
        DrGHUD.DamageR:GetInt(),
        DrGHUD.DamageG:GetInt(),
        DrGHUD.DamageB:GetInt(),
        200
      ),
      ["armor"] = Color(
        DrGHUD.ArmorR:GetInt(),
        DrGHUD.ArmorG:GetInt(),
        DrGHUD.ArmorB:GetInt(),
        200
      ),
      ["ammo"] = Color(
        DrGHUD.AmmoR:GetInt(),
        DrGHUD.AmmoG:GetInt(),
        DrGHUD.AmmoB:GetInt(),
        200
      ),
      ["secammo"] = Color(
        DrGHUD.SecAmmoR:GetInt(),
        DrGHUD.SecAmmoG:GetInt(),
        DrGHUD.SecAmmoB:GetInt(),
        200
      ),
      ["crosshairCenter"] = Color(
        DrGHUD.CrosshairCenterR:GetInt(),
        DrGHUD.CrosshairCenterG:GetInt(),
        DrGHUD.CrosshairCenterB:GetInt(),
        DrGHUD.CrosshairCenterA:GetInt()
      ),
      ["crosshairSides"] = Color(
        DrGHUD.CrosshairSidesR:GetInt(),
        DrGHUD.CrosshairSidesG:GetInt(),
        DrGHUD.CrosshairSidesB:GetInt(),
        DrGHUD.CrosshairSidesA:GetInt()
      ),
      [DRGHUD_NEUTRAL] = Color(
        DrGHUD.RadarNeutralR:GetInt(),
        DrGHUD.RadarNeutralG:GetInt(),
        DrGHUD.RadarNeutralB:GetInt(),
        200
      ),
      [DRGHUD_ALLY] = Color(
        DrGHUD.RadarAllyR:GetInt(),
        DrGHUD.RadarAllyG:GetInt(),
        DrGHUD.RadarAllyB:GetInt(),
        200
      ),
      [DRGHUD_ENEMY] = Color(
        DrGHUD.RadarEnemyR:GetInt(),
        DrGHUD.RadarEnemyG:GetInt(),
        DrGHUD.RadarEnemyB:GetInt(),
        200
      ),
      [DRGHUD_WEAPON] = Color(
        DrGHUD.RadarWeaponR:GetInt(),
        DrGHUD.RadarWeaponG:GetInt(),
        DrGHUD.RadarWeaponB:GetInt(),
        200
      ),
      [DRGHUD_VEHICLE] = Color(
        DrGHUD.RadarVehicleR:GetInt(),
        DrGHUD.RadarVehicleG:GetInt(),
        DrGHUD.RadarVehicleB:GetInt(),
        200
      ),
      [DRGHUD_ITEM] = Color(200, 200, 200, 200)
    }
  end)

  function DrGHUD.GetCirclePoints(x, y, radius, nb, offset)
    nb = nb or 256
    offset = offset or 0
    local theta = math.rad(360/nb)
    local points = {}
    for i = 0, nb-1 do
      local a = theta*i+math.rad(offset)
      table.insert(points, {
        x = x + radius*math.cos(a),
        y = y + radius*math.sin(a),
        u = math.cos(a)/2 + 0.5,
        v = math.sin(a)/2 + 0.5
      })
    end
    return points
  end

  function DrGHUD.DrawPoly(points, color, border, options)
    options = options or {}
    draw.NoTexture()
    if options.material then
      surface.SetDrawColor(color or DrGHUD.PickColor("white"))
      surface.SetMaterial(options.material)
      surface.DrawPoly(points)
    elseif color then
      surface.SetDrawColor(color)
      surface.DrawPoly(points)
    end
    draw.NoTexture()
    if options.blur then
      for _, point in pairs(points) do
        point.u = point.x/scrWidth
        point.v = point.y/scrHeight
      end
      surface.SetDrawColor(255, 255, 255, 255)
      surface.SetMaterial(blur)
      for i = 1, DrGHUD.Blur:GetInt() do
        blur:SetFloat("$blur", (i/3)*(25/DrGHUD.Blur:GetInt()))
        blur:Recompute()
        render.UpdateScreenEffectTexture()
        surface.DrawPoly(points)
      end
    end
    if border then
      surface.SetDrawColor(border)
      for i = 1, #points do
        local h = i+1
        if h == #points+1 then h = 1 end
        surface.DrawLine(points[i].x, points[i].y, points[h].x, points[h].y)
      end
    end
  end

  function DrGHUD.DrawRect(x, y, width, height, color, border, options)
    DrGHUD.DrawPoly({
      {x = x, y = y, u = 0, v = 0},
      {x = x+width, y = y, u = 1, v = 0},
      {x = x+width, y = y+height, u = 1, v = 1},
      {x = x, y = y+height, u = 0, v = 1}
    }, color, border, options)
  end

  function DrGHUD.DrawSquare(x, y, length, color, border, options)
    DrGHUD.DrawRect(x, y, length, length, color, border, options)
  end

  function DrGHUD.DrawMaterial(x, y, length, material, color)
    DrGHUD.DrawSquare(x, y, length, color, nil, {material = material})
  end

  function DrGHUD.DrawDiamond(x, y, size, color, border, options)
    DrGHUD.DrawCircle(x, y, size, 4, color, border, options)
  end

  function DrGHUD.DrawCircle(x, y, radius, nb, color, border, options)
    options = options or {}
    if nb < 3 then return end
    if nb > 256 then nb = 256 end
    DrGHUD.DrawPoly(DrGHUD.GetCirclePoints(x, y, radius, nb, options.offset), color, border, options)
  end

  function DrGHUD.DrawTriangle(x, y, size, color, border, options)
    options = options or {}
    options.offset = options.offset or 0
    options.offset = options.offset + 90
    DrGHUD.DrawCircle(x, y, size, 3, color, border, options)
  end

  function DrGHUD.DrawBackground(x, y, width, height, bars)
    DrGHUD.DrawRect(x, y, width, height, DrGHUD.PickColor("background"), DrGHUD.PickColor("border"), {blur = true})
    if bars ~= nil then
      if type(bars) == "string" then bars = {bars} end
      for _, bar in pairs(bars) do
        if bar == "left" then DrGHUD.DrawRect(x, y, ep, height, DrGHUD.PickColor("main"))
        elseif bar == "top" then DrGHUD.DrawRect(x, y, width, ep, DrGHUD.PickColor("main"))
        elseif bar == "right" then DrGHUD.DrawRect(x+width-ep, y, ep, height, DrGHUD.PickColor("main"))
        elseif bar == "bottom" then DrGHUD.DrawRect(x, y+height-ep, width, ep, DrGHUD.PickColor("main")) end
      end
    end
  end

  function DrGHUD.DrawBar(x, y, long, larg, name, value, maxvalue, color, blur)
    local strvalue = value
    if value > maxvalue then value = maxvalue end
    DrGHUD.DrawRect(x, y + ecart*1.5, long, larg, DrGHUD.PickColor("dark"), nil, {blur = blur or false})
    if value > 0 and maxvalue > 0 then
      DrGHUD.DrawRect(x, y + ecart*1.5, long*(value/maxvalue), larg, color)
      DrGHUD.DrawRect(x, y + ecart*1.5+ larg/2, long*(value/maxvalue), larg/2, DrGHUD.PickColor("dark"))
    end
    DrGHUD.DrawRect(x, y + ecart*1.5, long, larg, nil, DrGHUD.PickColor("border"))
    DrGHUD.DrawText(x, y, name.."  |  "..strvalue.." / " ..maxvalue, "DrGHUDFont", DrGHUD.PickColor("main"))
  end

  function DrGHUD.DrawPie(x, y, radius, value, maxvalue, color, options)
    value = math.floor(value)
    maxvalue = math.floor(maxvalue)
    options = options or {}
    if maxvalue < 1 then return end
    if value < 0 then value = 0 end
    if value > maxvalue then value = maxvalue end
    local critical = 100
    if maxvalue > critical then
      value = math.ceil(value*(critical/maxvalue))
      maxvalue = critical
    end
    if maxvalue == 1 then
      local approx = 6
      if value > 0 then
        DrGHUD.DrawCircle(x, y, radius, approx, color, DrGHUD.PickColor("border"), options)
      else DrGHUD.DrawCircle(x, y, radius, approx, DrGHUD.PickColor("dark"), DrGHUD.PickColor("border"), options) end
    else
      local points
      if maxvalue == 2 then points = DrGHUD.GetCirclePoints(x, y, radius, 4, options.offset)
      elseif maxvalue == 3 then points = DrGHUD.GetCirclePoints(x, y, radius, 6, options.offset)
      else points = DrGHUD.GetCirclePoints(x, y, radius, maxvalue, options.offset) end
      for i = 1, #points do
        if not options.reverse then
          if maxvalue < 4 then
            if i > value*2 then surface.SetDrawColor(DrGHUD.PickColor("dark"))
            else surface.SetDrawColor(color) end
          else
            if i > value then surface.SetDrawColor(DrGHUD.PickColor("dark"))
            else surface.SetDrawColor(color) end
          end
        else
          if maxvalue < 4 then
            if i > maxvalue-(value*2) then surface.SetDrawColor(color)
            else surface.SetDrawColor(DrGHUD.PickColor("dark")) end
          else
            if i > maxvalue-(value) then surface.SetDrawColor(color)
            else surface.SetDrawColor(DrGHUD.PickColor("dark")) end
          end
        end
        draw.NoTexture()
        local h = i+1
        if i == #points then h = 1 end
        surface.DrawPoly({{x = x, y = y}, points[i], points[h]})
        surface.SetDrawColor(DrGHUD.PickColor("border"))
        surface.DrawLine(points[i].x, points[i].y, points[h].x, points[h].y)
      end
    end
  end

  function DrGHUD.DrawText(x, y, text, font, color, outlinewidth, outlinecolor, options)
    options = options or {}
    surface.SetFont(font)
    if options.maxlength ~= nil and surface.GetTextSize(text) > options.maxlength then return false end
    if outlinewidth ~= nil then
      return draw.SimpleTextOutlined(text, font, x, y, color, options.xAlign, options.yAlign, outlinewidth, outlinecolor or DrGHUD.PickColor("main"))
    else return draw.SimpleText(text, font, x, y, color, options.xAlign, options.yAlign) end
  end

  hook.Add("HUDPaint", "DrGHUDPaint", function()
    if scrHeight == nil or scrWidth == nil then return end
    if not DrGHUD.Enable:GetBool() or not GetConVar("cl_drawhud"):GetBool() then return end
    if not IsValid(ply) or not ply:Alive() then return end
    local tr = ply:GetEyeTraceNoCursor()
    local ent
    local entIcon = {}
    if IsValid(tr.Entity) then
      ent = tr.Entity
      for i, icon in ipairs(radar) do
        if icon.entIndex ~= ent:EntIndex() then continue end
        entIcon = icon
        break
      end
    end
    local possessing = DrGBase ~= nil and IsValid(DrGBase.Nextbot.Possessing(ply))
    local vehicle = ply:InVehicle()
    -- crosshair
    if DrGHUD.Crosshair:GetBool() and GetConVar("crosshair"):GetBool() and not ply:InVehicle() and not possessing then
      local x = scrWidth/2
      local y = scrHeight/2
      local color
      if IsValid(ent) and DrGHUD.CrosshairColorChange:GetBool() then
        if entIcon.rel == DRGHUD_ALLY then
          color = DrGHUD.PickColor(DRGHUD_ALLY)
        elseif entIcon.rel == DRGHUD_ENEMY then
          color = DrGHUD.PickColor(DRGHUD_ENEMY)
        end
      end
      if DrGHUD.CrosshairCenter:GetBool() then
        if DrGHUD.CrosshairCenterFull:GetBool() then
          DrGHUD.DrawCircle(x, y, ep/2*DrGHUD.CrosshairCenterSize:GetFloat(), 8, color or DrGHUD.PickColor("crosshairCenter"), color or DrGHUD.PickColor("crosshairCenter"))
        else
          DrGHUD.DrawCircle(x, y, ep/2*DrGHUD.CrosshairCenterSize:GetFloat(), 8, nil, color or DrGHUD.PickColor("crosshairCenter"))
        end
      end
      if DrGHUD.CrosshairSides:GetInt() > 0 then
        local points = DrGHUD.GetCirclePoints(x, y, ep*DrGHUD.CrosshairSidesDistance:GetFloat()*1.5, DrGHUD.CrosshairSides:GetInt(), DrGHUD.CrosshairSidesOffset:GetFloat() - 90)
        for i, point in ipairs(points) do
          if DrGHUD.CrosshairSidesFull:GetBool() then
            DrGHUD.DrawCircle(point.x, point.y, ep/2*DrGHUD.CrosshairSidesSize:GetFloat(), 8, color or DrGHUD.PickColor("crosshairSides"), color or DrGHUD.PickColor("crosshairSides"))
          else
            DrGHUD.DrawCircle(point.x, point.y, ep/2*DrGHUD.CrosshairSidesSize:GetFloat(), 8, nil, color or DrGHUD.PickColor("crosshairSides"))
          end
        end
      end
    end
    -- status
    if DrGHUD.Status:GetBool() then
      local x = distance
      local y = scrHeight - larg - distance
      DrGHUD.DrawBackground(x, y, long, larg, "left")
      local health = ply:Health()
      local maxhealth = ply:GetMaxHealth()
      if possessing then
        health = DrGBase.Nextbot.Possessing(ply):Health()
        maxhealth = DrGBase.Nextbot.Possessing(ply):GetMaxHealth()
      else DrGHUD.DrawBar(x + ecart*1.25, y + larg/2, long - ecart*2, larg/5, "SUIT", ply:Armor(), 100, DrGHUD.PickColor("armor")) end
      local healthcolor = DrGHUD.PickColor("damage")
      if CurTime() >= lastDamage then
        local healthy = DrGHUD.PickColor("health")
        local damaged = DrGHUD.PickColor("damage")
        local ratio = health/maxhealth
        if ratio > 1 then ratio = 1 end
        if ratio < 0 then ratio = 0 end
        healthcolor = Color(
          healthy.r*ratio + damaged.r*(1-ratio),
          healthy.g*ratio + damaged.g*(1-ratio),
          healthy.b*ratio + damaged.b*(1-ratio),
          healthy.a*ratio + damaged.a*(1-ratio)
        )
      end
      DrGHUD.DrawBar(x + ecart*1.25, y + ecart, long - ecart*2, larg/5, "HEALTH", health, maxhealth, healthcolor)
      if DrGHUD.StatusEffects:GetBool() then
        local x = distance + long + ecart
        local y = scrHeight - larg - distance
        DrGHUD.DrawBackground(x, y, larg/3, larg)
        for i = 1, 3 do
          local mat
          if i == 1 then
            if ply:IsOnFire() or CurTime() < lastBurn then
              mat = fire_on
            else mat = fire_off end
          elseif i == 2 then
            if CurTime() < lastRadiation then mat = rad_on
            else mat = rad_off end
          elseif i == 3 then
            if CurTime() < lastPoison then mat = poison_on
            else mat = poison_off end
          end
          DrGHUD.DrawCircle(x + larg/6, y + (larg/3)*i - larg/6, larg/8, 6, nil, DrGHUD.PickColor("border"), {material = mat})
        end
      end
    end
    -- additional info
    if DrGHUD.Info:GetBool() then
      local x
      local y
      if DrGHUD.Status:GetBool() then
        x = distance
        y = scrHeight - larg - distance - ecart - larg/3
        if DrGHUD.StatusEffects:GetBool() then
          DrGHUD.DrawBackground(x, y, long + ecart + larg/3, larg/3, "left")
        else DrGHUD.DrawBackground(x, y, long, larg/3, "left") end
      else
        x = distance
        y = distance
        DrGHUD.DrawBackground(x, y, long + ecart + larg/3, larg/3, "left")
      end
      local speed
      if ply:InVehicle() then
        speed = ply:GetVehicle():GetVelocity():Length()
      elseif possessing then
        speed = DrGBase.Nextbot.Possessing(ply):GetVelocity():Length()
      else speed = ply:GetVelocity():Length() end
      DrGHUD.DrawText(x + ecart, y + ecart, "SPEED "..math.Round(speed).."  |  PING "..math.Round(ping).."  |  FPS "..math.Round(fps), "DrGHUDFont", DrGHUD.PickColor("main"))
    end
    -- entity info
    if not vehicle and not possessing and
    DrGHUD.AllowEntityInfo:GetBool() and DrGHUD.EntityInfo:GetBool() then
      if IsValid(ent) then
        local x = distance
        local y
        if not DrGHUD.Status:GetBool() and DrGHUD.Info:GetBool() then
          y = distance + larg/3 + ecart
        else y = distance end
        DrGHUD.DrawText(x, y, "CLASS "..ent:GetClass().." ("..ent:EntIndex()..")", "DrGHUDFont", DrGHUD.PickColor("main"))
        local healthColor = DrGHUD.PickColor("main")
        if entIcon.rel == DRGHUD_ALLY then
          healthColor = DrGHUD.PickColor(DRGHUD_ALLY)
        elseif entIcon.rel == DRGHUD_ENEMY then
          healthColor = DrGHUD.PickColor(DRGHUD_ENEMY)
        end
        local health = ent:Health()
        local maxHealth = ent._DrGHUDMaxHealth or ent:GetMaxHealth()
        if health > maxHealth and ent:GetMaxHealth() == 0 then ent._DrGHUDMaxHealth = health end
        DrGHUD.DrawBar(x, y + ecart*1.5, long - ecart*5, larg/5, "HEALTH", health, maxHealth, healthColor, true)
        DrGHUD.DrawText(x, y + ecart*5.25, "DISTANCE "..math.Round(tr.StartPos:Distance(tr.HitPos)), "DrGHUDFont", DrGHUD.PickColor("main"))
      end
    end
    -- ammo
    if not vehicle and not possessing and DrGHUD.Ammo:GetBool() then
      local x = scrWidth - long - distance
      local y = scrHeight - larg - distance
      local weapon = ply:GetActiveWeapon()
      if IsValid(weapon) and not possessing then
        DrGHUD.DrawBackground(x, y, long, larg, "right")
        DrGHUD.DrawText(x + larg, y + ecart, string.Trim(DrGHUD.WeaponName(weapon)), "DrGHUDFont", DrGHUD.PickColor("main"))
        surface.SetDrawColor(DrGHUD.PickColor("border"))
        surface.DrawLine(x + larg, y + ecart*2.5, x + long - ecart, y + ecart*2.5)
        local ammo = weapon:Clip1()
        local clipsize = weapon:GetMaxClip1()
        local ammoquantity = ply:GetAmmoCount(weapon:GetPrimaryAmmoType())
        local radius = (larg - ecart*2)/2
        local center = {
          x = x + larg/2,
          y = y + larg/2
        }
        if clipsize > 0 then
          DrGHUD.DrawPie(center.x, center.y, radius, ammo, clipsize, DrGHUD.PickColor("ammo"))
          DrGHUD.DrawText(x + larg, y + ecart*2.5, ammo.." / "..clipsize.. "  |  "..ammoquantity, "DrGHUDFont", DrGHUD.PickColor("main"))
        elseif weapon:GetPrimaryAmmoType() > -1 then
          DrGHUD.DrawPie(center.x, center.y, radius, ammoquantity, 1, DrGHUD.PickColor("ammo"))
          DrGHUD.DrawText(x + larg, y + ecart*2.5, ammoquantity.." remaining", "DrGHUDFont", DrGHUD.PickColor("main"))
        else DrGHUD.DrawText(x + ecart*1.25, y - ecart*0.5, "∞", "DrGHUDFontFat", DrGHUD.PickColor("ammo"), 1, DrGHUD.PickColor("border")) end
        local secammo = weapon:Clip2()
        local secclipsize = weapon:GetMaxClip2()
        local secammoquantity = ply:GetAmmoCount(weapon:GetSecondaryAmmoType())
        local secradius = (larg - ecart*2)/4
        local seccenter = {
          x = x + (larg/2)*2.5,
          y = y + (larg/2)*1.375
        }
        if secclipsize > 0 then
          DrGHUD.DrawPie(seccenter.x, seccenter.y, secradius, secammo, secclipsize, DrGHUD.PickColor("secammo"))
          DrGHUD.DrawText(x + larg*1.5, y + larg/2, secammo.." / "..secclipsize.. "  |  "..secammoquantity, "DrGHUDFont", DrGHUD.PickColor("main"))
        elseif weapon:GetSecondaryAmmoType() > -1 then
          DrGHUD.DrawPie(seccenter.x, seccenter.y, secradius, secammoquantity, 1, DrGHUD.PickColor("secammo"))
          DrGHUD.DrawText(x + larg*1.5, y + larg/2, secammoquantity.." remaining", "DrGHUDFont", DrGHUD.PickColor("main"))
        end
      end
    end
    -- vehicle
    if vehicle and DrGHUD.Vehicle:GetBool() then
      local x = scrWidth - distance
      local y = scrHeight - distance
      local points = {{x = x, y = y}}
      for i, point in ipairs(DrGHUD.GetCirclePoints(x, y, long*1.25, 16)) do
        if i >= 9 and i <= 13 then table.insert(points, point) end
      end
      DrGHUD.DrawPoly(points, nil, DrGHUD.PickColor("border"), {blur = true})
    end
    -- radar
    if DrGHUD.AllowRadar:GetBool() and DrGHUD.Radar:GetBool() then
      local radius = larg*1.25*DrGHUD.RadarScale:GetFloat()
      local rad3 = radius/3
      local x = scrWidth - distance - radius
      local y = distance + radius
      local nb = 8
      local offset = -math.pi/2
      local pos = EyePos()
      local pos2D = Vector(pos.x, pos.y, 0)
      DrGHUD.DrawCircle(x, y, radius, nb, DrGHUD.PickColor("background"), nil, {blur = true})
      local points = DrGHUD.GetCirclePoints(x, y, radius, nb)
      DrGHUD.DrawPoly({
        {x = x, y = y, u = 0.5, v = 0.5},
        points[6], points[7], points[8]
      }, DrGHUD.PickColor("border"), nil, {blur = true})
      DrGHUD.DrawCircle(x, y, radius, nb, nil, DrGHUD.PickColor("border"))
      DrGHUD.DrawCircle(x, y, rad3*2, nb, nil, DrGHUD.PickColor("border"))
      DrGHUD.DrawCircle(x, y, rad3, nb, nil, DrGHUD.PickColor("border"))
      for i, icon in ipairs(radar) do
        if icon.entIndex ~= nil then
          local ent = Entity(icon.entIndex)
          if not IsValid(ent) then continue
          elseif icon.pvs then icon.pos = ent:GetPos() end
        end
        icon.pos2D = Vector(icon.pos.x, icon.pos.y, 0)
        local dist
        if pos2D:DistToSqr(icon.pos2D) > math.pow(DrGHUD.RadarRange:GetFloat(), 2) then
          if icon.outside then dist = DrGHUD.RadarRange:GetFloat()
          else continue end
        else dist = pos2D:Distance(icon.pos2D) end
        local size = ecart/2
        local tr = util.TraceLine({
          start = pos,
          endpos = icon.pos + Vector(0, 0, 10),
          collisiongroup = COLLISION_GROUP_IN_VEHICLE
        })
        local ang = math.AngleDifference(EyeAngles().y, tr.Normal:Angle().y)
        local theta = math.rad(ang)
        icon.x = (dist/DrGHUD.RadarRange:GetFloat())*radius*0.825*math.cos(theta + offset)
        icon.y = (dist/DrGHUD.RadarRange:GetFloat())*radius*0.825*math.sin(theta + offset)
        local color
        if icon.color ~= nil then color = icon.color
        elseif icon.rel ~= nil then color = DrGHUD.PickColor(icon.rel) end
        if icon.type == DRGHUD_TYPE_DEFAULT then
          if color == nil then continue end
          if icon.rel == DRGHUD_WEAPON or icon.rel == DRGHUD_ITEM then
            size = size/1.25
          end
          local heightdiff = pos.z - icon.pos.z
          if (not possessing and ply:EntIndex() == icon.entIndex) or
          (possessing and DrGBase.Nextbot.Possessing(ply):EntIndex() == icon.entIndex) then
            DrGHUD.DrawDiamond(x, y, size, color)
          elseif math.abs(ang) <= 45 and not tr.HitWorld then
            if heightdiff > 200 then
              DrGHUD.DrawTriangle(x + icon.x, y + icon.y, size, color)
            elseif heightdiff < -200 then
              DrGHUD.DrawTriangle(x + icon.x, y + icon.y, size, color, nil, {offset = 180})
            else
              DrGHUD.DrawDiamond(x + icon.x, y + icon.y, size, color)
            end
          else
            if heightdiff > 200 then
              DrGHUD.DrawTriangle(x + icon.x, y + icon.y, size, nil, color)
            elseif heightdiff < -200 then
              DrGHUD.DrawTriangle(x + icon.x, y + icon.y, size, nil, color, {offset = 180})
            else
              DrGHUD.DrawDiamond(x + icon.x, y + icon.y, size, nil, color)
            end
          end
        elseif icon.type == DRGHUD_TYPE_MATERIAL then
          size = size*3
          DrGHUD.DrawMaterial(x + icon.x - size/2, y + icon.y - size/2, size, DrGHUD.PickMaterial(icon.material), color)
        elseif icon.type == DRGHUD_TYPE_TEXT then
          surface.SetFont("DrGHUDFont")
          local width, height = surface.GetTextSize(icon.text)
          DrGHUD.DrawText(x + icon.x - width/2, y + icon.y - height/2, icon.text, "DrGHUDFont", color or DrGHUD.PickColor("main"))
        end
      end
    end
    hook.Run("DrGHUDPaint")
  end)

  hook.Add("HUDShouldDraw", "DrGHUDShouldDraw", function(name)
    if not DrGHUD.Enable:GetBool() then return end
    local hide = {
      ["CHudHealth"] = DrGHUD.Status:GetBool(),
      ["CHudBattery"] = DrGHUD.Status:GetBool(),
      ["CHudAmmo"] = DrGHUD.Ammo:GetBool(),
      ["CHudSecondaryAmmo"] = DrGHUD.Ammo:GetBool(),
      ["CHudCrosshair"] = DrGHUD.Crosshair:GetBool(),
      ["CHudWeaponSelection"] = false, --DrGHUD.Weapons:GetBool(),
      ["CHudPoisonDamageIndicator"] = DrGHUD.Status:GetBool(),
      ["CHudZoom"] = DrGHUD.Zoom:GetBool()
    }
    if name == "CHudGeiger" then lastRadiation = CurTime() + statusEffectDuration
    elseif name == "CHudPoisonDamageIndicator" then lastPoison = CurTime() + statusEffectDuration end
    if hide[name] then return false end
  end)

  -- weapon select menu
  hook.Add("PlayerBindPress", "DrGHUDWeaponSelection", function(ply, bind, on)

  end)

  -- death icon
  net.Receive("DrGHUDDeath", function()
    lastDeathTime = CurTime()
    lastDeathPos = net.ReadVector()
  end)
  hook.Add("PreCleanupMap", "DrGHUDDeathNotice", function()
    lastDeathTime = 0
    lastDeathPos = nil
  end)

  -- show damage
  net.Receive("DrGHUDDamage", function()
    lastDamage = CurTime() + 0.1
    if net.ReadBool() then
      local types = net.ReadInt(32)
      if bit.band(types, DMG_BURN) ~= 0 or
      bit.band(types, DMG_SLOWBURN) ~= 0 then
        lastBurn = CurTime() + statusEffectDuration
      elseif bit.band(types, DMG_RADIATION) ~= 0 then
        lastRadiation = CurTime() + statusEffectDuration
      elseif bit.band(types, DMG_POISON) ~= 0 or
      bit.band(types, DMG_ACID) ~= 0 or
      bit.band(types, DMG_PARALYZE) ~= 0 then
        lastPoison = CurTime() + statusEffectDuration
      end
    end
  end)

  -- define material
  net.Receive("DrGHUDDefineMaterial", function()
    local name = net.ReadString()
    local path = net.ReadString()
    local force = net.ReadBool()
    DrGHUD.DefineMaterial(name, path, force)
  end)

  -- add/remove beacons
  net.Receive("DrGHUDDefineBeacon", function()
    local name = net.ReadString()
    local pos = net.ReadVector()
    local color
    if net.ReadBool() then
      color = Color(0, 0, 0, 0)
      color.r = net.ReadInt(32)
      color.g = net.ReadInt(32)
      color.b = net.ReadInt(32)
      color.a = net.ReadInt(32)
    end
    DrGHUD.DefineBeacon(name, pos, color)
  end)
  net.Receive("DrGHUDRemoveBeacon", function()
    DrGHUD.RemoveBeacon(net.ReadString())
  end)

  -- refresh radar
  net.Receive("DrGHUDRadarRefresh", function(len)
    radar = util.JSONToTable(util.Decompress(net.ReadData(len/8)))
    if lastDeathPos ~= nil and (DrGHUD.RadarDeath:GetInt() < 0 or CurTime() < lastDeathTime + DrGHUD.RadarDeath:GetInt()) then
      table.insert(radar, {
        pos = lastDeathPos,
        outside = true,
        type = DRGHUD_TYPE_MATERIAL,
        material = "drghud_death",
        color = DrGHUD.PickColor("main")
      })
    end
    if DrGHUD.Compass:GetBool() then
      local lol = 999999999999
      local north = Vector(lol, 0, 0)
      north:Rotate(Angle(0, -DrGHUD.CompassRotate:GetFloat(), 0))
      table.insert(radar, {
        pos = north,
        outside = true,
        type = DRGHUD_TYPE_TEXT,
        text = "N"
      })
      if not DrGHUD.CompassNorthOnly:GetBool() then
        local south = Vector(-lol, 0, 0)
        local west = Vector(0, lol, 0)
        local east = Vector(0, -lol, 0)
        south:Rotate(Angle(0, -DrGHUD.CompassRotate:GetFloat(), 0))
        west:Rotate(Angle(0, -DrGHUD.CompassRotate:GetFloat(), 0))
        east:Rotate(Angle(0, -DrGHUD.CompassRotate:GetFloat(), 0))
        table.insert(radar, {
          pos = south,
          outside = true,
          type = DRGHUD_TYPE_TEXT,
          text = "S"
        })
        table.insert(radar, {
          pos = west,
          outside = true,
          type = DRGHUD_TYPE_TEXT,
          text = "W"
        })
        table.insert(radar, {
          pos = east,
          outside = true,
          type = DRGHUD_TYPE_TEXT,
          text = "E"
        })
      end
    end
    for i, beacon in ipairs(beacons) do
      table.insert(radar, beacon)
    end
  end)

else
  util.AddNetworkString("DrGHUDDeath")
  util.AddNetworkString("DrGHUDDamage")
  util.AddNetworkString("DrGHUDRadarRefresh")
  util.AddNetworkString("DrGHUDDefineMaterial")
  util.AddNetworkString("DrGHUDDefineBeacon")
  util.AddNetworkString("DrGHUDRemoveBeacon")

  local radarRefreshDelay = 0

  function DrGHUD.RefreshRadar(ply)
    if ply == nil then
      for i, ply in ipairs(player.GetHumans()) do
        DrGHUD.RefreshRadar(ply)
      end
    elseif IsValid(ply) then
      local data = {}
      for i, ent in ipairs(ents.GetAll()) do
        local rel
        local hookres = hook.Run("DrGHUD/EntityIcon", ent, ply)
        if hookres ~= nil then
          rel = hookres
        else
          if ply:EntIndex() == ent:EntIndex() then
            rel = DRGHUD_NEUTRAL
          elseif ent:IsPlayer() then
            local plyTeam = ply:Team()
            local entTeam = ent:Team()
            if plyTeam == TEAM_CONNECTING or plyTeam == TEAM_UNASSIGNED or plyTeam == TEAM_SPECTATOR or
            entTeam == TEAM_CONNECTING or entTeam == TEAM_UNASSIGNED or entTeam == TEAM_SPECTATOR then
              rel = DRGHUD_NEUTRAL
            elseif plyTeam == entTeam then
              rel = DRGHUD_ALLY
            else rel = DRGHUD_ENEMY end
          elseif ent:IsNPC() then
            local disposition = ent:Disposition(ply)
            if disposition == D_HT or disposition == D_FR then
              rel = DRGHUD_ENEMY
            elseif disposition == D_LI then
              rel = DRGHUD_ALLY
            else rel = DRGHUD_NEUTRAL end
          elseif ent.Type == "nextbot" then
            rel = DRGHUD_ENEMY
          elseif ent:IsWeapon() and not IsValid(ent:GetOwner()) then
            rel = DRGHUD_WEAPON
          elseif ent:IsVehicle() and not IsValid(ent:GetDriver()) then
            rel = DRGHUD_VEHICLE
          else rel = DRGHUD_IGNORE end
        end
        if rel == DRGHUD_IGNORE then continue end
        local type = hook.Run("DrGHUD/EntityIconType", ent, ply)
        --local color = hook.Run("DrGHUD/EntityIconColor", ent, ply)
        local outside = hook.Run("DrGHUD/EntityIconOutside", ent, ply)
        if outside then outside = true else outside = false end
        local icon = {
          entIndex = ent:EntIndex(),
          pos = ent:GetPos(),
          --color = color,
          outside = outside,
          rel = rel,
          type = type or DRGHUD_TYPE_DEFAULT,
          pvs = ply:TestPVS(ent)
        }
        if type == DRGHUD_TYPE_MATERIAL then
          local material = hook.Run("DrGHUD/EntityIconMaterial", ent, ply)
          if isstring(material) then
            icon.material = material
          else continue end
        elseif type == DRGHUD_TYPE_TEXT then
          local text = hook.Run("DrGHUD/EntityIconText", ent, ply)
          if isstring(text) then
            icon.text = text
          else continue end
        end
        table.insert(data, icon)
      end
      local compressed = util.Compress(util.TableToJSON(data))
      net.Start("DrGHUDRadarRefresh")
      net.WriteData(compressed, #compressed)
      net.Send(ply)
    end
  end

  hook.Add("DrGHUD/EntityIcon", "DrGHUDEntityIconOverrides", function(ent)
    local class = ent:GetClass()
    if class == "replicator_melon" then return DRGHUD_ENEMY
    elseif class == "replicator_queen" then return DRGHUD_ENEMY
    elseif class == "replicator_queen_hive" then return DRGHUD_ENEMY
    elseif class == "replicator_worker" then return DRGHUD_ENEMY
    end
  end)

  function DrGHUD.DefineMaterial(name, path, force)
    net.Start("DrGHUDDefineMaterial")
    net.WriteString(name)
    net.WriteString(path)
    net.WriteBool(force or false)
    net.Broadcast()
  end

  function DrGHUD.DefineBeacon(name, pos, color)
    net.Start("DrGHUDDefineBeacon")
    net.WriteString(name)
    net.WriteVector(pos)
    net.WriteBool(color ~= nil)
    if color ~= nil then
      net.WriteInt(color.r, 32)
      net.WriteInt(color.g, 32)
      net.WriteInt(color.b, 32)
      net.WriteInt(color.a, 32)
    end
    net.Broadcast()
  end

  function DrGHUD.RemoveBeacon(name)
    net.Start("DrGHUDRemoveBeacon")
    net.WriteString(name)
    net.Broadcast()
  end

  hook.Add("Think", "DrGHUDThink", function()
    if CurTime() > radarRefreshDelay + 0.1 then
      radarRefreshDelay = CurTime()
      DrGHUD.RefreshRadar()
    end
  end)

  hook.Add("OnEntityCreated", "DrGHUDOnEntityCreated", function()
    timer.Simple(0, DrGHUD.RefreshRadar)
  end)

  hook.Add("PlayerEnteredVehicle", "DrGHUDPlayerEnteredVehicle", function()
    timer.Simple(0, DrGHUD.RefreshRadar)
  end)

  hook.Add("PlayerLeaveVehicle", "DrGHUDPlayerLeaveVehicle", function()
    timer.Simple(0, DrGHUD.RefreshRadar)
  end)

  hook.Add("EntityTakeDamage", "DrGHUDEntityTakeDamage", function(ent, dmg)
    if not IsValid(ent) then return end
    if dmg:GetDamage() <= 0 then return end
    if ent:IsPlayer() or (DrGBase ~= nil and ent:IsDrGNextbot() and ent:IsPossessed()) then
      local types = dmg:GetDamageType()
      net.Start("DrGHUDDamage")
      net.WriteBool(types ~= nil)
      if types ~= nil then net.WriteInt(types, 32) end
      if ent:IsPlayer() then net.Send(ent)
      else net.Send(ent:GetPossessor()) end
      net.Send(ent)
    end
  end)

  hook.Add("PostPlayerDeath", "DrGHUDPostPlayerDeath", function(ply)
    net.Start("DrGHUDDeath")
    net.WriteVector(ply:GetPos())
    net.Send(ply)
  end)

  resource.AddFile("materials/drghud/death.png")
  resource.AddFile("materials/drghud/fire_on.png")
  resource.AddFile("materials/drghud/fire_off.png")
  resource.AddFile("materials/drghud/poison_on.png")
  resource.AddFile("materials/drghud/poison_off.png")
  resource.AddFile("materials/drghud/radiation_on.png")
  resource.AddFile("materials/drghud/radiaiton_off.png")

end
