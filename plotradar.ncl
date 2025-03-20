begin
;************************************************
; open file and read in data
;************************************************
  in = addfile("/mnt/d/Data/Skripsi/Radar/Case/20180712/201807120900.nc","r")
;   in = addfile("/mnt/g/Radar/201808/201808010720.nc","r")
;  in = addfile("/mnt/d/Data/Skripsi/Radar/201806090620.nc","r")

  t  = in->Band1
  lat=in->lat
  lon=in->lon
 
  minlat = -8.86
  maxlat = -5.86
  minlon = 111.26
  maxlon = 114.26

  minlonind = closest_val(minlon,lon)
  maxlonind = closest_val(maxlon,lon)
  minlatind = closest_val(minlat,lat)
  maxlatind = closest_val(maxlat,lat)
  
  minval = 0.
  maxval = 50.
  
  brtemp=t(minlatind(0):maxlatind(0),minlonind(0):maxlonind(0))
  brtemp = where(brtemp.lt.5.,brtemp@_FillValue,brtemp)
  
;************************************************
; create plot
;************************************************
  wks = gsn_open_wks("svg" ,"Radar0900")      ; send graphics to PNG file
  
  res                       = True
  res@gsnFrame              = True
  res@gsnDraw               = True
  res@gsnMaximize         = True           ; maximize plot in frame
  
  
  mnmxint = nice_mnmxintvl( minval, maxval, 18, False)
  cmap = read_colormap_file("MPL_jet")  ; read color data
  res@cnLevelSelectionMode = "ManualLevels"
  res@cnMinLevelValF       = minval              ; put it slightly above 0.0 so we get the blue color
  res@cnMaxLevelValF       = maxval
  res@cnLevelSpacingF      = mnmxint(2)/8.   ; Increase the number of levels 
                                             ; by choosing a smaller spacing.
  res@gsnAddCyclic         = False           ; don't add longitude cyclic point
  res@cnFillMode         = "RasterFill"   ; for faster draw
  res@cnRasterSmoothingOn = True


  res@cnFillOn             = True
  res@cnFillPalette        = cmap
  res@cnLinesOn            = False            ; turn off contour lines
  res@cnLineLabelsOn       = False            ; turn off contour labels
  res@cnFillOpacityF       = 1.               ; .85 
 
  res@tfDoNDCOverlay        = True

; Text bagian Atas
  res@gsnLeftString = "(l) Citra Radar 16:00 LT"
  res@gsnRightString = " "
  res@gsnLeftStringFontHeightF = 0.0225
  res@gsnLeftStringOrthogonalPosF = 0.0025

  ;---Better map outlines
  res@mpDataBaseVersion     = "MediumRes"
  res@mpDataSetName         = "Earth..4"
  res@mpOutlineBoundarySets = "AllBoundaries"
  res@mpGeophysicalLineThicknessF = 4
  res@mpOutlineOn = False

  res@mpFillOn             = True
  res@mpOceanFillColor     = "transparent"
  res@mpLandFillColor      = "transparent"
  
  res@mpMinLatF           = minlat
  res@mpMaxLatF           = maxlat
  res@mpMinLonF           = minlon
  res@mpMaxLonF           = maxlon
  

; Latitude tick mark
  res@tmYLLabelFontHeightF = 0.012 ;-- change major lat tickmark spacing
  res@tmYLMajorLengthF = 0.015 ;-- change the tickmark length
  res@tmYLMajorLineColor = "black" ;-- change major tickmarks color
  res@tmYLMinorLineColor = "black" ;-- change major tickmarks color
  res@tmYLLabelFontColor = "black" ;-- change label color
  
; Tickmarck
  res@pmTickMarkDisplayMode = "Always"
  res@tmBorderThicknessF	= 5.0
  res@tmXBMajorThicknessF = 5.0
  res@tmYLMajorThicknessF = 5.0
  res@tmYLLabelFontThicknessF = 5.0
  res@tmXBLabelFontThicknessF = 5.0
  res@tmXBLabelFontHeightF = 0.025
  
; Legend laber bar
  res@lbOrientation = "Vertical"
  res@lbJustification = "Right"
  res@lbTitleOn        = True                ; turn on title
  res@lbTitleString    = "[dBZ]"                ; title string
  res@lbTitlePosition  = "Top"              ; title position
  res@lbTitleFontHeightF= .0175                ; make title smaller
  res@lbBoxLineThicknessF = 2.0
  res@lbTitleFontThicknessF = 6.0
  res@lbTitleExtentF = 0.02
  res@lbTitleJust = "TopCenterBottom"
  res@lbLabelStride = 20
  res@lbBoxLinesOn = True
  res@lbBoxSeparatorLinesOn = False
  res@lbBoxLineThicknessF = 5.0
  res@lbLabelFontThicknessF = 6.0
  res@lbLabelFontHeightF = 0.0175
  res@lbBoxMinorExtentF = 0.25 ;Ngatur lebar nya
  
  plot = gsn_csm_contour_map(wks,brtemp,res)
  
  ;---Section to add polylines to map.
  
  lnres             = True           ; resource list for 
  
  lnres@gsLineColor = "black"
  lnres@gsLineThicknessF = 5.0

  id2 = gsn_add_shapefile_polylines(wks,plot,"/mnt/d/Data/SHP/data1/IDN_adm1.shp",lnres)
  

  draw(plot)   ; This will draw attached polylines and map
  frame(wks)   ; Advanced frame.NhlTColorIndexGenArray  
end
