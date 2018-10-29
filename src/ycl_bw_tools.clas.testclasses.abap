CLASS ltcl_tools_tesing DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:
      get_eom_test FOR TESTING RAISING cx_static_check,
      check_open_file_auth FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltcl_tools_tesing IMPLEMENTATION.

  METHOD get_eom_test.

    DATA: lv_ceom TYPE sy-datum.
    lv_ceom = '20181031'.

    cl_abap_unit_assert=>assert_equals( act = NEW ycl_bw_tools( )->get_eom_date( sy-datum )
                                        exp = lv_ceom ).
  ENDMETHOD.

  METHOD check_open_file_auth.

    cl_abap_unit_assert=>assert_equals( act = NEW ycl_bw_tools( )->check_open_file_auth(
                                                                 iv_path      = '/usr/sap/NPL/D00/work/available.log')
                                                                 exp = abap_true ).


  ENDMETHOD.

ENDCLASS.
