*&---------------------------------------------------------------------*
*& Report zbw_toolbox
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbw_toolbox.

TABLES sscrfields.

SELECTION-SCREEN BEGIN OF SCREEN 100 AS SUBSCREEN.
PARAMETERS: p1    TYPE c LENGTH 10,
            p2 TYPE c LENGTH 10,
            p3 TYPE c LENGTH 10.
SELECTION-SCREEN END OF SCREEN 100.

SELECTION-SCREEN BEGIN OF SCREEN 200 AS SUBSCREEN.
PARAMETERS: q1 TYPE c LENGTH 10,
            q2 TYPE c LENGTH 10,
            q3 TYPE c LENGTH 10.
SELECTION-SCREEN END OF SCREEN 200.

SELECTION-SCREEN: BEGIN OF TABBED BLOCK mytab FOR 10 LINES,
                  TAB (20) button1 USER-COMMAND push1,
                  TAB (20) button2 USER-COMMAND push2,
                  END OF BLOCK mytab.

INITIALIZATION.
  button1 = 'Selection Screen 1'.
  button2 = 'Selection Screen 2'.
  mytab-prog = sy-repid.
  mytab-dynnr = 100.
  mytab-activetab = 'PUSH1'.

AT SELECTION-SCREEN.
  CASE sy-dynnr.
    WHEN 1000.
      CASE sscrfields-ucomm.
        WHEN 'PUSH1'.
          mytab-dynnr = 100.
        WHEN 'PUSH2'.
          mytab-dynnr = 200.
        WHEN OTHERS.
        ...
      ENDCASE.
      ...
  ENDCASE.
