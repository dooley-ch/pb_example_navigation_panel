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
EnableExplicit

#App_Title$ =  "Custom Gadget Demo"

#Caption_EnableAppStore = "Enable App Store"
#Caption_DisableAppStore = "Disable App Store"
#Caption_RemoveGoogle = "Remove Google"
#Caption_AddGoogle = "Add Google"
#Caption_SelectBing = "Select Bing"
#Caption_DeselectBing = "Deselect Bing"
#Caption_AddTwitter = "Add Twitter"
#Caption_RemoveTwitter = "Remove Twitter"

Enumeration 1000
  #Command_Run_AppStore
  #Command_Run_Bing
  #Command_Run_Google
  #Command_Run_Twitter
EndEnumeration

XIncludeFile "navigation_panel.pbi"

UseModule NavigationPanelUI

UsePNGImageDecoder()

Define.i hMainWindow, hStatusBar, hAppStoreButton, hGoogleButton, hBingButton, hTwitterButton
Define.i hAppStoreIcon, hBingIcon, hGoogleIcon, hTwitterIcon
Define.i hAppStoreHotIcon, hBingHotIcon, hGoogleHotIcon, hTwitterHotIcon
Define.i hAppStoreDisabledIcon, hBingDisabledIcon, hGoogleDisabledIcon, hTwitterDisabledIcon

;-------- Support Routines --------

; Invoked when the corresponding item is clicked on the navigation panel
;
Procedure OnAppStoreClicked()
  Shared hMainWindow
  MessageRequester(#App_Title$, "AppStore procedure invoked", #PB_MessageRequester_Info | #PB_MessageRequester_Ok, WindowID(hMainWindow))
EndProcedure

; Invoked when the corresponding item is clicked on the navigation panel
;
Procedure OnBingClicked()
  Shared hMainWindow
  MessageRequester(#App_Title$, "Bing procedure invoked", #PB_MessageRequester_Info | #PB_MessageRequester_Ok, WindowID(hMainWindow))
EndProcedure

; Invoked when the corresponding item is clicked on the navigation panel
;
Procedure OnGoogleClicked()
  Shared hMainWindow
  MessageRequester(#App_Title$, "Google procedure invoked", #PB_MessageRequester_Info | #PB_MessageRequester_Ok, WindowID(hMainWindow))
EndProcedure

; Invoked when the corresponding item is clicked on the navigation panel
;
Procedure OnTwitterClicked()
  Shared hMainWindow
  MessageRequester(#App_Title$, "Twitter procedure invoked", #PB_MessageRequester_Info | #PB_MessageRequester_Ok, WindowID(hMainWindow))
EndProcedure

; Handles the user event of resizing main window
;
Procedure OnResizeMainWindow()
  #NAV_PANEL_WIDTH = 200
  
  Shared hMainWindow, hStatusBar
  Protected.i winHeight, barHeight
  
  winHeight = WindowHeight(hMainWindow, #PB_Window_InnerCoordinate)
  barHeight = StatusBarHeight(hStatusBar)
  
  ResizeGadget(GetNavigationPanelId(), 0, 0, #NAV_PANEL_WIDTH, (winHeight - barHeight))
EndProcedure

; Invoked when the user clicks on the AppStore button
;
Procedure OnButtonAppStoreClicked()
  Shared hAppStoreButton
  Static disabled.b
  
  If Not disabled
    DisableNavigationItem(#Command_Run_AppStore, #True)
    SetGadgetText(hAppStoreButton, #Caption_EnableAppStore)
    disabled = #True
  Else
    DisableNavigationItem(#Command_Run_AppStore, #False)
    SetGadgetText(hAppStoreButton, #Caption_DisableAppStore)
    disabled = #False
  EndIf
EndProcedure

; Invoked when the user clicks on the Google button
;
Procedure OnButtonGoogleClicked()
  Shared hGoogleButton, hGoogleIcon, hGoogleHotIcon, hGoogleDisabledIcon
  Static removed.b
  
  If removed
    AddNavigationItem(#Command_Run_Google, "Google", ImageID(hGoogleIcon), @OnGoogleClicked(), ImageID(hGoogleHotIcon), ImageID(hGoogleDisabledIcon))
    SetGadgetText(hGoogleButton, #Caption_RemoveGoogle)
    removed = #False
  Else
    RemoveNavigationItem(#Command_Run_Google)
    SetGadgetText(hGoogleButton, #Caption_AddGoogle)
    removed = #True
  EndIf
EndProcedure

; Invoked when the user clicks on the Bing button
;
Procedure OnButtonBingClicked()
  Shared hBingButton
  Static selected.b
  
  If selected
    SelectNavigationItem(#Command_Run_Bing, #False)
    SetGadgetText(hBingButton, #Caption_SelectBing)
    selected = #False
  Else
    SelectNavigationItem(#Command_Run_Bing)
    SetGadgetText(hBingButton, #Caption_DeselectBing)
    selected = #True
  EndIf      
EndProcedure

; Invoked when the user clicks on the Twitter button
;
Procedure OnButtonTwitterClicked()
  Shared hTwitterButton, hTwitterIcon, hTwitterHotIcon, hTwitterDisabledIcon
  Static added.b
  
  If added
    RemoveNavigationItem(#Command_Run_Twitter)
    SetGadgetText(hTwitterButton, #Caption_AddTwitter)
    added = #False    
  Else
    AddNavigationItem(#Command_Run_Twitter, "Twitter", ImageID(hTwitterIcon), @OnTwitterClicked(), ImageID(hTwitterHotIcon), ImageID(hTwitterDisabledIcon))
    SetGadgetText(hTwitterButton, #Caption_RemoveTwitter)
    added = #True
  EndIf
EndProcedure
  
;-------- Main Window --------
#MainWindow_Max_Width = 1000
#MainWindow_Max_Height = 700
#MainWindow_Min_Width = 600
#MainWindow_Min_Height = 400

#MainWindowFlags = #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget | #PB_Window_SizeGadget | #PB_Window_TitleBar | #PB_Window_ScreenCentered

hMainWindow = OpenWindow(#PB_Any, #PB_Ignore, #PB_Ignore, #MainWindow_Min_Width, #MainWindow_Min_Height, #App_Title$, #MainWindowFlags)

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
  
  hStatusBar = CreateStatusBar(#PB_Any, WindowID(hMainWindow))
  
  hBingButton = ButtonGadget(#PB_Any, 250, 10, 150, 25, #Caption_SelectBing)
  BindGadgetEvent(hBingButton, @OnButtonBingClicked(), #PB_All)
  
  hTwitterButton = ButtonGadget(#PB_Any, 250, 35, 150, 25, #Caption_AddTwitter)
  BindGadgetEvent(hTwitterButton, @OnButtonTwitterClicked(), #PB_All)
  
  hGoogleButton = ButtonGadget(#PB_Any, 250, 60, 150, 25, #Caption_RemoveGoogle)
  BindGadgetEvent(hGoogleButton, @OnButtonGoogleClicked(), #PB_All)
  
  hAppStoreButton = ButtonGadget(#PB_Any, 250, 85, 150, 25, #Caption_DisableAppStore)
  BindGadgetEvent(hAppStoreButton, @OnButtonAppStoreClicked(), #PB_All)
  
  With cfg
    \BackgroundColor = RGB($00, $66, $CC)
    \Flags = #PB_Container_Flat
    \ItemBackgroundColor = RGB($44, $66, $CC)
    \ItemSelectedBackgroundColor = RGB($33, $66, $FF)
    \ItemSelectedTextColor = #White
  EndWith
  
  SetNavigationPanelConfig(@cfg)
  
  AddNavigationItem(#Command_Run_AppStore, "App Store", ImageID(hAppStoreIcon), @OnAppStoreClicked(), ImageID(hAppStoreHotIcon), ImageID(hAppStoreDisabledIcon))
  AddNavigationItem(#Command_Run_Bing, "Bing", ImageID(hBingIcon), @OnBingClicked(), ImageID(hBingHotIcon), ImageID(hBingDisabledIcon))
  AddNavigationItem(#Command_Run_Google, "Google", ImageID(hGoogleIcon), @OnGoogleClicked(), ImageID(hGoogleHotIcon), ImageID(hGoogleDisabledIcon))
  
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
; CursorPosition = 23
; FirstLine = 144
; Folding = --
; EnableXP
; DPIAware