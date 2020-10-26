"#autoformat
**********************************************************************
* Author: T.Meyer, https://www.reyemsaibot.com, 19.10.2020
**********************************************************************
*
* Activate all requests of an ADSO
*
**********************************************************************
* Change log
**********************************************************************
* 19.10.20 TM initial version
**********************************************************************
REPORT zbw_adso_request_act.

SELECTION-SCREEN: BEGIN OF BLOCK b1 WITH FRAME.
PARAMETERS:       p_adso TYPE rsoadsonm.
SELECTION-SCREEN: END OF BLOCK b1.


DATA(lr_act_api) = cl_rsdso_activate_api=>create( i_adsonm = p_adso ).
TRY.
    DATA(et_act_req_tsn) = lr_act_api->activate_all( ).
  CATCH cx_rsdso_activation_failed.
    WRITE:/ |Activation failed.|.
ENDTRY.
