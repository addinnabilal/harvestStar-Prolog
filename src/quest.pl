/** 
 * File: quest.pl
 * 
 * File berisi semua predikat dan rules yang
 * berhubungan dengan quest game.
 */


:- dynamic(is_quest_active/1).
:- dynamic(fish_to_catch/1).
:- dynamic(crop_to_harvest/1).
:- dynamic(product_to_produce/1).
:- dynamic(quest_reward_exp_gold/2).


is_quest_active(no).
fish_to_catch(0).
crop_to_harvest(0).
product_to_produce(0).
quest_reward_exp_gold(0, 0).


/**
 * take_quest untuk mengambil quest
 * otomatis dipanggil ketika menginjak tile Q
 */
take_quest :-
    is_quest_active(Check),
    (Check = yes ->
        write('Sorry, looks like you haven\'t finished your previous work.'), nl,
        write('Please finish it first.'), nl
    ; Check = no ->
        write('Hi, how have you been? There\'s new job from the town hall'),nl,
        write('to increase the production of food, fish, and city livestock.'), nl,
        write('If you\'ve got time to spare, do help our city!'), nl, 
        nl,
        write('[1] Okay, I will help.'), nl,
        write('[0] See you later, then.'), nl, 
        nl,
        write('Pick an option : '), read(Quest_option), nl,
        (Quest_option = 1 ->
            retract(fish_to_catch(_)),
            retract(crop_to_harvest(_)),
            retract(product_to_produce(_)),
            retract(quest_reward_exp_gold(_, _)),
            retract(is_quest_active(no)), asserta(is_quest_active(yes)),
            overallLevel(_X, Char_lvl),
            generate_quest(Char_lvl),
            quest_message,
            nl,
            quest_reward_exp_gold(Exp, Gold),
            write('You\'ll be rewarded '), write(Exp), write(' Exp and '), write(Gold), write(' Golds after finishing this quest!'), nl
        ; Quest_option = 0 ->
            write('Okay, hope you can help later.'), nl
        )
    ).
        

/* Membuat quest berdasarkan overall level */
generate_quest(Level) :-
    (Level = 1 ->
        asserta(fish_to_catch(2)),
        asserta(crop_to_harvest(1)),
        asserta(product_to_produce(1)),
        asserta(quest_reward_exp_gold(50, 250))
    ; Level = 2 ->
        asserta(fish_to_catch(3)),
        asserta(crop_to_harvest(2)),
        asserta(product_to_produce(2)),
        asserta(quest_reward_exp_gold(100, 300))
    ; Level = 3 ->
        asserta(fish_to_catch(4)),
        asserta(crop_to_harvest(3)),
        asserta(product_to_produce(3)),
        asserta(quest_reward_exp_gold(150, 350))
    ; Level = 4 ->
        asserta(fish_to_catch(5)),
        asserta(crop_to_harvest(4)),
        asserta(product_to_produce(4)),
        asserta(quest_reward_exp_gold(200, 400))
    ; Level = 5 ->
        asserta(fish_to_catch(6)),
        asserta(crop_to_harvest(5)),
        asserta(product_to_produce(5)),
        asserta(quest_reward_exp_gold(250, 450))
    ; Level = 6 ->
        asserta(fish_to_catch(7)),
        asserta(crop_to_harvest(6)),
        asserta(product_to_produce(6)),
        asserta(quest_reward_exp_gold(300, 500))
    ; Level = 7 ->
        asserta(fish_to_catch(8)),
        asserta(crop_to_harvest(7)),
        asserta(product_to_produce(7)),
        asserta(quest_reward_exp_gold(350, 550))
    ; Level = 8 ->
        asserta(fish_to_catch(9)),
        asserta(crop_to_harvest(8)),
        asserta(product_to_produce(8)),
        asserta(quest_reward_exp_gold(400, 600))
    ; Level = 9 ->
        asserta(fish_to_catch(10)),
        asserta(crop_to_harvest(9)),
        asserta(product_to_produce(9)),
        asserta(quest_reward_exp_gold(450, 650))
    ; Level = 10 ->
        asserta(fish_to_catch(11)),
        asserta(crop_to_harvest(10)),
        asserta(product_to_produce(10)),
        asserta(quest_reward_exp_gold(500, 700))
    ).


/* Menampilkan quest fishing */
catch_quest :-
    fish_to_catch(Fish_qty),
    (Fish_qty > 0 ->
        write('    - Catch '), write(Fish_qty), write(' fishes'), nl
    ; Fish_qty < 1 ->
        write('    - Catch 0 fishes'), nl).


/* Menampilkan quest farming */
harvest_quest :-
    crop_to_harvest(Crop_qty),
    (Crop_qty > 0 ->
        write('    - Harvest '), write(Crop_qty), write(' crops'), nl
    ; Crop_qty < 1 ->
        write('    - Harvest 0 crops'), nl).


/* Menampilkan quest ranching */
produce_quest :-
    product_to_produce(Prod_qty),
    (Prod_qty > 0 ->
        write('    - Produce '), write(Prod_qty), write(' livestock products'), nl
    ; Prod_qty < 1 ->
        write('    - Produce 0 livestock products'), nl).


/* Menampilkan quest yang harus dikerjakan */
quest_message :-
    is_quest_active(Check),
    nl,
    (Check = no ->
        write('You don\'t have any quest active at this moment.'), nl
    ; Check = yes ->
        write('To finish the town hall request, please'), nl,
        catch_quest,
        harvest_quest,
        produce_quest
    ).


/* Mengecek apakah quest sudah selesai, dipanggil setiap menyelesaikan activity */
is_quest_finished :-
    is_quest_active(yes),
    crop_to_harvest(Crop_qty), Crop_qty < 1,
    fish_to_catch(Fish_qty), Fish_qty < 1,
    product_to_produce(Prod_qty), Prod_qty < 1,
    update_exp_gold_quest.


/* Mengubah exp dan gold, dipanggil ketika menyelesaikan quest */
update_exp_gold_quest :-
    nl, quest_reward_exp_gold(Exp, Gold),
    write('Thank you for completing town hall request, here is your reward.'), nl,
    gold(X, Balance), New_balance is Balance + Gold, update_gold(New_balance),
    addOverallExp(X, Exp),
    write(Exp), write('Exp has been added.'), nl,
    write(Gold), write('Gold has been added.'), nl,
    retract(is_quest_active(yes)), asserta(is_quest_active(no)).
