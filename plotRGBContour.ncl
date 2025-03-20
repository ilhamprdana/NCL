begin
;************************************************
; open file and read in data
;************************************************

  
  minlat = -8.86
  maxlat = -5.86
  minlon = 111.26
  maxlon = 114.26
  resol0 = 0.02
  resol1 = 0.0025

  minval1 = 240.
  maxval1 = 280.
 
; File 1 Satelit 
  in1 = addfile("/mnt/d/H08_B03_Indonesia_201807220600.nc","r")
  t  = in1->VS(0,:,:)
  lat1=in1->latitude
  lon1=in1->longitude
  
  minlonind1 = closest_val(minlon,lon1)
  maxlonind1 = closest_val(maxlon,lon1)
  minlatind1 = closest_val(minlat,lat1)
  maxlatind1 = closest_val(maxlat,lat1)
  
  Band1=t(minlatind1(0):maxlatind1(0),minlonind1(0):maxlonind1(0))
  Band1=Band1*255
  
; File 2 Satelit 
  in2 = addfile("/mnt/d/H08_B02_Indonesia_201807220600.nc","r")
  t  = in2->V2(0,:,:)
  lat1=in2->latitude
  lon1=in2->longitude
  
  minlonind1 = closest_val(minlon,lon1)
  maxlonind1 = closest_val(maxlon,lon1)
  minlatind1 = closest_val(minlat,lat1)
  maxlatind1 = closest_val(maxlat,lat1)
  
  Band2=t(minlatind1(0):maxlatind1(0),minlonind1(0):maxlonind1(0))
  Band2=Band2*255
  
; File 1 Satelit 
  in3 = addfile("/mnt/d/H08_B01_Indonesia_201807220600.nc","r")
  t  = in3->V1(0,:,:)
  lat1=in3->latitude
  lon1=in3->longitude
  
  minlonind1 = closest_val(minlon,lon1)
  maxlonind1 = closest_val(maxlon,lon1)
  minlatind1 = closest_val(minlat,lat1)
  maxlatind1 = closest_val(maxlat,lat1)
  
  Band3=t(minlatind1(0):maxlatind1(0),minlonind1(0):maxlonind1(0))
  Band3=Band3*255

  band_dims = dimsizes(Band3)
  nlat      = band_dims(0)
  nlon      = band_dims(1)

; Interpolation
  lon0 = fspan(minlon,maxlon,tointeger(((maxlon-minlon)/resol0)+1))
  lat0 = fspan(minlat,maxlat,tointeger(((maxlat-minlat)/resol0)+2))
  
  lon9 = fspan(minlon,maxlon,tointeger(((maxlon-minlon)/resol1)+1))
  lat9 = fspan(minlat,maxlat,tointeger(((maxlat-minlat)/resol1)+1))
  
  Band3_1 = linint2_Wrap(lon0,lat0,Band3,False,lon9,lat9,0)
  Band2_1 = linint2_Wrap(lon0,lat0,Band2,False,lon9,lat9,0)
  Band1_1 = linint2_Wrap(lon0,lat0,Band1,False,lon9,lat9,0)
  
  in4 = addfile("/mnt/d/Data/Skripsi/Satelit/Case/20180722.nc","r")

  t4=in4->ci
  latsat=in4->lat
  lonsat=in4->lon
  
  minlonind4 = closest_val(minlon,lonsat)
  maxlonind4 = closest_val(maxlon,lonsat)
  minlatind4 = closest_val(minlat,latsat)
  maxlatind4 = closest_val(maxlat,latsat)

  cif=t4(36,minlatind4(0):maxlatind4(0),minlonind4(0):maxlonind4(0))
  cif=cif(::-1,:)
  
  cif = where(cif.lt.1.,cif@_FillValue,cif)

;---Start the graphics
  wks = gsn_open_wks("X11", "newcolor")
  res                 = True
  res@gsnMaximize     = True
  res@vpHeightF       = tofloat(nlat)/max((/nlat,nlon/))
  res@vpWidthF        = tofloat(nlon)/max((/nlat,nlon/))

  res@gsnFrame        = False        ; Don't draw or advance
  res@gsnDraw         = False        ; frame yet.

  res@cnFillOn        = True         ; Turn on filled rasters
  res@cnFillMode      = "RasterFill"

  res@cnLevelSelectionMode  = "EqualSpacedLevels"
  res@cnMaxLevelCount       = 254  
  res@cnFillBackgroundColor = (/ 1., 1., 1., 1./)

  res@cnLinesOn       = False              ; Turn off contour lines      .
  res@cnLineLabelsOn  = False              ; Turn off contour labels
  res@cnInfoLabelOn   = False              ; Turn off info label
  res@gsnTickMarksOn  = False              ; Turn off tickmarks
  res@lbLabelBarOn    = False              ; Turn off labelbar
  res@gsnRightString  = ""                 ; Turn off subtitles
  res@gsnLeftString   = ""
   
  res@sfXArray              = lon9
  res@sfYArray              = lat9
  res@pmTickMarkDisplayMode = "Always"            ; nicer tickmarks

  cires = True
  cires@gsnFrame        = False        ; Don't draw or advance
  cires@gsnDraw         = False        ; frame yet.

  cires@cnFillOn        = True         ; Turn on filled rasters
  cires@cnFillMode      = "RasterFill"
  cires@cnLineColor = "yellow"
  cires@cnLinesOn = True  
  cires@cnLineLabelsOn       = True
  cires@cnMonoLineColor  = False 
  cires@cnLineThicknessF = 5.0 


;---Construct RGBA colormaps...
  ramp   = fspan(0., 1., 255)
  reds   = new((/255, 4/), float)
  greens = new((/255, 4/), float)
  blues  = new((/255, 4/), float)
  
  reds   = 0
  greens = 0
  blues  = 0

  reds(:,0)   = ramp
  greens(:,1) = ramp
  blues(:,2)  = ramp
  
  ; The red contour map is plotted fully opaque; the green and blue
  ; are plotted completely transparent. When overlain, the colors 
  ; combine (rather magically).
  reds(:,3)   = 1.
  greens(:,3) = 0 
  blues(:,3)  = 0
  
  res@cnFillColors = greens 
  greenMap = gsn_csm_contour(wks, Band2_1, res) 

  res@cnFillColors = blues
  blueMap = gsn_csm_contour(wks, Band3_1, res) 
 
;---This will be our base, so make it a map plot.
  res@cnFillColors             = reds 

  redMap = gsn_csm_contour(wks, Band1_1, res) 
  
  ciplot = gsn_csm_contour(wks, cif, cires)

;---Overlay everything
  overlay(redMap, greenMap)
  overlay(redMap, blueMap)
  overlay(redMap, ciplot)


  lnres             		= True           ; resource list for polylines
  lnres@gsLineColor = "yellow"
  lnres@gsLineThicknessF = 4.0
  
  id2 = gsn_add_shapefile_polylines(wks,redMap,"/mnt/d/Data/Shp/data1/IDN_adm1.shp",lnres)

  draw(redMap)
  frame(wks)


end