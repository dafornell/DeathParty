VAR has_key = false
VAR checkedlockeddoor = false
->OliviaBasementLockedDoor

==OliviaBasementLockedDoor==
{checkedlockeddoor and has_key == false:
[Olivia] Still locked.
}

{checkedlockeddoor == false and has_key == false: 
[Olivia] Locked. 
Hang on, whats this? 
Keep out! Closed due to police investigation. Only the president is allowed inside!
}

{has_key:
This could be it. We might finally be able to find out what happened to Kyle. Here goes nothing.
}
~checkedlockeddoor = true
    -> END
– — —
