; rclick => lclick mapping for one click games only 
#Persistent

SetNumLockState, On
period := 1
periods := [0, 0]
for idx, val in periods
{
	periods[idx] := period
}
maxPeriod := period
SetTimer, TimerMng, %period%
SetTimer, ProcessInCaps, %period%

rerunTimer(timerName, newPeriod) 
{
	SetTimer, %timerName%, Off 
	SetTimer, %timerName%, %newPeriod%
	period := newPeriod
}

TimerMng:
startTick := A_TickCount
maxPeriod := Max(periods*)
if (maxPeriod > 0 && period != maxPeriod) 
{
	rerunTimer("TimerMng", maxPeriod) 
	rerunTimer("ProcessInCaps", maxPeriod) 
}
periods[0] := A_TickCount - startTick
return 

ProcessInCaps:
startTick := A_TickCount
suspState := GetKeyState("NumLock", "T") ? "On" : "Off"
Suspend, %suspState%
if (A_IsSuspended)
{
	ToolTip
}
else 
{
	periods0 := periods[0]
	periods1 := periods[1]
	ToolTip, Max(%periods0%ms & %periods1%ms) => %maxPeriod%ms, 0, 0
}
periods[1] := A_TickCount - startTick
return 

RButton::LButton

~CapsLock::return 