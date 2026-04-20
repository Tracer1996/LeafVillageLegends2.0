LeafVE_UIModernization = LeafVE_UIModernization or {}

local STYLE = LeafVE_Styles or {}
local COLORS = STYLE.colors or {}
local THEME = LeafVE_Theme or {}
local TAB_FADE_DURATION = 0.18

local function ColorOr(color, fallback)
  local fb = fallback or {1, 1, 1, 1}
  local f1, f2, f3, f4 = fb[1], fb[2], fb[3], fb[4]
  if type(color) == "table" then
    if color.r then
      return color.r or f1, color.g or f2, color.b or f3, color.a or f4
    end
    return color[1] or f1, color[2] or f2, color[3] or f3, color[4] or f4
  end
  return f1, f2, f3, f4
end

function LeafVE_UIModernization:CreateMainFrame(parent)
  return CreateFrame("Frame", nil, parent or UIParent)
end

function LeafVE_UIModernization:ApplyModernFrame(frame)
  if not frame then return end
  if LeafVE_ApplyMainWindowSkin then
    LeafVE_ApplyMainWindowSkin(frame)
  elseif LeafVE_FrameSkins and LeafVE_FrameSkins.SkinWindow then
    LeafVE_FrameSkins:SkinWindow(frame, nil)
  else
    frame:SetBackdrop({
      bgFile = "Interface\\Buttons\\WHITE8x8",
      edgeFile = "Interface\\Buttons\\WHITE8x8",
      tile = true, tileSize = 8, edgeSize = 1,
      insets = {left = 1, right = 1, top = 1, bottom = 1}
    })
    local bgR, bgG, bgB, bgA = ColorOr(COLORS.bgBase or (THEME.BG and THEME.BG.base), {0.059, 0.067, 0.082, 0.97})
    local bR, bG, bB, bA = ColorOr(COLORS.border or (THEME.BORDER and THEME.BORDER.normal), {0.208, 0.235, 0.306, 1.0})
    frame:SetBackdropColor(bgR, bgG, bgB, bgA or 0.97)
    frame:SetBackdropBorderColor(bR, bG, bB, bA or 1.0)
  end
  if frame.SetClampedToScreen then
    frame:SetClampedToScreen(true)
  end
end

function LeafVE_UIModernization:StyleButton(button)
  if not button or button._leafModernStyle then return end
  button._leafModernStyle = true

  if LeafVE_FrameSkins and LeafVE_FrameSkins.SkinButton then
    LeafVE_FrameSkins:SkinButton(button, "secondary")
  end

  local glow = button:CreateTexture(nil, "BACKGROUND")
  glow:SetPoint("TOPLEFT", button, "TOPLEFT", -4, 4)
  glow:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 4, -4)
  glow:SetTexture("Interface\\Buttons\\WHITE8x8")
  local r, g, b, _ = ColorOr(COLORS.accent or (THEME.ACCENT and THEME.ACCENT.primary), {0.180, 0.800, 0.443, 1.0})
  glow:SetVertexColor(r, g, b, 0.0)
  button._leafHoverGlow = glow

  button:HookScript("OnEnter", function()
    if button._leafHoverGlow then
      button._leafHoverGlow:SetVertexColor(r, g, b, 0.12)
    end
  end)
  button:HookScript("OnLeave", function()
    if button._leafHoverGlow then
      button._leafHoverGlow:SetVertexColor(r, g, b, 0.0)
    end
  end)
end

function LeafVE_UIModernization:CreateSectionHeader(parent, labelText, yOffset)
  if not parent then return nil end

  local row = CreateFrame("Frame", nil, parent)
  row:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, yOffset or 0)
  row:SetPoint("TOPRIGHT", parent, "TOPRIGHT", 0, yOffset or 0)
  row:SetHeight(14)

  local stub = row:CreateTexture(nil, "ARTWORK")
  stub:SetTexture("Interface\\Buttons\\WHITE8x8")
  stub:SetPoint("LEFT", row, "LEFT", 0, 0)
  stub:SetSize(8, 1)
  local sr, sg, sb = ColorOr((THEME.ACCENT and THEME.ACCENT.primary), {0.180, 0.800, 0.443, 1})
  stub:SetVertexColor(sr, sg, sb, 1)

  local label = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  label:SetPoint("LEFT", stub, "RIGHT", 6, 0)
  label:SetJustifyH("LEFT")
  label:SetText(labelText or "")
  label:SetFont("Fonts\\ARIALN.TTF", 10, "")
  local lr, lg, lb = ColorOr((THEME.TEXT and THEME.TEXT.muted), {0.380, 0.396, 0.427, 1})
  label:SetTextColor(lr, lg, lb, 1)

  local rule = row:CreateTexture(nil, "ARTWORK")
  rule:SetTexture("Interface\\Buttons\\WHITE8x8")
  rule:SetPoint("LEFT", label, "RIGHT", 8, 0)
  rule:SetPoint("RIGHT", row, "RIGHT", 0, 0)
  rule:SetHeight(1)
  local rr, rg, rb = ColorOr((THEME.BORDER and THEME.BORDER.subtle), {0.137, 0.153, 0.200, 1})
  rule:SetVertexColor(rr, rg, rb, 0.45)

  row.stub = stub
  row.label = label
  row.rule = rule
  return row
end

function LeafVE_UIModernization:AnimateTabTransition(panel)
  if not panel then return end
  if LeafVE_Animations and LeafVE_Animations.FadeIn then
    LeafVE_Animations:FadeIn(panel, TAB_FADE_DURATION)
    return
  end
  panel:Show()
  panel:SetAlpha(0)
  if not panel._leafFadeDriver then
    panel._leafFadeDriver = CreateFrame("Frame", nil, panel)
  end
  local elapsedTotal = 0
  panel._leafFadeDriver:SetScript("OnUpdate", function(_, elapsed)
    elapsedTotal = elapsedTotal + (elapsed or 0)
    local alpha = elapsedTotal / TAB_FADE_DURATION
    if alpha >= 1 then
      panel:SetAlpha(1)
      panel._leafFadeDriver:SetScript("OnUpdate", nil)
    else
      panel:SetAlpha(alpha)
    end
  end)
end
