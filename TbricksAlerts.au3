#include <MsgBoxConstants.au3>
#include <Array.au3>
#include <WinAPISys.au3>
#include <Date.au3>

; включаем дебаг сообщение в иконке в трее (будет видно, где скрипт повис при отладке и/или работе)
Opt("TrayIconDebug", 1)

; биндим rлавишу Esc на функцию завершения скрипта (чтобы была возможность принудительного выхода из бесконечного цикла)
HotKeySet("{ESC}", "_Terminate")

; сюда складываются все ошибки (не попадающие под фильтр)
Global $1dArray[1] = [""]

; время начала программы, будем использовать для ротации времени очистки списка ошибок, так как повторяющиеся ошибки в разное время, могут иметь разную причину
Global $timeStart = _NowCalc()



; основной бесконечный цикл программы
While 1
   local $currentActiveWindow = WinGetTitle("[ACTIVE]")
   TbricksAlerts()		; вызывается функция поиска и обработки полученной ошибки
   MouseEmulateMove()	; чтобы удаленный рабочий стол не уснул, дергаем мышкой =)
   WinActivate($currentActiveWindow, "")
   WinWaitActive($currentActiveWindow, "")
   Sleep(5000) ; таймер регулярности проверок = дефолт раз в 5 сек + время на выполнение скрипта
   Local $dateDiff = _DateDiff('n', $timeStart, _NowCalc()) ; получаем разницу между временем старта и временем окончания проверки в минутах
   If $dateDiff > 5 Then	; если скрипт работает > 5 минут, то очищаем список ошибок и обнуляем время старта текущим временем
	  $timeStart = _NowCalc()
	  Global $1dArray[1] = [""]
   Else
   EndIf
WEnd



Func TbricksAlerts()
   ClipPut("") ; см line #43
   ; находим нужное окно, делаем его активным, кликаем в верхнюю запись в Алертах
   If Not WinActive("Alerts - aosipov_home - [******] - Tbricks *","") Then WinActivate("Alerts - aosipov_home - [*******] - Tbricks *","")
   WinWaitActive("Alerts - aosipov_home - [*******] - Tbricks *","")
   ControlClick("[Class:WindowsForms10.Window.8.app.0.13f26d9_r9_ad1]", "", "", "", 1, 124,25)
   Send("^c") ; копируем текст ошибки в буфер
   Sleep(500)
   $newAlert = ClipGet() ;сохраняем в переменную
   If $newAlert = "" Then ; если Алертов нет, то копирования не произойдет и в $newAlert может записаться все, что угодно. Чтобы этого избежать мы записываем пустую строку в буфер в line 35
	  Return
   EndIf
   ; ЗАВТРА ПРОТЕСТИРОВАТЬ ОТ 0, ТАК КАК Я ДОБАВИЛ ПРОВЕРКУ НА ПУСТУЮ СТРОКУ!!!!!
   ; перебираем элементы списка с ошибками, если встречается такой же, то выходим из фукнции
   For $i = 1 To UBound($1dArray) - 1
	  If $1dArray[$i] == $newAlert Then
		 ; Alert already exists, function return
		 Return
	  EndIf
   Next
   ; если такого же не нашли, то добавляем его в список ошибок
   _ArrayAdd($1dArray, $newAlert)
   ; фильтр сообщений, какие отправлять, какие нет
   If StringInStr($newAlert, "Exchange event scheduler says") Or  Then
	  ;если подстрока Exchange event scheduler says есть в Алерте, то такуб серию ошибок игнориурем
	  Return
   EndIf
   ; и отправляем в Тимс
   SendToTeams($newAlert) ; вызываем функцию отправки сообщения в чат, передавая на вход наш алерт

EndFunc



; функция отправки сообщения в чат
Func SendToTeams($alert)
   ClipPut("")
   ConsoleWrite("Sending Active Alert: " & $alert & @CRLF)
   local $h = WinGetHandle("[REGEXPTITLE:(?i) Microsoft Teams]") ; получаем хендлер Тимса
   WinActivate($h, "") ; делаем окно активным
   WinWaitActive($h, "")
   $iLanguage = "0x0409"
   _WinAPI_SetKeyboardLayout ( $h, $iLanguage ) ; задаем обязательную раскладку английской клавы
   ControlClick($h, "", "", "", 1, 486,22) ; кликаем в строке поиска
   Sleep(500)
   ControlSend($h, "", "", "@Tbricks Support Chat") ; вводим нужный нам чат и отправляем туда ошибку
   ;ControlSend("[REGEXPTITLE:(?i)| Microsoft Teams]", "", "", "@Osipov, Aleksei, ")
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




