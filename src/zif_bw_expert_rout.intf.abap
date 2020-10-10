INTERFACE zif_bw_expert_rout
  PUBLIC .

"! <p class="shorttext synchronized" lang="en">Expert routine</p>
"!
"! @parameter iv_request | <p class="shorttext synchronized" lang="en">Request ID</p>
"! @parameter iv_datapackid | <p class="shorttext synchronized" lang="en">Data Package ID</p>
"! @parameter iv_log | <p class="shorttext synchronized" lang="en"></p>
"! @parameter ir_request | <p class="shorttext synchronized" lang="en">Reqest data reference</p>
"! @parameter it_source_package | <p class="shorttext synchronized" lang="en"> Source package</p>
"! @parameter et_result_package | <p class="shorttext synchronized" lang="en">Result package</p>
METHODS expert
    IMPORTING
      iv_request        TYPE rsrequest
      iv_datapackid     TYPE rsdatapid
      iv_log            TYPE REF TO cl_rsbm_log_cursor_step
      ir_request        TYPE REF TO if_rsbk_request_admintab_view
      it_source_package TYPE ANY TABLE
    EXPORTING
      et_result_package TYPE ANY TABLE.

endinterface.
