*&---------------------------------------------------------------------*
*& Report zds_for_01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zds_for_01.

data(sum) = reduce #( init s type i
                      for i = 1  until i > 10
                      next s = s + i ).

cl_demo_output=>display( sum ).

data(result) = reduce string(
                init text = `Count up:`
                for n = 1 until n > 10
                next text = text && | { n } | ).

cl_demo_output=>display( result ).

data itab type standard table of i with empty key.
itab = value #( for j = 1 while j <= 10 ( j ) ).

data(summe) = reduce i(
                init x = 0
                for wa in itab
                next x = x + wa ).

cl_demo_output=>display( summe ).
