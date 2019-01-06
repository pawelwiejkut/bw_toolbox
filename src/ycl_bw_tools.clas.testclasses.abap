CLASS ltcl_tools_tesing DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:
      get_eom_test FOR TESTING RAISING cx_static_check,
      open_file_auth_test FOR TESTING RAISING cx_static_check,
      remove_whitespaces_test FOR TESTING RAISING cx_static_check,
      remove_newline_test FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltcl_tools_tesing IMPLEMENTATION.

  METHOD get_eom_test.

    DATA: lv_ceom TYPE sy-datum.
    lv_ceom = '20181130'.

    cl_abap_unit_assert=>assert_equals( act = ycl_bw_tools=>get_eom_date( sy-datum )
                                        exp = lv_ceom ).
  ENDMETHOD.

  METHOD open_file_auth_test.

    cl_abap_unit_assert=>assert_equals( act = ycl_bw_tools=>check_open_file_auth(
                                                                 iv_path      = '/usr/sap/NPL/D00/work/available.log' )
                                                                 exp = abap_true ).


  ENDMETHOD.

  METHOD remove_whitespaces_test.

    cl_abap_unit_assert=>assert_equals( act = ycl_bw_tools=>remove_whitespaces( iv_string = '      test'  )
                                                                                exp = 'test' ).

  ENDMETHOD.

  METHOD remove_newline_test.

  DATA(lv_tsring) = |test{ cl_abap_char_utilities=>newline }|.

  cl_abap_unit_assert=>assert_equals( act = ycl_bw_tools=>remove_newline( iv_string = lv_tsring )
                                                                                exp = 'test' ).

  ENDMETHOD.

ENDCLASS.
