:-dynamic(increaseStamina/1).
:-dynamic(increaseProbability/1).
increaseStamina([amortentia, haliwinkles,polypody]).
increaseProbability([ptolemy,thaumatagoria,staghorn]).

:-dynamic(probabilityPotionState/2).
probabilityPotionState(_, notHave).
:-dynamic(staminaPotionState/2).
staminaPotionState(_, notHave).
buy_alchemist(X) :- displayAlchemist,
                    read(Opt),
                    (Opt =1 -> buyStamina(X);
                    Opt=2 -> buyProbability(X);
                    Opt=0 -> write('Okay, looks like you have other interests.');
                    write('Oops! There are only 2 options')).

buyProbability(X) :-    gold(X, Gold), increaseProbability(Items),
                        itemCount(Items, Count),
                        (Count is 0 -> write('You can\'t buy potion to increase fishing probability anymore!');
                        (Gold >=1000 ->
                        removeItem(Items, H, TAIL), retract(increaseProbability(Items)), asserta(increaseProbability(TAIL)),
                        retract(probabilityPotionState(X, _)), asserta(probabilityPotionState(X, H)),
                        write('You buy a '), write(H), write(' potion to increase fishing probability!'), nl,
                        write('To use this potion, you can use "usePotion" command!'),
                        retract(gold(X, Gold)), NewGold is Gold-1000, asserta(gold(X, NewGold));
                        write('Oops! You don\'t have enough gold to buy a potion to increase fishing probability!'))).

buyStamina(X) :-    gold(X, Gold), increaseStamina(Items),
                    itemCount(Items, Count),
                    (Count is 0 -> write('You can\'t buy potion to reset your current stamina anymore!');
                    (Gold >=2000 ->
                    removeItem(Items, H, TAIL), retract(increaseStamina(Items)), asserta(increaseStamina(TAIL)),
                    retract(staminaPotionState(X, _)), asserta(staminaPotionState(X, H)),
                    write('You buy a '), write(H), write(' potion to increase your stamina!!'), nl,
                    write('To use this potion, you can use "usePotion" command!'),
                    retract(gold(X, Gold)), NewGold is Gold-2000, asserta(gold(X, NewGold));
                    write('Oops! You don\'t have enough gold to buy a potion to increase your stamina!'))).

usePotion(X) :- staminaPotionState(X, SPState), probabilityPotionState(X, PPState),
                (((SPState=notHave, PPState=notHave);(SPState=used, PPState=used);(SPState=used, PPState=notHave);(SPState=notHave, PPState=used)) -> write('You don\'t have any potion to use!');
                    (
                        (
                            ((SPState=notHave;SPState=used),(\+ (PPState=used;PPState=notHave))) -> write('[0] Back'), nl, write('[1] -'), nl, write('[2] '), write(PPState), nl;
                            ((PPState=notHave;PPState=used),(\+ (SPState=used;SPState=notHave))) -> write('[0] Back'), nl, write('[1] '), write(SPState), nl, write('[2] -'),nl;
                            write('[0] Back'), nl, write('[1] '), write(SPState),nl, write('[2] '), write(PPState),nl
                        ),
                        write('Which potion do you want to use?'),nl,
                        read(Opt),
                        (Opt=1 -> useStaminaPotion(X);
                        Opt=2 -> useProbabilityPotion(X);
                        Opt=0 -> write('Looks like you still not want to use the potion');
                        write('Oops! There are only 2 options'))
                    )
                ).

:- dynamic(dayUsed/2).
dayUsed(_,0).

useStaminaPotion(X) :- staminaPotionState(X, SPState),
                        maxStamina(X, CurrStamina),
                        dayUsed(X,DayUsed),
                        (SPState=notHave -> write('You don\'t have any stamina potion!'),nl;
                        SPState=used -> (
                            (DayUsed=5 -> retract(maxStamina(X, CurrStamina)), New is CurrStamina-5, asserta(maxStamina(X, New)),
                                retract(staminaPotionState(X, SPState)), asserta(staminaPotionState(X, notHave)),
                                retract(dayUsed(X,5)), asserta(dayUsed(X,0));
                            retract(dayUsed(X, DayUsed)), NewDay is DayUsed+1, asserta(dayUsed(X,NewDay))));
                        write('Your stamina will be increased by 5 for 5 days!'),
                        retract(staminaPotionState(X, SPState)),
                        asserta(staminaPotionState(X, used)),
                        retract(dayUsed(X,DayUsed)),
                        asserta(dayUsed(X,1)),
                        retract(maxStamina(X, CurrMaxStamina)), NewMax is CurrMaxStamina+5,
                        asserta(maxStamina(X, NewMax)),
                        retract(currStamina(X, CurrStamina)), New is CurrStamina+5,
                        asserta(currStamina(X, New))).

useProbabilityPotion(X) :- 
            probabilityPotionState(X, PBState), 
            (PBState = notHave -> 
                write('You don\'t have any stamina potion!'),nl
            ;
                retract(probabilityPotionState(X, PBState)),
                asserta(probabilityPotionState(X, used)),
                write('Your chance to get rare fish are increased for one time, go fish right now!'),nl
            ).


itemCount([], X):- X is 0.
itemCount([_|TAIL], Count) :-   itemCount(TAIL, Prev),
                                Count is Prev + 1.

removeItem([H|TAIL], H, TAIL).

displayAlchemist :-

    write('          .'),nl,
    write('        (\'        '),nl,
    write('        \'|        '),nl,
    write('        |\'        '),nl,
    write('       [::]        '),nl,
    write('       [::]   _......_        '),nl,
    write('       [::].-\'      _.-`.'),nl,
    write('       [:.\'    .-. \'-._.-`.'),nl,
    write('       [/ /\\   |  \\        `-..'),nl,    
    write('       / / |   `-.\'      .-.   `-.'),nl,
    write('      /  `-\'            (   `.    `.'),nl,
    write('     |           /\\      `-._/      \\        '),nl,
    write('     \'    .\'\\   /  `.           _.-\'|        '),nl,    
    write('    /    /  /   \\_.-\'        _.\':;:/        '),nl,
    write('  .\'     \\_/             _.-\':;_.-\'        '),nl,
    write(' /   .-.             _.-\' \\;.-\'        '),nl,
    write('/   (   \\       _..-\'     |        '),nl,
    write('\\    `._/  _..-\'    .--.  |        '),nl,
    write(' `-.....-\'/  _ _  .\'    \'.|        '),nl,
    write('          | |_|_| |      | \\  (o)    '),nl,
    write('     (o)  | |_|_| |      | | (\\\'/)    '),nl,
    write('    (\\\'/)/  \'\'\'\'\' |     o|  \\;:;    '),nl,
    write('     :;  |        |      |  |/)    '),nl,
    write('      ;: `-.._    /__..--\'\\.\' ;:        '),nl,
    write('          :;  `--\' :;   :;        '),nl,
    write('|------------------------------------------|'), nl,
    write('|            Hi, I\'m Alchemist             |'), nl,
    write('|------------------------------------------|'), nl,
    nl,
    write('Which potion do you want to buy from me?'), nl,
    write('[0] Back'), nl,
    write('[1] Increase stamina                 | 2000   gold'), nl,
    write('[2] Increase fishing probability     | 1000   gold'), nl.
