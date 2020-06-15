#include <MsgBoxConstants.au3>
#include <Array.au3>
#include <WinAPISys.au3>
#include <Date.au3>

; �������� ����� ��������� � ������ � ���� (����� �����, ��� ������ ����� ��� ������� �/��� ������)
Opt("TrayIconDebug", 1)

; ������ r������ Esc �� ������� ���������� ������� (����� ���� ����������� ��������������� ������ �� ������������ �����)
HotKeySet("{ESC}", "_Terminate")

; ���� ������������ ��� ������ (�� ���������� ��� ������)
Global $1dArray[1] = [""]

; ����� ������ ���������, ����� ������������ ��� ������� ������� ������� ������ ������, ��� ��� ������������� ������ � ������ �����, ����� ����� ������ �������
Global $timeStart = _NowCalc()



; �������� ����������� ���� ���������
While 1
   local $currentActiveWindow = WinGetTitle("[ACTIVE]")
   TbricksAlerts()		; ���������� ������� ������ � ��������� ���������� ������
   MouseEmulateMove()	; ����� ��������� ������� ���� �� �����, ������� ������ =)
   WinActivate($currentActiveWindow, "")
   WinWaitActive($currentActiveWindow, "")
   Sleep(5000) ; ������ ������������ �������� = ������ ��� � 5 ��� + ����� �� ���������� �������
   Local $dateDiff = _DateDiff('n', $timeStart, _NowCalc()) ; �������� ������� ����� �������� ������ � �������� ��������� �������� � �������
   If $dateDiff > 5 Then	; ���� ������ �������� > 5 �����, �� ������� ������ ������ � �������� ����� ������ ������� ��������
	  $timeStart = _NowCalc()
	  Global $1dArray[1] = [""]
   Else
   EndIf
WEnd



Func TbricksAlerts()
   ClipPut("") ; �� line #43
   ; ������� ������ ����, ������ ��� ��������, ������� � ������� ������ � �������
   If Not WinActive("Alerts - aosipov_home - [support@rencap_prod] - Tbricks *","") Then WinActivate("Alerts - aosipov_home - [support@rencap_prod] - Tbricks *","")
   WinWaitActive("Alerts - aosipov_home - [support@rencap_prod] - Tbricks *","")
   ControlClick("[Class:WindowsForms10.Window.8.app.0.13f26d9_r9_ad1]", "", "", "", 1, 124,25)
   Send("^c") ; �������� ����� ������ � �����
   Sleep(500)
   $newAlert = ClipGet() ;��������� � ����������
   If $newAlert = "" Then ; ���� ������� ���, �� ����������� �� ���������� � � $newAlert ����� ���������� ���, ��� ������. ����� ����� �������� �� ���������� ������ ������ � ����� � line 35
	  Return
   EndIf
   ; ������ �������������� �� 0, ��� ��� � ������� �������� �� ������ ������!!!!!
   ; ���������� �������� ������ � ��������, ���� ����������� ����� ��, �� ������� �� �������
   For $i = 1 To UBound($1dArray) - 1
	  If $1dArray[$i] == $newAlert Then
		 ; Alert already exists, function return
		 Return
	  EndIf
   Next
   ; ���� ������ �� �� �����, �� ��������� ��� � ������ ������
   _ArrayAdd($1dArray, $newAlert)
   ; ������ ���������, ����� ����������, ����� ���
   If StringInStr($newAlert, "Exchange event scheduler says") Or  Then
	  ;���� ��������� Exchange event scheduler says ���� � ������, �� ����� ����� ������ ����������
	  Return
   EndIf
   ; � ���������� � ����
   SendToTeams($newAlert) ; �������� ������� �������� ��������� � ���, ��������� �� ���� ��� �����

EndFunc



; ������� �������� ��������� � ���
Func SendToTeams($alert)
   ClipPut("")
   ConsoleWrite("Sending Active Alert: " & $alert & @CRLF)
   local $h = WinGetHandle("[REGEXPTITLE:(?i) Microsoft Teams]") ; �������� ������� �����
   WinActivate($h, "") ; ������ ���� ��������
   WinWaitActive($h, "")
   $iLanguage = "0x0409"
   _WinAPI_SetKeyboardLayout ( $h, $iLanguage ) ; ������ ������������ ��������� ���������� �����
   ControlClick($h, "", "", "", 1, 486,22) ; ������� � ������ ������
   Sleep(500)
   ControlSend($h, "", "", "@Tbricks Support Chat") ; ������ ������ ��� ��� � ���������� ���� ������
   ;ControlSend("[REGEXPTITLE:(?i)| Microsoft Teams]", "", "", "@Ignatov, Artem, ")
   Sleep(1000)
   ControlSend($h, "", "", "{ENTER}")
   Sleep(500)
   ClipPut($alert)
   ControlSend($h, "", "", "AUTO: ^v")
   Sleep(1000)
    ControlSend($h, "", "", "{ENTER}")
   Sleep(1000)
   ControlClick($h, "", "", "", 1, 772,25)
EndFunc



Func MouseEmulateMove()
   Local $x = Random(1, @DesktopWidth)
   Local $y = Random(1, @DesktopHeight)
   MouseMove($x, $y, 50)
EndFunc


Func _Terminate()
   Exit
EndFunc




