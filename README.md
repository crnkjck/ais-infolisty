XML 2 HTML convertor
=========

Vygeneruje HTML dokumenty zo zdrojovych XML suborov.

## Poziadavky ##
* pripojenie na internet :)
* Python >=2.7.x (starsie verzie nie su otestovane)
* lynx
* wget

Python verzia stahovaca:
* `pip install requests`

## Instalacia ##
Ak su splnene poziadavky vyssie, staci spustit `./update_infolists.sh`, pripadne to spustat v cron-e.

## Dokumentacia ##

Pokus o DTD:

    <!DOCTYPE obsah [
      <!ELEMENT obsah (organizacnaJednotka, informacneListy)>
      <!ELEMENT organizacnaJednotka (#PCDATA)>
      <!ELEMENT informacneListy (informacnyList)*>
      <!ELEMENT informacnyList (#vid nizsie#)>
    ]>

Vsetky elementy v informacnom list su `#PCDATA`. Elementy v tvare _[A-Z]_ obsahuju elementy `<p>`.

### Elementy informacneho listu ###

* `kod`
* `nazov`
* `kredit` (pocet kreditov)
* `sposobUkoncenia` (obsahuje konstantu "Hodnotenie")
* `sposobVyucby` (napr. cvicenie)
* `rozsahTyzdenny` (pocet hodin)
* `rozsahSemestranly` (pocet hodin)
* `obdobie` (?)
* `studijnyProgram`
* `doplnujuceUdaje` (... k studijnemu programu)
* `zabezpecuju` (vyucujuci)
* `garanti`
* `podmienujucePredmety` (aka prerekvizity)
* `vylucujucePredmety`
* `_O_` (obsahova prerekvizita)
* `_P_` (priebezne hodnotenie)
* `_Z_` (zaverecne hodnotenie)
* `_VH_` (vaha hodnotenia, priebezne/zaverecne)
* `_SO_` (strucna osnova predmetu)
* `_C_` (ciel predmetu)
* `_S_` (sylabus)
* `_SO_` (strucna osnova predmetu)
* `_L_` (literatura)
* `jazyk`
* `datumSchvalenia`

