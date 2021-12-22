*&---------------------------------------------------------------------*
*& Report zds_old_new_02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zds_old_new_02.

**********************************************************************
* OLD
**********************************************************************
data out type ref to if_demo_output.

call method cl_demo_output=>new
  exporting
    mode   = cl_demo_output=>text_mode
  receiving
    output = out.

data text type c length 100.
set country 'US'.
write sy-datlo to text.
concatenate 'Today is the' text into text separated by space.
call method out->display( text ).

**********************************************************************
* NEW
**********************************************************************
cl_demo_output=>new( cl_demo_output=>text_mode
   )->display( |Today is the { sy-datlo country = 'US ' }| ).
