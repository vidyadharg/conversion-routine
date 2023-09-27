# conversion-routine
SAP one method for conversion routine.

```
DATA(convexit) = zcl_convexit=>create( ).

DATA:
  lv_kunnr TYPE kunnr,
  lv_matnr TYPE matnr.

  lv_matnr = '00000000000000123'.
  lv_matnr = convexit->out( lv_matnr ) .

  lv_matnr = '123'.
  lv_matnr = convexit->in( lv_matnr ) .

  lv_kunnr = '0000000123'.
  lv_kunnr = convexit->out( lv_knunr ) .

  lv_kunnr = '123'.
  lv_kunnr = convexit->in( lv_kunnr ) .

```
