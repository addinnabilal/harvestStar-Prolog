:- dynamic(usedSpace/1).
:- dynamic(stored/2).

/* create Inventory untuk setiap speciality*/
createFarmerInventory :-    asserta(usedSpace(7)), asserta(stored(fishing_rod_lv1, 1)),
                            asserta(stored(shovel_lv1, 1)), asserta(stored(seeds, 5)).

createRancherInventory :-   asserta(usedSpace(6)), asserta(stored(fishing_rod_lv1, 1)),
                            asserta(stored(shovel_lv1, 1)).

createFishermanInventory :- asserta(usedSpace(7)), asserta(stored(fishing_rod_lv1, 1)),
                            asserta(stored(shovel_lv1, 1)), asserta(stored(fish_bait, 5)).


/* space untuk menandakan berapa banyak item yang ada dalam inventory */
space(X) :- usedSpace(X).


/* isInInventory, predikat untuk mengetahui apakah suatu item ada di inventory */
isInInventory(Item) :- stored(Item, Qty), Qty > 0.


/* storeItem untuk memasukkan item ke dalam inventory */
storeItem(Item) :-  space(Used), Used < 100 ->
                    /* Jika Item sudah ada, tinggal ditambah jumlahnya */
                    (stored(Item, Qty) -> retract(stored(Item, Qty)), 
                    NewQty is Qty + 1, asserta(stored(Item, NewQty)), 
                    retract(usedSpace(Used)), NewUsed is Used + 1, 
                    asserta(usedSpace(NewUsed));
                    /* Jika belum ada, dibuat baru */
                    asserta(stored(Item, 1)), retract(usedSpace(Used)), 
                    NewUsed is Used + 1, asserta(usedSpace(NewUsed))),
                    /* Setelah berhasil ditambahkan keluarkan pesan */
                    write('Item stored to inventory.'), nl;
                    /* Jika tas penuh, keluarkan pesan */
                    write('Inventory full.'), nl.


/* countItem untuk menghitung jumlah tiap item dalam inventory */
countItem(Item, Count) :- stored(Item, Count).


/* displayInventory untuk menampilkan inventory */
displayInventory :- write(' _                                              '), nl,
                    write('| |                        _                    '), nl,
                    write('| |____ _   _ _____ ____ _| |_ ___   ____ _   _ '), nl,
                    write('| |  _ \\ | | | ___ |  _ (_   _) _ \\ / ___) | | |'), nl,
                    write('| | | | \\ V /| ____| | | || || |_| | |   | |_| |'), nl,
                    write('|_|_| |_|\\_/ |_____)_| |_| \\__)___/|_|    \\__  |'), nl,
                    write('                                         (____/ '), nl, nl,
                    write('Load: '), space(Used), write(Used), write('/'), write('100'), nl, nl,
                    write('-----------------  ITEMS LIST  -----------------'), nl, nl,
                    forall((isInInventory(Item)), 
                        (countItem(Item, Count), write(Item), write(' : '), write(Count), nl)), nl.
