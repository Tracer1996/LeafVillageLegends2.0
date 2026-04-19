LeafVE_Styles = LeafVE_Styles or {}

LeafVE_Styles.colors = {
  rare = { 0.00, 0.44, 0.87, 1.00 },       -- #0070DD
  uncommon = { 0.12, 1.00, 0.00, 1.00 },   -- #1EFF00
  epic = { 0.64, 0.21, 0.93, 1.00 },       -- #A335EE
  bgDark = { 0.04, 0.06, 0.15, 0.96 },     -- #0a0e27
  bgPanel = { 0.10, 0.12, 0.23, 0.88 },    -- #1a1f3a
  border = { 0.20, 0.24, 0.44, 1.00 },
  soft = { 0.14, 0.17, 0.32, 1.00 },
  white = { 0.96, 0.96, 0.96, 1.00 },
}

LeafVE_Styles.fonts = {
  title = "GameFontNormalLarge",
  normal = "GameFontNormal",
  highlight = "GameFontHighlightSmall",
}

LeafVE_Styles.classColors = {
  WARRIOR = {0.78, 0.61, 0.43}, PALADIN = {0.96, 0.55, 0.73}, HUNTER = {0.67, 0.83, 0.45},
  ROGUE = {1.00, 0.96, 0.41}, PRIEST = {1.00, 1.00, 1.00}, SHAMAN = {0.14, 0.35, 1.00},
  MAGE = {0.41, 0.80, 0.94}, WARLOCK = {0.58, 0.51, 0.79}, DRUID = {1.00, 0.49, 0.04},
  DEATHKNIGHT = {0.77, 0.12, 0.23},
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
