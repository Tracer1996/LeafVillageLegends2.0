LeafVE_Theme = LeafVE_Theme or {}

LeafVE_Theme.BG = {
  base     = {r=0.07, g=0.09, b=0.12},
  panel    = {r=0.12, g=0.15, b=0.20},
  elevated = {r=0.16, g=0.19, b=0.25},
  hover    = {r=0.20, g=0.24, b=0.31},
  selected = {r=0.14, g=0.28, b=0.22},
}
LeafVE_Theme.ACCENT = {
  primary = {r=0.24, g=0.72, b=0.54},
  dim     = {r=0.14, g=0.44, b=0.34},
}
LeafVE_Theme.TEXT = {
  primary   = {r=0.92, g=0.94, b=0.98},
  secondary = {r=0.62, g=0.68, b=0.76},
  muted     = {r=0.42, g=0.46, b=0.54},
  accent    = {r=0.24, g=0.72, b=0.54},
  white     = {r=1.00, g=1.00, b=1.00},
}
LeafVE_Theme.BORDER = {
  subtle    = {r=0.18, g=0.22, b=0.28},
  normal    = {r=0.28, g=0.34, b=0.42},
  accent    = {r=0.24, g=0.72, b=0.54},
  highlight = {r=0.32, g=0.38, b=0.48},
}
LeafVE_Theme.STATUS = {
  success  = {r=0.24, g=0.72, b=0.54},
  warning  = {r=0.90, g=0.62, b=0.00},
  error    = {r=0.86, g=0.20, b=0.20},
  info     = {r=0.24, g=0.52, b=0.97},
  disabled = {r=0.28, g=0.29, b=0.32},
}
LeafVE_Theme.LAYOUT = {
  pad=12, pad_sm=6, pad_lg=18, row_h=28, tab_h=28, btn_h=26, border=1,
}

function LeafVE_Theme:RGBA(c, a)
  if not c then return 1, 1, 1, a or 1 end
  return c.r or 1, c.g or 1, c.b or 1, c.a or a or 1
end

LeafVE_Theme.BG_COLORS = {
  darkest = LeafVE_Theme.BG.base,
  dark    = LeafVE_Theme.BG.panel,
  medium  = LeafVE_Theme.BG.elevated,
  light   = LeafVE_Theme.BG.hover,
  accent  = LeafVE_Theme.ACCENT.primary,
}
LeafVE_Theme.TEXT_COLORS = {
  bright_white = LeafVE_Theme.TEXT.white,
  bright       = LeafVE_Theme.TEXT.primary,
  off_white    = LeafVE_Theme.TEXT.primary,
  normal       = LeafVE_Theme.TEXT.secondary,
  muted_gray   = LeafVE_Theme.TEXT.muted,
  muted        = LeafVE_Theme.TEXT.muted,
  gold         = LeafVE_Theme.TEXT.secondary, -- compatibility redirect (no yellow decorative text)
}
LeafVE_Theme.STATUS_COLORS = LeafVE_Theme.STATUS
