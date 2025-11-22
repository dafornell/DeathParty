VAR talk_sam_nora = false

->OliviaRowanKitchen

==OliviaRowanKitchen==
{ talk_sam_nora:
->SeenSamNora
-else:
->NotSeenSamNora 
}

==SeenSamNora==
[Rowan] Doth mine eyes deceive me? Why, it's Olivia Herrera! In the flesh!

* [Yeah, yeah. I actually made it. Glad to be amongst people.]
[Rowan] It's so good to see you. I'm glad you're here.
->END

* [Yeah... it's been a while, huh?]
[Rowan] When was the last time we hung out...? Oh well don't let me keep you, we can reminisce later, go enjoy the party!
->END

==NotSeenSamNora==
[Rowan] It's so good to see you. I'm glad you're here.

* [Oh, hey! Glad you made it too.] -> glad_you
* [I thought you had rehearsal tonight?] -> rehearsal

===glad_you===
[Rowan] Hey, I never miss a good time! 
When was the last time we hung out...? Oh well don't let me keep you, we can reminisce later, go find Nora and Sam!
-> END

===rehearsal===
[Rowan] Well, don't tell our director, but there's quite a few of us here. It's Halloween! We can't miss a chance to dress up!
When was the last time we hung out...? Oh well don't let me keep you, we can reminisce later, go find Nora and Sam!
-> END

