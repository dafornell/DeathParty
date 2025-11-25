VAR met_caleb = false

//Olivia gets close-

[Nora] Is that you…Olivia? OLIVIA HERRERA?!

//Olivia walks over to where Sam and Nora are-

*[Hey Nora, hey Sam. Umm...what's up?]
    -> whatsup
*[It is me. At a frat party.] 
In a gigantic mansion.
->itsme

==whatsup==
[Sam] ...
[Nora] What's up? What's. Up. That...that’s all you have to say?  We–I...I didn't think I’d get to see you again. Ever.
Where've you been?
[Olivia] Right. Yeah...It's been awhile, huh?
->schoolworkorstruggle

==itsme==
[Sam] ...
[Nora] I just...I can't believe you're here. I know parties aren’t really your vibe...
Anyway, since you <i>are</i> here, catch me up! How've you been?
->schoolworkorstruggle

==schoolworkorstruggle==

*[Suffocating from schoolwork]
I’ve been suffocating under a neverending pile of schoolwork.
->schoolwork
*Honestly...It's been a struggle. 
->struggle

==schoolwork==
[Sam] Uh huh. Did that pile crush your fingers or something? Or you just can’t be bothered to text us back? 
You take that shit way too seriously.
[Nora] Not all of us are badass like you, Sam. Some of us still care about getting good grades...sometimes that means you put away your distractions. Like your phone.
[Sam] Grades? You don’t need ‘em to do what you wanna do. Just get off your ass and do it.
[Nora] They can help, I mean...there’s nothing like an A+ after an all-nighter, right, Liv?”

*[Yeah.] 
Grades reward all the blood, sweat, and tears I’ve poured into my work. 
And the sleep deprivation. Can’t forget that.
	[Sam] Nerds.
	[Nora] Ahem, proud nerds.
	We’ll bleed, sweat, and cry together, Liv...like we said we would. All the way to graduation!
	->noraorsam
	
*[Grades can be overrated.]
Still...I’m not trying to tank my GPA. 
	[Sam] Uh huh.
	[Nora] Same. I’m gonna keep mine above 3.5. At least. 
	->noraorsam

==struggle==
[Nora] I’ve been really worried about you. You barely texted me back. 
[Olivia] It’s just been—
[Nora] I know that it’s hard to, sometimes. Trust me, I do.
[Olivia] It <i>is</i> hard. With classes and homework and...I can’t sleep through the night so I’m tired all the time. I’m a mess.
[Nora] I miss you, Liv. These past few years, I really needed you and I don't even know how to reach you. It feels like you completely shut me out. 
[Sam] Boo fuckin’ hoo. You’re not the only one struggling.

*[I’m so sorry, guys.] 
It’s not an excuse but...I changed—everything changed. After Kyle.
[Nora] I know you guys were really close but…I’m still here. I wanna be here for you. 
But I can’t do that if you disappear off the face of the Earth. I don’t wanna lose you, too…
[Sam] Everything did change. You stopped giving a single shit about us.
->noraorsam

*[I've been caught up in other things.]
Look, I’ve been caught up with other things, okay? So a few texts slipped my mind. It happens.
[Sam] Wow. Great apology.  
[Nora] It wasn’t just a few texts. And it’s not just about the texting, Liv, it’s about—I...actually, forget it. I don’t want to talk about this right now.
->noraorsam

==noraorsam==
*[Uh...Nora.]
How's it feel being back on campus?
->backoncampus
*[So...Sam.]
I heard you got suspended? 
->samsuspended

==backoncampus==
[Nora] It’s been an adjustment, I guess. SVU has a billion stairs—and only one elevator. One.

*[What? That’s gotta be an ADA violation.]
	[Nora] It probably is.
	->aboutcaleb
	
*[Your cane is on point, though.]
	[Nora] Thanks, Liv. Not even a <i>trillion</i> stairs can stop me from coordinating my colors.
	->aboutcaleb

==samsuspended==
[Sam] Now you’re pretending to care?
[Nora] Don't mind him, he's just uh... focused on doing good work.

*[You got really good, Sam.] 
Your tats are sick.
[Sam] ...thanks. Been inkin’ anyone who’ll let me.
    ->aboutcaleb
    
*[I do care.] 
I was freaked out about you getting kicked out—forever. I’m seriously so relieved they let you back in!
[Sam] I’ve been back. You would know, if you were around.
	->aboutcaleb

==aboutcaleb==
//If you have met Caleb
{met_caleb:
[Olivia] ...So...I saw Caleb.
[Nora] ...And?

*[I tried to ask him about Kyle.]
->triedtoask
*[And...nothing.]
I mean, is it weird seeing him? ->isitweird
}
//If haven't interacted with Caleb yet
{not met_caleb:
[Olivia] Umm...Do you guys know where Caleb is?
[Nora] Caleb?......Why?

*[I need to ask him about Kyle.]
->aboutkyle
*[Uh...I want to say hi.]
->sayhi
}

==aboutkyle==
[Sam] Classic Liv. Won’t shut up about Kyle, who’s been gone for two fucking years! 
Even when your friends—the ones you been ghosting—are right in front of your face.
[Nora] I think what Sam is trying to say is...you just got here. A minute ago. Can’t you ask him that later? 
I wanna chat about what you’ve been up to. Like...what’s your favorite class this semester?
[Sam] Nah, I said what I said. 

*[Advanced Composition with Professor Henley.]
	[Nora] Oh my god, are you okay? I heard Henley is a total tyrant. 

*[I don’t think I have one.] 
	[Nora] That’s a bummer. I hope it hasn’t been too much of a slog.

-
*[What about you?] 
What’s your favorite class?
	[Nora] Fashion History! My last humanities elective. 
	It’s amazing, I’ve been learning so much cool stuff about fabrics, patterns, and trends.

*[I’m managing...somehow.]
How are your classes going?
	[Nora] I have three 9ams in a row this semester. I know–it’s rough, but it's also nice to start the day early. 
    I got way too used to sleeping in when I was home.

-
*[I need to find Caleb, Nora.] 
He was the last one who saw Kyle.
->obsessedwithkyle

*[Nora...can you just tell me where Caleb is?] 
->obsessedwithkyle

==sayhi==
[Sam] Hmm.
[Nora] I think I saw him in the kitchen, maybe? I don’t know if he’s still there. 
Are you gonna go look for him? Now?

*[He was the last person to see Kyle]
-> aboutkyle

*[That’s why I’m here, Nora.] 
To find out more about Kyle. 
->aboutkyle



==triedtoask==
[Sam] Big surprise.
[Nora] Liv...I can't even remember the last time we were all together. Can we talk about something else...before you bring up Kyle? 
Have you had the time to take photos? Not just for classes?

*[All the time.] 
	[Nora] I love it. The random photos you take are some of my faves!
*[Not much lately...]
	[Nora] Oh...I hope you’re able to find some time soon.

-
*[Yeah, thanks, Nora...]
I’m gonna find Caleb again. There’s gotta be something he knows about Kyle.
->obsessedwithkyle

*[It's not the same without Kyle...]
Hyping up every pic—even the blurriest takes. I—I gotta talk to Caleb. 
->obsessedwithkyle



==isitweird==
[Nora] Sort of...well, not really, I guess. I...I still care about him.
[Sam] It’s been a little weird, but they’ll get over it. 

*[I get it.]
Just ‘cause things end doesn’t mean you suddenly stop caring.
	[Nora] No...I don’t think I could stop, even if I tried.
	[Sam] Love. Shit fucks you up. 

*[Caleb's a good guy.]
Even though things didn’t work out. 
    [Nora] Yeah...he is. 

-
*[Do you think he’ll talk to me about Kyle?]
->obsessedwithkyle

*[I need to find him again.] 
He knows something about Kyle.
->obsessedwithkyle


==obsessedwithkyle==
[Sam] Fuck the rest of us, huh? The police closed the case years ago. Obsessing about Kyle and abandoning your friends won’t bring him back.
[Nora] Liv...I know you’re hurting. We all are. Kyle was our friend, not just yours. 
Can we try to enjoy each other and have fun? While we can? Please.

*[I won’t give up.] 
Just because everybody else has.
*[You’ve all forgotten about him.]
I can’t.
-
//Cutscene
[Sam] Fuck. You.
[Nora] I…I can’t believe you said that.
//Enter Rowan
[Rowan] Hey guys! Why look, it’s the faithful gang—reunited, once again!
[Sam] You’re a selfish bitch, Olivia. Your head is stuck so far up your Kyle-obsessed ass, I don’t even know how you got here.
[Rowan] Whoa! Wha? Guys...what happened?
[Olivia] Oh, <i>I’m</i> selfish? Selfish for what? Caring about Kyle? 
I’m sorry I’m not like you, I can’t just move on from Kyle like…like he went on fucking vacation or something. 
He DISAPPEARED! That doesn’t just happen, okay? 
Don’t you want to know the truth?
[Nora] Of course we do! But—
[Rowan] Guys! Now is not the time! 
[Sam] Here’s the truth. You’re a cun—
[Rowan] STOP IT! RIGHT FUCKING NOW!!!
[Sam] …Damn, Rowan.
[Nora] Rowan...
[Olivia] I–
[Rowan] HELLO?! Look around, it’s my final year and we’re all in one room, at a frat party!
You know what that means? Shaking what our mommas’ gave us, not tearing each others’ throats apart.
[Nora] Sorry, Rowan.
[Sam] Whatever.
[Olivia] Fine.
[Rowan] Channel all that rage into dancing and we’ll bring the house down! Come with me.

-> END

