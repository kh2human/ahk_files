#Persistent

#InstallKeybdHook

#InstallMouseHook
; Directive

ProcessKey(KeyName, UD)
{
	if (StrLen(KeyName) <= 0)
	{
		return 
	}
	
	ChkState := (InStr(UD, "Up") > 0) ? true : false
	
	if (ChkState == GetKeyState(KeyName))
	{
		Send, {Blind}{%KeyName% %UD%}
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
		SetTimer, KeyWatcher, 5
		 
		SetTimer, LockChecker, 5
		
		SetTimer, PressChk, 5 
		
		SetTimer, ReleaseChk, 5 

		SetTimer, MoveLoop, %TimerPeriod% 

		SetTimer, MoveLoop, Off 

		SetCapsLockState, Off 

		SetScrollLockState, Off 
		
		break 
	}
	catch {
		continue
	}
}
return
; Autoexec 

ReleaseChk:
{
	if (true == GetKeyState("LButton") && true == GetKeyState("RButton"))
	{
		ProcessKey("LButton", "Up")
		
		ProcessKey("RButton", "Up") 
	}
	
	For idx, KeyName in KeyNameList
	{
		if (false == GetKeyState(KeyName, "P"))
		{
			ProcessKey(KeyName, "Up")
		}
	}
}
return 

PressChk:
{
	if (true != GetKeyState(LockKey, "T")) 
	{
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
return 

MoveLoop:
{
	MoveKey := "LButton"

	if (A_IsSuspended)
	{
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
return 

LockChecker:
{
	isSuspendOn := (true == GetKeyState("ScrollLock", "T")) ? "Off" : "On" 

	Suspend, %isSuspendOn%
}
return 

KeyWatcher:
while, true 
{
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
			return
		}

		isFortNeed := (SomethingPressed) ? "Down" : "Up"

		ProcessKey(FortKey, isFortNeed)
		
		break 
	}
	catch {
		continue 
	}
}
return 
; Loop

~*CapsLock Up::
{
	if (false != GetKeyState(LockKey, "T"))
	{
		return 
	}
	
	Send, {Blind}{%FortKey% Up}
	;ProcessKey(FortKey, "Up")

	Send, {Blind}{%MoveKey% Up}
	;ProcessKey(MoveKey, "Up")

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