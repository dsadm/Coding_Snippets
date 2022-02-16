*&---------------------------------------------------------------------*
*& Report zds_spmon_01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zds_spmon_01.

data:
  begin of selection,
    spmon type spmon,
  end of selection.

select-options:
s_spmon for selection-spmon .


start-of-selection.

  write: / s_spmon-low,
         / s_spmon-high.

  data(date_low) = s_spmon-low.
  data(date_high) = s_spmon-high.

  data(sum) = date_high - date_low.

  write: / sum.
