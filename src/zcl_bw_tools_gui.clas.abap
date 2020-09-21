CLASS zcl_bw_tools_gui DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS: change_request_status
      IMPORTING requset_id TYPE rsbkrequid.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_bw_tools_gui IMPLEMENTATION.

  METHOD change_request_status.
    CALL FUNCTION 'RSBM_GUI_CHANGE_USTATE'
      EXPORTING
        i_requid = requset_id.
    TRY.
      CATCH cx_rs_not_found.
        MESSAGE 'Request not found' TYPE 'E'.
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
