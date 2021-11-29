/**
 * File: inventory.pl
 * 
 * File berisi semua predikat dan rules yang 
 * berhubungan dengan inventory.
 */


:- dynamic(used_space/1).
:- dynamic(stored_item/2).
:- dynamic(tool_level/2).


is_tool(fishing_rod).
is_tool(shovel).


/* create Inventory untuk setiap speciality */
create_farmer_inventory :-
    asserta(used_space(7)), asserta(stored_item(corn_seed, 5)),
    asserta(tool_level(fishing_rod, 1)), asserta(tool_level(shovel, 1)).

create_rancher_inventory :-
    asserta(used_space(2)), asserta(stored_animal(chicken, 5)),
    asserta(tool_level(fishing_rod, 1)), asserta(tool_level(shovel, 1)).

create_fisherman_inventory :-
    asserta(used_space(7)), asserta(stored_item(fish_bait, 5)),
    asserta(tool_level(fishing_rod, 1)), asserta(tool_level(shovel, 1)).


/* space untuk menandakan berapa banyak item yang ada dalam inventory */
space(X) :- used_space(X).


/* predikat is_inventory_full untuk mengecek apakah inventory penuh */
is_inventory_full(Used) :- space(Used), Used = 100.


/* pesan jika inventory penuh */
display_inventory_full_message :- write('Inventory full.'), nl.


/* display_inventory untuk menampilkan inventory */
display_inventory :-
    write(' _                                              '), nl,
    write('| |                        _                    '), nl,
    write('| |____ _   _ _____ ____ _| |_ ___   ____ _   _ '), nl,
    write('| |  _ \\ | | | ___ |  _ (_   _) _ \\ / ___) | | |'), nl,
    write('| | | | \\ V /| ____| | | || || |_| | |   | |_| |'), nl,
    write('|_|_| |_|\\_/ |_____)_| |_| \\__)___/|_|    \\__  |'), nl,
    write('                                         (____/ '), nl,
    nl,
    write('Load: '), space(Used), write(Used), write('/'), write('100'), nl,
    nl,
    write('-----------------  ITEMS LIST  -----------------'), nl, 
    nl,
    tool_level(fishing_rod, Lvl_fr),
    write(fishing_rod), write('\tlv.'), write(Lvl_fr), nl,
    tool_level(shovel, Lvl_s),
    write(shovel), write('\t\tlv.'), write(Lvl_s), nl,
    forall(stored_item(Item, Count), 
        (write(Item), write('\t: '), write(Count), nl)).


/* store_item untuk memasukkan item ke dalam inventory */
store_item(Item) :-
    % Cek apakah masih ada ruang kosong, jika ada, lanjut
    (\+ is_inventory_full(Used)) ->
        % Jika Item sudah ada, tinggal ditambah jumlahnya
        (stored_item(Item, Qty) -> 
            retract(stored_item(Item, Qty)), 
            NewQty is Qty + 1, asserta(stored_item(Item, NewQty)), 
            retract(used_space(Used)), NewUsed is Used + 1, 
            asserta(used_space(NewUsed))
            % Jika belum ada, dibuat baru
            ; asserta(stored_item(Item, 1)), retract(used_space(Used)), 
            NewUsed is Used + 1, asserta(used_space(NewUsed))),
        % Setelah berhasil ditambahkan keluarkan pesan
        write(Item), write(' stored to inventory.'), nl
    % Jika tas penuh, keluarkan pesan
    ; display_inventory_full_message.

store_many_item(Item,Amnt) :-
    % Cek apakah masih ada ruang kosong, jika ada, lanjut
    (\+ is_inventory_full(Used)) ->
        % Jika Item sudah ada, tinggal ditambah jumlahnya
        (stored_item(Item, Qty) -> 
            retract(stored_item(Item, Qty)), 
            NewQty is Qty + Amnt, asserta(stored_item(Item, NewQty)), 
            retract(used_space(Used)), NewUsed is Used + Amnt, 
            asserta(used_space(NewUsed))
            % Jika belum ada, dibuat baru
            ; asserta(stored_item(Item, Amnt)), retract(used_space(Used)), 
            NewUsed is Used + Amnt, asserta(used_space(NewUsed))),
        % Setelah berhasil ditambahkan keluarkan pesan
        write(Item), write(' x'), write(Amnt), write(' stored to inventory.'), nl
    % Jika tas penuh, keluarkan pesan
    ; display_inventory_full_message.


/* delete_item untuk menghapus item pada inventory */
delete_item(Item, Qty) :-
    % Cek apakah dia item atau tool
    % Jika item, kurangi jumlahnya
    stored_item(Item, OldQty) ->
        NewQty is OldQty - Qty,
        % Jika jumlahnya menjadi negatif atau nol, hapus semua item tsb
        (NewQty =< 0 -> 
            retract(stored_item(Item, OldQty)), retract(used_space(Used)),
            NewUsed is Used - OldQty, asserta(used_space(NewUsed)),
            write(Item), write(' x'), write(OldQty), write(' deleted from Inventory.'), nl
            % Jika jumlahnya positif, kurangi kuantitasnya
        ; retract(stored_item(Item, OldQty)), asserta(stored_item(Item, NewQty)), 
            retract(used_space(Used)), NewUsed is Used - Qty, asserta(used_space(NewUsed)),
            write(Item), write(' x'), write(Qty), write(' deleted from Inventory.'), nl
        )
        
    % Jika mencoba mendelete tool, tampilkan pesan
    ; is_tool(Item) -> write('You can\'t delete a tool.'), nl
    % Jika tidak punya item yang mau didelete, tampilkan pesan
    ; write('You don\'t have that item.'), nl.


/* throw_item untuk membuang suatu item dari inventory */
throw_item :- 
    write('-----------------  ITEMS LIST  -----------------'), nl,
    nl,
    tool_level(fishing_rod, Lvl_fr),
    write(fishing_rod), write('\tlv.'), write(Lvl_fr), nl,
    tool_level(shovel, Lvl_s),
    write(shovel), write('\t\tlv.'), write(Lvl_s), nl,
    forall(stored_item(Item, Count), 
        (write(Item), write('\t: '), write(Count), nl)), nl,
    
    write('Be careful, item that have been thrown can\'t be retrieved.'), nl,
    write('Input "cancel" if you want to cancel.'), nl,
    write('Pick an item: '), read(Item),

    (stored_item(Item, _) ->
        write('How many '), write(Item), write(' do you want to throw? '), read(Throw_qty), nl,
        (Throw_qty =< 0 ->
            write('It seems you are not interested in throwing the item.'), nl
        ; delete_item(Item, Throw_qty))
    ; (is_tool(Item) ->
        nl, write('You can\'t delete a tool.'), nl)
    ; Item = cancel -> write('Okay.'), nl
    ; \+ stored_item(Item, _) -> write('You don\'t have that item.'), nl).
    