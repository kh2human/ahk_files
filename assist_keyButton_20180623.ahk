; assist key or button for arpg pc games 
#Persistent
#InstallKeybdHook
#InstallMouseHook

SetCapsLockState, Off 
; default period (250)
; start from minimum 
Thread, NoTimers 
period := 1
periods := [0, 0, 0, 0]
for idx, val in periods
{
	periods[idx] := period
}
maxPeriod := period
SetTimer, TimerMng, %period%
SetTimer, ProcessInCaps, %period%
SetTimer, autoplayInCaps, %period%
lastInp := "" 
enableRapid := false 
rapidKey := "Alt"
inpedList := [] 
startTick := 0 
keyList := [""
	, "1", "2", "3", "4", "5"
	, "q", "w", "e", "r", "t" 
	, "LButton", "MButton", "RButton"]

; autoexec part
for idx, val in keyList
{
	if (val = "") 
	{
		continue
	}
	valCmmn := "*" . val 
	valUp := valCmmn . " Up"
	
	Hotkey, %valCmmn%, keyDowns, On
	Hotkey, %valUp%, keyUps, On 
}

chckInpProcess(keyName, keyUD)
{
	if (keyName = "") 
	{
		return 
	}
	if (keyUD = "") 
	{
		keyUD := "Up"
	}
	if (GetKeyState(keyName) != ((keyUD = "Down") ? true : false) )
	{
		Send, {Blind}{%keyName% %keyUD%}
		
	}	
}

rerunTimer(timerName, newPeriod) 
{
	SetTimer, %timerName%, Off 
	SetTimer, %timerName%, %newPeriod%
}

remChrs(keyName, chs)
{
	retKey := keyName 
	for idx, ch in chs 
	{
		retKey := StrReplace(keyName, ch) 
	}
	return retKey 
}

TimerMng:
startTick := A_TickCount
maxPeriod := Max(periods*)
if (maxPeriod > 0 && period != maxPeriod) 
{
	rerunTimer("TimerMng", maxPeriod) 
	rerunTimer("ProcessInCaps", maxPeriod) 
	rerunTimer("autoplayInCaps", maxPeriod) 
	period := maxPeriod
}
periods[0] := A_TickCount - startTick
return 

ProcessInCaps:
startTick := A_TickCount
suspState := GetKeyState("CapsLock", "T") ? "Off" : "On"
Suspend, %suspState%
if (A_IsSuspended)
{
	ToolTip
}
else 
{
	periods0 := periods[0]
	periods1 := periods[1]
	periods2 := periods[2]
	periods3 := periods[3]
	rapidCnt := Round(1000 / period) 
	ToolTip, Max(%periods0%ms & %periods1%ms & %periods2%ms & %periods3%ms) => %period%ms & %rapidCnt%/sec, 0, 0
}
periods[1] := A_TickCount - startTick
return 

autoplayInCaps:
startTick := A_TickCount
isInpExists := false 
for idx, val in inpedList 
{
	if (GetKeyState(val, "P")) 
	{
		isInpExists := true
		break 
	}
}
if (A_IsSuspended)
{
	chckInpProcess(lastInp, "Up")
	lastInp := "" 
}
else if (!isInpExists)
{
	chckInpProcess(lastInp, "Down")
	if (GetKeyState(rapidKey)) 
	{
		chckInpProcess(lastInp, "Up")
	}
}
periods[2] := A_TickCount - startTick
return 



keyDowns:
startTick := A_TickCount
isListExist := false 
for idx, val in inpedList 
{
	if (val = simpleInp)
	{
		isListExist := true 
		break
	}
}
if (!isListExist) 
{
	inpedList.push(simpleInp)
}
if (lastInp != "") 
{
	chckInpProcess(lastInp, "Up")
	KeyWait, %lastInp%, L	; 만약 뗄 입력이 없는데 떼도록 하는 거라면? 
	
}	
simpleInp := remChrs(A_ThisHotkey, ["*"])
Send {Blind}{%simpleInp% Down}
lastInp := simpleInp	
periods[3] := A_TickCount - startTick
return 

keyUps:
simpleInp := remChrs(A_ThisHotkey, ["*"])
Send {Blind}{%simpleInp%}
return 

~CapsLock::return 

~ScrollLock::
SetScrollLockState, Off 
ExitApp
return 