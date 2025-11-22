VAR DJ_announcement = false
->OliviaNoraSamPartyRoomDancePartner

==OliviaNoraSamPartyRoomDancePartner==
+[Hey Nora, care to dance?] ->NoraDance
+[Sam, it's been a while...] ->SamDance
+[Hey Rowan--] ->RowanDance

==NoraDance==
[Nora] That depends...what do you have in mind?
[Olivia] Have you practiced your voguing at all since we last watched Paris is Burning?
[Nora] Haha, I may have dabbled...
-> DJAnnouncement

==SamDance==
[Olivia] What was the name of that band we saw right after winter break?
[Sam] Cairn Stranglers...Their bassist kicked ass.
[Olivia] Definitely a different crowd here. Should we see if we can get a moshpit going?
[Sam] Hell yea.
-> DJAnnouncement

==RowanDance==
[Rowan] Liv! Come dance with me!
[Olivia] I was just about to ask if you wanted to--
[Rowan] Yes girl. Come here, I'll lead!
-> DJAnnouncement
    
==DJAnnouncement==
~ DJ_announcement = true
[DJ] What is up my ghouls and goblins! You all look so great out there on that dance floor tonight! We're gonna be changing it up a bit and slowing down the beats for all you lovely couples to get in a dance.
Are you lonely? Got nobody to dance with? That's okay! DIE wants me to remind you that their Beer Pong for Bills charity tournament is about to get started! 
If you want a chance at winning seven minutes in heaven with DIE's very own president, get your asses to the kitchen and get your wallets ready!
[Olivia] That actually might not be a bad way to get some answers out of Caleb.
->END
