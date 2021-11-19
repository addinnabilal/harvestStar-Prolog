/*map.pl*/

/*generate coordinate*/

:- dynamic(coordinate/2).
:- dynamic(width/1).
:- dynamic(height/1).
generate(X, Y) :- (X = 0, Y = 0 -> asserta(coordinate(0, 0));
                    X = 0 -> asserta(coordinate(0, Y)), NewY is Y-1, generate(X, NewY);
                    Y = 0 -> asserta(coordinate(X,Y)), NewY = 15, NewX is X - 1, generate(NewX, NewY);
                            asserta(coordinate(X, Y)), NewY is Y - 1, generate(X, NewY)).

% generate(X,Y) :-        (X = 0, Y = 0 -> asserta(coordinate(0, 0));
%                         X = 0 -> asserta(coordinate(0,Y)), NewY is Y - 1, generate(X, NewY);
%                         Y = 0 -> asserta(coordinate(X,Y)), NewY = 15, NewX is X - 1, generate(NewX, NewY);
% 		                asserta(coordinate(X, Y)), NewY is Y - 1, generate(X, NewY)).

/*deklarasi isTaken*/
:- dynamic(isTaken/2).
taken(X, Y) :- isTaken(X, Y).
taken(X, Y) :- \+(isTaken(X,Y)), asserta(isTaken(X, Y)).


/*deklarasi wall */
isWall(X, Y) :- Y =:= 15, coordinate(X, Y).
isWall(X, Y) :- X =:= 0, coordinate(X, Y).
isWall(X, Y) :- X =:= 15, coordinate(X, Y).
isWall(X, Y) :- Y =:= 0, coordinate(X, Y).


/*deklarasi show map */
 map(SX, SY) :-  (isWall(SX, SY) -> write('#');
                 player(SX, SY) -> write('P');
                 marketplace(SX, SY) -> write('M');
                 quest(SX, SY) -> write('Q');
                 house(SX, SY) -> write('H');
                 ranch(SX, SY) -> write('R');
                 digged(SX, SY) -> write('=');
                 lake(SX, SY) -> write('o');
                 write('-')), NewX is SX + 1,
                 (SX = 15, SY = 0 -> nl;
                 SX = 15 -> nl, X = 0, NewY is SY - 1, map(X, NewY);
                 map(NewX, SY)).




validMove(PrevX, PrevY, NewX, NewY) :- (marketplace(NewX, NewY) -> write('Welcome to the market, want to buy something?'),nl,nl, visitStore;
                                        quest(NewX, NewY) -> write('uncle need your help!'), nl, nl, getQuest;
                                        ranch(NewX, NewY) -> write('uhuk, uhuk.. This ranch stinks'), nl, nl, visitRanch;
                                        house(NewX, NewY) -> write('Mama, Papa, i\'m home'), nl, nl, visitHouse;
                                        isWall(NewX, NewY), taken(NewX, NewY) ->
                                        retract(player(NewX, NewY)), asserta(player(PrevX, PrevY)),
                                        write('aaaa!!, I hit the wall. It hurts'), nl, !, fail;
                                        lake(NewX, NewY), taken(NewX, NewY) -> retract(player(NewX, NewY)), asserta(player(PrevX, PrevY)),
                                        write('This lake is too cold, I don\'t want to swim here'), nl, !, fail;
                                        digged(NewX, NewY) -> write('I like farming!!'), nl, nl, visitFarm).

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
initMap :-  generate(15, 15), 
            asserta(player(6, 13)), asserta(isTaken(6,13)),
            asserta(quest(4, 6)), asserta(isTaken(4, 6)),
            asserta(marketplace(11, 9)), asserta(isTaken(11, 9)),
            asserta(house(6, 14)), asserta(isTaken(6,14)),
            asserta(ranch(12, 13)), asserta(isTaken(12, 13)),
            asserta(digged(7,7)), asserta(isTaken(7,7)), 
            asserta(lake(2,2)), asserta(isTaken(2, 2)),
            asserta(lake(3,3)), asserta(isTaken(3, 3)),
            asserta(lake(4,4)), asserta(isTaken(4, 4)),
            asserta(lake(2,3)), asserta(isTaken(2, 3)),
            asserta(lake(2,4)), asserta(isTaken(2, 4)),
            asserta(lake(3,2)), asserta(isTaken(3, 2)),
            asserta(lake(3,4)), asserta(isTaken(3, 4)),
            asserta(lake(4,2)), asserta(isTaken(4, 2)),
            asserta(lake(4,3)), asserta(isTaken(4, 3)).




                                
                                        

                                        





