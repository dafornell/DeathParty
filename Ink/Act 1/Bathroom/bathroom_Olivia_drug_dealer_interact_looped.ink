VAR has_wallet = true
VAR met_drugdealer = false

[Olivia]Uh, hey?
[Drug Dealer]Hey.
~met_drugdealer = true
->drug_dealer_bathroom

=drug_dealer_bathroom
    +[Is that a...bong on your face?]
        [Olivia]Is that a...bong on your face?
        [Drug Dealer]It's a gas mask. I'm a soldier from World War II.
        [Olivia]And the Hawaiian shirt is part of it?
        [Drug Dealer]Pearl Harbor.
        [Olivia]Right...
        ->drug_dealer_bathroom
        
    +[What's with the hot dog cart?]
        [Olivia]What's with the hot dog cart?
        [Drug Dealer]It's more convenient than a backpack. Lots of room for storage.
        [Olivia]And you're storing what exactly?
        [Drug Dealer]Guess. If you get it right, I'll let you try it.
        
        ++[Drugs? Like party drugs?]
            [Olivia]Drugs? Like party drugs?
            [Drug Dealer]No shit, they're all party drugs! Not good enough.
            I guess you can look as long as you want--but no touching.
            [Olivia]I wasn't gonna. Just curious.
            ->drug_dealer_loop
            
        ++[Hot dogs? I'm not really a party person]
            [Olivia]Hot dogs? In case it wasn't obvious, I'm not really a party person.
            [Drug Dealer]It was obvious. You look like you could use a downer, you're all...twitchy.
            I've got a few different thinks you could try if you've got cash.
            [Olivia]I'm good, thanks.
            [Drug Dealer]Suit yourself.
            ->drug_dealer_loop
            
    * {has_wallet} [I found a wallet outside...]
        [Olivia]I found a wallet outside. Do you know someone named Jack?
        [Drug Dealer]He's the shirtless dude—mega ripped—wearing the Finley the Phoenix mascot helmet.
        Can't miss him, even if you're wasted.
        [Olivia]Okay. Thanks.
        [Drug Dealer]You know...if you give it to me, I can give you a sample. On the house.
        [Olivia]Of what?
        [Drug Dealer]Can't tell you, it'll ruin the fun.
        
            ++ [This better not be a set-up]
            /remove_item Wallet
            /complete_task FindJack
            ~has_wallet = false
            
            [Olivia]Here. You better not be setting me up.
            [Drug Dealer]I never do. It's not good for business.
            If you need anything else—or need more, feel free to drop by.
            ->drug_dealer_loop
            
            ++[I'm keeping it]
            [Olivia]I'm keeping it.
            [Drug Dealer]Whatever you say, sunshine.
            ->drug_dealer_loop
     
    
    +{drug_dealer_loop} [That's enough.] ->end_drug_dealer_convo
        
        -(drug_dealer_loop)
            {->drug_dealer_bathroom | ->drug_dealer_bathroom}
        
         =end_drug_dealer_convo
         [Olivia]Alright, I gotta go.
         
         
         -> END
