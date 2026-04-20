LeafVE_RosterUI = LeafVE_RosterUI or {}

local THEME = LeafVE_Theme or {}
local BG = THEME.BG or {}
local TEXT = THEME.TEXT or {}
local BORDER = THEME.BORDER or {}
local ACCENT = THEME.ACCENT or {}
local STATUS = THEME.STATUS or {}
local LAYOUT = THEME.LAYOUT or {}

local WHITE = "Interface\\Buttons\\WHITE8x8"
local ROW_HEIGHT = LAYOUT.row_h or 28

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

local function ApplyRowVisual(root, row, member, index)
  local selected = root.selectedName and member and member.name and root.selectedName == member.name
  local isEven = index % 2 == 0
  local base = isEven and BG.panel or BG.base

  local r, g, b = RGBA(base)
  if selected then
    r, g, b = RGBA(BG.selected)
  elseif row._hover then
    r, g, b = RGBA(BG.hover)
  end

  row:SetBackdropColor(r, g, b, 1)
  local br, bg, bb = RGBA(BORDER.subtle)
  row:SetBackdropBorderColor(br, bg, bb, 0)

  local ar, ag, ab = RGBA(ACCENT.primary)
  row.leftBar:SetVertexColor(ar, ag, ab, selected and 1 or 0)

  local sr, sg, sb = RGBA(BORDER.subtle)
  row.separator:SetVertexColor(sr, sg, sb, 0.55)

  if member and member.online then
    local orr, org, orb = RGBA(STATUS.success or ACCENT.primary)
    row.statusDot:SetVertexColor(orr, org, orb, 1)
  else
    local mtr, mtg, mtb = RGBA(TEXT.muted)
    row.statusDot:SetVertexColor(mtr, mtg, mtb, 0.9)
  end

  local nr, ng, nb = RGBA(TEXT.primary)
  row.nameFS:SetTextColor(nr, ng, nb, 1)
  local mr, mg, mb = RGBA(TEXT.muted)
  row.metaFS:SetTextColor(mr, mg, mb, 1)
end

local function BuildVisibleRows(root)
  if not root or not root.scrollFrame then return end
  local viewportHeight = root.scrollFrame:GetHeight() or (ROW_HEIGHT * 8)
  local visibleCount = math.max(1, math.floor(viewportHeight / ROW_HEIGHT) + 1)

  root.rowPool = root.rowPool or {}
  for i = 1, visibleCount do
    if not root.rowPool[i] then
      local row = CreateFrame("Button", nil, root.content)
      row:SetHeight(ROW_HEIGHT)
      row:SetPoint("LEFT", root.content, "LEFT", 0, 0)
      row:SetPoint("RIGHT", root.content, "RIGHT", -2, 0)
      EnsureBackdrop(row, 1)

      row.leftBar = row:CreateTexture(nil, "ARTWORK")
      row.leftBar:SetTexture(WHITE)
      row.leftBar:SetPoint("TOPLEFT", row, "TOPLEFT", 0, 0)
      row.leftBar:SetPoint("BOTTOMLEFT", row, "BOTTOMLEFT", 0, 0)
      row.leftBar:SetWidth(3)

      row.statusDot = row:CreateTexture(nil, "OVERLAY")
      row.statusDot:SetTexture(WHITE)
      row.statusDot:SetPoint("LEFT", row, "LEFT", 10, 0)
      row.statusDot:SetSize(6, 6)

      row.nameFS = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      row.nameFS:SetPoint("LEFT", row.statusDot, "RIGHT", 8, 0)
      row.nameFS:SetJustifyH("LEFT")
      row.nameFS:SetFont("Fonts\\ARIALN.TTF", 11, "")

      row.metaFS = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      row.metaFS:SetPoint("RIGHT", row, "RIGHT", -8, 0)
      row.metaFS:SetJustifyH("RIGHT")
      row.metaFS:SetFont("Fonts\\ARIALN.TTF", 10, "")

      row.separator = row:CreateTexture(nil, "BORDER")
      row.separator:SetTexture(WHITE)
      row.separator:SetPoint("BOTTOMLEFT", row, "BOTTOMLEFT", 0, 0)
      row.separator:SetPoint("BOTTOMRIGHT", row, "BOTTOMRIGHT", 0, 0)
      row.separator:SetHeight(1)

      row:SetScript("OnEnter", function(btn)
        btn._hover = true
        if btn.member and btn.member.name then
          ApplyRowVisual(root, btn, btn.member, btn._memberIndex or 1)
        end
      end)
      row:SetScript("OnLeave", function(btn)
        btn._hover = false
        if btn.member and btn.member.name then
          ApplyRowVisual(root, btn, btn.member, btn._memberIndex or 1)
        end
      end)
      row:SetScript("OnClick", function(btn)
        if not btn.member then return end
        root:SelectMember(btn.member.name)
      end)

      root.rowPool[i] = row
    end
  end

  root.visibleCount = visibleCount
end

local function RefreshScroll(root)
  local count = #(root.filteredMembers or {})
  local viewportHeight = root.scrollFrame:GetHeight() or (ROW_HEIGHT * 8)
  local totalHeight = count * ROW_HEIGHT

  root.content:SetHeight(math.max(totalHeight, viewportHeight))
  root.content:SetWidth(root.scrollFrame:GetWidth() or root:GetWidth())

  local maxScroll = math.max(0, totalHeight - viewportHeight)
  root.scrollbar:SetMinMaxValues(0, maxScroll)
  root.scrollbar:SetValueStep(ROW_HEIGHT)
  if root.scrollbar:GetValue() > maxScroll then
    root.scrollbar:SetValue(maxScroll)
  end

  local offset = root.scrollbar:GetValue()
  root.scrollFrame:SetVerticalScroll(offset)

  local firstIndex = math.floor(offset / ROW_HEIGHT) + 1
  for i = 1, (root.visibleCount or 0) do
    local memberIndex = firstIndex + i - 1
    local row = root.rowPool and root.rowPool[i]
    local member = root.filteredMembers and root.filteredMembers[memberIndex]

    if row then
      if member then
        row:Show()
        row.member = member
        row._memberIndex = memberIndex
        row:SetPoint("TOPLEFT", root.content, "TOPLEFT", 0, -((memberIndex - 1) * ROW_HEIGHT))
        row:SetPoint("TOPRIGHT", root.content, "TOPRIGHT", -2, -((memberIndex - 1) * ROW_HEIGHT))

        row.nameFS:SetText(member.name or "Unknown")
        local level = tonumber(member.level) or 0
        local rank = member.rank or "Member"
        row.metaFS:SetText(string.format("Lv.%d  %s", level, rank))
        ApplyRowVisual(root, row, member, memberIndex)
      else
        row:Hide()
        row.member = nil
      end
    end
  end
end

function LeafVE_RosterUI:Create(parent)
  local root = CreateFrame("Frame", nil, parent)
  root.members = {}
  root.filteredMembers = {}
  root.selectedName = nil

  EnsureBackdrop(root, 1)
  local br, bg, bb = RGBA(BG.base)
  root:SetBackdropColor(br, bg, bb, 1)
  local er, eg, eb = RGBA(BORDER.subtle)
  root:SetBackdropBorderColor(er, eg, eb, 1)

  root.scrollFrame = CreateFrame("ScrollFrame", nil, root)
  root.scrollFrame:SetPoint("TOPLEFT", root, "TOPLEFT", 4, -4)
  root.scrollFrame:SetPoint("BOTTOMRIGHT", root, "BOTTOMRIGHT", -22, 4)
  root.scrollFrame:EnableMouseWheel(true)

  root.content = CreateFrame("Frame", nil, root.scrollFrame)
  root.content:SetPoint("TOPLEFT", root.scrollFrame, "TOPLEFT", 0, 0)
  root.content:SetPoint("TOPRIGHT", root.scrollFrame, "TOPRIGHT", 0, 0)
  root.content:SetHeight(1)
  root.scrollFrame:SetScrollChild(root.content)

  root.scrollbar = CreateFrame("Slider", nil, root, "UIPanelScrollBarTemplate")
  root.scrollbar:SetPoint("TOPRIGHT", root, "TOPRIGHT", -4, -16)
  root.scrollbar:SetPoint("BOTTOMRIGHT", root, "BOTTOMRIGHT", -4, 16)
  root.scrollbar:SetMinMaxValues(0, 0)
  root.scrollbar:SetValue(0)

  root.scrollbar:SetScript("OnValueChanged", function(_, value)
    root.scrollFrame:SetVerticalScroll(value or 0)
    RefreshScroll(root)
  end)

  local function HandleWheel(_, delta)
    local minVal, maxVal = root.scrollbar:GetMinMaxValues()
    local current = root.scrollbar:GetValue() or 0
    local nextVal = current - (delta * ROW_HEIGHT)
    if nextVal < minVal then nextVal = minVal end
    if nextVal > maxVal then nextVal = maxVal end
    root.scrollbar:SetValue(nextVal)
  end

  root.scrollFrame:SetScript("OnMouseWheel", HandleWheel)
  root:SetScript("OnMouseWheel", HandleWheel)
  root:EnableMouseWheel(true)

  root:SetScript("OnSizeChanged", function()
    BuildVisibleRows(root)
    RefreshScroll(root)
  end)

  function root:SetMembers(arr)
    self.members = arr or {}
    self:Filter(self._filterQuery)
  end

  function root:Filter(query)
    self._filterQuery = query
    local q = string.lower(query or "")
    self.filteredMembers = {}

    for _, member in ipairs(self.members or {}) do
      local name = string.lower(member.name or "")
      if q == "" or string.find(name, q, 1, true) then
        table.insert(self.filteredMembers, member)
      end
    end

    BuildVisibleRows(self)
    RefreshScroll(self)
  end

  function root:SelectMember(name)
    self.selectedName = name
    RefreshScroll(self)
    if self.onSelect then
      for _, member in ipairs(self.filteredMembers or {}) do
        if member.name == name then
          self.onSelect(member)
          break
        end
      end
    end
  end

  BuildVisibleRows(root)
  RefreshScroll(root)

  return root
end
