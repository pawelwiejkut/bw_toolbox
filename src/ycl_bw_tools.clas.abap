"! <p class="shorttext synchronized" lang="en">BW Tools</p>
CLASS ycl_bw_tools DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      BEGIN OF ty_paramv,
        param TYPE string,
        value TYPE string,
      END OF ty_paramv .

    TYPES:
      BEGIN OF ty_pcstat,
        chain_id       TYPE string,
        variante       TYPE string,
        starttimestamp TYPE timestamp,
        endtimestamp   TYPE timestamp,
        runtime        TYPE integer,
      END OF ty_pcstat.

    TYPES:
      t_ty_paramv TYPE STANDARD TABLE OF ty_paramv,
      t_ty_pcstat TYPE STANDARD TABLE OF ty_pcstat,
      t_rdate     TYPE RANGE OF sy-datum.

    "! <p class="shorttext synchronized" lang="en">Get end of month date</p>
    "!
    "! @parameter iv_date | <p class="shorttext synchronized" lang="en">Date using to get end of month from</p>
    "! @parameter rv_eom  | <p class="shorttext synchronized" lang="en">End of month date return</p>
    CLASS-METHODS  get_eom_date
      IMPORTING !iv_date      TYPE sy-datum
      RETURNING VALUE(rv_eom) TYPE sy-datum
      RAISING   ycx_bw_error.

    "! <p class="shorttext synchronized" lang="en">Check authorization for file open</p>
    "!
    "! @parameter iv_path | <p class="shorttext synchronized" lang="en">Full text path for file</p>
    "! @parameter rv_cb_opened | <p class="shorttext synchronized" lang="en">Could file be opened by user?</p>
    CLASS-METHODS check_open_file_auth
      IMPORTING !iv_path            TYPE string
      RETURNING VALUE(rv_cb_opened) TYPE boolean
      RAISING   ycx_bw_error.

    "! <p class="shorttext synchronized" lang="en">Dynamic run of function module</p>
    "!
    "! @parameter iv_funcna | <p class="shorttext synchronized" lang="en">Function name</p>
    "! @parameter it_param | <p class="shorttext synchronized" lang="en">Parameter name and value</p>
    CLASS-METHODS run_function_module
      IMPORTING
        !iv_funcna TYPE string
        !it_param  TYPE t_ty_paramv.

    "! <p class="shorttext synchronized" lang="en">Remove whitespace from string</p>
    "!
    "! @parameter iv_string | <p class="shorttext synchronized" lang="en">String contains white space</p>
    "! @parameter rv_cstring | <p class="shorttext synchronized" lang="en">Cleared string</p>
    CLASS-METHODS remove_whitespaces
      IMPORTING !iv_string        TYPE string
      RETURNING VALUE(rv_cstring) TYPE string.

    "! <p class="shorttext synchronized" lang="en">Remove newline charters from string</p>
    "!
    "! @parameter iv_string | <p class="shorttext synchronized" lang="en">String contains newline charters</p>
    "! @parameter rv_cstring | <p class="shorttext synchronized" lang="en">Cleared string</p>
    CLASS-METHODS remove_newline
      IMPORTING !iv_string        TYPE string
      RETURNING VALUE(rv_cstring) TYPE string.

    "! <p class="shorttext synchronized" lang="en">Check ustate status of request</p>
    "!
    "! @parameter iv_requid | <p class="shorttext synchronized" lang="en"></p>
    "! @parameter rv_status | <p class="shorttext synchronized" lang="en"></p>
    CLASS-METHODS check_req_status
      IMPORTING !iv_requid       TYPE rsbkrequid
      RETURNING VALUE(rv_status) TYPE  rsbkustate.

    "! <p class="shorttext synchronized" lang="en">Check process chain statistics</p>
    "!
    "! @parameter iv_variant | <p class="shorttext synchronized" lang="en"></p>
    "! @parameter iv_processchain | <p class="shorttext synchronized" lang="en"></p>
    "! @parameter is_date | <p class="shorttext synchronized" lang="en"></p>
    "! @parameter et_stats | <p class="shorttext synchronized" lang="en"></p>
    "! @parameter es_stats | <p class="shorttext synchronized" lang="en"></p>
    CLASS-METHODS check_statistics
      IMPORTING !iv_variant      TYPE string
                !iv_processchain TYPE string
                !is_date         TYPE t_rdate
      EXPORTING et_stats         TYPE t_ty_pcstat
                es_stats         TYPE ty_pcstat.


  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ycl_bw_tools IMPLEMENTATION.

  METHOD run_function_module.

    TYPES: BEGIN OF  t_itab,
             parameter TYPE string,
             structure TYPE string,
             object    TYPE REF TO cl_abap_datadescr,
           END OF t_itab.

    DATA: lt_params TYPE STANDARD TABLE OF t_itab,
          lt_imppar TYPE abap_func_parmbind_tab,
          ls_imppar TYPE abap_func_parmbind,
          lr_data   TYPE REF TO data.

    "Get importing parameters and it's structure of function module
    SELECT parameter, structure
    FROM fupararef
    INTO CORRESPONDING FIELDS OF TABLE @lt_params
    WHERE funcname = @iv_funcna.

    "Assign reference to all object
    LOOP AT lt_params ASSIGNING FIELD-SYMBOL(<ls_params>).
      <ls_params>-object ?= cl_abap_datadescr=>describe_by_name( <ls_params>-structure ).
    ENDLOOP.

    "Create parameter table
    LOOP AT it_param ASSIGNING FIELD-SYMBOL(<ls_parval>).

      ls_imppar-kind = abap_func_importing.
      ls_imppar-name = <ls_parval>-param.
      "Get reference and create data
      READ TABLE lt_params WITH KEY parameter = <ls_parval>-param ASSIGNING FIELD-SYMBOL(<lr_object>).
      CHECK <lr_object> IS NOT INITIAL.
      CREATE DATA lr_data TYPE HANDLE <lr_object>-object.
      ASSIGN lr_data->* TO FIELD-SYMBOL(<lv_object>).
      "Assign value passed from import parameters to field symbol
      <lv_object> =  <ls_parval>-value.
      ls_imppar-value = REF #( <lv_object> ).

      INSERT ls_imppar INTO TABLE lt_imppar.

    ENDLOOP.
    "Call every function with every parameter
    CALL FUNCTION iv_funcna PARAMETER-TABLE lt_imppar.

  ENDMETHOD.


  METHOD check_open_file_auth.

    rv_cb_opened = abap_true.

    TRY.
        OPEN DATASET iv_path FOR OUTPUT IN BINARY MODE.
        IF sy-subrc <> 0.
          rv_cb_opened = abap_false.
        ENDIF.
      CATCH cx_sy_file_authority.
        rv_cb_opened = abap_false.
      CATCH cx_root.
        rv_cb_opened = abap_false.
        RAISE EXCEPTION TYPE ycx_bw_error.
    ENDTRY.

  ENDMETHOD.


  METHOD get_eom_date.

    CALL FUNCTION 'SLS_MISC_GET_LAST_DAY_OF_MONTH'
      EXPORTING
        day_in            = iv_date
      IMPORTING
        last_day_of_month = rv_eom
      EXCEPTIONS
        day_in_not_valid  = 1
        OTHERS            = 2.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE ycx_bw_error.
    ENDIF.

  ENDMETHOD.

  METHOD remove_whitespaces.

    DATA(lv_string) = iv_string.
    REPLACE ALL OCCURRENCES OF REGEX '[[:blank:]]' IN lv_string WITH ''.
    rv_cstring = lv_string.

  ENDMETHOD.

  METHOD remove_newline.

    DATA(lv_string) = iv_string.
    REPLACE ALL OCCURRENCES OF REGEX '\n' IN lv_string WITH ''.
    REPLACE ALL OCCURRENCES OF REGEX '\r' IN lv_string WITH ''.
    REPLACE ALL OCCURRENCES OF cl_abap_char_utilities=>newline IN lv_string WITH ''.
    rv_cstring = lv_string.

  ENDMETHOD.

  METHOD check_req_status.

    DATA lobj_req TYPE REF TO cl_rsbk_request.

    lobj_req = NEW #( i_requid  =  iv_requid ) .

    rv_status = lobj_req->get_ustate( ).

  ENDMETHOD.

  METHOD check_statistics.


    SELECT chain_id,chain~variante,starttimestamp,endtimestamp
    INTO TABLE @et_stats
    FROM rspcchain AS chain
    INNER JOIN rspcprocesslog AS log
    ON chain~variante = log~variante
    WHERE chain~chain_id = @iv_processchain
    AND chain~variante = @iv_variant
    AND log~batchdate IN @is_date
    AND chain~objvers = 'A'.

    LOOP AT et_stats ASSIGNING FIELD-SYMBOL(<ls_stats>).

      TRY.
          cl_abap_tstmp=>subtract(
            EXPORTING
              tstmp1                     =  <ls_stats>-endtimestamp
              tstmp2                     =  <ls_stats>-starttimestamp
            RECEIVING
              r_secs                     =  <ls_stats>-runtime
          ).

          <ls_stats>-runtime  = <ls_stats>-runtime  / 60.

        CATCH cx_parameter_invalid_range.    "TO-DO Log message

        CATCH cx_parameter_invalid_type.    "TO-DO Log message

      ENDTRY.

      AT LAST.
        MOVE <ls_stats> TO es_stats.
      ENDAT.

    ENDLOOP.

    DATA(lv_avg) = REDUCE i( INIT a = 0 FOR ls_stats IN et_stats
                         NEXT a = a + ls_stats-runtime ) / lines( et_stats ).

    es_stats-runtime = lv_avg.

  ENDMETHOD.

ENDCLASS.
