INTERFACE zif_bw_start_rout
  PUBLIC .

  METHODS
    start
      IMPORTING
        iv_request        TYPE rsrequest
        iv_datapackid     TYPE rsdatapid
        iv_segid          TYPE rsbk_segid
        it_source_package TYPE ANY TABLE
      EXPORTING
        et_monitor        TYPE rstr_ty_t_monitors
        et_source_package TYPE ANY TABLE
      RAISING
        cx_rsrout_abort
        cx_rsbk_errorcount.

ENDINTERFACE.
