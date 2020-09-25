CLASS zcl_bw_tools_gui DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    "! <p class="shorttext synchronized" lang="en">Change DTP request status</p>
    "!
    "! @parameter requset_id | <p class="shorttext synchronized" lang="en">Request id</p>
    METHODS change_request_status
      IMPORTING requset_id TYPE int4.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS zcl_bw_tools_gui IMPLEMENTATION.

  METHOD change_request_status.
    TRY.
        CALL FUNCTION 'RSBM_GUI_CHANGE_USTATE'
          EXPORTING
            i_requid = requset_id.
      CATCH cx_rs_not_found.
        MESSAGE 'Request not found' TYPE 'E'.
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
