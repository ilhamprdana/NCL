; Running plotgrids_new dulu buat tau lon lat
; You then can use NCL V5.1.1 to plot the shapefile data.
;----------------------------------------------------------------------
; This script shows the "new" way (post NCL V6.0.0) of adding shapefile
; outlines to an existing NCL map. It uses gsn_add_shapefile_polylines.
;----------------------------------------------------------------------
; These files are loaded by default in NCL V6.2.0 and newer
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW3.ncl"

begin
  wks  = gsn_open_wks("png","Domain")  ; send graphics to PNG file
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; DOMAIN 1
  minlat = -20.53037
  minlon = 99.15598
  maxlat = 6.211499
  maxlon = 126.364

; DOMAIN 2
  d2lonstart 	= 108.905
  d2lonend 		= 116.161
  d2latstart	= -11.16349
  d2latend		= -3.976125
  
; DOMAIN 3
  d3lonstart 	= 111.6717
  d3lonend 		= 113.5762
  d3latstart	= -8.437981
  d3latend		= -6.549774

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
  
;-- read the data and define
  topo_file = "D:/Data/ETOPO1_Bed_c_gmt4.grd.nc"
  f         = addfile(topo_file,"r")
  var = f->z({minlat:maxlat},{minlon:maxlon})

  res                     = True

; For faster code, don't set res@gsnDraw = False, and see below.
  res@gsnDraw             = False          ; don't draw plot yet

  res@gsnFrame            = False          ; don't advance frame yet
  res@gsnMaximize         = True           ; maximize plot in frame
  res@mpDataBaseVersion   = "MediumRes"    ; slightly better resolution
  res@mpFillOn 			  = False		   ; Agar warna pulau ga ada warnanya
  res@mpOutlineOn 		  = False		   ; Agar warna pulau ga ada bordernya

; Tickmarck
  res@pmTickMarkDisplayMode = "Always"
  res@tmBorderThicknessF	= 3.0
  res@tmXBMajorThicknessF = 3.0
  res@tmYLMajorThicknessF = 3.0
  res@tmYLLabelFontThicknessF = 3.0
  res@tmXBLabelFontThicknessF = 3.0



; latitude tick mark
  res@tmYLLabelFontHeightF = 0.012 ;-- change major lat tickmark spacing
  res@tmYLMajorLengthF = 0.015 ;-- change the tickmark length
  res@tmYLMinorLengthF = 0.01 ;-- change the tickmark length
  res@tmYLMajorLineColor = "black" ;-- change major tickmarks color
  res@tmYLMinorLineColor = "black" ;-- change major tickmarks color
  res@tmYLLabelFontColor = "black" ;-- change label color
  
 
; Contour setting
  res@cnFillOn 	= True ;-- turn on contour fill
  res@cnFillPalette = "MPL_Greys" ;-- choose color map
  res@cnLinesOn = False ;-- turn off contour lines
  res@cnLineLabelsOn = False ;-- turn off line labels
  res@cnLevelSelectionMode = "ManualLevels" ;-- set contour levels manually
  res@cnMinLevelValF = 100. ;-- minimum contour level
  res@cnMaxLevelValF = 1900. ;-- maximum contour level
  res@cnLevelSpacingF = 100. ;-- contour level spacing
  res@lbBoxMinorExtentF = 0.15 ;-- decrease the height of the labelbar


; Zoom in on Indonesia.
  res@mpMinLatF           = minlat
  res@mpMaxLatF           = maxlat
  res@mpMinLonF           = minlon
  res@mpMaxLonF           = maxlon
  res@gsnAddCyclic        = False

;  res@tiMainString        = "Indonesia"	; buat ngasih judul
;  res@tiMainFontHeightF   = 0.015   ; Make font slightly smaller.

; Legend laber bar
  res@lbTitleOn        = True                ; turn on title
  res@lbTitleString    = "m"                ; title string
  res@lbTitlePosition  = "Right"              ; title position
  res@lbTitleFontHeightF= .015                ; make title smaller
  res@lbBoxLineThicknessF = 2.0
  res@lbTitleFontThicknessF = 2.0
  res@lbTitleExtentF = 0.02
; res@lbTitleOffsetF = 0.05
; res@lbTitleJust = "TopCenterBottom"

  plot = gsn_csm_contour_map(wks, var, res)

;---Section to add polylines to map.
  
  lnres             		= True           ; resource list for polylines
  lnres@gsLineColor = "black"
  lnres@gsLineThicknessF = 3.0
  
  id = gsn_add_shapefile_polylines(wks,plot,"/home/asus/NCL/Data/Shp/Indo_provinces.shp",lnres)
  
  lnres@gsLineColor = "black"
  lnres@gsLineThicknessF = 3.0
  
  id2 = gsn_add_shapefile_polylines(wks,plot,"/home/asus/NCL/Data/Shp/Other_Countries.shp",lnres)

  txres = True
  txres@txFont = "helvetica-bold"
  ;txres@txJust = "BottomLeft"
  txres@txJust = "TopLeft"
  txres@txPerimOn = False
  txres@txFontHeightF = 0.015
  txres@txFontColor = "black"
  
;************************************************
; create points for box DOMAIN 2
;************************************************

  y1 = d2latstart
  y2 = d2latend
  x1 = d2lonstart
  x2 = d2lonend

 ypts = (/ y2, y1, y1, y2, y2/)
 xpts = (/ x1, x1, x2, x2, x1/)

;************************************************
; add the box
;************************************************
  resp                  = True                      ; polyline mods desired
  resp@gsLineColor      = "black"                     ; color of lines
  resp@gsLineThicknessF = 5.0                       ; thickness of lines
; resp@gsLineLabelString= "d02"                    ; adds a line label string

; create array of dummy graphic variables. This is required, b/c each line
; must be associated with a unique dummy variable.

  dum = new(4,graphic)  

; draw each line separately. Each line must contain two points.
  do i = 0,3
    dum(i)=gsn_add_polyline(wks,plot,xpts(i:i+1),ypts(i:i+1),resp)      
  end do 
  
  tambahtext1 = gsn_add_text(wks,plot,"d02",d2lonstart+0.3,d2latend-0.3,txres)
  
;************************************************
; create points for box DOMAIN 3
;************************************************

  y1 = d3latstart
  y2 = d3latend
  x1 = d3lonstart
  x2 = d3lonend

 ypts = (/ y2, y1, y1, y2, y2/)
 xpts = (/ x1, x1, x2, x2, x1/)

;************************************************
; add the box
;************************************************
  resp                  = True                      ; polyline mods desired
  resp@gsLineColor      = "black"                     ; color of lines
  resp@gsLineThicknessF = 5.0                       ; thickness of lines
; resp@gsLineLabelString= "test"                    ; adds a line label string

; create array of dummy graphic variables. This is required, b/c each line
; must be associated with a unique dummy variable.

  dum2 = new(4,graphic)  

; draw each line separately. Each line must contain two points.
  do i = 0,3
    dum2(i)=gsn_add_polyline(wks,plot,xpts(i:i+1),ypts(i:i+1),resp)      
  end do 
  tambahtext2 = gsn_add_text(wks,plot,"d03",d3lonstart+0.2,d3latend-0.2,txres)
  tambahtext3 = gsn_add_text(wks,plot,"d01",minlon+0.4,maxlat-0.4,txres)

  
  draw(plot)   ; This will draw attached polylines and map
  frame(wks)   ; Advanced frame.NhlTColorIndexGenArray

end
