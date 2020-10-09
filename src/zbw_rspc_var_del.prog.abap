*&---------------------------------------------------------------------*
*& Report zbw_rspc_var_del
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbw_rspc_var_del.

DATA:
  lv_varaint TYPE rspc_variant.

PARAMETERS: pa_type TYPE rspc_type.
SELECT-OPTIONS pa_var  FOR lv_varaint NO INTERVALS.

LOOP AT pa_var REFERENCE INTO DATA(lr_var).
  DATA(l_r_variant) = cl_rspc_variant=>create( i_type      = pa_type
                                               i_variant   = lr_var->low
                                               i_lock      = rs_c_true ).

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4
               RAISING aborted.
  ENDIF.

  l_r_variant->delete(  ).

ENDLOOP.
