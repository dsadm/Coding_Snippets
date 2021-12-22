*&---------------------------------------------------------------------*
*& Report zds_constructor_expressions
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zds_constructor_expressions.

data itab type table of i with empty key.
itab = value #( for i = 1 until i > 10
                ( ipow( base = i exp = 2 ) ) ).

cl_demo_output=>display( itab ).


data(components) =
cast cl_abap_structdescr(
cl_abap_typedescr=>describe_by_name( 'T100' ) )->components.

cl_demo_output=>display( components ).
