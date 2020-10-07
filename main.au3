#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=D:\Users\po.klinmala\Downloads\login_w_4jR_icon.ico
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include "OpenCV.au3"
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

#Region ### Init ###
Opt("GUIOnEventMode", 1)
Opt("PixelCoordMode",2)
Opt("MouseCoordMode",2)

_OpenCV_Startup()
_OpenCV_EnableLogging(True,True,True)

Global $sw = 0
Global $aPause = False
Global $WinHandle = WinGetHandle("NoxPlayer 7")
Global $btn = "Continue"

Global $startMission[4] = [1050, 604, 135,66]
Global $startSelectCharacter[4] = [1052, 604, 134,57]
Global $next[4] = [1073, 678, 71,42]
Global $hiddenShop[4] = [515, 303, 246,45]
Global $calcenHiddenShop[4] = [451, 501, 87,42]
Global $playAgin[4] = [820, 659, 122,46]
Global $SubmitPlayAgin[4] = [752, 505, 70,32]
Global $cancelHeadMode[4] = [454, 502, 81,38]
Global $relationship[4] = [1165, 58, 65,45]
Global $headMode[4] = [541, 352, 208,34]
Global $levelUp[4] = [569, 207, 145,33]
Global $submitLevelUp[4] = [600, 500, 82,39]
Global $StaminaLoss[4] = [553, 350, 177,37]
Global $missionFail[4] = [477, 40, 326,106]
Global $submitMissionFail[4] = [960, 658, 233,50]

HotKeySet("{ESC}", "_Terminate")
HotKeySet("{F4}", "SetScreen")
#EndRegion ### END Init ###

#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("BOT", 214, 74, -1, -1)
GUISetOnEvent($GUI_EVENT_CLOSE, "FormClose")
$Button1 = GUICtrlCreateButton("Bot", 24, 24, 75, 25)
GUICtrlSetOnEvent(-1, "Start_Click")
$Button2 = GUICtrlCreateButton($btn, 112, 24, 75, 25)
GUICtrlSetOnEvent(-1, "Stop_Click")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

#Region ### Main ###
While 1
	Sleep(100)
	Select
		Case $sw = 1
			$sw = 0
			StartBot()
	EndSelect
WEnd
#EndRegion ### END Main ###

#Region ### From ###
#EndRegion ### END From ###

#Region ### Method ###
Func _Terminate()
    Exit
EndFunc

Func StartBot()
    While 1
        if not $aPause Then
            Framing()          
        Else
            Sleep(200)
        EndIf
        Sleep(200)
    WEnd
EndFunc

Func Framing()
    ;lv up 574	493 645	522
    
    ;next result mission
	$Match1 = _ImageSearch($WinHandle,@ScriptDir&"\ImageBMP\nextMission.bmp", 0.70, $next,1,500)
    If Not @error Then
        _Click($WinHandle,$Match1[0], $Match1[1])
        Sleep(500)
	EndIf

    ;หารูปร้านค้าลับ
    $Match1 = _ImageSearch($WinHandle,@ScriptDir&"\ImageBMP\hiddenShop.bmp", 0.70,$hiddenShop,1,500)
    If Not @error Then
        $Match1 = _ImageSearch($WinHandle,@ScriptDir&"\ImageBMP\calcenHiddenShop.bmp", 0.70,$calcenHiddenShop,1,500)
        If Not @error Then
            Sleep(500)
            _Click($WinHandle,$Match1[0], $Match1[1])

            ;stop bot
            $aPause = Not $aPause
            TrayTip("BOT-PrincessConnectReDive", "Hidden shop is Open!", 0, 1)
            return;            
        EndIf
    EndIf 

    ;play again
    $Match1 = _ImageSearch($WinHandle,@ScriptDir&"\ImageBMP\playAgin.bmp", 0.70, $playAgin,1,500)
    If Not @error Then
        _Click($WinHandle,$Match1[0], $Match1[1])
        Sleep(500)

        ;stamina loss
        StaminaLoss()

        ;head mode
        HeadMode()

        ;submit play again
        $Match1 = _ImageSearch($WinHandle,@ScriptDir&"\ImageBMP\SubmitPlayAgin.bmp", 0.70,$SubmitPlayAgin,1,500)
        If Not @error Then
            Sleep(500)
            _Click($WinHandle,$Match1[0], $Match1[1])
        EndIf
    EndIf

    ;relationship
    $Match1 = _ImageSearch($WinHandle,@ScriptDir&"\ImageBMP\relationship.bmp", 0.70,$relationship,1,500)
    If Not @error Then
        Sleep(500)
        _Click($WinHandle,$Match1[0], $Match1[1])
    EndIf

    ;level up
    $Match1 = _ImageSearch($WinHandle,@ScriptDir&"\ImageBMP\levelUp.bmp", 0.70,$levelUp,1,500)
    If Not @error Then
        ;submit level up
        $Match1 = _ImageSearch($WinHandle,@ScriptDir&"\ImageBMP\submitLevelUp.bmp", 0.70,$submitLevelUp,1,500)
        If Not @error Then
            Sleep(500)
            _Click($WinHandle,$Match1[0], $Match1[1])
        EndIf
    EndIf

    ;mission fail
    $Match1 = _ImageSearch($WinHandle,@ScriptDir&"\ImageBMP\missionFail.bmp", 0.70,$missionFail,1,500)
    If Not @error Then
        $Match1 = _ImageSearch($WinHandle,@ScriptDir&"\ImageBMP\submitMissionFail.bmp", 0.70,$submitMissionFail,1,500)
        If Not @error Then
            Sleep(500)
            _Click($WinHandle,$Match1[0], $Match1[1])
            TrayTip("BOT-PrincessConnectReDive", "Mission Fail!", 0, 1)
            return
        EndIf
    EndIf
EndFunc

Func Start_Click()
    $sw = 1
EndFunc

Func Stop_Click()
    $aPause = Not $aPause
EndFunc

Func SetScreen()

    $aWidth = _WinAPI_GetWindowWidth($WinHandle)
    $aHeight = _WinAPI_GetWindowHeight($WinHandle)

    If $aWidth = 1280 Then return
    If $aHeight = 720 Then return

    WinMove($WinHandle,"",0,0,1200, 700)
    Sleep(500)
	WinMove($WinHandle,"",0,0,1280, 720)
    Sleep(500)
	WinSetState($WinHandle,"",@SW_MINIMIZE)
	Sleep(500)
	WinSetState($WinHandle,"",@SW_RESTORE)
    Sleep(500) 
EndFunc

Func HeadMode()
    $Match1 = _ImageSearch($WinHandle,@ScriptDir&"\ImageBMP\headMode.bmp", 0.70,$headMode,1,500)
        If Not @error Then
            $Match1 = _ImageSearch($WinHandle,@ScriptDir&"\ImageBMP\cancelHeadMode.bmp", 0.70,$cancelHeadMode,1,500)
            If Not @error Then
                Sleep(500)
                _Click($WinHandle,$Match1[0], $Match1[1])
                
                ;stop bot
                $aPause = Not $aPause
                TrayTip("BOT-PrincessConnectReDive", "Head Mode the end 0/3!", 0, 1)
                return;
            EndIf
        EndIf
EndFunc

Func StaminaLoss()
    $Match1 = _ImageSearch($WinHandle,@ScriptDir&"\ImageBMP\StaminaLoss.bmp", 0.70,$StaminaLoss,1,500)
    If Not @error Then
        $Match1 = _ImageSearch($WinHandle,@ScriptDir&"\ImageBMP\cancelHeadMode.bmp", 0.70,$cancelHeadMode,1,500)
        If Not @error Then
            Sleep(500)
            _Click($WinHandle,$Match1[0], $Match1[1])
            
            ;stop bot
            $aPause = Not $aPause
            TrayTip("BOT-PrincessConnectReDive", "Little Stamina left to use in Mission!", 0, 1)
            return;
        EndIf
    EndIf
EndFunc

Func FormClose()
	Exit
EndFunc
#EndRegion ### END Method ###
