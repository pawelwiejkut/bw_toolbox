"! <p class="shorttext synchronized" lang="en">BW Toolbox</p>
class ycl_bw_tools definition
  public
  final
  create public .

  public section.

    types:
      begin of ty_paramv,
        param type string,
        value type string,
      end of ty_paramv .

    types:
      begin of ty_pcstat,
        chain_id       type string,
        variante       type string,
        starttimestamp type timestamp,
        endtimestamp   type timestamp,
        runtime        type integer,
      end of ty_pcstat.

    types:
      t_ty_paramv type standard table of ty_paramv,
      t_ty_pcstat type standard table of ty_pcstat,
      t_rdate     type range of sy-datum.

    "! <p class="shorttext synchronized" lang="en">Get end of month date</p>
    "!
    "! @parameter iv_date | <p class="shorttext synchronized" lang="en">Date using to get end of month from</p>
    "! @parameter rv_eom  | <p class="shorttext synchronized" lang="en">End of month date return</p>
    class-methods  get_eom_date
      importing !iv_date      type sy-datum
      returning value(rv_eom) type sy-datum
      raising   ycx_bw_error.

    "! <p class="shorttext synchronized" lang="en">Check authorization for file open</p>
    "!
    "! @parameter iv_path | <p class="shorttext synchronized" lang="en">Full text path for file</p>
    "! @parameter rv_cb_opened | <p class="shorttext synchronized" lang="en">Could file be opened by user?</p>
    class-methods check_open_file_auth
      importing !iv_path            type string
      returning value(rv_cb_opened) type boolean
      raising   ycx_bw_error.

    "! <p class="shorttext synchronized" lang="en">Dynamic run of function module</p>
    "!
    "! @parameter iv_funcna | <p class="shorttext synchronized" lang="en">Function name</p>
    "! @parameter it_param | <p class="shorttext synchronized" lang="en">Parameter name and value</p>
    class-methods run_function_module
      importing
        !iv_funcna type string
        !it_param  type t_ty_paramv.

    "! <p class="shorttext synchronized" lang="en">Remove whitespace from string</p>
    "!
    "! @parameter iv_string | <p class="shorttext synchronized" lang="en">String contains white space</p>
    "! @parameter rv_cstring | <p class="shorttext synchronized" lang="en">Cleared string</p>
    class-methods remove_whitespaces
      importing !iv_string        type string
      returning value(rv_cstring) type string.

    "! <p class="shorttext synchronized" lang="en">Remove newline charters from string</p>
    "!
    "! @parameter iv_string | <p class="shorttext synchronized" lang="en">String contains newline charters</p>
    "! @parameter rv_cstring | <p class="shorttext synchronized" lang="en">Cleared string</p>
    class-methods remove_newline
      importing !iv_string        type string
      returning value(rv_cstring) type string.

    "! <p class="shorttext synchronized" lang="en">Check ustate status of request</p>
    "!
    "! @parameter iv_requid | <p class="shorttext synchronized" lang="en"></p>
    "! @parameter rv_status | <p class="shorttext synchronized" lang="en"></p>
    class-methods check_req_status
      importing !iv_requid       type rsbkrequid
      returning value(rv_status) type  rsbkustate.

    "! <p class="shorttext synchronized" lang="en">Check process chain statistics</p>
    "!
    "! @parameter iv_variant | <p class="shorttext synchronized" lang="en"></p>
    "! @parameter iv_processchain | <p class="shorttext synchronized" lang="en"></p>
    "! @parameter is_date | <p class="shorttext synchronized" lang="en"></p>
    "! @parameter et_stats | <p class="shorttext synchronized" lang="en"></p>
    "! @parameter es_stats | <p class="shorttext synchronized" lang="en"></p>
    class-methods check_statistics
      importing !iv_variant      type string
                !iv_processchain type string
                !it_date         type t_rdate
      exporting et_stats         type t_ty_pcstat
                es_stats         type ty_pcstat.


  protected section.
  private section.
endclass.



class ycl_bw_tools implementation.


  method check_open_file_auth.

    rv_cb_opened = abap_true.

    try.
        open dataset iv_path for output in binary mode.
        if sy-subrc <> 0.
          rv_cb_opened = abap_false.
        endif.
      catch cx_sy_file_authority.
        rv_cb_opened = abap_false.
      catch cx_root.
        rv_cb_opened = abap_false.
        raise exception type ycx_bw_error.
    endtry.

  endmethod.


  method check_req_status.

    data lo_req type ref to cl_rsbk_request.

    lo_req = new #( i_requid  =  iv_requid ) .

    rv_status = lo_req->get_ustate( ).

  endmethod.


  method check_statistics.
    constants lc_minute type i value 60.


    select chain_id,chain~variante,starttimestamp,endtimestamp
      into corresponding fields of table @et_stats
      from rspcchain as chain
      inner join rspcprocesslog as log
      on chain~variante = log~variante
      where chain~chain_id = @iv_processchain
      and chain~variante = @iv_variant
      and log~batchdate in @it_date
      and chain~objvers = 'A'.

    loop at et_stats assigning field-symbol(<ls_stats>).

      try.
          <ls_stats>-runtime = cl_abap_tstmp=>subtract(
              tstmp1                     =  <ls_stats>-endtimestamp
              tstmp2                     =  <ls_stats>-starttimestamp ).

          <ls_stats>-runtime  = <ls_stats>-runtime  / lc_minute.

        catch cx_parameter_invalid_range.    "TO-DO Log message

        catch cx_parameter_invalid_type.    "TO-DO Log message

      endtry.

      at last.
        es_stats = <ls_stats>.
      endat.

    endloop.

    data(lv_avg) = reduce i( init a = 0 for ls_stats in et_stats
                         next a = a + ls_stats-runtime ) / lines( et_stats ).

    es_stats-runtime = lv_avg.

  endmethod.


  method get_eom_date.

    call function 'SN_LAST_DAY_OF_MONTH'
      exporting
        day_in       = iv_date
      importing
        end_of_month = rv_eom.

  endmethod.


  method remove_newline.

    data(lv_string) = iv_string.
    replace all occurrences of regex '\n' in lv_string with ''.
    replace all occurrences of regex '\r' in lv_string with ''.
    replace all occurrences of cl_abap_char_utilities=>newline in lv_string with ''.
    rv_cstring = lv_string.

  endmethod.


  method remove_whitespaces.

    data(lv_string) = iv_string.
    replace all occurrences of regex '[[:blank:]]' in lv_string with ''.
    rv_cstring = lv_string.

  endmethod.


  method run_function_module.

    types: begin of  t_itab,
             parameter type string,
             structure type string,
             object    type ref to cl_abap_datadescr,
           end of t_itab.

    data: lt_params type standard table of t_itab,
          lt_imppar type abap_func_parmbind_tab,
          ls_imppar type abap_func_parmbind,
          lr_data   type ref to data.

    "Get importing parameters and it's structure of function module
    select parameter, structure
      from fupararef
      into corresponding fields of table @lt_params
      where funcname = @iv_funcna.

    "Assign reference to all object
    loop at lt_params assigning field-symbol(<ls_params>).
      <ls_params>-object ?= cl_abap_datadescr=>describe_by_name( <ls_params>-structure ).
    endloop.

    "Create parameter table
    loop at it_param assigning field-symbol(<ls_parval>).

      ls_imppar-kind = abap_func_importing.
      ls_imppar-name = <ls_parval>-param.
      "Get reference and create data
      read table lt_params with key parameter = <ls_parval>-param assigning field-symbol(<ls_object>).
      check <ls_object> is not initial.
      create data lr_data type handle <ls_object>-object.
      assign lr_data->* to field-symbol(<lg_object>).
      "Assign value passed from import parameters to field symbol
      <lg_object> =  <ls_parval>-value.
      ls_imppar-value = ref #( <lg_object> ).

      insert ls_imppar into table lt_imppar.

    endloop.
    "Call every function with every parameter
    call function iv_funcna parameter-table lt_imppar.

  endmethod.
endclass.
