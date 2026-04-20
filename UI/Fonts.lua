LeafVE_Fonts = LeafVE_Fonts or {}

local TEXT_COLORS = (LeafVE_Colors and LeafVE_Colors.TEXT_COLORS) or {}

LeafVE_Fonts.FONTS = {
  header_large = {path = "Fonts\\FRIZQT__.TTF", size = 16, color = TEXT_COLORS.bright},
  header_medium = {path = "Fonts\\FRIZQT__.TTF", size = 14, color = TEXT_COLORS.bright},
  header_small = {path = "Fonts\\ARIALN.TTF", size = 12, color = TEXT_COLORS.bright},
  body_large = {path = "Fonts\\ARIALN.TTF", size = 12, color = TEXT_COLORS.normal},
  body_normal = {path = "Fonts\\ARIALN.TTF", size = 11, color = TEXT_COLORS.normal},
  body_small = {path = "Fonts\\ARIALN.TTF", size = 10, color = TEXT_COLORS.muted},
  mono = {path = "Fonts\\ARIALN.TTF", size = 10, color = TEXT_COLORS.normal},
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
end
