"! <p class="shorttext synchronized" lang="en">BW Tools</p>
CLASS ycl_bw_tools DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    "! <p class="shorttext synchronized" lang="en">Get end of month date</p>
    "!
    "! @parameter iv_date | <p class="shorttext synchronized" lang="en">Date using to get end of month from</p>
    "! @parameter rv_eom  | <p class="shorttext synchronized" lang="en">End of month date return</p>
    CLASS-METHODS  get_eom_date
      IMPORTING !iv_date      TYPE sy-datum
      RETURNING VALUE(rv_eom) TYPE sy-datum
      RAISING   ycx_bw_error.

    "! <p class="shorttext synchronized" lang="en">Check authorization for file open</p>
    "!
    "! @parameter iv_path | <p class="shorttext synchronized" lang="en">Full text path for file</p>
    "! @parameter rv_cb_opened | <p class="shorttext synchronized" lang="en">Could file be opened by user?</p>
    CLASS-METHODS check_open_file_auth
      IMPORTING !iv_path            TYPE string
      RETURNING VALUE(rv_cb_opened) TYPE boolean
      RAISING   ycx_bw_error.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS YCL_BW_TOOLS IMPLEMENTATION.


  METHOD check_open_file_auth.

  rv_cb_opened = abap_true.

    TRY.
        OPEN DATASET iv_path FOR OUTPUT IN BINARY MODE.
        IF sy-subrc <> 0.
          rv_cb_opened = abap_false.
        ENDIF.
      CATCH cx_sy_file_authority.
        rv_cb_opened = abap_false.
      CATCH cx_root.
        rv_cb_opened = abap_false.
        RAISE EXCEPTION TYPE ycx_bw_error.
    ENDTRY.

  ENDMETHOD.


  METHOD get_eom_date.

    CALL FUNCTION 'SLS_MISC_GET_LAST_DAY_OF_MONTH'
      EXPORTING
        day_in            = iv_date
      IMPORTING
        last_day_of_month = rv_eom
      EXCEPTIONS
        day_in_not_valid  = 1
        OTHERS            = 2.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE ycx_bw_error.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
