;----------------------------------------------------------------------
; WRF_pcp_2.ncl
;
; Concepts illustrated:
;   - Plotting WRF data
;   - Overlaying WRF precipitation on terrain map using gsn_csm functions
;   - Setting the correct WRF map projection using wrf_map_resources
;   - Creating two contour plots with two sets of filled contours
;   - Explicitly setting contour levels
;   - Drawing fully transparent filled contours
;   - Turning the tickmarks inward on the X and Y axes
;   - Moving the contour informational label into the plot
;   - Customizing the contour informational label
;----------------------------------------------------------------------

begin

;---Rain data
  wks = gsn_open_wks("png" ,"CH_RADARASS_10")
  f0 = addfile("/mnt/d/DATA/PCLN/SBYUAS/RADARASS/wrfout_d03_2018-11-24_12_00_00","r")
  Times = f0->Times 
  dims = dimsizes(Times)
  timeke = 132
  RAINC2 = f0->RAINC(timeke,:,:)
  RAINNC2 = f0->RAINNC(timeke,:,:)

  RAINC1 = f0->RAINC(timeke-6,:,:)
  RAINNC1 = f0->RAINNC(timeke-6,:,:)
  
  Rain = ((RAINC2-RAINC1)+(RAINNC2-RAINNC1))
  

  lon = fspan(111.1411,114.3789,120)
  lat = fspan(-8.962448,-5.75177,120)
  
  lon2 = fspan(111.1411,114.3789,1440)
  lat2 = fspan(-8.962448,-5.75177,1440)
  
  t1 = 235
  t2 = 1082
  
  Raininter = linint2_Wrap(lon,lat,Rain,False,lon2,lat2,0)
  
  Raininter2 = Raininter(t1:t2,t1:t2)
  
  ;---Set resources for rain total contour plot
  res_tot                       = True
  res_tot@gsnFrame              = True
  res_tot@gsnDraw               = True
  res_tot@gsnMaximize         = True           ; maximize plot in frame

  cmap     := read_colormap_file("BlAqGrYeOrReVi200")
  cmap(0,:) = (/0,0,0,0/)    ; make first color fully transparent

  res_tot@cnFillOn             = True
  res_tot@cnFillMode           = "RasterFill"
  res_tot@cnFillPalette        = cmap
  res_tot@cnLinesOn            = False            ; turn off contour lines
  res_tot@cnLineLabelsOn       = False            ; turn off contour labels
  res_tot@cnFillOpacityF       = 1.               ; .85 
 
  res_tot@tfDoNDCOverlay        = True

  res_tot@cnLevelSelectionMode = "ManualLevels"
  res_tot@cnMaxLevelValF       = 60  
  res_tot@cnMinLevelValF       =  5 
  res_tot@cnLevelSpacingF      =  5 
  
  res_tot@sfXArray = lon2
  res_tot@sfYArray = lat2
  
  ;---Better map outlines
  res_tot@mpDataBaseVersion     = "MediumRes"
  res_tot@mpDataSetName         = "Earth..4"
  res_tot@mpOutlineBoundarySets = "AllBoundaries"
  res_tot@mpGeophysicalLineThicknessF = 4
  res_tot@mpOutlineOn = False

  res_tot@mpFillOn             = True
  res_tot@mpOceanFillColor     = "transparent"
  res_tot@mpLandFillColor      = "transparent"
  
 
  minlat = lat2(t1)
  maxlat = lat2(t2)
  minlon = lon2(t1)
  maxlon = lon2(t2)
  
  res_tot@mpMinLatF           = minlat
  res_tot@mpMaxLatF           = maxlat
  res_tot@mpMinLonF           = minlon
  res_tot@mpMaxLonF           = maxlon
  
  res_tot@lbOrientation = "Vertical"
  res_tot@lbJustification = "Right"
  
  
; latitude tick mark
  res_tot@tmYLLabelFontHeightF = 0.012 ;-- change major lat tickmark spacing
  res_tot@tmYLMajorLengthF = 0.015 ;-- change the tickmark length
  res_tot@tmYLMajorLineColor = "black" ;-- change major tickmarks color
  res_tot@tmYLMinorLineColor = "black" ;-- change major tickmarks color
  res_tot@tmYLLabelFontColor = "black" ;-- change label color
  
  ; Tickmarck
  res_tot@pmTickMarkDisplayMode = "Always"
  res_tot@tmBorderThicknessF	= 5.0
  res_tot@tmXBMajorThicknessF = 5.0
  res_tot@tmYLMajorThicknessF = 5.0
  res_tot@tmYLLabelFontThicknessF = 5.0
  res_tot@tmXBLabelFontThicknessF = 5.0
  res_tot@tmXBLabelFontHeightF = 0.025

  res_tot@lbTitleOn        = True                ; turn on title
  res_tot@lbTitleString    = "mm"                ; title string
  res_tot@lbTitlePosition  = "Top"              ; title position
  res_tot@lbTitleFontHeightF= .0175                ; make title smaller
  res_tot@lbBoxLineThicknessF = 2.0
  res_tot@lbTitleFontThicknessF = 6.0
  res_tot@lbTitleExtentF = 0.02
; res_tot@lbTitleOffsetF = 0.05
  res_tot@lbTitleJust = "TopCenterBottom"
;  res_tot@lbLabelStride = 
  res_tot@lbBoxLinesOn = True
  res_tot@lbBoxSeparatorLinesOn = False
  res_tot@lbBoxLineThicknessF = 5.0
  res_tot@lbLabelFontThicknessF = 6.0
  res_tot@lbLabelFontHeightF = 0.0175
  
  plot = gsn_csm_contour_map(wks,Raininter2,res_tot)
  
  ;---Section to add polylines to map.
  
  lnres             = True           ; resource list for 
  
  lnres@gsLineColor = "grey40"
  lnres@gsLineThicknessF = 1.0
  
  id3 = gsn_add_shapefile_polylines(wks,plot,"/mnt/d/Data/Shp/data1/IDN_adm2.shp",lnres)
  
  lnres@gsLineColor = "black"
  lnres@gsLineThicknessF = 6.0

  id2 = gsn_add_shapefile_polylines(wks,plot,"/mnt/d/Data/Shp/data1/IDN_adm1.shp",lnres)
  


   radar                   = True
   radar@gsMarkerIndex     = 7         ; polymarker style
   radar@gsMarkerSizeF     = 15.          ; polymarker size
   radar@gsMarkerColor		= "black"
   radar@gsMarkerThicknessF = 4.0
   lonradar = (/112.7799/)
   latradar = (/-7.37259/)
   
   id6    = gsn_add_polymarker(wks,plot,lonradar,latradar,radar)


  draw(plot)   ; This will draw attached polylines and map
  frame(wks)   ; Advanced frame.NhlTColorIndexGenArray
end