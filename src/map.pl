/*map.pl*/

/*createMap coordinate*/

showMap :- displayMap(0,16).

:- dynamic(coordinate/2).
createMap(X, Y) :- (X = 0, Y = 0 -> asserta(coordinate(0, 0));
                    X = 0 -> asserta(coordinate(0, Y)), NewY is Y-1, createMap(X, NewY);
                    Y = 0 -> asserta(coordinate(X,Y)), NewY = 16, NewX is X - 1, createMap(NewX, NewY);
                             asserta(coordinate(X, Y)), NewY is Y - 1, createMap(X, NewY)).

/*deklarasi isTaken*/
:- dynamic(isTaken/2).
taken(X, Y) :- isTaken(X, Y).
taken(X, Y) :- \+(isTaken(X,Y)), asserta(isTaken(X, Y)).


/*deklarasi wall */
wall(X, Y) :- Y =:= 16, coordinate(X, Y).
wall(X, Y) :- X =:= 0, coordinate(X, Y).
wall(X, Y) :- X =:= 16, coordinate(X, Y).
wall(X, Y) :- Y =:= 0, coordinate(X, Y).


/*deklarasi show map */
 displayMap(SX, SY) :-  (wall(SX, SY) -> write('#');
                        player(SX, SY) -> write('P');
                        marketplace(SX, SY) -> write('M');
                        quest(SX, SY) -> write('Q');
                        house(SX, SY) -> write('H');
                        ranch(SX, SY) -> write('R');
                        alchemist(SX, SY) -> write('A');
                        digged(SX, SY) -> write('=');
                        lake(SX, SY) -> write('~');
                        lakeSide(SX, SY) -> write('o');
                        write('-')), NewX is SX + 1,
                        (SX = 16, SY = 0 -> nl;
                        SX = 16 -> nl, X = 0, NewY is SY - 1, displayMap(X, NewY);
                        displayMap(NewX, SY)).



validMove(PrevX, PrevY, NewX, NewY) :- (marketplace(NewX, NewY) -> write('Welcome to the market, want to buy something?'),nl,nl, visit_marketplace;

                                        quest(NewX, NewY) -> write('uncle need your help!'), nl, nl, getQuest;

                                        ranch(NewX, NewY) -> write('uhuk, uhuk.. This ranch stinks'), nl, nl, visitRanch;

                                        alchemist(NewX, NewY) -> write('welcome to secret'), nl, nl, visitAlchemist;

                                        house(NewX, NewY) -> write('Mama, Papa, i\'m home'), nl, nl, visitHouse;

                                        wall(NewX, NewY), taken(NewX, NewY) ->
                                        retract(player(NewX, NewY)), asserta(player(PrevX, PrevY)),
                                        write('aaaa!!, I hit the wall. It hurts'), nl, !, fail;

                                        lake(NewX, NewY), taken(NewX, NewY) -> retract(player(NewX, NewY)), asserta(player(PrevX, PrevY)),
                                        write('This lake is too cold, I don\'t want to swim here'), nl, !, fail;
                                        
                                        digged(NewX, NewY) -> write('I like farming!!'), nl, nl, visitFarm;

                                        lakeSide(NewX, NewY) -> write('This is lakeside, you can fish from here'),nl,nl, fishing).

/*deklarasi move*/
:- dynamic(player/2).
w :-    retract(player(PrevX, PrevY)), 
        NewY is PrevY + 1, 
        asserta(player(PrevX, NewY)),
        write('what\'s up in the north, is it cold in the nort?'),  nl,
        validMove(PrevX, PrevY, PrevX, NewY).

a:-     retract(player(PrevX, PrevY)), 
        NewX is PrevX - 1, 
        asserta(player(NewX, PrevY)),
        write('what\'s up in the west, seems cool to cowboy'), nl,
        validMove(PrevX, PrevY, NewX, PrevY).

s :-    retract(player(PrevX, PrevY)), 
        NewY is PrevY - 1, 
        asserta(player(PrevX, NewY)),
        write('what\'s up in the south, can i find penguins in the south?'), nl,
        validMove(PrevX, PrevY, PrevX, NewY).

d:-     retract(player(PrevX, PrevY)), 
        NewX is PrevX + 1, 
        asserta(player(NewX, PrevY)),
        write('what\'s up in the east, i like asian culture'), nl,
        validMove(PrevX, PrevY, NewX, PrevY).

/*deklarasi init map*/
initMap :-  createMap(16, 16), 
        asserta(player(10, 8)), asserta(isTaken(10,8)),
        asserta(quest(6, 8)), asserta(isTaken(6, 8)),
        asserta(marketplace(6, 10)), asserta(isTaken(6, 10)),
        asserta(house(8, 8)), asserta(isTaken(8,8)),
        asserta(ranch(10, 10)), asserta(isTaken(10, 10)),
        asserta(alchemist(12, 1)), asserta(isTaken(12, 1)),
        asserta(digged(3, 3)), asserta(isTaken(3, 3)),
        asserta(lake(2,2)), asserta(isTaken(2, 2)),
        asserta(lake(1,3)), asserta(isTaken(1, 3)),
        asserta(lake(3,1)), asserta(isTaken(3, 1)),
        asserta(lake(5,3)), asserta(isTaken(5, 3)),
        asserta(lake(3,5)), asserta(isTaken(3, 5)),
        asserta(lake(4,4)), asserta(isTaken(4, 4)),
        asserta(lake(2,3)), asserta(isTaken(2, 3)),
        asserta(lake(2,4)), asserta(isTaken(2, 4)),
        asserta(lake(3,2)), asserta(isTaken(3, 2)),
        asserta(lake(3,4)), asserta(isTaken(3, 4)),
        asserta(lake(4,2)), asserta(isTaken(4, 2)),
        asserta(lake(4,3)), asserta(isTaken(4, 3)),
        asserta(lake(1,1)), asserta(isTaken(1, 1)),
        asserta(lake(2,1)), asserta(isTaken(2, 1)),
        asserta(lake(1,2)), asserta(isTaken(1, 2)),
        asserta(lakeSide(4,1)), asserta(isTaken(4, 1)),
        asserta(lakeSide(5,2)), asserta(isTaken(5, 2)),
        asserta(lakeSide(6,3)), asserta(isTaken(6, 3)),
        asserta(lakeSide(3,6)), asserta(isTaken(3, 6)),
        asserta(lakeSide(4,5)), asserta(isTaken(4, 5)),
        asserta(lakeSide(2,5)), asserta(isTaken(2, 5)),
        asserta(lakeSide(5,4)), asserta(isTaken(5, 4)),
        asserta(lakeSide(1,4)), asserta(isTaken(1, 4)).


diggingTile :-  player(PrevX,PrevY),
                asserta(digged(PrevX, PrevY)),
                asserta(isTaken(PrevX, PrevY)),
                write('now you can farm here'), nl.


periTidur :-    write('     __/\\__ '), nl,
                write('. _  \\''//                '), nl,
                write('-( )-/_||_\\                    '), nl,
                write(' .\'  \\_()_/        '), nl,
                write('  |   | , \\     '), nl,
                write('  |mrf| .  \\ '), nl,
                write(' .\\. ,\\_____\'. '), nl, nl,
                
                write('you meet a sleeping fairy in your dream, you can choose the place you want: '), nl,
                write('Enter the X posisition that you want to go: '), read_integer(XT),
                write('Enter the Y posisition that you want to go: '), read_integer(YT), nl,
                wall(XT, YT) -> write('you can\'t go through wall'),nl;
                lake(XT, YT) -> write('you can\'t swim, don\'t go there'), nl;
                player(PrevX, PrevY), retract(player(PrevX, PrevY)), asserta(player(XT, YT)),
                write('-----------------3, 2, 1.. GO!!!!------------------'), nl, 
                write('Successfully moved, May we meet again, good boy! '), nl, nl,
                validMove(PrevX, PrevY, XT, YT).


                                
                                        

                                        



