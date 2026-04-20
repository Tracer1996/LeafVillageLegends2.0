LeafVE_Fonts = LeafVE_Fonts or {}

local THEME = LeafVE_Theme or {}
local TEXT_COLORS = THEME.TEXT or ((LeafVE_Colors and LeafVE_Colors.TEXT_COLORS) or {})

local function ColorOr(color, fallback)
  return color or fallback or {r = 1, g = 1, b = 1}
end

LeafVE_Fonts.FONTS = {
  h1 = {path = "Fonts\\FRIZQT__.TTF", size = 18, color = ColorOr(TEXT_COLORS.primary, TEXT_COLORS.bright_white or TEXT_COLORS.bright)},
  h2 = {path = "Fonts\\FRIZQT__.TTF", size = 14, color = ColorOr(TEXT_COLORS.primary, TEXT_COLORS.bright_white or TEXT_COLORS.bright)},
  h3 = {path = "Fonts\\FRIZQT__.TTF", size = 12, color = ColorOr(TEXT_COLORS.secondary, TEXT_COLORS.off_white or TEXT_COLORS.normal)},

  body_normal = {path = "Fonts\\ARIALN.TTF", size = 11, color = ColorOr(TEXT_COLORS.primary, TEXT_COLORS.off_white or TEXT_COLORS.normal)},
  body_small = {path = "Fonts\\ARIALN.TTF", size = 10, color = ColorOr(TEXT_COLORS.muted, TEXT_COLORS.muted_gray or TEXT_COLORS.muted)},
  mono = {path = "Fonts\\ARIALN.TTF", size = 10, color = ColorOr(TEXT_COLORS.primary, TEXT_COLORS.off_white or TEXT_COLORS.normal)},

  button = {path = "Fonts\\ARIALN.TTF", size = 11, color = ColorOr(TEXT_COLORS.white, TEXT_COLORS.bright_white or TEXT_COLORS.bright), uppercase = true},
  class_name = {path = "Fonts\\FRIZQT__.TTF", size = 12, color = ColorOr(TEXT_COLORS.primary, TEXT_COLORS.bright_white or TEXT_COLORS.bright)},
  stat = {path = "Fonts\\ARIALN.TTF", size = 10, color = ColorOr(TEXT_COLORS.muted, TEXT_COLORS.muted_gray or TEXT_COLORS.muted)},
  tooltip_h = {path = "Fonts\\FRIZQT__.TTF", size = 12, color = ColorOr(TEXT_COLORS.gold, TEXT_COLORS.primary)},
  badge_label = {path = "Fonts\\ARIALN.TTF", size = 10, color = ColorOr(TEXT_COLORS.secondary, TEXT_COLORS.muted)},

  header_large = {path = "Fonts\\FRIZQT__.TTF", size = 18, color = ColorOr(TEXT_COLORS.primary, TEXT_COLORS.bright_white or TEXT_COLORS.bright)},
  header_medium = {path = "Fonts\\FRIZQT__.TTF", size = 14, color = ColorOr(TEXT_COLORS.primary, TEXT_COLORS.bright_white or TEXT_COLORS.bright)},
  header_small = {path = "Fonts\\FRIZQT__.TTF", size = 12, color = ColorOr(TEXT_COLORS.secondary, TEXT_COLORS.off_white or TEXT_COLORS.normal)},
  body_large = {path = "Fonts\\ARIALN.TTF", size = 11, color = ColorOr(TEXT_COLORS.primary, TEXT_COLORS.off_white or TEXT_COLORS.normal)},
}

function LeafVE_Fonts:Apply(fontString, styleKey, flags)
  if not fontString or not fontString.SetFont then return end
  local style = self.FONTS[styleKey] or self.FONTS.body_normal
  if not style then return end

  fontString:SetFont(style.path, style.size, flags)
  if style.color and fontString.SetTextColor then
    fontString:SetTextColor(style.color.r or 1, style.color.g or 1, style.color.b or 1, 1)
  end

  if style.uppercase and fontString.GetText and fontString.SetText then
    local text = fontString:GetText()
    if text and text ~= "" then
      fontString:SetText(string.upper(text))
    end
  end
end

function LeafVE_Fonts:SetAccent(fs)
  if not fs or not fs.SetTextColor then return end
  local c = (LeafVE_Theme and LeafVE_Theme.TEXT and LeafVE_Theme.TEXT.accent) or {r = 0.18, g = 0.8, b = 0.443}
  fs:SetTextColor(c.r or 1, c.g or 1, c.b or 1, 1)
end

function LeafVE_Fonts:SetGold(fs)
  if not fs or not fs.SetTextColor then return end
  local c = (LeafVE_Theme and LeafVE_Theme.TEXT and LeafVE_Theme.TEXT.gold) or {r = 0.788, g = 0.635, b = 0.153}
  fs:SetTextColor(c.r or 1, c.g or 1, c.b or 1, 1)
end

function LeafVE_Fonts:SetMuted(fs)
  if not fs or not fs.SetTextColor then return end
  local c = (LeafVE_Theme and LeafVE_Theme.TEXT and LeafVE_Theme.TEXT.muted) or {r = 0.38, g = 0.396, b = 0.427}
  fs:SetTextColor(c.r or 1, c.g or 1, c.b or 1, 1)
end
