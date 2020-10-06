; #SelectWinGUI# ====================================================================================================================
; Name ..........: SelectWinGUI
; Description ...: Screen Capture for get position use in Image Search
; Author ........: Linlijian
; Modified ......: Linlijian
; ===============================================================================================================================

#include-once
#include <ScreenCapture.au3>
#include <GDIPlus.au3>
#include <Misc.au3>
#include <GuiConstantsEx.au3>
#include <PrintWindow.au3>
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>

Opt("PixelCoordMode",2) ;relative coords to the client area of the defined window
Opt("MouseCoordMode",2) ;Enable OnEvent functions notifications.

HotKeySet('{F1}', "SelectSaveImageArea")
HotKeySet('{F2}', "SelectImageArea")

Global $WGHandle = WinGetHandle("NoxPlayer 7")
Global $WGImage = "Show BMP"

;delete size title
;Height = 4 from 1284 - 1280
;Width = 34 from 754 - 720 but i use 30
Global $windowsHeight = 30
Global $windowsWidth = 4

Global $pathImage = @ScriptDir & "\tempImage.bmp"
Global $pathSaveImage = @ScriptDir
Global $thresholdArea = 40
Global $iX1, $iY1, $iX2, $iY2, $runningNum = 0, $isShowImage = False, $isShowSaveImage = False

#Region ### START Koda GUI section ### Form=
$Form = GUICreate("Form", 300, 100, -1, -1)
GUISetOnEvent($GUI_EVENT_CLOSE, "FormClose")
$btnScreenCapture = GUICtrlCreateButton("Screen Capture", 8, 8, 280, 60)
GUICtrlSetFont(-1, 16, 400, 0, "Itim")
$createBy = GUICtrlCreateLabel("ชายกลัวดอกพิกุล", 190, 70, 100, 20)
GUICtrlSetFont(-1, 10, 800, 0, "Itim")
GUISetState(@SW_SHOW, $Form)
#EndRegion ### END Koda GUI section ###

#Region ### Form ###
While 1
	;event with form
	$nMsg = GUIGetMsg()

	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $btnScreenCapture
			ScreenCapture()
			ShowImage()
	EndSwitch
WEnd
#EndRegion ### Form ###

#Region ### Method ###
; ===============================================================================================================================
; Description ...: Screen Capture
; Author ........: Linlijian
; Notes .........:
; Modified.......: Linlijian
; ===============================================================================================================================
Func ScreenCapture()
	$image = _WinCapture($WGHandle)
	_ScreenCapture_SaveImage($pathImage, $image)
EndFunc

; ===============================================================================================================================
; Description ...: Display Image in GUI
; Author ........: Linlijian
; Notes .........:
; Modified.......: Linlijian
; ===============================================================================================================================
Func ShowImage()
	
    ; Load PNG imageSS
	_GDIPlus_StartUp()
	$hImage   = _GDIPlus_ImageLoadFromFile($pathImage)

	; Create GUI
	$hGUI = GUICreate($WGImage, _GDIPlus_ImageGetWidth($hImage), _GDIPlus_ImageGetHeight($hImage))
	GUISetState()

	; Draw PNG image
	$hGraphic = _GDIPlus_GraphicsCreateFromHWND($hGUI)
	_GDIPlus_GraphicsDrawImage($hGraphic, $hImage, 0, 0)

	GUISetState(@SW_HIDE, $Form)
	GUISetState(@SW_SHOW, $hGUI)

	;turn on HotKey {F1}
	$isShowSaveImage = True

	;turn on HotKey {F2}
	$isShowImage = True

	While 1
		;event with form
		$nMsg = GUIGetMsg()
	
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				GUISetState(@SW_SHOW, $Form)	
				GUIDelete($hGUI)
				
				;turn on HotKey {F1}
				$isShowSaveImage = False

				;turn off HotKey {F2}
				$isShowImage = False
				ExitLoop
		EndSwitch
	WEnd

	; Clean up resources
	_GDIPlus_GraphicsDispose($hGraphic)
	_GDIPlus_ImageDispose($hImage)
	_GDIPlus_ShutDown()
EndFunc

; ===============================================================================================================================
; Description ...: Mark Area in GUI for select position and save it
; Author ........: Linlijian
; Notes .........: Press F1 to use
; Modified.......: Linlijian
; ===============================================================================================================================
Func SelectSaveImageArea()
	While $isShowSaveImage 
		MouseUp("")
		MarkRectGUI()
		TrayTip("Select Windown GUI", "Save Complete", 0, 1)
		SaveImage()
		ExitLoop		
	WEnd
EndFunc

; ===============================================================================================================================
; Description ...: Mark Area in GUI for select position
; Author ........: Linlijian
; Notes .........: Press F2 to use
; Modified.......: Linlijian
; ===============================================================================================================================
Func SelectImageArea()
	While $isShowImage 
		MouseUp("")
		MarkRectGUI()
		ClipPut($iX1 & ', ' & $iY1 & ', ' & $iX2 & ',' & $iY2)
		TrayTip("Select Windown GUI", "Match-Coordinates been copied to the clipboard.", 0, 1)
		ExitLoop		
	WEnd
EndFunc

; ===============================================================================================================================
; Description ...: Get Screen size of Display Image
; Author ........: Linlijian
; Notes .........: Return Array of size
; Modified.......: Linlijian
; ===============================================================================================================================
Func ScreenSize()
	_GDIPlus_StartUp()

	Local $hGUI2[4]
	
	$hImage2   = _GDIPlus_ImageLoadFromFile($pathImage)

	$winPos = WinGetPos($WGImage)
	$hGUI2[0] = _GDIPlus_ImageGetWidth($hImage2)
	$hGUI2[1] = _GDIPlus_ImageGetHeight($hImage2)

	$hGUI2[2] = $winPos[0]
	$hGUI2[3] = $winPos[1]

	_GDIPlus_ShutDown()
	_GDIPlus_ImageDispose($hImage2)

	Return $hGUI2
EndFunc

; ===============================================================================================================================
; Description ...: Mark Area in GUI for select position and calulate size without title NoxPlayer
; Author ........: Linlijian
; Notes .........: Return position
; Modified.......: Linlijian
; ===============================================================================================================================
Func MarkRectGUI()

	Local $aMouse_Pos, $hMask, $hMaster_Mask, $iTemp
	Local $UserDLL = DllOpen("user32.dll")

	; Create transparent GUI with Cross cursor
	Local $Screensize = ScreenSize()
	$hCross_GUI = GUICreate("Test", $Screensize[0], $Screensize[1], $Screensize[2], $Screensize[3], $WS_POPUP, $WS_EX_TOPMOST)
	WinSetTrans($hCross_GUI, "", 8)
	GUISetState(@SW_SHOW, $hCross_GUI)
	GUISetCursor(3, 1, $hCross_GUI)

	Global $hRectangle_GUI = GUICreate("", $Screensize[0], $Screensize[1], $Screensize[2], $Screensize[3], $WS_POPUP, $WS_EX_TOOLWINDOW + $WS_EX_TOPMOST)
	GUISetBkColor(0x000000)

	; Wait until mouse button pressed
	While Not _IsPressed("01", $UserDLL)
		Sleep(10)
	WEnd

	; Get first mouse position
	$aMouse_Pos = MouseGetPos()
	$iX1 = $aMouse_Pos[0]
	$iY1 = $aMouse_Pos[1]

	; Draw rectangle while mouse button pressed
	While _IsPressed("01", $UserDLL)

		$aMouse_Pos = MouseGetPos()

		$hMaster_Mask = _WinAPI_CreateRectRgn(0, 0, 0, 0)
		$hMask = _WinAPI_CreateRectRgn($iX1, $aMouse_Pos[1], $aMouse_Pos[0], $aMouse_Pos[1] + 1) ; Bottom of rectangle
		_WinAPI_CombineRgn($hMaster_Mask, $hMask, $hMaster_Mask, 2)
		_WinAPI_DeleteObject($hMask)
		$hMask = _WinAPI_CreateRectRgn($iX1, $iY1, $iX1 + 1, $aMouse_Pos[1]) ; Left of rectangle
		_WinAPI_CombineRgn($hMaster_Mask, $hMask, $hMaster_Mask, 2)
		_WinAPI_DeleteObject($hMask)
		$hMask = _WinAPI_CreateRectRgn($iX1 + 1, $iY1 + 1, $aMouse_Pos[0], $iY1) ; Top of rectangle
		_WinAPI_CombineRgn($hMaster_Mask, $hMask, $hMaster_Mask, 2)
		_WinAPI_DeleteObject($hMask)
		$hMask = _WinAPI_CreateRectRgn($aMouse_Pos[0], $iY1, $aMouse_Pos[0] + 1, $aMouse_Pos[1]) ; Right of rectangle
		_WinAPI_CombineRgn($hMaster_Mask, $hMask, $hMaster_Mask, 2)
		_WinAPI_DeleteObject($hMask)
		; Set overall region
		_WinAPI_SetWindowRgn($hRectangle_GUI, $hMaster_Mask)

		If WinGetState($hRectangle_GUI) < 15 Then GUISetState()
		Sleep(10)

	WEnd

	; Get second mouse position
	$iX2 = $aMouse_Pos[0]
	$iY2 = $aMouse_Pos[1]

	; Set in correct order if required
	If $iX2 < $iX1 Then
		$iTemp = $iX1
		$iX1 = $iX2
		$iX2 = $iTemp
	EndIf
	If $iY2 < $iY1 Then
		$iTemp = $iY1
		$iY1 = $iY2
		$iY2 = $iTemp
	EndIf

	;cal pos without title for save
	$iX1 = $iX1 - $windowsWidth
	$iY1 = $iY1 - $windowsHeight
	$iX2 = $iX2 - $windowsWidth
	$iY2 = $iY2 - $windowsHeight
	$iX2 = ($iX2 - $iX1)
	$iY2 = ($iY2 - $iY1)

	GUIDelete($hRectangle_GUI)
	GUIDelete($hCross_GUI)
	DllClose($UserDLL)
EndFunc

; ===============================================================================================================================
; Description ...: Save Image for image search
; Author ........: Linlijian
; Notes .........: 
; Modified.......: Linlijian
; ===============================================================================================================================
Func SaveImage()
	$runningNum = $runningNum + 1
	$image = _WinCaptureAreaPosition($WGHandle, $iX1, $iY1, $iX2, $iY2)
	DirCreate($pathSaveImage & "\ImageBMP\")
	_ScreenCapture_SaveImage($pathSaveImage & '\ImageBMP\' & $runningNum & '.bmp', $image)
EndFunc

; ===============================================================================================================================
; Description ...: Close Form
; ===============================================================================================================================
Func FormClose()
    Exit
EndFunc
#EndRegion ### Method ###