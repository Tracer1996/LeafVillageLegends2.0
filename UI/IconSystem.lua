LeafVE_IconSystem = LeafVE_IconSystem or {}

local COLORS = LeafVE_Colors or {}
local QUALITY_COLORS = COLORS.QUALITY_COLORS or {}
local STATUS_COLORS = COLORS.STATUS_COLORS or {}
local CLASS_COLORS = COLORS.CLASS_COLORS_HEX or {}

local CLASS_COORDS = {
  WARRIOR = {0.00, 0.25, 0.00, 0.25},
  MAGE = {0.25, 0.50, 0.00, 0.25},
  ROGUE = {0.50, 0.75, 0.00, 0.25},
  DRUID = {0.75, 1.00, 0.00, 0.25},
  HUNTER = {0.00, 0.25, 0.25, 0.50},
  SHAMAN = {0.25, 0.50, 0.25, 0.50},
  PRIEST = {0.50, 0.75, 0.25, 0.50},
  WARLOCK = {0.75, 1.00, 0.25, 0.50},
  PALADIN = {0.00, 0.25, 0.50, 0.75},
  DEATHKNIGHT = {0.25, 0.50, 0.50, 0.75},
}

local PROFESSION_ICONS = {
  Alchemy = "Interface\\Icons\\Trade_Alchemy",
  Blacksmithing = "Interface\\Icons\\Trade_BlackSmithing",
  Cooking = "Interface\\Icons\\INV_Misc_Food_15",
  Enchanting = "Interface\\Icons\\Trade_Engraving",
  Engineering = "Interface\\Icons\\Trade_Engineering",
  FirstAid = "Interface\\Icons\\Spell_Holy_SealOfSacrifice",
  ["First Aid"] = "Interface\\Icons\\Spell_Holy_SealOfSacrifice",
  Jewelcrafting = "Interface\\Icons\\INV_Misc_Gem_01",
  Leatherworking = "Interface\\Icons\\INV_Misc_ArmorKit_17",
  Tailoring = "Interface\\Icons\\Trade_Tailoring",
  Mining = "Interface\\Icons\\Trade_Mining",
  Herbalism = "Interface\\Icons\\Trade_Herbalism",
  Skinning = "Interface\\Icons\\INV_Misc_Pelt_Wolf_01",
}

local function ColorFromHex(hex, fallback)
  if LeafVE_Colors and LeafVE_Colors.HexToRGB then
    local r, g, b = LeafVE_Colors:HexToRGB(hex)
    return r, g, b
  end
  local c = fallback or {r = 1, g = 1, b = 1}
  return c.r or 1, c.g or 1, c.b or 1
end

local function ApplyBorder(frame, color, thickness)
  if LeafVE_FrameSkins and LeafVE_FrameSkins.SkinBorder then
    return LeafVE_FrameSkins:SkinBorder(frame, color, thickness)
  end
  if SkinBorder then
    return SkinBorder(frame, color, thickness)
  end
  return nil
end

local function ApplyProgress(frame, color, maxValue)
  if LeafVE_FrameSkins and LeafVE_FrameSkins.SkinProgressBar then
    return LeafVE_FrameSkins:SkinProgressBar(frame, color, maxValue)
  end
  if SkinProgressBar then
    return SkinProgressBar(frame, color, maxValue)
  end
  return nil
end

local function BuildIconFrame(size)
  local f = CreateFrame("Frame", nil, UIParent)
  f:SetWidth(size or 18)
  f:SetHeight(size or 18)
  f.icon = f:CreateTexture(nil, "ARTWORK")
  f.icon:SetAllPoints(f)
  ApplyBorder(f, QUALITY_COLORS.common, 10)
  return f
end

function LeafVE_IconSystem:CreateQualityBorderedIcon(texture, quality, size)
  local frame = BuildIconFrame(size or 18)
  frame.icon:SetTexture(texture or "Interface\\Icons\\INV_Misc_QuestionMark")
  ApplyBorder(frame, QUALITY_COLORS[string.lower(quality or "common")] or QUALITY_COLORS.common, 10)
  return frame
end

function LeafVE_IconSystem:CreateClassIcon(class, size)
  local token = string.upper(class or "")
  local frame = BuildIconFrame(size or 18)
  frame.icon:SetTexture("Interface\\TargetingFrame\\UI-Classes-Circles")
  if CLASS_COORDS[token] then
    frame.icon:SetTexCoord(CLASS_COORDS[token][1], CLASS_COORDS[token][2], CLASS_COORDS[token][3], CLASS_COORDS[token][4])
  end
  local r, g, b = ColorFromHex(CLASS_COLORS[token], QUALITY_COLORS.rare)
  ApplyBorder(frame, {r = r, g = g, b = b}, 10)
  return frame
end

function LeafVE_IconSystem:CreateBadgeIcon(badgeId, size, progress)
  local iconTexture = (LEAF_BADGE_ICONS and LEAF_BADGE_ICONS[badgeId]) or LEAF_FALLBACK or "Interface\\Icons\\INV_Misc_QuestionMark"
  local frame = self:CreateQualityBorderedIcon(iconTexture, "rare", size or 22)
  if progress and type(progress) == "number" then
    frame.progress = CreateFrame("StatusBar", nil, frame)
    frame.progress:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", 0, -2)
    frame.progress:SetPoint("TOPRIGHT", frame, "BOTTOMRIGHT", 0, -2)
    frame.progress:SetHeight(4)
    ApplyProgress(frame.progress, STATUS_COLORS.info, 100)
    frame.progress:SetValue(math.max(0, math.min(100, progress)))
  end
  return frame
end

function LeafVE_IconSystem:CreateMedalIcon(rank)
  local medalMap = {
    [1] = "Interface\\Icons\\INV_Misc_Coin_16",
    [2] = "Interface\\Icons\\INV_Misc_Coin_17",
    [3] = "Interface\\Icons\\INV_Misc_Coin_18",
  }
  local quality = (rank == 1 and "artifact") or (rank == 2 and "common") or (rank == 3 and "legendary") or "common"
  return self:CreateQualityBorderedIcon(medalMap[rank] or medalMap[3], quality, 20)
end

function LeafVE_IconSystem:CreateProfessionIcon(profession, size)
  local icon = PROFESSION_ICONS[profession] or PROFESSION_ICONS[string.gsub(profession or "", "%s+", "")] or "Interface\\Icons\\INV_Misc_QuestionMark"
  return self:CreateQualityBorderedIcon(icon, "uncommon", size or 18)
end

function LeafVE_IconSystem:CreateStatusIcon(status, size)
  local frame = BuildIconFrame(size or 12)
  frame.icon:SetTexture("Interface\\Buttons\\WHITE8x8")
  local color = STATUS_COLORS[string.lower(tostring(status or ""))] or STATUS_COLORS.info
  frame.icon:SetVertexColor(color.r or 1, color.g or 1, color.b or 1, 1)
  ApplyBorder(frame, color, 10)
  return frame
end

function CreateQualityBorderedIcon(texture, quality, size) return LeafVE_IconSystem:CreateQualityBorderedIcon(texture, quality, size) end
function CreateClassIcon(class, size) return LeafVE_IconSystem:CreateClassIcon(class, size) end
function CreateBadgeIcon(badgeId, size, progress) return LeafVE_IconSystem:CreateBadgeIcon(badgeId, size, progress) end
function CreateMedalIcon(rank) return LeafVE_IconSystem:CreateMedalIcon(rank) end
function CreateProfessionIcon(profession, size) return LeafVE_IconSystem:CreateProfessionIcon(profession, size) end
function CreateStatusIcon(status, size) return LeafVE_IconSystem:CreateStatusIcon(status, size) end
