LeafVE_Theme = LeafVE_Theme or {}

LeafVE_Theme.BG = {
  base     = {r=0.059, g=0.067, b=0.082},
  panel    = {r=0.082, g=0.094, b=0.129},
  elevated = {r=0.102, g=0.118, b=0.161},
  hover    = {r=0.118, g=0.137, b=0.188},
  selected = {r=0.055, g=0.165, b=0.098},
}
LeafVE_Theme.ACCENT = {
  primary  = {r=0.180, g=0.800, b=0.443},
  dim      = {r=0.102, g=0.471, b=0.259},
  gold     = {r=0.788, g=0.635, b=0.153},
  gold_dim = {r=0.490, g=0.388, b=0.086},
}
LeafVE_Theme.TEXT = {
  primary   = {r=0.929, g=0.937, b=0.953},
  secondary = {r=0.604, g=0.620, b=0.651},
  muted     = {r=0.380, g=0.396, b=0.427},
  accent    = {r=0.180, g=0.800, b=0.443},
  gold      = {r=0.788, g=0.635, b=0.153},
  white     = {r=1.000, g=1.000, b=1.000},
}
LeafVE_Theme.BORDER = {
  subtle    = {r=0.137, g=0.153, b=0.200},
  normal    = {r=0.208, g=0.235, b=0.306},
  accent    = {r=0.180, g=0.800, b=0.443},
  gold      = {r=0.788, g=0.635, b=0.153},
  highlight = {r=0.259, g=0.298, b=0.388},
}
LeafVE_Theme.STATUS = {
  success  = {r=0.180, g=0.800, b=0.443},
  warning  = {r=0.902, g=0.624, b=0.000},
  error    = {r=0.859, g=0.196, b=0.196},
  info     = {r=0.235, g=0.522, b=0.973},
  disabled = {r=0.278, g=0.290, b=0.318},
}
LeafVE_Theme.LAYOUT = {
  pad=12, pad_sm=8, pad_lg=16, row_h=28, tab_h=26, border=1,
}
function LeafVE_Theme:RGBA(c, a)
  if not c then return 1,1,1,a or 1 end
  return c.r or 1, c.g or 1, c.b or 1, c.a or a or 1
end

LeafVE_Theme.BG_COLORS = {
  darkest = LeafVE_Theme.BG.base,
  dark = LeafVE_Theme.BG.panel,
  medium = LeafVE_Theme.BG.elevated,
  light = LeafVE_Theme.BG.hover,
  accent = LeafVE_Theme.ACCENT.gold,
}
LeafVE_Theme.TEXT_COLORS = {
  bright_white = LeafVE_Theme.TEXT.white,
  bright = LeafVE_Theme.TEXT.primary,
  off_white = LeafVE_Theme.TEXT.primary,
  normal = LeafVE_Theme.TEXT.secondary,
  muted_gray = LeafVE_Theme.TEXT.muted,
  muted = LeafVE_Theme.TEXT.muted,
  gold = LeafVE_Theme.ACCENT.gold,
}
LeafVE_Theme.STATUS_COLORS = LeafVE_Theme.STATUS
