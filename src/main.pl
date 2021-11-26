:- include('map.pl').
:- include('character.pl').
:- include('leveling.pl').
:- include('marketplace.pl').
:- include('inventory.pl').

startGame :-    write('  _    _                           _      _____ _                    '),nl,
                write(' | |  | |                         | |    / ____| |                                '),nl,
                write(' | |__| | __ _ _ ____   _____  ___| |_  | (___ | |_ __ _ _ __                     '),nl,
                write(' |  __  |/ _\` | \'__\\ \\ / / _ \\/ __| __|  \\___ \\| __/ _\` | \'__|                    '),nl,
                write(' | |  | | (_| | |   \\ V /  __/\\__ \\ |_   ____) | || (_| | |                       '),nl,
                write(' |_|  |_|\\__,_|_|    \\_/ \\___||___/\\__| |_____/ \\__\\__,_|_|                       '),nl,nl,
                write('Harvest Star!!!'),initMap, nl,
                write('Lets play and pay our debts together!'), nl,
                write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'), nl,
                write('%                          ~Harvest Star~                          %'), nl,
                write('% 1. start       : to start your journey                                 %'), nl,
                write('% 2. map         : to shows map                                            %'), nl,
                write('% 3. status      : to show your current status                          %'), nl,
                write('% 4. inventory   : to show your inventory                            %'), nl,
                write('% 4. w : move 1 step to north                                      %'), nl,
                write('% 5. s : move 1 step to south                                      %'), nl,
                write('% 6. d : move 1 step to east                                       %'), nl,
                write('% 7. a : move 1 step to west                                       %'), nl,
                write('% 8. help : to show commands you can use                           %'), nl,
                write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'), nl,
                start.

:-dynamic(uname/1).
start :-    write('Welcome to Harvest Star. Whats your name?'), nl, read(Username), nl, asserta(uname(Username)),
            write('Hello, '), write(Username), write(', choose your job now!'), nl,
            write('1. Fisherman'), nl,
            write('2. Farmer'), nl,
            write('3. Rancher'), nl,
            read_integer(JobChoice),
            (JobChoice=1 -> write('You choose Fisherman, lets start fishing'), createFisherman(Username);
            JobChoice=2 -> write('You choose Farmer, lets start farming'), createFarmer(Username);
            JobChoice=3 -> write('You choose Rancher, lets start ranching'), createRancher(Username)).

status :-   uname(Username),
            checkStatus(Username).

inventory :- display_inventory.

map :-  (write('Where is my map?, ooh i found it. Open the map.'), nl, nl,
        write('  _____ _   _ _____  __     _____ _     _        _    ____ _____ '),nl,
        write(' |_   _| | | | ____| \\ \\   / /_ _| |   | |      / \\  / ___| ____ '),nl,
        write('   | | | |_| |  _|    \\ \\ / / | || |   | |     / _ \\| |  _|  _|  '),nl,
        write('   | | |  _  | |___    \\ \\V /  | || |___| |___ / ___ \\ |_| | |___ '),nl,
        write('   |_| |_| |_|_____|    \\_/  |___|_____|_____/_/   \\_\\____|_____|'),nl,nl,
        showMap,
        write('----------------------------------------------------------------------'), nl,
        write('%                   ~Legends of Harvest Star~                        %'), nl,
        write('% P : Your Current Position %'), nl,
        write('% Q : The Quest. Help your uncle to beat the quest. %'), nl,
        write('% M : Marketplace. You can buy item there. %'), nl,
        write('% H : House. You can sleep there. %'), nl,
        write('% o : Lakeside. You can fish from there. %'), nl,
        write('% = : Watch out for digging. %'), nl,
        write('% R : Ranch. Let`s see your cattle. %'), nl,
        write('% A : Alchemist. This is a secret shop, do not tell anyone. %'), nl,
        write('----------------------------------------------------------------------'), nl, !).

        



quit :- write('You quit the game!'),
        retractall(gold(_,_)), retractall(time(_,_)), retractall(overallExp(_,_)), retractall(fishingExp(_,_)), retractall(gold(_,_)),
        retractall(overallLevel(_,_)), retractall(fishingLevel(_,_)), retractall(farmingLevel(_,_)), retractall(ranchingLevel(_,_)),
        retractall(targetOverallExp(_,_)), retractall(targetFishingExp(_,_)), retractall(targetFarmingExp(_,_)), retractall(targetRanchingExp(_,_)),
        retractall(currStamina(_,_)), retractall(maxStamina(_,_)), retractall(isTaken(_,_)), retractall(time(_,_)), retractall(plant(_,_)),
        retractall(used_space(_)), retractall(stored_item(_,_)),retractall(tool_level(_,_)), retractall(uname(_)).     

help :- write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'), nl,
        write('%                                    ~HELP~                                    %'), nl,
        write('% 1. start : untuk memulai petualanganmu                                       %'), nl,
        write('% 2. map : menampilkan peta                                                    %'), nl,
        write('% 3. status : menampilkan kondisimu terkini                                    %'), nl,
        write('% 4. w : gerak ke utara 1 langkah                                              %'), nl,
        write('% 5. s : gerak ke selatan 1 langkah                                            %'), nl,
        write('% 6. d : gerak ke ke timur 1 langkah                                           %'), nl,
        write('% 7. a : gerak ke barat 1 langkah                                              %'), nl,
        write('% 8. help : menampilkan segala bantuan                                         %'), nl,
        write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%').

checkGoalState(X) :-    gold(X, CurrGold),
                        (CurrGold >= 20000 -> goalState, quit).

checkFailState(X) :-    time(X, Time),
                        (Time is 365 -> failState, quit).

failState :-    write('You have worked hard, but in the end result is all that matters.'), nl,
                write('May God bless you in the future with kind people!').

goalState :-    write('Congratulations! You have finally collected 20000 golds!'), nl.