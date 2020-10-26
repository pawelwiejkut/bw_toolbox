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

parameters: p_user type xubname obligatory.

data: lt_return type table of bapiret2.

select single uflag
  from usr02
  into @data(lv_uflag)
 where bname = @p_user.

if sy-subrc = 0 and lv_uflag = 128.
  call function 'BAPI_USER_UNLOCK'
    exporting
      username = p_user
    tables
      return   = lt_return.
endif.
