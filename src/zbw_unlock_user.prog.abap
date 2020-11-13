**********************************************************************
* Author: T.Meyer, https://www.reyemsaibot.com 21.10.2020
**********************************************************************
*
* Unlock User if no access to SU01
*
**********************************************************************
* Change log
**********************************************************************
* 21.10.20 TM initial version
**********************************************************************
REPORT zbw_unlock_user.

PARAMETERS: p_user TYPE usr02-bname OBLIGATORY.

DATA: lt_return   TYPE TABLE OF bapiret2,
      lv_username TYPE xubname.

SELECT SINGLE uflag
  FROM usr02
  INTO @DATA(lv_uflag)
 WHERE bname = @p_user.

IF sy-subrc = 0 AND lv_uflag = 128.

  lv_username = p_user.

  CALL FUNCTION 'BAPI_USER_UNLOCK'
    EXPORTING
      username = lv_username
    TABLES
      return   = lt_return.

  LOOP AT lt_return REFERENCE INTO DATA(lr_return).
    MESSAGE lr_return->message TYPE lr_return->type.
  ENDLOOP.

ELSE.
  MESSAGE 'User not locked due to incorrect logins' TYPE 'I'.
ENDIF.
