SQL> @ C:\Users\Joshua\Documents\itse1345\competency_3\competency3_3\ho6\Ho6.sql
SQL> -- Joshua Membreno
SQL> 
SQL> -- # 6-1
SQL> CREATE OR REPLACE FUNCTION DOLLAR_FMT_SF 
  2  (p_num NUMBER)
  3  RETURN VARCHAR2 
  4  AS 
  5  lv_amt_txt VARCHAR2(20);
  6  BEGIN
  7      lv_amt_txt := TO_CHAR(p_num, '$99,999.99');
  8    RETURN  lv_amt_txt;
  9  END DOLLAR_FMT_SF;
 10  /

Function DOLLAR_FMT_SF compiled

SQL> DECLARE
  2      lv_amt_num  NUMBER(8,2) := 9999.55;
  3  BEGIN
  4      DBMS_OUTPUT.PUT_LINE(dollar_fmt_sf(lv_amt_num));
  5  END;
  6  /
$9,999.55


PL/SQL procedure successfully completed.

SQL> -- # 6-2
SQL> CREATE OR REPLACE FUNCTION TOT_PURCH_SF 
  2  (p_shoid    NUMBER)
  3  RETURN NUMBER 
  4  AS
  5  lv_num_tot NUMBER(8,2);
  6  BEGIN
  7      SELECT SUM(total)
  8      INTO lv_num_tot
  9      FROM bb_basket
 10      WHERE idshopper = p_shoid;
 11    RETURN lv_num_tot;
 12  END TOT_PURCH_SF;
 13  /

Function TOT_PURCH_SF compiled

SQL> SELECT idshopper, TOT_PURCH_SF(idshopper)
  2  FROM bb_shopper;

                                       HO6-JOSHUA MEMBRENO                                        
 IDSHOPPER TOT_PURCH_SF(IDSHOPPER)
---------- -----------------------
        21                   66.76
        22                  210.21
        23                   81.75
        24                    61.1
        25                   83.66
        26                       0
        27                   43.38

7 rows selected. 

SQL> /
SQL> -- # 6-3
SQL> CREATE OR REPLACE FUNCTION NUM_PURCH_SF
  2  (p_shoid  NUMBER)
  3  RETURN NUMBER
  4  AS 
  5  lv_num_tot NUMBER(5);
  6  BEGIN
  7      SELECT COUNT(idbasket)
  8      INTO lv_num_tot
  9      FROM bb_basket
 10      WHERE idshopper = p_shoid
 11      AND orderplaced = 1;
 12    RETURN lv_num_tot;
 13  END NUM_PURCH_SF;
 14  /

Function NUM_PURCH_SF compiled

SQL> SELECT num_purch_sf(idshopper)
  2  FROM bb_shopper
  3  WHERE idshopper = 23;

                                       HO6-JOSHUA MEMBRENO                                        
NUM_PURCH_SF(IDSHOPPER)
-----------------------
                      3

SQL> /
SQL> -- # 6-4
SQL> CREATE OR REPLACE FUNCTION DAY_ORD_SF 
  2  (p_date  DATE)
  3  RETURN VARCHAR2 
  4  AS
  5  lv_date VARCHAR2(10);
  6  BEGIN
  7  lv_date := TO_CHAR(p_date, 'DAY');
  8    RETURN lv_date;
  9  END DAY_ORD_SF;
 10  /

Function DAY_ORD_SF compiled

SQL> SELECT idBasket, day_ord_sf(dtcreated)
  2    FROM bb_basket;

                                       HO6-JOSHUA MEMBRENO                                        
   ID           
 BASK DAY       
----- ----------
    3 MONDAY    
    4 SUNDAY    
    5 SUNDAY    
    6 THURSDAY  
    7 THURSDAY  
    8 THURSDAY  
    9 FRIDAY    
   10 TUESDAY   
   11 MONDAY    
   12 SUNDAY    
   13 THURSDAY  
   14 FRIDAY    
   15 TUESDAY   
   16 FRIDAY    

14 rows selected. 

SQL> /
SQL> SELECT day_ord_sf(dtcreated), COUNT(idBasket)
  2    FROM bb_basket
  3    GROUP BY day_ord_sf(dtcreated);

                                       HO6-JOSHUA MEMBRENO                                        
DAY        COUNT(IDBASKET)
---------- ---------------
THURSDAY                 4
TUESDAY                  2
SUNDAY                   3
MONDAY                   2
FRIDAY                   3

SQL> /
SQL> -- # 6-5
SQL> CREATE OR REPLACE FUNCTION ORD_SHIP_SF 
  2  (p_day  NUMBER)
  3  RETURN VARCHAR2 
  4  AS 
  5  lv_shipp    VARCHAR2(12);
  6  lv_order    DATE;
  7  lv_sh_date  DATE;
  8  lv_days     NUMBER(2);
  9  BEGIN
 10    SELECT bk.dtordered, bs.dtstage
 11      INTO lv_order, lv_sh_date
 12      FROM bb_basket bk, bb_basketstatus bs
 13      WHERE bk.idBasket = bs.idBasket
 14        AND bs.idBasket = p_day
 15        AND bs.idstage = 5;
 16    lv_days := lv_sh_date - lv_order;
 17    IF lv_days > 1 THEN
 18      lv_shipp := 'CHECK';
 19    ELSE
 20      lv_shipp := 'OK';
 21    END IF;
 22    RETURN lv_shipp;
 23  EXCEPTION
 24    WHEN NO_DATA_FOUND THEN
 25      lv_shipp := 'NOT SHIPPED';
 26      RETURN lv_shipp;
 27  END ORD_SHIP_SF;
 28  /

Function ORD_SHIP_SF compiled

SQL> DECLARE
  2    lv_flag VARCHAR2(12);
  3    lv_num_id bb_basket.idbasket%TYPE := 3;
  4  BEGIN
  5    lv_flag := ord_ship_sf(lv_num_id);
  6    DBMS_OUTPUT.PUT_LINE('Basket ' || lv_num_id || ' is ' || lv_flag);
  7  END;
  8  /
Basket 3 is CHECK


PL/SQL procedure successfully completed.

SQL> DECLARE
  2    lv_flag VARCHAR2(12);
  3    lv_num_id bb_basket.idbasket%TYPE := 13;
  4  BEGIN
  5    lv_flag := ord_ship_sf(lv_num_id);
  6    DBMS_OUTPUT.PUT_LINE('Basket ' || lv_num_id || ' is ' || lv_flag);
  7  END;
  8  /
Basket 13 is NOT SHIPPED


PL/SQL procedure successfully completed.

SQL> DECLARE
  2    lv_flag VARCHAR2(12);
  3    lv_num_id bb_basket.idbasket%TYPE := 4;
  4  BEGIN
  5    lv_flag := ord_ship_sf(lv_num_id);
  6    DBMS_OUTPUT.PUT_LINE('Basket ' || lv_num_id || ' is ' || lv_flag);
  7  END;
  8  /
Basket 4 is OK


PL/SQL procedure successfully completed.

SQL> -- # 6-6
SQL> CREATE OR REPLACE FUNCTION STATUS_DESC_SF 
  2  (p_st_id NUMBER)
  3  RETURN VARCHAR2 
  4  AS
  5  lv_stage    VARCHAR2(25);
  6  BEGIN
  7    CASE 
  8      WHEN p_st_id = 1 THEN
  9          lv_stage := 'Order submitted';
 10      WHEN p_st_id = 2 THEN
 11          lv_stage := 'Accepted, Sent to shipping';
 12      WHEN p_st_id = 3 THEN
 13          lv_stage := 'Back Ordered';
 14      WHEN p_st_id = 4 THEN
 15          lv_stage := 'Cancelled';
 16      WHEN p_st_id = 5 THEN
 17          lv_stage := 'Shipped';
 18      ELSE
 19          DBMS_OUTPUT.PUT_LINE('PLEASE CHOOSE 1-5');
 20    END CASE;
 21  RETURN lv_stage;
 22  END STATUS_DESC_SF;
 23  /

Function STATUS_DESC_SF compiled

SQL> SELECT dtstage, status_desc_sf(idstage)
  2  FROM bb_basketstatus
  3  WHERE idbasket = 4;

                                       HO6-JOSHUA MEMBRENO                                        
DTSTAGE    STATUS    
---------- ----------
13-FEB-12  Order subm
           itted     

13-FEB-12  Shipped   

SQL> /
SQL> -- # 6-7
SQL> CREATE OR REPLACE FUNCTION TAX_CALC_SF 
  2  (p_bid  NUMBER)
  3  RETURN NUMBER
  4  AS 
  5  lv_tax  NUMBER(5,2) := 0;
  6  BEGIN
  7      SELECT sb.subtotal*bt.taxrate tax
  8      INTO lv_tax
  9      FROM bb_basket sb, bb_tax bt
 10      WHERE sb.shipstate = bt.state
 11          AND sb.idbasket = p_bid;
 12    RETURN lv_tax;
 13  EXCEPTION
 14      WHEN NO_DATA_FOUND THEN
 15          lv_tax := 0;
 16      RETURN lv_tax;
 17  END TAX_CALC_SF;
 18  /

Function TAX_CALC_SF compiled

SQL> SELECT tax_calc_sf(idbasket)
  2    FROM bb_basket
  3    WHERE idbasket = 6;

                                       HO6-JOSHUA MEMBRENO                                        
TAX_CALC_SF(IDBASKET)
---------------------
                 6.75

SQL> /
SQL> -- # 6-8
SQL> CREATE OR REPLACE FUNCTION CK_SALE_SF 
  2  (p_proid IN NUMBER,
  3   p_date  IN DATE)
  4  RETURN VARCHAR2 
  5  AS 
  6    lv_start DATE;
  7    lv_end DATE;
  8    lv_str_val VARCHAR2(15);
  9  BEGIN
 10      SELECT salestart, saleend
 11      INTO lv_start, lv_end
 12      FROM bb_product
 13      WHERE idproduct = p_proid;
 14     IF p_date BETWEEN lv_start AND lv_end THEN
 15      lv_str_val := 'On Sale!';
 16    ELSE
 17      lv_str_val := 'Great Deal!';
 18    END IF; 
 19    RETURN lv_str_val;
 20  END CK_SALE_SF;
 21  /

Function CK_SALE_SF compiled

SQL> DECLARE
  2    lv_str_val VARCHAR2(15);
  3  BEGIN
  4    lv_str_val := ck_sale_sf(6,'10-JUN-12');
  5    DBMS_OUTPUT.PUT_LINE(lv_str_val);
  6  END;
  7  /
On Sale!


PL/SQL procedure successfully completed.

SQL> DECLARE
  2    lv_str_val VARCHAR2(15);
  3  BEGIN
  4    lv_str_val := ck_sale_sf(6,'19-JUN-12');
  5    DBMS_OUTPUT.PUT_LINE(lv_str_val);
  6  END;
  7  /
Great Deal!


PL/SQL procedure successfully completed.

SQL> CLEAR COLUMNS
SQL> --CLEAR BRAKES
SQL> TTITLE OFF
SQL> TTITLE CENTER 'HO6-JOSHUA MEMBRENO'
SQL> COLUMN IDBASKET HEADING 'ID|BASK' FORMAT A5 WRAP
SQL> COLUMN DAY_ORD_SF(DTCREATED) HEADING 'DAY' FORMAT A10 WRAP
SQL> COLUMN DTSTAGE HEADING 'DTSTAGE' FORMAT A10 
SQL> COLUMN STATUS_DESC_SF(IDSTAGE) HEADING 'STATUS' FORMAT A10 
SQL> spool off
