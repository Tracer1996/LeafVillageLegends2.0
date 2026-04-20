LeafVE_Animations = LeafVE_Animations or {}

local function CreateAlphaAnimation(frame, fromAlpha, toAlpha, duration)
  if not frame or not frame.CreateAnimationGroup then
    if frame and frame.SetAlpha then frame:SetAlpha(toAlpha or 1) end
    if toAlpha and toAlpha > 0 and frame and frame.Show then frame:Show() end
    if toAlpha == 0 and frame and frame.Hide then frame:Hide() end
    return nil
  end
  local group = frame:CreateAnimationGroup()
  local alpha = group:CreateAnimation("Alpha")
  alpha:SetFromAlpha(fromAlpha)
  alpha:SetToAlpha(toAlpha)
  alpha:SetDuration(duration or 0.2)
  group:SetScript("OnFinished", function()
    if toAlpha == 0 and frame.Hide then frame:Hide() end
  end)
  return group
end

function LeafVE_Animations:FadeIn(frame, duration)
  if not frame then return end
  frame:Show()
  local group = CreateAlphaAnimation(frame, frame.GetAlpha and frame:GetAlpha() or 0, 1, duration)
  if group then group:Play() end
end

function LeafVE_Animations:FadeOut(frame, duration)
  if not frame then return end
  local group = CreateAlphaAnimation(frame, frame.GetAlpha and frame:GetAlpha() or 1, 0, duration)
  if group then group:Play() end
end

function LeafVE_Animations:SlideIn(frame, direction, duration)
  if not frame then return end
  frame:Show()
  if not frame.CreateAnimationGroup then return end
  local group = frame:CreateAnimationGroup()
  local move = group:CreateAnimation("Translation")
  local d = string.upper(direction or "LEFT")
  local x, y = 0, 0
  if d == "LEFT" then x = -30
  elseif d == "RIGHT" then x = 30
  elseif d == "TOP" then y = 30
  elseif d == "BOTTOM" then y = -30
  end
  move:SetOffset(-x, -y)
  move:SetDuration(duration or 0.2)
  local alpha = group:CreateAnimation("Alpha")
  alpha:SetFromAlpha(0)
  alpha:SetToAlpha(1)
  alpha:SetDuration(duration or 0.2)
  group:Play()
end

function LeafVE_Animations:GlowPulse(frame, color, duration)
  if not frame then return end
  local glow
  if LeafVE_FrameSkins and LeafVE_FrameSkins.AddGlowEffect then
    glow = LeafVE_FrameSkins:AddGlowEffect(frame, color, 0.1)
  elseif AddGlowEffect then
    glow = AddGlowEffect(frame, color, 0.1)
  end
  if not glow or not frame.CreateAnimationGroup then return end
  local group = frame:CreateAnimationGroup()
  group:SetLooping("BOUNCE")
  local alpha = group:CreateAnimation("Alpha")
  alpha:SetDuration(duration or 0.8)
  alpha:SetOrder(1)
  alpha:SetFromAlpha(0.05)
  alpha:SetToAlpha(0.25)
  group:Play()
  frame._leafGlowPulse = group
end

function LeafVE_Animations:ColorTransition(frame, fromColor, toColor, duration)
  if not frame or not frame.CreateAnimationGroup then
    return
  end
  local from = fromColor or {r = 1, g = 1, b = 1}
  local to = toColor or {r = 1, g = 1, b = 1}
  local d = duration or 0.25
  local elapsedTotal = 0
  if frame._leafColorDriver then
    frame._leafColorDriver:SetScript("OnUpdate", nil)
  else
    frame._leafColorDriver = CreateFrame("Frame", nil, frame)
  end
  frame._leafColorDriver:SetScript("OnUpdate", function(_, elapsed)
    elapsedTotal = elapsedTotal + (elapsed or 0)
    local p = elapsedTotal / d
    if p >= 1 then p = 1 end
    local r = (from.r or 1) + (((to.r or 1) - (from.r or 1)) * p)
    local g = (from.g or 1) + (((to.g or 1) - (from.g or 1)) * p)
    local b = (from.b or 1) + (((to.b or 1) - (from.b or 1)) * p)
    if frame.SetBackdropColor then
      frame:SetBackdropColor(r, g, b, 0.9)
    elseif frame.SetVertexColor then
      frame:SetVertexColor(r, g, b, 1)
    elseif frame.SetTextColor then
      frame:SetTextColor(r, g, b, 1)
    end
    if p >= 1 then
      frame._leafColorDriver:SetScript("OnUpdate", nil)
    end
  end)
end

function LeafVE_Animations:ScaleAnimation(frame, fromScale, toScale, duration)
  if not frame then return end
  local startScale = fromScale or frame:GetScale() or 1
  local endScale = toScale or 1
  frame:SetScale(startScale)
  if not frame.CreateAnimationGroup then
    frame:SetScale(endScale)
    return
  end
  local elapsedTotal = 0
  if frame._leafScaleDriver then
    frame._leafScaleDriver:SetScript("OnUpdate", nil)
  else
    frame._leafScaleDriver = CreateFrame("Frame", nil, frame)
  end
  frame._leafScaleDriver:SetScript("OnUpdate", function(_, elapsed)
    elapsedTotal = elapsedTotal + (elapsed or 0)
    local p = elapsedTotal / (duration or 0.2)
    if p >= 1 then p = 1 end
    frame:SetScale(startScale + ((endScale - startScale) * p))
    if p >= 1 then
      frame._leafScaleDriver:SetScript("OnUpdate", nil)
    end
  end)
end

function FadeIn(frame, duration) return LeafVE_Animations:FadeIn(frame, duration) end
function FadeOut(frame, duration) return LeafVE_Animations:FadeOut(frame, duration) end
function SlideIn(frame, direction, duration) return LeafVE_Animations:SlideIn(frame, direction, duration) end
function GlowPulse(frame, color, duration) return LeafVE_Animations:GlowPulse(frame, color, duration) end
function ColorTransition(frame, fromColor, toColor, duration) return LeafVE_Animations:ColorTransition(frame, fromColor, toColor, duration) end
function ScaleAnimation(frame, fromScale, toScale, duration) return LeafVE_Animations:ScaleAnimation(frame, fromScale, toScale, duration) end
