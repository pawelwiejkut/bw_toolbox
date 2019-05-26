class ltcl_tools_tesing definition final for testing
  duration short
  risk level harmless.

  private section.
    methods:
      get_eom_test for testing raising cx_static_check,
      open_file_auth_test for testing raising cx_static_check,
      remove_whitespaces_test for testing raising cx_static_check,
      remove_newline_test for testing raising cx_static_check,
      check_statistics_test for testing raising cx_static_check.
endclass.


class ltcl_tools_tesing implementation.

  method get_eom_test.

    data: lv_ceom         type sy-datum,
          lv_date_example type sy-datum.
    lv_date_example = '20181129'.
    lv_ceom = '20181130'.

    cl_abap_unit_assert=>assert_equals( act = ycl_bw_tools=>get_eom_date( lv_date_example )
                                        exp = lv_ceom ).
  endmethod.

  method open_file_auth_test.

    cl_abap_unit_assert=>assert_equals( act = ycl_bw_tools=>check_open_file_auth(
      iv_path      = '/usr/sap/NPL/D00/work/available.log' )
      exp = abap_true ).


  endmethod.

  method remove_whitespaces_test.

    cl_abap_unit_assert=>assert_equals( act = ycl_bw_tools=>remove_whitespaces(
      iv_string = '      test'  )
      exp = 'test' ).

  endmethod.

  method remove_newline_test.

    data(lv_tsring) = |test{ cl_abap_char_utilities=>newline }|.

    cl_abap_unit_assert=>assert_equals( act = ycl_bw_tools=>remove_newline(
      iv_string = lv_tsring )
      exp = 'test' ).

  endmethod.

  method check_statistics_test.

    data lt_date type range of sy-datum.

    lt_date = value #( ( sign = 'I' option = 'BT' low = '20180101' high = '99999999' ) ).

    ycl_bw_tools=>check_statistics( exporting
                                    it_date = lt_date
                                    iv_processchain = 'TEST_PC'
                                    iv_variant = 'ZPAK_BY40S1EJACIMADX9V3D2SKQH1'
                                    importing
                                    es_stats = data(ls_stats) ).


    cl_abap_unit_assert=>assert_equals(
        act                  =  ls_stats
        exp                  =  ls_stats ).

  endmethod.

endclass.
