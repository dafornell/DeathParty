VAR DJ_announcement = false
VAR beerpong = false
->OliviaKitchenBeerPongCrowd

==OliviaKitchenBeerPongCrowd==

[Olivia] Wow, huge crowd for beer pong.
[NPC1] What are we playing for?
[NPC2] Sweet, sweet victory, duh.
[NPC3] And seven minutes in heaven with DIE dreamboat Caleb!
[Olivia] Huh... maybe he'd actually talk to me if we had to be in the same room together.

{DJ_announcement:
[FratBroNPC] What's up, you lovely fuckers! DIE's Beerpong for Bills competition is about to get started! If you're looking to play, you gotta pay!

-else:
[FratBroNPC] If you're looking to compete, we're gonna be getting started in just a little bit. 
Don't forget, it costs $5 to play and DIE takes NO IOU's! It's for charity y'all, pay up!
}
Ready to cough up five bucks?
*[Yes] 
~beerpong = true
->END

*[No] 
~beerpong = false
->END
    
