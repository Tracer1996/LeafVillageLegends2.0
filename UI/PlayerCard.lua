LeafVE_PlayerCard = LeafVE_PlayerCard or {}

local THEME = LeafVE_Theme or {}
local BG = THEME.BG or {}
local TEXT = THEME.TEXT or {}
local BORDER = THEME.BORDER or {}
local STATUS = THEME.STATUS or {}
local LAYOUT = THEME.LAYOUT or {}

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

local function ApplyFont(fs, style, fallbackPath, fallbackSize, fallbackColor)
  if not fs then return end
  if LeafVE_Fonts and LeafVE_Fonts.Apply then
    LeafVE_Fonts:Apply(fs, style, "")
    return
  end
  fs:SetFont(fallbackPath, fallbackSize, "")
  if fallbackColor and fs.SetTextColor then
    local r, g, b = RGBA(fallbackColor)
    fs:SetTextColor(r, g, b, 1)
  end
end

function LeafVE_PlayerCard:Create(parent)
  local card = CreateFrame("Frame", nil, parent)
  local sectionGap = 8
  local buttonGap = 8
  local buttonHeight = LAYOUT.btn_h or 26

  ApplyPane(card, BG.panel, BORDER.subtle, 1)

  card.modelWrap = CreateFrame("Frame", nil, card)
  card.modelWrap:SetPoint("TOPLEFT", card, "TOPLEFT", sectionGap, -sectionGap)
  card.modelWrap:SetPoint("TOPRIGHT", card, "TOPRIGHT", -sectionGap, -sectionGap)
  card.modelWrap:SetHeight(200)
  ApplyPane(card.modelWrap, BG.base, BORDER.normal, 1)

  card.model = CreateFrame("PlayerModel", nil, card.modelWrap)
  card.model:SetPoint("TOPLEFT", card.modelWrap, "TOPLEFT", 2, -2)
  card.model:SetPoint("BOTTOMRIGHT", card.modelWrap, "BOTTOMRIGHT", -2, 2)
  card.model:SetFacing(0.1 * math.pi)

  card.identityPane = CreateFrame("Frame", nil, card)
  card.identityPane:SetPoint("TOPLEFT", card.modelWrap, "BOTTOMLEFT", 0, -sectionGap)
  card.identityPane:SetPoint("TOPRIGHT", card.modelWrap, "BOTTOMRIGHT", 0, -sectionGap)
  card.identityPane:SetHeight(98)
  ApplyPane(card.identityPane, BG.elevated, BORDER.subtle, 1)

  card.statusDot = card.identityPane:CreateTexture(nil, "OVERLAY")
  card.statusDot:SetTexture(WHITE)
  card.statusDot:SetPoint("TOPLEFT", card.identityPane, "TOPLEFT", 10, -10)
  card.statusDot:SetSize(6, 6)

  card.liveFS = card.identityPane:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  card.liveFS:SetPoint("LEFT", card.statusDot, "RIGHT", 6, 0)
  ApplyFont(card.liveFS, "label_dim", "Fonts\\ARIALN.TTF", 10, TEXT.muted)

  card.nameFS = card.identityPane:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  card.nameFS:SetPoint("TOPLEFT", card.identityPane, "TOPLEFT", 10, -24)
  card.nameFS:SetPoint("TOPRIGHT", card.identityPane, "TOPRIGHT", -10, -24)
  card.nameFS:SetJustifyH("LEFT")
  ApplyFont(card.nameFS, "card_name", "Fonts\\FRIZQT__.TTF", 17, TEXT.primary)

  card.rankFS = card.identityPane:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  card.rankFS:SetPoint("TOPRIGHT", card.identityPane, "TOPRIGHT", -10, -24)
  card.rankFS:SetJustifyH("RIGHT")
  ApplyFont(card.rankFS, "card_accent", "Fonts\\ARIALN.TTF", 11, TEXT.accent)

  card.subtitleFS = card.identityPane:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  card.subtitleFS:SetPoint("TOPLEFT", card.nameFS, "BOTTOMLEFT", 0, -2)
  card.subtitleFS:SetPoint("TOPRIGHT", card.identityPane, "TOPRIGHT", -10, -2)
  card.subtitleFS:SetJustifyH("LEFT")
  ApplyFont(card.subtitleFS, "card_sub", "Fonts\\ARIALN.TTF", 11, TEXT.secondary)

  card.specFS = card.identityPane:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  card.specFS:SetPoint("TOPLEFT", card.subtitleFS, "BOTTOMLEFT", 0, -1)
  card.specFS:SetPoint("TOPRIGHT", card.identityPane, "TOPRIGHT", -10, -1)
  card.specFS:SetJustifyH("LEFT")
  ApplyFont(card.specFS, "body_dim", "Fonts\\ARIALN.TTF", 11, TEXT.muted)

  card.achLabel = card.identityPane:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  card.achLabel:SetPoint("BOTTOMLEFT", card.identityPane, "BOTTOMLEFT", 10, 8)
  card.achLabel:SetJustifyH("LEFT")
  ApplyFont(card.achLabel, "label_dim", "Fonts\\ARIALN.TTF", 10, TEXT.muted)
  card.achLabel:SetText("ACHIEVEMENTS")

  card.achPoints = card.identityPane:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  card.achPoints:SetPoint("LEFT", card.achLabel, "RIGHT", 6, 0)
  card.achPoints:SetJustifyH("LEFT")
  ApplyFont(card.achPoints, "card_sub", "Fonts\\ARIALN.TTF", 11, TEXT.secondary)

  card.badgePane = CreateFrame("Frame", nil, card)
  card.badgePane:SetPoint("TOPLEFT", card.identityPane, "BOTTOMLEFT", 0, -sectionGap)
  card.badgePane:SetPoint("TOPRIGHT", card.identityPane, "BOTTOMRIGHT", 0, -sectionGap)
  card.badgePane:SetHeight(94)
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
  card.designPane:SetPoint("TOPLEFT", card.badgePane, "BOTTOMLEFT", 0, -sectionGap)
  card.designPane:SetPoint("TOPRIGHT", card.badgePane, "BOTTOMRIGHT", 0, -sectionGap)
  card.designPane:SetHeight(42)
  ApplyPane(card.designPane, BG.elevated, BORDER.subtle, 1)

  card.designLabel = card.designPane:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  card.designLabel:SetPoint("TOPLEFT", card.designPane, "TOPLEFT", 8, -5)
  card.designLabel:SetPoint("TOPRIGHT", card.designPane, "TOPRIGHT", -8, -5)
  card.designLabel:SetJustifyH("LEFT")
  ApplyFont(card.designLabel, "label_dim", "Fonts\\ARIALN.TTF", 10, TEXT.muted)
  card.designLabel:SetText("Designations:")

  card.designLine1 = card.designPane:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  card.designLine1:SetPoint("TOPLEFT", card.designLabel, "BOTTOMLEFT", 0, -1)
  card.designLine1:SetPoint("TOPRIGHT", card.designLabel, "TOPRIGHT", 0, -1)
  card.designLine1:SetJustifyH("LEFT")
  ApplyFont(card.designLine1, "label", "Fonts\\ARIALN.TTF", 10, TEXT.secondary)

  card.designLine2 = card.designPane:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  card.designLine2:SetPoint("TOPLEFT", card.designLine1, "BOTTOMLEFT", 0, -4)
  card.designLine2:SetPoint("TOPRIGHT", card.designLine1, "TOPRIGHT", 0, -4)
  card.designLine2:SetJustifyH("LEFT")
  ApplyFont(card.designLine2, "label_dim", "Fonts\\ARIALN.TTF", 10, TEXT.muted)

  card.wisdomPane = CreateFrame("Frame", nil, card)
  card.wisdomPane:SetPoint("TOPLEFT", card.designPane, "BOTTOMLEFT", 0, -sectionGap)
  card.wisdomPane:SetPoint("TOPRIGHT", card.designPane, "BOTTOMRIGHT", 0, -sectionGap)
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
  ApplyFont(card.wisdomFS, "body_dim", "Fonts\\ARIALN.TTF", 10, TEXT.muted)

  card.buttonRow = CreateFrame("Frame", nil, card)
  card.buttonRow:SetPoint("TOPLEFT", card.wisdomPane, "BOTTOMLEFT", 0, -sectionGap)
  card.buttonRow:SetPoint("TOPRIGHT", card.wisdomPane, "BOTTOMRIGHT", 0, -sectionGap)
  card.buttonRow:SetHeight(buttonHeight)

  card.achButton = CreateFrame("Button", nil, card.buttonRow)
  card.achButton:SetPoint("LEFT", card.buttonRow, "LEFT", 0, 0)
  card.achButton:SetHeight(buttonHeight)
  card.achButton:SetText("ACHIEVEMENTS")

  card.gearButton = CreateFrame("Button", nil, card.buttonRow)
  card.gearButton:SetPoint("LEFT", card.achButton, "RIGHT", buttonGap, 0)
  card.gearButton:SetHeight(buttonHeight)
  card.gearButton:SetText("GEAR")

  card.badgesButton = CreateFrame("Button", nil, card.buttonRow)
  card.badgesButton:SetPoint("LEFT", card.gearButton, "RIGHT", buttonGap, 0)
  card.badgesButton:SetPoint("RIGHT", card.buttonRow, "RIGHT", 0, 0)
  card.badgesButton:SetHeight(buttonHeight)
  card.badgesButton:SetText("BADGES")

  local function ResizeButtons()
    local total = card.buttonRow:GetWidth() or 0
    local width = math.max(20, (total - (buttonGap * 2)) / 3)
    card.achButton:SetWidth(width)
    card.gearButton:SetWidth(width)
    card.badgesButton:SetWidth(width)
  end
  card.buttonRow:SetScript("OnSizeChanged", ResizeButtons)

  if LeafVE_FrameSkins and LeafVE_FrameSkins.SkinButton then
    LeafVE_FrameSkins:SkinButton(card.achButton, "secondary")
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
      else
        cell.icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
      end
      cell:Show()
    end
  end

  function card:LoadMember(m)
    self.member = m or {}
    local member = self.member

    local online = member.online and true or false
    local statusColor = online and STATUS.success or TEXT.muted
    local sr, sg, sb = RGBA(statusColor)
    self.statusDot:SetVertexColor(sr, sg, sb, 1)
    self.liveFS:SetText(online and "Live" or "Offline")
    self.liveFS:SetTextColor(sr, sg, sb, 1)

    local nr, ng, nb = RGBA(TEXT.primary)
    self.nameFS:SetText(member.name or "Unknown")
    self.nameFS:SetTextColor(nr, ng, nb, 1)

    local cr, cg, cb = RGBA(TEXT.secondary)
    local classText = string.upper(member.class or "UNKNOWN")
    local levelText = tonumber(member.level) or 0
    self.subtitleFS:SetText(string.format("%s | Level %d", classText, levelText))
    self.subtitleFS:SetTextColor(cr, cg, cb, 1)

    local mr, mg, mb = RGBA(TEXT.muted)
    self.specFS:SetText(member.spec or "Unknown")
    self.specFS:SetTextColor(mr, mg, mb, 1)

    local ar, ag, ab = RGBA(TEXT.accent)
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

    self.achLabel:SetTextColor(mr, mg, mb, 1)
    self.achPoints:SetText(string.format("%d Points", tonumber(member.achievementPoints) or 0))
    self.achPoints:SetTextColor(cr, cg, cb, 1)

    self:SetBadges(member.recentBadges)

    local line1 = (member.designations and member.designations[1]) or ""
    local line2 = (member.designations and member.designations[2]) or ""
    self.designLine1:SetText(line1)
    self.designLine2:SetText(line2)
    self.designLabel:SetTextColor(mr, mg, mb, 1)
    self.designLine1:SetTextColor(cr, cg, cb, 1)
    self.designLine2:SetTextColor(mr, mg, mb, 1)

    self.quoteMark:SetTextColor(mr, mg, mb, 1)
    self.wisdomFS:SetText(member.wisdom or "")
    self.wisdomFS:SetTextColor(mr, mg, mb, 1)
  end

  ResizeButtons()
  card:LoadMember({})
  return card
end
