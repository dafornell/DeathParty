VAR has_freya = false
VAR has_athena = false
VAR has_lakshmi = false
VAR has_flamedrop = false

->OliviaBartenderKitchen
==OliviaBartenderKitchen==

[Bartender] What are you feeling? We've got specialty drinks: Freya, Athena, Lakshmi...if any of that sounds good, let me know!
*[Freya sounds interesting.] -> freya
*[How about an Athena?] -> athena
*[Maybe a Lakshmi?] -> lakshmi
*[Are those drinks?] -> ask_drinks

===freya===
[Bartender] One glass of battle and beauty, coming right up. 
/give_item freya
-> END

===athena===
[Bartender] Wise choice. Heh.
/give_item athena
-> END

===lakshmi===
[Bartender] Ooh, my favorite. I'll drink to that choice. 
/give_item lakshmi
-> END

===ask_drinks===
[Bartender] Goddesses, actually... But yeah, tonight they're drinks.

* [Cool. Thanks.] -> END
* [Sick costume. Are you a cheetah?] -> ask_costume

===ask_costume===
[Bartender] I'm Seshat, the Egyptian Goddess. She was a scribe who dressed in leopard skin and invented writing.
[Olivia] Oh wow, cool.
[Bartender] Yeah, I know. It's a lot, haha. I'm a classics major, so legit, I'm all about the different gods and goddesses. That's my whole jam. 
Here's a Flame Drop, for letting me blab. A little heat to get the party going! 
/give_item "flame drop"
    -> END
