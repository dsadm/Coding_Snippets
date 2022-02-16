*&---------------------------------------------------------------------*
*& Report zds_perf_sat_test
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zds_perf_sat_test.

DATA: zlt_vbak TYPE TABLE OF vbak.
DATA: zls_vbak TYPE vbak.
DATA: zlt_vbap TYPE TABLE OF vbap.
DATA: zls_vbap TYPE vbap.
DATA: zls_vbap2 TYPE vbap.

SELECT * FROM vbak INTO TABLE zlt_vbak UP TO 100 ROWS.

LOOP AT zlt_vbak INTO zls_vbak.
  SELECT * FROM vbap INTO zls_vbap.
    DO 10000 TIMES.
      zls_vbap2 = zls_vbap.
    ENDDO.
  ENDSELECT.
ENDLOOP.
