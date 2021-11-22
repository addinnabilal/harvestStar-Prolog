:- dynamic(is_in_marketplace/1).
:- dynamic(tool_price_per_level/3).

tool_price_per_level(fishing_rod, 500, 2).
tool_price_per_level(shovel, 300, 2).

is_in_marketplace(no).

tool_level(shovel, 4).
tool_level(fishing_rod, 4).
gold(_,300).
used_space(100).
stored_item(seeds, 100).

visit_marketplace  :- 
    retract(is_in_marketplace(no)), asserta(is_in_marketplace(yes)), 
    display_marketplace_welcome, gold(_,Balance),
    write('Your current money : '), writeln(Balance),
    write('Pick an option : '), read(General_option), nl,

    General_option = 1 -> 
        display_marketplace_buy,
        write('Pick an option : '), read(Buy_option), nl,
        (Buy_option = 1 ->
            (\+ is_inventory_full(Used) -> 
                (Balance >= 30 ->
                    New_balance is Balance - 30,
                    update_gold(New_balance),
                    save_item(fish_bait)
                ; display_insufficient_gold
                )
            ; display_inventory_full_message
            )
        ; Buy_option = 2 ->
            (\+ is_inventory_full(Used) -> 
                (Balance >= 50 ->
                    New_balance is Balance - 50,
                    update_gold(New_balance),
                    save_item(corn_seed)
                ; display_insufficient_gold)
            ; display_inventory_full_message
            )
        ; Buy_option = 3 ->
            (\+ is_inventory_full(Used) -> 
                (Balance >= 50 ->
                    New_balance is Balance - 50,
                    update_gold(New_balance),
                    save_item(rice_seed)
                ; display_insufficient_gold)
            ; display_inventory_full_message
            )
        ; Buy_option = 4 ->
            (\+ is_inventory_full(Used) -> 
                (Balance >= 50 ->
                    New_balance is Balance - 50,
                    update_gold(New_balance),
                    save_item(wheat_seed)
                ; display_insufficient_gold)
            ; display_inventory_full_message
            )
        ; Buy_option = 5 ->
            (Balance >= 500 ->
                New_balance is Balance - 500,
                update_gold(New_balance),
                save_animal(chicken)
            ; display_insufficient_gold
            )
        ; Buy_option = 6 ->
            (Balance >= 1000 ->
                New_balance is Balance - 1000,
                update_gold(New_balance),
                save_animal(sheep)
            ; display_insufficient_gold
            )
        ; Buy_option = 7 ->
            (Balance >= 1500 ->
                New_balance is Balance - 1500,
                update_gold(New_balance),
                save_animal(cow)
            ; display_insufficient_gold
            )
        ; (tool_price_per_level(fishing_rod, Lvl_fr, Price_fr), tool_price_per_level(shovel, Lvl_s, Price_s),
            (Lvl_fr =< 5 -> 
                (Lvl_s =< 5 ->
                    (Buy_option = 8 ->
                        (Balance >= Price_s ->
                            New_balance is Balance - Price_s,
                            update_gold(New_balance),
                            retract(tool_level(shovel, _)),
                            asserta(tool_level(shovel, Lvl_s)),
                            retract(tool_price_per_level(shovel, Lvl_s, Price_s)),
                            Next_lvl_s is Lvl_s + 1, Next_price_s is Price_s + 100,
                            asserta(tool_price_per_level(shovel, Next_lvl_s, Next_price_s))
                        ; display_insufficient_gold
                        )
                    ; Buy_option = 9 ->
                        (Balance >= Price_fr ->
                            New_balance is Balance - Price_fr,
                            update_gold(New_balance),
                            retract(tool_level(fishing_rod, _)),
                            asserta(tool_level(fishing_rod, Lvl_fr)),
                            retract(tool_price_per_level(fishing_rod, Lvl_fr, Price_fr)),
                            Next_lvl_fr is Lvl_fr + 1, Next_price_fr is Price_fr + 100,
                            asserta(tool_price_per_level(fishing_rod, Next_lvl_fr, Next_price_fr))
                        ; display_insufficient_gold
                        )
                    )
                ; Buy_option = 8 ->
                    (Balance >= Price_fr ->
                        New_balance is Balance - Price_fr,
                        update_gold(New_balance),
                        retract(tool_level(fishing_rod, _)),
                        asserta(tool_level(fishing_rod, Lvl_fr)),
                        retract(tool_price_per_level(fishing_rod, Lvl_fr, Price_fr)),
                        Next_lvl_fr is Lvl_fr + 1, Next_price_fr is Price_fr + 100,
                        asserta(tool_price_per_level(fishing_rod, Next_lvl_fr, Next_price_fr))
                    ; display_insufficient_gold
                    )
                )
            ; Lvl_s =< 5 ->
                (Buy_option = 8 ->
                    (Balance >= Price_s ->
                        New_balance is Balance - Price_s,
                        update_gold(New_balance),
                        retract(tool_level(shovel, _)),
                        asserta(tool_level(shovel, Lvl_s)),
                        retract(tool_price_per_level(shovel, Lvl_s, Price_s)),
                        Next_lvl_s is Lvl_s + 1, Next_price_s is Price_s + 100,
                        asserta(tool_price_per_level(shovel, Next_lvl_s, Next_price_s))
                    ; display_insufficient_gold
                    )
                )
            )
        )
        )
    ; General_option = 0 ->
        display_exit_message, retract(is_in_marketplace(yes)), asserta(is_in_marketplace(no)).


/* Pesan ketika mengunjungi marketplace */
display_marketplace_welcome :-
    writeln('|------------------------------------------|'),
    writeln('|        Welcome To The Marketplace        |'),
    writeln('|------------------------------------------|'),
    nl,
    writeln('Are you interested in something?'),
    writeln('[1] I want to buy something.'),
    writeln('[2] I want to sell something'),
    writeln('[0] Cancel.'), nl.


/* Tampilan buy */
display_marketplace_buy :-
    writeln('|------------------------------------------|'),
    writeln('|             Buy Items/Tools              |'),
    writeln('|------------------------------------------|'), 
    nl,
    writeln('Which items or tools do you want to buy?'),
    writeln('[1] Fish Bait            | 30   gold'),
    writeln('[2] Corn Seed            | 50   gold'),
    writeln('[3] Rice Seed            | 50   gold'),
    writeln('[4] Wheat Seed           | 50   gold'),
    writeln('[5] Chicken              | 500  gold'),
    writeln('[6] Sheep                | 1000 gold'),
    writeln('[7] Cow                  | 1500 gold'),

    tool_price_per_level(fishing_rod, Lvl_fr, Price_fr), tool_price_per_level(shovel, Lvl_s, Price_s),
    (Lvl_fr =< 5 -> 
        (Lvl_s =< 5 ->
            format('[8] Level ~d Shovel       | ~d gold', [Lvl_s, Price_s]), nl,
            format('[9] Level ~d Fishing Rod  | ~d gold', [Lvl_fr, Price_fr]), nl, nl,
            writeln('[0] Cancel                          '), nl
        ;   format('[8] Level ~d Fishing Rod  | ~d gold', [Lvl_fr, Price_fr]), nl, nl,
            writeln('[0] Cancel                          '), nl)
    ; Lvl_s =< 5 ->
        format('[8] Level ~d Shovel       | ~d gold', [Lvl_s, Price_s]), nl, nl,
        writeln('[0] Cancel                          '), nl)
    ; nl, writeln('[0] Cancel                          '), nl.


/* Tampilan keluar */
display_exit_message :- writeln('Alright! This marketplace will be at your service anytime.').


/* Mengubah jumlah gold */
update_gold(New_number):- retract(gold(X,_)), asserta(gold(X, New_number)).


/* Tampilan jika uang tidak cukup */
display_insufficient_gold :- writeln('Sorry, you don\'t have enough gold.').