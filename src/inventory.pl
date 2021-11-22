:- dynamic(used_space/1).
:- dynamic(stored_item/2).
:- dynamic(tool_level/2).

is_tool(fishing_rod).
is_tool(shovel).


/* create Inventory untuk setiap speciality*/
create_farmer_inventory :-
    asserta(used_space(7)), asserta(stored_item(corn_seed, 5)),
    asserta(tool_level(fishing_rod, 1)), asserta(tool_level(shovel, 1)).

create_rancher_inventory :-
    asserta(used_space(2)),
    asserta(tool_level(fishing_rod, 1)), asserta(tool_level(shovel, 1)).

create_fisherman_inventory :-
    asserta(used_space(7)), asserta(stored_item(fish_bait, 5)),
    asserta(tool_level(fishing_rod, 1)), asserta(tool_level(shovel, 1)).


/* space untuk menandakan berapa banyak item yang ada dalam inventory */
space(X) :- used_space(X).


/* predikat is_inventory_full untuk mengecek apakah inventory penuh */
is_inventory_full(Used) :- space(Used), Used = 100.


/* pesan jika inventory penuh */
display_inventory_full_message :- writeln('Inventory full.').


/* store_item untuk memasukkan item ke dalam inventory */
store_item(Item) :-
    % Cek apakah masih ada ruang kosong, jika ada, lanjut
    not(is_inventory_full(Used)) ->
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
        writeln('Item stored to inventory.')
    % Jika tas penuh, keluarkan pesan
    ; display_inventory_full_message.


/* display_inventory untuk menampilkan inventory */
display_inventory :-
    writeln(' _                                              '),
    writeln('| |                        _                    '),
    writeln('| |____ _   _ _____ ____ _| |_ ___   ____ _   _ '),
    writeln('| |  _ \\ | | | ___ |  _ (_   _) _ \\ / ___) | | |'),
    writeln('| | | | \\ V /| ____| | | || || |_| | |   | |_| |'),
    writeln('|_|_| |_|\\_/ |_____)_| |_| \\__)___/|_|    \\__  |'),
    writeln('                                         (____/ '), 
    nl,
    write('Load: '), space(Used), write(Used), write('/'), writeln('100'), 
    nl,
    writeln('-----------------  ITEMS LIST  -----------------'), 
    nl,
    forall(is_tool(Tool),
        (write(Tool), write(' lv. '), tool_level(Tool, Lv), writeln(Lv))),
    forall(stored_item(Item, Count), 
        (write(Item), write(' : '), writeln(Count))), nl.


/* delete_item untuk menghapus item pada inventory */
delete_item(Item, Qty) :-
    % Cek apakah dia item atau tool
    % Jika item, kurangi jumlahnya
    stored_item(Item, OldQty) ->
        NewQty is OldQty - Qty,
        % Jika jumlahnya menjadi negatif atau nol, hapus semua item tsb
        (NewQty =< 0 -> 
            retract(stored_item(Item, OldQty)), retract(used_space(Used)),
            NewUsed is Used - OldQty, asserta(used_space(NewUsed))
            % Jika jumlahnya positif, kurangi kuantitasnya
            ; retract(stored_item(Item, OldQty)), asserta(stored_item(Item, NewQty)), 
            retract(used_space(Used)), NewUsed is Used - Qty, asserta(used_space(NewUsed))),
        % Jika berhasil menghapus item, tampilkan pesan
        writeln('Item deleted from Inventory.')
    % Jika mencoba mendelete tool, tampilkan pesan
    ; is_tool(Item) -> writeln('You can\'t delete a tool.')
    % Jika tidak punya item yang mau didelete, tampilkan pesan
    ; writeln('You don\'t have that item.').