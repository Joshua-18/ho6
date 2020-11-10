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
-- # 6-4
CREATE OR REPLACE FUNCTION DAY_ORD_SF 
(p_date  DATE)
RETURN VARCHAR2 
AS
lv_date VARCHAR2(10);
BEGIN
lv_date := TO_CHAR(p_date, 'DAY');
  RETURN lv_date;
END DAY_ORD_SF;
/
SELECT idBasket, day_ord_sf(dtcreated)
  FROM bb_basket;
/
SELECT day_ord_sf(dtcreated), COUNT(idBasket)
  FROM bb_basket
  GROUP BY day_ord_sf(dtcreated);
/
-- # 6-5
CREATE OR REPLACE FUNCTION ORD_SHIP_SF 
(p_day  NUMBER)
RETURN VARCHAR2 
AS 
lv_shipp    VARCHAR2(12);
lv_order    DATE;
lv_sh_date  DATE;
lv_days     NUMBER(2);
BEGIN
  SELECT bk.dtordered, bs.dtstage
    INTO lv_order, lv_sh_date
    FROM bb_basket bk, bb_basketstatus bs
    WHERE bk.idBasket = bs.idBasket
      AND bs.idBasket = p_day
      AND bs.idstage = 5;
  lv_days := lv_sh_date - lv_order;
  IF lv_days > 1 THEN
    lv_shipp := 'CHECK';
  ELSE
    lv_shipp := 'OK';
  END IF;
  RETURN lv_shipp;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    lv_shipp := 'NOT SHIPPED';
    RETURN lv_shipp;
END ORD_SHIP_SF;
/
DECLARE
  lv_flag VARCHAR2(12);
  lv_num_id bb_basket.idbasket%TYPE := 3;
BEGIN
  lv_flag := ord_ship_sf(lv_num_id);
  DBMS_OUTPUT.PUT_LINE('Basket ' || lv_num_id || ' is ' || lv_flag);
END;
/
DECLARE
  lv_flag VARCHAR2(12);
  lv_num_id bb_basket.idbasket%TYPE := 13;
BEGIN
  lv_flag := ord_ship_sf(lv_num_id);
  DBMS_OUTPUT.PUT_LINE('Basket ' || lv_num_id || ' is ' || lv_flag);
END;
/
DECLARE
  lv_flag VARCHAR2(12);
  lv_num_id bb_basket.idbasket%TYPE := 4;
BEGIN
  lv_flag := ord_ship_sf(lv_num_id);
  DBMS_OUTPUT.PUT_LINE('Basket ' || lv_num_id || ' is ' || lv_flag);
END;
/
-- # 6-6
CREATE OR REPLACE FUNCTION STATUS_DESC_SF 
(p_st_id NUMBER)
RETURN VARCHAR2 
AS
lv_stage    VARCHAR2(25);
BEGIN
  CASE 
    WHEN p_st_id = 1 THEN
        lv_stage := 'Order submitted';
    WHEN p_st_id = 2 THEN
        lv_stage := 'Accepted, Sent to shipping';
    WHEN p_st_id = 3 THEN
        lv_stage := 'Back Ordered';
    WHEN p_st_id = 4 THEN
        lv_stage := 'Cancelled';
    WHEN p_st_id = 5 THEN
        lv_stage := 'Shipped';
    ELSE
        DBMS_OUTPUT.PUT_LINE('PLEASE CHOOSE 1-5');
  END CASE;
RETURN lv_stage;
END STATUS_DESC_SF;
/
SELECT dtstage, status_desc_sf(idstage)
FROM bb_basketstatus
WHERE idbasket = 4;
/
-- # 6-7
CREATE OR REPLACE FUNCTION TAX_CALC_SF 
(p_bid  NUMBER)
RETURN NUMBER
AS 
lv_tax  NUMBER(5,2) := 0;
BEGIN
    SELECT sb.subtotal*bt.taxrate tax
    INTO lv_tax
    FROM bb_basket sb, bb_tax bt
    WHERE sb.shipstate = bt.state
        AND sb.idbasket = p_bid;
  RETURN lv_tax;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        lv_tax := 0;
    RETURN lv_tax;
END TAX_CALC_SF;
/
SELECT tax_calc_sf(idbasket)
  FROM bb_basket
  WHERE idbasket = 6;
/
-- # 6-8
CREATE OR REPLACE FUNCTION CK_SALE_SF 
(p_proid IN NUMBER,
 p_date  IN DATE)
RETURN VARCHAR2 
AS 
  lv_start DATE;
  lv_end DATE;
  lv_str_val VARCHAR2(15);
BEGIN
    SELECT salestart, saleend
    INTO lv_start, lv_end
    FROM bb_product
    WHERE idproduct = p_proid;
   IF p_date BETWEEN lv_start AND lv_end THEN
    lv_str_val := 'On Sale!';
  ELSE
    lv_str_val := 'Great Deal!';
  END IF; 
  RETURN lv_str_val;
END CK_SALE_SF;
/
DECLARE
  lv_str_val VARCHAR2(15);
BEGIN
  lv_str_val := ck_sale_sf(6,'10-JUN-12');
  DBMS_OUTPUT.PUT_LINE(lv_str_val);
END;
/
DECLARE
  lv_str_val VARCHAR2(15);
BEGIN
  lv_str_val := ck_sale_sf(6,'19-JUN-12');
  DBMS_OUTPUT.PUT_LINE(lv_str_val);
END;
/
CLEAR COLUMNS
--CLEAR BRAKES
TTITLE OFF
TTITLE CENTER 'HO6-JOSHUA MEMBRENO'
COLUMN IDBASKET HEADING 'ID|BASK' FORMAT A5 WRAP
COLUMN DAY_ORD_SF(DTCREATED) HEADING 'DAY' FORMAT A10 WRAP
COLUMN DTSTAGE HEADING 'DTSTAGE' FORMAT A10 
COLUMN STATUS_DESC_SF(IDSTAGE) HEADING 'STATUS' FORMAT A10 