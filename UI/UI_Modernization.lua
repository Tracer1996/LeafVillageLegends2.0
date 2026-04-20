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
    local bgR, bgG, bgB, bgA = ColorOr(COLORS.bgBase or (THEME.BG and THEME.BG.base), {0.07, 0.09, 0.12, 0.97})
    local bR, bG, bB, bA = ColorOr(COLORS.border or (THEME.BORDER and THEME.BORDER.normal), {0.28, 0.34, 0.42, 1.0})
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
  local r, g, b, _ = ColorOr(COLORS.accent or (THEME.ACCENT and THEME.ACCENT.primary), {0.24, 0.72, 0.54, 1.0})
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

function LeafVE_UIModernization:StyleInput(frame)
  if not frame then return end
  if LeafVE_FrameSkins and LeafVE_FrameSkins.SkinPanel then
    local bg = LeafVE_Theme and LeafVE_Theme.BG and LeafVE_Theme.BG.elevated
    LeafVE_FrameSkins:SkinPanel(frame, bg)
  end
  if frame.SetBackdropBorderColor then
    local BORDER = LeafVE_Theme and LeafVE_Theme.BORDER or {}
    local normal = BORDER.normal or {r=0.28,g=0.34,b=0.42}
    local accent = BORDER.accent or {r=0.24,g=0.72,b=0.54}
    local r, g, b = normal.r, normal.g, normal.b
    frame:SetBackdropBorderColor(r, g, b, 1)
    if not frame._leafModernInputHooks then
      frame._leafModernInputHooks = true
      frame:HookScript("OnEditFocusGained", function(f)
        f:SetBackdropBorderColor(accent.r, accent.g, accent.b, 1)
      end)
      frame:HookScript("OnEditFocusLost", function(f)
        f:SetBackdropBorderColor(r, g, b, 1)
      end)
    end
  end
end

function LeafVE_UIModernization:StyleToggle(button)
  if not button then return end
  if LeafVE_FrameSkins and LeafVE_FrameSkins.SkinButton then
    LeafVE_FrameSkins:SkinButton(button, "ghost")
  end
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
  stub:SetSize(3, 1)
  local sr, sg, sb = ColorOr((THEME.ACCENT and THEME.ACCENT.primary), {0.24, 0.72, 0.54, 1})
  stub:SetVertexColor(sr, sg, sb, 1)

  local label = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  label:SetPoint("LEFT", stub, "RIGHT", 6, 0)
  label:SetJustifyH("LEFT")
  label:SetText(labelText or "")
  if LeafVE_Fonts and LeafVE_Fonts.Apply then
    LeafVE_Fonts:Apply(label, "section", "")
  else
    label:SetFont("Fonts\\ARIALN.TTF", 10, "")
    label:SetText(string.upper(labelText or ""))
  end
  local lr, lg, lb = ColorOr((THEME.TEXT and THEME.TEXT.muted), {0.42, 0.46, 0.54, 1})
  label:SetTextColor(lr, lg, lb, 1)

  local rule = row:CreateTexture(nil, "ARTWORK")
  rule:SetTexture("Interface\\Buttons\\WHITE8x8")
  rule:SetPoint("LEFT", label, "RIGHT", 8, 0)
  rule:SetPoint("RIGHT", row, "RIGHT", 0, 0)
  rule:SetHeight(1)
  local rr, rg, rb = ColorOr((THEME.BORDER and THEME.BORDER.subtle), {0.18, 0.22, 0.28, 1})
  rule:SetVertexColor(rr, rg, rb, 0.30)

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
