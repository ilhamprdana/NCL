;**************************************************
; skewt_3.ncl
; https://www.ncl.ucar.edu/Applications/skewt.shtml
; Concepts illustrated:
;   - Drawing Skew-T plots
;   - Thinning the wind barbs in a Skew-T plot
;   - Customizing the background of a Skew-T plot
;**************************************************
;
; This file is loaded by default in NCL V6.2.0 and newer
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
;
; This file still has to be loaded manually
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/skewt_func2.ncl"
;**************************************************
 begin

; --- Read Data ----------------------------------------;
  diri = "/home/asus/NCL/"
  fili = "DataSounding.txt"
  nlvl = 59 
  ncol = 11 
  TestData = asciiread (diri+fili , (/nlvl,ncol/), "float") 
; order: Surface is 'bottom'  eg: 1000,950,935,897,...  
   
  p    = TestData (:,0)    ; pressure     [mb / hPa] 
  print(p)
  tc   = TestData (:,2)    ; temperature  [C]    
  tdc  = TestData (:,3)    ; dew pt temp  [C] 
  tdc@_FillValue = -999  
  z    = TestData (:,1)    ; geopotential [gpm] 
  wspd = TestData (:,7)    ; wind speed   [knots or m/s]    
  wdir = TestData (:,6)    ; meteorological wind dir

  print(tc)
  print(tdc)  
  
;*************************
; create plot
;*************************
  wks  = gsn_open_wks ("x11", "skewt")  ; send graphics to PNG file

; --- Create background skew-T and plot sounding----------------

  skewtOpts                 	= True
  skewtOpts@DrawColAreaFill 	= False    ; default is False
; skewtOpts@DrawColAreaColor  	= 3
; skewtOpts@DrawColLine       	= True
; skewtOpts@tiMainString    	= "ATS Rawindsonde: default dataOpts"  
  skewtOpts@PrintZ    			= False     ; print geopotential (Z) on skewT diagram
  skewtOpts@PlotWindP 			= True     ; plot wind barbs at p lvls
  skewtOpts@WspdWdir  			= True     ; wind speed and dir [else: u,v]
  skewtOpts@PlotWindH 			= False    ; plot wind barbs at h lvls [pibal; special]
  skewtOpts@HspdHdir  			= True     ; wind speed and dir [else: u,v]
  skewtOpts@ThermoInfo		  	= False     ; print thermodynamic info
  skewtOpts@DrawIsotherm      	= True
  skewtOpts@DrawIsobar        	= True
  skewtOpts@DrawMixRatio      	= True
  skewtOpts@DrawDryAdiabat    	= True
  skewtOpts@DrawMoistAdiabat  	= True ; aka: saturation or pseudo adibat
  skewtOpts@DrawWind          	= False
  skewtOpts@DrawStandardAtm   	= False
  skewtOpts@DrawColLine       	= True 
  skewtOpts@DrawColAreaFill   	= False 
  skewtOpts@DrawFahrenheit    	= True  ; Fahrenheit "x" axis
  skewtOpts@DrawHeightScale   	= False
  skewtOpts@DrawHeightScaleFt 	= True  ;default is feet [otherwise km] 
  skewtOpts@DrawStandardAtmThk	= 2.0



  dataOpts           = True     ; options describing data and ploting
  dataOpts@colTemperature = "black"   	; default -> "Foreground"
  dataOpts@colDewPt       = "(/0.51,0.51,0.52/)"   	; default -> "RoyalBlue"
  dataOpts@colCape        = "orange"  	; default -> "Red"
                                        ; Winds at Pressure levels
  dataOpts@colWindP       = "black"   	; default -> "Foreground"
                                        ; Winds at geopotential [Z] levels
  dataOpts@colWindZ       = "black"   	; default -> "Foreground"
                                        ; Winds at pibal Height levels
  dataOpts@colWindH       = "black"   	; default -> "Foreground"
  
  dataOpts@lineThicknessDewPt = 10			; line thickness dewpt
  dataOpts@lineThicknessTemperature = 10	; line thickness temp
                                        
											; sounding line patterns
  dataOpts@linePatternTemperature = 0 	; default=1 [solid]
  dataOpts@linePatternDewPt       = 15 	; default=1 [solid]
; dataOpts@linePatternCape        = 8 	; default=1 [solid]
                                        
                                        ; "x" location for windbarbs
; dataOpts@xpWind                 =42 	; default=45

                                        ; By default, skewT_PlotData expects
                                        ; wind speed (WSPD) and direction (WDIR).
; dataOpts@WspdWdir      = False      	; Set to False, if u and v are input.
  dataOpts@DrawWindBarbThk = 4.0      	; make wind barbs thicker; default value is 1.0; NCL version 6.4.0 
; dataOpts@hemisphere    = "NH"       	; "NH" -  Northern Hemisphere (default)
                                        ; "SH" -  Southern Hemisphere
  dataOpts@Wthin     = 2         	 	; Plot a subset of the winds. Default =1 
                                        ; =1 means every wind barb
                                        ; =5 would mean every 5-th 
                                        ;    wind report would be plotted.

; skewtOpts@tiMainString    = "ATS Rawindsonde: degC + Thin wind" 
  skewtOpts@DrawFahrenheit  = False   ; default is True
  
  skewtOpts@lineThicknessMixRatio     = 0

  skewt_bkgd = skewT_BackGround (wks, skewtOpts)
  skewt_data = skewT_PlotData   (wks, skewt_bkgd, p,tc,tdc,z \
                                    , wspd,wdir, dataOpts)
  draw (skewt_bkgd)
  draw (skewt_data)
  frame(wks)


 end
