CLASS ltcl_tools_tesing DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:
      get_eom_test FOR TESTING RAISING cx_static_check,
      open_file_auth_test FOR TESTING RAISING cx_static_check,
      remove_whitespaces_test FOR TESTING RAISING cx_static_check,
      remove_newline_test FOR TESTING RAISING cx_static_check,
      check_statistics_test FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltcl_tools_tesing IMPLEMENTATION.

  METHOD get_eom_test.

    DATA(lv_date_example) = conv sy-datum( '20181129' ).
    DATA(lv_ceom) = conv sy-datum( '20181130' ).

    cl_abap_unit_assert=>assert_equals( act = zcl_bw_tools=>get_eom_date( lv_date_example )
                                        exp = lv_ceom ).
  ENDMETHOD.

  METHOD open_file_auth_test.

    cl_abap_unit_assert=>assert_equals( act = zcl_bw_tools=>check_open_file_auth(
      iv_path      = '/usr/sap/NPL/D00/work/available.log' )
      exp = abap_true ).


  ENDMETHOD.

  METHOD remove_whitespaces_test.

    cl_abap_unit_assert=>assert_equals( act = zcl_bw_tools=>remove_whitespaces(
      iv_string = '      test'  )
      exp = 'test' ).

  ENDMETHOD.

  METHOD remove_newline_test.

    DATA(lv_tsring) = |test{ cl_abap_char_utilities=>newline }|.

    cl_abap_unit_assert=>assert_equals( act = zcl_bw_tools=>remove_newline(
      iv_string = lv_tsring )
      exp = 'test' ).

  ENDMETHOD.

  METHOD check_statistics_test.

    DATA lt_date TYPE RANGE OF sy-datum.

    lt_date = VALUE #( ( sign = 'I' option = 'BT' low = '20180101' high = '99999999' ) ).

    zcl_bw_tools=>check_statistics( EXPORTING
                                    it_date = lt_date
                                    iv_processchain = 'TEST_PC'
                                    iv_variant = 'ZPAK_BY40S1EJACIMADX9V3D2SKQH1'
                                    IMPORTING
                                    es_stats = DATA(ls_stats) ).


    cl_abap_unit_assert=>assert_equals(
        act                  =  ls_stats
        exp                  =  ls_stats ).

  ENDMETHOD.

ENDCLASS.
