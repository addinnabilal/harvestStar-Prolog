addTime(X,Add) :-   time(X, PrevTime), retract(time(X, PrevTime)),
                    NewTime is PrevTime + Add, asserta(time(X, NewTime)),
                    write('changing day'), nl,
                    gameState(State),
                    staminaPotionState(X,SPState),
                    time(X, Time),
                    (Time>=365 -> failState, quit;
                    ((SPState=used ->useStaminaPotion(X), updateStamina(X));
                    updateStamina(X))).

updateStamina(X) :- maxStamina(X, PrevMax), currStamina(X, PrevStamina), retract(currStamina(X, PrevStamina)),
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
                    updateAnimalTime, updatePlant,
                    write('Good Night'), nl,
                    uname(Username),
                    addTime(Username, 1),
                    random(1, 10, X),
                    (X =< 5 -> periTidur;
                    X =< 10 -> visitHouse);
                HouseChoice = 2 ->
                    write('writing diary'), nl;
                HouseChoice = 3 ->
                    write('reading diary'), nl;
                HouseChoice = 4 ->
                write('already want to go again? ok good luck'),nl).

:- dynamic(diary/1).
save :- write('Mau nulis apa ngab'), nl, read(Diary), asserta(diary(Diary)),
        uname(Username), time(Username, Day), number_atom(Day, NewDay), 
        atom_concat('Day_',NewDay, NewFile),
        atom_concat('saves/', NewFile, NewFile2),
        tell(NewFile2),
            listing(diary/1),
            listing(gameState/1),
            listing(gold/2), 
            listing(time/2), 
            listing(overallExp/2), 
            listing(fishingExp/2), 
            listing(gold/2),
            listing(overallLevel/2), 
            listing(fishingLevel/2), 
            listing(farmingLevel/2), 
            listing(ranchingLevel/2),
            listing(targetOverallExp/2), 
            listing(targetFishingExp/2), 
            listing(targetFarmingExp/2), 
            listing(targetRanchingExp/2),
            listing(currStamina/2), 
            listing(maxStamina/2), 
            listing(isPlaced/2),  
            listing(plant/2),
            listing(used_space/1), 
            listing(stored_item/2),
            listing(tool_level/2), 
            listing(uname/1), 
            listing(increaseProbability/1),
            listing(increaseStamina/1), 
            listing(staminaPotionState/2), 
            listing(probabilityPotionState/2), 
            listing(dayUsed/2),
            listing(player/2),
            listing(digged/2),
        told,
        write('saving games'),nl, !.

load    :-  write('Your Diary: '), nl, 
            directory_files('./saves', Files),
            Files = [_, _|Files2],
            displayList(Files2, 1), nl, 
            write('masukkan nama file dengan aposthrope sebagai prefix dan postfix (ex: \'Day_0\'): '), nl,
            BaseDirectory = './saves/', 
            read(FileName),
            atom_concat(BaseDirectory, FileName, NewFileName),
            (\+file_exists(NewFileName) -> write('salah load.'), nl, fail;
            open(NewFileName, read, Stream), loadFile(Stream, Lines),
            loadList(Lines), close(Stream), 
            initMap,
            retractall(player(_,_)), asserta(player(X, Y)),
            write('-----------------------------loading-----------------------------'), nl,
            write('-----------------------------------------------------------------'), nl, nl,
            diary(Diary),
            write(Diary), nl), !.

loadFile(Str, []):- at_end_of_stream(Str).
loadFile(Str, [Val|List1]):-  \+at_end_of_stream(Str),
                                read(Str, Val),
                                loadFile(Str, List1), !.

loadList(List) :- (List = [] -> !;
                    List = [Val|List1] -> asserta(Val), loadList(List1), !).


displayList([], 1) :- write('None'),nl, !.
displayList(List, 1) :- nl, List = [Head|Tail],
    write('1. '), write(Head), nl, displayList(Tail, 2), !.
displayList(List, X) :-
    List = [Head|Tail],
    write(X), write('. '), write(Head), nl, X2 is X+1, displayList(Tail, X2), !;
    !.                