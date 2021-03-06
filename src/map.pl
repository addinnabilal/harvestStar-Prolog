/*map.pl*/

/*createMap locate*/

showMap :- displayMap(0,16).

:- dynamic(locate/2).
createMap(X, Y) :- (X = 0, Y = 0 -> asserta(locate(0, 0));
                    X = 0 -> asserta(locate(0, Y)), YNew is Y-1, createMap(X, YNew);
                    Y = 0 -> asserta(locate(X,Y)), YNew = 16, XNew is X - 1, createMap(XNew, YNew);
                             asserta(locate(X, Y)), YNew is Y - 1, createMap(X, YNew)).

/*deklarasi isPlaced*/
:- dynamic(isPlaced/2).
placed(X, Y) :- isPlaced(X, Y).
placed(X, Y) :- \+(isPlaced(X,Y)), asserta(isPlaced(X, Y)).


/*deklarasi wall */
wall(X, Y) :- Y =:= 16, locate(X, Y).
wall(X, Y) :- X =:= 0, locate(X, Y).
wall(X, Y) :- X =:= 16, locate(X, Y).
wall(X, Y) :- Y =:= 0, locate(X, Y).


/*deklarasi show map */
 displayMap(SX, SY) :-  (SX = 0 -> write('\t\t\t')
                        ; write('')),
                        (wall(SX, SY) -> write('#');
                        position(SX, SY) -> write('P');
                        marketplace(SX, SY) -> write('M');
                        quest(SX, SY) -> write('Q');
                        house(SX, SY) -> write('H');
                        ranch(SX, SY) -> write('R');
                        alchemist(SX, SY) -> write('A');
                        digged(SX, SY) -> write('=');
                        lake(SX, SY) -> write('~');
                        lakeSide(SX, SY) -> write('o');
                        write('-')), XNew is SX + 1,
                        (SX = 16, SY = 0 -> nl;
                        SX = 16 -> nl, X = 0, YNew is SY - 1, displayMap(X, YNew);
                        displayMap(XNew, SY)).



isValid(XPrev, YPrev, XNew, YNew) :- (marketplace(XNew, YNew) -> nl, visit_marketplace;

                                        quest(XNew, YNew) -> nl, take_quest;

                                        ranch(XNew, YNew) -> write('uhuk, uhuk.. This ranch stinks'), nl, nl, ranch;

                                        alchemist(XNew, YNew) -> write('welcome to secret'), nl, nl, alchemist;

                                        house(XNew, YNew) -> write('Mama, Papa, i\'m home'), nl, nl, visitHouse;

                                        digged(XNew, YNew) -> write('I like farming!!'), nl, nl;

                                        lakeSide(XNew, YNew) -> write('This is lakeside, you can fish from here'),nl,nl);

                                        wall(XNew, YNew), placed(XNew, YNew) ->
                                        retract(position(XNew, YNew)), asserta(position(XPrev, YPrev)),
                                        !,write('aaaa!!, I hit the wall. It hurts'), nl, fail;

                                        lake(XNew, YNew), placed(XNew, YNew) -> retract(position(XNew, YNew)), asserta(position(XPrev, YPrev)),
                                        !,write('This lake is too cold, I don\'t want to swim here'),nl, fail.
                                        
                                        

/*deklarasi move*/
:- dynamic(position/2).
w :-    retract(position(XPrev, YPrev)), 
        YNew is YPrev + 1, 
        asserta(position(XPrev, YNew)),
        write('What\'s up in the north, is it cold in the nort?'),  nl,
        isValid(XPrev, YPrev, XPrev, YNew).

a:-     retract(position(XPrev, YPrev)), 
        XNew is XPrev - 1, 
        asserta(position(XNew, YPrev)),
        write('What\'s up in the west, seems cool to cowboy.'), nl,
        isValid(XPrev, YPrev, XNew, YPrev).

s :-    retract(position(XPrev, YPrev)), 
        YNew is YPrev - 1, 
        asserta(position(XPrev, YNew)),
        write('What\'s up in the south, can i find penguins in the south?'), nl,
        isValid(XPrev, YPrev, XPrev, YNew).

d:-     retract(position(XPrev, YPrev)), 
        XNew is XPrev + 1, 
        asserta(position(XNew, YPrev)),
        write('What\'s up in the east, i like asian culture.'), nl,
        isValid(XPrev, YPrev, XNew, YPrev).

/*deklarasi init map*/
initMap :-  createMap(16, 16), 
        asserta(position(10, 8)),
        asserta(quest(6, 8)), asserta(isPlaced(6, 8)),
        asserta(marketplace(6, 10)), asserta(isPlaced(6, 10)),
        asserta(house(8, 8)), asserta(isPlaced(8,8)),
        asserta(ranch(10, 10)), asserta(isPlaced(10, 10)),
        asserta(alchemist(12, 1)), asserta(isPlaced(12, 1)),
        asserta(digged(3, 3)), asserta(isPlaced(3, 3)),
        asserta(lake(2,2)), asserta(isPlaced(2, 2)),
        asserta(lake(1,3)), asserta(isPlaced(1, 3)),
        asserta(lake(3,1)), asserta(isPlaced(3, 1)),
        asserta(lake(5,3)), asserta(isPlaced(5, 3)),
        asserta(lake(3,5)), asserta(isPlaced(3, 5)),
        asserta(lake(4,4)), asserta(isPlaced(4, 4)),
        asserta(lake(2,3)), asserta(isPlaced(2, 3)),
        asserta(lake(2,4)), asserta(isPlaced(2, 4)),
        asserta(lake(3,2)), asserta(isPlaced(3, 2)),
        asserta(lake(3,4)), asserta(isPlaced(3, 4)),
        asserta(lake(4,2)), asserta(isPlaced(4, 2)),
        asserta(lake(4,3)), asserta(isPlaced(4, 3)),
        asserta(lake(1,1)), asserta(isPlaced(1, 1)),
        asserta(lake(2,1)), asserta(isPlaced(2, 1)),
        asserta(lake(1,2)), asserta(isPlaced(1, 2)),
        asserta(lakeSide(4,1)), asserta(isPlaced(4, 1)),
        asserta(lakeSide(5,2)), asserta(isPlaced(5, 2)),
        asserta(lakeSide(6,3)), asserta(isPlaced(6, 3)),
        asserta(lakeSide(3,6)), asserta(isPlaced(3, 6)),
        asserta(lakeSide(4,5)), asserta(isPlaced(4, 5)),
        asserta(lakeSide(2,5)), asserta(isPlaced(2, 5)),
        asserta(lakeSide(5,4)), asserta(isPlaced(5, 4)),
        asserta(lakeSide(1,4)), asserta(isPlaced(1, 4)).


diggingTile :-  position(XPrev,YPrev),
                asserta(digged(XPrev, YPrev)),
                asserta(isPlaced(XPrev, YPrev)),
                write('Now you can farm here.'), nl.


periTidur :-    write('     __/\\__ '), nl,
                write('. _  \\''//                '), nl,
                write('-( )-/_||_\\                    '), nl,
                write(' .\'  \\_()_/        '), nl,
                write('  |   | , \\     '), nl,
                write('  |zzz| .  \\ '), nl,
                write(' .\\. ,\\_____\'. '), nl, nl,

                write('You meet a sleeping fairy in your dream!'), nl,
                write('You can move to the place you want after wake up!'), nl,
                nl,
                showMap,
                nl,
                write('Notes: (0,0) is the bottom left position on the map.'), nl,
                write('Enter the X posisition that you want to go: '), read(XT),
                write('Enter the Y posisition that you want to go: '), read(YT), nl,
                (wall(XT, YT) -> write('You can\'t go through wall.'), nl, fail;
                lake(XT, YT) -> write('You can\'t swim, don\'t go there.'), nl, fail;
                position(XPrev, YPrev), retract(position(XPrev, YPrev)), asserta(position(XT, YT)),
                write('             ~ Wingardium Leviosa ~             '), nl, 
                write('Successfully moved, May we meet again, good boy!'), nl, nl,
                isValid(XPrev, YPrev, XT, YT)).


                                
                                        

                                        



