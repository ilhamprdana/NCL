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
  wks  = gsn_open_wks("X11","LatihanSHP")  ; send graphics to PNG file
  
  minlat = -7.5
  maxlat = -5
  minlon = 105.5
  maxlon = 108
  
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


; grid line setting
;  res@mpGridAndLimbOn 		= False 	;-- draw grid lines on the plot
;  res@mpGridLatSpacingF 	= 1 		;-- grid line latitude spacing
;  res@mpGridLonSpacingF 	= 1 		;-- grid line longitude spacing
;  res@mpGridLineColor 		= "gray" 	;-- grid line color
;  res@mpGridLineThicknessF 	= 2 		;-- grid line thickness
;  res@mpGridLineDashPattern 	= 2 		;-- grid line dash pattern
                                		;-- (2: dotted

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
  res@lbTitleJust = "TopCenterBottom"

  plot = gsn_csm_contour_map(wks, var, res)

;---Section to add polylines to map.
  
  lnres             		= True           ; resource list for polylines
  lnres@gsLineColor 		= "DarkSlateGray"
  lnres@gsLineThicknessF 	= 1.5
  
  id = gsn_add_shapefile_polylines(wks,plot,"/home/asus/NCL/Data/Shp/Indo_Districts.shp",lnres)

  lnres@gsLineColor = "black"
  lnres@gsLineThicknessF = 4.0
  
  id2 = gsn_add_shapefile_polylines(wks,plot,"/home/asus/NCL/Data/Shp/Indo_provinces.shp",lnres)
  
;----------------------------------------------------------------------
; Draw a large circle on a map.
;----------------------------------------------------------------------
  ncirc    = 100
  circ_lat = new(ncirc,float)               ; Create arrays to hold circle.
  circ_lon = new(ncirc,float)
  cen_lat  = -6.1714393
  cen_lon  = 106.6465687
  radi = 0.9009009009

  nggcog(cen_lat,cen_lon,radi,circ_lat,circ_lon)
  
  lnres@gsLineColor      = "black"
  lnres@gsLineThicknessF = 5.0
  id3 = gsn_add_polyline(wks, plot, circ_lon, circ_lat, lnres)
  
;************************************************
; label the box with additional text
;************************************************
  tres       =  True
  tres@txFontHeightF = 0.02
  id4 = gsn_add_text(wks,plot,"100 km",106.64656870,-5.2,tres)
  
;********************************
; Plot Pusat Radar
;********************************
   radar                   = True
   radar@gsMarkerIndex     = 2         ; polymarker style
   radar@gsMarkerSizeF     = 15.          ; polymarker size
   radar@gsMarkerColor		= "black"
   radar@gsMarkerThicknessF = 7.0
   lonradar = 106.6465687
   latradar = -6.1714393
   
   id5    = gsn_add_polymarker(wks,plot,lonradar,latradar,radar)

  draw(plot)   ; This will draw attached polylines and map
  frame(wks)   ; Advanced frame.NhlTColorIndexGenArray

end
