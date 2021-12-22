*&---------------------------------------------------------------------*
*& Report zds_string_functions
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zds_string_functions.


**********************************************************************
* Description functions
**********************************************************************
data(result) = count( val = `xxx123yyy` regex = `\d+` ).
cl_demo_output=>display( result ).

**********************************************************************
* Processing functions
**********************************************************************
data(html) = replace( val   = `<title>This is the <i>Title</i></title>`
                      regex = `i` && `(?![^<>]*>)`
                      with  = `<b>$0</b>`
                      occ   = 0 ).

cl_demo_output=>display( html ).

**********************************************************************
* Predicate functions
**********************************************************************
data emails type table of string.
emails =  value #(
                ( `dschwarting@metabo.de` )
                ( `dschwarting&metabo.de` ) ).

loop at emails reference into data(email).
  if matches( val = email->*
              regex = `\w+(\.\w+)*@(\w+\.)+(\w{2,4})` ).
    data(valid) = |{ email->* } valid|.
  else.
    data(not_valid) = |{ email->* } not valid|.
  endif.
endloop.
cl_demo_output=>display( |{ valid }\n { not_valid }| ).
