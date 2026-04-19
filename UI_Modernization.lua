LeafVE_UIModernization = LeafVE_UIModernization or {}

local STYLE = LeafVE_Styles or {}
local COLORS = STYLE.colors or {}

local function ColorOr(color, fallback)
  if type(color) == "table" then
    return color[1], color[2], color[3], color[4]
  end
  return fallback[1], fallback[2], fallback[3], fallback[4]
end

function LeafVE_UIModernization:CreateMainFrame(parent)
  return CreateFrame("Frame", nil, parent or UIParent)
end

function LeafVE_UIModernization:ApplyModernFrame(frame)
  if not frame or not frame.SetBackdrop then return end
  frame:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 14,
    insets = {left = 3, right = 3, top = 3, bottom = 3}
  })
  local bgR, bgG, bgB, bgA = ColorOr(COLORS.bgDark, {0.04, 0.06, 0.15, 0.96})
  local bR, bG, bB, bA = ColorOr(COLORS.border, {0.20, 0.24, 0.44, 1.00})
  frame:SetBackdropColor(bgR, bgG, bgB, bgA)
  frame:SetBackdropBorderColor(bR, bG, bB, bA)
  if frame.SetClampedToScreen then
    frame:SetClampedToScreen(true)
  end
end

function LeafVE_UIModernization:StyleButton(button)
  if not button or button._leafModernStyle then return end
  button._leafModernStyle = true

  local glow = button:CreateTexture(nil, "BACKGROUND")
  glow:SetPoint("TOPLEFT", button, "TOPLEFT", -4, 4)
  glow:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 4, -4)
  glow:SetTexture("Interface\\Buttons\\WHITE8x8")
  local r, g, b, _ = ColorOr(COLORS.rare, {0.00, 0.44, 0.87, 1.00})
  glow:SetVertexColor(r, g, b, 0.0)
  button._leafHoverGlow = glow

  button:HookScript("OnEnter", function()
    if button._leafHoverGlow then
      button._leafHoverGlow:SetVertexColor(r, g, b, 0.18)
    end
  end)
  button:HookScript("OnLeave", function()
    if button._leafHoverGlow then
      button._leafHoverGlow:SetVertexColor(r, g, b, 0.0)
    end
  end)
end

function LeafVE_UIModernization:AnimateTabTransition(panel)
  if not panel then return end
  panel:Show()
  panel:SetAlpha(0)
  if not panel._leafFadeDriver then
    panel._leafFadeDriver = CreateFrame("Frame", nil, panel)
  end
  local elapsedTotal = 0
  panel._leafFadeDriver:SetScript("OnUpdate", function(_, elapsed)
    elapsedTotal = elapsedTotal + (elapsed or _G.arg1 or 0)
    local alpha = elapsedTotal / 0.18
    if alpha >= 1 then
      panel:SetAlpha(1)
      panel._leafFadeDriver:SetScript("OnUpdate", nil)
    else
      panel:SetAlpha(alpha)
    end
  end)
end
