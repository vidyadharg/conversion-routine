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

TYPES:
  BEGIN OF ty_wbs,
  zuonr TYPE bseg-zuonr,
  wbs   TYPE bseg-projk,
  END OF ty_wbs,
  tt_wbs TYPE STANDARD TABLE OF ty_wbs.
  DATA lt_wbs TYPE tt_wbs.
  DATA(convexit_wbs) = zcl_convexit=>create( convexit  = 'ABPSP' ).

  LOOP AT lt_wbs ASSIGNING FIELD-SYMBOL(<fs_wbs>).
    TRY.
      <fs_wbs>-wbs = convexit_wbs->in( <fs_wbs>-zuonr ).
    CATCH zcx_convexit INTO DATA(lcx_convexit).
      MESSAGE lcx_convexit TYPE 'S'.
      MESSAGE lcx_convexit->mv_longtext TYPE 'S'.
    ENDTRY.
  ENDLOOP.

  data(lv_lifnr) = '0000000123'.
  lv_lifnr = convexit_wbs->out( input = lv_lifnr convexit  = 'ALPHA' )
```
