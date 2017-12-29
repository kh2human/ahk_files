#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

RapidCnt := 5
PeriodMain := 1000 / RapidCnt 
KeyLists := ["LButton", "RButton", "1", "2", "3", "4", "5", "q", "w", "e", "r", "t"] 
MoveKey := "1"
#Persistent 
SetCapsLockState, Off 
SetTimer, MainRunning, %PeriodMain% 
Menu, Tray, add
For i, k in KeyLists {
	Menu, MoveKey, add, %k%, MenuHandler
}
Menu, Tray, add, MoveKey, :MoveKey
return 

MenuHandler:
;MsgBox, You selected %A_ThisMenuItem% from menu %A_ThisMenu% 
MoveKey := A_ThisMenuItem
MsgBox, Now 'MoveKey' is %A_ThisMenuItem%
return

MainRunning:
; 키 입력이 있다면 중지
LastKey := 0 
For i, k in KeyLists { 
	SomeKey := RegExReplace(k, "[~*]+")
	KeySt := GetKeyState(SomeKey, "P")
	if (1 != KeySt) {
		LastKey += 0
	}
	else {
		LastKey += 1
	}
}
CapsState := GetKeyState("CapsLock", "T") 
if (LastKey <= 0 && 1 == CapsState) {
	if ("LButton" == MoveKey) {
		Click
	}
	else if ("RButton" == MoveKey) {
		Click, right 
	}
	else {
		Send {%MoveKey%}
	}
}
return 