/**
 * File: marketplace.pl
 * 
 * File berisi semua predikat dan rules
 * yang berhubungan dengan marketplace.
 */


:- dynamic(item_price_per_char_level/3).
:- dynamic(tool_price_per_level/3).

% debugging purpose
% stored_animal(chicken, 5).

% Harga beli item-item basic
basic_item_buy_price(fish_bait, 30).
basic_item_buy_price(corn_seed, 30).
basic_item_buy_price(rice_seed, 40).
basic_item_buy_price(wheat_seed, 50).
basic_item_buy_price(chicken, 500).
basic_item_buy_price(sheep, 1000).
basic_item_buy_price(cow, 1500).

% Harga jual item-item basic
basic_item_sell_price(fish_bait, 15).
basic_item_sell_price(corn_seed, 15).
basic_item_sell_price(rice_seed, 20).
basic_item_sell_price(wheat_seed, 25).
basic_item_sell_price(chicken, 250).
basic_item_sell_price(sheep, 500).
basic_item_sell_price(cow, 750).

% Harga jual ikan per level karakter
item_price_per_char_level(arowana_fish, 200, 1).
item_price_per_char_level(koi_fish, 150, 1).
item_price_per_char_level(carp_fish, 120, 1).
item_price_per_char_level(pomfret_fish, 100, 1).
item_price_per_char_level(catfish, 80, 1).
item_price_per_char_level(boots, 5, 1).

% Harga jual hasil ternak per level karakter
item_price_per_char_level(milk, 200, 1).
item_price_per_char_level(wool, 70, 1).
item_price_per_char_level(egg, 10, 1).

% Harga jual hasil panen per level karakter
item_price_per_char_level(wheat, 14, 1).
item_price_per_char_level(rice, 10, 1).
item_price_per_char_level(corn, 8, 1).

% Harga beli tools per levelnya
tool_price_per_level(fishing_rod, 500, 2).
tool_price_per_level(shovel, 300, 2).


/* 
 * visit_marketplace untuk mengunjungi marketplace
 * dan melakukan buy atau sell
 */
visit_marketplace  :-  
    display_marketplace_welcome, gold(_,Balance),
    write('Your current money : '), write(Balance), nl,
    write('Pick an option : '), read(Marketplace_option), nl,

    % BUY
    (Marketplace_option = 1 ->
        display_marketplace_buy,
        write('Pick an option : '), read(Buy_option),
        (Buy_option = 1 -> buy_item(Balance, fish_bait)
        ; Buy_option = 2 -> buy_item(Balance, corn_seed)
        ; Buy_option = 3 -> buy_item(Balance, rice_seed)
        ; Buy_option = 4 -> buy_item(Balance, wheat_seed)
        ; Buy_option = 5 -> buy_animal(Balance, chicken)
        ; Buy_option = 6 -> buy_animal(Balance, sheep)
        ; Buy_option = 7 -> buy_animal(Balance, cow)
        ; Buy_option = 0 -> write('Okay, looks like you have other interests.'), nl, nl
        ; (tool_price_per_level(fishing_rod, Price_fr, Lvl_fr), tool_price_per_level(shovel, Price_s, Lvl_s),
            % Level fishing rod < 5
            (Lvl_fr =< 5 ->
                % Level shovel < 5, bisa membeli keduanya
                (Lvl_s =< 5 ->
                    (Buy_option = 8 -> buy_tool(Balance, shovel, Price_s, Lvl_s)
                    ; Buy_option = 9 -> buy_tool(Balance, fishing_rod, Price_fr, Lvl_fr))

                % Level shovel = 5, hanya bisa membeli fishing rod    
                ; Buy_option = 8 -> buy_tool(Balance, fishing_rod, Price_fr, Lvl_fr))
            
            % Level fishing rod = 5
            ; Lvl_s =< 5 ->
                (Buy_option = 8 -> buy_tool(Balance, shovel, Price_s, Lvl_s))))  
            
            % Level fishing rod = 5 dan shovel = 5, tidak bisa membeli tool

        ), nl,
        visit_marketplace
    
    % SELL
    ; Marketplace_option = 2 ->
        display_marketplace_sell,
        write('Input "cancel" if you want to cancel.'), nl,
        write('Pick an item : '), read(Item), nl,

        % Item yang dipilih berada di inventory
        (stored_item(Item, Qty) ->
            % Item yang dipilih harga jualnya tidak pernah berubah
            (basic_item_sell_price(Item, Price) -> sell_item(Balance, Item, Price, Qty)    
            % Item yang dipilih harga jualnya berubah sesuai level karakter
            ; item_price_per_char_level(Item, Price, _) -> sell_item(Balance, Item, Price, Qty))

        % Item yang dipilih merupakan animal di ranch
        ; stored_animal(Item, Qty) ->
            basic_item_sell_price(Item, Price), sell_animal(Balance, Item, Price, Qty)
        
        ; Item = cancel ->
            write('Okay, looks like you have other interests.'), nl

        % Tidak mempunyai item yang dipilih
        ; write('You don\'t have that item.'), nl
        ), nl,
        visit_marketplace
    
    % CANCEL
    ; Marketplace_option = 0 ->
        display_marketplace_exit).


/* Prosedur buy */
buy_item(Balance, Item) :-
    basic_item_buy_price(Item, Price),
    (\+(is_inventory_full(_)) -> 
        write('How many '), write(Item), write(' do you want to buy? '), read(Buy_qty), nl,
        % Jika membeli dengan quantity <= 0, keluarkan pesan
        (Buy_qty =< 0 -> 
            write('It seems you are not interested in buying the item.'), nl, nl
        % Jika > 0 , lanjut dengan pengecekan apakah quantity yang dibeli bisa masuk inventory
        ; space(Used), New_used is Used + Buy_qty, 
            % Beli melebihi kapasitas inventory
            (New_used > 100 ->
                display_inventory_full_message
            % Beli kurang dari kapasitas inventory
            ; Total_price is Price * Buy_qty,
                (Balance >= Total_price ->
                    % Update gold
                    New_balance is Balance - Total_price,
                    update_gold(New_balance),
                    store_many_item(Item, Buy_qty)
                ; display_insufficient_gold
                )
            )
        )
    ; display_inventory_full_message).

buy_animal(Balance, Animal) :-
    basic_item_buy_price(Animal, Price),
    write('How many '), write(Animal), write(' do you want to buy? '), read(Buy_qty), nl,
    (Buy_qty =< 0 ->
        write('It seems you are not interested in buying the item.'), nl, nl
    ; Total_price is Price * Buy_qty,
        (Balance >= Total_price ->
            % Update gold
            New_balance is Balance - Total_price,
            update_gold(New_balance),
            store_many_animal(Animal, Buy_qty)
        ; display_insufficient_gold
        )    
    ).
    

buy_tool(Balance, Tool, Price, Level) :-
    Balance >= Price ->
        % Update gold
        New_balance is Balance - Price,
        update_gold(New_balance),

        % Update level tool menjadi level tool yang dibeli
        retract(tool_level(Tool, _)),
        asserta(tool_level(Tool, Level)),

        % Update harga beli tool pada level selanjutnya
        retract(tool_price_per_level(shovel, Price, Level)),
        Next_level is Level + 1, Next_price is Price + 100,
        asserta(tool_price_per_level(shovel, Next_price, Next_level)),

        write(Tool), write(' upgraded to level '), write(Level), write('!'), nl
    ; display_insufficient_gold.


/* Prosedur sell */
sell_item(Balance, Item, Price, Qty) :-
    write('One '), write(Item), write(' is worth '), write(Price), write(' golds!'), nl,
    write('How many '), write(Item), write(' do you want to sell? '), read(Sell_qty), nl,
    
    (Sell_qty =< 0 ->
        write('It seems you are not interested in selling the item.'), nl, nl
    ; New_qty is Qty - Sell_qty, 
        (New_qty =< 0 ->
            New_balance is (Balance + Qty * Price), update_gold(New_balance),
            delete_item(Item, Qty)
        ; New_balance is (Balance + Sell_qty * Price), update_gold(New_balance),
            delete_item(Item, Sell_qty))).

sell_animal(Balance, Animal, Price, Qty) :-
    write('One '), write(Animal), write(' is worth '), write(Price), write(' golds!'), nl,
    write('How many '), write(Animal), write(' do you want to sell? '), read(Sell_qty), nl,
    
    (Sell_qty = 0 ->
        write('It seems you are not interested in selling the animal.'), nl, nl
    ; New_qty is Qty - Sell_qty, 
        (New_qty =< 0 ->
            New_balance is (Balance + Qty * Price), update_gold(New_balance),
            delete_animal(Animal, Qty)
        ; New_balance is (Balance + Sell_qty * Price), update_gold(New_balance),
            delete_animal(Animal, Sell_qty))).


/* Tampilan ketika mengunjungi marketplace */
display_marketplace_welcome :-
    write('                                               /\\      /\\        '),nl,
    write('                                               ||______||        '),nl,
    write('                                               || ^  ^ ||        '),nl,
    write('                                               \\| |  | |/        '),nl,
    write('                                                |______|        '),nl,
    write('              __                                |  __  |        '),nl,
    write('             /  \\       ________________________|_/  \\_|__        '),nl,
    write('            / ^^ \\     /=========================/ ^^ \\===|        '),nl,
    write('           /  []  \\   /=========================/  []  \\==|        '),nl,
    write('          /________\\ /=========================/________\\=|        '),nl,
    write('       *  |        |/==========================|        |=|        '),nl,
    write('      *** | ^^  ^^ |---------------------------| ^^  ^^ |--        '),nl,
    write('     *****| []  [] |           _____           | []  [] | |        '),nl,
    write('    *******        |          /_____\\          |      * | |        '),nl,
    write('   *********^^  ^^ |  ^^  ^^  |  |  |  ^^  ^^  |     ***| |        '),nl,
    write('  ***********]  [] |  []  []  |  |  |  []  []  | ===***** |        '),nl,
    write(' *************     |         @|__|__|@         |/ |*******|        '),nl,
    write('***************   ***********--=====--**********| *********        '),nl,
    write('***************___*********** |=====| **********|***********        '),nl,
    write(' *************     ********* /=======\\ ******** | *********        '),nl,
    write('|------------------------------------------|'), nl,
    write('|        Welcome To The Marketplace        |'), nl,
    write('|------------------------------------------|'), nl,
    nl,
    write('Are you interested in something?'), nl,
    write('[1] I want to buy something.'), nl,
    write('[2] I want to sell something.'), nl,
    write('[0] Cancel.'), nl.


/* Tampilan buy */
display_marketplace_buy :-
    write('|------------------------------------------|'), nl,
    write('|             Buy Items/Tools              |'), nl,
    write('|------------------------------------------|'), nl,
    nl,
    write('Which item or tool do you want to buy?'), nl,
    write('[1] Fish Bait            | 30   gold'), nl,
    write('[2] Corn Seed            | 30   gold'), nl,
    write('[3] Rice Seed            | 40   gold'), nl, 
    write('[4] Wheat Seed           | 50   gold'), nl,
    write('[5] Chicken              | 500  gold'), nl,
    write('[6] Sheep                | 1000 gold'), nl,
    write('[7] Cow                  | 1500 gold'), nl,

    tool_price_per_level(fishing_rod, Price_fr, Lvl_fr), tool_price_per_level(shovel, Price_s, Lvl_s),
    (Lvl_fr =< 5 -> 
        (Lvl_s =< 5 ->
            format('[8] Level ~d Shovel       | ~d  gold', [Lvl_s, Price_s]), nl,
            format('[9] Level ~d Fishing Rod  | ~d  gold', [Lvl_fr, Price_fr]), nl, nl
        ;   format('[8] Level ~d Fishing Rod  | ~d  gold', [Lvl_fr, Price_fr]), nl, nl)
    ; Lvl_s =< 5 ->
        format('[8] Level ~d Shovel       | ~d  gold', [Lvl_s, Price_s]), nl, nl),
    
    write('[0] Cancel                          '), nl, nl.


/* Tampilam sell */
display_marketplace_sell :-
    write('|------------------------------------------|'), nl,
    write('|               Sell Items                 |'), nl,
    write('|------------------------------------------|'), nl,
    nl,
    write('Which item do you want to sell?'), nl,
    forall(stored_item(Item, Count), 
        (write(Item), write('\t: '), write(Count), nl)),
    forall(stored_animal(Animal, Count),
        (write(Animal), write('\t\t: '), write(Count), nl)), nl.


/* Tampilan keluar */
display_marketplace_exit :- write('Alright! This marketplace will be at your service anytime.'), nl.


/* Tampilan jika uang tidak cukup */
display_insufficient_gold :- write('Sorry, you don\'t have enough gold.'), nl.


/* Mengubah jumlah gold */
update_gold(New_number):- 
    uname(X),
    (New_number >= 20000 -> goalState, quit
    ; retract(gold(X,_)), asserta(gold(X, New_number))).


/* Mengubah harga jual item hasil aktivitas berdasarkan level */
update_item_price_per_char_level(Item, New_level) :-
    retract(item_price_per_char_level(Item, Price, _)),
    New_price_temp is Price * (11/10),
    New_price is ceiling(New_price_temp),
    asserta(item_price_per_char_level(Item, New_price, New_level)).
