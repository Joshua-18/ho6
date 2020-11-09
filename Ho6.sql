-- Joshua Membreno

-- # 6-1
CREATE OR REPLACE FUNCTION DOLLAR_FMT_SF 
(p_num NUMBER)
RETURN VARCHAR2 
AS 
lv_amt_txt VARCHAR2(20);
BEGIN
    lv_amt_txt := TO_CHAR(p_num, '$99,999.99');
  RETURN  lv_amt_txt;
END DOLLAR_FMT_SF;
/
DECLARE
    lv_amt_num  NUMBER(8,2) := 9999.55;
BEGIN
    DBMS_OUTPUT.PUT_LINE(dollar_fmt_sf(lv_amt_num));
END;
/