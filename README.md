# Couple Breaker

## Purpose

Simple money-owed calculator for the end of the month
Only works for 2 persons

##Usage

2. Just run awk --posix -f couplebreaker.awk ./myfile.tsv

## Format
Input file must be field-separated with following columns: When;Who;What;HowMuch;Personnal;DirectDebt
* Separator chosen doesn't matter. Default is "\t" but you can change it with awf's -F
* "When" field isn't really used for now. But will be, as a filter. Format is ^[0-9]{2}.[0-9]{2}.[0-9]{2,4}
* "Personnal" field means that it's a personnal purchase and shoudn't count for shared expenses
* "DirectDebt" field means that one made a purchase (that shouldn't count for shared expenses) but for the other

##Example
```
$ cat ./myfile.tsv
When    Who     What    HowMuch Personnal       DirectDebt
04/11/2014      Person1 Food    40
07/11/2014      Person2 Bread   2.05
07/11/2014      Person2 Soap    10      x
07/11/2014      Person2 Beer    15              x
06/11/2014      Person1 Loto Win    +200
$
$ awk --posix -f couplebreaker.awk ./myfile.tsv
User         Incomes  Expenses Personnal    Direct     Total
----         -------  -------- ---------    ------     -----
Person1          200        40                         47.05
Person2                   2.05        10        15         0
----         -------  -------- ---------    ------     -----
Total            200     42.05        10        15     47.05
```
So Person1 owe 47.05 to Person2