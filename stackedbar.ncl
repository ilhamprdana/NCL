;*************************************************
; bar_16.ncl
;
; Concepts illustrated:
;   - Creating a blank plot
;   - Drawing stacked bar plots
;*************************************************
;
; These files are loaded by default in NCL V6.2.0 and newer
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"

begin
  filename = "/mnt/d/Data/Skripsi/Final/Temporal/leadtimedem.csv"

;---Read in file as array of strings so we can parse each line
  data 	= asciiread(filename,-1,"float")

  dataswh = new((/6,6/),"float")
  dataswh(0,0:5)=data(0:5)
  dataswh(1,0:5)=data(6:11)
  dataswh(2,0:5)=data(12:17)
  dataswh(3,0:5)=data(18:23)
  dataswh(4,0:5)=data(24:29)
  dataswh(5,0:5)=data(30:35)
  
  
  cities = (/"60","50","40","30","20","10"/)

  ncities = dimsizes(cities)

  d6 = data(0:5)
  d5 = data(6:11)
  d4 = data(12:17)
  d3 = data(18:23)
  d2 = data(24:29)
  d1 = data(30:35)

  wks = gsn_open_wks("svg","bar")  ; send graphics to PNG file
;
; Set resources for blank plot. Be sure to set axes limits
; that represent d that will be added later via polygons.
;
  res                          = True

  res@gsnMaximize              = True    ; Maximize plot in frame
  res@gsnDraw                  = False   ; Don't draw
  res@gsnFrame                 = False   ; Don't advance frame

  res@vpWidthF                 = 0.7     ; Make long and
  res@vpHeightF                = 0.7     ; narrow

;---Set axes limits. Add extra space for X max.
  res@trYMinF                  = 0.0
  res@trYMaxF                  = 100
  res@trXMinF                  = 0
  res@trXMaxF                  = ncities


;---Put city labels on X axis
  res@tmXBMode                 = "Explicit"
  res@tmXBValues               = (/0.5,1.5,2.5,3.5,4.5,5.5/)
  res@tmXBLabels               = cities
  res@tmXBLabelJust            = "BottomCenter"
  res@tmXBLabelDeltaF 		   = 0.5

  res@gsnScale                 = True    ; Make labels on axes same size

;--Turn off X axis tickmarks
  res@tmXBMajorLengthF         = 0.
  res@tmXBMajorOutwardLengthF  = 0.  
  res@tmYLMajorLengthF         = 0.01
  res@tmYLMajorOutwardLengthF  = 0.01

  res@tmXTOn                   = False   ; Turn off top tickmarks
  res@tmYROn                   = False   ; Turn off top tickmarks
  res@tmYLMinorOn 			   = False
  
  res@pmTickMarkDisplayMode = "Always"
  res@tmBorderThicknessF	= 5.0
  res@tmXBMajorThicknessF = 5.0
  res@tmYLMajorThicknessF = 5.0
  res@tmYLLabelFontThicknessF = 5.0
  res@tmXBLabelFontThicknessF = 5.0
  res@tmXBLabelFontHeightF = 0.025  
  
  res@tiYAxisString   = "Persentase (%)"
  res@tiYAxisFontHeightF = 0.0225
  res@tiYAxisFontThicknessF = 2
  
  res@tiXAxisString   = "Lead Time (menit)"
  res@tiXAxisFontHeightF = 0.0225
  res@tiXAxisFontThicknessF = 2

;---Create blank plot without Y grid lines
  plot_without_xgrid = gsn_csm_blank_plot(wks,res)

;---Create blank plot with Y grid lines
  res@tmYMajorGrid                = False    ; Turn on grid lines
  res@tmYMajorGridLineDashPattern = 2       ; Dashed lines
  res@tmYMajorGridThicknessF      = 1.0     ; default is 2 (?)
  plot_with_xgrid = gsn_csm_blank_plot(wks,res)

;---Arrays to hold the bar values and the bars themselves.
  dum1 = new(ncities,graphic)
  dum2 = new(ncities,graphic)
  dum3 = new(ncities,graphic)
  dum4 = new(ncities,graphic)
  dum5 = new(ncities,graphic)
  dum6 = new(ncities,graphic)

;---Set some resources for the bars.
  bres           = True
  bres@gsEdgesOn = True      ; Outline the polygons (bars)
;
; Loop through each city and attach bar to plot that
; doesn't have grid lines.

  do i=1,ncities
    bres@gsEdgeThicknessF = 3.0
    bres@gsFillColor           = "(/0.75, 0.88, 0.80/)"
    
	xbar      = (/i-1,i-1,i,i,i-1/)	
    ybar      = (/0,d1(i-1),d1(i-1),0,0/)
    dum1(i-1) = gsn_add_polygon(wks,plot_without_xgrid,xbar,ybar,bres)

    bres@gsFillColor          = "(/0.44, 0.76, 0.82/)"
    
    ybar      = (/d1(i-1),d2(i-1)+d1(i-1),d2(i-1)+d1(i-1),d1(i-1),d1(i-1)/)
    dum2(i-1) = gsn_add_polygon(wks,plot_without_xgrid,xbar,ybar,bres)
    
    bres@gsFillColor          = "(/0.25, 0.62, 0.77/)"

    ybar      = (/d1(i-1)+d2(i-1),d3(i-1)+d2(i-1)+d1(i-1),\
                  d3(i-1)+d2(i-1)+d1(i-1),d1(i-1)+d2(i-1),\
                  d1(i-1)+d2(i-1)/)
    dum3(i-1) = gsn_add_polygon(wks,plot_without_xgrid,xbar,ybar,bres)
 
    
    bres@gsFillColor          = "(/0.19, 0.42, 0.65/)"

    ybar      = (/d1(i-1)+d2(i-1)+d3(i-1),d4(i-1)+d3(i-1)+d2(i-1)+d1(i-1),\
                  d4(i-1)+d3(i-1)+d2(i-1)+d1(i-1),d1(i-1)+d2(i-1)+d3(i-1),\
                  d1(i-1)+d2(i-1)+d3(i-1)/)
    dum4(i-1) = gsn_add_polygon(wks,plot_without_xgrid,xbar,ybar,bres)
	
	bres@gsFillColor          = "(/0.13, 0.23, 0.54/)"

    ybar      = (/d1(i-1)+d2(i-1)+d3(i-1)+d4(i-1),d5(i-1)+d4(i-1)+d3(i-1)+d2(i-1)+d1(i-1),\
                  d5(i-1)+d4(i-1)+d3(i-1)+d2(i-1)+d1(i-1),d1(i-1)+d2(i-1)+d3(i-1)+d4(i-1),\
                  d1(i-1)+d2(i-1)+d3(i-1)+d4(i-1)/)
    dum5(i-1) = gsn_add_polygon(wks,plot_without_xgrid,xbar,ybar,bres)
	
	bres@gsFillColor          = "(/0.08, 0.12, 0.37/)"
	
	ybar      = (/d1(i-1)+d2(i-1)+d3(i-1)+d4(i-1)+d5(i-1),d6(i-1)+d5(i-1)+d4(i-1)+d3(i-1)+d2(i-1)+d1(i-1),\
                  d6(i-1)+d5(i-1)+d4(i-1)+d3(i-1)+d2(i-1)+d1(i-1),d1(i-1)+d2(i-1)+d3(i-1)+d4(i-1)+d5(i-1),\
                  d1(i-1)+d2(i-1)+d3(i-1)+d4(i-1)+d5(i-1)/)
    dum6(i-1) = gsn_add_polygon(wks,plot_without_xgrid,xbar,ybar,bres)

 end do

;
; Drawing the plot will draw all the attached bars. Have to draw
; the plot twice: one with the X grid lines and one without, in
; order to make sure the X grid lines are behind the bars.
;
; Couldn't see how else to do this.

   lbres                    = True          ; labelbar only resources
   lbres@vpWidthF           = 0.2           ; labelbar width
   lbres@vpHeightF          = 0.15           ; labelbar height
   lbres@lbBoxMajorExtentF  = 0.4          ; puts space between color boxes
   lbres@lbBoxLineThicknessF = 2.5
   lbres@lbFillColors       = (/"red","blue","red","blue","red","blue"/)
   lbres@lbMonoFillPattern  = True          ; Solid fill pattern
   lbres@lbLabelJust        = "CenterLeft"  ; left justify labels
   lbres@lbPerimOn          = False
   lbres@lgPerimColor 	 = "white"
   lbres@lbLabelFontHeightF = 0.0175
   lbres@lbLabelFontThicknessF = 2
	 
	 
   labels = (/"OBJEK IK","OBJEK AWAN","OBJEK IK","OBJEK AWAN","OBJEK IK","OBJEK AWAN"/)
   gsn_labelbar_ndc(wks,6,labels,1.1,1.1,lbres)	; draw right labelbar column


   draw(plot_with_xgrid)
   draw(plot_without_xgrid)
   frame(wks)
end