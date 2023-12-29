INTERFACE zif_convexit
  PUBLIC .

  METHODS in
    IMPORTING
      input         TYPE any
      convexit      TYPE convexit OPTIONAL
      curkey        TYPE WAERS OPTIONAL
      quom          TYPE unit OPTIONAL
    RETURNING
      VALUE(output) TYPE string
    RAISING   zcx_convexit.

  METHODS out
    IMPORTING
      input         TYPE any
      convexit      TYPE convexit OPTIONAL
      curkey        TYPE WAERS OPTIONAL
      quom          TYPE unit OPTIONAL
    RETURNING
      VALUE(output) TYPE string
    RAISING   zcx_convexit.


ENDINTERFACE.
