CLASS ycl_bw_tools DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES yif_bw_tools.

    ALIASES get_eom FOR yif_bw_tools~get_eom.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ycl_bw_tools IMPLEMENTATION.

  METHOD get_eom.

    CALL FUNCTION 'SLS_MISC_GET_LAST_DAY_OF_MONTH'
      EXPORTING
        day_in            = iv_date
      IMPORTING
        last_day_of_month = rv_eom
      EXCEPTIONS
        day_in_not_valid  = 1
        OTHERS            = 2.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
