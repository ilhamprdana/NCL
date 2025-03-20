;----------------------------------------------------------------------
; shapefiles_3.ncl
;
; Concepts illustrated:
;   - Reading shapefiles
;   - Plotting data from shapefiles
;   - Drawing selected data based upon a database query of the shapefile
;   - Decreasing the font size of the main title
;   - Using shapefile data to draw the streams of South America
;   - Zooming in on South America on a cylindrical equidistant map
;   - Drawing a map using the medium resolution map outlines
;
;----------------------------------------------------------------------
;  Simple example of how to draw selected geometry from a shapefile.
;
; You must download the "HYDRO1k Streams data set for South America
; as a tar file in shapefile format (2.4 MB)" from:
;
; http://eros.usgs.gov/#/Find_Data/Products_and_Data_Available/gtopo30/hydro/samerica
;  
; Gunzip and untar the file:
;
;   gunzip sa_str.tar.gz
;   tar -xf sa_str.tar
;
; You then can use NCL V5.1.1 to plot the shapefile data.
;----------------------------------------------------------------------
; This script shows the "new" way (post NCL V6.0.0) of adding shapefile
; outlines to an existing NCL map. It uses gsn_add_shapefile_polylines.
;----------------------------------------------------------------------
; These files are loaded by default in NCL V6.2.0 and newer
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"

begin
  wks  = gsn_open_wks("x11","LatihanIndo")  ; send graphics to PNG file
  
  minlat = -10
  maxlat = 3
  minlon = 100
  maxlon = 113
;-- read the data and define
  topo_file = "D:/Data/etopoindo.nc"
  f         = addfile(topo_file,"r")
  var = f->h({minlat:maxlat},{minlon:maxlon})

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
  
  lnres@gsLineColor = "grey"
  lnres@gsLineThicknessF = 3.0
  
  id2 = gsn_add_shapefile_polylines(wks,plot,"/home/asus/NCL/Data/Shp/Other_Countries.shp",lnres)
  
;************************************************
; create points for box
;************************************************

  y1 = -7.5
  y2 = -5
  x1 = 105.5
  x2 = 108

 ypts = (/ y2, y1, y1, y2, y2/)
 xpts = (/ x1, x1, x2, x2, x1/)

;************************************************
; add the box
;************************************************
  resp                  = True                      ; polyline mods desired
  resp@gsLineColor      = "black"                     ; color of lines
  resp@gsLineThicknessF = 4.0                       ; thickness of lines
; resp@gsLineLabelString= "test"                    ; adds a line label string

; create array of dummy graphic variables. This is required, b/c each line
; must be associated with a unique dummy variable.

  dum = new(4,graphic)  

; draw each line separately. Each line must contain two points.
  do i = 0,3
    dum(i)=gsn_add_polyline(wks,plot,xpts(i:i+1),ypts(i:i+1),resp)      
  end do 
  
  draw(plot)   ; This will draw attached polylines and map
  frame(wks)   ; Advanced frame.NhlTColorIndexGenArray

end
