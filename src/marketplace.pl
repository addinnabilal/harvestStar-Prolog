:- dynamic(is_in_marketplace/1).

is_in_marketplace(no).
tool_level(shovel, 4).
tool_level(fishing_rod, 4).
gold(_,300).

visit_marketplace  :- 
    retract(is_in_marketplace(no)), asserta(is_in_marketplace(yes)), 
    display_marketplace_welcome, gold(_,Balance),
    write('Your current money : '), writeln(Balance),
    write('Pick an option : '), read(General_option), nl,

    General_option = 1 -> 
        display_marketplace_buy,
        write('Pick an option : '), read(Buy_option), nl,
        (Buy_option = 1 ->
            (Balance >= 50 ->
                New_balance is Balance - 50,
                update_gold(New_balance),
                save_item(corn_seed)
            ; display_insufficient_gold)
        ; Buy_option = 2 ->
            (Balance >= 50 ->
                New_balance is Balance - 50,
                update_gold(New_balance),
                save_item(rice_seed)
            ; display_insufficient_gold)
        ; Buy_option = 3 ->
            (Balance >= 50 ->
                New_balance is Balance - 50,
                update_gold(New_balance),
                save_item(wheat_seed)
            ; display_insufficient_gold))
    ; General_option = 0 ->
        display_exit_message.


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
    writeln('[1] Corn Seed            | 50   gold'),
    writeln('[2] Rice Seed            | 50   gold'),
    writeln('[3] Wheat Seed           | 50   gold'),
    writeln('[4] Chicken              | 500  gold'),
    writeln('[5] Sheep                | 1000 gold'),
    writeln('[6] Cow                  | 1500 gold'),

    tool_level(fishing_rod, Lvl_fr), tool_level(shovel, Lvl_s),
    (Lvl_fr < 5 -> 
        (Lvl_s < 5 ->
            Next_lvl_fr is Lvl_fr + 1, Next_lvl_s is Lvl_s + 1,
            format('[7] Level ~d Shovel       | 300 gold', [Next_lvl_s]), nl,
            format('[8] Level ~d Fishing Rod  | 500 gold', [Next_lvl_fr]), nl, nl,
            writeln('[0] Cancel                          '), nl
        ; Next_lvl_fr is Lvl_fr + 1,
            format('[7] Level ~d Fishing Rod  | 500 gold', [Nex_lLvl_fr]), nl, nl,
            writeln('[0] Cancel                          '), nl)
    ; Lvl_s < 5 ->
        Next_lvl_s is Lvl_s + 1,
        format('[7] Level ~d Shovel       | 300 gold', [Next_lvl_s]), nl, nl,
        writeln('[0] Cancel                          '), nl)
    ; nl, writeln('[0] Cancel                          '), nl.


/* Tampilan keluar */
display_exit_message :- writeln('Alright! This marketplace will be at your service anytime.').


/* Mengubah jumlah gold */
update_gold(New_number):- retract(gold(X,_)), asserta(gold(X, New_number)).


/* Tampilan jika uang tidak cukup */
display_insufficient_gold :- writeln('Sorry, you don\'t have enough gold.').