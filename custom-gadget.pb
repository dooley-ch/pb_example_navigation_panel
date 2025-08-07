;╔═════════════════════════════════════════════════════════════════════════════════════════════════
;║     custom-gadget.pb                                                                           
;╠═════════════════════════════════════════════════════════════════════════════════════════════════
;║     Created: 06-08-2025 
;║
;║     Copyright (c) 2025 James Dooley <james@dooley.ch>
;║
;║     History:
;║     06-08-2025 : Initial version
;╚═════════════════════════════════════════════════════════════════════════════════════════════════

XIncludeFile "navigation_panel.pbi"

EnableExplicit

UseModule NavigationPanelUI

UsePNGImageDecoder()

Define hMainWindow.i, hAppStoreButton
Define.i hAppStoreIcon, hBingIcon, hGoogleIcon, hTwitterIcon
Define.i hAppStoreHotIcon, hBingHotIcon, hGoogleHotIcon, hTwitterHotIcon
Define.i hAppStoreDisabledIcon, hBingDisabledIcon, hGoogleDisabledIcon, hTwitterDisabledIcon

;-------- Support Routines --------

Procedure OnResizeMainWindow()
  #NAV_PANEL_WIDTH = 200
  
  Shared hMainWindow
  Protected.i winHeight
  
  winHeight = WindowHeight(hMainWindow, #PB_Window_InnerCoordinate)
  
  ResizeGadget(GetNavigationPanelId(), 0, 0, #NAV_PANEL_WIDTH, winHeight)
EndProcedure

Procedure OnButtonAppStoreClicked()
  Shared hAppStoreButton
  Static disabled.b
  
  If Not disabled
    DisableNavigationItem(1, #True)
    SetGadgetText(hAppStoreButton, "Enable App Store")
    disabled = #True
  Else
    DisableNavigationItem(1, #False)
    SetGadgetText(hAppStoreButton, "Disable App Store")
    disabled = #False
  EndIf
  
EndProcedure

Procedure OnButtonBingClicked()
  SelectNavigationItem(2)
EndProcedure

Procedure OnTwitterClicked()
  Debug "Twitter clicked"
EndProcedure

Procedure OnButtonTwitterClicked()
  Shared hTwitterIcon, hTwitterHotIcon, hTwitterDisabledIcon
  
  AddNavigationItem(4, "Twitter", ImageID(hTwitterIcon), @OnTwitterClicked(), ImageID(hTwitterHotIcon), ImageID(hTwitterDisabledIcon))
EndProcedure

Procedure OnButtonGoogleClicked()
  RemoveNavigationItem(3)
EndProcedure

Procedure OnAppStoreClicked()
  Debug "App Store clicked"
EndProcedure

Procedure OnBingClicked()
  Debug "Bing clicked"
EndProcedure

Procedure OnGoogleClicked()
  Debug "Google clicked"
EndProcedure

  
;-------- Main Window --------
#MainWindow_Max_Width = 1500
#MainWindow_Max_Height = 800
#MainWindow_Min_Width = 900
#MainWindow_Min_Height = 600

#MainWindowFlags = #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget | #PB_Window_SizeGadget | #PB_Window_TitleBar | #PB_Window_ScreenCentered

hMainWindow = OpenWindow(#PB_Any, #PB_Ignore, #PB_Ignore, #MainWindow_Min_Width, #MainWindow_Min_Height, "Custom Gadget Demo", #MainWindowFlags)
If IsWindow(hMainWindow)
  Define cfg.NavigationPanelConfigInfo, event.i, exitMainLoop.b = #False
  Define.i hButton
  
  hAppStoreIcon = CatchImage(#PB_Any, ?AppStoreIcon)
  hBingIcon = CatchImage(#PB_Any, ?BingIcon)
  hGoogleIcon = CatchImage(#PB_Any, ?GoogleIcon)
  hTwitterIcon = CatchImage(#PB_Any, ?TwitterIcon)
  
  hAppStoreHotIcon = CatchImage(#PB_Any, ?AppStoreHotIcon)
  hBingHotIcon = CatchImage(#PB_Any, ?BingHotIcon)
  hGoogleHotIcon = CatchImage(#PB_Any, ?GoogleHotIcon)
  hTwitterHotIcon = CatchImage(#PB_Any, ?TwitterHotIcon)
  
  hAppStoreDisabledIcon = CatchImage(#PB_Any, ?AppStoreDisabledIcon)
  hBingDisabledIcon = CatchImage(#PB_Any, ?BingDisabledIcon)
  hGoogleDisabledIcon = CatchImage(#PB_Any, ?GoogleDisabledIcon)
  hTwitterDisabledIcon = CatchImage(#PB_Any, ?TwitterDisabledIcon)
  
  WindowBounds(hMainWindow, #MainWindow_Min_Width, #MainWindow_Min_Height, #MainWindow_Max_Width, #MainWindow_Max_Height)
  
  hButton = ButtonGadget(#PB_Any, 250, 10, 150, 25, "Select Bing")
  BindGadgetEvent(hButton, @OnButtonBingClicked(), #PB_All)
  
  hButton = ButtonGadget(#PB_Any, 250, 35, 150, 25, "Add Twitter")
  BindGadgetEvent(hButton, @OnButtonTwitterClicked(), #PB_All)
  
  hButton = ButtonGadget(#PB_Any, 250, 60, 150, 25, "Remove Google")
  BindGadgetEvent(hButton, @OnButtonGoogleClicked(), #PB_All)
  
  hAppStoreButton = ButtonGadget(#PB_Any, 250, 85, 150, 25, "Disable App Store")
  BindGadgetEvent(hAppStoreButton, @OnButtonAppStoreClicked(), #PB_All)
  
  With cfg
    \BackgroundColor = RGB($00, $66, $CC)
    \Flags = #PB_Container_Flat
    \ItemBackgroundColor = RGB($44, $66, $CC)
    \ItemSelectedBackgroundColor = RGB($33, $66, $FF)
    \ItemSelectedTextColor = #White
  EndWith
  
  AddNavigationItem(1, "App Store", ImageID(hAppStoreIcon), @OnAppStoreClicked(), ImageID(hAppStoreHotIcon), ImageID(hAppStoreDisabledIcon))
  SetNavigationPanelConfig(@cfg)
  AddNavigationItem(2, "Bing", ImageID(hBingIcon), @OnBingClicked(), ImageID(hBingHotIcon), ImageID(hBingDisabledIcon))
  AddNavigationItem(3, "Google", ImageID(hGoogleIcon), @OnGoogleClicked(), ImageID(hGoogleHotIcon), ImageID(hGoogleDisabledIcon))
  
  CreateNavigationPanel(hMainWindow)
  OnResizeMainWindow()
  
  Repeat
    event = WaitWindowEvent()
    
    Select event
      Case #PB_Event_SizeWindow
        OnResizeMainWindow()
      Case #PB_Event_CloseWindow
        exitMainLoop = #True 
    EndSelect
  Until exitMainLoop

  CloseWindow(hMainWindow)
EndIf

;-------- Clean up & Exit --------
End 0

;-------- Images --------
DataSection  
  AppStoreIcon:
  IncludeBinary #PB_Compiler_FilePath + "images/appstore@48px.png"
  
  BingIcon:
  IncludeBinary #PB_Compiler_FilePath + "images/bing@48px.png"
  
  GoogleIcon:
  IncludeBinary #PB_Compiler_FilePath + "images/google@48px.png"
  
  TwitterIcon:
  IncludeBinary #PB_Compiler_FilePath + "images/twitter@48px.png"  
  
  AppStoreHotIcon:
  IncludeBinary #PB_Compiler_FilePath + "images/hot/appstore@48px.png"
  
  BingHotIcon:
  IncludeBinary #PB_Compiler_FilePath + "images/hot/bing@48px.png"
  
  GoogleHotIcon:
  IncludeBinary #PB_Compiler_FilePath + "images/hot/google@48px.png"
  
  TwitterHotIcon:
  IncludeBinary #PB_Compiler_FilePath + "images/hot/twitter@48px.png" 
  
  AppStoreDisabledIcon:
  IncludeBinary #PB_Compiler_FilePath + "images/disabled/appstore@48px.png"
  
  BingDisabledIcon:
  IncludeBinary #PB_Compiler_FilePath + "images/disabled/bing@48px.png"
  
  GoogleDisabledIcon:
  IncludeBinary #PB_Compiler_FilePath + "images/disabled/google@48px.png"
  
  TwitterDisabledIcon:
  IncludeBinary #PB_Compiler_FilePath + "images/disabled/twitter@48px.png"    
EndDataSection

; IDE Options = PureBasic 6.21 - C Backend (MacOS X - arm64)
; ExecutableFormat = Console
; CursorPosition = 52
; FirstLine = 35
; Folding = --
; EnableXP
; DPIAware