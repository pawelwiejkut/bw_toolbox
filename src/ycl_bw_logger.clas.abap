CLASS ycl_bw_logger DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS constructor
      IMPORTING object      TYPE bal_s_log-object
                subobject   TYPE bal_s_log-subobject
                description TYPE bal_s_log-extnumber.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ycl_bw_logger IMPLEMENTATION.

  METHOD constructor.

    DATA header TYPE bal_s_log.

    header-object = object.
    header-subobject = subobject.
    header-extnumber = description.

    CALL FUNCTION 'BAL_LOG_CREATE'
      EXPORTING
        i_s_log = header   " Log header data
*      IMPORTING
*       e_log_handle            =     " Log handle
*      EXCEPTIONS
*       log_header_inconsistent = 1
*       others  = 2
      .
    IF sy-subrc <> 0.
*     MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.


  ENDMETHOD.

ENDCLASS.
