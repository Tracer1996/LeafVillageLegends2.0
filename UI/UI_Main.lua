LeafVE = LeafVE or {}
LeafVE.UI = LeafVE.UI or {}

function LeafVE.UI:ApplyMainWindowSkin(frame, titleText)
  if not frame then return end
  if LeafVE_FrameSkins and LeafVE_FrameSkins.SkinWindow then
    LeafVE_FrameSkins:SkinWindow(frame, titleText)
  end
end

function LeafVE_ApplyMainWindowSkin(frame, titleText)
  if LeafVE and LeafVE.UI and LeafVE.UI.ApplyMainWindowSkin then
    return LeafVE.UI:ApplyMainWindowSkin(frame, titleText)
  end
end
