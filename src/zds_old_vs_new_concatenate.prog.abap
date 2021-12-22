*&---------------------------------------------------------------------*
*& Report zds_old_vs_new_concatenate
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zds_old_vs_new_concatenate.

set country 'US'.

**********************************************************************
* Old
**********************************************************************
data name type sy-uname.
name = sy-uname.
translate name to lower case.
translate name(1) to upper case.
data date type c length 10.
write sy-datlo to date.
data hour type c length 2.
hour = sy-uzeit div 3600.
data result type string.
concatenate
  `Hello ` name '!' cl_abap_char_utilities=>newline
  `Today is ` date cl_abap_char_utilities=>newline
  `The hour is ` hour `.`
  into result.
cl_demo_output=>write( result ).

**********************************************************************
* New
**********************************************************************
cl_demo_output=>write(
  |Hello {       to_mixed( sy-uname ) }!\n| &&
  |Today is {    sy-datlo date = environment }.\n| &&
  |The hour is { sy-uzeit div 3600 }.| ).
cl_demo_output=>display( ).
