LeafVE_PlayerCard = LeafVE_PlayerCard or {}

local THEME = LeafVE_Theme or {}
local BG = THEME.BG or {}
local TEXT = THEME.TEXT or {}
local BORDER = THEME.BORDER or {}
local ACCENT = THEME.ACCENT or {}
local STATUS = THEME.STATUS or {}

local WHITE = "Interface\\Buttons\\WHITE8x8"

local function RGBA(c, a)
  if LeafVE_Theme and LeafVE_Theme.RGBA then
    return LeafVE_Theme:RGBA(c, a)
  end
  if not c then return 1, 1, 1, a or 1 end
  return c.r or 1, c.g or 1, c.b or 1, c.a or a or 1
end

local function EnsureBackdrop(frame, edge)
  if not frame or not frame.SetBackdrop then return end
  frame:SetBackdrop({
    bgFile = WHITE,
    edgeFile = WHITE,
    tile = true,
    tileSize = 8,
    edgeSize = edge or 1,
    insets = {left = 1, right = 1, top = 1, bottom = 1},
  })
end

local function ApplyPane(frame, bgColor, borderColor, edge)
  EnsureBackdrop(frame, edge or 1)
  local r, g, b = RGBA(bgColor)
  local br, bg, bb = RGBA(borderColor)
  frame:SetBackdropColor(r, g, b, 1)
  frame:SetBackdropBorderColor(br, bg, bb, 1)
end

function LeafVE_PlayerCard:Create(parent)
  local card = CreateFrame("Frame", nil, parent)
  ApplyPane(card, BG.panel, BORDER.subtle, 1)

  card.header = CreateFrame("Frame", nil, card)
  card.header:SetPoint("TOPLEFT", card, "TOPLEFT", 8, -8)
  card.header:SetPoint("TOPRIGHT", card, "TOPRIGHT", -8, -8)
  card.header:SetHeight(74)
  ApplyPane(card.header, BG.elevated, BORDER.subtle, 1)

  card.statusDot = card.header:CreateTexture(nil, "OVERLAY")
  card.statusDot:SetTexture(WHITE)
  card.statusDot:SetPoint("TOPLEFT", card.header, "TOPLEFT", 10, -10)
  card.statusDot:SetSize(6, 6)

  card.statusLabel = card.header:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  card.statusLabel:SetPoint("LEFT", card.statusDot, "RIGHT", 6, 0)
  card.statusLabel:SetFont("Fonts\\ARIALN.TTF", 10, "")

  card.nameFS = card.header:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  card.nameFS:SetPoint("TOPLEFT", card.header, "TOPLEFT", 10, -22)
  card.nameFS:SetPoint("TOPRIGHT", card.header, "TOPRIGHT", -10, -22)
  card.nameFS:SetJustifyH("LEFT")
  card.nameFS:SetFont("Fonts\\FRIZQT__.TTF", 19, "")

  card.subtitleFS = card.header:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  card.subtitleFS:SetPoint("TOPLEFT", card.nameFS, "BOTTOMLEFT", 0, -2)
  card.subtitleFS:SetFont("Fonts\\ARIALN.TTF", 11, "")
  card.subtitleFS:SetJustifyH("LEFT")

  card.rankFS = card.header:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  card.rankFS:SetPoint("TOPRIGHT", card.header, "TOPRIGHT", -10, -44)
  card.rankFS:SetFont("Fonts\\FRIZQT__.TTF", 11, "")
  card.rankFS:SetJustifyH("RIGHT")

  card.modelWrap = CreateFrame("Frame", nil, card)
  card.modelWrap:SetPoint("TOPLEFT", card.header, "BOTTOMLEFT", 0, -8)
  card.modelWrap:SetPoint("TOPRIGHT", card.header, "BOTTOMRIGHT", 0, -8)
  card.modelWrap:SetHeight(190)
  ApplyPane(card.modelWrap, BG.base, BORDER.normal, 2)

  card.model = CreateFrame("PlayerModel", nil, card.modelWrap)
  card.model:SetPoint("TOPLEFT", card.modelWrap, "TOPLEFT", 2, -2)
  card.model:SetPoint("BOTTOMRIGHT", card.modelWrap, "BOTTOMRIGHT", -2, 2)
  card.model:SetFacing(0.1 * math.pi)

  card.liveFS = card:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  card.liveFS:SetPoint("TOP", card.modelWrap, "BOTTOM", 0, -4)
  card.liveFS:SetFont("Fonts\\ARIALN.TTF", 10, "")
  card.liveFS:SetText("Live")

  card.specPill = CreateFrame("Frame", nil, card)
  card.specPill:SetPoint("TOPLEFT", card.liveFS, "BOTTOMLEFT", -90, -8)
  card.specPill:SetPoint("TOPRIGHT", card.liveFS, "BOTTOMRIGHT", 90, -8)
  card.specPill:SetHeight(22)
  ApplyPane(card.specPill, BG.elevated, BORDER.accent, 1)

  card.specFS = card.specPill:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  card.specFS:SetPoint("CENTER", card.specPill, "CENTER", 0, 0)
  card.specFS:SetFont("Fonts\\ARIALN.TTF", 11, "")

  card.achPane = CreateFrame("Frame", nil, card)
  card.achPane:SetPoint("TOPLEFT", card.specPill, "BOTTOMLEFT", 0, -8)
  card.achPane:SetPoint("TOPRIGHT", card.specPill, "BOTTOMRIGHT", 0, -8)
  card.achPane:SetHeight(42)
  ApplyPane(card.achPane, BG.elevated, BORDER.subtle, 1)

  card.achLabel = card.achPane:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  card.achLabel:SetPoint("TOPLEFT", card.achPane, "TOPLEFT", 8, -6)
  card.achLabel:SetFont("Fonts\\FRIZQT__.TTF", 11, "")
  card.achLabel:SetText("Achievements")

  card.achPoints = card.achPane:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  card.achPoints:SetPoint("TOPLEFT", card.achLabel, "BOTTOMLEFT", 0, -2)
  card.achPoints:SetFont("Fonts\\FRIZQT__.TTF", 14, "")

  card.badgePane = CreateFrame("Frame", nil, card)
  card.badgePane:SetPoint("TOPLEFT", card.achPane, "BOTTOMLEFT", 0, -8)
  card.badgePane:SetPoint("TOPRIGHT", card.achPane, "BOTTOMRIGHT", 0, -8)
  card.badgePane:SetHeight(88)
  ApplyPane(card.badgePane, BG.panel, BORDER.subtle, 1)

  card.badges = {}
  for i = 1, 9 do
    local cell = CreateFrame("Frame", nil, card.badgePane)
    cell:SetSize(26, 26)
    local col = (i - 1) % 3
    local row = math.floor((i - 1) / 3)
    cell:SetPoint("TOPLEFT", card.badgePane, "TOPLEFT", 8 + col * 30, -8 - row * 30)
    ApplyPane(cell, BG.elevated, BORDER.subtle, 1)

    cell.icon = cell:CreateTexture(nil, "ARTWORK")
    cell.icon:SetPoint("TOPLEFT", cell, "TOPLEFT", 2, -2)
    cell.icon:SetPoint("BOTTOMRIGHT", cell, "BOTTOMRIGHT", -2, 2)
    cell.icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")

    cell:SetScript("OnEnter", function(f)
      local r, g, b = RGBA(BORDER.accent)
      f:SetBackdropBorderColor(r, g, b, 1)
    end)
    cell:SetScript("OnLeave", function(f)
      local r, g, b = RGBA(BORDER.subtle)
      f:SetBackdropBorderColor(r, g, b, 1)
    end)

    card.badges[i] = cell
  end

  card.designPane = CreateFrame("Frame", nil, card)
  card.designPane:SetPoint("TOPLEFT", card.badgePane, "BOTTOMLEFT", 0, -8)
  card.designPane:SetPoint("TOPRIGHT", card.badgePane, "BOTTOMRIGHT", 0, -8)
  card.designPane:SetHeight(42)
  ApplyPane(card.designPane, BG.elevated, BORDER.subtle, 1)

  card.designLine1 = card.designPane:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  card.designLine1:SetPoint("TOPLEFT", card.designPane, "TOPLEFT", 8, -7)
  card.designLine1:SetPoint("TOPRIGHT", card.designPane, "TOPRIGHT", -8, -7)
  card.designLine1:SetJustifyH("LEFT")
  card.designLine1:SetFont("Fonts\\ARIALN.TTF", 10, "")

  card.designLine2 = card.designPane:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  card.designLine2:SetPoint("TOPLEFT", card.designLine1, "BOTTOMLEFT", 0, -4)
  card.designLine2:SetPoint("TOPRIGHT", card.designLine1, "TOPRIGHT", 0, -4)
  card.designLine2:SetJustifyH("LEFT")
  card.designLine2:SetFont("Fonts\\ARIALN.TTF", 10, "")

  card.wisdomPane = CreateFrame("Frame", nil, card)
  card.wisdomPane:SetPoint("TOPLEFT", card.designPane, "BOTTOMLEFT", 0, -8)
  card.wisdomPane:SetPoint("TOPRIGHT", card.designPane, "BOTTOMRIGHT", 0, -8)
  card.wisdomPane:SetHeight(52)
  ApplyPane(card.wisdomPane, BG.elevated, BORDER.subtle, 1)

  card.quoteMark = card.wisdomPane:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  card.quoteMark:SetPoint("TOPLEFT", card.wisdomPane, "TOPLEFT", 8, -4)
  card.quoteMark:SetFont("Fonts\\FRIZQT__.TTF", 18, "")
  card.quoteMark:SetText("\"")

  card.wisdomFS = card.wisdomPane:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  card.wisdomFS:SetPoint("TOPLEFT", card.quoteMark, "TOPRIGHT", 4, -2)
  card.wisdomFS:SetPoint("BOTTOMRIGHT", card.wisdomPane, "BOTTOMRIGHT", -8, 8)
  card.wisdomFS:SetJustifyH("LEFT")
  card.wisdomFS:SetJustifyV("TOP")
  card.wisdomFS:SetWordWrap(true)
  card.wisdomFS:SetNonSpaceWrap(true)
  card.wisdomFS:SetFont("Fonts\\ARIALN.TTF", 10, "")

  card.buttonRow = CreateFrame("Frame", nil, card)
  card.buttonRow:SetPoint("TOPLEFT", card.wisdomPane, "BOTTOMLEFT", 0, -10)
  card.buttonRow:SetPoint("TOPRIGHT", card.wisdomPane, "BOTTOMRIGHT", 0, -10)
  card.buttonRow:SetHeight(24)

  local gap = 6
  local buttonWidth = (card.buttonRow:GetWidth() - (gap * 2)) / 3

  card.achButton = CreateFrame("Button", nil, card.buttonRow)
  card.achButton:SetText("ACHIEVEMENTS")
  card.achButton:SetPoint("LEFT", card.buttonRow, "LEFT", 0, 0)
  card.achButton:SetHeight(24)

  card.gearButton = CreateFrame("Button", nil, card.buttonRow)
  card.gearButton:SetText("GEAR")
  card.gearButton:SetPoint("LEFT", card.achButton, "RIGHT", gap, 0)
  card.gearButton:SetHeight(24)

  card.badgesButton = CreateFrame("Button", nil, card.buttonRow)
  card.badgesButton:SetText("BADGES")
  card.badgesButton:SetPoint("LEFT", card.gearButton, "RIGHT", gap, 0)
  card.badgesButton:SetPoint("RIGHT", card.buttonRow, "RIGHT", 0, 0)
  card.badgesButton:SetHeight(24)

  local function ResizeButtons()
    local total = card.buttonRow:GetWidth() or 0
    local w = math.max(20, (total - gap * 2) / 3)
    card.achButton:SetWidth(w)
    card.gearButton:SetWidth(w)
    card.badgesButton:SetWidth(w)
  end
  card.buttonRow:SetScript("OnSizeChanged", ResizeButtons)

  if LeafVE_FrameSkins and LeafVE_FrameSkins.SkinButton then
    LeafVE_FrameSkins:SkinButton(card.achButton, "primary")
    LeafVE_FrameSkins:SkinButton(card.gearButton, "secondary")
    LeafVE_FrameSkins:SkinButton(card.badgesButton, "secondary")
  end

  card.achButton:SetScript("OnClick", function()
    if card.onViewAchievements then card.onViewAchievements(card.member) end
  end)
  card.gearButton:SetScript("OnClick", function()
    if card.onViewGear then card.onViewGear(card.member) end
  end)
  card.badgesButton:SetScript("OnClick", function()
    if card.onViewBadges then card.onViewBadges(card.member) end
  end)

  function card:SetBadges(arr)
    for i = 1, #self.badges do
      local cell = self.badges[i]
      local badge = arr and arr[i]
      if badge and badge.icon then
        cell.icon:SetTexture(badge.icon)
        cell:Show()
      else
        cell.icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
        cell:Show()
      end
    end
  end

  function card:LoadMember(m)
    self.member = m or {}
    local member = self.member

    local online = member.online and true or false
    local sr, sg, sb = RGBA(online and STATUS.success or TEXT.muted)
    self.statusDot:SetVertexColor(sr, sg, sb, 1)
    self.statusLabel:SetText(online and "Online" or "Offline")
    self.statusLabel:SetTextColor(sr, sg, sb, 1)

    local nr, ng, nb = RGBA(TEXT.primary)
    self.nameFS:SetText(member.name or "Unknown")
    self.nameFS:SetTextColor(nr, ng, nb, 1)

    local cr, cg, cb = RGBA(TEXT.secondary)
    self.subtitleFS:SetText(string.format("Lv.%d  %s", tonumber(member.level) or 0, string.upper(member.class or "UNKNOWN")))
    self.subtitleFS:SetTextColor(cr, cg, cb, 1)

    local ar, ag, ab = RGBA(ACCENT.primary)
    self.rankFS:SetText(member.rank or "")
    self.rankFS:SetTextColor(ar, ag, ab, 1)

    if member.unit and self.model.SetUnit then
      pcall(self.model.SetUnit, self.model, member.unit)
    elseif member.displayId and self.model.SetDisplayInfo then
      pcall(self.model.SetDisplayInfo, self.model, member.displayId)
    elseif self.model.ClearModel then
      self.model:ClearModel()
    end
    self.model:SetFacing(0.1 * math.pi)

    if online then
      self.liveFS:Show()
    else
      self.liveFS:Hide()
    end
    self.liveFS:SetTextColor(ar, ag, ab, 1)

    self.specFS:SetText("Spec: " .. (member.spec or "Unknown"))
    self.specFS:SetTextColor(ar, ag, ab, 1)

    local hr, hg, hb = RGBA(TEXT.secondary)
    self.achLabel:SetTextColor(hr, hg, hb, 1)
    local gr, gg, gb = RGBA(ACCENT.gold)
    self.achPoints:SetText(string.format("%d Points", tonumber(member.achievementPoints) or 0))
    self.achPoints:SetTextColor(gr, gg, gb, 1)

    self:SetBadges(member.recentBadges)

    local line1 = (member.designations and member.designations[1]) or ""
    local line2 = (member.designations and member.designations[2]) or ""
    self.designLine1:SetText(line1)
    self.designLine2:SetText(line2)
    self.designLine1:SetTextColor(hr, hg, hb, 1)
    self.designLine2:SetTextColor(hr, hg, hb, 1)

    self.quoteMark:SetTextColor(ar, ag, ab, 1)
    self.wisdomFS:SetText(member.wisdom or "")
    self.wisdomFS:SetTextColor(hr, hg, hb, 1)
  end

  local tr, tg, tb = RGBA(TEXT.secondary)
  card.achLabel:SetTextColor(tr, tg, tb, 1)
  card.designLine1:SetTextColor(tr, tg, tb, 1)
  card.designLine2:SetTextColor(tr, tg, tb, 1)
  card.wisdomFS:SetTextColor(tr, tg, tb, 1)

  ResizeButtons()
  card:LoadMember({})
  return card
end
