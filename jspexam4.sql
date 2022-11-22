--MEMBER 테이블을 통해 MEMBER_BAK 테이블로 복제해보자
CREATE TABLE MEMBER_BAK
AS
SELECT * FROM MEMBER;

-- MEMBER 테이블 DROP
DROP TABLE MEMBER;
DELETE FROM MEMBER;



 SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'MEMBER';

-- 기본키 / 외래키 제약사항은 복제가 안 됨
CREATE TABLE MEMBER
AS 
SELECT * FROM MEM_BAK;

/

SELECT MEM_ID, MEM_PASS, ENABLED FROM MEMBER
WHERE MEM_ID = 'a001';


-- 권한 
SELECT M.MEM_ID, MA.AUTH
FROM MEMBER M, MEMBER_AUTH MA
WHERE M.MEM_ID = MA.MEM_ID
AND M.MEM_ID = 'a001';

--구글 카멜변환(https://heavenly-appear.tistory.com/270)
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



--  BOOK 테이블과 ATTACH테이블을 INNER JOIN 해보자
-- 모든 컬럼 *쓰지 않기

SELECT B.BOOK_ID, B.TITLE, B.CATEGORY, B.PRICE, B.INSERT_DATE, B.CONTENT
, A.SEQ, A.FILENAME
FROM BOOK B, ATTACH A
WHERE  B.BOOK_ID = A.USER_NO
AND B.BOOK_ID = 3;

SELECT B.BOOK_ID, B.TITLE, B.CATEGORY, B.PRICE, B.INSERT_DATE, B.CONTENT
, A.USER_NO, A.SEQ, A.FILENAME, A.FILESIZE, A.REGDATE
FROM BOOK B INNER JOIN ATTACH A ON(B.BOOK_ID = A.USER_NO)
where b.book_id = 3;

-- 매퍼 XML명 : gallery_SQL.xml
-- 매퍼 interface명 : GalleryMapper.java
-- namespace 명 : gallery
-- id 명 : list
-- parameterType : bookVO
-- resultMap : bookMap(1:N 관계 처리 + CLOB 데이터 처리)

--INSERT ALL
--INTO ATTACH(USER_NO, SEQ, FILENAME, FILESIZE, REGDATE) VALUES('2', 1, '/2022/11/16/s_22cce766-64e1-4200-b1fb-503990e17730_roun.jpg',0, SYSDATE)
--INTO ATTACH(USER_NO, SEQ, FILENAME, FILESIZE, REGDATE) VALUES('2', 2, '/2022/11/16/s_22cce766-64e1-4200-b1fb-503990e17730_roun.jpg',0, SYSDATE)
--INTO ATTACH(USER_NO, SEQ, FILENAME, FILESIZE, REGDATE) VALUES('2', 3, '/2022/11/16/s_22cce766-64e1-4200-b1fb-503990e17730_roun.jpg',0, SYSDATE)
--SELECT * FROM DUAL;

SELECT NVL(MAX(SEQ),0)+1 FROM ATTACH WHERE USER_NO =8;


-- pc12계정의 lprod 테이블 데이터를 jspexam으로 가져오기


CREATE TABLE cart_bak AS SELECT * FROM cart;
CREATE TABLE cart_det_bak AS SELECT * FROM cart_det;
--drop table cart;

-- pc12 계정의 prod 및 cart테이블을 가져오자
-- 도구 -> 데이터베이스 복사 -> 소스접속 : pc12, 대상접속 : jspexam


-- 상품 별 판매금액의 합계를 구해보자
-- alias : prod_name, money(prod_sale * cart_qty)
-- 단, money 값이 1000000 이상인 데이터만 가져와보자
-- cart 테이블을 백업하고 cart테이블 및 cart_det 테이블을 drop
SELECT  PROD_NAME   prodName, SUM(PROD_SALE * CART_QTY) MONEY
FROM      PROD , CART 
WHERE   PROD_ID = CART_PROD
GROUP BY PROD_NAME
HAVING SUM(PROD_SALE * CART_QTY) >=10000000;


-- LPROD 테이블을 LPROD2 테이블로 복제해보자
CREATE TABLE LPROD2
AS
SELECT * FROM LPROD;

SELECT * FROM LPROD2;


MERGE INTO LPROD2 A -- 대상 테이블
USING DUAL
ON (A.LPROD_GU = 'P404')  -- 조건절(주로 기본키 데이터)
WHEN MATCHED THEN  -- 조건절에 해당하는 데이터가 있으면 실행
        UPDATE SET A.LPROD_CNT = A.LPROD_CNT + 1
WHEN NOT MATCHED THEN   -- 조건절에 해당하는 데이터가 없으면 실행
        INSERT (LPROD_ID, LPROD_GU, LPROD_NM, LPROD_CNT)
        VALUES((SELECT NVL(MAX(LPROD_ID),0)+1 FROM LPROD2), (SELECT 'P'||MAX(SUBSTR(LPROD_GU,2,4)+1)  FROM LPROD2),'가구류',0)
;

-- LPROD2 테이블의 LPROD_ID 값을 1 증가시켜 리턴해주는 FUNCTION을 만들어보자
-- FUNCTION 명 : FN_NEXT_LPROD_ID
SELECT NVL(MAX(LPROD_ID),0)+1 FROM LPROD2;
/
CREATE OR REPLACE FUNCTION  FN_NEXT_LPROD_ID 
RETURN NUMBER
IS
        V_ID NUMBER;
BEGIN
-- PL/SQL에서 SELECT와 함께 꼭 INTO를 쓰자 
                SELECT NVL(MAX(LPROD_ID),0)+1 INTO V_ID
                FROM LPROD2;
                RETURN V_ID;
END;
/
-- LPROD2 테이블의 LPROD_GU 값을 1 증가시켜 리턴해주는 서브쿼리를 만들어보자
-- P403 -> 1 증가 -> P405
SELECT 'P'||MAX(SUBSTR(LPROD_GU,2,4)+1)  FROM LPROD2;

SELECT SUBSTR(MAX(LPROD_GU),1,1)
     || TRIM(SUBSTR(MAX(LPROD_GU),2) + 1)
FROM   LPROD2;


ALTER TABLE LPROD2 ADD LPROD_CNT NUMBER;









MERGE INTO BOOK A -- 대상 테이블
USING DUAL
ON (A.BOOK_ID = 12)  -- 조건절(주로 기본키 데이터)
WHEN MATCHED THEN  -- 조건절에 해당하는 데이터가 있으면 실행
        UPDATE SET
        TITLE='개똥이는 힘이 쎄', CATEGORY='a0101', PRICE=15000, INSERT_DATE=SYSDATE, CONTENT= '외로워도 슬퍼도 나는 안울어'
WHEN NOT MATCHED THEN   -- 조건절에 해당하는 데이터가 없으면 실행
        INSERT(BOOK_ID, TITLE, CATEGORY, PRICE, INSERT_DATE, CONTENT)
		VALUES((SELECT NVL(MAX(BOOK_ID),0) + 1 FROM BOOK), '사탕 개똥',  'a0101', 15555, SYSDATE, '지겹다 지겨워 집에가자 좀....')
;

-- 시작일자 ~ 종료일자 기간 내 모든 날짜(일자) 구하기
-- 시작일자 : 2022-12-01 (날짜형 문자)
-- 종료일자 : 2022-12-10 (날짜형 문자)
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
SELECT TO_DATE('2022-12-01','YYYY-MM-DD') AS ATTDATE, '출근' AS ATTSTAT FROM DUAL
UNION ALL
SELECT TO_DATE('2022-12-03','YYYY-MM-DD') AS ATTDATE, '출근' AS ATTSTAT FROM DUAL
UNION ALL
SELECT TO_DATE('2022-12-06','YYYY-MM-DD') AS ATTDATE, '출근' AS ATTSTAT FROM DUAL
)
SELECT A.DATES, B.ATTSTAT FROM DATE_RANGE A, ATTENDANCE B
WHERE  A.DATES = B.ATTDATE(+)
ORDER BY A.DATES
;

SELECT LEVEL T_NO
                ,   LEVEL || '교시' T_NAME
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









































