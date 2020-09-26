CLASS zcl_bw_tools_gui DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    "! <p class="shorttext synchronized" lang="en">Change DTP request status</p>
    CLASS-METHODS change_request_status.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS zcl_bw_tools_gui IMPLEMENTATION.

  METHOD change_request_status.

    DATA: lt_fields TYPE STANDARD TABLE OF sval,
          lv_return TYPE string,
          lv_reqid  TYPE rsbkrequid.

    APPEND VALUE #( tabname = to_upper('rsddstatdtp') fieldname = to_upper('requid')  ) TO lt_fields.

    CALL FUNCTION 'POPUP_GET_VALUES'
      EXPORTING
        popup_title     = 'Request ID'
      IMPORTING
        returncode      = lv_return
      TABLES
        fields          = lt_fields
      EXCEPTIONS
        error_in_fields = 1
        OTHERS          = 2.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    IF lv_return = 'A'.
      EXIT.
    ENDIF.

    lv_reqid = lv_return.

    TRY.
        CALL FUNCTION 'RSBM_GUI_CHANGE_USTATE'
          EXPORTING
            i_requid = lv_reqid.
      CATCH cx_rs_not_found.
        MESSAGE 'Request not found' TYPE 'E'.
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
