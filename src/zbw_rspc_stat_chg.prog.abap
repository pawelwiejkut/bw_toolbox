*&---------------------------------------------------------------------*
*& Report zbw_rspc_finish
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbw_rspc_stat_chg.

SELECTION-SCREEN COMMENT 1(74) TEXT-001.

PARAMETERS:
  pa_logid TYPE rspc_logid,
  pa_type  TYPE rspc_type,
  pa_var   TYPE rspc_variant,
  pa_inst  TYPE rspc_instance,
  pa_stat  AS LISTBOX TYPE rspc_state OBLIGATORY DEFAULT 'G' VISIBLE LENGTH 30.


CALL FUNCTION 'RSPC_PROCESS_FINISH'
  EXPORTING
    i_logid         = pa_logid
    i_type          = pa_type
    i_variant       = pa_var
    i_instance      = pa_inst
    i_state         = pa_stat
    i_dump_at_error = abap_true.
