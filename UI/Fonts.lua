LeafVE_Fonts = LeafVE_Fonts or {}

local TEXT_COLORS = (LeafVE_Colors and LeafVE_Colors.TEXT_COLORS) or {}

LeafVE_Fonts.FONTS = {
  -- Headers (FRIZQT__.TTF)
  h1 = {path = "Fonts\\FRIZQT__.TTF", size = 18, color = TEXT_COLORS.bright_white or TEXT_COLORS.bright},
  h2 = {path = "Fonts\\FRIZQT__.TTF", size = 14, color = TEXT_COLORS.bright_white or TEXT_COLORS.bright},
  h3 = {path = "Fonts\\FRIZQT__.TTF", size = 12, color = TEXT_COLORS.off_white or TEXT_COLORS.normal},

  -- Body text (ARIALN.TTF)
  body_normal = {path = "Fonts\\ARIALN.TTF", size = 11, color = TEXT_COLORS.off_white or TEXT_COLORS.normal},
  body_small = {path = "Fonts\\ARIALN.TTF", size = 10, color = TEXT_COLORS.muted_gray or TEXT_COLORS.muted},
  mono = {path = "Fonts\\ARIALN.TTF", size = 10, color = TEXT_COLORS.off_white or TEXT_COLORS.normal},

  -- Special styles
  button = {path = "Fonts\\ARIALN.TTF", size = 11, color = TEXT_COLORS.bright_white or TEXT_COLORS.bright, uppercase = true},
  class_name = {path = "Fonts\\FRIZQT__.TTF", size = 12, color = TEXT_COLORS.bright_white or TEXT_COLORS.bright},
  stat = {path = "Fonts\\ARIALN.TTF", size = 10, color = TEXT_COLORS.muted_gray or TEXT_COLORS.muted},

  -- Compatibility aliases
  header_large = {path = "Fonts\\FRIZQT__.TTF", size = 18, color = TEXT_COLORS.bright_white or TEXT_COLORS.bright},
  header_medium = {path = "Fonts\\FRIZQT__.TTF", size = 14, color = TEXT_COLORS.bright_white or TEXT_COLORS.bright},
  header_small = {path = "Fonts\\FRIZQT__.TTF", size = 12, color = TEXT_COLORS.off_white or TEXT_COLORS.normal},
  body_large = {path = "Fonts\\ARIALN.TTF", size = 11, color = TEXT_COLORS.off_white or TEXT_COLORS.normal},
}

function LeafVE_Fonts:Apply(fontString, styleKey, flags)
  if not fontString or not fontString.SetFont then
    return
  end
  local style = self.FONTS[styleKey] or self.FONTS.body_normal
  if not style then
    return
  end

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
