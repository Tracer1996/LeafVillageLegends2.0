LeafVE_Colors = LeafVE_Colors or {}

local COLORS = LeafVE_Colors

COLORS.QUALITY_COLORS = {
  poor = {r = 0.62, g = 0.62, b = 0.62, hex = "#9D9D9D"},
  common = {r = 1.00, g = 1.00, b = 1.00, hex = "#FFFFFF"},
  uncommon = {r = 0.12, g = 1.00, b = 0.00, hex = "#1EFF00"},
  rare = {r = 0.00, g = 0.44, b = 0.87, hex = "#0070DD"},
  epic = {r = 0.64, g = 0.21, b = 0.93, hex = "#A335EE"},
  legendary = {r = 1.00, g = 0.50, b = 0.00, hex = "#FF8000"},
  artifact = {r = 1.00, g = 0.80, b = 0.00, hex = "#FFD100"},
}

COLORS.BG_COLORS = {
  darkest = {r = 0.04, g = 0.06, b = 0.15, hex = "#0a0f27"},
  dark = {r = 0.10, g = 0.12, b = 0.23, hex = "#1a1f3a"},
  medium = {r = 0.17, g = 0.19, b = 0.31, hex = "#2a3050"},
  light = {r = 0.24, g = 0.27, b = 0.38, hex = "#3a4561"},
}

COLORS.TEXT_COLORS = {
  bright = {r = 1.00, g = 1.00, b = 1.00, hex = "#FFFFFF"},
  normal = {r = 0.90, g = 0.90, b = 0.90, hex = "#E6E6E6"},
  muted = {r = 0.69, g = 0.69, b = 0.69, hex = "#B0B0B0"},
  dark = {r = 0.50, g = 0.50, b = 0.50, hex = "#808080"},
  gold = {r = 1.00, g = 0.82, b = 0.00, hex = "#FFD100"},
}

COLORS.CLASS_COLORS_HEX = {
  WARRIOR = "#C69B7D",
  PALADIN = "#F48CBA",
  HUNTER = "#ABD473",
  ROGUE = "#FFF468",
  PRIEST = "#FFFFFF",
  SHAMAN = "#0070DD",
  MAGE = "#3FC7EB",
  WARLOCK = "#9482CA",
  DRUID = "#FF7D0A",
  DEATHKNIGHT = "#C41E3A",
}

COLORS.STATUS_COLORS = {
  success = {r = 0.18, g = 1.00, b = 0.00, hex = "#2DFF00"},
  warning = {r = 1.00, g = 0.82, b = 0.00, hex = "#FFD100"},
  error = {r = 1.00, g = 0.00, b = 0.00, hex = "#FF0000"},
  info = {r = 0.00, g = 0.70, b = 0.87, hex = "#0070DD"},
  disabled = {r = 0.40, g = 0.40, b = 0.40, hex = "#666666"},
}

function COLORS:HexToRGB(hex)
  if type(hex) ~= "string" then
    return 1, 1, 1
  end
  local clean = string.gsub(hex, "#", "")
  if string.len(clean) ~= 6 then
    return 1, 1, 1
  end
  local r = tonumber(string.sub(clean, 1, 2), 16) or 255
  local g = tonumber(string.sub(clean, 3, 4), 16) or 255
  local b = tonumber(string.sub(clean, 5, 6), 16) or 255
  return r / 255, g / 255, b / 255
end

function COLORS:GetClassColor(classToken)
  local token = classToken and string.upper(classToken) or ""
  local hex = self.CLASS_COLORS_HEX[token]
  if not hex then
    return self.TEXT_COLORS.normal
  end
  local r, g, b = self:HexToRGB(hex)
  return {r = r, g = g, b = b, hex = hex}
end

function COLORS:GetQualityColor(quality)
  if not quality then
    return self.QUALITY_COLORS.common
  end
  return self.QUALITY_COLORS[string.lower(quality)] or self.QUALITY_COLORS.common
end
