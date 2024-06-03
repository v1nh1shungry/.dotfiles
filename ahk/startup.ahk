*CapsLock::Send "{Blind}{LCtrl Down}"
*CapsLock Up::
{
    Send "{Blind}{LCtrl Up}"
    if (A_PriorKey = "CapsLock")
        Send "{Esc}"
}