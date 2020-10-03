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
Global $btn = "Start"

Global $arry1[4] = [1032,589, 71,40]
Global $arry2[4] = [1021, 592, 109,35]
Global $arry3[4] = [1026,656,73,36]
Global $arry4[4] = [788,643,121,31]
Global $arry5[4] = [716,491,79,31]
Global $arry6[4] = [416,487,105,42] ;ยกเลิก
Global $arry7[4] = [632,478,251,54] ;ร้านค้าลับ
Global $arry8[4] = [513,341,199,35] ;stamina


HotKeySet("{ESC}", "_Terminate")
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

    ;start mission
    $Match1 = _ImageSearch($WinHandle,@ScriptDir&"\pic\2.bmp", 0.70, $arry1,1,500)
    If Not @error Then
        _Click($WinHandle,$Match1[0], $Match1[1])
        Sleep(500)

        ;starmina loss
        $Match1 = _ImageSearch($WinHandle,@ScriptDir&"\pic\8.bmp", 0.70,$arry8,1,500)
        If Not @error Then
            $Match1 = _ImageSearch($WinHandle,@ScriptDir&"\pic\7.bmp", 0.70,$arry6,1,500)
            If Not @error Then
                Sleep(500)
                _Click($WinHandle,$Match1[0], $Match1[1])
                
                ;stop bot
                $aPause = Not $aPause
                TrayTip("BOT-PrincessConnectReDive", "Little Stamina left to use in Mission!", 0, 1)
                return;
            EndIf
        EndIf

        ;select character
		$Match1 = _ImageSearch($WinHandle,@ScriptDir&"\pic\3.bmp", 0.70, $arry2,1,500)
        If Not @error Then
            Sleep(500)
            _Click($WinHandle,$Match1[0], $Match1[1])
        EndIf
	EndIf

    ;next result mission
	$Match1 = _ImageSearch($WinHandle,@ScriptDir&"\pic\4.bmp", 0.70, $arry3,1,500)
    If Not @error Then
        _Click($WinHandle,$Match1[0], $Match1[1])
        Sleep(500)
	EndIf

    ;หารูปร้านค้าลับ
    $Match1 = _ImageSearch($WinHandle,@ScriptDir&"\pic\1.bmp", 0.70,$arry7,1,500)
    If Not @error Then
        $Match1 = _ImageSearch($WinHandle,@ScriptDir&"\pic\7.bmp", 0.70,$arry6,1,500)
        If Not @error Then
            Sleep(500)
            _Click($WinHandle,$Match1[0], $Match1[1])
            TrayTip("BOT-PrincessConnectReDive", "Hidden shop is Open!", 0, 1)
        EndIf
    EndIf 

    ;play again
    $Match1 = _ImageSearch($WinHandle,@ScriptDir&"\pic\5.bmp", 0.70, $arry4,1,500)
    If Not @error Then
        _Click($WinHandle,$Match1[0], $Match1[1])
        Sleep(500)

        ;stamina loss
        $Match1 = _ImageSearch($WinHandle,@ScriptDir&"\pic\8.bmp", 0.70,$arry8,1,500)
        If Not @error Then
            $Match1 = _ImageSearch($WinHandle,@ScriptDir&"\pic\7.bmp", 0.70,$arry6,1,500)
            If Not @error Then
                Sleep(500)
                _Click($WinHandle,$Match1[0], $Match1[1])
                
                ;stop bot
                $aPause = Not $aPause
                TrayTip("BOT-PrincessConnectReDive", "Little Stamina left to use in Mission!", 0, 1)
                return;
            EndIf
        EndIf

        ;submit play again
        $Match1 = _ImageSearch($WinHandle,@ScriptDir&"\pic\6.bmp", 0.70,$arry5,1,500)
        If Not @error Then
            Sleep(500)
            _Click($WinHandle,$Match1[0], $Match1[1])
        EndIf
    EndIf
EndFunc

Func Start_Click()
    $sw = 1
EndFunc

Func Stop_Click()
    $aPause = Not $aPause
EndFunc

Func FormClose()
	Exit
EndFunc
#EndRegion ### END Method ###
