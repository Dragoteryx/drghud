DrGHUD.Background = Color(0, 0, 25, 50)
DrGHUD.Border = Color(100, 100, 110, 25)

-- Util --

local X, Y = 0, 0
function DrGHUD.GetOrigin()
  return X, Y
end
function DrGHUD.SetOrigin(x, y)
  X, Y = x, y
end

function DrGHUD.GetCenter()
  local y = 50/DrGHUD.Scale:GetFloat()
  local x = y*(ScrW()/ScrH())
  return x, y
end

function ScaleValue(v)
  return v/100*ScrH()*DrGHUD.Scale:GetFloat()
end

local function TranslateX(x)
  return ScaleValue(x + X) % ScrW()
end

local function TranslateY(y)
  return ScaleValue(y + Y) % ScrH()
end

local function CalcRectanglePoints(length, height)
  return {
    {x = 0, y = 0, u = 0, v = 0},
    {x = length, y = 0, u = 1, v = 0},
    {x = length, y = height, u = 1, v = 1},
    {x = 0, y = height, u = 0, v = 1}
  }
end

local function CalcCirclePoints(radius, lines, angle)
  local theta = math.rad(360/lines)
  local points = {}
  for i = 0, lines-1 do
    local a = theta*i+math.rad(angle or 0)
    local x = math.cos(a)*radius
    local y = math.sin(a)*radius
    local u = 0.5 + x/(radius*2)
    local v = 0.5 + y/(radius*2)
    table.insert(points, {
      x = x, y = y,
      u = u, v = v
    })
  end
  return points
end

-- Simple --

function DrGHUD.DrawLine(x1, y1, x2, y2, color)
  surface.SetDrawColor(color or DrGHUD.Border)
  surface.DrawLine(TranslateX(x1), TranslateY(y1), TranslateX(x2), TranslateY(y2))
end

function DrGHUD.DrawText(x, y, text, options)
  local font = options and options.font or "DrGHUD/Default"
  local color = options and options.color or DrGHUD.MainColor.Value
  local xAlign = options and options.xAlign or TEXT_ALIGN_LEFT
  local yAlign = options and options.yAlign or TEXT_ALIGN_TOP
  if options and isnumber(options.maxLength) then
    surface.SetFont(font)
    local maxLength = ScaleValue(options.maxLength)
    local length = surface.GetTextSize(text)
    if length > maxLength then
      local shortened
      repeat
        text = string.Left(text, #text-1)
        shortened = text.."..."
      until surface.GetTextSize(shortened) <= maxLength
      text = shortened
    end
  end
  return draw.SimpleText(text, font, TranslateX(x), TranslateY(y), color, xAlign, yAlign)
end

-- Prepare polygons --

local POLYGONS = {}
function DrGHUD.PreparePolygon(x, y, ...)
  local polygons = {}
  for _, points in ipairs({...}) do
    local polygon = {}
    for _, point in ipairs(points) do
      table.insert(polygon, {
        x = TranslateX(x) + ScaleValue(point.x),
        y = TranslateY(y) + ScaleValue(point.y),
        u = point.u, v = point.v
      })
    end
    table.insert(polygons, polygon)
  end
  POLYGONS = polygons
end

function DrGHUD.PrepareRectangle(x, y, length, height)
  local points = CalcRectanglePoints(length, height)
  DrGHUD.PreparePolygon(x, y, points)
end

function DrGHUD.PrepareSquare(x, y, sides)
  local half = sides/2
  DrGHUD.PrepareRectangle(x-half, y-half, sides, sides)
end

function DrGHUD.PrepareCircle(x, y, radius, lines, angle)
  local points = CalcCirclePoints(radius, lines, angle)
  DrGHUD.PreparePolygon(x, y, points)
end

function DrGHUD.PrepareCirclePiece(x, y, radius, lines, angle, from, to)
  local points = CalcCirclePoints(radius, lines, angle)
  local piece = {{x = 0, y = 0, u = 0.5, v = 0.5}}
  for i = from, to do
    table.insert(piece, points[i % #points + 1])
  end
  DrGHUD.PreparePolygon(x, y, piece)
end

function DrGHUD.PrepareTriangle(x, y, size, angle)
  DrGHUD.PrepareCircle(x, y, size, 3, angle)
end

function DrGHUD.PrepareDiamond(x, y, size, angle)
  DrGHUD.PrepareCircle(x, y, size, 4, angle)
end

function DrGHUD.PrepareHexagon(x, y, size, angle)
  DrGHUD.PrepareCircle(x, y, size, 6, angle)
end

function DrGHUD.PrepareRing(x, y, outer, inner, lines, angle)
  local ratio = inner/outer
  local outer = CalcCirclePoints(outer, lines, angle)
  local inner = {}
  for _, point in ipairs(outer) do
    table.insert(inner, {
      x = point.x*ratio,
      y = point.y*ratio,
      u = (point.u-0.5)*ratio+0.5,
      v = (point.v-0.5)*ratio+0.5
    })
  end
  local polygons = {}
  for i = 1, lines do
    local j = i == lines and 1 or i+1
    table.insert(polygons, {
      outer[i], outer[j],
      inner[j], inner[i]
    })
  end
  DrGHUD.PreparePolygon(x, y, unpack(polygons))
end

-- Draw polygons --

local WHITE = Color(255, 255, 255)
local BLUR = Material("pp/blurscreen")

function DrGHUD.Fill(color, material)
  if color or material then
    if color then
      surface.SetDrawColor(color)
    else surface.SetDrawColor(WHITE) end
    if material then
      surface.SetMaterial(material)
    else draw.NoTexture() end
    for _, polygon in ipairs(POLYGONS) do
      surface.DrawPoly(polygon)
    end
  end
end

function DrGHUD.Stroke(color)
  surface.SetDrawColor(color)
  for _, polygon in ipairs(POLYGONS) do
    for i = 1, #polygon do
      local j = i == #polygon and 1 or i+1
      surface.DrawLine(
        polygon[i].x, polygon[i].y,
        polygon[j].x, polygon[j].y
      )
    end
  end
end

function DrGHUD.Blur()
  local polygons = {}
  for _, polygon in ipairs(POLYGONS) do
    local points = {}
    for _, point in pairs(polygon) do
      table.insert(points, {
        x = point.x,
        y = point.y,
        u = point.x/ScrW(),
        v = point.y/ScrH()
      })
    end
    table.insert(polygons, points)
  end
  surface.SetMaterial(BLUR)
  surface.SetDrawColor(WHITE)
  local blur = DrGHUD.BlurQuality:GetInt()
  for i = 1, blur do
    BLUR:SetFloat("$blur", (i/3)*(25/blur))
    BLUR:Recompute()
    render.UpdateScreenEffectTexture()
    for _, polygon in ipairs(polygons) do
      surface.DrawPoly(polygon)
    end
  end
end

-- Draw components --

function DrGHUD.DrawWindow(length, height, border)
  DrGHUD.PrepareRectangle(0, 0, length, height)
  DrGHUD.Fill(DrGHUD.Background)
  DrGHUD.Blur()
  DrGHUD.Stroke(DrGHUD.Border)
  if border == "left" then
    DrGHUD.PrepareRectangle(-0.5, 0, 0.5, height)
    DrGHUD.Fill(DrGHUD.MainColor.Value)
  elseif border == "right" then
    DrGHUD.PrepareRectangle(length, 0, 0.5, height)
    DrGHUD.Fill(DrGHUD.MainColor.Value)
  end
end

function DrGHUD.DrawBar(x, y, length, height, value, max, color)
  DrGHUD.PrepareRectangle(x, y, length, height)
  DrGHUD.Fill(DrGHUD.Background)
  DrGHUD.Stroke(DrGHUD.Border)
  local barLength = (math.min(value, max)/max)*length
  DrGHUD.PrepareRectangle(x, y, barLength, height)
  DrGHUD.Fill(color)
  DrGHUD.PrepareRectangle(x, y+height/2, barLength, height/2)
  for _ = 1, 2 do DrGHUD.Fill(DrGHUD.Background) end
end

function DrGHUD.DrawPie(x, y, radius, value, max, color)
  if max == 1 then
    DrGHUD.PrepareHexagon(x, y, radius)
    if value <= 0 then
      DrGHUD.Fill(DrGHUD.Background)
      DrGHUD.Stroke(DrGHUD.Border)
    else DrGHUD.Fill(color) end
  elseif max < 4 then
    DrGHUD.DrawPie(x, y, radius, value*2, max*2, color, blur)
  elseif max >= 4 then
    DrGHUD.PrepareCircle(x, y, radius, max)
    DrGHUD.Fill(DrGHUD.Background)
    DrGHUD.Stroke(DrGHUD.Border)
    DrGHUD.PrepareCirclePiece(x, y, radius, max, nil, 0, value)
    DrGHUD.Fill(color)
  end
end