--MEMBER ���̺��� ���� MEMBER_BAK ���̺�� �����غ���
CREATE TABLE MEMBER_BAK
AS
SELECT * FROM MEMBER;

-- MEMBER ���̺� DROP
DROP TABLE MEMBER;
DELETE FROM MEMBER;



 SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'MEMBER';

-- �⺻Ű / �ܷ�Ű ��������� ������ �� ��
CREATE TABLE MEMBER
AS 
SELECT * FROM MEM_BAK;

/

SELECT MEM_ID, MEM_PASS, ENABLED FROM MEMBER
WHERE MEM_ID = 'a001';


-- ���� 
SELECT M.MEM_ID, MA.AUTH
FROM MEMBER M, MEMBER_AUTH MA
WHERE M.MEM_ID = MA.MEM_ID
AND M.MEM_ID = 'a001';

--���� ī�ắȯ(https://heavenly-appear.tistory.com/270)
SELECT COLUMN_NAME
, DATA_TYPE
, CASE WHEN DATA_TYPE='NUMBER' THEN 'private int ' || FN_GETCAMEL(COLUMN_NAME) || ';'
WHEN DATA_TYPE IN('VARCHAR2','CHAR') THEN 'private String ' || FN_GETCAMEL(COLUMN_NAME) || ';'
WHEN DATA_TYPE='DATE' THEN 'private Date ' || FN_GETCAMEL(COLUMN_NAME) || ';'
ELSE 'private String ' || FN_GETCAMEL(COLUMN_NAME) || ';'
END AS CAMEL_CASE
, '' RESULTMAP
FROM ALL_TAB_COLUMNS
WHERE TABLE_NAME = 'MEMBER_AUTH';

SELECT *
FROM MEMBER A LEFT OUTER JOIN MEMBER_AUTH AUTH ON (A.MEM_ID = AUTH.MEM_ID)
WHERE A.MEM_ID = 'a001';



--  BOOK ���̺�� ATTACH���̺��� INNER JOIN �غ���
-- ��� �÷� *���� �ʱ�

SELECT B.BOOK_ID, B.TITLE, B.CATEGORY, B.PRICE, B.INSERT_DATE, B.CONTENT
, A.SEQ, A.FILENAME
FROM BOOK B, ATTACH A
WHERE  B.BOOK_ID = A.USER_NO
AND B.BOOK_ID = 3;

SELECT B.BOOK_ID, B.TITLE, B.CATEGORY, B.PRICE, B.INSERT_DATE, B.CONTENT
, A.USER_NO, A.SEQ, A.FILENAME, A.FILESIZE, A.REGDATE
FROM BOOK B INNER JOIN ATTACH A ON(B.BOOK_ID = A.USER_NO)
where b.book_id = 3;

-- ���� XML�� : gallery_SQL.xml
-- ���� interface�� : GalleryMapper.java
-- namespace �� : gallery
-- id �� : list
-- parameterType : bookVO
-- resultMap : bookMap(1:N ���� ó�� + CLOB ������ ó��)

--INSERT ALL
--INTO ATTACH(USER_NO, SEQ, FILENAME, FILESIZE, REGDATE) VALUES('2', 1, '/2022/11/16/s_22cce766-64e1-4200-b1fb-503990e17730_roun.jpg',0, SYSDATE)
--INTO ATTACH(USER_NO, SEQ, FILENAME, FILESIZE, REGDATE) VALUES('2', 2, '/2022/11/16/s_22cce766-64e1-4200-b1fb-503990e17730_roun.jpg',0, SYSDATE)
--INTO ATTACH(USER_NO, SEQ, FILENAME, FILESIZE, REGDATE) VALUES('2', 3, '/2022/11/16/s_22cce766-64e1-4200-b1fb-503990e17730_roun.jpg',0, SYSDATE)
--SELECT * FROM DUAL;

SELECT NVL(MAX(SEQ),0)+1 FROM ATTACH WHERE USER_NO =8;


-- pc12������ lprod ���̺� �����͸� jspexam���� ��������


CREATE TABLE cart_bak AS SELECT * FROM cart;
CREATE TABLE cart_det_bak AS SELECT * FROM cart_det;
--drop table cart;

-- pc12 ������ prod �� cart���̺��� ��������
-- ���� -> �����ͺ��̽� ���� -> �ҽ����� : pc12, ������� : jspexam


-- ��ǰ �� �Ǹűݾ��� �հ踦 ���غ���
-- alias : prod_name, money(prod_sale * cart_qty)
-- ��, money ���� 1000000 �̻��� �����͸� �����ͺ���
-- cart ���̺��� ����ϰ� cart���̺� �� cart_det ���̺��� drop
SELECT  PROD_NAME   prodName, SUM(PROD_SALE * CART_QTY) MONEY
FROM      PROD , CART 
WHERE   PROD_ID = CART_PROD
GROUP BY PROD_NAME
HAVING SUM(PROD_SALE * CART_QTY) >=10000000;


-- LPROD ���̺��� LPROD2 ���̺�� �����غ���
CREATE TABLE LPROD2
AS
SELECT * FROM LPROD;

SELECT * FROM LPROD2;


MERGE INTO LPROD2 A -- ��� ���̺�
USING DUAL
ON (A.LPROD_GU = 'P404')  -- ������(�ַ� �⺻Ű ������)
WHEN MATCHED THEN  -- �������� �ش��ϴ� �����Ͱ� ������ ����
        UPDATE SET A.LPROD_CNT = A.LPROD_CNT + 1
WHEN NOT MATCHED THEN   -- �������� �ش��ϴ� �����Ͱ� ������ ����
        INSERT (LPROD_ID, LPROD_GU, LPROD_NM, LPROD_CNT)
        VALUES((SELECT NVL(MAX(LPROD_ID),0)+1 FROM LPROD2), (SELECT 'P'||MAX(SUBSTR(LPROD_GU,2,4)+1)  FROM LPROD2),'������',0)
;

-- LPROD2 ���̺��� LPROD_ID ���� 1 �������� �������ִ� FUNCTION�� ������
-- FUNCTION �� : FN_NEXT_LPROD_ID
SELECT NVL(MAX(LPROD_ID),0)+1 FROM LPROD2;
/
CREATE OR REPLACE FUNCTION  FN_NEXT_LPROD_ID 
RETURN NUMBER
IS
        V_ID NUMBER;
BEGIN
-- PL/SQL���� SELECT�� �Բ� �� INTO�� ���� 
                SELECT NVL(MAX(LPROD_ID),0)+1 INTO V_ID
                FROM LPROD2;
                RETURN V_ID;
END;
/
-- LPROD2 ���̺��� LPROD_GU ���� 1 �������� �������ִ� ���������� ������
-- P403 -> 1 ���� -> P405
SELECT 'P'||MAX(SUBSTR(LPROD_GU,2,4)+1)  FROM LPROD2;

SELECT SUBSTR(MAX(LPROD_GU),1,1)
     || TRIM(SUBSTR(MAX(LPROD_GU),2) + 1)
FROM   LPROD2;


ALTER TABLE LPROD2 ADD LPROD_CNT NUMBER;









MERGE INTO BOOK A -- ��� ���̺�
USING DUAL
ON (A.BOOK_ID = 12)  -- ������(�ַ� �⺻Ű ������)
WHEN MATCHED THEN  -- �������� �ش��ϴ� �����Ͱ� ������ ����
        UPDATE SET
        TITLE='�����̴� ���� ��', CATEGORY='a0101', PRICE=15000, INSERT_DATE=SYSDATE, CONTENT= '�ܷο��� ���۵� ���� �ȿ��'
WHEN NOT MATCHED THEN   -- �������� �ش��ϴ� �����Ͱ� ������ ����
        INSERT(BOOK_ID, TITLE, CATEGORY, PRICE, INSERT_DATE, CONTENT)
		VALUES((SELECT NVL(MAX(BOOK_ID),0) + 1 FROM BOOK), '���� ����',  'a0101', 15555, SYSDATE, '����� ���ܿ� �������� ��....')
;

-- �������� ~ �������� �Ⱓ �� ��� ��¥(����) ���ϱ�
-- �������� : 2022-12-01 (��¥�� ����)
-- �������� : 2022-12-10 (��¥�� ����)
SELECT TO_DATE('2022-12-01', 'YYYY-MM-DD') + LEVEL -1 AS DATES
FROM DUAL
CONNECT BY LEVEL <= (TO_DATE('2022-12-10','YYYY-MM-DD')-
                                                    TO_DATE('2022-12-01','YYYY-MM-DD') +1);


WITH DATE_RANGE AS(
    SELECT TO_DATE('2022-12-01','YYYY-MM-DD') + LEVEL - 1 AS DATES
    FROM DUAL
    CONNECT BY LEVEL <= (TO_DATE('2022-12-10','YYYY-MM-DD') - 
                         TO_DATE('2022-12-01','YYYY-MM-DD') + 1)
),
ATTENDANCE AS(
SELECT TO_DATE('2022-12-01','YYYY-MM-DD') AS ATTDATE, '���' AS ATTSTAT FROM DUAL
UNION ALL
SELECT TO_DATE('2022-12-03','YYYY-MM-DD') AS ATTDATE, '���' AS ATTSTAT FROM DUAL
UNION ALL
SELECT TO_DATE('2022-12-06','YYYY-MM-DD') AS ATTDATE, '���' AS ATTSTAT FROM DUAL
)
SELECT A.DATES, B.ATTSTAT FROM DATE_RANGE A, ATTENDANCE B
WHERE  A.DATES = B.ATTDATE(+)
ORDER BY A.DATES
;

SELECT LEVEL T_NO
                ,   LEVEL || '����' T_NAME
                ,   DECODE(LEVEL,
                    1, '09:00',
                    2, '10:00',
                    3, '11:00',
                    4, '12:00',
                    5, '13:00',
                    6, '14:00',
                    7, '15:00',
                    8, '16:00') P_SDATE
                ,   DECODE(LEVEL,
                    1, '09:50',
                    2, '10:50',
                    3, '11:50',
                    4, '12:50',
                    5, '13:50',
                    6, '14:50',
                    7, '15:50',
                    8, '16:50') P_EDATE
FROM DUAL
CONNECT BY LEVEL <=8;









































