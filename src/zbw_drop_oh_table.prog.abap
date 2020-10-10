*&---------------------------------------------------------------------*
*& Report zbw_drop_oh_table
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbw_drop_oh_table.

DATA: lv_ohdest  TYPE rsohdest,
      lv_tabname TYPE tabname.

SELECT-OPTIONS so_odest FOR lv_ohdest NO INTERVALS.
PARAMETERS: pa_test AS CHECKBOX DEFAULT abap_true.

IF pa_test = abap_true.
  MESSAGE 'Program in test mode' TYPE 'S'.
  EXIT.
ENDIF.

END-OF-SELECTION.

  SELECT *
  FROM rsbdbtab
  WHERE ohdest IN @so_odest
  AND objvers = 'A'
  INTO TABLE @DATA(lt_ohtab).

  LOOP AT lt_ohtab REFERENCE INTO DATA(lr_ohtab).

    lv_tabname = lr_ohtab->dbtab.

    CALL FUNCTION 'DB_DROP_TABLE'
      EXPORTING
        tabname               = lv_tabname
        program_not_generated = 1
        program_not_written   = 2
        table_not_dropped     = 3
        others                = 4.

    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

  ENDLOOP.

  MESSAGE 'All tables are dropped' TYPE 'S'.
