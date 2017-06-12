#Persistent

#InstallKeybdHook

#InstallMouseHook
; Directive

ProcessKey(KeyName, UD)
{
	try 
	{
		if (StrLen(KeyName) <= 0)
		{
			sleep, -1 
			
			return 
		}
		
		ChkState := (InStr(UD, "Up") > 0) ? true : false
		
		if (ChkState == GetKeyState(KeyName))
		{
			Send, {Blind}{%KeyName% %UD%}
		}
	}
	catch 
	{
		sleep, -1
	}
}

RemoveCh(KeyName, Chars)
{
	result := Trim(KeyName)
	
	For idx, Ch in Chars
	{
		result := StrReplace(result, Ch, "")
	}
	
	return result
}
; Function

RpdCnt := 10

RpdSec := 1

TimerPeriod := (RpdSec * 1000) / RpdCnt

LockKey := "CapsLock"

FortKey := "LShift"

KeyNameList := Array()

LoopEnabled := "Off" 
; Variable 

while, true 
{
	try
	{	
		SetScrollLockState, Off 
		
		SetCapsLockState, Off 
		
		SetTimer, KeyWatcher, 5
		 
		SetTimer, LockChecker, 5
		
		SetTimer, PressChk, 5 
		
		SetTimer, ReleaseChk, 5 

		SetTimer, MoveLoop, %TimerPeriod% 

		SetTimer, MoveLoop, Off 

		break 
	}
	catch {
		Sleep, -1 
		
		continue
	}
}
return
; Autoexec 

ReleaseChk:
try 
{
	For idx, KeyName in KeyNameList
	{
		if (false == GetKeyState(KeyName, "P") && true == GetKeyState(KeyName))
		{
			Send, {Blind}{%KeyName% Up} 
		}
	}
}
catch 
{
	sleep, -1 
}
return 

PressChk:
try 
{
	if (true != GetKeyState(LockKey, "T"))
	{
		sleep, -1 
		
		return 
	}
	
	For idx, KeyName in KeyNameList
	{
		if (true == GetKeyState(KeyName, "P"))
		{
			Send, {Blind}{%KeyName% Down} 
		}
	}
}	
catch 
{
	sleep, -1
}
return 

MoveLoop:
try 
{
	MoveKey := "LButton"
	
	if (A_IsSuspended)
	{
		Sleep, -1
		
		return 
	}

	if (true != GetKeyState(LockKey, "T"))
	{
		ProcessKey(MoveKey, "Up")
		
		return 
	}

	if (false == GetKeyState(MoveKey, "P"))
	{
		ProcessKey(MoveKey, "Up")
	}

	Sleep, 2

	ProcessKey(MoveKey, "Down")
}
catch 
{
	sleep, -1 
}
return 

LockChecker:
{
	isSuspendOn := (true == GetKeyState("ScrollLock", "T")) ? "Off" : "On" 

	Suspend, %isSuspendOn%
}
return 

KeyWatcher:
try
{
	SomethingPressed := false 

	For idx, KeyName in KeyNameList 
	{
		ThisKeyCheck := GetKeyState(KeyName, "P")
		
		ThisKeyPressed := true == ThisKeyCheck
		
		SomethingPressed := SomethingPressed || ThisKeyPressed 
		
	}

	isLoopOn := (SomethingPressed) ? "Off" : "On"

	if (InStr(LoopEnabled, isLoopOn) <= 0)
	{
		SetTimer, MoveLoop, %isLoopOn%
		
		LoopEnabled := isLoopOn
	}

	if (true != GetKeyState(LockKey, "T"))
	{
		Sleep, -1 
		
		return
	}

	isFortNeed := (SomethingPressed) ? "Down" : "Up"

	ProcessKey(FortKey, isFortNeed)
}
catch {
	Sleep, -1 
}
return 
; Loop

~*CapsLock Up::
{
	if (false != GetKeyState(LockKey, "T"))
	{
		Sleep, -1 
		
		return 
	}
	
	Send, {Blind}{%FortKey% Up}
	
	Send, {Blind}{%MoveKey% Up}
	
	KeyNameList := Array() 
}
return 

~*LButton::
~*RButton::
~*MButton::
~*1::
~*2::
~*3::
~*4::
~*5::
~*q::
~*w::
~*e::
~*r::
~*t::
{
	KeyAdded := false

	AddedName := RemoveCh(A_ThisHotKey, ["~", "*"])

	For idx, KeyName in KeyNameList
	{
		if (InStr(AddedName, KeyName) > 0)
		{
			KeyAdded := true
			
			break
		}
	}

	if (!KeyAdded)
	{
		KeyNameList.Push(AddedName)
	}
}
return 
; Mapping