;----------------------------------------------------------------------
; dataonmap_1.ncl
;
; Concepts illustrated:
;   - Plotting contours on a rectilinear grid
;----------------------------------------------------------------------
; These files are loaded by default in NCL V6.2.0 and newer
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
;----------------------------------------------------------------------

begin
  minlat = -6.6
  maxlat = -5.8
  minlon = 106.4
  maxlon = 107.2
  
  filename = "D:/Data/NWP/AnginSkema1_cutted.nc"
  a = addfile(filename,"r")    ; open file
  u = a->ws10(94,0,:,:)          ; read data (64 x 128)
  u = u*2

;---Plot data
  wks = gsn_open_wks("X11","dataonmap")
  
; ColorMap
  cmapangin = (/"(/0.65, 0.14, 0.14/)", "(/0.82, 0.36, 0.36/)", \
           "(/0.93, 0.12, 0.15/)", "(/0.94, 0.28, 0.13/)", \
           "(/0.96, 0.56, 0.12/)", "(/0.99, 0.65, 0.12/)", \
           "(/0.75, 0.75, 0.20/)", "(/0.05, 0.51, 0.25/)", \
           "(/0.05, 0.51, 0.51/)", "(/0.52, 0.82, 0.93/)", \
           "(/0.70, 0.88, 0.91/)", "(/1.00, 1.00, 1.00/)"/)
		   
  cmapangin         = cmapangin(::-1)
		   
  gsn_define_colormap(wks,cmapangin)

  res              	      = True
  res@gsnDraw             = False          ; don't draw plot yet

  res@gsnFrame            = False          ; don't advance frame yet
  res@gsnMaximize         = True           ; maximize plot in frame
  res@mpDataBaseVersion   = "MediumRes"    ; slightly better resolution
  res@mpFillOn 			  = False		   ; Agar warna pulau ga ada warnanya
  res@mpOutlineOn 		  = False		   ; Agar warna pulau ga ada bordernya
  
  
  res@cnFillOn     = True     ; turn on contour fill
  res@cnLinesOn    = False    ; turn off contour line
  
  res@mpMinLatF           = minlat
  res@mpMaxLatF           = maxlat
  res@mpMinLonF           = minlon
  res@mpMaxLonF           = maxlon
  res@gsnAddCyclic        = False
  
  ; Tickmarck
  res@pmTickMarkDisplayMode = "Always"
  res@tmBorderLineColor = "black"
  res@tmBorderThicknessF	= 3.0
  res@tmXBMajorThicknessF = 3.0
  res@tmYLMajorThicknessF = 3.0
  res@tmYLLabelFontThicknessF = 3.0
  res@tmXBLabelFontThicknessF = 3.0
  
; latitude tick mark
  res@tmYLLabelFontHeightF = 0.015 ;-- change major lat tickmark spacing
  res@tmYLMajorLengthF = 0.015 ;-- change the tickmark length
  res@tmYLMinorLengthF = 0.01 ;-- change the tickmark length
  res@tmYLMajorLineColor = "black" ;-- change major tickmarks color
  res@tmYLMinorLineColor = "black" ;-- change major tickmarks color
  res@tmYLLabelFontColor = "black" ;-- change label color
  
; longitude tick mark
  res@tmXBLabelFontHeightF = 0.015 ;-- change major lat tickmark spacing
  res@tmXBMajorLengthF = 0.015 ;-- change the tickmark length
  res@tmXBMinorLengthF = 0.01 ;-- change the tickmark length
  res@tmXBMajorLineColor = "black" ;-- change major tickmarks color
  res@tmXBMinorLineColor = "black" ;-- change major tickmarks color
  res@tmXBLabelFontColor = "black" ;-- change label color
  
 
; Contour setting
  res@cnFillOn 	= True ;-- turn on contour fill
  res@cnFillPalette = cmapangin ;-- choose color map
  res@cnLinesOn = False ;-- turn off contour lines
  res@cnLineLabelsOn = False ;-- turn off line labels
  res@cnLevelSelectionMode = "ManualLevels" ;-- set contour levels manually
  res@cnMinLevelValF = 10. ;-- minimum contour level
  res@cnMaxLevelValF = 20. ;-- maximum contour level
  res@cnLevelSpacingF = 1.0 ;-- contour level spacing
  res@lbBoxMinorExtentF = 0.15 ;-- decrease the height of the labelbar
  res@lbOrientation = "Vertical"
  res@lbJustification = "Right"
  
; Legend laber bar
  res@lbTitleOn        = True                ; turn on title
  res@lbTitleString    = "knot"                ; title string
  res@lbTitlePosition  = "Top"              ; title position
  res@lbTitleFontHeightF= .015                ; make title smaller
  res@lbBoxLineThicknessF = 2.0
  res@lbTitleFontThicknessF = 2.0
  res@lbTitleFontColor = "black"
  res@lbBoxLineColor = "black"
  res@lbTitleExtentF = 0.02
  res@lbLabelFontColor = "black"


  plot = gsn_csm_contour_map(wks,u,res)
  
;---Section to add polylines to map.
  
  lnres             		= True           ; resource list for polylines
  lnres@gsLineColor 		= "black"
  lnres@gsLineThicknessF 	= 1.5
  
  id = gsn_add_shapefile_polylines(wks,plot,"/home/asus/NCL/Data/Shp/Indo_Districts.shp",lnres)

  lnres@gsLineColor = "black"
  lnres@gsLineThicknessF = 4.0
  
  id2 = gsn_add_shapefile_polylines(wks,plot,"/home/asus/NCL/Data/Shp/Indo_provinces.shp",lnres)
  
  draw(plot)   ; This will draw attached polylines and map
  frame(wks)   ; Advanced frame.NhlTColorIndexGenArray

end