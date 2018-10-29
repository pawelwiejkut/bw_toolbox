CLASS ltcl_tools_tesing DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:
      get_eom_test FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltcl_tools_tesing IMPLEMENTATION.

  METHOD get_eom_test.

    DATA: lv_ceom TYPE sy-datum.

    lv_ceom = '20181031'.

    cl_abap_unit_assert=>assert_equals( act = NEW ycl_macgyver( )->get_eom( sy-datum )
                                        exp = lv_ceom ).
  ENDMETHOD.

ENDCLASS.
