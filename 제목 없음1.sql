/*SQL(Structed Query Language): 구조화 된 질의 언어
- ISO(International Standard Organization)에서 지정한
 비절차적(<->절차적 ex) PL/SQL)인 관계형 데이터베이스(RDB)의 표준 언어
 - 세미콜론(;)으로 끝남
 - 여러줄로 줄로 입력 가능
 - 가장 최근에 실행한 SQL문은 SQL 버퍼에 남아 있음
 
 //"_" 없는것은 자주 쓰임
 
 DDL(Data Definition Language)
 : 데이터 정의어(DB 구조 또는 스키마 정의)
 1) CREATE(개체-테이블/뷰.. 생성), ALTER(개체 변경), DROP(개체 삭제)
 2_) RENAME(개체명 변경)
 3_) TRUNCATE(개체내의 데이터 삭제)
 4_) COMMENT(데이터 사전에 주석 추가)
 
2. DML(Data Manipulation Language)
: 데이터 조작어
 1) INSERT(데이터 입력-C)
 2) UPDATE(데이터 수정-U)
 3) DELETE(데이터 삭제-D)
 4) SELECT(데이터 검색-R)
 5_) EXPLAIN(실행 계획문)
 6_) LOCK TABLE(테이블, 뷰에 대한 접근의 일시적 잠금)
 
3. DCL(Data Control Language)
: 데이터 제어어
 1) GRANT(권한부여)
 2) REVOKE(권한회수)
 
4. TCL(Transaction Control Language)
 : 트랜잭션 제어어
 1) COMMIT(트랜잭션 적용)
 2) ROLLBACK(마지막 COMMIT 시점으로 회귀)
 3) SAVEPOINT(트랜잭션 임시저장)
 */
 
 /*<SQL 문의 입력 및 실행에 관한 일반적인 사항>
 1. 모든 SQL문은 세미콜론(;)으로 끝난다.
 2. SQL의 명령문은 대소문자를 구분하지 않는다. 데이터는 대소문자를 구분함
 3. 하나의 SQL문은 명료하도록 한 줄 또는 여러 줄로 나누어 입력할 수 있음
 */
 /*
 테이블명 정의 규칙
 - 하나의 계정 내에서 테이블명은 유일해야함.
 - 영문자로 시작해야 함
 - 영문자, 숫자, 특수문자 주 #_$를 사용할 수 있음
 - 30BYTES를 넘을 수 없음(한글은 1글자 3BYTES, 순수한글은 10자 가능)
 - 예약이 사용 못함(NOT,NULL,INSERT..)
 */
 -- 영문 대소문자 바꾸기 : ALT + '
 -- 실행 : CTRL + ENTER, 플레이 버튼 클릭
 -- LPROD 테이블 새성(3개의 컬럼, LPROD_GU컬럼이 P.K)
CREATE TABLE lprod (
    lprod_id   NUMBER(5) NOT NULL,     --순번
    lprod_gu   CHAR(4) NOT NULL,      --상품분류코드
    lprod_nm   VARCHAR(40) NOT NULL,     --상품분류명
    CONSTRAINT pk_lprod PRIMARY KEY ( lprod_gu )
);
 
 --테이블에 설명글 달기

COMMENT ON TABLE lprod IS
    '상품분류';
 --컬럼에 설명글 달기

COMMENT ON COLUMN lprod.lprod_id IS
    '순번';

COMMENT ON COLUMN lprod.lprod_gu IS
    '상품분류코드';

COMMENT ON COLUMN lprod.lprod_nm IS
    '상품분류명';

--P.147
/* 
ALTER TABLE : 테이블의 구조만 변경, 데이터 내용은 변경안됨

ALTER TABLE <테이블 명>
    ADD (새로운컬럼명 TYPE [DEFAULT VALUE] , ...) => 컬럼 추가, 기본 값 추가
    MODIFY ( 필드명 TYPE [NOT NULL] PRFAULT VALUE] , ...)
        => 컬럼 자료형/ 크기 변경, NULL을 NOT NULL로, NOT NULL을 NULL로 제약조건 변경
        => 컬럼명을 변경 X => RENAME을 써야함
  DROP COLUMN 필드명  => 기존 컬럼, 제약조건 제거
*/
--BUYER테이블의 구조 변경(컬럼이 추가)
--ADD(추가), MODIFY(변경), DROP(제거)
--NULL은 생략 가능

CREATE TABLE buyer (
    buyer_id         CHAR(6) NOT NULL,      --거래처코드
    buyer_name       VARCHAR(40) NOT NULL,      --거래처명
    buyer_lgu        CHAR(4) NOT NULL,      --취급상품 대분류
    buyer_bank       VARCHAR2(60),               --은행
    buyer_bankno     VARCHAR2(60),               --계좌번호
    buyer_bankname   VARCHAR2(15),               --예금주
    buyer_zip        CHAR(7),                    --우편번호
    buyer_add1       VARCHAR2(100),              --주소1
    buyer_add2       VARCHAR2(70),               --주소2
    buyer_comtel     VARCHAR2(14) NOT NULL,      --전화번호
    buyer_fax        VARCHAR2(20) NOT NULL       --FAX번호
);

ALTER TABLE buyer ADD (
    buyer_mail      VARCHAR2(60) NOT NULL,
    buyer_charger   VARCHAR2(20) NULL,
    buyer_telext    VARCHAR2(2)
);

ALTER TABLE buyer MODIFY (
    buyer_name VARCHAR2(60)
);

DESC buyer;
 --ADD(추가) CONSTRAINT(제약사항) CHECK_PHONE(이름)
 --CHECK_LIKE : 정규식(제약조건)
 --[0-9] : 0~9 사이의 정수
 --[0-9] [0-9] : 두 자리의 정수

ALTER TABLE buyer
    ADD CONSTRAINT check_phone CHECK ( REGEXP_LIKE ( buyer_telext,
    '[0-9][0-9]' ) );
 
 -- INDEX : 책의 목차와 비슷함
 -- BUYER 테이블의 BUYER_NAME, BUYER_ID를 묶어서 인덱스 생성
 -- 검색속도를 빠르게 하려고

CREATE INDEX idx_buyer ON
    buyer ( buyer_name,
    buyer_id );

--인덱스 제거

DROP INDEX idx_buyer;

ALTER TABLE buyer ADD (
    CONSTRAINT pk_buyer PRIMARY KEY ( buyer_id )
);

ALTER TABLE buyer ADD (
    CONSTRAINT fk_buyer_lprod FOREIGN KEY ( buyer_lgu )
        REFERENCES lprod ( lprod_gu )
);

CREATE TABLE prod (
    prod_id            VARCHAR2(10) NOT NULL,       --상품코드
    prod_name          VARCHAR2(40) NOT NULL,       --상품명
    prod_lgu           CHAR(4) NOT NULL,       --상품분류
    prod_buyer         CHAR(6) NOT NULL,       --공급업체(코드)
    prod_cost          NUMBER(10) NOT NULL,       --매입가
    prod_price         NUMBER(10) NOT NULL,       --소비자가
    prod_sale          NUMBER(10) NOT NULL,       --판매가
    prod_outline       VARCHAR2(100) NOT NULL,       --상품개략설명
    prod_detail        CLOB,                           --상품상세설명
    prod_img           VARCHAR2(40) NOT NULL,       --이미지(소)
    prod_totalstock    NUMBER(10) NOT NULL,       --재고수량
    prod_insdate       DATE,                           --신고일자(등록일)
    prod_properstock   NUMBER(10) NOT NULL,       --안전재고수량
    prod_size          VARCHAR2(20),                   --크기
    prod_color         VARCHAR2(20),                   --색상
    prod_delivery      VARCHAR2(255),                  --배달특기사항
    prod_unit          VARCHAR2(6),                    --단위(수량)
    prod_qtyin         NUMBER(10),                     --총입고수량
    prod_qtysale       NUMBER(10),                     --총판매수량
    prod_mileage       NUMBER(10),                     --개당 마일리지 점수
    CONSTRAINT pk_prod PRIMARY KEY ( prod_id ),
    CONSTRAINT fr_prod_lprod FOREIGN KEY ( prod_lgu )
        REFERENCES lprod ( lprod_gu ),
    CONSTRAINT fr_prod_buyer FOREIGN KEY ( prod_buyer )
        REFERENCES buyer ( buyer_id )
);

CREATE TABLE buyprod (
    buy_date   DATE NOT NULL,       --입고일자
    buy_prod   VARCHAR2(10) NOT NULL,       --상품코드
    buy_qty    NUMBER(10) NOT NULL,       --매입수량
    buy_cost   NUMBER(10) NOT NULL,       --매입단가
    CONSTRAINT pk_buyprod PRIMARY KEY ( buy_date,
    buy_prod ),
    CONSTRAINT fr_buyprod_prod FOREIGN KEY ( buy_prod )
        REFERENCES prod ( prod_id )
)

CREATE TABLE member (
    mem_id            VARCHAR2(15) NOT NULL,       --회원ID
    mem_pass          VARCHAR2(15) NOT NULL,       --비밀번호
    mem_name          VARCHAR2(20) NOT NULL,       --성명
    mem_regnol        CHAR(6) NOT NULL,       --주민등록번호앞6자리
    mem_regno2        CHAR(7) NOT NULL,       --주민등록번호뒤7자리
    mem_bir           DATE,                               --생일
    mem_zip           CHAR(7) NOT NULL,       --우편번호
    mem_add1          VARCHAR2(100) NOT NULL,       --주소1
    mem_add2          VARCHAR2(80) NOT NULL,       --주소2
    mem_hometel       VARCHAR2(14) NOT NULL,       --집전화번호
    mem_comtel        VARCHAR2(14) NOT NULL,       --회사전화번호
    mem_hp            VARCHAR2(15),                        --이동전화
    mem_mail          VARCHAR2(60) NOT NULL,       --E_mail주소
    mem_job           VARCHAR2(40),                       --직업
    mem_like          VARCHAR2(40),                       --취미
    mem_memorial      VARCHAR2(40),                       --기념일명
    mem_memorialday   DATE,                           --기념일날짜
    mem_mailage       NUMBER(10),                         --마일리지
    mem_delete        VARCHAR2(1),                        --삭제여부
    CONSTRAINT pk_member PRIMARY KEY ( mem_id )
)

CREATE TABLE cart (
    cart_member   VARCHAR2(15) NOT NULL,        --회원ID
    cart_no       CHAR(13) NOT NULL,        --주문번호
    cart_prod     VARCHAR2(10) NOT NULL,        --상품코드
    cart_qty      NUMBER(8) NOT NULL,        --수량
    CONSTRAINT pk_cart PRIMARY KEY ( cart_no,
    cart_prod ),
    CONSTRAINT fr_cart_member FOREIGN KEY ( cart_member )
        REFERENCES member ( mem_id ),
    CONSTRAINT fr_cart_prod FOREIGN KEY ( cart_prod )
        REFERENCES prod ( prod_id )
)

CREATE TABLE ziptb (
    zipcode   CHAR(7) NOT NULL,      --우편번호
    sido      VARCHAR2(2 CHAR) NOT NULL,       --특별시, 광역시, 도
    gugun     VARCHAR2(10 CHAR) NOT NULL,       --시, 군, 구
    dong      VARCHAR2(30 CHAR) NOT NULL,       --읍, 면, 동, 리, 건물명
    bunji     VARCHAR2(10 CHAR),                  --번지, 아파드동, 호수
    seq       NUMBER(5) NOT NULL
);       --자료순서

CREATE INDEX idx_ziptb_zipcode ON
    ziptb ( zipcode );

 --p.180
/*
INSERT : 테이블에 새로운 행을 추가할 때 실행.
- 컬럼명과 입력하는 값의 수가 동일해야 함
- 컬럼명과 입력하는 값의 데이터타입(자료형)이 동일해야 함
- 기본키와 필수(N.N) 컬럼은 반드시 입력해야 함
- 컬럼명이 생략되면 모든 컬럼의 값이 입력되야 함
- 입력되지 않은 컬럼의 값은 널(NULL) 값이 저장됨
- 입력되지 않은 컬럼에 기본 값이 선언된 컬럼은 기본 값이 저장됨
*/

INSERT INTO lprod (
    lprod_id,
    lprod_gu,
    lprod_nm
) VALUES (
    1,
    'P101',
    '컴퓨터제품'
);

INSERT INTO lprod (
    lprod_id,
    lprod_gu,
    lprod_nm
) VALUES (
    2,
    'P102',
    '전자제품'
);

INSERT INTO lprod (
    lprod_id,
    lprod_gu,
    lprod_nm
) VALUES (
    3,
    'P201',
    '여성캐주얼'
);

INSERT INTO lprod (
    lprod_id,
    lprod_gu,
    lprod_nm
) VALUES (
    4,
    'P202',
    '남성캐주얼'
);

INSERT INTO lprod (
    lprod_id,
    lprod_gu,
    lprod_nm
) VALUES (
    5,
    'P301',
    '피혁잡화'
);

INSERT INTO lprod (
    lprod_id,
    lprod_gu,
    lprod_nm
) VALUES (
    6,
    'P302',
    '화장품'
);

INSERT INTO lprod (
    lprod_id,
    lprod_gu,
    lprod_nm
) VALUES (
    7,
    'P401',
    '음반/CD'
);

INSERT INTO lprod (
    lprod_id,
    lprod_gu,
    lprod_nm
) VALUES (
    8,
    'P402',
    '도서'
);

INSERT INTO lprod (
    lprod_id,
    lprod_gu,
    lprod_nm
) VALUES (
    9,
    'P403',
    '문구류'
);
--* : 아스트리크
--SELECT : 데이터 검색
--LPROD 테이블의 모든 열과 행을 검색

SELECT
    *
FROM
    lprod;

--P181
/* 
-SELECT문은 테이블(행과 열로 이루어진 2차원 배열=RELATION)로부터
필요한 데이터를 질의(QUERY)하여 검색하는 명령문.
_SELECT, FROM절은 필수절임
*/

--P.181
--LPROD 테이블의 모든 컬럼(속성, attribute, field, 열)의
--정보를 검색
-- * : 아스트리크(모든 컬럼)


 --WHERE : 행필터 (왜여 왜그런데여?)

SELECT
    lprod_gu,
    lprod_nm
FROM
    lprod
WHERE
    lprod_gu <= 'P102';
 --LPROD 테이블의 데이터를 검색
 -- 단, 상품분류코드가 P201 미만인 정보만 검색
 --구분코드와 구분명만 보이자

SELECT
    lprod_gu,
    lprod_nm
FROM
    lprod
WHERE
    lprod_gu > 'P201';

SELECT
    lprod_gu,
    lprod_nm
FROM
    lprod
WHERE
    lprod_nm = '전자제품';
 
--lprod_id가 3인 row를 select하시오.
--lprod_id, lprod_gu, lprod_nm 컬럼을 모두 출력

SELECT
    lprod_id,
    lprod_nm,
    lprod_gu
FROM
    lprod
WHERE
    lprod_id = 3;

DESC lprod;  -- describe
 
 
 --p.181
 --업데이트는 쎄대여
 --LPROD 테이블의 LPROD_GU의 값이 P102인 데이터를 검색하여
 --해당 행의 LPROD_NM 컬럼의 값을 '향수로' 변경함

SELECT
    *
FROM
    lprod
WHERE
    lprod_gu = 'P102';

UPDATE lprod
    SET
        lprod_nm = '향수'
WHERE
    lprod_gu = 'P102';
 
 
--lprod 테이블을 lprod2 테이블로 복사
--LPROD 테이블의 모든 정보를 LPROD2테이블을
--생성하면서 복제(단, P.K, F.K는 복제가 안됨)

CREATE TABLE lprod2
    AS
        SELECT
            *
        FROM
            lprod;

SELECT
    *
FROM
    lprod2;
 
 
--lprod2 테이블의 lprod_gu가 P202인 lprod_nm을
--남성 케쥬얼에서 도서류로 update 하시오

SELECT
    *
FROM
    lprod2
WHERE
    lprod_gu = 'P202';

UPDATE lprod2
    SET
        lprod_nm = '도서류'
WHERE
    lprod_gu = 'P202';

COMMIT;
 
--lprod2 테이블에서 lprod_id가 7인
--lprod_gu를 P401에서 P303으로 update 하시오.

SELECT
    *
FROM
    lprod2
WHERE
    lprod_id = 7;

UPDATE lprod2
    SET
        lprod_gu = 'P303'
WHERE
    lprod_id = 7;
 
 /*DELETE문
 -테이블의 행을 삭제함
 -모든 행을 삭제할 수도 있고(WHERE절이 없을 때)
  특정 행을 삭제할 수도 있음(WHERE절이 있을 때)
  */
 --등푸른생선 주세여
 --DELETE FROM 테이블명
 --WHERE 조건;
 
 --LPROD 테이블에서 LPRO_NM이 화장품인
 --데이터를 삭제하시오.(ROW(=행,튜플,레코드)가 삭제 됨)

SELECT
    *
FROM
    lprod2
WHERE
    lpord_nm = '화장품';

DELETE FROM lprod2 WHERE
    lprod_nm = '화장품';
 
 
 
-- 고정길이, 가변길이
-- char(6)     'a' where ?? =  'a     ' , 성능좋고, 저장효율 좋고, 사용은 불편
-- varchar2(6) 'a' where ?? =  'a'      , 성능좀 나쁘고, 저장효율 좋고, 사용편함
 
 --P. 182
 --테이블의 모든 ROW와 COLUMN을 검색
 --SELECT * FROM 테이블명;
 --상품 테이블로부터 모든 row와 column을 검색하시오. 

SELECT
    *
FROM
    prod;
 
 --회원 테이블로부터 모든 row와 column을 검색하시오. 
 -- * : 아스트리크

SELECT
    *
FROM
    member;
 
 
 --장바구니 테이블로부터 모든 row와 column을 검색하시오. 

SELECT
    *
FROM
    cart;
 
--상품 테이블로부터 상품코드와 상품명을 검색하시오. 

SELECT
    prod_id,
    prod_name
FROM
    prod;
  
  --1. buyer 테이블을 buyer2 테이블로 복사하시오
  --(p.k, f.k는 복사가 안됨

CREATE TABLE buyer2
    AS
        SELECT
            *
        FROM
            buyer;
 
 -- 2. buyer2 테이블의  buyer_id, buyer_name, buyer_lgu
 --컬럼을 모두 select 하시오

SELECT
    buyer_id,
    buyer_name,
    buyer_lgu
FROM
    buyer2;

-- 3. buyer2 테이블의 buyer_id가 P30203인 buyer_name
--   값을 거성으로 update하시오

SELECT
    *
FROM
    buyer2
WHERE
    buyer_id = 'P30203';

UPDATE buyer2
    SET
        buyer_name = '거성'
WHERE
    buyer_id = 'P30203';
 
 
 --BUYER2 테이블의 BUYER_NAME이
 --피리어스인 ROW를 삭제하시오

SELECT
    *
FROM
    buyer2
WHERE
    buyer_name = '피리어스';

DELETE FROM buyer2 WHERE
    buyer_name = '피리어스';

COMMIT;
 
 /*
 산술연산자
 산술연산자를 사용하여 검색되는 자료값 변경
 산술연산식은 COLUMN명, 상수값, 산술연산자로 구성
 산술연산자는 +, -, *, /, () 로구성
 SELECT  산술연산식  FROM 테이블명
 */

SELECT
    mem_id,
    1004,
    ' 내일이 지나면..',
    mem_name,
    mem_mileage,
    mem_mileage / 12 AS "월 평균"
FROM
    member;
 
 
 --장바구니 테이블로부터 주문번호, 상품코드,
 -- 회원 ID, 수량을 검색하시오

SELECT
    cart_no,
    cart_prod,
    cart_member,
    cart_qty
FROM
    cart;
 
 --P.183
 -- 산술연산자는 +, -, *, /, () 로 구성
 --회원 테이블의 마일리지를 12로 나눈 값을 검색하시오
 --ROUND : 반올림 함수,(,2 : 소수점 2째자리까지 살리고 반올림)

SELECT
    mem_mileage,
    mem_mileage / 12,
    round
( mem_
            
            
 
 --상품 테이블(PROD)의 상품코드, 상품명, 판매금액을 
--검색 하시오?
--판매금액은  = 판매단가 * 55 로 계산한다.
--상품코드(PROD_ID), 상품명(PROD_NAME), 
--판매단가(PROD_SALE)
 
 SELECT PROD_ID
          ,PROD_NAME
          ,PROD_SALE*55
            
FROM PROD;

--P.183
--중복 ROW(행)의 제거
-- 상품 테이블(PROD)의 상품분류(PROD_LGU)를 
--중복되지 않게 검색

SELECT DISTINCT PROD_LGU
FROM PROD;

--DISTINCT : 중복 제거, 예약어
--컬럼목록의 맨 앞에 1회 사용

SELECT  DISTINCT CART_MEMBER
          , CART_PROD
FROM    CART
ORDER BY 1, 2;

--상품 테이블의 거래처코드를 중복되지
--않게 검색하시오 ?
--(Alias는 거래처)
--거래처코드 : PROD_BUYER

SELECT DISTINCT PROD_BUYER
FROM PROD;

--P.183
--ROW(행)을 SORT(정렬)하고자 하면 ORDER BY 절을 사용
--ASC(Ascending) : 오름차순,ASC는 생략 가능
--  숫자형은 0부터 9, 영문자는 A부터 Z, 한글은 가나다.. 순으로 정렬
--DESC(Descending) : 내림차순
--  숫자형은 9부터 0, 영문자는 Z부터 A, 한글은 하파타.. 순으로 정렬


SELECT     MEM_ID
          ,  MEM_NAME
          , MEM_BIR
          , MEM_MILEAGE
FROM    MEMBER
ORDER BY MEM_BIR DESC;


SELECT 'a나' COL1 FROM DUAL
UNION ALL
SELECT 'A나' FROM DUAL
UNION ALL
SELECT 'a나' FROM DUAL
UNION ALL
SELECT 'B나' FROM DUAL
UNION ALL
SELECT 'b나' FROM DUAL
UNION ALL
SELECT 'B나' FROM DUAL
ORDER BY 1;

--ALIAS(별칭)
/*
ALIAS?
1) SELECT절과 FROM절에 사용되는 별명
- 컬럼 출력시 부제목으로 사용
-ORDER BY절의 출력 순서를 지정시 사용 가능
- EX) A S "회원ID",    "회원ID",    회원ID(*)
2) FROM절에서 사용
- 테이블 명을 단순화하기 위해 사용
- SELECT문의 각 절에서 컬럼명을 구분할 때 사용
- 테이블명 ALIAS명
*/


SELECT MEM_ID           -- 회원ID
      , MEM_NAME           성명
      , MEM_BIR               생일      
      , MEM_MILEAGE       마일리지
FROM MEMBER
ORDER BY 성명;

--컬럼번호

SELECT MEM_ID              회원ID
      , MEM_NAME           성명
      , MEM_BIR               생일      
      , MEM_MILEAGE       마일리지
FROM MEMBER
ORDER BY 3;

--다중정렬

SELECT MEM_ID              회원ID
      , MEM_NAME           성명
      , MEM_BIR               생일      
      , MEM_MILEAGE       마일리지
FROM MEMBER
ORDER BY MEM_MILEAGE, 1;


--회원테이블(MEMBER)에서
--MEM_ID(회원ID), MEM_JOB(직업), 
--MEM_LIKE(취미)를 검색하기
--직업으로 오름차순, 취미로 내림차순, 
--회원ID로 오름차순 정렬

SELECT   MEM_ID       회원ID
          , MEM_JOB     직업
          , MEM_LIKE     취미
            
FROM MEMBER
ORDER BY MEM_JOB , MEM_LIKE DESC, 1 ASC;

--직업(MEM_JOB)이 회사원인 회원의 
--MEM_MEMORIAL 컬럼의 데이터를 
--NULL로 수정하기
--** MEM_MEMORIAL = NULL
--** 조건검색 시 ''(홀따옴표)를 사용함


SELECT *
FROM MEMBER
WHERE MEM_JOB = '회사원';

UPDATE MEMBER
SET      MEM_MEMORIAL = NULL
WHERE  MEM_JOB = '회사원';
COMMIT;
 
 --오름차순(NULL은 마지막에 위치)
 SELECT MEM_MEMORIAL, MEM_ID FROM MEMBER
 ORDER BY MEM_MEMORIAL ASC;
 
 --내림차순 (NULL은 처음에 위치)
  SELECT MEM_MEMORIAL, MEM_ID FROM MEMBER
 ORDER BY MEM_MEMORIAL DESC;
 
 --상품테이블(PROD)의 전체 컬럼을 검색하는데
--판매가(PROD_SALE)로 내림차순 후, 
--상품분류코드(PROD_LGU)로 오름차순 후
--상품명(PROD_NAME)으로 오름차순 정렬해보자
 
 SELECT * FROM PROD
 ORDER BY PROD_SALE DESC, PROD_LGU, PROD_NAME;
 
 --P.184
 
 SELECT PROD_NAME 상품명
          , PROD_SALE 판매가
 FROM PROD
 WHERE PROD_SALE = 170000; 
 
 
 SELECT PROD_NAME 상품명
          , PROD_SALE 판매가
 FROM PROD
 WHERE PROD_SALE <> 170000;  
 
 
 --p185
 --상품 중 매입가(PROD_COST)가 
--200,000원 이하인 상품을 검색하시오
--(ALIAS는 상품코드(PROD_ID), 
--상품명(PROD_NAME), 매입가(PROD_COST))

 SELECT PROD_COST 매입가
          , PROD_ID 상품코드
          , PROD_NAME 상품명
 FROM PROD
 WHERE PROD_COST <= 200000 ;
 
 --회원 중 76년도 1월 1일 이후에 
--태어난 회원을 검색하시오
--단, 주민등록번호 앞자리로 비교
--(ALIAS는 회원ID(MEM_ID), 
--회원명(MEM_NAME), 
--주민등록번호 앞자리(MEM_REGNO1))
 
 SELECT     MEM_ID 회원ID
      ,       MEM_NAME  회원명
      ,       MEM_REGNO1  주민등록번호앞자리
FROM MEMBER
WHERE MEM_REGNO1 > 760101  ;
 
 
 -- P.185
 -- 상품 중 상품분류가 P201 (여성 캐쥬얼)이거나
 -- 판매가가 170,000원인 상품 조회
 -- ALIAS : 상품명
 -- 거나/ 또는 => OR
 
 SELECT PROD_NAME AS 상품명
 , PROD_LGU         AS 상품분류
 , PROD_SALE        AS 판매가
 FROM PROD
 WHERE  PROD_LGU   = 'P201'
 OR       PROD_SALE  = 170000; 
 
 
 --상품 중 상품분류가 P201(여성 캐쥬얼)도 
--아니고 
--판매가가  170,000원도 아닌 상품 조회
--ALIAS : 상품명, 상품분류, 판매가
 
  SELECT PROD_NAME AS 상품명
      , PROD_LGU         AS 상품분류
       , PROD_SALE        AS 판매가
 FROM PROD
 WHERE PROD_LGU != 'P201'
AND      PROD_SALE  != 170000; 
 
SELECT PROD_NAME AS 상품명
      , PROD_LGU         AS 상품분류
       , PROD_SALE        AS 판매가
 FROM PROD
 WHERE NOT PROD_LGU = 'P201'
OR     PROD_SALE = 170000); 

 --상품 중 판매가가 300,000원 이상, 500,000원 
--이하인 상품을 검색  하시오 ?
--( Alias는 상품코드(PROD_ID), 
--상품명(PROD_NAME), 판매가(PROD_SALE) )
 
 SELECT PROD_ID 상품코드
           ,PROD_NAME 상품명
          ,PROD_SALE 판매가
FROM PROD
WHERE 300000<=PROD_SALE
AND            PROD_SALE<=500000;
 
 --문제 :
--회원(MEMBER) 테이블에서
--직업(MEM_JOB)이 공무원인 인원 중 
--마일리지(MEM_MILEAGE)가 1500 이상인 
--리스트를 검색하시오.
--모든 컬럼을 포함시키기
 
 
 SELECT     *
 FROM      MEMBER
 WHERE    MEM_JOB = '공무원'
 AND        MEM_MILEAGE >= 1500;
 
 
 --P185
 --상품 중 판매가가 150000원, 170000원, 330000원인 상품 조회
 --ALIAS : 상품명, 판매가
 
 SELECT PROD_NAME 상품명
      ,     PROD_SALE 판매가
 FROM   PROD
 WHERE  PROD_SALE IN (150000, 170000, 330000);
 
 --회원테이블(MEMBER)에서
 --회원ID(MEM_ID)가 c001, f001, w001인 회원만 검색하시오
 --ALIAS는 회원ID(MEM_ID), 회원명(MEM_NAME)
 
 SELECT MEM_ID        회원_ID,
             MEM_NAME   회원명
 FROM MEMBER
 WHERE  MEM_ID IN ('c001', 'f001', 'w001');
 
--P.186
--상품 분류테이블(LPROD)에서 
--현재 상품테이블(PROD)에 
--존재하는 분류만 검색(분류코드(LPROD_GU)
--, 분류명(LPROD_NM))
 
 SELECT    LPROD_GU 분류코드
          ,   LPROD_NM 분류명
 FROM   LPROD
 WHERE   LPROD_GU NOT IN (SELECT DISTINCT PROD_LGU  FROM   PROD) ;
 
 SELECT DISTINCT PROD_LGU
 FROM   PROD;
 
 
 --상품 중 판매가가 100,000원 부터  300,000원 
--사이의 상품 조회
--ALIAS : 상품명, 판매가
 
 SELECT   PROD_NAME 상품명
          ,   PROD_SALE 판매가
 FROM   PROD
 WHERE  PROD_SALE BETWEEN 100000 AND  300000; 
 
 --회원 중 생일이 1975-01-01에서 1976-12-31사이에 
--태어난 회원을 검색하시오 ? 
--( Alias는 회원ID, 회원 명, 생일 )
 
 SELECT     MEM_ID 회원ID
           ,   MEM_NAME 회원명
           ,   MEM_BIR 생일
FROM    MEMBER
WHERE  MEM_BIR  BETWEEN '1975-01-01'  AND '1976-12-31';

-- 날짜형과 날짜형 문자의 비교 시
--날짜형 문자 ->날짜형으로 자동 형변환
 
 
 --P.186
--상품 중 매입가(PROD_COST)가 300,000~1,500,000이고 
--판매가(PROD_SALE)가  800,000~2,000,000 인 상품을 검색하시오 ?
--( Alias는 상품명(PROD_NAME), 
--매입가(PROD_COST), 판매가(PROD_SALE) )
SELECT    PROD_NAME 상품명 
      ,      PROD_COST  매입가
      ,      PROD_SALE   판매가 
FROM      PROD
WHERE      ( PROD_COST BETWEEN 300000 AND 1500000) AND
(PROD_SALE BETWEEN 800000 AND 2000000);


--회원 중 생일이 1975년도 생이 아닌
--회원을 검색하시오 ?
--( Alias는 회원ID, 회원 명, 생일)
 
 SELECT   MEM_ID         회원ID
      ,       MEM_NAME  회원명
      ,       MEM_BIR       생일
 FROM   MEMBER
 WHERE  MEM_BIR NOT BETWEEN '1975-01-01' AND '1975-12-31';
 
 
-- P.186
-- LIKE 연산자
--LIKE와 함께 쓰이는 %, _ : 와일드카드
--% : 여러글자,  _ : 한글자
--삼% : 삼으로 시작하고 뒤에 여러글자가 나옴
-- _성% : 2번째 글자가 성으로 시작
--%치 : 치로 끝나는 글자(마지막 글자)
-- %여름% : 앞 뒤 상관없이 '여름'이라는 글자가 포함되면 됨

SELECT  PROD_ID 상품코드
,           PROD_NAME 상품명
FROM    PROD
WHERE   PROD_NAME LIKE '_성%';

SELECT PROD_ID 상품코드
,           PROD_NAME 상품명
FROM    PROD
WHERE PROD_NAME LIKE '%치';

SELECT PROD_ID 상품코드
,           PROD_NAME 상품명
FROM    PROD
WHERE PROD_NAME NOT LIKE '%치'


SELECT PROD_ID 상품코드
,           PROD_NAME 상품명
FROM    PROD
WHERE PROD_NAME LIKE '%여름%';

-- 회원테이블에서 김씨 성을 가진 회원을 
-- 검색하시오
-- ALIAS는 회원ID(MEM_ID), 성명(MEM_NAME)

SELECT  MEM_ID    회원ID  
,           MEM_NAME        성명
FROM MEMBER
WHERE  MEM_NAME LIKE '김%';

--회원테이블의 주민등록번호 앞자리를
-- 검색하여 1975년생을 제외한
--회원을 검색하시오
--ALIAS는 회원ID, 성명, 주민등록번호

SELECT   MEM_ID    회원ID  
,             MEM_NAME        성명
,               MEM_REGNO1 || '  ' || MEM_REGNO2  주민등록번호
FROM  MEMBER
WHERE MEM_REGNO1 NOT LIKE '75%' ;

--개똥이는 취업기념으로 삼성에서 만든 제품을 구입하고자 한다.
--가격은 100만원 미만이며 가격이 내림차순으로 정렬된 
--리스트를 보고자 한다.
--(ALIAS는 상품ID(PROD_ID), 상품명(PROD_NAME), 
--판매가(PROD_SALE), 제품설명글(PROD_DETAIL))
 
 
 SELECT   PROD_ID   상품
 ,             PROD_NAME   상품명
 ,          PROD_SALE    판매가
 ,          PROD_DETAIL 제품설명글
 FROM PROD
 WHERE PROD_NAME LIKE '%삼성%'
 AND PROD_SALE < 1000000
 ORDER BY  PROD_SALE DESC;
 
 -- P.193
 -- || : 둘 이상의 문자열을 연결하는 결합연산자
 SELECT 'a' || 'bcd' FROM DUAL;
 SELECT MEM_ID || '  NAME IS  ' || MEM_NAME FROM MEMBER;
 
 --CONCAT 함수 : 두 문자열을 연결하여 반환
 SELECT CONCAT('MY NAME IS ' ,MEM_NAME) FROM MEMBER; 
 
 -- CHR :  ASCII -> 문자 / ASCII : 문자를 ASCII
 SELECT CHR(65) "CHR", ASCII('ABC') "ASCII" FROM DUAL;
 SELECT ASCII (  CHR(65)  ) RESULT FROM DUAL;
 SELECT CHR(75) "CHR", ASCII('K') "ASCII" FROM DUAL;
  
 --P.194
 --LOWER :  소문자로 반환
 --UPPER : 대문자로 반환
 --INITCAP : 첫글자만 대문자로 반환
 
 --회원테이블의 회원ID를 대문자로 
 --변환하여 검색하시오
 --ALIAS 명은 변환전ID, 변환 후 ID
 SELECT MEM_ID 변환전ID
 ,   UPPER(MEM_ID) 변환후ID
 FROM MEMBER;
 
--P.194 

--상품테이블의 소비자가격(PROD_PRICE)과  
--소비자가격을 치환화여 다음과 같이 출력되게 하시오 
--ALIAS : PROD_PRICE  PROD_RESULT(LPAD함수를 통해 처리)
-- 공백에 * 넣기

SELECT  PROD_PRICE 
,            LPAD (PROD_PRICE, 10, '*') PROD_RESULT
FROM    PROD;

SELECT '<' || LTRIM ('            AAA            ') ||   '>' "LTRIM1"
             ,  '<' || LTRIM ('Hello  World',   'He') ||   '>' "LTRIM2"
             ,       '<' || LTRIM ('llo  HE World',   'He') ||   '>' "LTRIM3"
             ,            '<' || LTRIM ('Hello He  World',   'He') ||   '>' "LTRIM4"
             ,                    '<' || LTRIM ('HeHello  World',   'He') ||   '>' "LTRIM5"
FROM DUAL;

SELECT '<' || RTRIM ('            AAA            ') ||   '>' "RTRIM1"
             ,  '<' || RTRIM ('Hello  World',   'ld') ||   '>' "RTRIM2"
             ,            '<' || RTRIM ('Hello He  World',   'He') ||   '>' "RTRIM3"
             ,                    '<' || REPLACE ('HeHello  World',   'He') ||   '>' "RTRIM4"
FROM DUAL;

--TRIM : L + R
SELECT '<' || TRIM('     AAA     ') || '>' TRIM1
   , '<' || TRIM(LEADING 'a' FROM TRIM('    aaAaBaAaa')) || '>' TRIM2
   , '<' || TRIM( 'a' FROM 'aaAaBaAaa')|| '>' TRIM3
   , '<' || TRIM(BOTH 'a' FROM 'aaAaBaAaa') || '>' TRIM4
   , '<' || TRIM(TRAILING 'a' FROM 'aaAaBaAaa')  || '>' TRIM5
FROM SYS.DUAL;

--P.195
--SUBSTR *****


--*****
SELECT SUBSTR('SQL PROJECT',1,3)  AS RESULT1
   , SUBSTR('SQL PROJECT',5)    AS RESULT2
   , SUBSTR('SQL PROJECT',-7,3) AS RESULT3 --M이 음수이면 뒤쪽에서부터 처리
FROM   DUAL;

/
--회원테이블의 성씨 조회
SELECT MEM_ID               AS 회원ID
   , MEM_NAME
   , SUBSTR(MEM_NAME,1,1) AS 성씨
FROM   MEMBER;


--상품테이블의 상품명(PROD_NAME)의 
--4째 자리부터  2글자가
--'칼라' 인 상품의 상품코드(PROD_ID), 
--상품명(PROD_NAME)을 검색하시오 ?
--( Alias명은 상품코드(PROD_ID), 상품명(PROD_NAME) )

SELECT      PROD_ID  상품코드
,                PROD_NAME 상품명
FROM       PROD
WHERE     SUBSTR(PROD_NAME, 4 ,2) = '칼라' ;
AND          PROD_NAME LIKE '___칼라%' ;


--P.196
--P102000001 : 상품코드
--P102       : 대분류
--000001     : 순번
--상품테이블의 상품코드(PROD_ID)에서 왼쪽4자리, 
--오른쪽6자리를 검색하시오 ?
--(Alias명은 상품코드(PROD_ID),  대분류,  순번)

SELECT PROD_ID          상품코드
 ,          SUBSTR(PROD_ID,1,4)     대분류
,            SUBSTR(PROD_ID,5)       순번
FROM PROD;

--P.196
--거래처 테이블의 거래처명 중 '삼'-> '육'으로 치환

SELECT 
REPLACE(BUYER_NAME ,'삼', '육')
FROM BUYER;

--회원테이블의 회원성명 중 '이'-> '리'로 치환 검색하시오
--ALIAS 회원명, 회원명 치환

SELECT MEM_NAME 회원명
,          REPLACE(MEM_NAME, '이', '리')  회원명치환
FROM MEMBER;

--P.196
--INSTR (대상문자열,     찾을문자열, 시작위치, 글자수)
-- INSTR('HELLO HEIDI', 'HE',           1 ,          2) 
--INSTR(c1 ,c2, [m, [n]]) : m에서 시작해서 n번째의 c2의 위치를 출력
-- 1 : 첫번째 글자부터 HE를 찾음
-- 2 : 두번째

SELECT INSTR('hello heidi', 'he') result
from dual;

--문제 : I have a hat.
--1 첫번째 ha의 위치를 출력
-- 두번째 ha의 위치를 출력

select instr('I have a hat.','ha') 첫번째
, instr('I have a hat.', 'ha', 1, 2) 두번째
from dual;

--문제 : I have a hat that i had have been found 
--      that hat before 2 years ago.
--1. 상위 문장에서 5번째 ha의 위치를 출력
--INSTR(c1 ,c2, [m, [n]]) : m에서 시작해서 n번째의 c2의 위치를 출력

SELECT INSTR( 'I have a hat that i had have been found that hat before 2 years ago.', 'ha', 1, 5)
FROM DUAL;

--문제
--mepch@test.com
--상위 문자에서 @를 기준으로 다음과 같이 출력하기
--아이디 | 도메인
--------------------
--mepch  | test.com

SELECT SUBSTR('Mepch@test.com', 1,5) 아이디
, SUBSR('Mepch@test.com',7)  도메인
, INSTR('Mepch@test.com','@')
FROM  DUAL;

SELECT  SUBSTR('Mepch@test.com', 1, INSTR('Mepch@test.com','@')-1) 아이디
,  SUBSTR('Mepch@test.com', INSTR('Mepch@test.com','@')+1) 도메인
FROM DUAL;
 
 
 SELECT MEM_ID 
 ,MEM_NAME
 ,SUBSTR(MEM_MAIL,1,INSTR(MEM_MAIL,'@')-1) 아이디
 ,SUBSTR(MEM_MAIL,1,INSTR(MEM_MAIL,'@')+1) 도메인

 FROM MEMBER;
 
 
 --P.197
 -- LENGTH : 글지수,  LENGTHB : 글자의 BYTES
 -- 영문자/ 특수기호 : 1BYTE,  한글 : 3BYTES
 
 SELECT LENGTH('SQL 프로젝트' )  LENGTH
      ,  LENGTHB('SQL 프로젝트')  LENGTHB
        FROM DUAL;
        
        SELECT BUYER_ID     AS 거래처코드
      ,  LENGTH(BUYER_ID) AS 거래처코드길이
      ,  BUYER_NAME AS 거래처명
      , LENGTH(BUYER_NAME) AS 거래처명길이
      , LENGTHB(BUYER_NAME)AS 거래처명길이
        FROM BUYER;
 
 
 ---P.197
 --ABS   : 절대값
 
 SELECT ABS(-365)  FROM DUAL; --365
 
 --SIGN   ; 양수(1), 0 (0), 음수(-1)
 SELECT SIGN(12), SIGN(0), SIGN(-55) FROM DUAL;
 
--3의2승, 2의10승
SELECT POWER(3, 2), POWER(2, 10) FROM DUAL;

--제곱근
 SELECT SQRT(2), SQRT(9) FROM DUAL;
 
 
 --P.197
 SELECT   GREATEST (10, 20, 30) 가장큰값
   , LEAST(10, 20, 30)    가장작은값
FROM   DUAL;
 
  -- 숫자보다 한글이 큼
 
SELECT GREATEST('강아지', 256, '송아지') 가장큰값
   , LEAST('강아지', 256, '송아지')    가장작은값
FROM   DUAL;
 
 
 --P.198
--회원(MEMBER) 테이블에서 회원이름(MEM_NAME),  
--마일리지(MEM_MILEAGE)를 출력하시오
--(단, 마일리지가 1000보다 작은 경우 1000으로 변경) 
 
 
 SELECT     MEM_NAME 회원이름
,   GREATEST(MEM_MILEAGE,1000) 마일리지
FROM MEMBER;


-- P.197 
 --   ROUND :  반올림, TRUNC : 버림
 --   2 : 소수점 둘째자리까지 살리고
 --  -2 : 둘째자리에서 반올림
  SELECT ROUND(345.123, -2) FROM DUAL;
  SELECT ROUND(345.123, -1) FROM DUAL;
  SELECT ROUND(345.123, 0) FROM DUAL;
  SELECT ROUND(345.123, 1)  FROM DUAL;
  SELECT ROUND(345.123, 2) FROM DUAL;
  --양수면 살리고, 음수면 에서
   SELECT TRUNC(345.123, 0) FROM DUAL;
   SELECT TRUNC(345.123, 1) FROM DUAL;
   SELECT TRUNC(345.123, 2 ) FROM DUAL;
   SELECT ROUND(345.123, -1)  결과1
 ,           TRUNC(345.123, -1) 결과2
   FROM DUAL;

 -- 회원 테이블의 마일리지를 12로 나눈 값을 검색
 --(소수 2째자리 살리기 반올림, 절삭)
 
 
 SELECT MEM_MILEAGE / 12
 ,          ROUND(MEM_MILEAGE / 12 ,2) 살리기반올림
 ,          TRUNC(MEM_MILEAGE / 12, 2) 절삭

 FROM MEMBER;
 
 
 --P.198
--상품테이블의 상품명, 원가율( 매입가 / 판매가 )을  비율(%)로
--(반올림 없는 것과 소수 첫째자리 살리기 반올림 비교) 검색하시오 ?
--(Alias는 상품명, 원가율1, 원가율2)
 
 SELECT    PROD_NAME  상품명
 ,             PROD_COST / PROD_SALE*100 원가율1
 ,              ROUND(PROD_COST / PROD_SALE *100, 1)  원가율2
 FROM  PROD;
 
 -- P.198
 -- int nameuji = 10%3;
 SELECT MOD(10, 3) FROM DUAL;
 
 --회원테이블(MEMBER)의 마일리지를 12로 나눈 나머지를 구하시오
--ALIAS는 회원ID(MEM_ID), 회원명(MEM_NAME), 
--마일리지원본(MEM_MILEAGE), 마일리지결과(MEM_MILEAGE)
 
 SELECT    MEM_ID 회원ID
 ,              MEM_NAME    회원명
 ,              MEM_MILEAGE 마일리지원본
 ,              MOD(MEM_MILEAGE, 12)  마일리지결과
 FROM MEMBER;
 
 
 -- P.198 
 --  FLOOR : 내림(마룻바닥)
 --  CEIL : 올림(천장)
 
 SELECT FLOOR(1332.69), CEIL(1332.69) FROM DUAL;
 SELECT FLOOR(-1332.69), CEIL(-1332.69) FROM DUAL;
 SELECT FLOOR(2.69), CEIL(2.69) FROM DUAL;
 SELECT FLOOR(-2.69), CEIL(-2.69) FROM DUAL;

 
--문제
--  -3.141592의 내림(FLOOR)과 올림(CEIL)을 구하시오
--ALIAS : 원본, 내림, 올림
SELECT  -3.141592  원본
,          FLOOR(-3.141592)   내림
,           CEIL(-3.141592)  올림
 FROM  DUAL;
 
 -- P.199
 --SYSDATE ★★★★★
 -- 시스템 날짜의 연-월-일 시:분:초
 SELECT SYSDATE FROM DUAL;
 -- 시스템 날짜의 연-월-일 시:분:초. 1000분의 1초
  SELECT SYSTIMESTAMP FROM DUAL;

 -- P.199
 SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD HH:MI:SS') 현재시간
      ,       SYSDATE - 1 AS 어제이시간
      ,       SYSDATE + 1 AS 내일이시간
      , TO_CHAR(SYSDATE + 1/24, 'YYYY-MM-DD HH:MI:SS') 한시간후
      , TO_CHAR(SYSDATE + 1/(24*60), 'YYYY-MM-DD HH:MI:SS') 일분후
        FROM DUAL;
 
 --P.199
--회원테이블(MEMBER)의 생일과 
--12000일째 되는 날을 검색하시오 ?
--(Alias는 회원명(MEM_NAME), 
--생일(MEM_BIR), 12000일째)
--교수님 시간 표시의 경우 오전 오후(AM, PM, A.M., P.M.)가 표시되거나
--24시간 형식(HH24)으로 출력되게는 할 수 없는 걸까요...?
 
 
 SELECT  MEM_NAME 회원명
 ,            MEM_BIR  생일
 ,            MEM_BIR + 12000 "12000일째"
 ,         TO_CHAR(MEM_BIR + 12000, 'YYYY-MM-DD HH:MI:SS AM')
 FROM MEMBER;
 
 --나는 몇 일을 살았을까??
 SELECT TO_DATE('1993-09-03') 내생일
         , ROUND(SYSDATE - TO_DATE('1993-09-03'),1) 내가산일수
 FROM DUAL;
 
--문제 : 나는 몇 일을 살았는가? TO_DATE('2015-04-10')함수 이용
--단, 밥은 하루에 3번을 먹음.
--      소수점 2째자리까지 반올림하여 처리하시오.
--ALIAS : 내생일, 산일수, 밥먹은수, 
--밥먹은비용(한끼에 3000원으로 처리)

SELECT TO_DATE('1993-09-03') 내생일
,           ROUND(SYSDATE - TO_DATE('1993-09-03'), 2) 산일수
,           ROUND(SYSDATE - TO_DATE('1993-09-03'), 2) * 3 밥먹은수
,           ROUND(SYSDATE - TO_DATE('1993-09-03'), 2) * 3 * 3000 밥먹은비용
 FROM DUAL;

--p.199
-- ADD_MONTHS()함수 :  월을 더한 날짜 
-- 오늘부터 5월  후의 날짜
SELECT ADD_MONTHS(SYSDATE, 5) FROM DUAL;
 
 -- NEXT_DAY()  :  가장 빠른 요일의 날짜
 --LAST_DAY()      :    월의 마지막 날짜
 SELECT NEXT_DAY(SYSDATE, '월요일')
          ,       NEXT_DAY(SYSDATE, '금요일')
          ,       LAST_DAY(SYSDATE)
FROM    DUAL;
 
--이번달이 며칠이 남았는지 검색하시오?
-- ALIAS : 오늘날짜, 이달마지막날짜, 이번달에남은날짜
 
SELECT      SYSDATE  오늘날짜
      ,         LAST_DAY(SYSDATE) 이달마지막날짜
       ,        LAST_DAY(SYSDATE) - SYSDATE        이번달에남은날짜    
 FROM DUAL;
 
 --P. 200
 -- 날짜 ROUND    /   TRUNC
 -- FMT(FOMAT : 형식) : YEAR(연도) , MONTH(월), DAY(요일) , DD(일)...
 SELECT ROUND(SYSDATE, 'MM') -- 이번달 50%를 넘었으므로 7월 1일
          ,   TRUNC(SYSDATE, 'MM') --이번달 50%를 넘었지만 버려서 6월 1일
 FROM DUAL;
 
 SELECT ROUND(SYSDATE, 'YEAR') --올해 50%를 안넘겼으므로  1월 1일
      ,    TRUNC(SYSDATE, 'YEAR')  -- 올해 50%를 안넘김 버려서 1월 1일
        FROM DUAL;
 
-- P.200
-- MONTHS_BETWEEN    : 두 날짜 사이의 달수를 숫자로 리턴
SELECT MONTHS_BETWEEN(SYSDATE, '1993-09-03')
FROM DUAL;


-- EXTRACT(★★★)   :  날짜에서 필요한 부분만 추출
-- (FMT :YEAR(년), MONTH(월), DAY(일), HOUR(시), MINUTE(분),  SECOND(초))
SELECT  EXTRACT(YEAR FROM SYSDATE)  년도
      ,    EXTRACT(MONTH FROM SYSDATE)    월
      ,   EXTRACT(DAY FROM SYSDATE)   일
      ,   EXTRACT(HOUR FROM SYSTIMESTAMP)-3    시
      ,   EXTRACT(MINUTE FROM SYSTIMESTAMP)   분
      ,   EXTRACT(SECOND FROM SYSTIMESTAMP)   초
FROM DUAL;
 
 --연-월-일 시:분:초.밀리세컨드
 SELECT TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH:SS:FF3')
 FROM DUAL;
 
 --생일이 3월인 회원을 검색하시오
--(ALIAS : 회원ID(MEM_ID), 
-- 회원명(MEM_NAME), 생일(MEM_BIR))
 
 SELECT MEM_ID  회원ID
 ,    MEM_NAME   회원명
 ,    MEM_BIR    생일
FROM    MEMBER 
WHERE     EXTRACT(MONTH FROM MEM_BIR) = 3  
 AND        MEM_BIR LIKE    '%/03/%'
 AND        SUBSTR(MEM_BIR, 4, 2) = '03';
 
--문제
--입고상품(BUYPROD) 중에 3월 에 입고된 내역을 검색하시오
--ALIAS : 상품코드(BUY_PROD), 입고일자(BUY_DATE)
--, 매입수량(BUY_QTY), 매입단가(BUY_COST)
--EXTRACT 사용하기, SUBSTR 사용하기, LIKE 사용하기
 
 SELECT BUY_PROD 상품코드
      ,    BUY_DATE 입고일자
      ,    BUY_QTY  매입수량
      ,    BUY_COST  매입단가
FROM BUYPROD
WHERE EXTRACT(MONTH FROM BUY_DATE) = 3
AND     BUY_DATE    LIKE    '%/03/%'
AND     SUBSTR(BUY_DATE, 4, 2) ='03';
 
 --P.201 
 -- CAST : 명시적 형 변환
 -- CHAR (30) : 고정길이 문자형
 -- VARCHAR2 (30)    :  가변길이 문자형
 SELECT      ' [ ' || 'Hello' || ' ] '   형변환
          ,     ' [ ' || CAST('Hello' AS CHAR(30))  || ' ] '  고정길이문자형변환
          ,      ' [ ' || CAST( 'Hello' AS VARCHAR2(30)) || ' ] ' 가변길이문자형변환
 FROM     DUAL ;
 
 --★★★
 -- TO_DATE()   :   날짜형문자를 날짜형으로 형변환
 -- CAST :   날짜형 문자를 지정된 형으로 형변환
 -- '2022/05/17' + 1    :   날짜형 문자 + 숫자 시=> 날짜형 문자가 숫자로 자동형변환
 SELECT '2022/05/17'
  ,           TO_DATE('2022/05/17')   
  ,           CAST('2022/05/17' AS DATE)  +   1
  FROM     DUAL ;
           
--P. 201
--TO_CHAR() : 숫자/문자/날짜를 지정한 형식의 문자열로 반환
-- 오늘 날짜를 이러한 형식의 문자열로 반환
SELECT TO_CHAR(SYSDATE, 'AD YYYY, CC"세기"    ')
FROM    DUAL;
--오류발생
SELECT TO_CHAR('2008-12-25', 'YYYY.MM.DD HH24:MI:SS')
FROM    DUAL;

--★★★★
-- TO_DATE : 2008-12-25는 연-월-일 형식인
-- 날짜형 문자라고 라클이에게 알려줌
SELECT  TO_CHAR(TO_DATE('2008-12-25', 'YYYY.MM.DD'), 'YYYY.MM.DD HH24:MI:SS')
FROM    DUAL;

 

--P.202
-- 상품테이블에서 상품입고일을 '2008-09-28 12:00:00' 
--형식으로 나오게 검색하시오.
--(Alias 상품명(PROD_NAME), 상품판매가(PROD_SALE)
--, 입고일(PROD_INSDATE))
 -- '2008-09-28 12:00:00'  :  날짜형 문자
-- 입고일 PROD_INSDATE : DATE이므로 TO_DATE가 필요 없음

SELECT    PROD_NAME  상품명
      ,       PROD_SALE  상품판매가
      ,       TO_CHAR(PROD_INSDATE, 'YYYY-MM-DD HH:MI:SS')  입고일
from PROD;
 
--어려운 문제
--장바구니 테이블을 사용하여 다음처럼 출력해보자
--ALIAS : 장바구니 번호, 구매일시
-- 구매일시는 '2005-04-03 12:00:00' 형식으로 출력
SELECT CART_NO 장바구니번호
      ,   TO_CHAR(TO_DATE( SUBSTR(CART_NO, 1, 8) , 'YYYYMMDD'), 'YYYY-MM-DD HH:MI:SS') 구매일시
FROM    CART;

--쉬운문제
--회원 테이블을 사용하여 다음처럼 출력해보자
--ALIAS :   회원ID(MEM_ID), 회원명(MEM_NAME), 회원생일(MEM_BIR)
--회원생일은 '1985-03-02 12:00:00' 형식으로 출력
-- YY : 2자리연도, MON : ,1월, HH24 : 24시간형식, AM : 오전/오후


SELECT  MEM_ID 회원ID
,           MEM_NAME  회원명
,           TO_CHAR(MEM_BIR, 'YYYY-MM-DD HH:MI:SS AM')  회원생일
FROM MEMBER;
 
 
 --P.202
 -- TO_CHAR() 함수 중 숫자를 문자로 형변환
 SELECT 1234.6 + 0.4 FROM DUAL;
 
 SELECT TO_CHAR(1234.6,'L9,999.00')
 FROM DUAL;
 
  SELECT TO_CHAR(-1234.6,'L9,999.00PR')
 ,           TO_CHAR(-1234.6,'L9,999.00MI')
 FROM DUAL;
 
 SELECT TO_CHAR(255, 'XXX') FROM DUAL;
 
 --문제
--상품 판매가를 다음과 같은 형식으로 출력하시오
--￦230,000
--ALIAS : 상품ID(PROD_ID), 상품명(PROD_NAME)
--, 판매가(PROD_SALE)
 
 SELECT PROD_ID  상품ID
 ,          PROD_NAME  상품명
 ,        TRIM( TO_CHAR(PROD_SALE, 'L99,99,99,99,99,999,999'))  판매가
 FROM PROD;
 
 --P.203
--상품테이블에서 상품코드, 상품명, 매입가격, 
-- 소비자가격, 판매가격을 출력하시오. 
-- (단, 가격은 천단위 구분 및 원화표시)
 
 SELECT PROD_ID  상품코드
 ,      PROD_NAME  상품명
 ,      TO_CHAR(PROD_COST, 'L999,999,999') 매입가격
 ,      TO_CHAR(PROD_PRICE, 'L999,999,999')   소비자가격
 ,      TO_CHAR(PROD_SALE, 'L999,999,999')   판매가격
 FROM PROD;
 
 --문제
--매입테이블(BUYPROD)의 매입가의 평균
--AVG(BUY_COST)을 다음 형식으로 출력
--소수점 2번째 자리까지 살리고 살리고~ 반올림처리
--￦210,000.350
--원표시 : ㄹ + 한자키
 
 SELECT    TO_CHAR(ROUND(AVG(BUY_COST), 2), 'L999,999.000')
 FROM BUYPROD;
 
 --P. 203
 -- TO NUMBER : 숫자형식의 문자열 -> 숫자로 반환
 -- 숫자형 문자 + 숫자 => 숫자로 자동형변환 + 숫자 =>숫자의 결과
 SELECT '3.1415' + 1 FROM DUAL;
 -- 숫자형문자(O) -> 숫자형  변환
 SELECT TO_NUMBER('3.1415') FROM DUAL;
 
 -- 문자 (X) -> 숫자형 변환 (X)
 SELECT TO_NUMBER('\1,200') + 1 FROM DUAL;
 
  -- 문자 (X) -> 숫자형 변환 (X)
 SELECT TO_NUMBER('개똥이') + 1 FROM DUAL;
 
 --라클아 이거 숫자야. \는 L형식이고,
 --','는 천단위 구분기호야 라고 알려줌
 SELECT TO_NUMBER('\1,200', 'L999,999') + 1 FROM DUAL;
 --이런 형식으로 출력
 SELECT TO_CHAR('1200' , 'L999,999') FROM DUAL;
 
 --P.203
--회원테이블(MEMBER)에서 이쁜이회원(MEM_NAME='이쁜이')의
--회원Id 2~4 문자열을 숫자형으로 치환한 후 
--10을 더하여 새로운 회원ID로 조합하시오 ?
--(Alias는 회원ID(MEM_ID), 조합회원ID)
 SELECT     MEM_ID 회원ID
 ,              SUBSTR(MEM_ID,1,1)  
                 ||   TRIM( TO_CHAR(TO_NUMBER(SUBSTR(MEM_ID,2) ) + 10, '000')) 조합회원ID
 FROM MEMBER
 WHERE MEM_NAME = '이쁜이';
 
 -- 상품테이블(PROD)에서
 -- 상품코드(PROD_ID)가 'P101000001'인 데이터의
 --다음과 같이 1 증가시켜보자. (P101과 000001을 분리)
 -- P101000002
 --ALIAS : 상품코드, 다음상품코드
 
 SELECT PROD_ID       상품코드
 ,          SUBSTR(PROD_ID, 1, 1)
  ||          TO_CHAR(SUBSTR(PROD_ID, 2) + 1) 다음상품코드
 FROM PROD
 WHERE PROD_ID = 'P101000001';
 
 SELECT PROD_ID       상품코드
 ,          SUBSTR(PROD_ID, 1, 4)
||       TRIM( TO_CHAR(SUBSTR(PROD_ID,5) + 1, '000000'))다음상품코드
 FROM PROD
 WHERE PROD_ID = 'P101000001';
 
 
 --P.203
 -- TO_DATE  : 날짜형식의 문자열을 DATE형으로 반환
 SELECT '2009-03-05' + 3 FROM DUAL; --오류남
 
 SELECT TO_DATE('2009-03-05') + 3 FROM DUAL;
 
 --라클아 이거 날짜형 문자야
 --2009는 YYYY이고, 03은 MM이고, 05는 DD야 라고 알려줌
 SELECT TO_DATE('2009-03-05', 'YYYY-MM-DD') + 3 FROM DUAL;
 
 --문(TO_CHAR) 날(대상) 날(형식) (O)
 --문(TO_CHAR) 문(대상) 날(형식)  (X)
 --문(TO_CHAR) 숫(대상) 날(형식)  (X)
 SELECT TO_CHAR('200803101234' , 'YYYY-MM-DD HH24:MI')
 FROM DUAL;         -- (X), 앞에 TO_DATE를 써서 '200803101234'가 날짜임을 알려줘야함
 
-- (O)
  SELECT TO_DATE('2009-03-10') + 3 FROM DUAL;
-- (X)
  SELECT TO_DATE('200803101234') + 3 FROM DUAL;
  
  --라클이한테 알려줌
 SELECT TO_CHAR(TO_DATE('200803101234' , 'YYYYMMDDHHMI') +3, 'YYYY-MM-DD HH24:MI')
 FROM DUAL;
 --(O)
 SELECT TO_CHAR(TO_DATE('200803101234', 'YYYY-MM-DD HH:MI'), 'YYYYMMDDHH24MI')
 FROM DUAL;
 
--(O) : 날짜형문자이므로
SELECT TO_DATE('20220621') FROM DUAL;
--(X) : 시간때문에 인식이 안됨
SELECT TO_DATE('202206211619') FROM DUAL;
--(O) : 날짜형문자이므로. (년.월.일 / 년/월/일 / 년-월-일)
SELECT TO_DATE('2022-06-21') FROM DUAL;
--(X) : 시간때문에 인식이 안됨
SELECT TO_DATE('2022-06-21 16:19') FROM DUAL;
--(O) : 이럴 땐 라클이에게 알려줘야함
SELECT TO_DATE('2022-06-21 16:19','YYYY-MM-DD HH24:MI') FROM DUAL;
 
 --(O) : 날짜형문자이므로.(년.월.일 / 년/월/일 / 년-월-일)
SELECT TO_DATE('2021.12.25') FROM DUAL;
--(X) : 11:10 때문에 인식 안됨
SELECT TO_DATE('2021.12.25 11:10') FROM DUAL;
--(O) : 이럴 땐 라클이에게 알려줘야 함
SELECT TO_DATE('2021.12.25 11:10','YYYY.MM.DD HH:MI') FROM DUAL;
--(O) : 날짜형문자이므로.(년.월.일 / 년/월/일 / 년-월-일)
SELECT TO_DATE('2021/12/25') FROM DUAL;
--(X) : '2021/12/25'는 날짜형문자이므로
SELECT TO_CHAR('2021/12/25','YYYY/MM/DD') FROM DUAL;
--(O) : TO_DATE('2021/12/25')는 날짜형이므로
SELECT TO_CHAR(TO_DATE('2021/12/25'),'YYYY/MM/DD') FROM DUAL;
--SELECT TO_CHAR(동그라미, 'YYYY-MM-DD') FROM DUAL;
SELECT TO_CHAR(TO_DATE('2021.12.25 11:10','YYYY.MM.DD HH:MI'),'YYYY/MM/DD') FROM DUAL;
 
--P.204
--회원테이블(MEMBER)에서 주민등록번호1(MEM_REGNO1)을
--날짜로 치환한 후 검색하시오
--(Alias는 회원명(MEM_NAME), 주민등록번호1, 
--치환날짜(MEM_REGNO1 활용) 
 
 SELECT MEM_NAME    회원명
 ,            MEM_REGNO1   주민등록번호1
 ,            TO_DATE(MEM_REGNO1, 'YYMMDD' ) 치환날짜
 FROM MEMBER;
 
 --장바구니 테이블(CART)에서 장바구니번호(CART_NO)를
--날짜로 치환한 후 다음과 같이 출력하기
--2005년 3월 14일
--ALIAS : 장바구니번호, 상품코드, 판매일, 판매수
 
 SELECT   CART_NO 장바구니번호
 ,              CART_PROD 상품코드
   , TO_CHAR(TO_DATE(SUBSTR(CART_NO,1,8),'YYYYMMDD'),'YYYY"년 "MONDD"일"') 판매일 ,              CART_QTY  판매수
 FROM CART;
 
 
 --P.205
 --거래처테이블에서 거래처명, 담당자 조회
 SELECT BUYER_NAME   거래처명
 ,             BUYER_CHARGER 담당자
 FROM BUYER;
 
 --거래처 담당자 성씨가 '김'이면 NULL로 갱신
 SELECT BUYER_NAME 거래처명
      ,      BUYER_CHARGER  담당자
 FROM   BUYER
 WHERE BUYER_CHARGER  LIKE '김%';
 
 --업데이트 쎄대여
 UPDATE  BUYER
 SET        BUYER_CHARGER = NULL
 WHERE BUYER_CHARGER  LIKE '김%';
 
--거래처 담당자 성씨가 '성'이면 White Space로 갱신
--White Space : '' = null
 
 SELECT BUYER_NAME 거래처명
      ,      BUYER_CHARGER  담당자
 FROM   BUYER
 WHERE BUYER_CHARGER   LIKE '성%';
 
UPDATE  BUYER
SET         BUYER_CHARGER = ''
WHERE   BUYER_CHARGER  LIKE '성%';
 
 
 --P.206
 --담당자가 NULL인 데이터를 검색
 
 SELECT BUYER_NAME 거래처
 , BUYER_CHARGER  담당자
 FROM BUYER
 WHERE BUYER_CHARGER IS NULL;
 
 --담당자가 NULL이 아닌 데이터를 검색
 SELECT BUYER_NAME  거래처
 , BUYER_CHARGER  담당자
 FROM BUYER
 WHERE BUYER_CHARGER IS NOT NULL;
 
 --해당 컬럼이 NULL일 경우에 대신할 문자나 숫자 치환
 --1) NULL이 존재하는 상태로 조회
SELECT BUYER_NAME 거래처명
,           BUYER_CHARGER 담당자
FROM BUYER;
 
 --2) NVL을 이용 NULL값일 경우만 '없다'로 치환
-- ☆☆☆☆☆ NVN :널바라 
 SELECT BUYER_NAME 거래처명
,           NVL(BUYER_CHARGER, '없다') 담당자
FROM BUYER;

 --P.206
 --전체회원 마일리지에 100을 더한 수치를 검색
 --ALIAS : 성명, 마일리지, 변경마일리지

 SELECT MEM_NAME             성명
      ,       MEM_MILEAGE     마일리지
      ,       MEM_MILEAGE  + 100   변경마일리지
FROM        MEMBER;
 
 
 --회원 성씨가 'ㅂ'을 포함하면 마일리지를 NULL로 갱신
 --배, 박, 변..
 
 SELECT MEM_NAME
 ,      MEM_MILEAGE
 FROM MEMBER
 WHERE MEM_NAME >= '바' AND MEM_NAME<= '빟';
 
 UPDATE  MEMBER
 SET  MEM_MILEAGE = NULL
 WHERE  MEM_NAME >= '바' AND MEM_NAME<= '빟';

--P.206 
 SELECT NULL +10 덧셈
       , 10* NULL     곱셈
       , 10/NULL      나눗셈
       , NULL -10     뺄셈
  FROM DUAL;
 
 --P. 207
 --회원 마일리지에 100을 더한 수치를 검색
 --ALIAS : 성명, 마일리지, 변경마일리지
 
 SELECT MEM_NAME             성명
      ,       MEM_MILEAGE     마일리지
      ,      NVL( MEM_MILEAGE,0)  + 100   변경마일리지
FROM        MEMBER;
 
 --회원 마일리지가 있으면 '정상 회원', NULL이면
 --'비정상 회원'으로 검색하시오
 --NVL2 사용, ALIAS 는 성명, 마일리지, 회원상태
 --NVL2(NULL, '정상회원', '비정상 회원')
 
 --NVL2 : NULL이 아니면 두번째 인수, NULL이면 세번째 인수
 SELECT MEM_NAME             성명
      ,       MEM_MILEAGE     마일리지
      ,      NVL2( MEM_MILEAGE, '정상 회원', '비정상 회원')     변경마일리지
 FROM        MEMBER;
 
 --P.207
 SELECT NULLIF(123, 123)  AS "같을경우 NULL반환"
         , NULLIF(123, 1234)  AS "다른경우 앞인수반환"
         , NULLIF('A', 'B')       AS  "다른경우 앞인수반환"
FROM DUA L;    

--코어ㄹ리즈  : 파라미터 중 NULL이 아닌 첫번재 파라미터 반환
SELECT COALESCE (NULL, NULL, 'HELLO', NULL, 'WORLD')
FROM DUAL;
 
 --9    :   비교대상
 --'D'  :   ELSE
 SELECT DECODE (3
                      ,  10,  'A'
                      ,  9,   'B'
                      ,  8,    'C'
                      , 'D')
FROM DUAL;                        
 
 
SELECT PROD_LGU
      ,   SUBSTR(PROD_LGU, 1, 2) 앞두자리
      ,   DECODE(SUBSTR(PROD_LGU, 1, 2)
                    , 'P1', '컴퓨터/전자 제품'
                    , 'P2', '의류'
                    , 'P3', '잡화'
                    , '기타')   결과
FROM PROD;                      
 
 --P.208
 --상품분류(PROD_LGU) 중  앞의 두 글자가  'P1' 이면 
--판매가(PROD_SALE)를 10%인상하고
--'P2' 이면 판매가를 15%인상하고,  
--나머지는 동일 판매가로 
--검색하시오 ? 
--(DECODE 함수 사용, 
--Alias는 상품명(PROD_NAME), 판매가(PROD_SALE), 변경판매가 )
 
 SELECT PROD_NAME  상품명
,            PROD_SALE  판매가
,           DECODE(substr(PROD_LGU, 1, 2)
                  ,   'P1', PROD_SALE * 1.1
                  ,   'P2', PROD_SALE *1.15
                  ,    PROD_SALE) 변경판매가
FROM PROD;
 
 --대전측기사에서는 3월에 생일인(MEM_BIR) 회원을
--대상으로 마일리지를 10% 인상해주는 이벤트를
--시행하고자 한다. 생일이 3월이 아닌 회원은
--짝수인 경우만 5% 인상 처리한다.
--이를 위한 SQL을 작성하시오.
--ALIAS : 회원ID, 회원명, 마일리지, 변경마일리지

  SELECT  MEM_ID  회원ID
      ,       MEM_NAME  회원명
      ,       MEM_MILEAGE  마일리지
      , DECODE(EXTRACT(MONTH  FROM MEM_BIR)
                            ,   3,  MEM_MILEAGE*1.1
                            , MOD(EXTRACT(MONTH  FROM MEM_BIR), 2), MEM_MILEAGE 
                            , MEM_MILEAGE * 1.05) 변경마일리지
 FROM   MEMBER;
 
 --선생님 답
  SELECT  MEM_ID  회원ID
      ,       MEM_NAME  회원명
      ,       MEM_MILEAGE  마일리지
      ,       DECODE(EXTRACT(MONTH  FROM MEM_BIR) 
                           ,   3,  MEM_MILEAGE*1.1                               
                           ,  DECODE(MOD(EXTRACT(MONTH  FROM MEM_BIR), 2)
                           ,  0 ,MEM_MILEAGE * 1.05
                           ,  MEM_MILEAGE)
                             )변경마일리지
 FROM   MEMBER;
 
 --P.208
 --SIMPLE CASE EXPRESSION
 --
 SELECT CASE WHEN '나' = '나' THEN '맞다'
                    ELSE '아니다'
                    END AS "RESULT"
FROM DUAL;                    
 
-- SEARCHED CASE EXPRESSION
SELECT CASE '나' WHEN  '철호' THEN '아니다'
                            WHEN  '너' THEN '아니다'
                            WHEN  '나' THEN '맞다'
                            ELSE '모르겠다'
                            END RESULT
FROM DUAL;                            
 
 SELECT PROD_NAME 상품, PROD_LGU 분류,
        CASE WHEN PROD_LGU = 'P101' THEN '컴퓨터제품'
                WHEN PROD_LGU = 'P102' THEN '전자제품'
                WHEN PROD_LGU = 'P201' THEN '여성캐쥬얼'
                WHEN PROD_LGU = 'P202' THEN '남성캐쥬얼'
                 WHEN PROD_LGU = 'P301' THEN '피혁잡화'
                WHEN PROD_LGU = 'P302' THEN '화장품'
                WHEN PROD_LGU = 'P401' THEN '음반/CD'
                 WHEN PROD_LGU = 'P402' THEN '도서'
             WHEN PROD_LGU = 'P403' THEN '문구류'
             ELSE '미등록분류'
             END "상품분류"
FROM PROD;             

--10만원 초과 상품판매가 가격대를 검색하시오
SELECT PROD_NAME        AS "상품"
      ,   PROD_PRICE      AS "판매가"
      ,   CASE    WHEN (100000 - PROD_PRICE)>= 0 THEN '10만원 미만'
                        WHEN (200000 - PROD_PRICE)>= 0 THEN '10만원대'
                        WHEN (300000 - PROD_PRICE)>= 0 THEN '20만원대'
                        WHEN (400000 - PROD_PRICE)>= 0 THEN '30만원대'
                        WHEN (500000 - PROD_PRICE)>= 0 THEN '40만원대'  
                        WHEN (600000 - PROD_PRICE)>= 0 THEN '50만원대'
                        WHEN (700000 - PROD_PRICE)>= 0 THEN '60만원대'
                        WHEN (800000 - PROD_PRICE)>= 0 THEN '70만원대'
                        WHEN (900000 - PROD_PRICE)>= 0 THEN '80만원대'
                        WHEN (1000000 - PROD_PRICE)>= 0 THEN '90만원대'
                        ELSE '100만원 이상'
                        END "가격대"
FROM PROD;                            
                    
--회원정보테이블의 주민등록 뒷자리(7자리 중 첫째자리)에서 성별구분을 검색하시오
--(CASE 구문 사용, ALIAS는 회원명, 주민등록번호(주민1-주민2), 성별

SELECT  MEM_NAME 회원명
      ,    MEM_REGNO1
      ||   MEM_REGNO2 주민등록번호
      ,   CASE WHEN substr(MEM_REGNO2,1,1)  IN(' 1' , '3') THEN '남자'
                         WHEN substr(MEM_REGNO2,1,1)  IN(' 2' , '4') THEN '여자'
                        ELSE '기타'  END "성별"
   FROM MEMBER;
                     
SELECT  MEM_NAME 회원명
      ,    MEM_REGNO1
      ||   MEM_REGNO2 주민등록번호
      CASE substr(MEM_REGNO2,1,1) WHEN '1' THEN '남자'
                                                 WHEN '2' THEN '여자'
                                                 WHEN '3' THEN '남아'
                                                 WHEN '4' THEN '여아'
                                                 ELSE '기타'                                
FROM MEMBER;
 
 --P.210
 -- 트랜잭션(Transaction)
 -- 데이터베이스를 변경하기 위해 수행되어야 할
 -- 논리적인 단위. 여러개의 SQL로 구성되어 있음.
 -- 원자성 : All or Nothing. 전체 실행 또는 전체 실행 안됨.
 -- 일관성 : 데이터베이스에 실행전에 문제가 없다면 실행후에도 문제가 없다.
 -- 고립성 : 실행 중 타 트랜잭션에 영향으로 결과에 문제가 발생해서는 안 됨
 -- 지속성 : 성공하면 결과는 지속됨
CREATE TABLE TEST1(
        DEPTNO  NUMBER ,
        DNAME   VARCHAR2(30),
        LOC        VARCHAR2(30),
CONSTRAINT PK_TEST1 PRIMARY KEY(DEPTNO )
);
 
INSERT INTO TEST1(DEPTNO, DNAME, LOC) VALUES(10,'ACCOUNTING','NEW YORK');
INSERT INTO TEST1(DEPTNO, DNAME, LOC) VALUES(20,'RESEARCH','DALLAS');
INSERT INTO TEST1(DEPTNO, DNAME, LOC) VALUES(30,'SALES','CHICAGO');
INSERT INTO TEST1(DEPTNO, DNAME, LOC) VALUES(40,'OPERATIONS','BOSTON');
COMMIT;
 
 SELECT *
 FROM TEST1;
 
 UPDATE * USER_COMSTRAINTS
 WHERE CONSTRAINT_NAME = 'PK_TEST1';

 UPDATE TEST1 
 SET DEPTNO = 20;
 
 UPDATE TEST1
 SET LOC = 'SEOUL'
 WHERE DNAME = 'SALES';
 
 DELETE FROM TEST1
 WHERE DNAME = 'OPERATIONS';
 
 
 SELECT * FROM TEST1;
 
 ROLLBACK;
 
 -- P.215
 UPDATE TEST1 
 SET DEPTNO = 20; 
 
 COMMIT;
 
 UPDATE TEST1
 SET LOC = 'SEOUL'
 WHERE DNAME = 'SALES';
 
 DELETE FROM TEST1
 WHERE DNAME = 'OPERATIONS';
 
  ROLLBACK;
-- 마지막 COMMIT / ROLLBACK 시점으로 돌아감 
-- DDL을 수행하면 자동  COMMIT이 됨 

CREATE TABLE TEST2
AS 
SELECT * FROM TEST11;
ROLLBACK;

--LPROD 테이블 복제 -> LPROD2 테이블 생성
--1) 스키만    :   컬럼, 자료형, 크기, N.N제약사항
--2) 데이터
--단, P.K, FK는 복제가 안됨
 CREATE TABLE LPROD2
 AS 
 SELECT * FROM LPROD;
 
  SELECT * FROM LPROD2;
 --1)
 UPDATE LPROD2
 SET        LPROD_ID = 7;
 COMMIT;
 --2)
 UPDATE     LPROD2
 SET        LPROD_NM = '미샤'
 WHERE  LPROD_GU = 'P302';
 --3)
 DELETE FROM LPROD2
 WHERE LPROD_GU = 'P403';
--오류가 생기면 최종적으로 COMMIT이 됨
CREATE TABLE LPROD3
AS
SELECT * FROM LPROC;

 SELECT * FROM LPROD2;
 
 ROLLBACK;

--P.218
--SAVEPOINT : 트랜잭션 중간저장
--COMMIT : 변경사항을 데이터베이스에 반영
--트랜잭션이 종료됨과 동시에
--새로운 트랜잭션이 시작됨
INSERT INTO TEST1(DEPTNO, DNAME, LOC) VALUES(10,'ACCOUNTING','NEW YORK');
INSERT INTO TEST1(DEPTNO, DNAME, LOC) VALUES(20,'RESEARCH','DALLAS');
INSERT INTO TEST1(DEPTNO, DNAME, LOC) VALUES(30,'SALES','CHICAGO');
INSERT INTO TEST1(DEPTNO, DNAME, LOC) VALUES(40,'OPERATIONS','BOSTON');
COMMIT;


UPDATE TEST1
SET     DEPTNO = 20;
SAVEPOINT A1;

UPDATE TEST1
 SET LOC = 'SEOUL'
 WHERE DNAME = 'SALES';
 SAVEPOINT A2;
 
 DELETE FROM TEST1
 WHERE DNAME = 'OPERATIONS';
 SAVEPOINT A3;

SELECT * FROM TEST1;

ROLLBACK TO A2;     --(O)
ROLLBACK TO A3;     --(X)
ROLLBACK TO A1;     --(O)
ROLLBACK;               --(O)


--P.222
-- 메타데이터? 데이터(눈에 보이는 데이터)를 위한 데이터(컬럼, 자료형, 크기, 제약사항)
-- 데이터사전? 메타데이터 정보를 관리

--Dictionary 뷰(가상의 테이블, 논리적)에서 'ALL_'로 시작하는 모든 테이블 조회
SELECT TABLE_NAME
          ,   COMMENTS
FROM    DICTIONARY
WHERE   TABLE_NAME LIKE 'ALL_%';

SELECT * FROM ALL_CONSTRAINTS;
SELECT * FROM ALL_USERS;
 
 --현재 로그인한 사용자(계정)가 만든 모든 객체 정보를 출력
 SELECT object_NAME
  ,          OBJECT_TYPE
  ,       CREATED
FROM ALL_OBJECTS
WHERE OWNER = 'PC12'
ORDER BY OBJECT_TYPE ASC;
 
 --각 테이블 전체 레코드 개수를 출력. (테이블명, 레코드 수)
 SELECT TABLE_NAME 테이블명
      ,       NUM_ROWS "레코드 수"
FROM USER_TABLES;        
 

 --USER_CONSTRAINTS,
 --USER_CONS_COLUMNS의 컬럼 상세를 확인하고
 --상품 테이블의 제약조건을 출력하시오?
 --(컬럼명, 제약명, 타입, 제약내용)
 SELECT B.CONSTRAINT_NAME 컬럼명
      ,   A.CONSTRAINT_NAME  제약명
      ,   A.CONSTRAINT_TYPE 타입
      ,   A.SEARCH_CONDITION 제약내용
FROM    USER_CONSTRAINTS A, USER_CONS_COLUMNS B
WHERE   A.TABLE_NAME = B.TABLE_NAME
AND     A.TABLE_NAME = 'BUYER';

--테이블목록 쿼리
SELECT S1.TABLE_NAME AS 물리테이블명,
         COMMENTS AS 논리테이블명,
         TABLESPACE_NAME AS 테이블스페이스명,
         NUM_ROWS AS ROW수,     --- analize 를 해야 정확한 Row수를 얻는다.
         LAST_ANALYZED AS  최종분석일자,
         PARTITIONED AS 파티션여부
FROM USER_TABLES S1,
        USER_TAB_COMMENTS S2
WHERE S1.TABLE_NAME = S2.TABLE_NAME       
  AND S2.TABLE_TYPE  = 'TABLE'    -- VIEW (뷰, 테이블 따로 SELECT 
  AND TABLESPACE_NAME IS NOT NULL --PLAN TABLE 등을 빼기 위해
ORDER BY  S1.TABLE_NAME;

--테이블, 컬럼 목록 추출
SELECT A.TABLE_NAME AS TABLE_NAME,
   A.TAB_CMT AS 테이블설명,
         A.COLUMN_NAME AS 컬럼명,
         B.POS AS PK,
         A.COL_CMT AS 컬럼설명,
         A.DATA_TYPE AS 데이터유형,
         A.데이터길이,
         A.NULLABLE AS NULL여부,
         A.COLUMN_ID AS 컬럼순서,
         A.DATA_DEFAULT AS 기본값
FROM
(SELECT S1.TABLE_NAME,
   S3.COMMENTS AS TAB_CMT,
         S1.COLUMN_NAME,
         S2.COMMENTS AS COL_CMT,
         S1.DATA_TYPE,
         CASE WHEN S1.DATA_PRECISION IS NOT NULL THEN DATA_PRECISION||','||DATA_SCALE
         ELSE TO_CHAR(S1.DATA_LENGTH)
         END  AS 데이터길이,
         NULLABLE,
         COLUMN_ID,
         DATA_DEFAULT
FROM  USER_TAB_COLUMNS S1,
         USER_COL_COMMENTS S2,
         USER_TAB_COMMENTS S3
WHERE S1.TABLE_NAME = S2.TABLE_NAME
   AND S1.COLUMN_NAME = S2.COLUMN_NAME
   AND S2.TABLE_NAME = S3.TABLE_NAME ) A,        
(SELECT T1.TABLE_NAME, T2.COLUMN_NAME, 'PK'||POSITION AS POS
   FROM (SELECT TABLE_NAME, CONSTRAINT_NAME  
              FROM USER_CONSTRAINTS
                  WHERE  CONSTRAINT_TYPE = 'P' )T1,
                  (SELECT TABLE_NAME, CONSTRAINT_NAME,  COLUMN_NAME, POSITION
                 FROM USER_CONS_COLUMNS ) T2
          WHERE T1.TABLE_NAME = T2.TABLE_NAME
             AND T1.CONSTRAINT_NAME = T2.CONSTRAINT_NAME  ) B
WHERE A.TABLE_NAME = B.TABLE_NAME(+)
   AND A.COLUMN_NAME = B.COLUMN_NAME(+)    
ORDER BY A.TABLE_NAME,  A.COLUMN_ID;
 
 --P.224
 --회원 아이디가 조건절에 자주 사용되어 INDEX를 사용
 --ROWID : 행의 고유번호
 SELECT ROWID
          ,   MEM_ID
          ,   MEM_NAME
          ,   MEM_JOB
          ,   MEM_BIR
FROM MEMBER
WHERE MEM_ID = 'a001';

--P.229 
 --회원 생일이 조건절에 자주 사용되어
 --INDEX를 생성 -> 검색속도 개선(B-TREE INDEX)
 CREATE INDEX IDX_MEMBER_BIR
 ON MEMBER(MEM_BIR);
 
 SELECT ROWID
      ,  MEM_ID
      ,   MEM_NAME
      ,   MEM_JOB
      ,   MEM_BIR
 FROM MEMBER
 WHERE MEM_BIR LIKE '75%';
 
--회원생일에서 년도만 분리하여
--인덱스를 생성(Function-based Index)

CREATE INDEX IDX_MEMBER_BIR_YEAR
ON      MEMBER(TO_CHAR(MEM_BIR, 'YYYY'));

SELECT   ROWID, MEM_ID
      ,   MEM_NAME
      ,   MEM_JOB
      ,   MEM_BIR
 FROM MEMBER
 WHERE TO_CHAR(MEM_BIR, 'YYYY') = '1975';
 
  --P.230
 DROP INDEX IDX_MEMBER_BIR;
 
 --IDX_MEMBER_BIR_YEAR 인덱스는 REBUILD 하시오?
 ALTER INDEX IDX_MEMBER_BIR_YEAR REBUILD;

--INDEX KEY Column 변형을 막는 Query문 사용 권장 
SELECT BUY_DATE
      ,   BUY_PROD
      ,   BUY_QTY
FROM BUYPROD
WHERE   BUY_DATE - 10 = '2005-02-20';
--재구성
SELECT BUY_DATE
      ,   BUY_PROD
      ,   BUY_QTY
FROM BUYPROD
WHERE   BUY_DATE = TO_DATE('2005-02-20') + 10;
 
 --P. 243
 --상품테이블에서 상품코드, 상품명, 분류명을 조회
 
 --조인 기초 쿼리
 --LPROD, PROD 조인
 
-- 조인 시 단계 ★
--1) 두 테이블 사이에 P.K, F.K 관계를 찾자
--2) 관계가 있다면 FROM절에 두 테이블 명을 적음
--  자료형과 크기가 같음, 같은 데이터가 있음
--3) P.K데이터와 F.K데이터가 같은 경우에만 결과에 포함
--4) 컬럼을 구성. FROM 절의 테이블에  ALIAS 

SELECT L.LPROD_GU
      ,   L.LPROD_NM
      ,   P.PROD_LGU
      ,   P.PROD_ID
      ,   P.PROD_NAME
FROM LPROD L,PROD P 
 WHERE  L.LPROD_GU= P.PROD_LGU;     --조인 조건(3)
 -- ANSI 표준
SELECT L.LPROD_GU
      ,   L.LPROD_NM
      ,   P.PROD_LGU
      ,   P.PROD_ID
      ,   P.PROD_NAME
FROM LPROD L INNER JOIN PROD P 
ON(L.LPROD_GU= P.PROD_LGU);  

 
 SELECT L.LPROD_GU
      ,   L.LPROD_NM
      ,   B.BUYER_NAME
      ,   B.BUYER_ID
      ,   B.BUYER_LGU
 FROM LPROD L INNER JOIN BUYER B
 ON ( L.LPROD_GU = B.BUYER_LGU);  --ANSI 표준(INNER JOIN , ON)
 
 -- 조인조건이 없는 조인? 카티젼 프로덕트
 -- 조인조건이 있으면, EQUI JOIN, 동등조인, 내부조인
 SELECT M.MEM_ID
      ,   M.MEM_NAME
      ,   C.CART_NO
      ,   C.CART_PROD
      ,   C.CART_MEMBER
      ,   C.CART_QTY
 FROM MEMBER M, CART C
 WHERE M.MEM_ID = C.CART_MEMBER;
 --ANSI 표준
  SELECT M.MEM_ID
      ,   M.MEM_NAME
      ,   C.CART_NO
      ,   C.CART_PROD
      ,   C.CART_MEMBER
      ,   C.CART_QTY
 FROM MEMBER M INNER JOIN CART C
 ON( M.MEM_ID = C.CART_MEMBER);
 
 SELECT P.PROD_ID
      ,   P.PROD_NAME
      ,   B.BUY_DATE
      ,   B.BUY_PROD
      ,   B.BUY_QTY
      ,   B.BUY_COST
FROM PROD   P, BUYPROD  B
WHERE P.PROD_ID = B.BUY_PROD;
 
 SELECT P.PROD_ID
      ,   P.PROD_NAME
      ,   C.CART_NO
      ,   C.CART_PROD
      ,   C.CART_MEMBER
      ,   C.CART_QTY
 FROM PROD P, CART C
 WHERE P.PROD_ID = C.CART_PROD;
 
 
 SELECT C.CART_NO
          , C.CART_PROD
          , C.CART_QTY
          , C.CART_MEMBER
          , P.PROD_NAME
          , M.MEM_NAME
 FROM   PROD P, CART C, MEMBER M
 WHERE  P.PROD_ID = C.CART_PROD
 AND      C.CART_MEMBER = M.MEM_ID;
 --ANSI 표준
  SELECT C.CART_NO
          , C.CART_PROD
          , C.CART_QTY
          , C.CART_MEMBER
          , P.PROD_NAME
          , M.MEM_NAME
 FROM   PROD P INNER JOIN CART C ON ( P.PROD_ID = C.CART_PROD)
                          INNER JOIN MEMBER M ON (C.CART_MEMBER = M.MEM_ID);

 
 SELECT    B.BUYER_ID,   B.BUYER_NAME
          ,   L.LPROD_GU,   L.LPROD_NM
          ,   P.PROD_ID,   P.PROD_LGU ,   P.PROD_NAME
 FROM   BUYER B, PROD P , LPROD L
 WHERE  B.BUYER_ID = P.PROD_BUYER
 AND      L.LPROD_GU = P.PROD_LGU  ;
 --ANSI 표준
 SELECT    B.BUYER_ID,   B.BUYER_NAME
          ,   L.LPROD_GU,   L.LPROD_NM
          ,   P.PROD_ID,   P.PROD_LGU ,   P.PROD_NAME
 FROM   BUYER B INNER JOIN PROD P ON(B.BUYER_ID = P.PROD_BUYER)
                           INNER JOIN LPROD L ON(L.LPROD_GU = P.PROD_LGU);

 
 SELECT  C.CART_NO, C.CART_PROD, C.CART_QTY , C.CART_MEMBER
          , P.PROD_NAME
          , B.BUYER_NAME
          , L.LPROD_NM
          , M.MEM_NAME
 FROM CART C, MEMBER M, PROD P, BUYER B, LPROD L 
 WHERE  B.BUYER_ID  =  P.PROD_BUYER
 AND      L.LPROD_GU = P.PROD_LGU
 AND      P.PROD_ID = C.CART_PROD
 AND      C.CART_MEMBER = M.MEM_ID;
 --ANSI 표준
  SELECT  C.CART_NO, C.CART_PROD, C.CART_QTY, C.CART_MEMBER
          , P.PROD_NAME
          , B.BUYER_NAME
          , L.LPROD_NM
          , M.MEM_NAME
 FROM PROD P INNER JOIN BUYER B ON (B.BUYER_ID  =  P.PROD_BUYER)
                        INNER JOIN  LPROD L ON( L.LPROD_GU = P.PROD_LGU)
                        INNER JOIN  CART C ON(P.PROD_ID = C.CART_PROD)
                        INNER JOIN  MEMBER M ON (C.CART_MEMBER = M.MEM_ID) ;
    
 --P. 243
 -- 상품테이블에서 거래처가 '삼성전자' 인 자료의
 --상품코드, 상품명, 거래처명을 조회
 --EQUI JOIN
 
 SELECT P.PROD_ID 상품코드
          ,   P.PROD_NAME 상품명
          ,   B.BUYER_NAME 거래처명
 FROM BUYER B, PROD P
 WHERE B.BUYER_ID = P.PROD_BUYER
 AND    B.BUYER_NAME = '삼성전자';

 --ANSI 표준_P. 244 
 SELECT   P.PROD_ID 상품코드
          ,   P.PROD_NAME 상품명
          ,   B.BUYER_NAME 거래처명
 FROM   BUYER B INNER JOIN  PROD P ON( B.BUYER_ID = P.PROD_BUYER)
 WHERE     B.BUYER_NAME = '삼성전자';
 
 --P. 244
 -- 상품 분류가 전자제품(P.102)인 상품의 상품코드, 상품명
 --분류명, 거래처명을 조회
 --EQUI JOIN
 
 SELECT P.PROD_ID 상품코드
          ,   P.PROD_NAME 상품명
          ,   L.LPROD_NM 분류명
          ,   B.BUYER_NAME 거래처명
 FROM PROD P, BUYER B, LPROD L
 WHERE BUYER_ID = PROD_BUYER
 AND    P.PROD_LGU = L.LPROD_GU
 AND    L.LPROD_NM = '전자제품';
 
 --ANSI
  SELECT P.PROD_ID 상품코드
          ,   P.PROD_NAME 상품명
          ,   L.LPROD_NM 분류명
          ,   B.BUYER_NAME 거래처명
 FROM PROD P INNER JOIN BUYER B ON (B.BUYER_ID = P.PROD_BUYER)
                         INNER JOIN LPROD L ON( P.PROD_LGU = L.LPROD_GU)
 WHERE   L.LPROD_NM = '전자제품';
 
 
 
 --P.282
 --AVG(컬럼)
 SELECT PROD_COST
 FROM PROD
 ORDER BY 1;
 
 SELECT AVG(DISTINCT PROD_COST) 중복된값은제외
      ,   AVG(ALL PROD_COST) DEFALT모든값
      ,   AVG(PROD_COST) 매입가평균
FROM PROD;
 
 --상품테이블의 상품분류별 매입가격 평균값
 SELECT PROD_LGU
          , ROUND(AVG(NVL(PROD_COST,0)),2)
 FROM    PROD
 GROUP BY PROD_LGU;
 
 --상품테이블의 총 판매가격 평균 값을 구하시오
 --ALIAS 상품 총판매 가격 평균
 SELECT  AVG(NVL(PROD_SALE,0)) 상품총판매가평균
FROM PROD;        
 
 
 --상품테이블의 상품분류별 평균값을 구하시오
 --ALIAS는 상품분류, 상품분류별 판매가격 평균
 
 SELECT PROD_LGU 상품분류
 ,        ROUND  (AVG(NVL(PROD_SALE,0)),2) 상품분류별판매가평균
 FROM PROD
 GROUP BY PROD_LGU;
 
--P.282
--COUNT : 자료수
SELECT PROD_COST FROM PROD
ORDER BY PROD_COST ASC;

SELECT COUNT(DISTINCT PROD_COST)
      ,   COUNT(ALL PROD_COST)
      ,   COUNT(PROD_COST)
      ,   COUNT(*)
FROM    PROD;        
 
 --거래처테이블의 담당자(BUYER_CHARGER)를 컬럼으로 하여 COUNT하시오
 --ALIAS는 자료수(DISTINCT), 자료수, 자료수(*)
 SELECT COUNT(DISTINCT BUYER_CHARGER)  "자료수(DISTINCT)"
      ,   COUNT(ALL BUYER_CHARGER)  자료수
      ,   COUNT(*)  "자료수(*)"
FROM    BUYER;    

 --회원테이블의 취미종류수를 COUNT 집계하시오
 --ALIAS 취미종류수
 SELECT COUNT(DISTINCT MEM_LIKE) 취미종류수
FROM MEMBER;  
 
 --회원테이블의 취미별 COUNT집계하시오
 --ALIAS는 취미 자료수 자료수*
 SELECT MEM_LIKE  취미
      ,   COUNT(MEM_ID) 자료수
      ,   COUNT(*)  "자료수(*)"
 FROM MEMBER
 GROUP BY MEM_LIKE;
 
 --회원테이블의 직업종류수를 COUNT집계하시오
 --ALIAS는 직업종류수
 SELECT COUNT(DISTINCT MEM_JOB)직업종류수
 FROM MEMBER;
 
 
 --회원테이블(MEMBER)의 직업별(MEM_JOB)
 --COUNT집계하시오
  --ALIAS는 직업 자료수 자료수*
 SELECT    MEM_JOB 직업
     ,   COUNT(MEM_ID) 인원수
     ,    COUNT(*)  "자료수(*)"
 FROM MEMBER
 GROUP BY MEM_JOB;
 
 
 --장바구니테이블의 회원(CART_MEMBER)별 COUNT집계하시오
  --ALIAS는 회원ID, 구매수(DISTINCT), 구매수, 구매수(*)
SELECT CART_MEMBER  회원ID
      ,  COUNT(DISTINCT CART_PROD) 구매회수
      ,  COUNT(CART_PROD) 구매회수
      , COUNT(*)
FROM CART 
GROUP BY CART_MEMBER;
 
 --P.283
 --상품중 최고판매가격과 최저판매가격
 
 SELECT MAX(PROD_SALE) 최고판매가
  ,       MIN( PROD_SALE) 최저판매가
FROM PROD;    
 
 --상품 중 거래처별 최고매입가격과 최저매입가격
 -- SELECT 절에서 집계함수 이외의 컬럼들은
 --GROUP BY 절에 기술한다.
 SELECT PROD_BUYER   거래처
      ,   MAX(PROD_COST)   최고매입가
      ,   MIN(PROD_COST)    최저매입가
FROM PROD
GROUP BY PROD_BUYER
ORDER BY PROD_BUYER;

--R테이블 S테이블을 통해 OUTER JOIN 연습
--1. S테이블 생성 후 기본키는 C
--      컬렴 : C, D, E
CREATE TABLE S(
    C VARCHAR2(10),
    D VARCHAR2(10),
    E VARCHAR2(10),
    CONSTRAINT PK_S PRIMARY KEY(C)
    );
    
-- 2. R테이블 생성 후 기본키는 A,
--컬럼 : A, B, C
CREATE TABLE R(
    A VARCHAR2(10),
    B VARCHAR2(10),
    C VARCHAR2(10),
    CONSTRAINT PK_R PRIMARY KEY(A)
    );

-- 3. R테이블에 a1, b1, c1과 a2, b2, c2 데이터 입력
INSERT INTO R(A, B, C) VALUES('a1', 'b1', 'c1');
INSERT INTO R(A, B, C) VALUES('a2', 'b2', 'c2');
--EQUI JOIN = SIMPLE JOIN, 등가조인, 동등조인
select *
from r, s
where S.C = R.C; 

--ANSI  표준 (INNER JOIN)

SELECT *
FROM R INNER JOIN S ON ( S.C = R.C);

-- LEFT OUTER JOIN 
SELECT R.A, R.b, R.C
      ,   S.C, S.D, S.E
FROM R, S
WHERE  R.C= S.C(+); 

--ANSI  표준 (LEFT OUTER JOIN)

SELECT R.A, R.b, R.C
      ,   S.C, S.D, S.E
FROM R LEFT OUTER JOIN S ON ( S.C = R.C);

-- RIGHT OUTER JOIN 
SELECT R.A, R.b, R.C
      ,   S.C, S.D, S.E
FROM R, S
WHERE R.C(+) = S.C ; 
--ANSI  표준 ( RIGHT OUTER JOIN)
SELECT R.A, R.b, R.C
      ,   S.C, S.D, S.E
FROM R  RIGHT OUTER JOIN S ON ( S.C = R.C);

--FULL OUTER JOIN
SELECT R.A, R.b, R.C
      ,   S.C, S.D, S.E
FROM R, S
WHERE R.C(+) = S.C 
UNION
SELECT R.A, R.b, R.C
      ,   S.C, S.D, S.E
FROM R, S
WHERE  R.C= S.C(+); 
--ANSI  표준 (FULL OUTER JOIN)
SELECT R.A, R.B, R.C
      ,   S.C, S.D, S.E
from R FULL OUTER JOIN S ON(R.C= S.C);


--P.246
--상품의 2005년 1월 입고수량을 검색 조회
--ALIAS는 상품코드, 상품명, 입고수량
--EQUI JOIN
SELECT  P.PROD_NAME 상품명
      ,   B.BUY_PROD 상품코드
      ,   SUM(B.BUY_QTY)입고수량
FROM PROD P, BUYPROD  B
WHERE PROD_ID= BUY_PROD(+)
AND B.BUY_DATE(+) LIKE '05/01%'
GROUP BY B.BUY_PROD, P.PROD_NAME;
SELECT PROD_ID, PROD_NAME FROM PROD;
--ANSI 표준(LEFT OUTER JOIN)
SELECT  P.PROD_NAME 상품명
      ,   B.BUY_PROD 상품코드
      ,   SUM(B.BUY_QTY)입고수량
FROM PROD P LEFT OUTER JOIN BUYPROD  B
ON (PROD_ID= BUY_PROD AND B.BUY_DATE(+) LIKE '05/01%')
GROUP BY B.BUY_PROD, P.PROD_NAME;

--P.
--HAVING : 
--집계가 끝나고 난 뒤 결과 집계함수에 조건걸 때
--GROUP BY 절 뒤에 씀
--SELECT절에 쓰인 구문이라면 HAVING절에 조건으로 사용 가능!

-- 2005년도 월별 매입 현황을 검색하시오 ?
--(Alias는 매입월, 매입수량, 매입금액(매입수량*매입테이블의 매입가))
--단, 매입금액이 20000000 이상인 데이터만 출력해보자

SELECT EXTRACT( MONTH FROM BUY_DATE) 매입월
      ,  SUM( BUY_QTY) 매입수량
      ,  SUM( BUY_COST * BUY_QTY) 매입금액
FROM BUYPROD
WHERE EXTRACT (YEAR FROM BUY_DATE) = 2005
GROUP BY EXTRACT( MONTH FROM BUY_DATE)
HAVING    SUM( BUY_COST * BUY_QTY) >= 20000000;


-- 회원ID(CART_MEMBER), 회원명
--주문번호(CART_NO)
--, 상품코드(CART_PROD), 수량(CART_QTY)
--단, 서브쿼리 이용
--SCALAR 서브쿼리
SELECT  CART_MEMBER 회원ID
      ,   (SELECT MEM_NAME FROM MEMBER WHERE MEM_ID = CART_MEMBER) 회원명
      ,   CART_NO 주문번호
      ,   CART_PROD 상품코드
      ,   CART_QTY 수량
FROM    CART;

--NESTED 서브쿼리1
--NESTED 서브쿼리 : WHERE절에 사용된 서브쿼리
-- 상품분류가 컴퓨터제품인 상품의 리스트를 출력하기
-- ALIAS : 상품코드, 상품명, 상품분류코드
SELECT   PROD_ID  상품코드
      ,   PROD_NAME  상품명
      ,   PROD_LGU  상품분류코드
FROM PROD
WHERE PROD_LGU = (SELECT LPROD_GU FROM LPROD WHERE LPROD_NM = '컴퓨터제품');

--P.256
-- 모든 거래처의 2005년도 거래처별 매입금액(매입가 X 수량) 합계
-- Alias :  거래처코드, 거래처명, 매입금액합계
SELECT   B.BUYER_ID 거래처코드
      ,   B.BUYER_NAME  거래처명
      ,   SUM(BP.BUY_COST * BP.BUY_QTY)  매입금액합계
FROM    BUYER B, PROD P, BUYPROD BP
WHERE  B.BUYER_ID = P.PROD_BUYER(+) -- LEFT OUTER JOIN
AND     P.PROD_ID = BP.BUY_PROD (+) 
AND     EXTRACT(YEAR FROM BP.BUY_DATE(+)) = 2005
GROUP BY  B.BUYER_ID, B.BUYER_NAME;
--ANSI 표준
SELECT   B.BUYER_ID 거래처코드
      ,   B.BUYER_NAME  거래처명
      ,   SUM(BP.BUY_COST * BP.BUY_QTY)  매입금액합계
FROM    BUYER B LEFT OUTER JOIN PROD P ON(B.BUYER_ID = P.PROD_BUYER)
LEFT OUTER JOIN BUYPROD BP ON(P.PROD_ID = BP.BUY_PROD AND EXTRACT(YEAR FROM BP.BUY_DATE)=2005)
GROUP BY  B.BUYER_ID, B.BUYER_NAME;
--INLINEVIEW
SELECT  T.BUYER_ID , T.BUYER_NAME
  ,   NVL(U.SUM_QTY, 0)
FROM 
(    SELECT  BUYER_ID 
          ,   BUYER_NAME FROM BUYER
) T,
(SELECT   B.BUYER_ID 
      ,   B.BUYER_NAME
      ,   SUM(BP.BUY_COST * BP.BUY_QTY)   SUM_QTY
FROM    BUYER B, PROD P, BUYPROD BP
WHERE  B.BUYER_ID = P.PROD_BUYER
AND     P.PROD_ID = BP.BUY_PROD 
AND     EXTRACT(YEAR FROM BP.BUY_DATE) = 2005
GROUP BY  B.BUYER_ID, B.BUYER_NAME
) U
WHERE T.BUYER_ID = U.BUYER_ID(+);
--ANSI 표준
SELECT T.BUYER_ID , T.BUYER_NAME
  ,   NVL(U.SUM_QTY, 0)
FROM 
(    SELECT  BUYER_ID 
          ,   BUYER_NAME FROM BUYER
) T LEFT OUTER JOIN
(SELECT   B.BUYER_ID 
      ,   B.BUYER_NAME
      ,   SUM(BP.BUY_COST * BP.BUY_QTY)   SUM_QTY
FROM    BUYER B, PROD P, BUYPROD BP
WHERE  B.BUYER_ID = P.PROD_BUYER
AND     P.PROD_ID = BP.BUY_PROD 
AND     EXTRACT(YEAR FROM BP.BUY_DATE) = 2005
GROUP BY  B.BUYER_ID, B.BUYER_NAME
) U
ON( T.BUYER_ID = U.BUYER_ID(+));

--P.256
--(모든) 거래처의 2005년도 거래처별 매출금액(PROD_SALE * CART_QTY) 합계
--Alias : 거래처코드, 거래처명, 매출금액(PROD_SALE * CART_QTY)
--INLINEVIEW
SELECT  T.BUYER_ID , T.BUYER_NAME
  ,   NVL(U.SUM_QTY, 0)
FROM 
(    SELECT  BUYER_ID 
          ,   BUYER_NAME FROM BUYER
) T,
(SELECT   B.BUYER_ID
      ,   B.BUYER_NAME
      ,   SUM( P.PROD_SALE * C.CART_QTY) SUM_QTY
FROM       BUYER B, PROD P, CART C
WHERE     B.BUYER_ID = P.PROD_BUYER
AND         P.PROD_ID = C.CART_PROD    
AND         SUBSTR(CART_NO, 1 ,4) LIKE '2005%'
GROUP BY B.BUYER_ID, B.BUYER_NAME
) U
WHERE T.BUYER_ID = U.BUYER_ID(+)
ORDER BY T.BUYER_ID;


SELECT  T.BUYER_ID , T.BUYER_NAME
  ,  U.IN_QTY,   V.OUT_QTY
FROM 
(    SELECT  BUYER_ID 
          ,   BUYER_NAME FROM BUYER
) T,
(SELECT   B.BUYER_ID 
      ,   B.BUYER_NAME
      ,   SUM(BP.BUY_COST * BP.BUY_QTY)   IN_QTY
FROM    BUYER B, PROD P, BUYPROD BP
WHERE  B.BUYER_ID = P.PROD_BUYER
AND     P.PROD_ID = BP.BUY_PROD 
AND     EXTRACT(YEAR FROM BP.BUY_DATE) = 2005
GROUP BY  B.BUYER_ID, B.BUYER_NAME) U,
(SELECT   B.BUYER_ID
      ,   B.BUYER_NAME
      ,   SUM( P.PROD_SALE * C.CART_QTY) OUT_QTY
FROM       BUYER B, PROD P, CART C
WHERE     B.BUYER_ID = P.PROD_BUYER
AND         P.PROD_ID = C.CART_PROD    
AND         SUBSTR(CART_NO, 1 ,4) LIKE '2005%'
GROUP BY B.BUYER_ID, B.BUYER_NAME
) V
WHERE T.BUYER_ID = U.BUYER_ID(+)
AND     T.BUYER_ID = V.BUYER_ID(+);

--장바구니 TABLE에서 회원별 최고의 구매수량을 가진 자료의 회원,
--주문번호, 상품, 수량에 대해 모두 검색하시오
--Alias는 회원, 주문번호, 상품, 수량
--상관관계 서브쿼리(CORRELATED SUBQUERY)    :    MAIN의 특정 컬럼이
-- SUB의 조건으로 사용되고, SUB의 결과가 다시 MAIN의 조건으로 사용됨
SELECT  A.CART_MEMBER 회원
      ,   A.CART_NO  주문번호
      ,   A.CART_PROD 상품
      ,   A.CART_QTY  수량
FROM    CART A
WHERE   A.CART_QTY = (
            SELECT MAX(B.CART_QTY)
            FROM CART B
            WHERE B.CART_MEMBER = A.CART_MEMBER  --★★★★★★
    );        


--입고테이블(BUYPROD)에서 "상품별"
--최고 매입수량을 가진 자료의
-- 입고일자, 상품코드, 매입수량, 매입단가를 검색하시오
SELECT A.BUY_DATE 입고일자
      ,   A.BUY_PROD  상품코드
      ,   A.BUY_QTY  매입수량
      ,   A.BUY_COST  매입단가
FROM    BUYPROD A
WHERE  A.BUY_QTY = (
        SELECT MAX(B.BUY_PROD )
        FROM   BUYPROD B
        WHERE B.BUY_PROD =  A.BUY_PROD;        --★★★★★★

--상관관계서브쿼리 예제3)
-- 장바구니Table에서 일자별 최고의 구매수량을 가진 자료의 회원, 
--주문번호, 상품, 수량에 대해 모두 검색하시오 ?
--(Alias는 회원, 일자, 상품, 수량)
SELECT A.CART_MEMBER  회원
      ,  SUBSTR(A.CART_NO, 1, 8)  일자
      ,   A.CART_PROD  상품
      ,   A.CART_QTY  수량
FROM CART A
WHERE A.CART_QTY = (
            SELECT MAX(B.CART_QTY)
            FROM CART B
            WHERE SUBSTR(B.CART_NO, 1, 8) = SUBSTR(A.CART_NO, 1, 8)
);

--P.260
-- 단일행 서브쿼리, 단일컬럼 서브쿼리에 사용가능
-- =, !=, <>, <, >, <=,>= 연산자 사용
SELECT LPROD_NM
FROM LPROD
WHERE LPROD_GU = 'P101';

-- 다중행 서브쿼리에 사용가능
--IN, ANY, ALL, EXISTS 연산자 사용
SELECT LPROD_NM
FROM LPROD
WHERE LPROD_GU LIKE 'P1%';

--다중컬럼 서브쿼리에 사용가능 
SELECT LPROD_ID, LPROD_GU, LPROD_NM
FROM LPROD
WHERE LPROD_GU = 'P101';

--P.230
-- 직업이 '공무원'인 사람들의 마일리지를 검색하여
--최소한 그들 중 어느 한사람보다는 마일리지가 큰 사람들을 출력하시오
-- 단, 직업이 '공무원'인 사람은 제외하고 검색하시오
--ALIAS는 회원명, 직업, 마일리지
-- 직업이 '공무원'인 사람들의 마일리지?
--ANY : OR(또는)
SELECT A.MEM_NAME, A.MEM_JOB, A.MEM_MILEAGE
FROM MEMBER A
WHERE   A.MEM_MILEAGE > ANY(
SELECT B.MEM_MILEAGE
FROM MEMBER B
WHERE B.MEM_JOB= '공무원'
);
--ALL   :   AND 
SELECT A.MEM_NAME, A.MEM_JOB, A.MEM_MILEAGE
FROM MEMBER A
WHERE   A.MEM_MILEAGE > ALL(
SELECT B.MEM_MILEAGE
FROM MEMBER B
WHERE B.MEM_JOB= '공무원'
);

--문제
--a001 회원의 구입수량을 검색하여
--최소한 a001 회원 보다는 구입수량이(AND의 개념)
--큰 주문내역을 출력하시오.
--단, a001 회원은 제외하고 검색하시오.
--(ALIAS는 주문번호, 상품코드, 회원명!!!, 구입수량)

SELECT A.CART_NO 주문번호
   , A.CART_PROD 상품코드
   , (SELECT C.MEM_NAME FROM MEMBER C WHERE C.MEM_ID = A.CART_MEMBER) 회원명
   , M.MEM_NAME 회원명2
   , A.CART_QTY 구입수량
FROM   CART A, MEMBER M
WHERE  A.CART_MEMBER = M.MEM_ID
AND    A.CART_MEMBER <> 'a001'
AND    A.CART_QTY > ALL(
        SELECT DISTINCT B.CART_QTY FROM CART B WHERE B.CART_MEMBER = 'a001'
    );


--P.261
-- A집합
SELECT MEM_NAME
      ,   MEM_JOB
      ,   MEM_MILEAGE
FROM    MEMBER
WHERE   MEM_MILEAGE > 4000
--B집합
UNION   --UNION : 합집합, 중복 된것을 1회 출력, 자동정렬
SELECT MEM_NAME
      ,   MEM_JOB
      ,   MEM_MILEAGE
FROM    MEMBER
WHERE   MEM_JOB = '자영업';


SELECT MEM_NAME
      ,   MEM_JOB
      ,   MEM_MILEAGE
FROM    MEMBER
WHERE   MEM_MILEAGE > 4000
UNION ALL -- 합집합, 중복모두 출력, 자동정렬안됨
SELECT MEM_NAME
      ,   MEM_JOB
      ,   MEM_MILEAGE
FROM    MEMBER
WHERE   MEM_JOB = '자영업';

SELECT MEM_NAME
      ,   MEM_JOB
      ,   MEM_MILEAGE
FROM    MEMBER
WHERE   MEM_MILEAGE > 4000
INTERSECT -- 교집합, 자동정렬안됨
SELECT MEM_NAME
      ,   MEM_JOB
      ,   MEM_MILEAGE
FROM    MEMBER
WHERE   MEM_JOB = '자영업';


SELECT MEM_NAME
      ,   MEM_JOB
      ,   MEM_MILEAGE
FROM    MEMBER
WHERE   MEM_MILEAGE > 4000
MINUS -- 차집합, 자동정렬안됨
SELECT MEM_NAME
      ,   MEM_JOB
      ,   MEM_MILEAGE
FROM    MEMBER
WHERE   MEM_JOB = '자영업';

--P.264
--SET(집합)을 사용할 수 있는지
--1. 컬럼의 수가 동일, 2. 대응되는 자료형이 동일
--A) 2005년도 4월에 판매된 상품
SELECT DISTINCT A.CART_PROD 판매상품
      ,   P.PROD_NAME  상품명
      ,   P.PROD_SALE
FROM    CART A, PROD P
WHERE   A.CART_PROD = P.PROD_ID
AND SUBSTR(A.CART_NO, 1,8) BETWEEN '20050401' AND '20050430'
AND EXISTS(
--INTERSECT
--B) 2005년도 6월에 판매된 상품
SELECT DISTINCT C.CART_PROD 판매상품
      ,   P.PROD_NAME  상품명
FROM    CART C, PROD P
WHERE   C.CART_PROD = P.PROD_ID
AND     C.CART_NO LIKE '200506%'
AND     C.CART_PROD = A.CART_PROD  --★★★★★연결고리 중요한 포인트
);

--EXISTS 쉬운 문제
-- A 집합
SELECT A.MEM_ID
      ,   A.MEM_NAME
      ,   A.MEM_MILEAGE
FROM    MEMBER A
WHERE   A.MEM_MILEAGE > 1000
AND     EXISTS (
-- B집합
SELECT 1
FROM    MEMBER B
WHERE   B.MEM_JOB = '학생'
AND     B.MEM_ID = A.MEM_ID --★★★★★연결고리 중요한 포인트
);

--P.265
--2005년도 구매금액 2천만 이상 우수고객으로 지정하여 
--검색하시오 ?
--(Alias는 회원ID, 회원명, '우수고객’)
--(구매금액 : SUM(CART.CART_QTY * PROD.PROD_SALE))
--A테이블

SELECT A.MEM_ID 회원ID
   , A.MEM_NAME 회원명
   , '우수고객' 우수고객
FROM   MEMBER A
WHERE EXISTS(
        --2005년도 구매금액 2천만 이상 우수고객
        SELECT  M.MEM_ID
              ,  SUM( C.CART_QTY * P.PROD_SALE)  --1이라고 써도 상관없음
        FROM   MEMBER M, CART C, PROD P
        WHERE M.MEM_ID = C.CART_MEMBER
        AND     C.CART_PROD = P.PROD_ID
        AND     C.CART_NO LIKE '2005%'
        GROUP BY  M.MEM_ID
        HAVING  SUM( C.CART_QTY * P.PROD_SALE)>=20000000
        AND M.MEM_ID = A.MEM_ID --★★★★★연결고리 중요한 포인트
    );

--EXISTS 문제2)
--2005년도 매입금액 1천만원 이상 우수거래처로 지정하여 검색하시오
--ALIAS 는 거래처코드, 거래처명, '우수거래처'
--구매금액 (SUM(BUYPROD.BUY_QTY * BUYPROD.BUY_COST)

SELECT A.BUYER_ID
      ,   A.BUYER_NAME
      ,   '우수거래처'
FROM    BUYER A 
WHERE EXISTS(

SELECT  P.PROD_BUYER 
      ,   SUM( BP.BUY_QTY * BP.BUY_COST)
FROM    PROD P,  BUYPROD BP
WHERE  P.PROD_ID = BP.BUY_PROD
AND     BP.BUY_DATE  LIKE '05%'
AND P.PROD_BUYER = A.BUYER_ID --★★★★★연결고리 중요한 포인트
GROUP BY  P.PROD_BUYER
HAVING SUM( BP.BUY_QTY * BP.BUY_COST) >= 10000000
);

 --2005년도 상품의 매입, 매출현황을 조회(UNION문 사용)
 -- 상단, 하단의 필드개수/ 이름/ 데이터 유형이 동일해야 함
 --일자 상품명 순
 
 SELECT TO_CHAR(BUY_DATE, 'YYYY/MM/DD') 일자
      ,   PROD.PROD_NAME 상품명
      ,   BUYPROD.BUY_QTY    수량
      ,   '매입'      매입
FROM BUYPROD, PROD 
WHERE BUY_PROD = PROD_ID
AND BUY_DATE BETWEEN '2005-01-01' AND '2005-12-31'
UNION
SELECT TO_CHAR(TO_DATE(SUBSTR(CART_NO,1,8),'YYYYMMDD'),'YYYY/MM/DD')   일자
      , PROD_NAME 상품명
      , CART_QTY 수량
         '매출'  구분
FROM  CART , PROD 
WHERE  CART_PROD = PROD_ID
AND CART_NO LIKE '2005%'
ORDER BY 1, 상품명;
 
-- P.267
-- 집계용 문법
-- RANK( ) : 순위 출력 함수
--DENSE_RANK( ) :  서열 출력 함수(대상과 동일값을 하나로 설정하여 순위 부여)
 -- 순위 부여
 SELECT RANK('c001')
            WITHIN GROUP(ORDER BY CART_MEMBER) RANK
      ,   DENSE_RANK('c001')
            WITHIN GROUP(ORDER BY CART_MEMBER) DENSE_RANK
 FROM CART;
 
 SELECT CART_MEMBER
 FROM CART
 ORDER BY 1;
 
 --분석용 문법
 -- 장바구니 (CART) 테이블에서 회원들의 회원아이디와
 -- 구매수, 구매수 순위를 출력
  SELECT CART_QTY FROM CART ORDER BY CART_QTY DESC;
  SELECT CART_MEMBER
      ,    CART_QTY
      ,   RANK() OVER(ORDER BY CART_QTY DESC) AS RANK
      ,   DENSE_RANK() OVER(ORDER BY CART_QTY DESC) AS RANK_DENSE
FROM    CART;        
 
 --P.268
 -- ROWNUM : 오라클 내부적으로 처리하기 위한 
 --                 각 레코드에 대한 일련번호
 SELECT ROWNUM
      ,   L.LPROD_ID
      ,   L.LPROD_GU
      ,   L.LPROD_NM
FROM    LPROD L;

SELECT T.*
FROM
( -- INLINE VIEW
SELECT ROWNUM RNUM
      ,   L.LPROD_ID
      ,   L.LPROD_GU
      ,   L.LPROD_NM
FROM    LPROD L
) T 
WHERE T.RNUM BETWEEN 1 AND 5;
-- P.269
--ROWID : 테이블의 특정 레코드로 랜덤하게 접근하기 위한
--          논리적인 주소값. 데이터베이스 내에서 유일한 값(잘안씀)
SELECT LPROD_GU
      ,   LPROD_NM
      ,   ROWID
FROM    LPROD
ORDER BY 3 ASC;
 
-- P.270
-- RATIO_TO_REPORT : 전체대비 해당 ROW의 값이
--                          차지하는 비율
SELECT T1.VAL
      ,   RATIO_TO_REPORT(T1.VAL) OVER() * 100 || '%'
FROM
( 
 SELECT 10 VAL FROM DUAL
 UNION ALL
 SELECT 20 VAL FROM DUAL
 UNION ALL 
 SELECT 30 VAL FROM DUAL
 UNION ALL
 SELECT 40 VAL FROM DUAL
 ) T1;

 --a001 회원이 구입한 상품의 내역을 활용하여
 --구매개수(CART_QTY) 대비 해당 구매개수 값이
 --차지하는 비율을 구하기
 --ALIAS : 회원ID, 상품코드, 구매수, 차지비율
SELECT  CART_MEMBER 회원ID
      ,   CART_PROD 상품코드
      ,   CART_QTY 구매수
      ,   ROUND(RATIO_TO_REPORT(CART_QTY) OVER() * 100, 2 ) 차지비율
FROM CART
WHERE CART_MEMBER = 'a001';
 
 --P. 270
 --ROLLUP : 소계
 -- 상품분류별, 거래처별, 입고수와 입고가격의 합을 구해보자
 --ALIAS : PROD_LGU, PROD_BUYER, PROD_ID, IN_AMT, SUM_COST
 
 SELECT P.PROD_LGU
      ,   P.PROD_BUYER
      ,   COUNT(BP.BUY_PROD) IN_AMT
      ,  SUM(BP.BUY_COST) SUM_COST
FROM    PROD P, BUYPROD BP
WHERE   P.PROD_ID = BP.BUY_PROD
GROUP BY ROLLUP (P.PROD_LGU,  P.PROD_BUYER);

 --ROLLUP 을 UNION ALL 로 바꿔보자
SELECT P.PROD_LGU
      ,   P.PROD_BUYER
      ,   COUNT(*) IN_AMT
      ,  SUM(BP.BUY_COST) SUM_COST
FROM    PROD P, BUYPROD BP
WHERE   P.PROD_ID = BP.BUY_PROD
GROUP BY  P.PROD_LGU,  P.PROD_BUYER
 UNION ALL
 SELECT P.PROD_LGU
      ,   NULL
      ,   COUNT(*) IN_AMT
      ,  SUM(BP.BUY_COST) SUM_COST
FROM    PROD P, BUYPROD BP
WHERE   P.PROD_ID = BP.BUY_PROD
GROUP BY P.PROD_LGU
UNION ALL
SELECT   NULL
      ,   NULL
      ,   COUNT(*) IN_AMT
      ,   SUM(BP.BUY_COST) SUM_COST
FROM    PROD P, BUYPROD BP
WHERE   P.PROD_ID = BP.BUY_PROD;
 
 --CUBE : 모든 소계
SELECT P.PROD_LGU
      ,   P.PROD_BUYER
      ,   COUNT(BP.BUY_PROD) IN_AMT
      ,  SUM(BP.BUY_COST) SUM_COST
FROM    PROD P, BUYPROD BP
WHERE   P.PROD_ID = BP.BUY_PROD
GROUP BY CUBE (P.PROD_LGU,  P.PROD_BUYER);
 
 --CUBE -> UNION ALL로 바꿔보자
 SELECT P.PROD_LGU
      ,   P.PROD_BUYER
      ,   COUNT(*) IN_AMT
      ,  SUM(BP.BUY_COST) SUM_COST
FROM    PROD P, BUYPROD BP
WHERE   P.PROD_ID = BP.BUY_PROD
GROUP BY  P.PROD_LGU,  P.PROD_BUYER
 UNION ALL
 SELECT P.PROD_LGU
      ,   NULL
      ,   COUNT(*) IN_AMT
      ,  SUM(BP.BUY_COST) SUM_COST
FROM    PROD P, BUYPROD BP
WHERE   P.PROD_ID = BP.BUY_PROD
GROUP BY P.PROD_LGU
UNION ALL
 SELECT NULL
      ,   P.PROD_BUYER
      ,   COUNT(*) IN_AMT
      ,  SUM(BP.BUY_COST) SUM_COST
FROM    PROD P, BUYPROD BP
WHERE   P.PROD_ID = BP.BUY_PROD
GROUP BY   P.PROD_BUYER
UNION ALL
SELECT   NULL
      ,   NULL
      ,   COUNT(*) IN_AMT
      ,   SUM(BP.BUY_COST) SUM_COST
FROM    PROD P, BUYPROD BP
WHERE   P.PROD_ID = BP.BUY_PROD;
 
 SELECT MEM_JOB
      , NULL
      , COUNT(*)
FROM MEMBER
GROUP BY MEM_JOB
UNION 
SELECT  NULL
  ,   MEM_LIKE
  ,   COUNT(*)
FROM MEMBER
GROUP BY MEM_LIKE  ;
 -- 동일한 방법
 -- GROUPING SET

 SELECT MEM_JOB
   ,  MEM_LIKE
   ,  COUNT(*)
FROM MEMBER
GROUP BY GROUPING SETS (MEM_JOB, MEM_LIKE);
 
-- P.277
SELECT  LPROD_GU
  ,   LPROD_NM
  ,   LAG(LPROD_GU) OVER (ORDER BY LPROD_GU ASC) 이전행정보
  ,   LEAD(LPROD_GU) OVER (ORDER BY LPROD_GU ASC) 다음행정보
FROM    LPROD;        

--295
/
SET SERVEROUTPUT ON;
/
DECLARE
v_i     NUMBER(9,2) :=123456.78;
v_STR   VARCHAR2(20) := '홍길동';
c_pi    CONSTANT NUMBER(8,6) := 3.141592;
v_flag  BOOLEAN NOT NULL := TRUE;
v_date  VARCHAR2(10) := TO_CHAR(SYSDATE, 'YYYY-MM-DD');
BEGIN
DBMS_OUTPUT.PUT_LINE('v_i:'||v_i );
--SYSTEM.OUT.PRINTLN(v_i :'||v_i );
END;
/
 
DECLARE
v_i     NUMBER(9,2) := 0;
v_name  VARCHAR2(20);
c_pi    CONSTANT NUMBER(8,6)    := 3.141592;
v_flag  BOOLEAN NOT NULL        := TRUE;
v_date  VARCHAR2(10)            := TO_CHAR(SYSDATE, 'YYYY-MM-DD');
BEGIN
v_name := '홍길동';
--  DBMS_OUTPUT.ENABLE;
    DBMS_OUTPUT.PUT_LINE('v_i:' ||v_i);
    DBMS_OUTPUT.PUT_LINE('v_name:' ||v_name);
    DBMS_OUTPUT.PUT_LINE('c_pi:' ||c_pi);
    DBMS_OUTPUT.PUT_LINE('v_date:' ||v_date);
END;
/

--P.296
--조건이 TRUE이면 이하 문장을 실행하고,
--조건이 FALSE이면 관련된 문장을 통과한다.
--ELSIF절은 여러 개가 가능하나, ELSE절은 한 개만 가능하다.
 
 DECLARE
 V_NUM NUMBER := 37;
 BEGIN
 --DBMS_OUTPUT.ENABLE;
 IF MOD(V_NUM, 2) = 0 THEN
    DBMS_OUTPUT.PUT_LINE(V_NUM || '는 짝수');
 ELSE
    DBMS_OUTPUT.PUT_LINE(V_NUM || '는 홀수');
 END IF;
END;
/
 --P.253
 --조건에 따른 다중 ELSIF
DECLARE
    V_NUM NUMBER := 77;
BEGIN 
    IF V_NUM > 90 THEN
     DBMS_OUTPUT.PUT_LINE('수');
    ELSIF V_NUM > 80 THEN
     DBMS_OUTPUT.PUT_LINE('우');
    ELSIF V_NUM > 70 THEN
     DBMS_OUTPUT.PUT_LINE('미');
    ELSE
     DBMS_OUTPUT.PUT_LINE('분발합시다');
    END IF;
END;
/
 
 DECLARE
-- 변수의 종류 : SCALAR(일반), REFERENCE(참조), COMPOSITE(배열), BIND(바인드 IN/OUT)
-- 상품테이블의 판매가 컬럼의 자료형 및 크기를 참조
 V_AVG_SALE PROD.PROD_SALE%TYPE; -- NUMBER(10) -- (REFERENCES 변수)
 V_SALE NUMBER :=500000;         -- (SCLAR 변수)
 BEGIN
    --269574.32
    SELECT AVG(PROD_SALE) INTO V_AVG_SALE
    FROM    PROD;
    IF V_SALE < V_AVG_SALE THEN
        DBMS_OUTPUT.PUT_LINE('평균 단가가 500000 초과입니다.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('평균 단가가 500000 이하입니다.');
    END IF;
END;
/
--P.297
--회원테이블에서 아이디가 'e001' 인 회원의  
--마일리지가 5000을 넘으면 'VIP 회원' 
--그렇지 않다면 '일반회원'으로 
--출력하시오. (회원이름, 마일리지 포함)  
DECLARE 
--SCALAR 변수
V_MILEAGE  NUMBER;
BEGIN 
    SELECT MEM_MILEAGE INTO V_MILEAGE
    FROM MEMBER WHERE MEM_ID = 'e001';
     IF V_MILEAGE > 5000 THEN
        DBMS_OUTPUT.PUT_LINE('VIP 회원');
     ELSE
        DBMS_OUTPUT.PUT_LINE('일반회원');
     END IF;
END;
/ 

--P.297
--CASE문 : SQL에서 사용하는 CASE문과 동일함
--         차이점은 END CASE로 끝난다는 것임
DECLARE
    V_NUM NUMBER :=77;
BEGIN
    V_NUM := TRUNC(V_NUM / 10);
--SIMPLE CASE EXPRESSION    
    CASE V_NUM
        WHEN 10 THEN
            DBMS_OUTPUT.PUT_LINE('수'||'('|| V_NUM ||')');
        WHEN 9 THEN
            DBMS_OUTPUT.PUT_LINE('수'||'('|| V_NUM ||')');
        WHEN 8 THEN
            DBMS_OUTPUT.PUT_LINE('우'||'('|| V_NUM ||')');
        WHEN 7 THEN
            DBMS_OUTPUT.PUT_LINE('미'||'('|| V_NUM||')');
        ELSE
            DBMS_OUTPUT.PUT_LINE('분발합시다.');
    END CASE;
END;
/

--상품분류가 화장품인 상품의 평균판매가를
--구한 후 평균판매가가 3,000원 미만이면 
--싸다, 3,000원 이상 ~ 6,000원 미만이면 보통,
--6,000원 이상 ~ 9,000원 미만이면 비싸다,
--9,000원 이상이면 너무비싸다를 출력하기
--단, CASE 문(SEARCHED CASE EXPRESSION) 사용하여 처리하기
--출력형식 : 화장품의 평균판매가는 5000원이고 보통이다.
 
DECLARE
V_AVG_SALE NUMBER;
BEGIN
SELECT ROUND(AVG(NVL(PROD_SALE, 0)), 2) INTO V_AVG_SALE
FROM PROD 
WHERE PROD_LGU = (SELECT LPROD_GU FROM LPROD WHERE LPROD_NM = '화장품');

    CASE WHEN V_AVG_SALE < 3000 THEN 
            DBMS_OUTPUT.PUT_LINE('화장품의 평균판매가는' ||V_AVG_SALE || '이고 싸다');
         WHEN V_AVG_SALE >= 3000 AND V_AVG_SALE < 6000 THEN
            DBMS_OUTPUT.PUT_LINE('화장품의 평균판매가는' ||V_AVG_SALE || '이고 보통');
         WHEN V_AVG_SALE >= 6000 AND V_AVG_SALE < 9000 THEN
            DBMS_OUTPUT.PUT_LINE('화장품의 평균판매가는' ||V_AVG_SALE || '이고 비싸다');         
        WHEN V_AVG_SALE >= 9000 THEN
            DBMS_OUTPUT.PUT_LINE('화장품의 평균판매가는' ||V_AVG_SALE || '이고 너무 비싸다');         
        ELSE
             DBMS_OUTPUT.PUT_LINE('기타');         
   END CASE;
END;
/

--가파치 업체의 지역을 검색하여
--다음과 같이 출력하기
--대구, 부산 : 경남
--대전 : 충청
--서울, 인천 : 수도권
--기타 : 기타
--단, CASE문 사용하기
/
DECLARE
V_ADD VARCHAR2(60);
BEGIN
SELECT SUBSTR(BUYER_ADD1, 1, 2) INTO V_ADD FROM BUYER 
WHERE BUYER_NAME = '가파치';
    CASE WHEN V_ADD IN( '대구', '부산') THEN
          DBMS_OUTPUT.PUT_LINE('대구, 부산 : 경남');
        WHEN V_ADD = '대전' THEN
          DBMS_OUTPUT.PUT_LINE('대전 : 충청');
        WHEN V_ADD IN ( '서울', '인천') THEN
          DBMS_OUTPUT.PUT_LINE('서울, 인천 : 수도권');        
        ELSE
          DBMS_OUTPUT.PUT_LINE('기타');
    END CASE;     
END;
/
--CASE  문제
--장바구니 테이블에서 2005년도 'a001' 회원의 구매금액의 합을 구해서
--1000만원 미만은 '브론즈', 1000만원 이상 2000만원 미만은 '실버'
-- 2000만원 이상 3000만원 미만은 '골드', 
-- 3000만원 이상 4000만원 미만은 '플래티넘', 그 이상은 다이아로 
-- 출력해보자
/
DECLARE
V_MEM   VARCHAR2(30);
V_SUM   NUMBER;
BEGIN
SELECT C.CART_MEMBER, SUM(C.CART_QTY * P.PROD_SALE)  INTO V_MEM, V_SUM
FROM CART C, PROD P
WHERE P.PROD_ID = C.CART_PROD
AND C.CART_MEMBER = 'a001'
GROUP BY C.CART_MEMBER;
    CASE WHEN V_SUM > 10000000 THEN
           DBMS_OUTPUT.PUT_LINE('브론즈');
         WHEN V_SUM <= 10000000 AND V_SUM > 20000000 THEN
           DBMS_OUTPUT.PUT_LINE('실버');
         WHEN V_SUM <= 20000000 AND V_SUM > 30000000 THEN
           DBMS_OUTPUT.PUT_LINE('골드');
         WHEN V_SUM <= 30000000 AND V_SUM > 40000000 THEN
           DBMS_OUTPUT.PUT_LINE('플래티넘');
         ELSE
           DBMS_OUTPUT.PUT_LINE('다이아');
    END CASE ;

END;
/

-- case 문제
-- 회원테이블에서 지역이 대전인 회원을 검색하여
--회원수가 3명 미만이면 '소모임'
--3명 이상 6명 미만이면 '써클'
--6명 이상 9명 미만이면 '동아리'
-- 그 이상이면 '집회'로 결과를 출력하자
/
SET SERVEROUTPUT ON;
/
DECLARE
V_ADD NUMBER;

BEGIN
SELECT COUNT(MEM_NAME)  INTO V_ADD
FROM MEMBER WHERE SUBSTR(MEM_ADD1, 1, 2) = '대전';
    CASE WHEN V_ADD < 3 THEN
           DBMS_OUTPUT.PUT_LINE('소모임');    
         WHEN V_ADD >=3 AND V_ADD < 6 THEN
           DBMS_OUTPUT.PUT_LINE('써클');    
         WHEN V_ADD >= 6 AND V_ADD < 9 THEN
           DBMS_OUTPUT.PUT_LINE('동아리');    
         ELSE
           DBMS_OUTPUT.PUT_LINE('집회');
    END CASE;           
END
;
/

--P.298
-- WHILE :  반복될 때마다 조건을 확인.
-- 조건이 TRUE이어야 LOOP실행
-- 1부터 10가지 더하기
/
DECLARE
V_SUM NUMBER := 0;
V_VAR NUMBER := 1;
BEGIN 
WHILE V_VAR <= 10 LOOP
V_SUM := V_SUM + V_VAR;
V_VAR := V_VAR + 1;
END LOOP;
DBMS_OUTPUT.PUT_LINE('1부터 10까지의 합 = ' || V_SUM);
END;
/

--P.298
--다중 WHILE문을 사용하여 구구단 만들기
/
DECLARE
DAN NUMBER := 2;
NUM NUMBER := 1;
BEGIN
    WHILE DAN <=9 LOOP
    DBMS_OUTPUT.PUT_LINE(DAN || '단' );

    WHILE NUM <=9 LOOP
    DBMS_OUTPUT.PUT_LINE(DAN || 'X' || NUM || '=' || (DAN * NUM));
    NUM := NUM+1;
    END LOOP;
    NUM := 1;
    DAN := DAN+1;
    END LOOP;
END;
/


--p.299
--LOOP문
--조건이 없는 단순한 무한 루프(무한 반복)
--EXIT 문을 사용하여 반복문을 빠져나감
/
SET SERVEROUTPUT ON;
/
DECLARE
    V_VAR NUMBER :=1; 
    -- 누적변수
    V_SUM NUMBER := 0;
BEGIN
    LOOP
        --V_VAR :  숫자형 변수
        DBMS_OUTPUT.PUT_LINE(V_VAR);
        --누적 := 누적 + 누적대상
        V_SUM := V_SUM +V_VAR;
        V_VAR := V_VAR +1;
        --언제 나가?
        IF V_VAR > 10 THEN
            EXIT;
        END IF;
    END LOOP;
     DBMS_OUTPUT.PUT_LINE('1부터 10까지의 합 = ' || V_SUM);
END;
/

--P.300
--GOTO
-- I GO TO SCHOOL BY BUS.
/
DECLARE
    V_VAR NUMBER := 1;
    --누적변수
    V_SUM NUMBER := 0;
BEGIN
    <<SCHOOL>>
    DBMS_OUTPUT.PUT_LINE(V_VAR);
    V_SUM := V_SUM + V_VAR;
    V_VAR := V_VAR + 1;
    IF V_VAR <= 10 THEN
        GOTO SCHOOL;
    END IF;
    DBMS_OUTPUT.PUT_LINE(V_SUM);
END;
/
--LOOP 및 EXIT WHEN 구문을 사용하여
-- 구구단을 출력하기
-- 2단부터 9단까지 출력
/
ACCEPT DAN PROMPT '단을 입력하세요 : ' 
DECLARE
    V_DAN NUMBER := 2;
    V_NUM NUMBER := 1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(V_DAN || '단');
        LOOP
            DBMS_OUTPUT.PUT_LINE(V_DAN || 'X' || V_NUM || '=' || V_DAN * V_NUM);        
            V_NUM := V_NUM + 1;
            EXIT WHEN V_NUM > 9;
        END LOOP;
        V_NUM := 1;        
        V_DAN := V_DAN + 1;
        --V_DAN이 10이되면 빠져나오자
        EXIT WHEN V_DAN > 9;
    END LOOP;

END;
/

--P.300
--F0R문
--
DECLARE 
    -- I NUMBER;: 자동으로 선언이 되니까 생략가능
BEGIN
    -- I : 자동선언 정수형 변수.
    -- 변수를 DECLARE에서 선언하지 않더라도 
    -- 내부적으로 자동으로 선언되는 변수
    -- 기본 1씩 증가
    --1..10 => 1을 시작값, 10은 종료값
    -- 시작값 앞에 REVERSE가 있다면 1씩 감소됨
    FOR I IN REVERSE 1..10 LOOP
    DBMS_OUTPUT.PUT_LINE(I);
    END LOOP;
END;
/
DECLARE 
BEGIN
    FOR V_DAN IN 2..9 LOOP
        DBMS_OUTPUT.PUT_LINE(V_DAN || '단');
        FOR V_NUM IN 1..9 LOOP
         DBMS_OUTPUT.PUT_LINE(V_DAN || 'X' || V_NUM || '=' || (V_DAN * V_NUM));
        END LOOP;
    END LOOP;
END;
/

DECLARE
BEGIN
    -- 7행
    FOR I IN 1..7 LOOP 
        -- 1열
        FOR J IN 1..I LOOP
        DBMS_OUTPUT.PUT('*');
        END LOOP;  
        DBMS_OUTPUT.PUT_LINE('');    
    END LOOP;
END;
/

--P.301
-- 상품분류코드가 P201인 상품분류명=> 여성캐주얼
DECLARE
    V_NM VARCHAR2(60);
BEGIN
    SELECT  LPROD_NM + 0 INTO V_NM
    FROM    LPROD
    WHERE   LPROD_GU LIKE 'P2%';
    DBMS_OUTPUT.PUT_LINE('V_NM :' || V_NM);
    -- 정의된 오류 처리
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN --ORA-01403
            DBMS_OUTPUT.PUT_LINE('해당 정보가 없습니다.');
        WHEN TOO_MANY_ROWS THEN --ORA-01422
            DBMS_OUTPUT.PUT_LINE('한 개 이상의 값이 나왔습니다.');
        WHEN OTHERS THEN --ORS-01722(SQL ERROR MESSAGE)
            DBMS_OUTPUT.PUT_LINE('기타오류 : ' || SQLERRM);
END;
/

--id가 z001인 회원의 이름과 직업을 구하기
--단, 해당 정보가 없을 경우 예외처리 하시오
/
DECLARE
    V_NAME VARCHAR2(60);
    V_JOB VARCHAR2(60);
BEGIN
    SELECT MEM_NAME, MEM_JOB INTO V_NAME , V_JOB
    FROM MEMBER 
    WHERE MEM_ID = 'z001';
        DBMS_OUTPUT.PUT_LINE('이름 :' || V_NAME || '직업 : '|| V_JOB);
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('해당 정보가 없습니다.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('오류발생: ' || SQLERRM);
END;
/

--P.301
--정의되지 않은 예외인 경우
DECLARE
    --EXCEPTION형 변수 선언
    EXP_REFERENCE EXCEPTION;
    --EXCEPTION형 변수와 2232번 오류를 연결
    PRAGMA EXCEPTION_INIT(EXP_REFERENCE, -2292);
BEGIN
    -- ORA-02292(child record found)
    DELETE FROM LPROD
    WHERE LPROD_GU = 'P101'; 
    EXCEPTION
        WHEN EXP_REFERENCE THEN
            DBMS_OUTPUT.PUT_LINE('삭제 불가 : ' || SQLERRM);
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('기타 오류 : ' || SQLERRM);
END;
/

-- P.302
-- 사용자 정의 ERROR
ACCEPT P_LGU PROMPT '등록하려는 상품분류코드를 입력하세요 :'
DECLARE
    -- EXCEPTION형 변수 선언
    EXP_LPROD_GU EXCEPTION;
    --ACCEPT의 P_LGU변수의 값을 사용하려면 주소를 찾아가야 함
    V_LGU VARCHAR2(10) := '&P_LGU';
BEGIN
    IF V_LGU IN('P101','P102', 'P201', 'P202') THEN
        --발생시키다
        RAISE EXP_LPROD_GU;
    END IF;
        DBMS_OUTPUT.PUT_LINE('등록가능');
    EXCEPTION
        WHEN EXP_LPROD_GU THEN
            DBMS_OUTPUT.PUT_LINE(V_LGU ||'는 등록불가');
END;
/
SET SERVEROUTPUT
--CURSOR
-- 2005년도 상품별 입입수량의 합계
DECLARE
    V_PROD VARCHAR2(20);
    V_QTY NUMBER;
    --커서 선언
    CURSOR GAEDDONGI IS 
        SELECT BUY_PROD, SUM(BUY_QTY) FROM BUYPROD
        WHERE EXTRACT(YEAR FROM BUY_DATE) = 2005
        GROUP BY BUY_PROD ORDER BY BUY_PROD ASC;
BEGIN
    --데이터를 메모리로 BIND(올림)
    OPEN GAEDDONGI;
    --작업 수행
    --다음행을 가리킴. 페따출
    FETCH GAEDDONGI INTO V_PROD, V_QTY;
    WHILE GAEDDONGI %FOUND LOOP
        DBMS_OUTPUT.PUT_LINE(V_PROD || ',' || V_QTY);
        FETCH GAEDDONGI INTO V_PROD, V_QTY;
        END LOOP;
        
    --데이터를 메모리에서 삭제
    CLOSE GAEDDONGI;
END;
/
-- 직업을 변수로 받아 이름 회원명과 마일리지를 출력하는 커서
ACCEPT V_JOB PROMPT '직업을 입력해주세요 :'
DECLARE
 V_NAME VARCHAR2(60);
 V_MILEAGE NUMBER;
 -- SELECT 결과 집합에 CUR이라는 이름을 붇임
 CURSOR CUR IS
SELECT  MEM_NAME
 ,   MEM_MILEAGE
FROM    MEMBER    
WHERE   MEM_JOB = '&V_JOB';
BEGIN
-- 집합을 메모리로 바인딩
    OPEN CUR;
--페따출
 FETCH CUR INTO V_NAME, V_MILEAGE;
 -- 페치했더니 데이터가 있니?
 WHILE CUR%FOUND LOOP
  DBMS_OUTPUT.PUT_LINE (V_NAME || ', ' || V_MILEAGE);
 FETCH CUR INTO V_NAME, V_MILEAGE;

 END LOOP;
 --메모리 제거
CLOSE CUR;
 
end;
/
-- FOR문을 이용함
/
ACCEPT V_JOB PROMPT '직업을 입력해주세요 :'

BEGIN
    FOR R IN (SELECT  MEM_NAME
             ,  MEM_MILEAGE
        FROM    MEMBER    
        WHERE   MEM_JOB = '&V_JOB') LOOP
        DBMS_OUTPUT.PUT_LINE(R.MEM_NAME ||
        ', ' || R.MEM_MILEAGE);
    END LOOP;
END;
/

--CURSOR 문제
/*
회원별 매출금액의 합 SUM(PROD_SALE*CART_QTY)이
20000000을 초과하는 회원을 출력해보자
ALIAS : 회원ID, 회원명, 매출금액합
CURSOR를 사용해 출력
*/ 
DECLARE
V_ID VARCHAR2(60);
V_NAME VARCHAR2(60);
V_SUM NUMBER;
    CURSOR CUR IS
        SELECT  CART_MEMBER
            ,   MEM_NAME
            ,   SUM(PROD_SALE * CART_QTY) SUM_QTY
        FROM    PROD, CART, MEMBER 
        WHERE   PROD_ID = CART_PROD
        AND   MEM_ID = CART_MEMBER
        GROUP BY CART_MEMBER, MEM_NAME
        HAVING SUM(PROD_SALE * CART_QTY) > 20000000;
BEGIN
    OPEN CUR;
        FETCH CUR INTO V_ID, V_NAME, V_SUM;
        WHILE CUR%FOUND LOOP
             DBMS_OUTPUT.PUT_LINE(V_ID || ', ' ||
                    V_NAME || ', ' || V_SUM);
        FETCH CUR INTO V_ID, V_NAME, V_SUM;
    END LOOP;         
    CLOSE CUR;
END;
/
-- FOR문으로 사용
BEGIN
    FOR R IN (SELECT M.MEM_ID, M.MEM_NAME
             , SUM(P.PROD_SALE * C.CART_QTY) SUM_QTY
        FROM   PROD P, CART C, MEMBER M
        WHERE  P.PROD_ID = C.CART_PROD
        AND    C.CART_MEMBER = M.MEM_ID
        GROUP BY M.MEM_ID, M.MEM_NAME
        HAVING SUM(P.PROD_SALE * C.CART_QTY)
        > 20000000) LOOP
        DBMS_OUTPUT.PUT_LINE(R.MEM_ID || ',' || R.MEM_NAME || ',' || R.SUM_QTY);
    END LOOP;    
END;
/

--P.304
--상품코드를 매개변수(PARAMETER)로 하여 재고수량 ADD
--UPDATE 쎄대여
SELECT PROD_ID
    ,  PROD_TOTALSTOCK
FROM  PROD
WHERE PROD_ID = 'P101000001';    

--프로시저 생성
-- 컴파일 : 구문분석 + 의미분석이 처리되고, 서버의 캐시공간에 저장됨
--          오라클이 좋아하는 언어로 바꿈
-- BIND변수 : 매개변수(파라미터(인수)를 처리)

CREATE OR REPLACE PROCEDURE USP_UPDATE(
V_ID IN VARCHAR2,
V_TOTALSTOCK IN NUMBER)
IS 
BEGIN
    UPDATE  PROD
    SET     PROD_TOTALSTOCK = PROD_TOTALSTOCK + V_TOTALSTOCK
    WHERE   PROD_ID = V_ID;
    
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('오류발생 : ' || SQLERRM);
END;
/
EXEC USP_UPDATE('P101000001', 50);
/

-- 프로시저 연습문제1
CREATE TABLE PROCTEST(
    PROC_SEQ NUMBER,
    PROC_CONTENT VARCHAR2(30),
    CONSTRAINT PK_PROCTEST PRIMARY KEY(PROC_SEQ)
    );

--1-1) 프로시저 PROC_TEST1을 생성
--실행하면 PROCTEST 테이블에 
--1, '개똥이' 데이터가 추가되도록 처리
--2, '개똥이2'
--3, '개똥이3'
--...
INSERT INTO PROCTEST(PROC_SEQ, PROC_CONTENT) VALUES (1, '개똥이1');
INSERT INTO PROCTEST(PROC_SEQ, PROC_CONTENT) VALUES (2, '개똥이2');
INSERT INTO PROCTEST(PROC_SEQ, PROC_CONTENT) VALUES (3, '개똥이3');
SELECT * FROM PROCTEST;
CREATE OR REPLACE PROCEDURE PROC_TEST1(V_SEQ IN NUMBER)
IS
BEGIN
    INSERT INTO PROCTEST(PROC_SEQ, PROC_CONTENT) VALUES (V_SEQ, '개똥이'||V_SEQ);
  
END;
/
EXEC PROC_TEST1(2);
/


SELECT * FROM PROCTEST;
INSERT INTO 테이블명(컬럼목록) VALUES(값들);

UPDATE 테이블명
SET 컬럼 = 값
WHERE 조건;

DELETE FROM 테이블명
WHERE 조건;

--P.305
-- 회원아이디를 입력받아(IN바인드변수) 이름과 취미를
-- OUT 매개변수(OUT바인드변수)로 처리
CREATE OR REPLACE PROCEDURE USP_MEMBERID(V_ID IN VARCHAR2,
V_NAME OUT VARCHAR2,
V_LIKE OUT VARCHAR2
)
IS
BEGIN
SELECT  MEM_NAME, MEM_LIKE INTO V_NAME, V_LIKE
FROM    MEMBER
WHERE   MEM_ID = V_ID;
END;
/
VAR V_NAME VARCHAR2(60)
VAR V_LIKE VARCHAR2(60)
EXEC USP_MEMBERID('a001', :V_NAME, :V_LIKE)
PRINT V_NAME
PRINT V_LIKE;
/

--회원아이디(MEM_ID) 및 점수를 입력받아 마일리지 점수(MEM_MILEAGE)를 
--업데이트 하는 프로시저(USP_MEMBER_UPDATE)를 생성하기
--EXECUTE를 통해 김은대(a001)회원의 마일리지 값을 
--100씩 추가하여 5회에 걸쳐 500으로 올리기.

SELECT  MEM_ID, MEM_MILEAGE 
FROM    MEMBER
WHERE   MEM_ID = 'a001';
/
CREATE OR REPLACE PROCEDURE USP_MEMBER_UPDATE(
P_ID IN VARCHAR2, P_MILEAGE IN NUMBER
)
IS
BEGIN
UPDATE MEMBER
SET     MEM_MILEAGE = MEM_MILEAGE + P_MILEAGE
WHERE MEM_ID = P_ID;
COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('오류발생 : ' || SQLERRM);
END;
/
EXEC USP_MEMBER_UPDATE('a001', 100);
/

-- 회원 아이디를 받으면 해당 이름을 리턴하는 함수 만들기
--프로시저와 달리 함수에는 RETURN타입이 있음
CREATE OR REPLACE FUNCTION FN_GETNAME(P_ID IN VARCHAR2)
    RETURN VARCHAR2
IS
    V_NAME  VARCHAR2(60);
BEGIN
    SELECT  MEM_NAME INTO V_NAME
    FROM    MEMBER
    WHERE   MEM_ID = P_ID;
    RETURN  V_NAME;
    
    EXCEPTION   
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('오류발생 :' || SQLEERRM);
END;
/
SELECT FN_GETNAME('a001') FROM DUAL;

-- 함수 문제
-- 다음과 같이 출력하시오
-- 상품코드, 상품명, 대분류코드, 대분류명
-- 함수를 사용, 함수명은  FN_PRODNM
SELECT  PROD_ID 상품코드
    ,   PROD_NAME 상품명
    ,   PROD_LGU 대분류코드
    ,   FN_GET_LPROD_NM(PROD_LGU) 대분류명
FROM    PROD; 
/
CREATE OR REPLACE FUNCTION FN_GET_LPROD_NM(P_GU IN VARCHAR2)
    RETURN VARCHAR2
IS
    V_NM VARCHAR2(60);
BEGIN
    SELECT LPROD_NM INTO V_NM
    FROM LPROD WHERE LPROD_GU = P_GU;
    RETURN V_NM;
END;
/

--P.308~ P.309
--년도 및 상품코드를 입력 받으면 해당연도의 평균 판매 횟수를 반환

CREATE OR REPLACE FUNCTION FN_PROD_AVG_QTY
    (P_YEAR IN NUMBER DEFAULT(EXTRACT(YEAR FROM SYSDATE)),
    P_PROD_ID IN VARCHAR2)
RETURN NUMBER
IS
    R_QTY NUMBER(10);
    V_YEAR VARCHAR2(5) := TO_CHAR(P_YEAR)||'%';
BEGIN 
    SELECT NVL(AVG(CART_QTY),0) INTO R_QTY 
    FROM CART
    WHERE CART_PROD = P_PROD_ID AND CART_NO LIKE V_YEAR;
    RETURN R_QTY;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('예외발생 : ' || SQLERRM);
        RETURN 0;
END;
/
VAR QTY NUMBER
EXEC : QTY := FN_PROD_AVG_QTY(P_PROD_ID => 'P101000002');
PRINT QTY
EXEC : QTY := FN_PROD_AVG_QTY(2005, 'P101000002');
PRINT QTY
/
SELECT PROD_ID, PROD_NAME,
        FN_PROD_AVG_QTY(2004,PROD_ID),
        FN_PROD_AVG_QTY(2005, PROD_ID)
FROM PROD;        
/

---------트리거----------------
CREATE OR REPLACE TRIGGER TG_LPROD_IN
--LPROD테이블에 데이터가 INSERT된 후에 BEGIN을 처리하자
AFTER INSERT
ON LPROD
FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE('상품분류가 추가되었습니다.');
   --NEW : 방금 INSERT된 새로운 행
   INSERT INTO LPROD_BAK(LPROD_ID, LPROD_GU, LPROD_NM)
   VALUES(:NEW.LPROD_ID, :NEW.LPROD_GU, :NEW.LPROD_NM);
END;
/
--만들어진 트리거 확인
SELECT TRIGGER_NAME FROM USER_TRIGGERS;
/
SET SERVEROUTPUT ON;
/ 
--MAX(LPROD_GU) : P403
--SUBSTR(MAX(LPROD_GU), 2) : 403 +1 => 404=> P404
INSERT INTO LPROD(LPROD_ID, LPROD_GU, LPROD_NM) VALUES(
            (SELECT MAX(LPROD_ID) + 1 FROM LPROD),
            (SELECT 'P' || (SUBSTR(MAX(LPROD_GU), 2) + 1) FROM LPROD),
            '트리거 추가값1');
/
SELECT * FROM LPROD;

--------트리거-----------------
CREATE TABLE LPROD_BAK
AS
SELECT * FROM LPROD;
/ 
SELECT * FROM LPROD_BAK;
/
---------트리거 실습하기--------
--급여정보를 자동 추가흐는 트리거 작성하기
-- 직원을 저장할 테이블 생성
CREATE TABLE EMP01(
EMPNO NUMBER(4) PRIMARY KEY,
EMPNAME VARCHAR2(45),
EMPJOB VARCHAR2(60)
);
-- 급여를 저장할 테이블 생성
CREATE TABLE SAL01(
SALNO NUMBER(4) PRIMARY KEY,
SAL NUMBER(7,2),
EMPNO NUMBER(4) REFERENCES EMP01(EMPNO)
);
--급여 번호를 자동으로 저장하는 시퀀스를 정의하고 
-- 이 시퀀스로부터 일련번호를 얻어 급여번호에 부여
CREATE SEQUENCE SAL01_SAL_NO_SEQ
START WITH 1
INCREMENT BY 1;
/
-- 타이밍 : AFTER(~후에), 이벤트 : INSERT(입력) 
CREATE OR REPLACE TRIGGER TGR_02
AFTER INSERT
ON EMP01
FOR EACH ROW
BEGIN 
-- NEW : EMP01테이블에 데이터를 입력한 그 행
INSERT INTO SAL01 VALUES(
SAL01_SAL_NO_SEQ.NEXTVAL, 200, :NEW.EMPNO);
END;
/
INSERT INTO EMP01 VALUES (2201, '성민정', '프로그래머');
INSERT INTO EMP01 VALUES (2202, '성민정', '프로그래머');
INSERT INTO EMP01 VALUES (2203, '개똥이', '프로그래머');

/
SELECT * FROM EMP01;
SELECT * FROM SAL01;
SELECT * FROM EMP01 A, SAL01 B WHERE A.EMPNO = B.EMPNO;
/
-- 사원이 삭제되면 급여정보도 자동삭제되는 트리거
DELETE FROM EMP01 WHERE EMPNO= 2203;
/
/*
사원번호 3을 급여 테이블에서 참조하고 있기 때문에 삭제가 불가능하다
사원이 삭제되려면 그 사원의 급여 정보도 급여 테이블에서 삭제되어야 합니다.
사원의 정보가 제거 될 때 사원의 급여 정보도 함께 삭제
*/
--이벤트 : DELETE, 타이밍 : AFTER
-- => EMP01 테이블의 데이터가 삭제된 후 BEGIN TLFGOD
CREATE OR REPLACE TRIGGER TRG_03
AFTER DELETE
ON EMP01
FOR EACH ROW
BEGIN
    --  OLD : 2202, 개똥이(삭제된 행)
    DELETE FROM SAL01 
    WHERE EMPNO = :OLD.EMPNO;
END;
/
--등푸른생선 주세여
DELETE FROM EMP01
WHERE EMPNO = 2203;

------------패키지-------------
--패키지 생성
/
CREATE OR REPLACE PACKAGE PROD_MGR
IS
--선언부
    --참조변수
    P_PROD_LGU  PROD.PROD_LGU%TYPE;  
    --프로시저
    PROCEDURE PROD_LIST;
    PROCEDURE PROD_LIST (P_PROD_LGU  IN  PROD.PROD_LGU%TYPE);
    --함수
    FUNCTION PROD_COUNT RETURN NUMBER;
    --예외형변수
    EXP_NO_PROD_LGU EXCEPTION;
END;
CREATE OR REPLACE PACKAGE BODY PROD_MGR 
  IS
    CURSOR PROD_CUR (V_LGU VARCHAR2) IS
     SELECT PROD_ID, PROD_NAME, TO_CHAR(PROD_SALE,'L999,999,999') PROD_SALE
     FROM PROD
     WHERE PROD_LGU = V_LGU;  
         
   PROCEDURE  PROD_LIST    IS     
    BEGIN
      IF P_PROD_LGU IS NULL THEN 
           RAISE EXP_NO_PROD_LGU;  
      END IF;
      FOR PROD_REC  IN PROD_CUR (P_PROD_LGU)  LOOP
          DBMS_OUTPUT.PUT_LINE(  PROD_REC.PROD_ID || ', '
                             || PROD_REC.PROD_NAME || ', ' || PROD_REC.PROD_SALE );
      END LOOP;
     EXCEPTION
        WHEN EXP_NO_PROD_LGU THEN
              DBMS_OUTPUT.PUT_LINE ( '상품 분류가 없습니다.'); 
        WHEN  OTHERS  THEN  
             DBMS_OUTPUT.PUT_LINE ( '기타 에러 :' || SQLERRM  ); 
   END PROD_LIST; 
PROCEDURE  PROD_LIST (P_PROD_LGU IN PROD.PROD_LGU%TYPE)
     IS     
   BEGIN
      FOR PROD_REC  IN PROD_CUR (P_PROD_LGU)  LOOP
          DBMS_OUTPUT.PUT_LINE(  PROD_REC.PROD_ID || ', '
                             || PROD_REC.PROD_NAME || ', ' || PROD_REC.PROD_SALE );
      END LOOP;
   EXCEPTION
     WHEN  OTHERS  THEN  
        DBMS_OUTPUT.PUT_LINE ( '기타 에러 :' || SQLERRM  ); 
  END PROD_LIST;  

   FUNCTION PROD_COUNT   
      RETURN NUMBER    
     IS  
       V_CNT NUMBER;
     BEGIN
        SELECT COUNT(*) INTO V_CNT FROM PROD WHERE PROD_LGU = P_PROD_LGU;
        RETURN V_CNT;
   END PROD_COUNT;  
END PROD_MGR;
/

-----------패키지 쉬운 예제-------------
CREATE OR REPLACE PACKAGE PKG_EASY
IS
        V_NAME VARCHAR2(60);
    --회원의 아이디 및 숫자를 받아 마일리지 부여
    PROCEDURE PROC_MILEAGE_UP(P_ID IN VARCHAR2, P_MILEAGE IN NUMBER);
    --회원의 아이디를 받아 이름을 리턴
    FUNCTION FN_GET_NAME(P_ID IN VARCHAR2)
        RETURN VARCHAR2;
END PKG_EASY;
/
--여기까지 우선 컴파일을 함
CREATE OR REPLACE PACKAGE BODY PKG_EASY
IS   
    --회원의 아이디 및 숫자를 받아 마일리지 부여 ->상세내용
    PROCEDURE PROC_MILEAGE_UP(P_ID IN VARCHAR2, P_MILEAGE IN NUMBER)
    IS
    BEGIN
        UPDATE MEMBER
        SET     MEM_MILEAGE = MEM_MILEAGE + P_MILEAGE
        WHERE   MEM_ID = P_ID;
        END PROC_MILEAGE_UP;

    --회원의 아이디를 받아 이름을 리턴-> 상세내용
        FUNCTION FN_GET_NAME(P_ID IN VARCHAR2)
        RETURN VARCHAR2
        IS
        BEGIN
            SELECT MEM_NAME INTO V_NAME 
            FROM MEMBER WHERE MEM_ID = P_ID;
            RETURN V_NAME;
        END FN_GET_NAME;
END PKG_EASY;
/
EXEC PKG_EASY.PROC_MILEAGE_UP('a001', 500);
/
SELECT MEM_ID, MEM_MILEAGE FROM MEMBER WHERE MEM_ID ='a001';
/
SELECT PKG_EASY.FN_GET_NAME('a001') FROM DUAL;
/ 

