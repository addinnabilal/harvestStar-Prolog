:- include('map.pl').
:- include('character.pl').
:- include('leveling.pl').
:- include('marketplace.pl').
:- include('inventory.pl').
:- include('alchemist.pl').
:- include('house.pl').
:- include('quest.pl').
:- include('activity.pl').

:-dynamic(uname/1).
:-dynamic(gameState/1).
gameState(notplaying).

startGame :-    gameState(State),
                (State=playing -> write('You still in a game! If you want to start the game again, please quit this game first.');
                nl,
                write('.'), nl,
                write('.'), nl,
                write('.'), nl,
                story,
                write('.'), nl,
                write('.'), nl,
                write('.'), nl,
                nl,
                write('  _    _                           _      _____ _                       '),nl,
                write(' | |  | |                         | |    / ____| |                      '),nl,
                write(' | |__| | __ _ _ ____   _____  ___| |_  | (___ | |_ __ _ _ __           '),nl,
                write(' |  __  |/ _\` | \'__\\ \\ / / _ \\/ __| __|  \\___ \\| __/ _\` | \'__| '),nl,
                write(' | |  | | (_| | |   \\ V /  __/\\__ \\ |_   ____) | || (_| | |          '),nl,
                write(' |_|  |_|\\__,_|_|    \\_/ \\___||___/\\__| |_____/ \\__\\__,_|_|       '),nl,
                nl,
                write('             Lets play and pay our debts together!                '), nl, 
                nl,
                help,
                nl,
                initMap, start).


start :-    gameState(State),
            (State=playing -> write('You still in a game! If you want to start the game again, please quit this game first.');
            retract(gameState(State)), asserta(gameState(playing)),
            write('Welcome to Harvest Star. What\'s your name? '), read(Username), nl, asserta(uname(Username)),
            write('Hello, '), write(Username), write(', please choose a job to help you pay your debt.'), nl,
            write('[1] Fisherman'), nl,
            write('[2] Farmer'), nl,
            write('[3] Rancher'), nl,
            nl,
            write('Pick an option: '), read(JobChoice),
            (JobChoice = 1 -> 
                write('You choose to become a \'Fisherman\'!'), 
                createFisherman(Username),
                write('Fishing will be the most profitable activity for you. May your debt be paid off!'), nl
            ; JobChoice = 2 -> 
                write('You choose to become a \'Farmer\'!'), 
                createFarmer(Username),
                write('Farming will be the most profitable activity for you. May your debt be paid off!'), nl
            ; JobChoice=3 -> write('You choose to become a \'Rancher\'!'), 
                createRancher(Username),
                write('Ranching will be the most profitable activity for you. May your debt be paid off!'), nl
            )
            ).

status :-   uname(Username),
            checkStatus(Username).

inventory :- display_inventory.

throw :- throw_item.

quest :- quest_message.

map :-  (write('Where is my map?, ooh i found it. Open the map.'), nl, nl,
        write('  _____ _   _ _____  __     _____ _     _        _    ____ _____ '),nl,
        write(' |_   _| | | | ____| \\ \\   / /_ _| |   | |      / \\  / ___| ____ '),nl,
        write('   | | | |_| |  _|    \\ \\ / / | || |   | |     / _ \\| |  _|  _|  '),nl,
        write('   | | |  _  | |___    \\ \\V /  | || |___| |___ / ___ \\ |_| | |___ '),nl,
        write('   |_| |_| |_|_____|    \\_/  |___|_____|_____/_/   \\_\\____|_____|'),nl,nl,
        showMap,
        write('----------------------------------------------------------------------'), nl,
        write('%                     ~ Legends of Harvest Star ~                    %'), nl,
        write('%                                                                    %'), nl,
        write('% P : Your Current Position                                          %'), nl,
        write('% Q : The Quest. Help your uncle to beat the quest.                  %'), nl,
        write('% M : Marketplace. You can buy item there.                           %'), nl,
        write('% H : House. You can sleep there.                                    %'), nl,
        write('% o : Lakeside. You can fish from there.                             %'), nl,
        write('% = : Watch out for digging.                                         %'), nl,
        write('% R : Ranch. Let`s see your cattle.                                  %'), nl,
        write('% A : Alchemist. This is a secret shop, do not tell anyone.          %'), nl,
        write('----------------------------------------------------------------------'), nl, !).


quit :- write('You quit the game!'),
        retractall(gameState(_)),
        asserta(gameState(notplaying)),
        retractall(gold(_,_)), 
        retractall(time(_,_)), 
        retractall(overallExp(_,_)), 
        retractall(fishingExp(_,_)), 
        retractall(gold(_,_)),
        retractall(overallLevel(_,_)), 
        retractall(fishingLevel(_,_)), 
        retractall(farmingLevel(_,_)), 
        retractall(ranchingLevel(_,_)),
        retractall(targetOverallExp(_,_)), 
        retractall(targetFishingExp(_,_)), 
        retractall(targetFarmingExp(_,_)), 
        retractall(targetRanchingExp(_,_)),
        retractall(currStamina(_,_)), 
        retractall(maxStamina(_,_)), 
        retractall(isTaken(_,_)),  
        retractall(plant(_,_)),
        retractall(used_space(_)), 
        retractall(stored_item(_,_)),
        retractall(tool_level(_,_)), 
        retractall(uname(_)), 
        retractall(increaseProbability(_)),
        retractall(increaseStamina(_)), 
        retractall(staminaPotionState(_,_)), 
        retractall(probabilityPotionState(_,_)), 
        retractall(dayUsed(_,_)),
        retractall(player(_,_)),
        retractall(digged(_,_)),
        asserta(increaseStamina([amortentia, haliwinkles,polypody])),
        asserta(increaseProbability([ptolemy,thaumatagoria,staghorn])),
        asserta(probabilityPotionState(_, notHave)),
        asserta(staminaPotionState(_, notHave)).     

help :- 
    write('% 1.  map         : to shows map                                   %'), nl,
    write('% 2.  status      : to show your current status                    %'), nl,
    write('% 3.  inventory   : to show your inventory                         %'), nl,
    write('% 4.  quest       : to show your current active quest              %'), nl,
    write('% 5.  throw       : to throw an item                               %'), nl,
    write('% 6.  w           : move 1 step to north                           %'), nl,
    write('% 7.  s           : move 1 step to south                           %'), nl,
    write('% 8.  d           : move 1 step to east                            %'), nl,
    write('% 9.  a           : move 1 step to west                            %'), nl,
    write('% 10. help        : to show commands list                          %'), nl,
    write('% 11. story       : to show your background story and objective    %'), nl,
    write('% 12. usePotion   : to use your potion                             %'), nl,
    write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'), nl.

story :-
    write('You are a businessman who has just been scammed by a client who has'), nl,
    write('just magically disappeared without paying for a project you worked so'), nl,
    write('hard to build. In addition to being a victim of fraud, you are also'), nl,
    write('in debt of 20000 golds that needs to be repaid within 1 year. Therefore,'), nl,
    write('you decide to return to your hometown and continue your grandfather\'s'), nl,
    write('farming business to be able to continue living and pay off your debts.'), nl.

usePotion :- uname(Username), usePotion(Username).

alchemist :- uname(Username), buy_alchemist(Username).

failState :-    write('__  __               __                    __    '),nl,
                write('\\ \\/ /___  __  __   / /   ____  ________  / /                    '),nl,
                write(' \\  / __ \\/ / / /  / /   / __ \\/ ___/ _ \\/ /                     '),nl,
                write(' / / /_/ / /_/ /  / /___/ /_/ (__  )  __/_/                  '),nl,
                write('/_/\\____/\\__,_/  /_____/\\____/____/\\___(_)                   '),nl,
                write('You have worked hard, but in the end result is all that matters.'), nl,
                write('May God bless you in the future with kind people!').

goalState :-    write('__  __               _       ___       __    '),nl,
                write('\\ \\/ /___  __  __   | |     / (_)___  / /                '),nl,
                write(' \\  / __ / / / /   | | /| / / / __ \\/ /                     '),nl,
                write(' / / /_/ / /_/ /    | |/ |/ / / / / /_/                      '),nl,
                write('/_/\\____/\\__,_/     |__/|__/_/_/ /_(_)                   '),nl,
                write('Congratulations! You have finally collected 20000 golds!'), nl.

