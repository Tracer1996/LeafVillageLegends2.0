LeafVE_Styles = LeafVE_Styles or {}

local ColorDB = LeafVE_Colors or {}
local Theme = LeafVE_Theme or {}
local quality = ColorDB.QUALITY_COLORS or {}
local bg = Theme.BG or ColorDB.BG_COLORS or {}
local text = Theme.TEXT or ColorDB.TEXT_COLORS or {}
local border = Theme.BORDER or {}
local accent = Theme.ACCENT or {}
local classHex = ColorDB.CLASS_COLORS_HEX or {}
local fontDB = LeafVE_Fonts and LeafVE_Fonts.FONTS or {}

local function ToArray(c, alpha)
  if not c then return {1, 1, 1, alpha or 1} end
  return {c.r or 1, c.g or 1, c.b or 1, alpha or 1}
end

local function HexToArray(hex)
  if ColorDB.HexToRGB then
    local r, g, b = ColorDB:HexToRGB(hex)
    return {r, g, b}
  end
  return {1, 1, 1}
end

LeafVE_Styles.colors = {
  rare = ToArray(quality.rare, 1),
  uncommon = ToArray(quality.uncommon, 1),
  epic = ToArray(quality.epic, 1),

  bgBase = ToArray(bg.base or bg.darkest, 0.97),
  bgDark = ToArray(bg.base or bg.darkest, 0.96),
  bgPanel = ToArray(bg.panel or bg.dark, 0.88),
  accent = ToArray(accent.primary or text.accent, 1),
  gold = ToArray(accent.gold or text.gold, 1),
  muted = ToArray(text.muted or text.muted_gray, 1),

  border = ToArray(border.normal or bg.light, 1),
  soft = ToArray(bg.elevated or bg.medium, 1),
  white = ToArray(text.primary or text.bright, 1),
}

LeafVE_Styles.fonts = {
  title = (fontDB.header_large and fontDB.header_large.path) or "Fonts\\FRIZQT__.TTF",
  normal = (fontDB.body_normal and fontDB.body_normal.path) or "Fonts\\ARIALN.TTF",
  highlight = (fontDB.body_small and fontDB.body_small.path) or "Fonts\\ARIALN.TTF",
  defs = fontDB,
}

LeafVE_Styles.classColors = {
  WARRIOR = HexToArray(classHex.WARRIOR),
  PALADIN = HexToArray(classHex.PALADIN),
  HUNTER = HexToArray(classHex.HUNTER),
  ROGUE = HexToArray(classHex.ROGUE),
  PRIEST = HexToArray(classHex.PRIEST),
  SHAMAN = HexToArray(classHex.SHAMAN),
  MAGE = HexToArray(classHex.MAGE),
  WARLOCK = HexToArray(classHex.WARLOCK),
  DRUID = HexToArray(classHex.DRUID),
  DEATHKNIGHT = HexToArray(classHex.DEATHKNIGHT),
}

LeafVE_Styles.medals = { "🥇", "🥈", "🥉" }
LeafVE_Styles.medalFallbacks = { "[1st]", "[2nd]", "[3rd]" }
LeafVE_Styles.useUnicodeMedals = true

function LeafVE_Styles:GetMedalForRank(rank)
  if not rank or rank < 1 or rank > 3 then return nil end
  if self.useUnicodeMedals ~= false and self.medals and self.medals[rank] then
    return self.medals[rank]
  end
  return self.medalFallbacks and self.medalFallbacks[rank] or nil
end
