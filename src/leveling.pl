:- dynamic(overallExp/2).
addOverallExp(X, Value) :-  overallExp(X,Prev), retract(overallExp(X,Prev)),
                            New is Prev+Value, asserta(overallExp(X,New)),
                            levelup(X).

:-dynamic(overallLevel/2)
:-dynamic(maxStamina/2)
levelup(X) :-   overallLevel(X, CurrLevel),
                (overallExp(X, CurrExp)),

                (CurrExp>=(CurrLevel*100 +100) -> 
                retract(overallLevel(X,CurrLevel)),
                asserta(overallLevel(X,CurrLevel+1)),

                maxStamina(X, CurrStamina), retract(maxStamina(X, CurrStamina)),
                asserta(maxStamina(X, CurrStamina+3)),
                ).

selamat malam pak Judhi, mohon maaf mengganggu sebalumny Pak, saya Addin Nabilal Huda(NIM 13520045).
Mohon