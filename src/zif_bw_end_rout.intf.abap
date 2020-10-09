INTERFACE zif_bw_end_rout
  PUBLIC .

  "! <p class="shorttext synchronized" lang="en">End routine for BW transformations</p>
  "!
  "! @parameter iv_request | <p class="shorttext synchronized" lang="en"> Request ID</p>
  "! @parameter iv_datapackid | <p class="shorttext synchronized" lang="en">Data package ID </p>
  "! @parameter iv_segid | <p class="shorttext synchronized" lang="en"></p>
  "! @parameter it_result_package | <p class="shorttext synchronized" lang="en">Result package income</p>
  "! @parameter et_monitor | <p class="shorttext synchronized" lang="en">Monitor</p>
  "! @parameter et_result_package | <p class="shorttext synchronized" lang="en">Result package outcome</p>
  "! @raising cx_rsrout_abort | <p class="shorttext synchronized" lang="en">Abort exception</p>
  "! @raising cx_rsbk_errorcount | <p class="shorttext synchronized" lang="en">Error count exception</p>
  METHODS start
      IMPORTING
        iv_request        TYPE rsrequest
        iv_datapackid     TYPE rsdatapid
        iv_segid          TYPE rsbk_segid
        it_result_package TYPE ANY TABLE
      EXPORTING
        et_monitor        TYPE rstr_ty_t_monitors
        et_result_package TYPE ANY TABLE
      RAISING
        cx_rsrout_abort
        cx_rsbk_errorcount.

ENDINTERFACE.
