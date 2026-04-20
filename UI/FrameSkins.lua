LeafVE_FrameSkins = LeafVE_FrameSkins or {}

local THEME = LeafVE_Theme or {}
local BG = THEME.BG or ((LeafVE_Colors and LeafVE_Colors.BG_COLORS) or {})
local TEXT = THEME.TEXT or ((LeafVE_Colors and LeafVE_Colors.TEXT_COLORS) or {})
local BORDER = THEME.BORDER or {
  subtle = {r = 0.14, g = 0.16, b = 0.20},
  normal = {r = 0.21, g = 0.24, b = 0.31},
  accent = {r = 0.18, g = 0.8, b = 0.443},
  gold = {r = 0.788, g = 0.635, b = 0.153},
  highlight = {r = 0.259, g = 0.298, b = 0.388},
}
local STATUS = THEME.STATUS or ((LeafVE_Colors and LeafVE_Colors.STATUS_COLORS) or {})
local ACCENT = THEME.ACCENT or {
  primary = {r = 0.18, g = 0.8, b = 0.443},
  gold = {r = 0.788, g = 0.635, b = 0.153},
}

local WHITE = "Interface\\Buttons\\WHITE8x8"

local function ResolveColor(color, fallback)
  local c = color or fallback or {r = 1, g = 1, b = 1, a = 1}
  if c.r then
    return c.r or 1, c.g or 1, c.b or 1, c.a or 1
  end
  return c[1] or 1, c[2] or 1, c[3] or 1, c[4] or 1
end

local function EnsureBackdrop(frame, edgeSize)
  if not frame or not frame.SetBackdrop then return end
  frame:SetBackdrop({
    bgFile = WHITE,
    edgeFile = WHITE,
    tile = true,
    tileSize = 8,
    edgeSize = edgeSize or 1,
    insets = {left = 1, right = 1, top = 1, bottom = 1},
  })
end

local function EnsureFillTexture(frame, key, layer)
  if not frame then return nil end
  if not frame[key] then
    local t = frame:CreateTexture(nil, layer or "BACKGROUND")
    t:SetTexture(WHITE)
    t:SetPoint("TOPLEFT", frame, "TOPLEFT", 1, -1)
    t:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -1, 1)
    frame[key] = t
  end
  return frame[key]
end

function LeafVE_FrameSkins:SkinBorder(frame, color, thickness)
  if not frame then return end
  if not frame._leafSkinBorder then
    frame._leafSkinBorder = CreateFrame("Frame", nil, frame)
    frame._leafSkinBorder:SetPoint("TOPLEFT", frame, "TOPLEFT", -1, 1)
    frame._leafSkinBorder:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 1, -1)
  end

  EnsureBackdrop(frame._leafSkinBorder, thickness or 1)
  local r, g, b = ResolveColor(color, BORDER.normal)
  frame._leafSkinBorder:SetBackdropColor(0, 0, 0, 0)
  frame._leafSkinBorder:SetBackdropBorderColor(r, g, b, 1)
  return frame._leafSkinBorder
end

function LeafVE_FrameSkins:AddGlowEffect(frame, color, intensity)
  if not frame then return end
  if not frame._leafGlow then
    local glow = frame:CreateTexture(nil, "BACKGROUND")
    glow:SetTexture(WHITE)
    glow:SetPoint("TOPLEFT", frame, "TOPLEFT", -4, 4)
    glow:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 4, -4)
    frame._leafGlow = glow
  end
  local r, g, b = ResolveColor(color, ACCENT.primary)
  frame._leafGlow:SetVertexColor(r, g, b, intensity or 0.08)
  return frame._leafGlow
end

function LeafVE_FrameSkins:AddBevel(frame, topColor, bottomColor)
  if not frame then return end
  if not frame._leafBevelTop then
    frame._leafBevelTop = frame:CreateTexture(nil, "ARTWORK")
    frame._leafBevelTop:SetTexture(WHITE)
    frame._leafBevelTop:SetPoint("TOPLEFT", frame, "TOPLEFT", 1, -1)
    frame._leafBevelTop:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -1, -1)
    frame._leafBevelTop:SetHeight(1)
  end
  if not frame._leafBevelBottom then
    frame._leafBevelBottom = frame:CreateTexture(nil, "ARTWORK")
    frame._leafBevelBottom:SetTexture(WHITE)
    frame._leafBevelBottom:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 1, 1)
    frame._leafBevelBottom:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -1, 1)
    frame._leafBevelBottom:SetHeight(1)
  end

  local tr, tg, tb = ResolveColor(topColor, BORDER.highlight)
  local br, bg, bb = ResolveColor(bottomColor, BG.base or BG.darkest)
  frame._leafBevelTop:SetVertexColor(tr, tg, tb, 0.55)
  frame._leafBevelBottom:SetVertexColor(br, bg, bb, 0.9)
end

function LeafVE_FrameSkins:SkinWindow(frame, title, width, height)
  if not frame then return end
  if width then frame:SetWidth(width) end
  if height then frame:SetHeight(height) end

  EnsureBackdrop(frame, 1)
  local br, bg, bb = ResolveColor(BG.base or BG.darkest)
  local er, eg, eb = ResolveColor(BORDER.normal)
  frame:SetBackdropColor(br, bg, bb, 0.97)
  frame:SetBackdropBorderColor(er, eg, eb, 1)

  if not frame._leafWindowSheen then
    frame._leafWindowSheen = frame:CreateTexture(nil, "ARTWORK")
    frame._leafWindowSheen:SetTexture(WHITE)
    frame._leafWindowSheen:SetPoint("TOPLEFT", frame, "TOPLEFT", 1, -1)
    frame._leafWindowSheen:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -1, -1)
    frame._leafWindowSheen:SetHeight(36)
  end
  frame._leafWindowSheen:SetGradientAlpha("VERTICAL", 1, 1, 1, 0.025, 0, 0, 0, 0.04)

  if title and title ~= "" then
    if not frame._leafTitle then
      frame._leafTitle = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
      frame._leafTitle:SetPoint("TOP", frame, "TOP", 0, -14)
    end
    frame._leafTitle:SetText(title)
    if LeafVE_Fonts and LeafVE_Fonts.Apply then
      LeafVE_Fonts:Apply(frame._leafTitle, "h1", "OUTLINE")
    end
    local tr, tg, tb = ResolveColor(TEXT.gold or ACCENT.gold)
    frame._leafTitle:SetTextColor(tr, tg, tb, 1)
  end

  return frame
end

function LeafVE_FrameSkins:SkinPanel(frame, bgColor, padding)
  if not frame then return end
  EnsureBackdrop(frame, 1)

  local r, g, b = ResolveColor(bgColor, BG.panel or BG.dark)
  local br, bg, bb = ResolveColor(BORDER.subtle)
  frame:SetBackdropColor(r, g, b, 1)
  frame:SetBackdropBorderColor(br, bg, bb, 1)
  frame._leafPadding = padding or 12
  return frame
end

local BUTTON_THEMES = {
  primary = {
    bg = ACCENT.primary,
    border = ACCENT.primary,
    text = BG.base or {r = 0.059, g = 0.067, b = 0.082},
    hoverBg = {r = 0.215, g = 0.855, b = 0.50},
    hoverBorder = {r = 0.215, g = 0.855, b = 0.50},
    pressedBg = {r = 0.140, g = 0.730, b = 0.390},
    pressedBorder = {r = 0.140, g = 0.730, b = 0.390},
    hoverText = BG.base or {r = 0.059, g = 0.067, b = 0.082},
  },
  secondary = {
    bg = BG.elevated or BG.medium,
    border = BORDER.normal,
    text = TEXT.secondary,
    hoverBg = BG.hover or BG.light,
    hoverBorder = BORDER.accent,
    pressedBg = BG.panel or BG.dark,
    pressedBorder = BORDER.accent,
    hoverText = TEXT.accent or ACCENT.primary,
  },
  ghost = {
    bg = BG.base or BG.darkest,
    border = BORDER.subtle,
    text = TEXT.secondary,
    hoverBg = BG.hover or BG.light,
    hoverBorder = BORDER.highlight,
    pressedBg = BG.panel or BG.dark,
    pressedBorder = BORDER.highlight,
    hoverText = TEXT.primary,
  },
  success = {
    bg = STATUS.success,
    border = STATUS.success,
    text = BG.base or {r = 0.059, g = 0.067, b = 0.082},
    hoverBg = {r = 0.215, g = 0.855, b = 0.50},
    hoverBorder = {r = 0.215, g = 0.855, b = 0.50},
    pressedBg = {r = 0.140, g = 0.730, b = 0.390},
    pressedBorder = {r = 0.140, g = 0.730, b = 0.390},
    hoverText = BG.base or {r = 0.059, g = 0.067, b = 0.082},
  },
  warning = {
    bg = STATUS.warning,
    border = STATUS.warning,
    text = BG.base or {r = 0.059, g = 0.067, b = 0.082},
    hoverBg = {r = 0.955, g = 0.700, b = 0.125},
    hoverBorder = {r = 0.955, g = 0.700, b = 0.125},
    pressedBg = {r = 0.820, g = 0.560, b = 0.000},
    pressedBorder = {r = 0.820, g = 0.560, b = 0.000},
    hoverText = BG.base or {r = 0.059, g = 0.067, b = 0.082},
  },
  error = {
    bg = STATUS.error,
    border = STATUS.error,
    text = TEXT.white or {r = 1, g = 1, b = 1},
    hoverBg = {r = 0.910, g = 0.280, b = 0.280},
    hoverBorder = {r = 0.910, g = 0.280, b = 0.280},
    pressedBg = {r = 0.740, g = 0.150, b = 0.150},
    pressedBorder = {r = 0.740, g = 0.150, b = 0.150},
    hoverText = TEXT.white or {r = 1, g = 1, b = 1},
  },
}

local STYLE_ALIAS = {
  info = "secondary",
  gear = "warning",
  designations = "secondary",
}

function LeafVE_FrameSkins:SkinButton(frame, style)
  if not frame then return end
  EnsureBackdrop(frame, 1)

  local requested = style or "secondary"
  local resolved = STYLE_ALIAS[requested] or requested
  local theme = BUTTON_THEMES[resolved] or BUTTON_THEMES.secondary
  frame._leafButtonTheme = theme
  frame._leafButtonStyle = resolved

  local function SetButtonVisual(state)
    local enabled = true
    if frame.IsEnabled then enabled = frame:IsEnabled() end

    if not enabled then
      local dr, dg, db = ResolveColor(STATUS.disabled, {r = 0.278, g = 0.29, b = 0.318})
      frame:SetBackdropColor(dr, dg, db, 0.7)
      frame:SetBackdropBorderColor(dr, dg, db, 0.6)
      if frame.GetFontString and frame:GetFontString() then
        local tr, tg, tb = ResolveColor(TEXT.muted)
        frame:GetFontString():SetTextColor(tr, tg, tb, 1)
      end
      if frame._leafGlow then frame._leafGlow:SetVertexColor(0, 0, 0, 0) end
      return
    end

    local bgColor = theme.bg
    local border = theme.border
    local text = theme.text or TEXT.primary
    local glowAlpha = 0

    if state == "hover" then
      bgColor = theme.hoverBg or bgColor
      border = theme.hoverBorder or border
      text = theme.hoverText or text
      glowAlpha = 0.08
    elseif state == "pressed" then
      bgColor = theme.pressedBg or bgColor
      border = theme.pressedBorder or border
      glowAlpha = 0.04
    end

    local br, bg, bb = ResolveColor(bgColor)
    local er, eg, eb = ResolveColor(border)
    frame:SetBackdropColor(br, bg, bb, 1)
    frame:SetBackdropBorderColor(er, eg, eb, 1)

    if frame.GetFontString and frame:GetFontString() then
      if LeafVE_Fonts and LeafVE_Fonts.Apply then
        LeafVE_Fonts:Apply(frame:GetFontString(), "button", "")
      end
      local tr, tg, tb = ResolveColor(text)
      frame:GetFontString():SetTextColor(tr, tg, tb, 1)
    end

    self:AddGlowEffect(frame, border, glowAlpha)
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
  local r, g, b = ResolveColor(BG.base or BG.darkest)
  local br, bg, bb = ResolveColor(BORDER.subtle)
  frame:SetBackdropColor(r, g, b, 1)
  frame:SetBackdropBorderColor(br, bg, bb, 1)
  return frame
end

function LeafVE_FrameSkins:SkinTab(frame, isActive)
  if not frame then return end
  EnsureBackdrop(frame, 1)

  frame._leafTabActive = isActive and true or false

  if not frame._leafTabAccent then
    frame._leafTabAccent = frame:CreateTexture(nil, "ARTWORK")
    frame._leafTabAccent:SetTexture(WHITE)
    frame._leafTabAccent:SetPoint("TOPLEFT", frame, "TOPLEFT", 1, -1)
    frame._leafTabAccent:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -1, -1)
    frame._leafTabAccent:SetHeight(2)
  end

  local function ApplyState(state)
    local active = frame._leafTabActive
    if active then
      local r, g, b = ResolveColor(BG.elevated or BG.medium)
      local br, bg, bb = ResolveColor(BORDER.normal)
      frame:SetBackdropColor(r, g, b, 1)
      frame:SetBackdropBorderColor(br, bg, bb, 1)
      local ar, ag, ab = ResolveColor(BORDER.accent)
      frame._leafTabAccent:SetVertexColor(ar, ag, ab, 1)
      if frame.GetFontString and frame:GetFontString() then
        local tr, tg, tb = ResolveColor(TEXT.primary)
        frame:GetFontString():SetTextColor(tr, tg, tb, 1)
      end
      return
    end

    local bgColor = BG.panel or BG.dark
    local textColor = TEXT.secondary
    if state == "hover" then
      bgColor = BG.hover or BG.light
      textColor = TEXT.primary
    end
    local r, g, b = ResolveColor(bgColor)
    local br, bg, bb = ResolveColor(BORDER.subtle)
    frame:SetBackdropColor(r, g, b, 1)
    frame:SetBackdropBorderColor(br, bg, bb, 1)
    frame._leafTabAccent:SetVertexColor(0, 0, 0, 0)
    if frame.GetFontString and frame:GetFontString() then
      local tr, tg, tb = ResolveColor(textColor)
      frame:GetFontString():SetTextColor(tr, tg, tb, 1)
    end
  end

  if frame.GetFontString and frame:GetFontString() and LeafVE_Fonts and LeafVE_Fonts.Apply then
    LeafVE_Fonts:Apply(frame:GetFontString(), "h3", "")
  end

  if not frame._leafTabHoverHooks then
    frame._leafTabHoverHooks = true
    frame:HookScript("OnEnter", function(tab)
      if tab._leafApplyTabState then tab:_leafApplyTabState("hover") end
    end)
    frame:HookScript("OnLeave", function(tab)
      if tab._leafApplyTabState then tab:_leafApplyTabState("normal") end
    end)
  end

  frame._leafApplyTabState = ApplyState
  ApplyState("normal")
  return frame
end

function LeafVE_FrameSkins:SkinProgressBar(frame, color, maxValue)
  if not frame then return end

  local fill = color or ACCENT.primary
  local r, g, b = ResolveColor(fill)

  if frame.SetStatusBarTexture then
    frame:SetStatusBarTexture(WHITE)
    frame:SetMinMaxValues(0, maxValue or 100)
    frame:SetStatusBarColor(r, g, b, 1)

    if not frame._leafBarBG then
      frame._leafBarBG = frame:CreateTexture(nil, "BACKGROUND")
      frame._leafBarBG:SetTexture(WHITE)
      frame._leafBarBG:SetAllPoints(frame)
    end
    local dr, dg, db = ResolveColor(BG.base or BG.darkest)
    frame._leafBarBG:SetVertexColor(dr, dg, db, 1)
  else
    self:SkinPanel(frame, BG.panel or BG.dark)
  end

  self:SkinBorder(frame, BORDER.normal, 1)
  return frame
end

function LeafVE_FrameSkins:SkinTooltip(frame)
  if not frame then return end
  EnsureBackdrop(frame, 1)

  local r, g, b = ResolveColor(BG.base or BG.darkest)
  local br, bg, bb = ResolveColor(BORDER.gold)
  frame:SetBackdropColor(r, g, b, 0.97)
  frame:SetBackdropBorderColor(br, bg, bb, 1)

  local grad = EnsureFillTexture(frame, "_leafTooltipGradient", "BACKGROUND")
  if grad and grad.SetGradientAlpha then
    local tr, tg, tb = ResolveColor(BG.elevated or BG.medium)
    grad:SetGradientAlpha("VERTICAL", tr, tg, tb, 0.15, r, g, b, 0.05)
  end
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
