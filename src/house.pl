/* house.pl */

:- dynamic (time/2).
addTime(X, Add) :-  time(X, PrevTime), retract(time(X, PrevTime)),
                    NewTime is PrevTime + Add, asserta(time(X, NewTime)),
                    write('changing day'), nl,
                    checkFailState(X).
                
:- dynamic (currStamina/2).
updateStamina(X) :- maxStamina(X, PrevMax), retract(currStamina(X, PrevStamina)),
                    NewStamina is PrevMax, asserta(currStamina(X, NewStamina)),
                    write('charging my energy'), nl.



visitHouse :-   write('you are finally home'), nl,

                write('        @ @ @ '),nl,
                write('       []___                '), nl,
                write('      /    /\\____                '),nl,
                write(' 00  /_/\\_//____/\\'), nl,
                write(' |   | || |||__|||                '), nl,

                write('what do you want to do?'), nl,
                write('- [1]. sleep'), nl, 
                write('- [2]. writeDiary'), nl,
                write('- [3]. readDiary'), nl,
                write('- [4]. exit'), nl,
                write('Pick a number: '), read_integer(HouseChoice), nl,

                (HouseChoice = 1 -> 
                    write('Good Night'), nl,
                    addTime(Username, 1),
                    updateStamina(Username), nl,
                    random(1, 10, X),
                    (X =< 5 -> periTidur;
                    X =< 10 -> visitHouse),
                HouseChoice = 2 ->
                    write('writing diary'), nl;
                HouseChoice = 3 ->
                    write('reading diary'), nl;
                HouseChoice = 4 ->
                write('already want to go again? ok good luck'),nl).