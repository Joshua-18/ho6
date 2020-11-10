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
-- # 6-2
CREATE OR REPLACE FUNCTION TOT_PURCH_SF 
(p_shoid    NUMBER)
RETURN NUMBER 
AS
lv_num_tot NUMBER(8,2);
BEGIN
    SELECT SUM(total)
    INTO lv_num_tot
    FROM bb_basket
    WHERE idshopper = p_shoid;
  RETURN lv_num_tot;
END TOT_PURCH_SF;
/
SELECT idshopper, TOT_PURCH_SF(idshopper)
FROM bb_shopper;
/
-- # 6-3
CREATE OR REPLACE FUNCTION NUM_PURCH_SF
(p_shoid  NUMBER)
RETURN NUMBER
AS 
lv_num_tot NUMBER(5);
BEGIN
    SELECT COUNT(idbasket)
    INTO lv_num_tot
    FROM bb_basket
    WHERE idshopper = p_shoid
    AND orderplaced = 1;
  RETURN lv_num_tot;
END NUM_PURCH_SF;
/
SELECT num_purch_sf(idshopper)
FROM bb_shopper
WHERE idshopper = 23;
/