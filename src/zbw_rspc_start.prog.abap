*&---------------------------------------------------------------------*
*& Report zbw_rspc_start
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbw_rspc_start.

PARAMETERS pa_chain TYPE rspc_chain .

CALL FUNCTION 'RSPC_API_CHAIN_START'
  EXPORTING
    i_chain = pa_chain
  EXCEPTIONS
    failed  = 1
    OTHERS  = 2.

IF sy-subrc <> 0.
  MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
ELSE.
  MESSAGE text-001 TYPE 'S'.
ENDIF.
