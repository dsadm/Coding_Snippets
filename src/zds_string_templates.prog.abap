*&---------------------------------------------------------------------*
*& Report zds_string_templates
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zds_string_templates.

data(string) = |Hello { sy-uname }!\n| &&
               |Today is { sy-datlo date = iso }.\n| &&
               |The hour is { sy-uzeit div 3600 }.|.

cl_demo_output=>display( string ).
