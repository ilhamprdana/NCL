;***************************************************
; 				Script Streamline 
;***************************************************
begin
  ncout = addfile("/mnt/d/Data/Maritim/Ambon/AnginUV17Ambon.nc","r")
  ugrid =  ncout->u10(13,:,:) 
  vgrid =  ncout->v10(13,:,:)

  ugrid2 = ugrid*0.001
  vgrid2 = vgrid*0.001  

  
  wks = gsn_open_wks("X11","stream")       ; send graphics to PNG file
  mpres                       = True
  mpres@gsnMaximize           = True     ; Make plot fit the frame
  mpres@gsnDraw               = False      ; will panel plots later
  mpres@gsnFrame              = False

;---Zoom in on map
  mpres@mpMaxLatF             =  5
  mpres@mpMinLatF             = -15
  mpres@mpMaxLonF             = 140
  mpres@mpMinLonF             = 120

  mpres@mpFillOn              = True
  mpres@mpOutlineOn           = True
  mpres@mpDataBaseVersion   	= "MediumRes"
  mpres@mpLandFillColor 		= (/"(/0.5, 0.5, 0.5/)"/)
  mpres@mpGeophysicalLineThicknessF = 2.5
  mpres@gsnLeftString ="Streamline dan kecepatan angin (m/s)"
  mpres@gsnRightString ="25 Juli 2018 12:00 UTC"


;---Data is regional
  mpres@gsnAddCyclic          = False

;---Change the streamline levels
  mpres@stLevelPalette        = "WhiteBlueGreenYellowRed"
  mpres@stLevelSelectionMode  = "ManualLevels"
  mpres@stMinLevelValF        = 1
  mpres@stMaxLevelValF        = 10.
  mpres@stLevelSpacingF       = 1.
  
  mpres@stMinDistanceF	= 0.04 ;jarak antar strm
  mpres@stLineThicknessF = 3.0
  mpres@stMinLineSpacingF = 0.0045 ;bikin pendek
  mpres@stArrowLengthF = 0.005
  mpres@stArrowStride = 5
  mpres@lbOrientation = "Vertical"
  
; Legend laber bar
  mpres@lbTitleFontHeightF= .015                ; make title smaller
  mpres@lbBoxLineThicknessF = 3.0
  mpres@lbTitleFontThicknessF = 3.0
  mpres@lbTitleFontColor = "black"
  mpres@lbBoxLineColor = "black"
  mpres@lbTitleExtentF = 0.02
  mpres@lbLabelFontColor = "black"
  mpres@lbJustification = "CenterLeft"

; Tickmarck
;  res@pmTickMarkDisplayMode = "Always"
  mpres@tmBorderLineColor = "black"
  mpres@tmBorderThicknessF	= 3.0
  mpres@tmXBMajorThicknessF = 3.0
  mpres@tmYLMajorThicknessF = 3.0
  mpres@tmYLLabelFontThicknessF = 3.0
  mpres@tmXBLabelFontThicknessF = 3.0
  
  mpres@stMonoLineColor       = False

  mpres@pmTickMarkDisplayMode = "Always"    ; more detailed tickmarks

  plots= gsn_csm_streamline_map(wks, ugrid2, vgrid2, mpres)
  
  draw(plots)
  frame(wks)

end