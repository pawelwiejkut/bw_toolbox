*&---------------------------------------------------------------------*
*& Report zbw_tools
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbw_tools.

* Define screen 101 as sub-screen
SELECTION-SCREEN BEGIN OF SCREEN 101 AS SUBSCREEN.

PARAMETERS: "activate TRFN RSDG_TRFN_ACTIVATE
  pa_atrf RADIOBUTTON GROUP rad1,
  "activate RSDS RSDS_DATASOURCE_ACTIVATE_ALL
  pa_arsd RADIOBUTTON GROUP rad1,
  "activate DTP RSBKDTPREPAIR
  pa_adtp RADIOBUTTON GROUP rad1,
  "activate HCPR RSDG_HCPR_ACTIVATE
  pa_ahcp RADIOBUTTON GROUP rad1,
  "activate all ADSO requests
  pa_adso RADIOBUTTON GROUP rad1.

SELECTION-SCREEN END OF SCREEN 101.

SELECTION-SCREEN BEGIN OF SCREEN 102 AS SUBSCREEN.

PARAMETERS:
  "change DTP request status zcl_bw_tools_gui->change_request_status
  pa_chgst RADIOBUTTON GROUP rad2,
  "re-import objects rsdg_after_import_for_corr
  pa_reimp RADIOBUTTON GROUP rad2,
  "delete process chain variant zbw_rspc_var_del
  pa_dpvar RADIOBUTTON GROUP rad2,
  "start rspc zbw_rspc_start
  pa_srsp  RADIOBUTTON GROUP rad2,
  "drop oh tables zbw_drop_oh_table
  pa_doh   RADIOBUTTON GROUP rad2,
  "repair iobj RSDG_IOBJ_REORG
  pa_rpiob RADIOBUTTON GROUP rad2,
  "change rspc status based on RSPC_PROCESS_FINISH
  pa_crsp  RADIOBUTTON GROUP rad2,
  "Unlock User
  pa_user  RADIOBUTTON GROUP rad2.

SELECTION-SCREEN END OF SCREEN 102.

SELECTION-SCREEN BEGIN OF TABBED BLOCK t1 FOR 20 LINES.
SELECTION-SCREEN TAB (20) tab1 USER-COMMAND ucomm1 DEFAULT SCREEN 101.
SELECTION-SCREEN TAB (20) tab2 USER-COMMAND ucomm2 DEFAULT SCREEN 102.
SELECTION-SCREEN END OF BLOCK t1.

INITIALIZATION.
  tab1 = TEXT-001.
  tab2 = TEXT-002.

END-OF-SELECTION.

  IF t1-activetab = 'UCOMM1'.

    IF pa_atrf = abap_true.
      SUBMIT rsdg_trfn_activate VIA SELECTION-SCREEN AND RETURN.

    ELSEIF pa_arsd = abap_true.
      SUBMIT rsds_datasource_activate_all VIA SELECTION-SCREEN AND RETURN.

    ELSEIF pa_adtp = abap_true.
      SUBMIT rsbkdtprepair VIA SELECTION-SCREEN AND RETURN.

    ELSEIF pa_ahcp = abap_true.
      SUBMIT rsdg_hcpr_activate VIA SELECTION-SCREEN AND RETURN.
    ELSEIF pa_adso = abap_true.
      SUBMIT zbw_adso_request_act VIA SELECTION-SCREEN AND RETURN.
    ENDIF.
  ELSEIF t1-activetab = 'UCOMM2'.

    IF pa_chgst = abap_true.
      zcl_bw_tools_gui=>change_request_status( ).

    ELSEIF pa_reimp = abap_true.
      SUBMIT rsdg_after_import_for_corr VIA SELECTION-SCREEN AND RETURN.

    ELSEIF pa_dpvar = abap_true.
      SUBMIT zbw_rspc_var_del VIA SELECTION-SCREEN AND RETURN.

    ELSEIF pa_srsp = abap_true.
      SUBMIT zbw_rspc_start VIA SELECTION-SCREEN AND RETURN.

    ELSEIF pa_doh = abap_true.
      SUBMIT zbw_drop_oh_table VIA SELECTION-SCREEN AND RETURN.

    ELSEIF pa_rpiob = abap_true.
      SUBMIT rsdg_iobj_reorg VIA SELECTION-SCREEN AND RETURN.

    ELSEIF pa_crsp = abap_true.
      SUBMIT zbw_rspc_stat_chg VIA SELECTION-SCREEN AND RETURN.
    ELSEIF pa_user = abap_true.
      SUBMIT zbw_unlock_user VIA SELECTION-SCREEN AND RETURN.
    ENDIF.
  ENDIF.
