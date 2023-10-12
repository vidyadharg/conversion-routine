CLASS zcl_convexit DEFINITION
  PUBLIC
  CREATE PRIVATE .

  PUBLIC SECTION.
    INTERFACES zif_convexit.

    ALIASES in
      FOR zif_convexit~in.

    ALIASES out
      FOR zif_convexit~out.

    CLASS-METHODS create
      IMPORTING
        convexit          TYPE convexit OPTIONAL
      RETURNING
        VALUE(r_convexit) TYPE REF TO zcl_convexit
        RAISING   zcx_convexit.

    METHODS constructor
      IMPORTING
        convexit TYPE convexit
        RAISING   zcx_convexit.

  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS:
      get_fnam
        IMPORTING
          input         TYPE any
          in_out        TYPE char1 DEFAULT 'I'
          convexit      TYPE convexit OPTIONAL
        RETURNING
          VALUE(fm_nam) TYPE rs38l_fnam
          RAISING   zcx_convexit,

      call_fm
        IMPORTING
          input         TYPE any
          in_out        TYPE char1 DEFAULT 'I'
        RETURNING
          VALUE(output) TYPE string
          RAISING   zcx_convexit.

    CONSTANTS:
      BEGIN OF gc,
        in  TYPE c LENGTH 1 VALUE 'I',
        out TYPE c LENGTH 1 VALUE 'O',
      END OF gc.
    DATA default_convexit TYPE convexit.
ENDCLASS.



CLASS zcl_convexit IMPLEMENTATION.

  METHOD call_fm.

    DATA(fm_nam) = get_fnam( input = input in_out = in_out ).

    IF fm_nam IS NOT INITIAL.
      CALL FUNCTION fm_nam  " Function Module Name
        EXPORTING
          input     = input       " Input
        IMPORTING
          output    = output      " Output
        EXCEPTIONS
          not_found = 1
          OTHERS    = 2.
      IF sy-subrc <> 0.
        zcx_convexit=>raise_t100( iv_longtext = |FM { fm_nam }/Value { input }| ).
      ENDIF.
    ELSE.
      output = input.
    ENDIF.
  ENDMETHOD.

  METHOD constructor.
    default_convexit = convexit.
  ENDMETHOD.

  METHOD create.
    r_convexit = NEW zcl_convexit( convexit ).
  ENDMETHOD.

  METHOD get_fnam.

    DATA lv_convexit TYPE convexit.

    IF convexit IS SUPPLIED.
      lv_convexit = convexit.
    ELSEIF default_convexit IS NOT INITIAL .
      lv_convexit = default_convexit.
    ELSE.

      DATA(ddic_object) = cl_abap_typedescr=>describe_by_data( input ).

      ddic_object->get_ddic_object(
        RECEIVING
         p_object     = DATA(ddic_tab)
        EXCEPTIONS
          not_found    = 1
          no_ddic_type = 2
          OTHERS       = 3 ).
      IF sy-subrc = 0 .
        DATA(ls_ddic_tab) = VALUE #( ddic_tab[ 1 ] DEFAULT space ).
        lv_convexit = ls_ddic_tab-convexit.
      ENDIF.
    ENDIF.

*    IF lv_convexit IS INITIAL.
*      lv_convexit = 'ALPHA'.
*    ENDIF.
    IF lv_convexit IS NOT INITIAL.
      IF in_out = 'I'.
        fm_nam = 'CONVERSION_EXIT_' && lv_convexit && '_INPUT'.
      ELSE.
        fm_nam = 'CONVERSION_EXIT_' && lv_convexit && '_OUTPUT'.
      ENDIF.

      CALL FUNCTION 'FUNCTION_EXISTS'
        EXPORTING
          funcname           = fm_nam           " Name of Function Module
        EXCEPTIONS
          function_not_exist = 1                " X
          OTHERS             = 2.
      IF sy-subrc <> 0.
        CLEAR fm_nam.
      ENDIF.
    ENDIF.

  ENDMETHOD.

  METHOD in.

    IF quom IS SUPPLIED.
      "Quantity. in-progress
    ELSEIF curkey IS SUPPLIED.
      "Currency. in-progress
    ELSE.
      output = call_fm( input = input
                        in_out = gc-in ).
    ENDIF.
  ENDMETHOD.

  METHOD out.
    IF quom IS SUPPLIED.
      "Quantity.in-progress
    ELSEIF curkey IS SUPPLIED.
      "Currency. in-progress
    ELSE.
      output = call_fm( input = input
                        in_out = gc-out ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
