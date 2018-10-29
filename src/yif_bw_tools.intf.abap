INTERFACE yif_bw_tools
  PUBLIC .

  METHODS: get_eom
    IMPORTING !iv_date      TYPE sy-datum
    RETURNING VALUE(rv_eom) TYPE sy-datum.

ENDINTERFACE.
