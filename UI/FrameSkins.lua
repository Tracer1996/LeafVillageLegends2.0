LeafVE_FrameSkins = LeafVE_FrameSkins or {}

local COLORS = LeafVE_Colors or {}
local BG_COLORS = COLORS.BG_COLORS or {}
local TEXT_COLORS = COLORS.TEXT_COLORS or {}
local STATUS_COLORS = COLORS.STATUS_COLORS or {}
local QUALITY_COLORS = COLORS.QUALITY_COLORS or {}

local function ResolveColor(color, fallback)
  local source = color or fallback or {r = 1, g = 1, b = 1}
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
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true,
    tileSize = 8,
    edgeSize = edgeSize or 12,
    insets = {left = 3, right = 3, top = 3, bottom = 3},
  })
end

function LeafVE_FrameSkins:SkinBorder(frame, color, thickness)
  if not frame then return end
  if not frame._leafSkinBorder then
    frame._leafSkinBorder = CreateFrame("Frame", nil, frame)
    frame._leafSkinBorder:SetPoint("TOPLEFT", frame, "TOPLEFT", -1, 1)
    frame._leafSkinBorder:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 1, -1)
  end
  EnsureBackdrop(frame._leafSkinBorder, thickness or 12)
  local r, g, b = ResolveColor(color, QUALITY_COLORS.rare)
  frame._leafSkinBorder:SetBackdropColor(0, 0, 0, 0)
  frame._leafSkinBorder:SetBackdropBorderColor(r, g, b, 1)
  return frame._leafSkinBorder
end

function LeafVE_FrameSkins:AddGlowEffect(frame, color, intensity)
  if not frame then return end
  if not frame._leafGlow then
    local glow = frame:CreateTexture(nil, "BACKGROUND")
    glow:SetTexture("Interface\\Buttons\\WHITE8x8")
    glow:SetPoint("TOPLEFT", frame, "TOPLEFT", -5, 5)
    glow:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 5, -5)
    frame._leafGlow = glow
  end
  local r, g, b = ResolveColor(color, QUALITY_COLORS.rare)
  frame._leafGlow:SetVertexColor(r, g, b, intensity or 0.15)
  return frame._leafGlow
end

function LeafVE_FrameSkins:AddBevel(frame, topColor, bottomColor)
  if not frame then return end
  if not frame._leafBevelTop then
    frame._leafBevelTop = frame:CreateTexture(nil, "BORDER")
    frame._leafBevelTop:SetTexture("Interface\\Buttons\\WHITE8x8")
    frame._leafBevelTop:SetPoint("TOPLEFT", frame, "TOPLEFT", 2, -2)
    frame._leafBevelTop:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -2, -2)
    frame._leafBevelTop:SetHeight(1)
  end
  if not frame._leafBevelBottom then
    frame._leafBevelBottom = frame:CreateTexture(nil, "BORDER")
    frame._leafBevelBottom:SetTexture("Interface\\Buttons\\WHITE8x8")
    frame._leafBevelBottom:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 2, 2)
    frame._leafBevelBottom:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 2)
    frame._leafBevelBottom:SetHeight(1)
  end
  local tr, tg, tb = ResolveColor(topColor, TEXT_COLORS.bright)
  local br, bg, bb = ResolveColor(bottomColor, BG_COLORS.dark)
  frame._leafBevelTop:SetVertexColor(tr, tg, tb, 0.25)
  frame._leafBevelBottom:SetVertexColor(br, bg, bb, 0.8)
end

function LeafVE_FrameSkins:SkinWindow(frame, title, width, height)
  if not frame then return end
  if width then frame:SetWidth(width) end
  if height then frame:SetHeight(height) end
  EnsureBackdrop(frame, 14)
  local bgR, bgG, bgB = ResolveColor(BG_COLORS.darkest, {r = 0.04, g = 0.06, b = 0.15})
  local bdR, bdG, bdB = ResolveColor(QUALITY_COLORS.rare, {r = 0.00, g = 0.44, b = 0.87})
  frame:SetBackdropColor(bgR, bgG, bgB, 0.93)
  frame:SetBackdropBorderColor(bdR, bdG, bdB, 1)
  self:AddBevel(frame, TEXT_COLORS.bright, BG_COLORS.medium)
  self:AddGlowEffect(frame, QUALITY_COLORS.rare, 0.08)
  if title and title ~= "" then
    if not frame._leafTitle then
      frame._leafTitle = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
      frame._leafTitle:SetPoint("TOP", frame, "TOP", 0, -12)
    end
    frame._leafTitle:SetText(title)
    if LeafVE_Fonts and LeafVE_Fonts.Apply then
      LeafVE_Fonts:Apply(frame._leafTitle, "header_large", "OUTLINE")
    end
    local tr, tg, tb = ResolveColor(TEXT_COLORS.gold, {r = 1, g = 0.82, b = 0})
    frame._leafTitle:SetTextColor(tr, tg, tb, 1)
  end
  return frame
end

function LeafVE_FrameSkins:SkinPanel(frame, bgColor, padding)
  if not frame then return end
  EnsureBackdrop(frame, 12)
  local r, g, b = ResolveColor(bgColor, BG_COLORS.dark)
  frame:SetBackdropColor(r, g, b, 0.84)
  frame:SetBackdropBorderColor(0.24, 0.27, 0.38, 1)
  frame._leafPadding = padding or 8
  return frame
end

function LeafVE_FrameSkins:SkinButton(frame, style)
  if not frame then return end
  EnsureBackdrop(frame, 12)
  local base = STATUS_COLORS.info
  if style == "success" then
    base = STATUS_COLORS.success
  elseif style == "warning" then
    base = STATUS_COLORS.warning
  elseif style == "error" then
    base = STATUS_COLORS.error
  end
  local r, g, b = ResolveColor(base, QUALITY_COLORS.rare)
  frame:SetBackdropColor(0.10, 0.12, 0.23, 0.92)
  frame:SetBackdropBorderColor(r, g, b, 0.9)
  self:AddBevel(frame, TEXT_COLORS.bright, BG_COLORS.medium)
  self:AddGlowEffect(frame, base, 0)
  if not frame._leafSkinButtonHooks then
    frame._leafSkinButtonHooks = true
    frame:HookScript("OnEnter", function(btn)
      if btn._leafGlow then
        local hr, hg, hb = ResolveColor(base, QUALITY_COLORS.rare)
        btn._leafGlow:SetVertexColor(hr, hg, hb, 0.20)
      end
    end)
    frame:HookScript("OnLeave", function(btn)
      if btn._leafGlow then
        local lr, lg, lb = ResolveColor(base, QUALITY_COLORS.rare)
        btn._leafGlow:SetVertexColor(lr, lg, lb, 0)
      end
    end)
  end
  return frame
end

function LeafVE_FrameSkins:SkinScrollArea(frame)
  if not frame then return end
  EnsureBackdrop(frame, 12)
  local r, g, b = ResolveColor(BG_COLORS.dark, {r = 0.10, g = 0.12, b = 0.23})
  frame:SetBackdropColor(r, g, b, 0.65)
  frame:SetBackdropBorderColor(0.22, 0.25, 0.37, 1)
  return frame
end

function LeafVE_FrameSkins:SkinTab(frame, isActive)
  if not frame then return end
  EnsureBackdrop(frame, 10)
  if isActive then
    frame:SetBackdropColor(0.17, 0.19, 0.31, 0.95)
    frame:SetBackdropBorderColor(0.00, 0.44, 0.87, 1)
  else
    frame:SetBackdropColor(0.10, 0.12, 0.23, 0.85)
    frame:SetBackdropBorderColor(0.24, 0.27, 0.38, 0.9)
  end
  if frame.GetFontString and frame:GetFontString() then
    local color = isActive and TEXT_COLORS.bright or TEXT_COLORS.normal
    local r, g, b = ResolveColor(color, {r = 1, g = 1, b = 1})
    frame:GetFontString():SetTextColor(r, g, b, 1)
  end
  return frame
end

function LeafVE_FrameSkins:SkinProgressBar(frame, color, maxValue)
  if not frame then return end
  if frame.SetStatusBarTexture then
    frame:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
    frame:SetMinMaxValues(0, maxValue or 100)
    local r, g, b = ResolveColor(color, STATUS_COLORS.info)
    frame:SetStatusBarColor(r, g, b, 1)
  else
    self:SkinPanel(frame, BG_COLORS.medium, 0)
  end
  self:SkinBorder(frame, color or STATUS_COLORS.info, 10)
  return frame
end

function LeafVE_FrameSkins:SkinTooltip(frame)
  if not frame then return end
  EnsureBackdrop(frame, 12)
  local dr, dg, db = ResolveColor(BG_COLORS.darkest, {r = 0.04, g = 0.06, b = 0.15})
  local rr, rg, rb = ResolveColor(QUALITY_COLORS.rare, {r = 0.00, g = 0.44, b = 0.87})
  frame:SetBackdropColor(dr, dg, db, 0.95)
  frame:SetBackdropBorderColor(rr, rg, rb, 1)
  if not frame._leafTooltipGradient then
    frame._leafTooltipGradient = frame:CreateTexture(nil, "BACKGROUND")
    frame._leafTooltipGradient:SetTexture("Interface\\Buttons\\WHITE8x8")
    frame._leafTooltipGradient:SetPoint("TOPLEFT", frame, "TOPLEFT", 2, -2)
    frame._leafTooltipGradient:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 2)
  end
  local lr, lg, lb = ResolveColor(BG_COLORS.light, {r = 0.24, g = 0.27, b = 0.38})
  frame._leafTooltipGradient:SetGradientAlpha("VERTICAL", lr, lg, lb, 0.22, dr, dg, db, 0.05)
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
