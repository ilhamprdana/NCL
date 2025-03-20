;================================================
;  topo_5.ncl
;================================================
; Concepts illustrated:
;   - Drawing two topographic maps using a subset of 1' data
;   - Using "MeshFill" for faster contouring
;   - Using functions for cleaner code
;   - Using cnFillPalette to assign a color palette to contours
;   - Using two different colormaps on one frame
;----------------------------------------------------------------------
; This script draws subsets of a global 1' topo grid downloaded from:
;
; http://www.ngdc.noaa.gov/mgg/global/relief/ETOPO1/data/bedrock/cell_registered/netcdf/
;----------------------------------------------------------------------
;
; These files are loaded by default in NCL V6.2.0 and newer
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"

;----------------------------------------------------------------------
; This function returns a color map for use with ocean elevation values.
;----------------------------------------------------------------------
undef("get_land_colormap")
function get_land_colormap()
begin
  cmap = (/ (/251,     251,   251/), \
            (/238,     238,   238/), \
            (/221,     221,   221/), \
            (/205,     205,   205/), \
            (/191,     191,   191/), \
            (/173,     173,   173/), \
            (/159,     159,   159/), \
            (/144,     144,   144/), \
            (/129,     129,   129/), \
            (/117,     117,   117/), \
            (/104,     104,   104/), \
            (/90,       90,    90/), \
            (/80,       80,    80/), \
            (/66,       66,    66/), \
            (/56,       56,    56/), \
            (/45,       45,    45/), \
            (/35,       35,    35/), \
            (/25,       25,    25/), \
            (/19,       19,    19/), \
            (/11,       11,    11/), \
            (/0,         0,     0/)/)/255.
  return(cmap)
end

;----------------------------------------------------------------------
; This procedure draws subsets of a global 1' topographic map read in
; from a netCDF file. The first plot is of land, the second of ocean.
; Two different colormaps and contour levels are used.
;----------------------------------------------------------------------
undef("draw_topo_map")
procedure draw_topo_map(wks,minlat,maxlat,minlon,maxlon)
begin
;---Read data
  topo_file = "D:/Data/ETOPO1_Bed_c_gmt4.grd.nc"
  a         = addfile(topo_file,"r")
  elev_lnd  = a->z({minlat:maxlat},{minlon:maxlon})
  elev_lnd  = where(elev_lnd.lt.-90,elev_lnd@_FillValue,elev_lnd)

;---Set some resources
  res                   = True

  res@gsnDraw           = False    ; will panel later
  res@gsnFrame          = False    ; will panel later

  res@cnFillOn          = True     ; turn on contour fill
  res@lbOrientation     = "Vertical"

  res@cnLinesOn         = False    ; turn off contour lines
  res@cnLineLabelsOn    = False    ; turn off line labels
  res@cnFillMode        = "MeshFill"
  res@lbBoxLinesOn      = False

  res@gsnAddCyclic      = False

;---Zoom in on map
  res@mpMinLatF         = minlat
  res@mpMaxLatF         = maxlat
  res@mpMinLonF         = minlon
  res@mpMaxLonF         = maxlon
  res@mpCenterLonF      = (res@mpMinLonF + res@mpMaxLonF) / 2.

  res@mpDataBaseVersion = "MediumRes"   ; Improve map outlines
  res@mpFillDrawOrder   = "PostDraw"

  res@gsnLeftString     = ""            ; make sure these
  res@gsnRightString    = ""            ; are blank

;---Get color map for land
  cmap := get_land_colormap()
  res@cnFillPalette := cmap

;---Set contours for land levels
  mnmxint = nice_mnmxintvl( min(elev_lnd), max(elev_lnd), 18, False)
  res@cnLevelSelectionMode = "ManualLevels"
  res@cnMinLevelValF       = mnmxint(0)
  res@cnMaxLevelValF       = mnmxint(1)
  res@cnLevelSpacingF      = mnmxint(2)/8.
  res@mpOceanFillColor     = "blue"
  res@mpLandFillColor      = -1            ; transparent

  plot_lnd  = gsn_csm_contour_map(wks,elev_lnd,res)


end

;----------------------------------------------------------------------
; Main code
;----------------------------------------------------------------------
begin
  wks = gsn_open_wks("png","topo")   ; send graphics to PNG file
;
; Increase memory for contours. This is necessary if you are 
; contouring a large grid. Otherwise, you might get this error:
;
;     fatal:ContourPlotDraw: Workspace reallocation would exceed maximum size 262144
;
;  setvalues NhlGetWorkspaceObjectId() 
;    "wsMaximumSize" : 100000000000000000
;  end setvalues

  draw_topo_map(wks,-8,7,90,105)
  frame(wks)
end