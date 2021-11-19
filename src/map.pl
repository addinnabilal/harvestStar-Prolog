/*map.pl*/

/*createMap coordinate*/

map :- displayMap(0,11).

:- dynamic(coordinate/2).
createMap(X, Y) :- (X = 0, Y = 0 -> asserta(coordinate(0, 0));
                    X = 0 -> asserta(coordinate(0, Y)), NewY is Y-1, createMap(X, NewY);
                    Y = 0 -> asserta(coordinate(X,Y)), NewY = 11, NewX is X - 1, createMap(NewX, NewY);
                            asserta(coordinate(X, Y)), NewY is Y - 1, createMap(X, NewY)).

/*deklarasi isTaken*/
:- dynamic(isTaken/2).
taken(X, Y) :- isTaken(X, Y).
taken(X, Y) :- \+(isTaken(X,Y)), asserta(isTaken(X, Y)).


/*deklarasi wall */
wall(X, Y) :- Y =:= 11, coordinate(X, Y).
wall(X, Y) :- X =:= 0, coordinate(X, Y).
wall(X, Y) :- X =:= 11, coordinate(X, Y).
wall(X, Y) :- Y =:= 0, coordinate(X, Y).


/*deklarasi show map */
 displayMap(SX, SY) :-  (wall(SX, SY) -> write('#');
                        player(SX, SY) -> write('P');
                        marketplace(SX, SY) -> write('M');
                        quest(SX, SY) -> write('Q');
                        house(SX, SY) -> write('H');
                        ranch(SX, SY) -> write('R');
                        digged(SX, SY) -> write('=');
                        lake(SX, SY) -> write('~');
                        lakeSide(SX, SY) -> write('o');
                        write('-')), NewX is SX + 1,
                        (SX = 11, SY = 0 -> nl;
                        SX = 11 -> nl, X = 0, NewY is SY - 1, displayMap(X, NewY);
                        displayMap(NewX, SY)).



validMove(PrevX, PrevY, NewX, NewY) :- (marketplace(NewX, NewY) -> write('Welcome to the market, want to buy something?'),nl,nl, visitStore;
                                        quest(NewX, NewY) -> write('uncle need your help!'), nl, nl, getQuest;
                                        ranch(NewX, NewY) -> write('uhuk, uhuk.. This ranch stinks'), nl, nl, visitRanch;
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
w :-    retract(player(PrevX, PrevY)), NewY is PrevY + 1, 
        asserta(player(PrevX, NewY)),
        write('what\'s up in the north'), nl, write('============================'), nl,
        validMove(PrevX, PrevY, PrevX, NewY).

a:-     retract(player(PrevX, PrevY)), NewX is PrevX - 1, 
        asserta(player(NewX, PrevY)),
        write('what\'s up in the west'), nl, write('============================'), nl,
        validMove(PrevX, PrevY, NewX, PrevY).

s :-    retract(player(PrevX, PrevY)), NewY is PrevY - 1, 
        asserta(player(PrevX, NewY)),
        write('what\'s up in the south'), nl,  write('============================'), nl,
        validMove(PrevX, PrevY, PrevX, NewY).

d:-     retract(player(PrevX, PrevY)), NewX is PrevX + 1, 
        asserta(player(NewX, PrevY)),
        write('what\'s up in the east'), nl, write('============================'), nl,
        validMove(PrevX, PrevY, NewX, PrevY).

/*deklarasi init map*/
initMap :-  createMap(11, 11), 
        asserta(player(10, 8)), asserta(isTaken(10,8)),
        asserta(quest(6, 8)), asserta(isTaken(6, 8)),
        asserta(marketplace(6, 10)), asserta(isTaken(6, 10)),
        asserta(house(8, 8)), asserta(isTaken(8,8)),
        asserta(ranch(10, 10)), asserta(isTaken(10, 10)),
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


diggingTile :-  retract(player(PrevX, PrevY)),
                asserta(player(PrevX, PrevY)),
                asserta(digged(PrevX, PrevY)),
                asserta(isTaken(PrevX, PrevY)),
                write('now you can farm here'), nl.



                                
                                        

                                        





