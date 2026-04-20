LeafVE_FrameSkins = LeafVE_FrameSkins or {}

local COLORS = LeafVE_Colors or {}
local BG_COLORS = COLORS.BG_COLORS or {}
local TEXT_COLORS = COLORS.TEXT_COLORS or {}
local STATUS_COLORS = COLORS.STATUS_COLORS or {}
local QUALITY_COLORS = COLORS.QUALITY_COLORS or {}
local SECONDARY = COLORS.SECONDARY or {}

local function ResolveColor(color, fallback)
  local source = color or fallback or {r = 1, g = 1, b = 1, a = 1}
  if source.r then
    return source.r, source.g or 1, source.b or 1, source.a or 1
  end
  return source[1] or 1, source[2] or 1, source[3] or 1, source[4] or 1
end

local function EnsureBackdrop(frame, edgeSize)
  if not frame or not frame.SetBackdrop then
    return
  end

  frame:SetBackdrop({
    bgFile = "Interface\\Buttons\\WHITE8x8",
    edgeFile = "Interface\\Buttons\\WHITE8x8",
    tile = true,
    tileSize = 8,
    edgeSize = edgeSize or 1,
    insets = {left = 1, right = 1, top = 1, bottom = 1},
  })
end

local function EnsureGradientTexture(frame, key, layer)
  if not frame then return nil end
  if not frame[key] then
    local texture = frame:CreateTexture(nil, layer or "BACKGROUND")
    texture:SetTexture("Interface\\Buttons\\WHITE8x8")
    texture:SetPoint("TOPLEFT", frame, "TOPLEFT", 1, -1)
    texture:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -1, 1)
    frame[key] = texture
  end
  return frame[key]
end

local function ApplyVerticalGradient(texture, topColor, bottomColor, topAlpha, bottomAlpha)
  if not texture or not texture.SetGradientAlpha then return end
  local tr, tg, tb = ResolveColor(topColor, BG_COLORS.light)
  local br, bg, bb = ResolveColor(bottomColor, BG_COLORS.darkest)
  texture:SetGradientAlpha("VERTICAL", tr, tg, tb, topAlpha or 0.9, br, bg, bb, bottomAlpha or 0.9)
end

local function EnsureShadow(frame)
  if not frame then return end
  if not frame._leafShadow then
    local shadow = frame:CreateTexture(nil, "BORDER")
    shadow:SetTexture("Interface\\Buttons\\WHITE8x8")
    shadow:SetPoint("TOPLEFT", frame, "TOPLEFT", 4, -4)
    shadow:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 10, -10)
    frame._leafShadow = shadow
  end
  frame._leafShadow:SetVertexColor(0, 0, 0, 0.45)
end

function LeafVE_FrameSkins:SkinBorder(frame, color, thickness)
  if not frame then return end
  if not frame._leafSkinBorder then
    frame._leafSkinBorder = CreateFrame("Frame", nil, frame)
    frame._leafSkinBorder:SetPoint("TOPLEFT", frame, "TOPLEFT", -1, 1)
    frame._leafSkinBorder:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 1, -1)
  end
  EnsureBackdrop(frame._leafSkinBorder, thickness or 1)
  local r, g, b = ResolveColor(color, QUALITY_COLORS.legendary or QUALITY_COLORS.rare)
  frame._leafSkinBorder:SetBackdropColor(0, 0, 0, 0)
  frame._leafSkinBorder:SetBackdropBorderColor(r, g, b, 0.95)
  return frame._leafSkinBorder
end

function LeafVE_FrameSkins:AddGlowEffect(frame, color, intensity)
  if not frame then return end
  if not frame._leafGlow then
    local glow = frame:CreateTexture(nil, "BACKGROUND")
    glow:SetTexture("Interface\\Buttons\\WHITE8x8")
    glow:SetPoint("TOPLEFT", frame, "TOPLEFT", -8, 8)
    glow:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 8, -8)
    frame._leafGlow = glow
  end
  local r, g, b = ResolveColor(color, TEXT_COLORS.gold)
  frame._leafGlow:SetVertexColor(r, g, b, intensity or 0.12)
  return frame._leafGlow
end

function LeafVE_FrameSkins:AddBevel(frame, topColor, bottomColor)
  if not frame then return end
  if not frame._leafHighlightTop then
    frame._leafHighlightTop = frame:CreateTexture(nil, "ARTWORK")
    frame._leafHighlightTop:SetTexture("Interface\\Buttons\\WHITE8x8")
    frame._leafHighlightTop:SetPoint("TOPLEFT", frame, "TOPLEFT", 2, -2)
    frame._leafHighlightTop:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -2, -2)
    frame._leafHighlightTop:SetHeight(1)
  end
  if not frame._leafShadowBottom then
    frame._leafShadowBottom = frame:CreateTexture(nil, "ARTWORK")
    frame._leafShadowBottom:SetTexture("Interface\\Buttons\\WHITE8x8")
    frame._leafShadowBottom:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 2, 2)
    frame._leafShadowBottom:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 2)
    frame._leafShadowBottom:SetHeight(1)
  end
  local tr, tg, tb = ResolveColor(topColor, TEXT_COLORS.off_white or TEXT_COLORS.normal)
  local br, bg, bb = ResolveColor(bottomColor, BG_COLORS.darkest)
  frame._leafHighlightTop:SetVertexColor(tr, tg, tb, 0.22)
  frame._leafShadowBottom:SetVertexColor(br, bg, bb, 0.8)
end

function LeafVE_FrameSkins:SkinWindow(frame, title, width, height)
  if not frame then return end
  if width then frame:SetWidth(width) end
  if height then frame:SetHeight(height) end

  EnsureBackdrop(frame, 2)
  local bgR, bgG, bgB = ResolveColor(BG_COLORS.dark, {r = 0.12, g = 0.15, b = 0.28})
  local bdR, bdG, bdB = ResolveColor(BG_COLORS.accent or TEXT_COLORS.gold, {r = 1, g = 0.84, b = 0})
  frame:SetBackdropColor(bgR, bgG, bgB, 0.92)
  frame:SetBackdropBorderColor(bdR, bdG, bdB, 0.95)

  local gradient = EnsureGradientTexture(frame, "_leafWindowGradient", "BACKGROUND")
  ApplyVerticalGradient(gradient, BG_COLORS.medium, BG_COLORS.darkest, 0.75, 0.90)

  self:AddBevel(frame, TEXT_COLORS.off_white or TEXT_COLORS.normal, BG_COLORS.darkest)
  EnsureShadow(frame)

  if title and title ~= "" then
    if not frame._leafTitle then
      frame._leafTitle = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
      frame._leafTitle:SetPoint("TOP", frame, "TOP", 0, -14)
    end
    frame._leafTitle:SetText(title)
    if LeafVE_Fonts and LeafVE_Fonts.Apply then
      LeafVE_Fonts:Apply(frame._leafTitle, "h1", "OUTLINE")
    end
    local tr, tg, tb = ResolveColor(TEXT_COLORS.gold, {r = 1, g = 0.84, b = 0})
    frame._leafTitle:SetTextColor(tr, tg, tb, 1)
  end

  return frame
end

function LeafVE_FrameSkins:SkinPanel(frame, bgColor, padding)
  if not frame then return end
  EnsureBackdrop(frame, 1)

  local r, g, b = ResolveColor(bgColor, BG_COLORS.medium)
  local lr, lg, lb = ResolveColor(BG_COLORS.light, BG_COLORS.light)
  frame:SetBackdropColor(r, g, b, 0.86)
  frame:SetBackdropBorderColor(lr, lg, lb, 0.65)

  local gradient = EnsureGradientTexture(frame, "_leafPanelGradient", "BACKGROUND")
  ApplyVerticalGradient(gradient, BG_COLORS.light, bgColor or BG_COLORS.dark, 0.28, 0.08)

  self:AddBevel(frame, TEXT_COLORS.off_white or TEXT_COLORS.normal, BG_COLORS.darkest)
  frame._leafPadding = padding or 12
  return frame
end

local BUTTON_THEMES = {
  info = {
    top = BG_COLORS.light,
    bottom = BG_COLORS.dark,
    hoverTop = BG_COLORS.medium,
    hoverBottom = BG_COLORS.dark,
    pressedTop = BG_COLORS.dark,
    pressedBottom = BG_COLORS.darkest,
    border = TEXT_COLORS.gold,
    hoverText = TEXT_COLORS.gold,
  },
  success = {
    top = {r = 0.15, g = 0.34, b = 0.20},
    bottom = {r = 0.08, g = 0.20, b = 0.12},
    hoverTop = {r = 0.20, g = 0.42, b = 0.25},
    hoverBottom = {r = 0.10, g = 0.24, b = 0.15},
    pressedTop = {r = 0.08, g = 0.20, b = 0.12},
    pressedBottom = {r = 0.06, g = 0.15, b = 0.09},
    border = STATUS_COLORS.success,
    hoverText = TEXT_COLORS.bright_white or TEXT_COLORS.bright,
  },
  warning = {
    top = {r = 0.48, g = 0.30, b = 0.06},
    bottom = {r = 0.26, g = 0.16, b = 0.03},
    hoverTop = {r = 0.58, g = 0.37, b = 0.08},
    hoverBottom = {r = 0.32, g = 0.20, b = 0.04},
    pressedTop = {r = 0.22, g = 0.14, b = 0.03},
    pressedBottom = {r = 0.18, g = 0.10, b = 0.02},
    border = STATUS_COLORS.warning,
    hoverText = TEXT_COLORS.gold,
  },
  error = {
    top = {r = 0.55, g = 0.12, b = 0.12},
    bottom = {r = 0.32, g = 0.06, b = 0.06},
    hoverTop = {r = 0.66, g = 0.15, b = 0.15},
    hoverBottom = {r = 0.38, g = 0.08, b = 0.08},
    pressedTop = {r = 0.28, g = 0.05, b = 0.05},
    pressedBottom = {r = 0.22, g = 0.04, b = 0.04},
    border = TEXT_COLORS.gold,
    hoverText = TEXT_COLORS.gold,
  },
  gear = {
    top = {r = 0.62, g = 0.46, b = 0.12},
    bottom = {r = 0.42, g = 0.30, b = 0.06},
    hoverTop = {r = 0.70, g = 0.52, b = 0.15},
    hoverBottom = {r = 0.46, g = 0.33, b = 0.08},
    pressedTop = {r = 0.36, g = 0.25, b = 0.05},
    pressedBottom = {r = 0.28, g = 0.18, b = 0.04},
    border = TEXT_COLORS.gold,
    hoverText = TEXT_COLORS.bright_white or TEXT_COLORS.bright,
  },
  designations = {
    top = SECONDARY.purple_light or {r = 0.45, g = 0.30, b = 0.60},
    bottom = SECONDARY.purple_dark or {r = 0.25, g = 0.15, b = 0.40},
    hoverTop = {r = 0.55, g = 0.38, b = 0.72},
    hoverBottom = {r = 0.32, g = 0.20, b = 0.50},
    pressedTop = {r = 0.25, g = 0.15, b = 0.40},
    pressedBottom = {r = 0.18, g = 0.10, b = 0.28},
    border = TEXT_COLORS.gold,
    hoverText = TEXT_COLORS.gold,
  },
}

function LeafVE_FrameSkins:SkinButton(frame, style)
  if not frame then return end
  EnsureBackdrop(frame, 1)

  local theme = BUTTON_THEMES[style or ""] or BUTTON_THEMES.info
  frame._leafButtonTheme = theme

  local gradient = EnsureGradientTexture(frame, "_leafButtonGradient", "BACKGROUND")
  local borderR, borderG, borderB = ResolveColor(theme.border, TEXT_COLORS.gold)
  frame:SetBackdropBorderColor(borderR, borderG, borderB, 0.92)

  local function SetButtonVisual(state)
    local enabled = true
    if frame.IsEnabled then
      enabled = frame:IsEnabled()
    end
    if not enabled then
      local dr, dg, db = ResolveColor(STATUS_COLORS.disabled, {r = 0.40, g = 0.40, b = 0.42})
      frame:SetBackdropColor(dr, dg, db, 0.80)
      frame:SetBackdropBorderColor(dr, dg, db, 0.5)
      ApplyVerticalGradient(gradient, STATUS_COLORS.disabled, BG_COLORS.darkest, 0.55, 0.8)
      if frame.GetFontString and frame:GetFontString() then
        local tr, tg, tb = ResolveColor(TEXT_COLORS.muted_gray or TEXT_COLORS.muted, STATUS_COLORS.disabled)
        frame:GetFontString():SetTextColor(tr, tg, tb, 1)
      end
      if frame._leafGlow then frame._leafGlow:SetVertexColor(borderR, borderG, borderB, 0) end
      return
    end

    local top, bottom = theme.top, theme.bottom
    local borderAlpha = 0.92
    local glowAlpha = 0
    local textColor = TEXT_COLORS.bright_white or TEXT_COLORS.bright

    if state == "hover" then
      top, bottom = theme.hoverTop, theme.hoverBottom
      glowAlpha = 0.14
      textColor = theme.hoverText or textColor
    elseif state == "pressed" then
      top, bottom = theme.pressedTop, theme.pressedBottom
      borderAlpha = 1
      glowAlpha = 0.06
    end

    frame:SetBackdropColor(0.03, 0.05, 0.12, 0.8)
    frame:SetBackdropBorderColor(borderR, borderG, borderB, borderAlpha)
    ApplyVerticalGradient(gradient, top, bottom, 0.95, 0.95)

    if frame.GetFontString and frame:GetFontString() then
      local tr, tg, tb = ResolveColor(textColor, TEXT_COLORS.bright_white or TEXT_COLORS.bright)
      frame:GetFontString():SetTextColor(tr, tg, tb, 1)
      if LeafVE_Fonts and LeafVE_Fonts.Apply then
        LeafVE_Fonts:Apply(frame:GetFontString(), "button", "OUTLINE")
      end
    end

    self:AddGlowEffect(frame, theme.border, glowAlpha)
  end

  if not frame._leafSkinButtonHooks then
    frame._leafSkinButtonHooks = true

    frame:HookScript("OnEnter", function(btn)
      if btn._leafButtonSetVisual then btn:_leafButtonSetVisual("hover") end
    end)

    frame:HookScript("OnLeave", function(btn)
      if btn._leafButtonSetVisual then btn:_leafButtonSetVisual("normal") end
    end)

    frame:HookScript("OnMouseDown", function(btn)
      if btn._leafButtonSetVisual then btn:_leafButtonSetVisual("pressed") end
    end)

    frame:HookScript("OnMouseUp", function(btn)
      if btn._leafButtonSetVisual then btn:_leafButtonSetVisual("hover") end
    end)

    frame:HookScript("OnDisable", function(btn)
      if btn._leafButtonSetVisual then btn:_leafButtonSetVisual("disabled") end
    end)

    frame:HookScript("OnEnable", function(btn)
      if btn._leafButtonSetVisual then btn:_leafButtonSetVisual("normal") end
    end)
  end

  frame._leafButtonSetVisual = SetButtonVisual
  SetButtonVisual("normal")
  return frame
end

function LeafVE_FrameSkins:SkinScrollArea(frame)
  if not frame then return end
  EnsureBackdrop(frame, 1)

  local r, g, b = ResolveColor(BG_COLORS.dark, {r = 0.12, g = 0.15, b = 0.28})
  local br, bg, bb = ResolveColor(BG_COLORS.light, {r = 0.25, g = 0.30, b = 0.45})
  frame:SetBackdropColor(r, g, b, 0.68)
  frame:SetBackdropBorderColor(br, bg, bb, 0.6)

  local gradient = EnsureGradientTexture(frame, "_leafScrollGradient", "BACKGROUND")
  ApplyVerticalGradient(gradient, BG_COLORS.medium, BG_COLORS.darkest, 0.30, 0.65)
  return frame
end

function LeafVE_FrameSkins:SkinTab(frame, isActive)
  if not frame then return end
  EnsureBackdrop(frame, 1)

  local active = isActive and true or false
  frame._leafTabActive = active
  local tr, tg, tb = ResolveColor(TEXT_COLORS.bright_white or TEXT_COLORS.bright, {r = 1, g = 1, b = 1})
  local mr, mg, mb = ResolveColor(TEXT_COLORS.muted_gray or TEXT_COLORS.muted, {r = 0.65, g = 0.65, b = 0.70})

  if active then
    frame:SetBackdropColor(0.09, 0.12, 0.24, 0.95)
    local br, bg, bb = ResolveColor(TEXT_COLORS.gold, {r = 1, g = 0.84, b = 0})
    frame:SetBackdropBorderColor(br, bg, bb, 0.95)
  else
    frame:SetBackdropColor(0.08, 0.10, 0.20, 0.86)
    local br, bg, bb = ResolveColor(BG_COLORS.light, {r = 0.25, g = 0.30, b = 0.45})
    frame:SetBackdropBorderColor(br, bg, bb, 0.55)
  end

  local gradient = EnsureGradientTexture(frame, "_leafTabGradient", "BACKGROUND")
  if active then
    ApplyVerticalGradient(gradient, BG_COLORS.medium, BG_COLORS.dark, 0.60, 0.80)
  else
    ApplyVerticalGradient(gradient, BG_COLORS.dark, BG_COLORS.darkest, 0.35, 0.75)
  end

  if not frame._leafTabAccent then
    frame._leafTabAccent = frame:CreateTexture(nil, "ARTWORK")
    frame._leafTabAccent:SetTexture("Interface\\Buttons\\WHITE8x8")
    frame._leafTabAccent:SetPoint("TOPLEFT", frame, "TOPLEFT", 1, -1)
    frame._leafTabAccent:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -1, -1)
    frame._leafTabAccent:SetHeight(2)
  end
  local ar, ag, ab = ResolveColor(TEXT_COLORS.gold, {r = 1, g = 0.84, b = 0})
  frame._leafTabAccent:SetVertexColor(ar, ag, ab, active and 1 or 0)

  if frame.GetFontString and frame:GetFontString() then
    if LeafVE_Fonts and LeafVE_Fonts.Apply then
      LeafVE_Fonts:Apply(frame:GetFontString(), "h3", "OUTLINE")
    end
    if active then
      frame:GetFontString():SetTextColor(tr, tg, tb, 1)
    else
      frame:GetFontString():SetTextColor(mr, mg, mb, 1)
    end
  end

  self:AddGlowEffect(frame, TEXT_COLORS.gold, active and 0.10 or 0)

  if not frame._leafTabHoverHooks then
    frame._leafTabHoverHooks = true
    frame:HookScript("OnEnter", function(tab)
      if tab._leafGlow and not tab._leafTabActive then
        local gr, gg, gb = ResolveColor(TEXT_COLORS.gold, {r = 1, g = 0.84, b = 0})
        tab._leafGlow:SetVertexColor(gr, gg, gb, 0.08)
      end
    end)
    frame:HookScript("OnLeave", function(tab)
      if tab._leafGlow and not tab._leafTabActive then
        local gr, gg, gb = ResolveColor(TEXT_COLORS.gold, {r = 1, g = 0.84, b = 0})
        tab._leafGlow:SetVertexColor(gr, gg, gb, 0)
      end
    end)
  end

  return frame
end

function LeafVE_FrameSkins:SkinProgressBar(frame, color, maxValue)
  if not frame then return end

  local fillColor = color or TEXT_COLORS.gold or STATUS_COLORS.info
  local r, g, b = ResolveColor(fillColor, TEXT_COLORS.gold)

  if frame.SetStatusBarTexture then
    frame:SetStatusBarTexture("Interface\\Buttons\\WHITE8x8")
    frame:SetMinMaxValues(0, maxValue or 100)
    frame:SetStatusBarColor(r, g, b, 1)

    if not frame._leafBarBG then
      frame._leafBarBG = frame:CreateTexture(nil, "BACKGROUND")
      frame._leafBarBG:SetTexture("Interface\\Buttons\\WHITE8x8")
      frame._leafBarBG:SetAllPoints(frame)
    end
    local dr, dg, db = ResolveColor(BG_COLORS.dark, {r = 0.12, g = 0.15, b = 0.28})
    frame._leafBarBG:SetVertexColor(dr, dg, db, 0.85)
  else
    self:SkinPanel(frame, BG_COLORS.medium, 0)
  end

  self:SkinBorder(frame, TEXT_COLORS.gold, 1)
  return frame
end

function LeafVE_FrameSkins:SkinTooltip(frame)
  if not frame then return end
  EnsureBackdrop(frame, 1)

  local dr, dg, db = ResolveColor(BG_COLORS.darkest, {r = 0.05, g = 0.08, b = 0.18})
  local gr, gg, gb = ResolveColor(TEXT_COLORS.gold, {r = 1, g = 0.84, b = 0})
  frame:SetBackdropColor(dr, dg, db, 0.95)
  frame:SetBackdropBorderColor(gr, gg, gb, 0.88)

  local gradient = EnsureGradientTexture(frame, "_leafTooltipGradient", "BACKGROUND")
  ApplyVerticalGradient(gradient, BG_COLORS.medium, BG_COLORS.darkest, 0.35, 0.08)
  return frame
end

function SkinWindow(frame, title, width, height) return LeafVE_FrameSkins:SkinWindow(frame, title, width, height) end
function SkinPanel(frame, bgColor, padding) return LeafVE_FrameSkins:SkinPanel(frame, bgColor, padding) end
function SkinButton(frame, style) return LeafVE_FrameSkins:SkinButton(frame, style) end
function SkinScrollArea(frame) return LeafVE_FrameSkins:SkinScrollArea(frame) end
function SkinTab(frame, isActive) return LeafVE_FrameSkins:SkinTab(frame, isActive) end
function SkinBorder(frame, color, thickness) return LeafVE_FrameSkins:SkinBorder(frame, color, thickness) end
function SkinProgressBar(frame, color, maxValue) return LeafVE_FrameSkins:SkinProgressBar(frame, color, maxValue) end
function AddGlowEffect(frame, color, intensity) return LeafVE_FrameSkins:AddGlowEffect(frame, color, intensity) end
function AddBevel(frame, topColor, bottomColor) return LeafVE_FrameSkins:AddBevel(frame, topColor, bottomColor) end
function SkinTooltip(frame) return LeafVE_FrameSkins:SkinTooltip(frame) end
