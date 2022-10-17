/*SQL(Structed Query Language): ����ȭ �� ���� ���
- ISO(International Standard Organization)���� ������
 ��������(<->������ ex) PL/SQL)�� ������ �����ͺ��̽�(RDB)�� ǥ�� ���
 - �����ݷ�(;)���� ����
 - �����ٷ� �ٷ� �Է� ����
 - ���� �ֱٿ� ������ SQL���� SQL ���ۿ� ���� ����
 
 //"_" ���°��� ���� ����
 
 DDL(Data Definition Language)
 : ������ ���Ǿ�(DB ���� �Ǵ� ��Ű�� ����)
 1) CREATE(��ü-���̺�/��.. ����), ALTER(��ü ����), DROP(��ü ����)
 2_) RENAME(��ü�� ����)
 3_) TRUNCATE(��ü���� ������ ����)
 4_) COMMENT(������ ������ �ּ� �߰�)
 
2. DML(Data Manipulation Language)
: ������ ���۾�
 1) INSERT(������ �Է�-C)
 2) UPDATE(������ ����-U)
 3) DELETE(������ ����-D)
 4) SELECT(������ �˻�-R)
 5_) EXPLAIN(���� ��ȹ��)
 6_) LOCK TABLE(���̺�, �信 ���� ������ �Ͻ��� ���)
 
3. DCL(Data Control Language)
: ������ �����
 1) GRANT(���Ѻο�)
 2) REVOKE(����ȸ��)
 
4. TCL(Transaction Control Language)
 : Ʈ����� �����
 1) COMMIT(Ʈ����� ����)
 2) ROLLBACK(������ COMMIT �������� ȸ��)
 3) SAVEPOINT(Ʈ����� �ӽ�����)
 */
 
 /*<SQL ���� �Է� �� ���࿡ ���� �Ϲ����� ����>
 1. ��� SQL���� �����ݷ�(;)���� ������.
 2. SQL�� ��ɹ��� ��ҹ��ڸ� �������� �ʴ´�. �����ʹ� ��ҹ��ڸ� ������
 3. �ϳ��� SQL���� ����ϵ��� �� �� �Ǵ� ���� �ٷ� ������ �Է��� �� ����
 */
 /*
 ���̺�� ���� ��Ģ
 - �ϳ��� ���� ������ ���̺���� �����ؾ���.
 - �����ڷ� �����ؾ� ��
 - ������, ����, Ư������ �� #_$�� ����� �� ����
 - 30BYTES�� ���� �� ����(�ѱ��� 1���� 3BYTES, �����ѱ��� 10�� ����)
 - ������ ��� ����(NOT,NULL,INSERT..)
 */
 -- ���� ��ҹ��� �ٲٱ� : ALT + '
 -- ���� : CTRL + ENTER, �÷��� ��ư Ŭ��
 -- LPROD ���̺� ����(3���� �÷�, LPROD_GU�÷��� P.K)
CREATE TABLE lprod (
    lprod_id   NUMBER(5) NOT NULL,     --����
    lprod_gu   CHAR(4) NOT NULL,      --��ǰ�з��ڵ�
    lprod_nm   VARCHAR(40) NOT NULL,     --��ǰ�з���
    CONSTRAINT pk_lprod PRIMARY KEY ( lprod_gu )
);
 
 --���̺� ����� �ޱ�

COMMENT ON TABLE lprod IS
    '��ǰ�з�';
 --�÷��� ����� �ޱ�

COMMENT ON COLUMN lprod.lprod_id IS
    '����';

COMMENT ON COLUMN lprod.lprod_gu IS
    '��ǰ�з��ڵ�';

COMMENT ON COLUMN lprod.lprod_nm IS
    '��ǰ�з���';

--P.147
/* 
ALTER TABLE : ���̺��� ������ ����, ������ ������ ����ȵ�

ALTER TABLE <���̺� ��>
    ADD (���ο��÷��� TYPE [DEFAULT VALUE] , ...) => �÷� �߰�, �⺻ �� �߰�
    MODIFY ( �ʵ�� TYPE [NOT NULL] PRFAULT VALUE] , ...)
        => �÷� �ڷ���/ ũ�� ����, NULL�� NOT NULL��, NOT NULL�� NULL�� �������� ����
        => �÷����� ���� X => RENAME�� �����
  DROP COLUMN �ʵ��  => ���� �÷�, �������� ����
*/
--BUYER���̺��� ���� ����(�÷��� �߰�)
--ADD(�߰�), MODIFY(����), DROP(����)
--NULL�� ���� ����

CREATE TABLE buyer (
    buyer_id         CHAR(6) NOT NULL,      --�ŷ�ó�ڵ�
    buyer_name       VARCHAR(40) NOT NULL,      --�ŷ�ó��
    buyer_lgu        CHAR(4) NOT NULL,      --��޻�ǰ ��з�
    buyer_bank       VARCHAR2(60),               --����
    buyer_bankno     VARCHAR2(60),               --���¹�ȣ
    buyer_bankname   VARCHAR2(15),               --������
    buyer_zip        CHAR(7),                    --�����ȣ
    buyer_add1       VARCHAR2(100),              --�ּ�1
    buyer_add2       VARCHAR2(70),               --�ּ�2
    buyer_comtel     VARCHAR2(14) NOT NULL,      --��ȭ��ȣ
    buyer_fax        VARCHAR2(20) NOT NULL       --FAX��ȣ
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
 --ADD(�߰�) CONSTRAINT(�������) CHECK_PHONE(�̸�)
 --CHECK_LIKE : ���Խ�(��������)
 --[0-9] : 0~9 ������ ����
 --[0-9] [0-9] : �� �ڸ��� ����

ALTER TABLE buyer
    ADD CONSTRAINT check_phone CHECK ( REGEXP_LIKE ( buyer_telext,
    '[0-9][0-9]' ) );
 
 -- INDEX : å�� ������ �����
 -- BUYER ���̺��� BUYER_NAME, BUYER_ID�� ��� �ε��� ����
 -- �˻��ӵ��� ������ �Ϸ���

CREATE INDEX idx_buyer ON
    buyer ( buyer_name,
    buyer_id );

--�ε��� ����

DROP INDEX idx_buyer;

ALTER TABLE buyer ADD (
    CONSTRAINT pk_buyer PRIMARY KEY ( buyer_id )
);

ALTER TABLE buyer ADD (
    CONSTRAINT fk_buyer_lprod FOREIGN KEY ( buyer_lgu )
        REFERENCES lprod ( lprod_gu )
);

CREATE TABLE prod (
    prod_id            VARCHAR2(10) NOT NULL,       --��ǰ�ڵ�
    prod_name          VARCHAR2(40) NOT NULL,       --��ǰ��
    prod_lgu           CHAR(4) NOT NULL,       --��ǰ�з�
    prod_buyer         CHAR(6) NOT NULL,       --���޾�ü(�ڵ�)
    prod_cost          NUMBER(10) NOT NULL,       --���԰�
    prod_price         NUMBER(10) NOT NULL,       --�Һ��ڰ�
    prod_sale          NUMBER(10) NOT NULL,       --�ǸŰ�
    prod_outline       VARCHAR2(100) NOT NULL,       --��ǰ��������
    prod_detail        CLOB,                           --��ǰ�󼼼���
    prod_img           VARCHAR2(40) NOT NULL,       --�̹���(��)
    prod_totalstock    NUMBER(10) NOT NULL,       --������
    prod_insdate       DATE,                           --�Ű�����(�����)
    prod_properstock   NUMBER(10) NOT NULL,       --����������
    prod_size          VARCHAR2(20),                   --ũ��
    prod_color         VARCHAR2(20),                   --����
    prod_delivery      VARCHAR2(255),                  --���Ư�����
    prod_unit          VARCHAR2(6),                    --����(����)
    prod_qtyin         NUMBER(10),                     --���԰����
    prod_qtysale       NUMBER(10),                     --���Ǹż���
    prod_mileage       NUMBER(10),                     --���� ���ϸ��� ����
    CONSTRAINT pk_prod PRIMARY KEY ( prod_id ),
    CONSTRAINT fr_prod_lprod FOREIGN KEY ( prod_lgu )
        REFERENCES lprod ( lprod_gu ),
    CONSTRAINT fr_prod_buyer FOREIGN KEY ( prod_buyer )
        REFERENCES buyer ( buyer_id )
);

CREATE TABLE buyprod (
    buy_date   DATE NOT NULL,       --�԰�����
    buy_prod   VARCHAR2(10) NOT NULL,       --��ǰ�ڵ�
    buy_qty    NUMBER(10) NOT NULL,       --���Լ���
    buy_cost   NUMBER(10) NOT NULL,       --���Դܰ�
    CONSTRAINT pk_buyprod PRIMARY KEY ( buy_date,
    buy_prod ),
    CONSTRAINT fr_buyprod_prod FOREIGN KEY ( buy_prod )
        REFERENCES prod ( prod_id )
)

CREATE TABLE member (
    mem_id            VARCHAR2(15) NOT NULL,       --ȸ��ID
    mem_pass          VARCHAR2(15) NOT NULL,       --��й�ȣ
    mem_name          VARCHAR2(20) NOT NULL,       --����
    mem_regnol        CHAR(6) NOT NULL,       --�ֹε�Ϲ�ȣ��6�ڸ�
    mem_regno2        CHAR(7) NOT NULL,       --�ֹε�Ϲ�ȣ��7�ڸ�
    mem_bir           DATE,                               --����
    mem_zip           CHAR(7) NOT NULL,       --�����ȣ
    mem_add1          VARCHAR2(100) NOT NULL,       --�ּ�1
    mem_add2          VARCHAR2(80) NOT NULL,       --�ּ�2
    mem_hometel       VARCHAR2(14) NOT NULL,       --����ȭ��ȣ
    mem_comtel        VARCHAR2(14) NOT NULL,       --ȸ����ȭ��ȣ
    mem_hp            VARCHAR2(15),                        --�̵���ȭ
    mem_mail          VARCHAR2(60) NOT NULL,       --E_mail�ּ�
    mem_job           VARCHAR2(40),                       --����
    mem_like          VARCHAR2(40),                       --���
    mem_memorial      VARCHAR2(40),                       --����ϸ�
    mem_memorialday   DATE,                           --����ϳ�¥
    mem_mailage       NUMBER(10),                         --���ϸ���
    mem_delete        VARCHAR2(1),                        --��������
    CONSTRAINT pk_member PRIMARY KEY ( mem_id )
)

CREATE TABLE cart (
    cart_member   VARCHAR2(15) NOT NULL,        --ȸ��ID
    cart_no       CHAR(13) NOT NULL,        --�ֹ���ȣ
    cart_prod     VARCHAR2(10) NOT NULL,        --��ǰ�ڵ�
    cart_qty      NUMBER(8) NOT NULL,        --����
    CONSTRAINT pk_cart PRIMARY KEY ( cart_no,
    cart_prod ),
    CONSTRAINT fr_cart_member FOREIGN KEY ( cart_member )
        REFERENCES member ( mem_id ),
    CONSTRAINT fr_cart_prod FOREIGN KEY ( cart_prod )
        REFERENCES prod ( prod_id )
)

CREATE TABLE ziptb (
    zipcode   CHAR(7) NOT NULL,      --�����ȣ
    sido      VARCHAR2(2 CHAR) NOT NULL,       --Ư����, ������, ��
    gugun     VARCHAR2(10 CHAR) NOT NULL,       --��, ��, ��
    dong      VARCHAR2(30 CHAR) NOT NULL,       --��, ��, ��, ��, �ǹ���
    bunji     VARCHAR2(10 CHAR),                  --����, ���ĵ嵿, ȣ��
    seq       NUMBER(5) NOT NULL
);       --�ڷ����

CREATE INDEX idx_ziptb_zipcode ON
    ziptb ( zipcode );

 --p.180
/*
INSERT : ���̺� ���ο� ���� �߰��� �� ����.
- �÷���� �Է��ϴ� ���� ���� �����ؾ� ��
- �÷���� �Է��ϴ� ���� ������Ÿ��(�ڷ���)�� �����ؾ� ��
- �⺻Ű�� �ʼ�(N.N) �÷��� �ݵ�� �Է��ؾ� ��
- �÷����� �����Ǹ� ��� �÷��� ���� �ԷµǾ� ��
- �Էµ��� ���� �÷��� ���� ��(NULL) ���� �����
- �Էµ��� ���� �÷��� �⺻ ���� ����� �÷��� �⺻ ���� �����
*/

INSERT INTO lprod (
    lprod_id,
    lprod_gu,
    lprod_nm
) VALUES (
    1,
    'P101',
    '��ǻ����ǰ'
);

INSERT INTO lprod (
    lprod_id,
    lprod_gu,
    lprod_nm
) VALUES (
    2,
    'P102',
    '������ǰ'
);

INSERT INTO lprod (
    lprod_id,
    lprod_gu,
    lprod_nm
) VALUES (
    3,
    'P201',
    '����ĳ�־�'
);

INSERT INTO lprod (
    lprod_id,
    lprod_gu,
    lprod_nm
) VALUES (
    4,
    'P202',
    '����ĳ�־�'
);

INSERT INTO lprod (
    lprod_id,
    lprod_gu,
    lprod_nm
) VALUES (
    5,
    'P301',
    '������ȭ'
);

INSERT INTO lprod (
    lprod_id,
    lprod_gu,
    lprod_nm
) VALUES (
    6,
    'P302',
    'ȭ��ǰ'
);

INSERT INTO lprod (
    lprod_id,
    lprod_gu,
    lprod_nm
) VALUES (
    7,
    'P401',
    '����/CD'
);

INSERT INTO lprod (
    lprod_id,
    lprod_gu,
    lprod_nm
) VALUES (
    8,
    'P402',
    '����'
);

INSERT INTO lprod (
    lprod_id,
    lprod_gu,
    lprod_nm
) VALUES (
    9,
    'P403',
    '������'
);
--* : �ƽ�Ʈ��ũ
--SELECT : ������ �˻�
--LPROD ���̺��� ��� ���� ���� �˻�

SELECT
    *
FROM
    lprod;

--P181
/* 
-SELECT���� ���̺�(��� ���� �̷���� 2���� �迭=RELATION)�κ���
�ʿ��� �����͸� ����(QUERY)�Ͽ� �˻��ϴ� ��ɹ�.
_SELECT, FROM���� �ʼ�����
*/

--P.181
--LPROD ���̺��� ��� �÷�(�Ӽ�, attribute, field, ��)��
--������ �˻�
-- * : �ƽ�Ʈ��ũ(��� �÷�)


 --WHERE : ������ (�ֿ� �ֱ׷�����?)

SELECT
    lprod_gu,
    lprod_nm
FROM
    lprod
WHERE
    lprod_gu <= 'P102';
 --LPROD ���̺��� �����͸� �˻�
 -- ��, ��ǰ�з��ڵ尡 P201 �̸��� ������ �˻�
 --�����ڵ�� ���и� ������

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
    lprod_nm = '������ǰ';
 
--lprod_id�� 3�� row�� select�Ͻÿ�.
--lprod_id, lprod_gu, lprod_nm �÷��� ��� ���

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
 --������Ʈ�� ��뿩
 --LPROD ���̺��� LPROD_GU�� ���� P102�� �����͸� �˻��Ͽ�
 --�ش� ���� LPROD_NM �÷��� ���� '�����' ������

SELECT
    *
FROM
    lprod
WHERE
    lprod_gu = 'P102';

UPDATE lprod
    SET
        lprod_nm = '���'
WHERE
    lprod_gu = 'P102';
 
 
--lprod ���̺��� lprod2 ���̺�� ����
--LPROD ���̺��� ��� ������ LPROD2���̺���
--�����ϸ鼭 ����(��, P.K, F.K�� ������ �ȵ�)

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
 
 
--lprod2 ���̺��� lprod_gu�� P202�� lprod_nm��
--���� ����󿡼� �������� update �Ͻÿ�

SELECT
    *
FROM
    lprod2
WHERE
    lprod_gu = 'P202';

UPDATE lprod2
    SET
        lprod_nm = '������'
WHERE
    lprod_gu = 'P202';

COMMIT;
 
--lprod2 ���̺��� lprod_id�� 7��
--lprod_gu�� P401���� P303���� update �Ͻÿ�.

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
 
 /*DELETE��
 -���̺��� ���� ������
 -��� ���� ������ ���� �ְ�(WHERE���� ���� ��)
  Ư�� ���� ������ ���� ����(WHERE���� ���� ��)
  */
 --��Ǫ������ �ּ���
 --DELETE FROM ���̺��
 --WHERE ����;
 
 --LPROD ���̺��� LPRO_NM�� ȭ��ǰ��
 --�����͸� �����Ͻÿ�.(ROW(=��,Ʃ��,���ڵ�)�� ���� ��)

SELECT
    *
FROM
    lprod2
WHERE
    lpord_nm = 'ȭ��ǰ';

DELETE FROM lprod2 WHERE
    lprod_nm = 'ȭ��ǰ';
 
 
 
-- ��������, ��������
-- char(6)     'a' where ?? =  'a     ' , ��������, ����ȿ�� ����, ����� ����
-- varchar2(6) 'a' where ?? =  'a'      , ������ ���ڰ�, ����ȿ�� ����, �������
 
 --P. 182
 --���̺��� ��� ROW�� COLUMN�� �˻�
 --SELECT * FROM ���̺��;
 --��ǰ ���̺�κ��� ��� row�� column�� �˻��Ͻÿ�. 

SELECT
    *
FROM
    prod;
 
 --ȸ�� ���̺�κ��� ��� row�� column�� �˻��Ͻÿ�. 
 -- * : �ƽ�Ʈ��ũ

SELECT
    *
FROM
    member;
 
 
 --��ٱ��� ���̺�κ��� ��� row�� column�� �˻��Ͻÿ�. 

SELECT
    *
FROM
    cart;
 
--��ǰ ���̺�κ��� ��ǰ�ڵ�� ��ǰ���� �˻��Ͻÿ�. 

SELECT
    prod_id,
    prod_name
FROM
    prod;
  
  --1. buyer ���̺��� buyer2 ���̺�� �����Ͻÿ�
  --(p.k, f.k�� ���簡 �ȵ�

CREATE TABLE buyer2
    AS
        SELECT
            *
        FROM
            buyer;
 
 -- 2. buyer2 ���̺���  buyer_id, buyer_name, buyer_lgu
 --�÷��� ��� select �Ͻÿ�

SELECT
    buyer_id,
    buyer_name,
    buyer_lgu
FROM
    buyer2;

-- 3. buyer2 ���̺��� buyer_id�� P30203�� buyer_name
--   ���� �ż����� update�Ͻÿ�

SELECT
    *
FROM
    buyer2
WHERE
    buyer_id = 'P30203';

UPDATE buyer2
    SET
        buyer_name = '�ż�'
WHERE
    buyer_id = 'P30203';
 
 
 --BUYER2 ���̺��� BUYER_NAME��
 --�Ǹ���� ROW�� �����Ͻÿ�

SELECT
    *
FROM
    buyer2
WHERE
    buyer_name = '�Ǹ��';

DELETE FROM buyer2 WHERE
    buyer_name = '�Ǹ��';

COMMIT;
 
 /*
 ���������
 ��������ڸ� ����Ͽ� �˻��Ǵ� �ڷᰪ ����
 ���������� COLUMN��, �����, ��������ڷ� ����
 ��������ڴ� +, -, *, /, () �α���
 SELECT  ��������  FROM ���̺��
 */

SELECT
    mem_id,
    1004,
    ' ������ ������..',
    mem_name,
    mem_mileage,
    mem_mileage / 12 AS "�� ���"
FROM
    member;
 
 
 --��ٱ��� ���̺�κ��� �ֹ���ȣ, ��ǰ�ڵ�,
 -- ȸ�� ID, ������ �˻��Ͻÿ�

SELECT
    cart_no,
    cart_prod,
    cart_member,
    cart_qty
FROM
    cart;
 
 --P.183
 -- ��������ڴ� +, -, *, /, () �� ����
 --ȸ�� ���̺��� ���ϸ����� 12�� ���� ���� �˻��Ͻÿ�
 --ROUND : �ݿø� �Լ�,(,2 : �Ҽ��� 2°�ڸ����� �츮�� �ݿø�)

SELECT
    mem_mileage,
    mem_mileage / 12,
    round
( mem_
            
            
 
 --��ǰ ���̺�(PROD)�� ��ǰ�ڵ�, ��ǰ��, �Ǹűݾ��� 
--�˻� �Ͻÿ�?
--�Ǹűݾ���  = �ǸŴܰ� * 55 �� ����Ѵ�.
--��ǰ�ڵ�(PROD_ID), ��ǰ��(PROD_NAME), 
--�ǸŴܰ�(PROD_SALE)
 
 SELECT PROD_ID
          ,PROD_NAME
          ,PROD_SALE*55
            
FROM PROD;

--P.183
--�ߺ� ROW(��)�� ����
-- ��ǰ ���̺�(PROD)�� ��ǰ�з�(PROD_LGU)�� 
--�ߺ����� �ʰ� �˻�

SELECT DISTINCT PROD_LGU
FROM PROD;

--DISTINCT : �ߺ� ����, �����
--�÷������ �� �տ� 1ȸ ���

SELECT  DISTINCT CART_MEMBER
          , CART_PROD
FROM    CART
ORDER BY 1, 2;

--��ǰ ���̺��� �ŷ�ó�ڵ带 �ߺ�����
--�ʰ� �˻��Ͻÿ� ?
--(Alias�� �ŷ�ó)
--�ŷ�ó�ڵ� : PROD_BUYER

SELECT DISTINCT PROD_BUYER
FROM PROD;

--P.183
--ROW(��)�� SORT(����)�ϰ��� �ϸ� ORDER BY ���� ���
--ASC(Ascending) : ��������,ASC�� ���� ����
--  �������� 0���� 9, �����ڴ� A���� Z, �ѱ��� ������.. ������ ����
--DESC(Descending) : ��������
--  �������� 9���� 0, �����ڴ� Z���� A, �ѱ��� ����Ÿ.. ������ ����


SELECT     MEM_ID
          ,  MEM_NAME
          , MEM_BIR
          , MEM_MILEAGE
FROM    MEMBER
ORDER BY MEM_BIR DESC;


SELECT 'a��' COL1 FROM DUAL
UNION ALL
SELECT 'A��' FROM DUAL
UNION ALL
SELECT 'a��' FROM DUAL
UNION ALL
SELECT 'B��' FROM DUAL
UNION ALL
SELECT 'b��' FROM DUAL
UNION ALL
SELECT 'B��' FROM DUAL
ORDER BY 1;

--ALIAS(��Ī)
/*
ALIAS?
1) SELECT���� FROM���� ���Ǵ� ����
- �÷� ��½� ���������� ���
-ORDER BY���� ��� ������ ������ ��� ����
- EX) A S "ȸ��ID",    "ȸ��ID",    ȸ��ID(*)
2) FROM������ ���
- ���̺� ���� �ܼ�ȭ�ϱ� ���� ���
- SELECT���� �� ������ �÷����� ������ �� ���
- ���̺�� ALIAS��
*/


SELECT MEM_ID           -- ȸ��ID
      , MEM_NAME           ����
      , MEM_BIR               ����      
      , MEM_MILEAGE       ���ϸ���
FROM MEMBER
ORDER BY ����;

--�÷���ȣ

SELECT MEM_ID              ȸ��ID
      , MEM_NAME           ����
      , MEM_BIR               ����      
      , MEM_MILEAGE       ���ϸ���
FROM MEMBER
ORDER BY 3;

--��������

SELECT MEM_ID              ȸ��ID
      , MEM_NAME           ����
      , MEM_BIR               ����      
      , MEM_MILEAGE       ���ϸ���
FROM MEMBER
ORDER BY MEM_MILEAGE, 1;


--ȸ�����̺�(MEMBER)����
--MEM_ID(ȸ��ID), MEM_JOB(����), 
--MEM_LIKE(���)�� �˻��ϱ�
--�������� ��������, ��̷� ��������, 
--ȸ��ID�� �������� ����

SELECT   MEM_ID       ȸ��ID
          , MEM_JOB     ����
          , MEM_LIKE     ���
            
FROM MEMBER
ORDER BY MEM_JOB , MEM_LIKE DESC, 1 ASC;

--����(MEM_JOB)�� ȸ����� ȸ���� 
--MEM_MEMORIAL �÷��� �����͸� 
--NULL�� �����ϱ�
--** MEM_MEMORIAL = NULL
--** ���ǰ˻� �� ''(Ȧ����ǥ)�� �����


SELECT *
FROM MEMBER
WHERE MEM_JOB = 'ȸ���';

UPDATE MEMBER
SET      MEM_MEMORIAL = NULL
WHERE  MEM_JOB = 'ȸ���';
COMMIT;
 
 --��������(NULL�� �������� ��ġ)
 SELECT MEM_MEMORIAL, MEM_ID FROM MEMBER
 ORDER BY MEM_MEMORIAL ASC;
 
 --�������� (NULL�� ó���� ��ġ)
  SELECT MEM_MEMORIAL, MEM_ID FROM MEMBER
 ORDER BY MEM_MEMORIAL DESC;
 
 --��ǰ���̺�(PROD)�� ��ü �÷��� �˻��ϴµ�
--�ǸŰ�(PROD_SALE)�� �������� ��, 
--��ǰ�з��ڵ�(PROD_LGU)�� �������� ��
--��ǰ��(PROD_NAME)���� �������� �����غ���
 
 SELECT * FROM PROD
 ORDER BY PROD_SALE DESC, PROD_LGU, PROD_NAME;
 
 --P.184
 
 SELECT PROD_NAME ��ǰ��
          , PROD_SALE �ǸŰ�
 FROM PROD
 WHERE PROD_SALE = 170000; 
 
 
 SELECT PROD_NAME ��ǰ��
          , PROD_SALE �ǸŰ�
 FROM PROD
 WHERE PROD_SALE <> 170000;  
 
 
 --p185
 --��ǰ �� ���԰�(PROD_COST)�� 
--200,000�� ������ ��ǰ�� �˻��Ͻÿ�
--(ALIAS�� ��ǰ�ڵ�(PROD_ID), 
--��ǰ��(PROD_NAME), ���԰�(PROD_COST))

 SELECT PROD_COST ���԰�
          , PROD_ID ��ǰ�ڵ�
          , PROD_NAME ��ǰ��
 FROM PROD
 WHERE PROD_COST <= 200000 ;
 
 --ȸ�� �� 76�⵵ 1�� 1�� ���Ŀ� 
--�¾ ȸ���� �˻��Ͻÿ�
--��, �ֹε�Ϲ�ȣ ���ڸ��� ��
--(ALIAS�� ȸ��ID(MEM_ID), 
--ȸ����(MEM_NAME), 
--�ֹε�Ϲ�ȣ ���ڸ�(MEM_REGNO1))
 
 SELECT     MEM_ID ȸ��ID
      ,       MEM_NAME  ȸ����
      ,       MEM_REGNO1  �ֹε�Ϲ�ȣ���ڸ�
FROM MEMBER
WHERE MEM_REGNO1 > 760101  ;
 
 
 -- P.185
 -- ��ǰ �� ��ǰ�з��� P201 (���� ĳ���)�̰ų�
 -- �ǸŰ��� 170,000���� ��ǰ ��ȸ
 -- ALIAS : ��ǰ��
 -- �ų�/ �Ǵ� => OR
 
 SELECT PROD_NAME AS ��ǰ��
 , PROD_LGU         AS ��ǰ�з�
 , PROD_SALE        AS �ǸŰ�
 FROM PROD
 WHERE  PROD_LGU   = 'P201'
 OR       PROD_SALE  = 170000; 
 
 
 --��ǰ �� ��ǰ�з��� P201(���� ĳ���)�� 
--�ƴϰ� 
--�ǸŰ���  170,000���� �ƴ� ��ǰ ��ȸ
--ALIAS : ��ǰ��, ��ǰ�з�, �ǸŰ�
 
  SELECT PROD_NAME AS ��ǰ��
      , PROD_LGU         AS ��ǰ�з�
       , PROD_SALE        AS �ǸŰ�
 FROM PROD
 WHERE PROD_LGU != 'P201'
AND      PROD_SALE  != 170000; 
 
SELECT PROD_NAME AS ��ǰ��
      , PROD_LGU         AS ��ǰ�з�
       , PROD_SALE        AS �ǸŰ�
 FROM PROD
 WHERE NOT PROD_LGU = 'P201'
OR     PROD_SALE = 170000); 

 --��ǰ �� �ǸŰ��� 300,000�� �̻�, 500,000�� 
--������ ��ǰ�� �˻�  �Ͻÿ� ?
--( Alias�� ��ǰ�ڵ�(PROD_ID), 
--��ǰ��(PROD_NAME), �ǸŰ�(PROD_SALE) )
 
 SELECT PROD_ID ��ǰ�ڵ�
           ,PROD_NAME ��ǰ��
          ,PROD_SALE �ǸŰ�
FROM PROD
WHERE 300000<=PROD_SALE
AND            PROD_SALE<=500000;
 
 --���� :
--ȸ��(MEMBER) ���̺���
--����(MEM_JOB)�� �������� �ο� �� 
--���ϸ���(MEM_MILEAGE)�� 1500 �̻��� 
--����Ʈ�� �˻��Ͻÿ�.
--��� �÷��� ���Խ�Ű��
 
 
 SELECT     *
 FROM      MEMBER
 WHERE    MEM_JOB = '������'
 AND        MEM_MILEAGE >= 1500;
 
 
 --P185
 --��ǰ �� �ǸŰ��� 150000��, 170000��, 330000���� ��ǰ ��ȸ
 --ALIAS : ��ǰ��, �ǸŰ�
 
 SELECT PROD_NAME ��ǰ��
      ,     PROD_SALE �ǸŰ�
 FROM   PROD
 WHERE  PROD_SALE IN (150000, 170000, 330000);
 
 --ȸ�����̺�(MEMBER)����
 --ȸ��ID(MEM_ID)�� c001, f001, w001�� ȸ���� �˻��Ͻÿ�
 --ALIAS�� ȸ��ID(MEM_ID), ȸ����(MEM_NAME)
 
 SELECT MEM_ID        ȸ��_ID,
             MEM_NAME   ȸ����
 FROM MEMBER
 WHERE  MEM_ID IN ('c001', 'f001', 'w001');
 
--P.186
--��ǰ �з����̺�(LPROD)���� 
--���� ��ǰ���̺�(PROD)�� 
--�����ϴ� �з��� �˻�(�з��ڵ�(LPROD_GU)
--, �з���(LPROD_NM))
 
 SELECT    LPROD_GU �з��ڵ�
          ,   LPROD_NM �з���
 FROM   LPROD
 WHERE   LPROD_GU NOT IN (SELECT DISTINCT PROD_LGU  FROM   PROD) ;
 
 SELECT DISTINCT PROD_LGU
 FROM   PROD;
 
 
 --��ǰ �� �ǸŰ��� 100,000�� ����  300,000�� 
--������ ��ǰ ��ȸ
--ALIAS : ��ǰ��, �ǸŰ�
 
 SELECT   PROD_NAME ��ǰ��
          ,   PROD_SALE �ǸŰ�
 FROM   PROD
 WHERE  PROD_SALE BETWEEN 100000 AND  300000; 
 
 --ȸ�� �� ������ 1975-01-01���� 1976-12-31���̿� 
--�¾ ȸ���� �˻��Ͻÿ� ? 
--( Alias�� ȸ��ID, ȸ�� ��, ���� )
 
 SELECT     MEM_ID ȸ��ID
           ,   MEM_NAME ȸ����
           ,   MEM_BIR ����
FROM    MEMBER
WHERE  MEM_BIR  BETWEEN '1975-01-01'  AND '1976-12-31';

-- ��¥���� ��¥�� ������ �� ��
--��¥�� ���� ->��¥������ �ڵ� ����ȯ
 
 
 --P.186
--��ǰ �� ���԰�(PROD_COST)�� 300,000~1,500,000�̰� 
--�ǸŰ�(PROD_SALE)��  800,000~2,000,000 �� ��ǰ�� �˻��Ͻÿ� ?
--( Alias�� ��ǰ��(PROD_NAME), 
--���԰�(PROD_COST), �ǸŰ�(PROD_SALE) )
SELECT    PROD_NAME ��ǰ�� 
      ,      PROD_COST  ���԰�
      ,      PROD_SALE   �ǸŰ� 
FROM      PROD
WHERE      ( PROD_COST BETWEEN 300000 AND 1500000) AND
(PROD_SALE BETWEEN 800000 AND 2000000);


--ȸ�� �� ������ 1975�⵵ ���� �ƴ�
--ȸ���� �˻��Ͻÿ� ?
--( Alias�� ȸ��ID, ȸ�� ��, ����)
 
 SELECT   MEM_ID         ȸ��ID
      ,       MEM_NAME  ȸ����
      ,       MEM_BIR       ����
 FROM   MEMBER
 WHERE  MEM_BIR NOT BETWEEN '1975-01-01' AND '1975-12-31';
 
 
-- P.186
-- LIKE ������
--LIKE�� �Բ� ���̴� %, _ : ���ϵ�ī��
--% : ��������,  _ : �ѱ���
--��% : ������ �����ϰ� �ڿ� �������ڰ� ����
-- _��% : 2��° ���ڰ� ������ ����
--%ġ : ġ�� ������ ����(������ ����)
-- %����% : �� �� ������� '����'�̶�� ���ڰ� ���ԵǸ� ��

SELECT  PROD_ID ��ǰ�ڵ�
,           PROD_NAME ��ǰ��
FROM    PROD
WHERE   PROD_NAME LIKE '_��%';

SELECT PROD_ID ��ǰ�ڵ�
,           PROD_NAME ��ǰ��
FROM    PROD
WHERE PROD_NAME LIKE '%ġ';

SELECT PROD_ID ��ǰ�ڵ�
,           PROD_NAME ��ǰ��
FROM    PROD
WHERE PROD_NAME NOT LIKE '%ġ'


SELECT PROD_ID ��ǰ�ڵ�
,           PROD_NAME ��ǰ��
FROM    PROD
WHERE PROD_NAME LIKE '%����%';

-- ȸ�����̺��� �达 ���� ���� ȸ���� 
-- �˻��Ͻÿ�
-- ALIAS�� ȸ��ID(MEM_ID), ����(MEM_NAME)

SELECT  MEM_ID    ȸ��ID  
,           MEM_NAME        ����
FROM MEMBER
WHERE  MEM_NAME LIKE '��%';

--ȸ�����̺��� �ֹε�Ϲ�ȣ ���ڸ���
-- �˻��Ͽ� 1975����� ������
--ȸ���� �˻��Ͻÿ�
--ALIAS�� ȸ��ID, ����, �ֹε�Ϲ�ȣ

SELECT   MEM_ID    ȸ��ID  
,             MEM_NAME        ����
,               MEM_REGNO1 || '  ' || MEM_REGNO2  �ֹε�Ϲ�ȣ
FROM  MEMBER
WHERE MEM_REGNO1 NOT LIKE '75%' ;

--�����̴� ���������� �Ｚ���� ���� ��ǰ�� �����ϰ��� �Ѵ�.
--������ 100���� �̸��̸� ������ ������������ ���ĵ� 
--����Ʈ�� ������ �Ѵ�.
--(ALIAS�� ��ǰID(PROD_ID), ��ǰ��(PROD_NAME), 
--�ǸŰ�(PROD_SALE), ��ǰ�����(PROD_DETAIL))
 
 
 SELECT   PROD_ID   ��ǰ
 ,             PROD_NAME   ��ǰ��
 ,          PROD_SALE    �ǸŰ�
 ,          PROD_DETAIL ��ǰ�����
 FROM PROD
 WHERE PROD_NAME LIKE '%�Ｚ%'
 AND PROD_SALE < 1000000
 ORDER BY  PROD_SALE DESC;
 
 -- P.193
 -- || : �� �̻��� ���ڿ��� �����ϴ� ���տ�����
 SELECT 'a' || 'bcd' FROM DUAL;
 SELECT MEM_ID || '  NAME IS  ' || MEM_NAME FROM MEMBER;
 
 --CONCAT �Լ� : �� ���ڿ��� �����Ͽ� ��ȯ
 SELECT CONCAT('MY NAME IS ' ,MEM_NAME) FROM MEMBER; 
 
 -- CHR :  ASCII -> ���� / ASCII : ���ڸ� ASCII
 SELECT CHR(65) "CHR", ASCII('ABC') "ASCII" FROM DUAL;
 SELECT ASCII (  CHR(65)  ) RESULT FROM DUAL;
 SELECT CHR(75) "CHR", ASCII('K') "ASCII" FROM DUAL;
  
 --P.194
 --LOWER :  �ҹ��ڷ� ��ȯ
 --UPPER : �빮�ڷ� ��ȯ
 --INITCAP : ù���ڸ� �빮�ڷ� ��ȯ
 
 --ȸ�����̺��� ȸ��ID�� �빮�ڷ� 
 --��ȯ�Ͽ� �˻��Ͻÿ�
 --ALIAS ���� ��ȯ��ID, ��ȯ �� ID
 SELECT MEM_ID ��ȯ��ID
 ,   UPPER(MEM_ID) ��ȯ��ID
 FROM MEMBER;
 
--P.194 

--��ǰ���̺��� �Һ��ڰ���(PROD_PRICE)��  
--�Һ��ڰ����� ġȯȭ�� ������ ���� ��µǰ� �Ͻÿ� 
--ALIAS : PROD_PRICE  PROD_RESULT(LPAD�Լ��� ���� ó��)
-- ���鿡 * �ֱ�

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
   , SUBSTR('SQL PROJECT',-7,3) AS RESULT3 --M�� �����̸� ���ʿ������� ó��
FROM   DUAL;

/
--ȸ�����̺��� ���� ��ȸ
SELECT MEM_ID               AS ȸ��ID
   , MEM_NAME
   , SUBSTR(MEM_NAME,1,1) AS ����
FROM   MEMBER;


--��ǰ���̺��� ��ǰ��(PROD_NAME)�� 
--4° �ڸ�����  2���ڰ�
--'Į��' �� ��ǰ�� ��ǰ�ڵ�(PROD_ID), 
--��ǰ��(PROD_NAME)�� �˻��Ͻÿ� ?
--( Alias���� ��ǰ�ڵ�(PROD_ID), ��ǰ��(PROD_NAME) )

SELECT      PROD_ID  ��ǰ�ڵ�
,                PROD_NAME ��ǰ��
FROM       PROD
WHERE     SUBSTR(PROD_NAME, 4 ,2) = 'Į��' ;
AND          PROD_NAME LIKE '___Į��%' ;


--P.196
--P102000001 : ��ǰ�ڵ�
--P102       : ��з�
--000001     : ����
--��ǰ���̺��� ��ǰ�ڵ�(PROD_ID)���� ����4�ڸ�, 
--������6�ڸ��� �˻��Ͻÿ� ?
--(Alias���� ��ǰ�ڵ�(PROD_ID),  ��з�,  ����)

SELECT PROD_ID          ��ǰ�ڵ�
 ,          SUBSTR(PROD_ID,1,4)     ��з�
,            SUBSTR(PROD_ID,5)       ����
FROM PROD;

--P.196
--�ŷ�ó ���̺��� �ŷ�ó�� �� '��'-> '��'���� ġȯ

SELECT 
REPLACE(BUYER_NAME ,'��', '��')
FROM BUYER;

--ȸ�����̺��� ȸ������ �� '��'-> '��'�� ġȯ �˻��Ͻÿ�
--ALIAS ȸ����, ȸ���� ġȯ

SELECT MEM_NAME ȸ����
,          REPLACE(MEM_NAME, '��', '��')  ȸ����ġȯ
FROM MEMBER;

--P.196
--INSTR (����ڿ�,     ã�����ڿ�, ������ġ, ���ڼ�)
-- INSTR('HELLO HEIDI', 'HE',           1 ,          2) 
--INSTR(c1 ,c2, [m, [n]]) : m���� �����ؼ� n��°�� c2�� ��ġ�� ���
-- 1 : ù��° ���ں��� HE�� ã��
-- 2 : �ι�°

SELECT INSTR('hello heidi', 'he') result
from dual;

--���� : I have a hat.
--1 ù��° ha�� ��ġ�� ���
-- �ι�° ha�� ��ġ�� ���

select instr('I have a hat.','ha') ù��°
, instr('I have a hat.', 'ha', 1, 2) �ι�°
from dual;

--���� : I have a hat that i had have been found 
--      that hat before 2 years ago.
--1. ���� ���忡�� 5��° ha�� ��ġ�� ���
--INSTR(c1 ,c2, [m, [n]]) : m���� �����ؼ� n��°�� c2�� ��ġ�� ���

SELECT INSTR( 'I have a hat that i had have been found that hat before 2 years ago.', 'ha', 1, 5)
FROM DUAL;

--����
--mepch@test.com
--���� ���ڿ��� @�� �������� ������ ���� ����ϱ�
--���̵� | ������
--------------------
--mepch  | test.com

SELECT SUBSTR('Mepch@test.com', 1,5) ���̵�
, SUBSR('Mepch@test.com',7)  ������
, INSTR('Mepch@test.com','@')
FROM  DUAL;

SELECT  SUBSTR('Mepch@test.com', 1, INSTR('Mepch@test.com','@')-1) ���̵�
,  SUBSTR('Mepch@test.com', INSTR('Mepch@test.com','@')+1) ������
FROM DUAL;
 
 
 SELECT MEM_ID 
 ,MEM_NAME
 ,SUBSTR(MEM_MAIL,1,INSTR(MEM_MAIL,'@')-1) ���̵�
 ,SUBSTR(MEM_MAIL,1,INSTR(MEM_MAIL,'@')+1) ������

 FROM MEMBER;
 
 
 --P.197
 -- LENGTH : ������,  LENGTHB : ������ BYTES
 -- ������/ Ư����ȣ : 1BYTE,  �ѱ� : 3BYTES
 
 SELECT LENGTH('SQL ������Ʈ' )  LENGTH
      ,  LENGTHB('SQL ������Ʈ')  LENGTHB
        FROM DUAL;
        
        SELECT BUYER_ID     AS �ŷ�ó�ڵ�
      ,  LENGTH(BUYER_ID) AS �ŷ�ó�ڵ����
      ,  BUYER_NAME AS �ŷ�ó��
      , LENGTH(BUYER_NAME) AS �ŷ�ó�����
      , LENGTHB(BUYER_NAME)AS �ŷ�ó�����
        FROM BUYER;
 
 
 ---P.197
 --ABS   : ���밪
 
 SELECT ABS(-365)  FROM DUAL; --365
 
 --SIGN   ; ���(1), 0 (0), ����(-1)
 SELECT SIGN(12), SIGN(0), SIGN(-55) FROM DUAL;
 
--3��2��, 2��10��
SELECT POWER(3, 2), POWER(2, 10) FROM DUAL;

--������
 SELECT SQRT(2), SQRT(9) FROM DUAL;
 
 
 --P.197
 SELECT   GREATEST (10, 20, 30) ����ū��
   , LEAST(10, 20, 30)    ����������
FROM   DUAL;
 
  -- ���ں��� �ѱ��� ŭ
 
SELECT GREATEST('������', 256, '�۾���') ����ū��
   , LEAST('������', 256, '�۾���')    ����������
FROM   DUAL;
 
 
 --P.198
--ȸ��(MEMBER) ���̺��� ȸ���̸�(MEM_NAME),  
--���ϸ���(MEM_MILEAGE)�� ����Ͻÿ�
--(��, ���ϸ����� 1000���� ���� ��� 1000���� ����) 
 
 
 SELECT     MEM_NAME ȸ���̸�
,   GREATEST(MEM_MILEAGE,1000) ���ϸ���
FROM MEMBER;


-- P.197 
 --   ROUND :  �ݿø�, TRUNC : ����
 --   2 : �Ҽ��� ��°�ڸ����� �츮��
 --  -2 : ��°�ڸ����� �ݿø�
  SELECT ROUND(345.123, -2) FROM DUAL;
  SELECT ROUND(345.123, -1) FROM DUAL;
  SELECT ROUND(345.123, 0) FROM DUAL;
  SELECT ROUND(345.123, 1)  FROM DUAL;
  SELECT ROUND(345.123, 2) FROM DUAL;
  --����� �츮��, ������ ����
   SELECT TRUNC(345.123, 0) FROM DUAL;
   SELECT TRUNC(345.123, 1) FROM DUAL;
   SELECT TRUNC(345.123, 2 ) FROM DUAL;
   SELECT ROUND(345.123, -1)  ���1
 ,           TRUNC(345.123, -1) ���2
   FROM DUAL;

 -- ȸ�� ���̺��� ���ϸ����� 12�� ���� ���� �˻�
 --(�Ҽ� 2°�ڸ� �츮�� �ݿø�, ����)
 
 
 SELECT MEM_MILEAGE / 12
 ,          ROUND(MEM_MILEAGE / 12 ,2) �츮��ݿø�
 ,          TRUNC(MEM_MILEAGE / 12, 2) ����

 FROM MEMBER;
 
 
 --P.198
--��ǰ���̺��� ��ǰ��, ������( ���԰� / �ǸŰ� )��  ����(%)��
--(�ݿø� ���� �Ͱ� �Ҽ� ù°�ڸ� �츮�� �ݿø� ��) �˻��Ͻÿ� ?
--(Alias�� ��ǰ��, ������1, ������2)
 
 SELECT    PROD_NAME  ��ǰ��
 ,             PROD_COST / PROD_SALE*100 ������1
 ,              ROUND(PROD_COST / PROD_SALE *100, 1)  ������2
 FROM  PROD;
 
 -- P.198
 -- int nameuji = 10%3;
 SELECT MOD(10, 3) FROM DUAL;
 
 --ȸ�����̺�(MEMBER)�� ���ϸ����� 12�� ���� �������� ���Ͻÿ�
--ALIAS�� ȸ��ID(MEM_ID), ȸ����(MEM_NAME), 
--���ϸ�������(MEM_MILEAGE), ���ϸ������(MEM_MILEAGE)
 
 SELECT    MEM_ID ȸ��ID
 ,              MEM_NAME    ȸ����
 ,              MEM_MILEAGE ���ϸ�������
 ,              MOD(MEM_MILEAGE, 12)  ���ϸ������
 FROM MEMBER;
 
 
 -- P.198 
 --  FLOOR : ����(����ٴ�)
 --  CEIL : �ø�(õ��)
 
 SELECT FLOOR(1332.69), CEIL(1332.69) FROM DUAL;
 SELECT FLOOR(-1332.69), CEIL(-1332.69) FROM DUAL;
 SELECT FLOOR(2.69), CEIL(2.69) FROM DUAL;
 SELECT FLOOR(-2.69), CEIL(-2.69) FROM DUAL;

 
--����
--  -3.141592�� ����(FLOOR)�� �ø�(CEIL)�� ���Ͻÿ�
--ALIAS : ����, ����, �ø�
SELECT  -3.141592  ����
,          FLOOR(-3.141592)   ����
,           CEIL(-3.141592)  �ø�
 FROM  DUAL;
 
 -- P.199
 --SYSDATE �ڡڡڡڡ�
 -- �ý��� ��¥�� ��-��-�� ��:��:��
 SELECT SYSDATE FROM DUAL;
 -- �ý��� ��¥�� ��-��-�� ��:��:��. 1000���� 1��
  SELECT SYSTIMESTAMP FROM DUAL;

 -- P.199
 SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD HH:MI:SS') ����ð�
      ,       SYSDATE - 1 AS �����̽ð�
      ,       SYSDATE + 1 AS �����̽ð�
      , TO_CHAR(SYSDATE + 1/24, 'YYYY-MM-DD HH:MI:SS') �ѽð���
      , TO_CHAR(SYSDATE + 1/(24*60), 'YYYY-MM-DD HH:MI:SS') �Ϻ���
        FROM DUAL;
 
 --P.199
--ȸ�����̺�(MEMBER)�� ���ϰ� 
--12000��° �Ǵ� ���� �˻��Ͻÿ� ?
--(Alias�� ȸ����(MEM_NAME), 
--����(MEM_BIR), 12000��°)
--������ �ð� ǥ���� ��� ���� ����(AM, PM, A.M., P.M.)�� ǥ�õǰų�
--24�ð� ����(HH24)���� ��µǰԴ� �� �� ���� �ɱ��...?
 
 
 SELECT  MEM_NAME ȸ����
 ,            MEM_BIR  ����
 ,            MEM_BIR + 12000 "12000��°"
 ,         TO_CHAR(MEM_BIR + 12000, 'YYYY-MM-DD HH:MI:SS AM')
 FROM MEMBER;
 
 --���� �� ���� �������??
 SELECT TO_DATE('1993-09-03') ������
         , ROUND(SYSDATE - TO_DATE('1993-09-03'),1) �������ϼ�
 FROM DUAL;
 
--���� : ���� �� ���� ��Ҵ°�? TO_DATE('2015-04-10')�Լ� �̿�
--��, ���� �Ϸ翡 3���� ����.
--      �Ҽ��� 2°�ڸ����� �ݿø��Ͽ� ó���Ͻÿ�.
--ALIAS : ������, ���ϼ�, �������, 
--��������(�ѳ��� 3000������ ó��)

SELECT TO_DATE('1993-09-03') ������
,           ROUND(SYSDATE - TO_DATE('1993-09-03'), 2) ���ϼ�
,           ROUND(SYSDATE - TO_DATE('1993-09-03'), 2) * 3 �������
,           ROUND(SYSDATE - TO_DATE('1993-09-03'), 2) * 3 * 3000 ��������
 FROM DUAL;

--p.199
-- ADD_MONTHS()�Լ� :  ���� ���� ��¥ 
-- ���ú��� 5��  ���� ��¥
SELECT ADD_MONTHS(SYSDATE, 5) FROM DUAL;
 
 -- NEXT_DAY()  :  ���� ���� ������ ��¥
 --LAST_DAY()      :    ���� ������ ��¥
 SELECT NEXT_DAY(SYSDATE, '������')
          ,       NEXT_DAY(SYSDATE, '�ݿ���')
          ,       LAST_DAY(SYSDATE)
FROM    DUAL;
 
--�̹����� ��ĥ�� ���Ҵ��� �˻��Ͻÿ�?
-- ALIAS : ���ó�¥, �̴޸�������¥, �̹��޿�������¥
 
SELECT      SYSDATE  ���ó�¥
      ,         LAST_DAY(SYSDATE) �̴޸�������¥
       ,        LAST_DAY(SYSDATE) - SYSDATE        �̹��޿�������¥    
 FROM DUAL;
 
 --P. 200
 -- ��¥ ROUND    /   TRUNC
 -- FMT(FOMAT : ����) : YEAR(����) , MONTH(��), DAY(����) , DD(��)...
 SELECT ROUND(SYSDATE, 'MM') -- �̹��� 50%�� �Ѿ����Ƿ� 7�� 1��
          ,   TRUNC(SYSDATE, 'MM') --�̹��� 50%�� �Ѿ����� ������ 6�� 1��
 FROM DUAL;
 
 SELECT ROUND(SYSDATE, 'YEAR') --���� 50%�� �ȳѰ����Ƿ�  1�� 1��
      ,    TRUNC(SYSDATE, 'YEAR')  -- ���� 50%�� �ȳѱ� ������ 1�� 1��
        FROM DUAL;
 
-- P.200
-- MONTHS_BETWEEN    : �� ��¥ ������ �޼��� ���ڷ� ����
SELECT MONTHS_BETWEEN(SYSDATE, '1993-09-03')
FROM DUAL;


-- EXTRACT(�ڡڡ�)   :  ��¥���� �ʿ��� �κи� ����
-- (FMT :YEAR(��), MONTH(��), DAY(��), HOUR(��), MINUTE(��),  SECOND(��))
SELECT  EXTRACT(YEAR FROM SYSDATE)  �⵵
      ,    EXTRACT(MONTH FROM SYSDATE)    ��
      ,   EXTRACT(DAY FROM SYSDATE)   ��
      ,   EXTRACT(HOUR FROM SYSTIMESTAMP)-3    ��
      ,   EXTRACT(MINUTE FROM SYSTIMESTAMP)   ��
      ,   EXTRACT(SECOND FROM SYSTIMESTAMP)   ��
FROM DUAL;
 
 --��-��-�� ��:��:��.�и�������
 SELECT TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH:SS:FF3')
 FROM DUAL;
 
 --������ 3���� ȸ���� �˻��Ͻÿ�
--(ALIAS : ȸ��ID(MEM_ID), 
-- ȸ����(MEM_NAME), ����(MEM_BIR))
 
 SELECT MEM_ID  ȸ��ID
 ,    MEM_NAME   ȸ����
 ,    MEM_BIR    ����
FROM    MEMBER 
WHERE     EXTRACT(MONTH FROM MEM_BIR) = 3  
 AND        MEM_BIR LIKE    '%/03/%'
 AND        SUBSTR(MEM_BIR, 4, 2) = '03';
 
--����
--�԰��ǰ(BUYPROD) �߿� 3�� �� �԰�� ������ �˻��Ͻÿ�
--ALIAS : ��ǰ�ڵ�(BUY_PROD), �԰�����(BUY_DATE)
--, ���Լ���(BUY_QTY), ���Դܰ�(BUY_COST)
--EXTRACT ����ϱ�, SUBSTR ����ϱ�, LIKE ����ϱ�
 
 SELECT BUY_PROD ��ǰ�ڵ�
      ,    BUY_DATE �԰�����
      ,    BUY_QTY  ���Լ���
      ,    BUY_COST  ���Դܰ�
FROM BUYPROD
WHERE EXTRACT(MONTH FROM BUY_DATE) = 3
AND     BUY_DATE    LIKE    '%/03/%'
AND     SUBSTR(BUY_DATE, 4, 2) ='03';
 
 --P.201 
 -- CAST : ����� �� ��ȯ
 -- CHAR (30) : �������� ������
 -- VARCHAR2 (30)    :  �������� ������
 SELECT      ' [ ' || 'Hello' || ' ] '   ����ȯ
          ,     ' [ ' || CAST('Hello' AS CHAR(30))  || ' ] '  �������̹�������ȯ
          ,      ' [ ' || CAST( 'Hello' AS VARCHAR2(30)) || ' ] ' �������̹�������ȯ
 FROM     DUAL ;
 
 --�ڡڡ�
 -- TO_DATE()   :   ��¥�����ڸ� ��¥������ ����ȯ
 -- CAST :   ��¥�� ���ڸ� ������ ������ ����ȯ
 -- '2022/05/17' + 1    :   ��¥�� ���� + ���� ��=> ��¥�� ���ڰ� ���ڷ� �ڵ�����ȯ
 SELECT '2022/05/17'
  ,           TO_DATE('2022/05/17')   
  ,           CAST('2022/05/17' AS DATE)  +   1
  FROM     DUAL ;
           
--P. 201
--TO_CHAR() : ����/����/��¥�� ������ ������ ���ڿ��� ��ȯ
-- ���� ��¥�� �̷��� ������ ���ڿ��� ��ȯ
SELECT TO_CHAR(SYSDATE, 'AD YYYY, CC"����"    ')
FROM    DUAL;
--�����߻�
SELECT TO_CHAR('2008-12-25', 'YYYY.MM.DD HH24:MI:SS')
FROM    DUAL;

--�ڡڡڡ�
-- TO_DATE : 2008-12-25�� ��-��-�� ������
-- ��¥�� ���ڶ�� ��Ŭ�̿��� �˷���
SELECT  TO_CHAR(TO_DATE('2008-12-25', 'YYYY.MM.DD'), 'YYYY.MM.DD HH24:MI:SS')
FROM    DUAL;

 

--P.202
-- ��ǰ���̺��� ��ǰ�԰����� '2008-09-28 12:00:00' 
--�������� ������ �˻��Ͻÿ�.
--(Alias ��ǰ��(PROD_NAME), ��ǰ�ǸŰ�(PROD_SALE)
--, �԰���(PROD_INSDATE))
 -- '2008-09-28 12:00:00'  :  ��¥�� ����
-- �԰��� PROD_INSDATE : DATE�̹Ƿ� TO_DATE�� �ʿ� ����

SELECT    PROD_NAME  ��ǰ��
      ,       PROD_SALE  ��ǰ�ǸŰ�
      ,       TO_CHAR(PROD_INSDATE, 'YYYY-MM-DD HH:MI:SS')  �԰���
from PROD;
 
--����� ����
--��ٱ��� ���̺��� ����Ͽ� ����ó�� ����غ���
--ALIAS : ��ٱ��� ��ȣ, �����Ͻ�
-- �����Ͻô� '2005-04-03 12:00:00' �������� ���
SELECT CART_NO ��ٱ��Ϲ�ȣ
      ,   TO_CHAR(TO_DATE( SUBSTR(CART_NO, 1, 8) , 'YYYYMMDD'), 'YYYY-MM-DD HH:MI:SS') �����Ͻ�
FROM    CART;

--�����
--ȸ�� ���̺��� ����Ͽ� ����ó�� ����غ���
--ALIAS :   ȸ��ID(MEM_ID), ȸ����(MEM_NAME), ȸ������(MEM_BIR)
--ȸ�������� '1985-03-02 12:00:00' �������� ���
-- YY : 2�ڸ�����, MON : ,1��, HH24 : 24�ð�����, AM : ����/����


SELECT  MEM_ID ȸ��ID
,           MEM_NAME  ȸ����
,           TO_CHAR(MEM_BIR, 'YYYY-MM-DD HH:MI:SS AM')  ȸ������
FROM MEMBER;
 
 
 --P.202
 -- TO_CHAR() �Լ� �� ���ڸ� ���ڷ� ����ȯ
 SELECT 1234.6 + 0.4 FROM DUAL;
 
 SELECT TO_CHAR(1234.6,'L9,999.00')
 FROM DUAL;
 
  SELECT TO_CHAR(-1234.6,'L9,999.00PR')
 ,           TO_CHAR(-1234.6,'L9,999.00MI')
 FROM DUAL;
 
 SELECT TO_CHAR(255, 'XXX') FROM DUAL;
 
 --����
--��ǰ �ǸŰ��� ������ ���� �������� ����Ͻÿ�
--��230,000
--ALIAS : ��ǰID(PROD_ID), ��ǰ��(PROD_NAME)
--, �ǸŰ�(PROD_SALE)
 
 SELECT PROD_ID  ��ǰID
 ,          PROD_NAME  ��ǰ��
 ,        TRIM( TO_CHAR(PROD_SALE, 'L99,99,99,99,99,999,999'))  �ǸŰ�
 FROM PROD;
 
 --P.203
--��ǰ���̺��� ��ǰ�ڵ�, ��ǰ��, ���԰���, 
-- �Һ��ڰ���, �ǸŰ����� ����Ͻÿ�. 
-- (��, ������ õ���� ���� �� ��ȭǥ��)
 
 SELECT PROD_ID  ��ǰ�ڵ�
 ,      PROD_NAME  ��ǰ��
 ,      TO_CHAR(PROD_COST, 'L999,999,999') ���԰���
 ,      TO_CHAR(PROD_PRICE, 'L999,999,999')   �Һ��ڰ���
 ,      TO_CHAR(PROD_SALE, 'L999,999,999')   �ǸŰ���
 FROM PROD;
 
 --����
--�������̺�(BUYPROD)�� ���԰��� ���
--AVG(BUY_COST)�� ���� �������� ���
--�Ҽ��� 2��° �ڸ����� �츮�� �츮��~ �ݿø�ó��
--��210,000.350
--��ǥ�� : �� + ����Ű
 
 SELECT    TO_CHAR(ROUND(AVG(BUY_COST), 2), 'L999,999.000')
 FROM BUYPROD;
 
 --P. 203
 -- TO NUMBER : ���������� ���ڿ� -> ���ڷ� ��ȯ
 -- ������ ���� + ���� => ���ڷ� �ڵ�����ȯ + ���� =>������ ���
 SELECT '3.1415' + 1 FROM DUAL;
 -- ����������(O) -> ������  ��ȯ
 SELECT TO_NUMBER('3.1415') FROM DUAL;
 
 -- ���� (X) -> ������ ��ȯ (X)
 SELECT TO_NUMBER('\1,200') + 1 FROM DUAL;
 
  -- ���� (X) -> ������ ��ȯ (X)
 SELECT TO_NUMBER('������') + 1 FROM DUAL;
 
 --��Ŭ�� �̰� ���ھ�. \�� L�����̰�,
 --','�� õ���� ���б�ȣ�� ��� �˷���
 SELECT TO_NUMBER('\1,200', 'L999,999') + 1 FROM DUAL;
 --�̷� �������� ���
 SELECT TO_CHAR('1200' , 'L999,999') FROM DUAL;
 
 --P.203
--ȸ�����̺�(MEMBER)���� �̻���ȸ��(MEM_NAME='�̻���')��
--ȸ��Id 2~4 ���ڿ��� ���������� ġȯ�� �� 
--10�� ���Ͽ� ���ο� ȸ��ID�� �����Ͻÿ� ?
--(Alias�� ȸ��ID(MEM_ID), ����ȸ��ID)
 SELECT     MEM_ID ȸ��ID
 ,              SUBSTR(MEM_ID,1,1)  
                 ||   TRIM( TO_CHAR(TO_NUMBER(SUBSTR(MEM_ID,2) ) + 10, '000')) ����ȸ��ID
 FROM MEMBER
 WHERE MEM_NAME = '�̻���';
 
 -- ��ǰ���̺�(PROD)����
 -- ��ǰ�ڵ�(PROD_ID)�� 'P101000001'�� ��������
 --������ ���� 1 �������Ѻ���. (P101�� 000001�� �и�)
 -- P101000002
 --ALIAS : ��ǰ�ڵ�, ������ǰ�ڵ�
 
 SELECT PROD_ID       ��ǰ�ڵ�
 ,          SUBSTR(PROD_ID, 1, 1)
  ||          TO_CHAR(SUBSTR(PROD_ID, 2) + 1) ������ǰ�ڵ�
 FROM PROD
 WHERE PROD_ID = 'P101000001';
 
 SELECT PROD_ID       ��ǰ�ڵ�
 ,          SUBSTR(PROD_ID, 1, 4)
||       TRIM( TO_CHAR(SUBSTR(PROD_ID,5) + 1, '000000'))������ǰ�ڵ�
 FROM PROD
 WHERE PROD_ID = 'P101000001';
 
 
 --P.203
 -- TO_DATE  : ��¥������ ���ڿ��� DATE������ ��ȯ
 SELECT '2009-03-05' + 3 FROM DUAL; --������
 
 SELECT TO_DATE('2009-03-05') + 3 FROM DUAL;
 
 --��Ŭ�� �̰� ��¥�� ���ھ�
 --2009�� YYYY�̰�, 03�� MM�̰�, 05�� DD�� ��� �˷���
 SELECT TO_DATE('2009-03-05', 'YYYY-MM-DD') + 3 FROM DUAL;
 
 --��(TO_CHAR) ��(���) ��(����) (O)
 --��(TO_CHAR) ��(���) ��(����)  (X)
 --��(TO_CHAR) ��(���) ��(����)  (X)
 SELECT TO_CHAR('200803101234' , 'YYYY-MM-DD HH24:MI')
 FROM DUAL;         -- (X), �տ� TO_DATE�� �Ἥ '200803101234'�� ��¥���� �˷������
 
-- (O)
  SELECT TO_DATE('2009-03-10') + 3 FROM DUAL;
-- (X)
  SELECT TO_DATE('200803101234') + 3 FROM DUAL;
  
  --��Ŭ������ �˷���
 SELECT TO_CHAR(TO_DATE('200803101234' , 'YYYYMMDDHHMI') +3, 'YYYY-MM-DD HH24:MI')
 FROM DUAL;
 --(O)
 SELECT TO_CHAR(TO_DATE('200803101234', 'YYYY-MM-DD HH:MI'), 'YYYYMMDDHH24MI')
 FROM DUAL;
 
--(O) : ��¥�������̹Ƿ�
SELECT TO_DATE('20220621') FROM DUAL;
--(X) : �ð������� �ν��� �ȵ�
SELECT TO_DATE('202206211619') FROM DUAL;
--(O) : ��¥�������̹Ƿ�. (��.��.�� / ��/��/�� / ��-��-��)
SELECT TO_DATE('2022-06-21') FROM DUAL;
--(X) : �ð������� �ν��� �ȵ�
SELECT TO_DATE('2022-06-21 16:19') FROM DUAL;
--(O) : �̷� �� ��Ŭ�̿��� �˷������
SELECT TO_DATE('2022-06-21 16:19','YYYY-MM-DD HH24:MI') FROM DUAL;
 
 --(O) : ��¥�������̹Ƿ�.(��.��.�� / ��/��/�� / ��-��-��)
SELECT TO_DATE('2021.12.25') FROM DUAL;
--(X) : 11:10 ������ �ν� �ȵ�
SELECT TO_DATE('2021.12.25 11:10') FROM DUAL;
--(O) : �̷� �� ��Ŭ�̿��� �˷���� ��
SELECT TO_DATE('2021.12.25 11:10','YYYY.MM.DD HH:MI') FROM DUAL;
--(O) : ��¥�������̹Ƿ�.(��.��.�� / ��/��/�� / ��-��-��)
SELECT TO_DATE('2021/12/25') FROM DUAL;
--(X) : '2021/12/25'�� ��¥�������̹Ƿ�
SELECT TO_CHAR('2021/12/25','YYYY/MM/DD') FROM DUAL;
--(O) : TO_DATE('2021/12/25')�� ��¥���̹Ƿ�
SELECT TO_CHAR(TO_DATE('2021/12/25'),'YYYY/MM/DD') FROM DUAL;
--SELECT TO_CHAR(���׶��, 'YYYY-MM-DD') FROM DUAL;
SELECT TO_CHAR(TO_DATE('2021.12.25 11:10','YYYY.MM.DD HH:MI'),'YYYY/MM/DD') FROM DUAL;
 
--P.204
--ȸ�����̺�(MEMBER)���� �ֹε�Ϲ�ȣ1(MEM_REGNO1)��
--��¥�� ġȯ�� �� �˻��Ͻÿ�
--(Alias�� ȸ����(MEM_NAME), �ֹε�Ϲ�ȣ1, 
--ġȯ��¥(MEM_REGNO1 Ȱ��) 
 
 SELECT MEM_NAME    ȸ����
 ,            MEM_REGNO1   �ֹε�Ϲ�ȣ1
 ,            TO_DATE(MEM_REGNO1, 'YYMMDD' ) ġȯ��¥
 FROM MEMBER;
 
 --��ٱ��� ���̺�(CART)���� ��ٱ��Ϲ�ȣ(CART_NO)��
--��¥�� ġȯ�� �� ������ ���� ����ϱ�
--2005�� 3�� 14��
--ALIAS : ��ٱ��Ϲ�ȣ, ��ǰ�ڵ�, �Ǹ���, �Ǹż�
 
 SELECT   CART_NO ��ٱ��Ϲ�ȣ
 ,              CART_PROD ��ǰ�ڵ�
   , TO_CHAR(TO_DATE(SUBSTR(CART_NO,1,8),'YYYYMMDD'),'YYYY"�� "MONDD"��"') �Ǹ��� ,              CART_QTY  �Ǹż�
 FROM CART;
 
 
 --P.205
 --�ŷ�ó���̺��� �ŷ�ó��, ����� ��ȸ
 SELECT BUYER_NAME   �ŷ�ó��
 ,             BUYER_CHARGER �����
 FROM BUYER;
 
 --�ŷ�ó ����� ������ '��'�̸� NULL�� ����
 SELECT BUYER_NAME �ŷ�ó��
      ,      BUYER_CHARGER  �����
 FROM   BUYER
 WHERE BUYER_CHARGER  LIKE '��%';
 
 --������Ʈ ��뿩
 UPDATE  BUYER
 SET        BUYER_CHARGER = NULL
 WHERE BUYER_CHARGER  LIKE '��%';
 
--�ŷ�ó ����� ������ '��'�̸� White Space�� ����
--White Space : '' = null
 
 SELECT BUYER_NAME �ŷ�ó��
      ,      BUYER_CHARGER  �����
 FROM   BUYER
 WHERE BUYER_CHARGER   LIKE '��%';
 
UPDATE  BUYER
SET         BUYER_CHARGER = ''
WHERE   BUYER_CHARGER  LIKE '��%';
 
 
 --P.206
 --����ڰ� NULL�� �����͸� �˻�
 
 SELECT BUYER_NAME �ŷ�ó
 , BUYER_CHARGER  �����
 FROM BUYER
 WHERE BUYER_CHARGER IS NULL;
 
 --����ڰ� NULL�� �ƴ� �����͸� �˻�
 SELECT BUYER_NAME  �ŷ�ó
 , BUYER_CHARGER  �����
 FROM BUYER
 WHERE BUYER_CHARGER IS NOT NULL;
 
 --�ش� �÷��� NULL�� ��쿡 ����� ���ڳ� ���� ġȯ
 --1) NULL�� �����ϴ� ���·� ��ȸ
SELECT BUYER_NAME �ŷ�ó��
,           BUYER_CHARGER �����
FROM BUYER;
 
 --2) NVL�� �̿� NULL���� ��츸 '����'�� ġȯ
-- �١١١١� NVN :�ιٶ� 
 SELECT BUYER_NAME �ŷ�ó��
,           NVL(BUYER_CHARGER, '����') �����
FROM BUYER;

 --P.206
 --��üȸ�� ���ϸ����� 100�� ���� ��ġ�� �˻�
 --ALIAS : ����, ���ϸ���, ���渶�ϸ���

 SELECT MEM_NAME             ����
      ,       MEM_MILEAGE     ���ϸ���
      ,       MEM_MILEAGE  + 100   ���渶�ϸ���
FROM        MEMBER;
 
 
 --ȸ�� ������ '��'�� �����ϸ� ���ϸ����� NULL�� ����
 --��, ��, ��..
 
 SELECT MEM_NAME
 ,      MEM_MILEAGE
 FROM MEMBER
 WHERE MEM_NAME >= '��' AND MEM_NAME<= '��';
 
 UPDATE  MEMBER
 SET  MEM_MILEAGE = NULL
 WHERE  MEM_NAME >= '��' AND MEM_NAME<= '��';

--P.206 
 SELECT NULL +10 ����
       , 10* NULL     ����
       , 10/NULL      ������
       , NULL -10     ����
  FROM DUAL;
 
 --P. 207
 --ȸ�� ���ϸ����� 100�� ���� ��ġ�� �˻�
 --ALIAS : ����, ���ϸ���, ���渶�ϸ���
 
 SELECT MEM_NAME             ����
      ,       MEM_MILEAGE     ���ϸ���
      ,      NVL( MEM_MILEAGE,0)  + 100   ���渶�ϸ���
FROM        MEMBER;
 
 --ȸ�� ���ϸ����� ������ '���� ȸ��', NULL�̸�
 --'������ ȸ��'���� �˻��Ͻÿ�
 --NVL2 ���, ALIAS �� ����, ���ϸ���, ȸ������
 --NVL2(NULL, '����ȸ��', '������ ȸ��')
 
 --NVL2 : NULL�� �ƴϸ� �ι�° �μ�, NULL�̸� ����° �μ�
 SELECT MEM_NAME             ����
      ,       MEM_MILEAGE     ���ϸ���
      ,      NVL2( MEM_MILEAGE, '���� ȸ��', '������ ȸ��')     ���渶�ϸ���
 FROM        MEMBER;
 
 --P.207
 SELECT NULLIF(123, 123)  AS "������� NULL��ȯ"
         , NULLIF(123, 1234)  AS "�ٸ���� ���μ���ȯ"
         , NULLIF('A', 'B')       AS  "�ٸ���� ���μ���ȯ"
FROM DUA L;    

--�ھ����  : �Ķ���� �� NULL�� �ƴ� ù���� �Ķ���� ��ȯ
SELECT COALESCE (NULL, NULL, 'HELLO', NULL, 'WORLD')
FROM DUAL;
 
 --9    :   �񱳴��
 --'D'  :   ELSE
 SELECT DECODE (3
                      ,  10,  'A'
                      ,  9,   'B'
                      ,  8,    'C'
                      , 'D')
FROM DUAL;                        
 
 
SELECT PROD_LGU
      ,   SUBSTR(PROD_LGU, 1, 2) �յ��ڸ�
      ,   DECODE(SUBSTR(PROD_LGU, 1, 2)
                    , 'P1', '��ǻ��/���� ��ǰ'
                    , 'P2', '�Ƿ�'
                    , 'P3', '��ȭ'
                    , '��Ÿ')   ���
FROM PROD;                      
 
 --P.208
 --��ǰ�з�(PROD_LGU) ��  ���� �� ���ڰ�  'P1' �̸� 
--�ǸŰ�(PROD_SALE)�� 10%�λ��ϰ�
--'P2' �̸� �ǸŰ��� 15%�λ��ϰ�,  
--�������� ���� �ǸŰ��� 
--�˻��Ͻÿ� ? 
--(DECODE �Լ� ���, 
--Alias�� ��ǰ��(PROD_NAME), �ǸŰ�(PROD_SALE), �����ǸŰ� )
 
 SELECT PROD_NAME  ��ǰ��
,            PROD_SALE  �ǸŰ�
,           DECODE(substr(PROD_LGU, 1, 2)
                  ,   'P1', PROD_SALE * 1.1
                  ,   'P2', PROD_SALE *1.15
                  ,    PROD_SALE) �����ǸŰ�
FROM PROD;
 
 --��������翡���� 3���� ������(MEM_BIR) ȸ����
--������� ���ϸ����� 10% �λ����ִ� �̺�Ʈ��
--�����ϰ��� �Ѵ�. ������ 3���� �ƴ� ȸ����
--¦���� ��츸 5% �λ� ó���Ѵ�.
--�̸� ���� SQL�� �ۼ��Ͻÿ�.
--ALIAS : ȸ��ID, ȸ����, ���ϸ���, ���渶�ϸ���

  SELECT  MEM_ID  ȸ��ID
      ,       MEM_NAME  ȸ����
      ,       MEM_MILEAGE  ���ϸ���
      , DECODE(EXTRACT(MONTH  FROM MEM_BIR)
                            ,   3,  MEM_MILEAGE*1.1
                            , MOD(EXTRACT(MONTH  FROM MEM_BIR), 2), MEM_MILEAGE 
                            , MEM_MILEAGE * 1.05) ���渶�ϸ���
 FROM   MEMBER;
 
 --������ ��
  SELECT  MEM_ID  ȸ��ID
      ,       MEM_NAME  ȸ����
      ,       MEM_MILEAGE  ���ϸ���
      ,       DECODE(EXTRACT(MONTH  FROM MEM_BIR) 
                           ,   3,  MEM_MILEAGE*1.1                               
                           ,  DECODE(MOD(EXTRACT(MONTH  FROM MEM_BIR), 2)
                           ,  0 ,MEM_MILEAGE * 1.05
                           ,  MEM_MILEAGE)
                             )���渶�ϸ���
 FROM   MEMBER;
 
 --P.208
 --SIMPLE CASE EXPRESSION
 --
 SELECT CASE WHEN '��' = '��' THEN '�´�'
                    ELSE '�ƴϴ�'
                    END AS "RESULT"
FROM DUAL;                    
 
-- SEARCHED CASE EXPRESSION
SELECT CASE '��' WHEN  'öȣ' THEN '�ƴϴ�'
                            WHEN  '��' THEN '�ƴϴ�'
                            WHEN  '��' THEN '�´�'
                            ELSE '�𸣰ڴ�'
                            END RESULT
FROM DUAL;                            
 
 SELECT PROD_NAME ��ǰ, PROD_LGU �з�,
        CASE WHEN PROD_LGU = 'P101' THEN '��ǻ����ǰ'
                WHEN PROD_LGU = 'P102' THEN '������ǰ'
                WHEN PROD_LGU = 'P201' THEN '����ĳ���'
                WHEN PROD_LGU = 'P202' THEN '����ĳ���'
                 WHEN PROD_LGU = 'P301' THEN '������ȭ'
                WHEN PROD_LGU = 'P302' THEN 'ȭ��ǰ'
                WHEN PROD_LGU = 'P401' THEN '����/CD'
                 WHEN PROD_LGU = 'P402' THEN '����'
             WHEN PROD_LGU = 'P403' THEN '������'
             ELSE '�̵�Ϻз�'
             END "��ǰ�з�"
FROM PROD;             

--10���� �ʰ� ��ǰ�ǸŰ� ���ݴ븦 �˻��Ͻÿ�
SELECT PROD_NAME        AS "��ǰ"
      ,   PROD_PRICE      AS "�ǸŰ�"
      ,   CASE    WHEN (100000 - PROD_PRICE)>= 0 THEN '10���� �̸�'
                        WHEN (200000 - PROD_PRICE)>= 0 THEN '10������'
                        WHEN (300000 - PROD_PRICE)>= 0 THEN '20������'
                        WHEN (400000 - PROD_PRICE)>= 0 THEN '30������'
                        WHEN (500000 - PROD_PRICE)>= 0 THEN '40������'  
                        WHEN (600000 - PROD_PRICE)>= 0 THEN '50������'
                        WHEN (700000 - PROD_PRICE)>= 0 THEN '60������'
                        WHEN (800000 - PROD_PRICE)>= 0 THEN '70������'
                        WHEN (900000 - PROD_PRICE)>= 0 THEN '80������'
                        WHEN (1000000 - PROD_PRICE)>= 0 THEN '90������'
                        ELSE '100���� �̻�'
                        END "���ݴ�"
FROM PROD;                            
                    
--ȸ���������̺��� �ֹε�� ���ڸ�(7�ڸ� �� ù°�ڸ�)���� ���������� �˻��Ͻÿ�
--(CASE ���� ���, ALIAS�� ȸ����, �ֹε�Ϲ�ȣ(�ֹ�1-�ֹ�2), ����

SELECT  MEM_NAME ȸ����
      ,    MEM_REGNO1
      ||   MEM_REGNO2 �ֹε�Ϲ�ȣ
      ,   CASE WHEN substr(MEM_REGNO2,1,1)  IN(' 1' , '3') THEN '����'
                         WHEN substr(MEM_REGNO2,1,1)  IN(' 2' , '4') THEN '����'
                        ELSE '��Ÿ'  END "����"
   FROM MEMBER;
                     
SELECT  MEM_NAME ȸ����
      ,    MEM_REGNO1
      ||   MEM_REGNO2 �ֹε�Ϲ�ȣ
      CASE substr(MEM_REGNO2,1,1) WHEN '1' THEN '����'
                                                 WHEN '2' THEN '����'
                                                 WHEN '3' THEN '����'
                                                 WHEN '4' THEN '����'
                                                 ELSE '��Ÿ'                                
FROM MEMBER;
 
 --P.210
 -- Ʈ�����(Transaction)
 -- �����ͺ��̽��� �����ϱ� ���� ����Ǿ�� ��
 -- ������ ����. �������� SQL�� �����Ǿ� ����.
 -- ���ڼ� : All or Nothing. ��ü ���� �Ǵ� ��ü ���� �ȵ�.
 -- �ϰ��� : �����ͺ��̽��� �������� ������ ���ٸ� �����Ŀ��� ������ ����.
 -- ���� : ���� �� Ÿ Ʈ����ǿ� �������� ����� ������ �߻��ؼ��� �� ��
 -- ���Ӽ� : �����ϸ� ����� ���ӵ�
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
-- ������ COMMIT / ROLLBACK �������� ���ư� 
-- DDL�� �����ϸ� �ڵ�  COMMIT�� �� 

CREATE TABLE TEST2
AS 
SELECT * FROM TEST11;
ROLLBACK;

--LPROD ���̺� ���� -> LPROD2 ���̺� ����
--1) ��Ű��    :   �÷�, �ڷ���, ũ��, N.N�������
--2) ������
--��, P.K, FK�� ������ �ȵ�
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
 SET        LPROD_NM = '�̻�'
 WHERE  LPROD_GU = 'P302';
 --3)
 DELETE FROM LPROD2
 WHERE LPROD_GU = 'P403';
--������ ����� ���������� COMMIT�� ��
CREATE TABLE LPROD3
AS
SELECT * FROM LPROC;

 SELECT * FROM LPROD2;
 
 ROLLBACK;

--P.218
--SAVEPOINT : Ʈ����� �߰�����
--COMMIT : ��������� �����ͺ��̽��� �ݿ�
--Ʈ������� ����ʰ� ���ÿ�
--���ο� Ʈ������� ���۵�
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
-- ��Ÿ������? ������(���� ���̴� ������)�� ���� ������(�÷�, �ڷ���, ũ��, �������)
-- �����ͻ���? ��Ÿ������ ������ ����

--Dictionary ��(������ ���̺�, ����)���� 'ALL_'�� �����ϴ� ��� ���̺� ��ȸ
SELECT TABLE_NAME
          ,   COMMENTS
FROM    DICTIONARY
WHERE   TABLE_NAME LIKE 'ALL_%';

SELECT * FROM ALL_CONSTRAINTS;
SELECT * FROM ALL_USERS;
 
 --���� �α����� �����(����)�� ���� ��� ��ü ������ ���
 SELECT object_NAME
  ,          OBJECT_TYPE
  ,       CREATED
FROM ALL_OBJECTS
WHERE OWNER = 'PC12'
ORDER BY OBJECT_TYPE ASC;
 
 --�� ���̺� ��ü ���ڵ� ������ ���. (���̺��, ���ڵ� ��)
 SELECT TABLE_NAME ���̺��
      ,       NUM_ROWS "���ڵ� ��"
FROM USER_TABLES;        
 

 --USER_CONSTRAINTS,
 --USER_CONS_COLUMNS�� �÷� �󼼸� Ȯ���ϰ�
 --��ǰ ���̺��� ���������� ����Ͻÿ�?
 --(�÷���, �����, Ÿ��, ���೻��)
 SELECT B.CONSTRAINT_NAME �÷���
      ,   A.CONSTRAINT_NAME  �����
      ,   A.CONSTRAINT_TYPE Ÿ��
      ,   A.SEARCH_CONDITION ���೻��
FROM    USER_CONSTRAINTS A, USER_CONS_COLUMNS B
WHERE   A.TABLE_NAME = B.TABLE_NAME
AND     A.TABLE_NAME = 'BUYER';

--���̺��� ����
SELECT S1.TABLE_NAME AS �������̺��,
         COMMENTS AS �����̺��,
         TABLESPACE_NAME AS ���̺����̽���,
         NUM_ROWS AS ROW��,     --- analize �� �ؾ� ��Ȯ�� Row���� ��´�.
         LAST_ANALYZED AS  �����м�����,
         PARTITIONED AS ��Ƽ�ǿ���
FROM USER_TABLES S1,
        USER_TAB_COMMENTS S2
WHERE S1.TABLE_NAME = S2.TABLE_NAME       
  AND S2.TABLE_TYPE  = 'TABLE'    -- VIEW (��, ���̺� ���� SELECT 
  AND TABLESPACE_NAME IS NOT NULL --PLAN TABLE ���� ���� ����
ORDER BY  S1.TABLE_NAME;

--���̺�, �÷� ��� ����
SELECT A.TABLE_NAME AS TABLE_NAME,
   A.TAB_CMT AS ���̺���,
         A.COLUMN_NAME AS �÷���,
         B.POS AS PK,
         A.COL_CMT AS �÷�����,
         A.DATA_TYPE AS ����������,
         A.�����ͱ���,
         A.NULLABLE AS NULL����,
         A.COLUMN_ID AS �÷�����,
         A.DATA_DEFAULT AS �⺻��
FROM
(SELECT S1.TABLE_NAME,
   S3.COMMENTS AS TAB_CMT,
         S1.COLUMN_NAME,
         S2.COMMENTS AS COL_CMT,
         S1.DATA_TYPE,
         CASE WHEN S1.DATA_PRECISION IS NOT NULL THEN DATA_PRECISION||','||DATA_SCALE
         ELSE TO_CHAR(S1.DATA_LENGTH)
         END  AS �����ͱ���,
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
 --ȸ�� ���̵� �������� ���� ���Ǿ� INDEX�� ���
 --ROWID : ���� ������ȣ
 SELECT ROWID
          ,   MEM_ID
          ,   MEM_NAME
          ,   MEM_JOB
          ,   MEM_BIR
FROM MEMBER
WHERE MEM_ID = 'a001';

--P.229 
 --ȸ�� ������ �������� ���� ���Ǿ�
 --INDEX�� ���� -> �˻��ӵ� ����(B-TREE INDEX)
 CREATE INDEX IDX_MEMBER_BIR
 ON MEMBER(MEM_BIR);
 
 SELECT ROWID
      ,  MEM_ID
      ,   MEM_NAME
      ,   MEM_JOB
      ,   MEM_BIR
 FROM MEMBER
 WHERE MEM_BIR LIKE '75%';
 
--ȸ�����Ͽ��� �⵵�� �и��Ͽ�
--�ε����� ����(Function-based Index)

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
 
 --IDX_MEMBER_BIR_YEAR �ε����� REBUILD �Ͻÿ�?
 ALTER INDEX IDX_MEMBER_BIR_YEAR REBUILD;

--INDEX KEY Column ������ ���� Query�� ��� ���� 
SELECT BUY_DATE
      ,   BUY_PROD
      ,   BUY_QTY
FROM BUYPROD
WHERE   BUY_DATE - 10 = '2005-02-20';
--�籸��
SELECT BUY_DATE
      ,   BUY_PROD
      ,   BUY_QTY
FROM BUYPROD
WHERE   BUY_DATE = TO_DATE('2005-02-20') + 10;
 
 --P. 243
 --��ǰ���̺��� ��ǰ�ڵ�, ��ǰ��, �з����� ��ȸ
 
 --���� ���� ����
 --LPROD, PROD ����
 
-- ���� �� �ܰ� ��
--1) �� ���̺� ���̿� P.K, F.K ���踦 ã��
--2) ���谡 �ִٸ� FROM���� �� ���̺� ���� ����
--  �ڷ����� ũ�Ⱑ ����, ���� �����Ͱ� ����
--3) P.K�����Ϳ� F.K�����Ͱ� ���� ��쿡�� ����� ����
--4) �÷��� ����. FROM ���� ���̺�  ALIAS 

SELECT L.LPROD_GU
      ,   L.LPROD_NM
      ,   P.PROD_LGU
      ,   P.PROD_ID
      ,   P.PROD_NAME
FROM LPROD L,PROD P 
 WHERE  L.LPROD_GU= P.PROD_LGU;     --���� ����(3)
 -- ANSI ǥ��
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
 ON ( L.LPROD_GU = B.BUYER_LGU);  --ANSI ǥ��(INNER JOIN , ON)
 
 -- ���������� ���� ����? īƼ�� ���δ�Ʈ
 -- ���������� ������, EQUI JOIN, ��������, ��������
 SELECT M.MEM_ID
      ,   M.MEM_NAME
      ,   C.CART_NO
      ,   C.CART_PROD
      ,   C.CART_MEMBER
      ,   C.CART_QTY
 FROM MEMBER M, CART C
 WHERE M.MEM_ID = C.CART_MEMBER;
 --ANSI ǥ��
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
 --ANSI ǥ��
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
 --ANSI ǥ��
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
 --ANSI ǥ��
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
 -- ��ǰ���̺��� �ŷ�ó�� '�Ｚ����' �� �ڷ���
 --��ǰ�ڵ�, ��ǰ��, �ŷ�ó���� ��ȸ
 --EQUI JOIN
 
 SELECT P.PROD_ID ��ǰ�ڵ�
          ,   P.PROD_NAME ��ǰ��
          ,   B.BUYER_NAME �ŷ�ó��
 FROM BUYER B, PROD P
 WHERE B.BUYER_ID = P.PROD_BUYER
 AND    B.BUYER_NAME = '�Ｚ����';

 --ANSI ǥ��_P. 244 
 SELECT   P.PROD_ID ��ǰ�ڵ�
          ,   P.PROD_NAME ��ǰ��
          ,   B.BUYER_NAME �ŷ�ó��
 FROM   BUYER B INNER JOIN  PROD P ON( B.BUYER_ID = P.PROD_BUYER)
 WHERE     B.BUYER_NAME = '�Ｚ����';
 
 --P. 244
 -- ��ǰ �з��� ������ǰ(P.102)�� ��ǰ�� ��ǰ�ڵ�, ��ǰ��
 --�з���, �ŷ�ó���� ��ȸ
 --EQUI JOIN
 
 SELECT P.PROD_ID ��ǰ�ڵ�
          ,   P.PROD_NAME ��ǰ��
          ,   L.LPROD_NM �з���
          ,   B.BUYER_NAME �ŷ�ó��
 FROM PROD P, BUYER B, LPROD L
 WHERE BUYER_ID = PROD_BUYER
 AND    P.PROD_LGU = L.LPROD_GU
 AND    L.LPROD_NM = '������ǰ';
 
 --ANSI
  SELECT P.PROD_ID ��ǰ�ڵ�
          ,   P.PROD_NAME ��ǰ��
          ,   L.LPROD_NM �з���
          ,   B.BUYER_NAME �ŷ�ó��
 FROM PROD P INNER JOIN BUYER B ON (B.BUYER_ID = P.PROD_BUYER)
                         INNER JOIN LPROD L ON( P.PROD_LGU = L.LPROD_GU)
 WHERE   L.LPROD_NM = '������ǰ';
 
 
 
 --P.282
 --AVG(�÷�)
 SELECT PROD_COST
 FROM PROD
 ORDER BY 1;
 
 SELECT AVG(DISTINCT PROD_COST) �ߺ��Ȱ�������
      ,   AVG(ALL PROD_COST) DEFALT��簪
      ,   AVG(PROD_COST) ���԰����
FROM PROD;
 
 --��ǰ���̺��� ��ǰ�з��� ���԰��� ��հ�
 SELECT PROD_LGU
          , ROUND(AVG(NVL(PROD_COST,0)),2)
 FROM    PROD
 GROUP BY PROD_LGU;
 
 --��ǰ���̺��� �� �ǸŰ��� ��� ���� ���Ͻÿ�
 --ALIAS ��ǰ ���Ǹ� ���� ���
 SELECT  AVG(NVL(PROD_SALE,0)) ��ǰ���ǸŰ����
FROM PROD;        
 
 
 --��ǰ���̺��� ��ǰ�з��� ��հ��� ���Ͻÿ�
 --ALIAS�� ��ǰ�з�, ��ǰ�з��� �ǸŰ��� ���
 
 SELECT PROD_LGU ��ǰ�з�
 ,        ROUND  (AVG(NVL(PROD_SALE,0)),2) ��ǰ�з����ǸŰ����
 FROM PROD
 GROUP BY PROD_LGU;
 
--P.282
--COUNT : �ڷ��
SELECT PROD_COST FROM PROD
ORDER BY PROD_COST ASC;

SELECT COUNT(DISTINCT PROD_COST)
      ,   COUNT(ALL PROD_COST)
      ,   COUNT(PROD_COST)
      ,   COUNT(*)
FROM    PROD;        
 
 --�ŷ�ó���̺��� �����(BUYER_CHARGER)�� �÷����� �Ͽ� COUNT�Ͻÿ�
 --ALIAS�� �ڷ��(DISTINCT), �ڷ��, �ڷ��(*)
 SELECT COUNT(DISTINCT BUYER_CHARGER)  "�ڷ��(DISTINCT)"
      ,   COUNT(ALL BUYER_CHARGER)  �ڷ��
      ,   COUNT(*)  "�ڷ��(*)"
FROM    BUYER;    

 --ȸ�����̺��� ����������� COUNT �����Ͻÿ�
 --ALIAS ���������
 SELECT COUNT(DISTINCT MEM_LIKE) ���������
FROM MEMBER;  
 
 --ȸ�����̺��� ��̺� COUNT�����Ͻÿ�
 --ALIAS�� ��� �ڷ�� �ڷ��*
 SELECT MEM_LIKE  ���
      ,   COUNT(MEM_ID) �ڷ��
      ,   COUNT(*)  "�ڷ��(*)"
 FROM MEMBER
 GROUP BY MEM_LIKE;
 
 --ȸ�����̺��� ������������ COUNT�����Ͻÿ�
 --ALIAS�� ����������
 SELECT COUNT(DISTINCT MEM_JOB)����������
 FROM MEMBER;
 
 
 --ȸ�����̺�(MEMBER)�� ������(MEM_JOB)
 --COUNT�����Ͻÿ�
  --ALIAS�� ���� �ڷ�� �ڷ��*
 SELECT    MEM_JOB ����
     ,   COUNT(MEM_ID) �ο���
     ,    COUNT(*)  "�ڷ��(*)"
 FROM MEMBER
 GROUP BY MEM_JOB;
 
 
 --��ٱ������̺��� ȸ��(CART_MEMBER)�� COUNT�����Ͻÿ�
  --ALIAS�� ȸ��ID, ���ż�(DISTINCT), ���ż�, ���ż�(*)
SELECT CART_MEMBER  ȸ��ID
      ,  COUNT(DISTINCT CART_PROD) ����ȸ��
      ,  COUNT(CART_PROD) ����ȸ��
      , COUNT(*)
FROM CART 
GROUP BY CART_MEMBER;
 
 --P.283
 --��ǰ�� �ְ��ǸŰ��ݰ� �����ǸŰ���
 
 SELECT MAX(PROD_SALE) �ְ��ǸŰ�
  ,       MIN( PROD_SALE) �����ǸŰ�
FROM PROD;    
 
 --��ǰ �� �ŷ�ó�� �ְ���԰��ݰ� �������԰���
 -- SELECT ������ �����Լ� �̿��� �÷�����
 --GROUP BY ���� ����Ѵ�.
 SELECT PROD_BUYER   �ŷ�ó
      ,   MAX(PROD_COST)   �ְ���԰�
      ,   MIN(PROD_COST)    �������԰�
FROM PROD
GROUP BY PROD_BUYER
ORDER BY PROD_BUYER;

--R���̺� S���̺��� ���� OUTER JOIN ����
--1. S���̺� ���� �� �⺻Ű�� C
--      �÷� : C, D, E
CREATE TABLE S(
    C VARCHAR2(10),
    D VARCHAR2(10),
    E VARCHAR2(10),
    CONSTRAINT PK_S PRIMARY KEY(C)
    );
    
-- 2. R���̺� ���� �� �⺻Ű�� A,
--�÷� : A, B, C
CREATE TABLE R(
    A VARCHAR2(10),
    B VARCHAR2(10),
    C VARCHAR2(10),
    CONSTRAINT PK_R PRIMARY KEY(A)
    );

-- 3. R���̺� a1, b1, c1�� a2, b2, c2 ������ �Է�
INSERT INTO R(A, B, C) VALUES('a1', 'b1', 'c1');
INSERT INTO R(A, B, C) VALUES('a2', 'b2', 'c2');
--EQUI JOIN = SIMPLE JOIN, �����, ��������
select *
from r, s
where S.C = R.C; 

--ANSI  ǥ�� (INNER JOIN)

SELECT *
FROM R INNER JOIN S ON ( S.C = R.C);

-- LEFT OUTER JOIN 
SELECT R.A, R.b, R.C
      ,   S.C, S.D, S.E
FROM R, S
WHERE  R.C= S.C(+); 

--ANSI  ǥ�� (LEFT OUTER JOIN)

SELECT R.A, R.b, R.C
      ,   S.C, S.D, S.E
FROM R LEFT OUTER JOIN S ON ( S.C = R.C);

-- RIGHT OUTER JOIN 
SELECT R.A, R.b, R.C
      ,   S.C, S.D, S.E
FROM R, S
WHERE R.C(+) = S.C ; 
--ANSI  ǥ�� ( RIGHT OUTER JOIN)
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
--ANSI  ǥ�� (FULL OUTER JOIN)
SELECT R.A, R.B, R.C
      ,   S.C, S.D, S.E
from R FULL OUTER JOIN S ON(R.C= S.C);


--P.246
--��ǰ�� 2005�� 1�� �԰������ �˻� ��ȸ
--ALIAS�� ��ǰ�ڵ�, ��ǰ��, �԰����
--EQUI JOIN
SELECT  P.PROD_NAME ��ǰ��
      ,   B.BUY_PROD ��ǰ�ڵ�
      ,   SUM(B.BUY_QTY)�԰����
FROM PROD P, BUYPROD  B
WHERE PROD_ID= BUY_PROD(+)
AND B.BUY_DATE(+) LIKE '05/01%'
GROUP BY B.BUY_PROD, P.PROD_NAME;
SELECT PROD_ID, PROD_NAME FROM PROD;
--ANSI ǥ��(LEFT OUTER JOIN)
SELECT  P.PROD_NAME ��ǰ��
      ,   B.BUY_PROD ��ǰ�ڵ�
      ,   SUM(B.BUY_QTY)�԰����
FROM PROD P LEFT OUTER JOIN BUYPROD  B
ON (PROD_ID= BUY_PROD AND B.BUY_DATE(+) LIKE '05/01%')
GROUP BY B.BUY_PROD, P.PROD_NAME;

--P.
--HAVING : 
--���谡 ������ �� �� ��� �����Լ��� ���ǰ� ��
--GROUP BY �� �ڿ� ��
--SELECT���� ���� �����̶�� HAVING���� �������� ��� ����!

-- 2005�⵵ ���� ���� ��Ȳ�� �˻��Ͻÿ� ?
--(Alias�� ���Կ�, ���Լ���, ���Աݾ�(���Լ���*�������̺��� ���԰�))
--��, ���Աݾ��� 20000000 �̻��� �����͸� ����غ���

SELECT EXTRACT( MONTH FROM BUY_DATE) ���Կ�
      ,  SUM( BUY_QTY) ���Լ���
      ,  SUM( BUY_COST * BUY_QTY) ���Աݾ�
FROM BUYPROD
WHERE EXTRACT (YEAR FROM BUY_DATE) = 2005
GROUP BY EXTRACT( MONTH FROM BUY_DATE)
HAVING    SUM( BUY_COST * BUY_QTY) >= 20000000;


-- ȸ��ID(CART_MEMBER), ȸ����
--�ֹ���ȣ(CART_NO)
--, ��ǰ�ڵ�(CART_PROD), ����(CART_QTY)
--��, �������� �̿�
--SCALAR ��������
SELECT  CART_MEMBER ȸ��ID
      ,   (SELECT MEM_NAME FROM MEMBER WHERE MEM_ID = CART_MEMBER) ȸ����
      ,   CART_NO �ֹ���ȣ
      ,   CART_PROD ��ǰ�ڵ�
      ,   CART_QTY ����
FROM    CART;

--NESTED ��������1
--NESTED �������� : WHERE���� ���� ��������
-- ��ǰ�з��� ��ǻ����ǰ�� ��ǰ�� ����Ʈ�� ����ϱ�
-- ALIAS : ��ǰ�ڵ�, ��ǰ��, ��ǰ�з��ڵ�
SELECT   PROD_ID  ��ǰ�ڵ�
      ,   PROD_NAME  ��ǰ��
      ,   PROD_LGU  ��ǰ�з��ڵ�
FROM PROD
WHERE PROD_LGU = (SELECT LPROD_GU FROM LPROD WHERE LPROD_NM = '��ǻ����ǰ');

--P.256
-- ��� �ŷ�ó�� 2005�⵵ �ŷ�ó�� ���Աݾ�(���԰� X ����) �հ�
-- Alias :  �ŷ�ó�ڵ�, �ŷ�ó��, ���Աݾ��հ�
SELECT   B.BUYER_ID �ŷ�ó�ڵ�
      ,   B.BUYER_NAME  �ŷ�ó��
      ,   SUM(BP.BUY_COST * BP.BUY_QTY)  ���Աݾ��հ�
FROM    BUYER B, PROD P, BUYPROD BP
WHERE  B.BUYER_ID = P.PROD_BUYER(+) -- LEFT OUTER JOIN
AND     P.PROD_ID = BP.BUY_PROD (+) 
AND     EXTRACT(YEAR FROM BP.BUY_DATE(+)) = 2005
GROUP BY  B.BUYER_ID, B.BUYER_NAME;
--ANSI ǥ��
SELECT   B.BUYER_ID �ŷ�ó�ڵ�
      ,   B.BUYER_NAME  �ŷ�ó��
      ,   SUM(BP.BUY_COST * BP.BUY_QTY)  ���Աݾ��հ�
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
--ANSI ǥ��
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
--(���) �ŷ�ó�� 2005�⵵ �ŷ�ó�� ����ݾ�(PROD_SALE * CART_QTY) �հ�
--Alias : �ŷ�ó�ڵ�, �ŷ�ó��, ����ݾ�(PROD_SALE * CART_QTY)
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

--��ٱ��� TABLE���� ȸ���� �ְ��� ���ż����� ���� �ڷ��� ȸ��,
--�ֹ���ȣ, ��ǰ, ������ ���� ��� �˻��Ͻÿ�
--Alias�� ȸ��, �ֹ���ȣ, ��ǰ, ����
--������� ��������(CORRELATED SUBQUERY)    :    MAIN�� Ư�� �÷���
-- SUB�� �������� ���ǰ�, SUB�� ����� �ٽ� MAIN�� �������� ����
SELECT  A.CART_MEMBER ȸ��
      ,   A.CART_NO  �ֹ���ȣ
      ,   A.CART_PROD ��ǰ
      ,   A.CART_QTY  ����
FROM    CART A
WHERE   A.CART_QTY = (
            SELECT MAX(B.CART_QTY)
            FROM CART B
            WHERE B.CART_MEMBER = A.CART_MEMBER  --�ڡڡڡڡڡ�
    );        


--�԰����̺�(BUYPROD)���� "��ǰ��"
--�ְ� ���Լ����� ���� �ڷ���
-- �԰�����, ��ǰ�ڵ�, ���Լ���, ���Դܰ��� �˻��Ͻÿ�
SELECT A.BUY_DATE �԰�����
      ,   A.BUY_PROD  ��ǰ�ڵ�
      ,   A.BUY_QTY  ���Լ���
      ,   A.BUY_COST  ���Դܰ�
FROM    BUYPROD A
WHERE  A.BUY_QTY = (
        SELECT MAX(B.BUY_PROD )
        FROM   BUYPROD B
        WHERE B.BUY_PROD =  A.BUY_PROD;        --�ڡڡڡڡڡ�

--������輭������ ����3)
-- ��ٱ���Table���� ���ں� �ְ��� ���ż����� ���� �ڷ��� ȸ��, 
--�ֹ���ȣ, ��ǰ, ������ ���� ��� �˻��Ͻÿ� ?
--(Alias�� ȸ��, ����, ��ǰ, ����)
SELECT A.CART_MEMBER  ȸ��
      ,  SUBSTR(A.CART_NO, 1, 8)  ����
      ,   A.CART_PROD  ��ǰ
      ,   A.CART_QTY  ����
FROM CART A
WHERE A.CART_QTY = (
            SELECT MAX(B.CART_QTY)
            FROM CART B
            WHERE SUBSTR(B.CART_NO, 1, 8) = SUBSTR(A.CART_NO, 1, 8)
);

--P.260
-- ������ ��������, �����÷� ���������� ��밡��
-- =, !=, <>, <, >, <=,>= ������ ���
SELECT LPROD_NM
FROM LPROD
WHERE LPROD_GU = 'P101';

-- ������ ���������� ��밡��
--IN, ANY, ALL, EXISTS ������ ���
SELECT LPROD_NM
FROM LPROD
WHERE LPROD_GU LIKE 'P1%';

--�����÷� ���������� ��밡�� 
SELECT LPROD_ID, LPROD_GU, LPROD_NM
FROM LPROD
WHERE LPROD_GU = 'P101';

--P.230
-- ������ '������'�� ������� ���ϸ����� �˻��Ͽ�
--�ּ��� �׵� �� ��� �ѻ�����ٴ� ���ϸ����� ū ������� ����Ͻÿ�
-- ��, ������ '������'�� ����� �����ϰ� �˻��Ͻÿ�
--ALIAS�� ȸ����, ����, ���ϸ���
-- ������ '������'�� ������� ���ϸ���?
--ANY : OR(�Ǵ�)
SELECT A.MEM_NAME, A.MEM_JOB, A.MEM_MILEAGE
FROM MEMBER A
WHERE   A.MEM_MILEAGE > ANY(
SELECT B.MEM_MILEAGE
FROM MEMBER B
WHERE B.MEM_JOB= '������'
);
--ALL   :   AND 
SELECT A.MEM_NAME, A.MEM_JOB, A.MEM_MILEAGE
FROM MEMBER A
WHERE   A.MEM_MILEAGE > ALL(
SELECT B.MEM_MILEAGE
FROM MEMBER B
WHERE B.MEM_JOB= '������'
);

--����
--a001 ȸ���� ���Լ����� �˻��Ͽ�
--�ּ��� a001 ȸ�� ���ٴ� ���Լ�����(AND�� ����)
--ū �ֹ������� ����Ͻÿ�.
--��, a001 ȸ���� �����ϰ� �˻��Ͻÿ�.
--(ALIAS�� �ֹ���ȣ, ��ǰ�ڵ�, ȸ����!!!, ���Լ���)

SELECT A.CART_NO �ֹ���ȣ
   , A.CART_PROD ��ǰ�ڵ�
   , (SELECT C.MEM_NAME FROM MEMBER C WHERE C.MEM_ID = A.CART_MEMBER) ȸ����
   , M.MEM_NAME ȸ����2
   , A.CART_QTY ���Լ���
FROM   CART A, MEMBER M
WHERE  A.CART_MEMBER = M.MEM_ID
AND    A.CART_MEMBER <> 'a001'
AND    A.CART_QTY > ALL(
        SELECT DISTINCT B.CART_QTY FROM CART B WHERE B.CART_MEMBER = 'a001'
    );


--P.261
-- A����
SELECT MEM_NAME
      ,   MEM_JOB
      ,   MEM_MILEAGE
FROM    MEMBER
WHERE   MEM_MILEAGE > 4000
--B����
UNION   --UNION : ������, �ߺ� �Ȱ��� 1ȸ ���, �ڵ�����
SELECT MEM_NAME
      ,   MEM_JOB
      ,   MEM_MILEAGE
FROM    MEMBER
WHERE   MEM_JOB = '�ڿ���';


SELECT MEM_NAME
      ,   MEM_JOB
      ,   MEM_MILEAGE
FROM    MEMBER
WHERE   MEM_MILEAGE > 4000
UNION ALL -- ������, �ߺ���� ���, �ڵ����ľȵ�
SELECT MEM_NAME
      ,   MEM_JOB
      ,   MEM_MILEAGE
FROM    MEMBER
WHERE   MEM_JOB = '�ڿ���';

SELECT MEM_NAME
      ,   MEM_JOB
      ,   MEM_MILEAGE
FROM    MEMBER
WHERE   MEM_MILEAGE > 4000
INTERSECT -- ������, �ڵ����ľȵ�
SELECT MEM_NAME
      ,   MEM_JOB
      ,   MEM_MILEAGE
FROM    MEMBER
WHERE   MEM_JOB = '�ڿ���';


SELECT MEM_NAME
      ,   MEM_JOB
      ,   MEM_MILEAGE
FROM    MEMBER
WHERE   MEM_MILEAGE > 4000
MINUS -- ������, �ڵ����ľȵ�
SELECT MEM_NAME
      ,   MEM_JOB
      ,   MEM_MILEAGE
FROM    MEMBER
WHERE   MEM_JOB = '�ڿ���';

--P.264
--SET(����)�� ����� �� �ִ���
--1. �÷��� ���� ����, 2. �����Ǵ� �ڷ����� ����
--A) 2005�⵵ 4���� �Ǹŵ� ��ǰ
SELECT DISTINCT A.CART_PROD �ǸŻ�ǰ
      ,   P.PROD_NAME  ��ǰ��
      ,   P.PROD_SALE
FROM    CART A, PROD P
WHERE   A.CART_PROD = P.PROD_ID
AND SUBSTR(A.CART_NO, 1,8) BETWEEN '20050401' AND '20050430'
AND EXISTS(
--INTERSECT
--B) 2005�⵵ 6���� �Ǹŵ� ��ǰ
SELECT DISTINCT C.CART_PROD �ǸŻ�ǰ
      ,   P.PROD_NAME  ��ǰ��
FROM    CART C, PROD P
WHERE   C.CART_PROD = P.PROD_ID
AND     C.CART_NO LIKE '200506%'
AND     C.CART_PROD = A.CART_PROD  --�ڡڡڡڡڿ���� �߿��� ����Ʈ
);

--EXISTS ���� ����
-- A ����
SELECT A.MEM_ID
      ,   A.MEM_NAME
      ,   A.MEM_MILEAGE
FROM    MEMBER A
WHERE   A.MEM_MILEAGE > 1000
AND     EXISTS (
-- B����
SELECT 1
FROM    MEMBER B
WHERE   B.MEM_JOB = '�л�'
AND     B.MEM_ID = A.MEM_ID --�ڡڡڡڡڿ���� �߿��� ����Ʈ
);

--P.265
--2005�⵵ ���űݾ� 2õ�� �̻� ��������� �����Ͽ� 
--�˻��Ͻÿ� ?
--(Alias�� ȸ��ID, ȸ����, '�������)
--(���űݾ� : SUM(CART.CART_QTY * PROD.PROD_SALE))
--A���̺�

SELECT A.MEM_ID ȸ��ID
   , A.MEM_NAME ȸ����
   , '�����' �����
FROM   MEMBER A
WHERE EXISTS(
        --2005�⵵ ���űݾ� 2õ�� �̻� �����
        SELECT  M.MEM_ID
              ,  SUM( C.CART_QTY * P.PROD_SALE)  --1�̶�� �ᵵ �������
        FROM   MEMBER M, CART C, PROD P
        WHERE M.MEM_ID = C.CART_MEMBER
        AND     C.CART_PROD = P.PROD_ID
        AND     C.CART_NO LIKE '2005%'
        GROUP BY  M.MEM_ID
        HAVING  SUM( C.CART_QTY * P.PROD_SALE)>=20000000
        AND M.MEM_ID = A.MEM_ID --�ڡڡڡڡڿ���� �߿��� ����Ʈ
    );

--EXISTS ����2)
--2005�⵵ ���Աݾ� 1õ���� �̻� ����ŷ�ó�� �����Ͽ� �˻��Ͻÿ�
--ALIAS �� �ŷ�ó�ڵ�, �ŷ�ó��, '����ŷ�ó'
--���űݾ� (SUM(BUYPROD.BUY_QTY * BUYPROD.BUY_COST)

SELECT A.BUYER_ID
      ,   A.BUYER_NAME
      ,   '����ŷ�ó'
FROM    BUYER A 
WHERE EXISTS(

SELECT  P.PROD_BUYER 
      ,   SUM( BP.BUY_QTY * BP.BUY_COST)
FROM    PROD P,  BUYPROD BP
WHERE  P.PROD_ID = BP.BUY_PROD
AND     BP.BUY_DATE  LIKE '05%'
AND P.PROD_BUYER = A.BUYER_ID --�ڡڡڡڡڿ���� �߿��� ����Ʈ
GROUP BY  P.PROD_BUYER
HAVING SUM( BP.BUY_QTY * BP.BUY_COST) >= 10000000
);

 --2005�⵵ ��ǰ�� ����, ������Ȳ�� ��ȸ(UNION�� ���)
 -- ���, �ϴ��� �ʵ尳��/ �̸�/ ������ ������ �����ؾ� ��
 --���� ��ǰ�� ��
 
 SELECT TO_CHAR(BUY_DATE, 'YYYY/MM/DD') ����
      ,   PROD.PROD_NAME ��ǰ��
      ,   BUYPROD.BUY_QTY    ����
      ,   '����'      ����
FROM BUYPROD, PROD 
WHERE BUY_PROD = PROD_ID
AND BUY_DATE BETWEEN '2005-01-01' AND '2005-12-31'
UNION
SELECT TO_CHAR(TO_DATE(SUBSTR(CART_NO,1,8),'YYYYMMDD'),'YYYY/MM/DD')   ����
      , PROD_NAME ��ǰ��
      , CART_QTY ����
         '����'  ����
FROM  CART , PROD 
WHERE  CART_PROD = PROD_ID
AND CART_NO LIKE '2005%'
ORDER BY 1, ��ǰ��;
 
-- P.267
-- ����� ����
-- RANK( ) : ���� ��� �Լ�
--DENSE_RANK( ) :  ���� ��� �Լ�(���� ���ϰ��� �ϳ��� �����Ͽ� ���� �ο�)
 -- ���� �ο�
 SELECT RANK('c001')
            WITHIN GROUP(ORDER BY CART_MEMBER) RANK
      ,   DENSE_RANK('c001')
            WITHIN GROUP(ORDER BY CART_MEMBER) DENSE_RANK
 FROM CART;
 
 SELECT CART_MEMBER
 FROM CART
 ORDER BY 1;
 
 --�м��� ����
 -- ��ٱ��� (CART) ���̺��� ȸ������ ȸ�����̵��
 -- ���ż�, ���ż� ������ ���
  SELECT CART_QTY FROM CART ORDER BY CART_QTY DESC;
  SELECT CART_MEMBER
      ,    CART_QTY
      ,   RANK() OVER(ORDER BY CART_QTY DESC) AS RANK
      ,   DENSE_RANK() OVER(ORDER BY CART_QTY DESC) AS RANK_DENSE
FROM    CART;        
 
 --P.268
 -- ROWNUM : ����Ŭ ���������� ó���ϱ� ���� 
 --                 �� ���ڵ忡 ���� �Ϸù�ȣ
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
--ROWID : ���̺��� Ư�� ���ڵ�� �����ϰ� �����ϱ� ����
--          ������ �ּҰ�. �����ͺ��̽� ������ ������ ��(�߾Ⱦ�)
SELECT LPROD_GU
      ,   LPROD_NM
      ,   ROWID
FROM    LPROD
ORDER BY 3 ASC;
 
-- P.270
-- RATIO_TO_REPORT : ��ü��� �ش� ROW�� ����
--                          �����ϴ� ����
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

 --a001 ȸ���� ������ ��ǰ�� ������ Ȱ���Ͽ�
 --���Ű���(CART_QTY) ��� �ش� ���Ű��� ����
 --�����ϴ� ������ ���ϱ�
 --ALIAS : ȸ��ID, ��ǰ�ڵ�, ���ż�, ��������
SELECT  CART_MEMBER ȸ��ID
      ,   CART_PROD ��ǰ�ڵ�
      ,   CART_QTY ���ż�
      ,   ROUND(RATIO_TO_REPORT(CART_QTY) OVER() * 100, 2 ) ��������
FROM CART
WHERE CART_MEMBER = 'a001';
 
 --P. 270
 --ROLLUP : �Ұ�
 -- ��ǰ�з���, �ŷ�ó��, �԰���� �԰����� ���� ���غ���
 --ALIAS : PROD_LGU, PROD_BUYER, PROD_ID, IN_AMT, SUM_COST
 
 SELECT P.PROD_LGU
      ,   P.PROD_BUYER
      ,   COUNT(BP.BUY_PROD) IN_AMT
      ,  SUM(BP.BUY_COST) SUM_COST
FROM    PROD P, BUYPROD BP
WHERE   P.PROD_ID = BP.BUY_PROD
GROUP BY ROLLUP (P.PROD_LGU,  P.PROD_BUYER);

 --ROLLUP �� UNION ALL �� �ٲ㺸��
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
 
 --CUBE : ��� �Ұ�
SELECT P.PROD_LGU
      ,   P.PROD_BUYER
      ,   COUNT(BP.BUY_PROD) IN_AMT
      ,  SUM(BP.BUY_COST) SUM_COST
FROM    PROD P, BUYPROD BP
WHERE   P.PROD_ID = BP.BUY_PROD
GROUP BY CUBE (P.PROD_LGU,  P.PROD_BUYER);
 
 --CUBE -> UNION ALL�� �ٲ㺸��
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
 -- ������ ���
 -- GROUPING SET

 SELECT MEM_JOB
   ,  MEM_LIKE
   ,  COUNT(*)
FROM MEMBER
GROUP BY GROUPING SETS (MEM_JOB, MEM_LIKE);
 
-- P.277
SELECT  LPROD_GU
  ,   LPROD_NM
  ,   LAG(LPROD_GU) OVER (ORDER BY LPROD_GU ASC) ����������
  ,   LEAD(LPROD_GU) OVER (ORDER BY LPROD_GU ASC) ����������
FROM    LPROD;        

--295
/
SET SERVEROUTPUT ON;
/
DECLARE
v_i     NUMBER(9,2) :=123456.78;
v_STR   VARCHAR2(20) := 'ȫ�浿';
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
v_name := 'ȫ�浿';
--  DBMS_OUTPUT.ENABLE;
    DBMS_OUTPUT.PUT_LINE('v_i:' ||v_i);
    DBMS_OUTPUT.PUT_LINE('v_name:' ||v_name);
    DBMS_OUTPUT.PUT_LINE('c_pi:' ||c_pi);
    DBMS_OUTPUT.PUT_LINE('v_date:' ||v_date);
END;
/

--P.296
--������ TRUE�̸� ���� ������ �����ϰ�,
--������ FALSE�̸� ���õ� ������ ����Ѵ�.
--ELSIF���� ���� ���� �����ϳ�, ELSE���� �� ���� �����ϴ�.
 
 DECLARE
 V_NUM NUMBER := 37;
 BEGIN
 --DBMS_OUTPUT.ENABLE;
 IF MOD(V_NUM, 2) = 0 THEN
    DBMS_OUTPUT.PUT_LINE(V_NUM || '�� ¦��');
 ELSE
    DBMS_OUTPUT.PUT_LINE(V_NUM || '�� Ȧ��');
 END IF;
END;
/
 --P.253
 --���ǿ� ���� ���� ELSIF
DECLARE
    V_NUM NUMBER := 77;
BEGIN 
    IF V_NUM > 90 THEN
     DBMS_OUTPUT.PUT_LINE('��');
    ELSIF V_NUM > 80 THEN
     DBMS_OUTPUT.PUT_LINE('��');
    ELSIF V_NUM > 70 THEN
     DBMS_OUTPUT.PUT_LINE('��');
    ELSE
     DBMS_OUTPUT.PUT_LINE('�й��սô�');
    END IF;
END;
/
 
 DECLARE
-- ������ ���� : SCALAR(�Ϲ�), REFERENCE(����), COMPOSITE(�迭), BIND(���ε� IN/OUT)
-- ��ǰ���̺��� �ǸŰ� �÷��� �ڷ��� �� ũ�⸦ ����
 V_AVG_SALE PROD.PROD_SALE%TYPE; -- NUMBER(10) -- (REFERENCES ����)
 V_SALE NUMBER :=500000;         -- (SCLAR ����)
 BEGIN
    --269574.32
    SELECT AVG(PROD_SALE) INTO V_AVG_SALE
    FROM    PROD;
    IF V_SALE < V_AVG_SALE THEN
        DBMS_OUTPUT.PUT_LINE('��� �ܰ��� 500000 �ʰ��Դϴ�.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('��� �ܰ��� 500000 �����Դϴ�.');
    END IF;
END;
/
--P.297
--ȸ�����̺��� ���̵� 'e001' �� ȸ����  
--���ϸ����� 5000�� ������ 'VIP ȸ��' 
--�׷��� �ʴٸ� '�Ϲ�ȸ��'���� 
--����Ͻÿ�. (ȸ���̸�, ���ϸ��� ����)  
DECLARE 
--SCALAR ����
V_MILEAGE  NUMBER;
BEGIN 
    SELECT MEM_MILEAGE INTO V_MILEAGE
    FROM MEMBER WHERE MEM_ID = 'e001';
     IF V_MILEAGE > 5000 THEN
        DBMS_OUTPUT.PUT_LINE('VIP ȸ��');
     ELSE
        DBMS_OUTPUT.PUT_LINE('�Ϲ�ȸ��');
     END IF;
END;
/ 

--P.297
--CASE�� : SQL���� ����ϴ� CASE���� ������
--         �������� END CASE�� �����ٴ� ����
DECLARE
    V_NUM NUMBER :=77;
BEGIN
    V_NUM := TRUNC(V_NUM / 10);
--SIMPLE CASE EXPRESSION    
    CASE V_NUM
        WHEN 10 THEN
            DBMS_OUTPUT.PUT_LINE('��'||'('|| V_NUM ||')');
        WHEN 9 THEN
            DBMS_OUTPUT.PUT_LINE('��'||'('|| V_NUM ||')');
        WHEN 8 THEN
            DBMS_OUTPUT.PUT_LINE('��'||'('|| V_NUM ||')');
        WHEN 7 THEN
            DBMS_OUTPUT.PUT_LINE('��'||'('|| V_NUM||')');
        ELSE
            DBMS_OUTPUT.PUT_LINE('�й��սô�.');
    END CASE;
END;
/

--��ǰ�з��� ȭ��ǰ�� ��ǰ�� ����ǸŰ���
--���� �� ����ǸŰ��� 3,000�� �̸��̸� 
--�δ�, 3,000�� �̻� ~ 6,000�� �̸��̸� ����,
--6,000�� �̻� ~ 9,000�� �̸��̸� ��δ�,
--9,000�� �̻��̸� �ʹ���δٸ� ����ϱ�
--��, CASE ��(SEARCHED CASE EXPRESSION) ����Ͽ� ó���ϱ�
--������� : ȭ��ǰ�� ����ǸŰ��� 5000���̰� �����̴�.
 
DECLARE
V_AVG_SALE NUMBER;
BEGIN
SELECT ROUND(AVG(NVL(PROD_SALE, 0)), 2) INTO V_AVG_SALE
FROM PROD 
WHERE PROD_LGU = (SELECT LPROD_GU FROM LPROD WHERE LPROD_NM = 'ȭ��ǰ');

    CASE WHEN V_AVG_SALE < 3000 THEN 
            DBMS_OUTPUT.PUT_LINE('ȭ��ǰ�� ����ǸŰ���' ||V_AVG_SALE || '�̰� �δ�');
         WHEN V_AVG_SALE >= 3000 AND V_AVG_SALE < 6000 THEN
            DBMS_OUTPUT.PUT_LINE('ȭ��ǰ�� ����ǸŰ���' ||V_AVG_SALE || '�̰� ����');
         WHEN V_AVG_SALE >= 6000 AND V_AVG_SALE < 9000 THEN
            DBMS_OUTPUT.PUT_LINE('ȭ��ǰ�� ����ǸŰ���' ||V_AVG_SALE || '�̰� ��δ�');         
        WHEN V_AVG_SALE >= 9000 THEN
            DBMS_OUTPUT.PUT_LINE('ȭ��ǰ�� ����ǸŰ���' ||V_AVG_SALE || '�̰� �ʹ� ��δ�');         
        ELSE
             DBMS_OUTPUT.PUT_LINE('��Ÿ');         
   END CASE;
END;
/

--����ġ ��ü�� ������ �˻��Ͽ�
--������ ���� ����ϱ�
--�뱸, �λ� : �泲
--���� : ��û
--����, ��õ : ������
--��Ÿ : ��Ÿ
--��, CASE�� ����ϱ�
/
DECLARE
V_ADD VARCHAR2(60);
BEGIN
SELECT SUBSTR(BUYER_ADD1, 1, 2) INTO V_ADD FROM BUYER 
WHERE BUYER_NAME = '����ġ';
    CASE WHEN V_ADD IN( '�뱸', '�λ�') THEN
          DBMS_OUTPUT.PUT_LINE('�뱸, �λ� : �泲');
        WHEN V_ADD = '����' THEN
          DBMS_OUTPUT.PUT_LINE('���� : ��û');
        WHEN V_ADD IN ( '����', '��õ') THEN
          DBMS_OUTPUT.PUT_LINE('����, ��õ : ������');        
        ELSE
          DBMS_OUTPUT.PUT_LINE('��Ÿ');
    END CASE;     
END;
/
--CASE  ����
--��ٱ��� ���̺��� 2005�⵵ 'a001' ȸ���� ���űݾ��� ���� ���ؼ�
--1000���� �̸��� '�����', 1000���� �̻� 2000���� �̸��� '�ǹ�'
-- 2000���� �̻� 3000���� �̸��� '���', 
-- 3000���� �̻� 4000���� �̸��� '�÷�Ƽ��', �� �̻��� ���̾Ʒ� 
-- ����غ���
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
           DBMS_OUTPUT.PUT_LINE('�����');
         WHEN V_SUM <= 10000000 AND V_SUM > 20000000 THEN
           DBMS_OUTPUT.PUT_LINE('�ǹ�');
         WHEN V_SUM <= 20000000 AND V_SUM > 30000000 THEN
           DBMS_OUTPUT.PUT_LINE('���');
         WHEN V_SUM <= 30000000 AND V_SUM > 40000000 THEN
           DBMS_OUTPUT.PUT_LINE('�÷�Ƽ��');
         ELSE
           DBMS_OUTPUT.PUT_LINE('���̾�');
    END CASE ;

END;
/

-- case ����
-- ȸ�����̺��� ������ ������ ȸ���� �˻��Ͽ�
--ȸ������ 3�� �̸��̸� '�Ҹ���'
--3�� �̻� 6�� �̸��̸� '��Ŭ'
--6�� �̻� 9�� �̸��̸� '���Ƹ�'
-- �� �̻��̸� '��ȸ'�� ����� �������
/
SET SERVEROUTPUT ON;
/
DECLARE
V_ADD NUMBER;

BEGIN
SELECT COUNT(MEM_NAME)  INTO V_ADD
FROM MEMBER WHERE SUBSTR(MEM_ADD1, 1, 2) = '����';
    CASE WHEN V_ADD < 3 THEN
           DBMS_OUTPUT.PUT_LINE('�Ҹ���');    
         WHEN V_ADD >=3 AND V_ADD < 6 THEN
           DBMS_OUTPUT.PUT_LINE('��Ŭ');    
         WHEN V_ADD >= 6 AND V_ADD < 9 THEN
           DBMS_OUTPUT.PUT_LINE('���Ƹ�');    
         ELSE
           DBMS_OUTPUT.PUT_LINE('��ȸ');
    END CASE;           
END
;
/

--P.298
-- WHILE :  �ݺ��� ������ ������ Ȯ��.
-- ������ TRUE�̾�� LOOP����
-- 1���� 10���� ���ϱ�
/
DECLARE
V_SUM NUMBER := 0;
V_VAR NUMBER := 1;
BEGIN 
WHILE V_VAR <= 10 LOOP
V_SUM := V_SUM + V_VAR;
V_VAR := V_VAR + 1;
END LOOP;
DBMS_OUTPUT.PUT_LINE('1���� 10������ �� = ' || V_SUM);
END;
/

--P.298
--���� WHILE���� ����Ͽ� ������ �����
/
DECLARE
DAN NUMBER := 2;
NUM NUMBER := 1;
BEGIN
    WHILE DAN <=9 LOOP
    DBMS_OUTPUT.PUT_LINE(DAN || '��' );

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
--LOOP��
--������ ���� �ܼ��� ���� ����(���� �ݺ�)
--EXIT ���� ����Ͽ� �ݺ����� ��������
/
SET SERVEROUTPUT ON;
/
DECLARE
    V_VAR NUMBER :=1; 
    -- ��������
    V_SUM NUMBER := 0;
BEGIN
    LOOP
        --V_VAR :  ������ ����
        DBMS_OUTPUT.PUT_LINE(V_VAR);
        --���� := ���� + �������
        V_SUM := V_SUM +V_VAR;
        V_VAR := V_VAR +1;
        --���� ����?
        IF V_VAR > 10 THEN
            EXIT;
        END IF;
    END LOOP;
     DBMS_OUTPUT.PUT_LINE('1���� 10������ �� = ' || V_SUM);
END;
/

--P.300
--GOTO
-- I GO TO SCHOOL BY BUS.
/
DECLARE
    V_VAR NUMBER := 1;
    --��������
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
--LOOP �� EXIT WHEN ������ ����Ͽ�
-- �������� ����ϱ�
-- 2�ܺ��� 9�ܱ��� ���
/
ACCEPT DAN PROMPT '���� �Է��ϼ��� : ' 
DECLARE
    V_DAN NUMBER := 2;
    V_NUM NUMBER := 1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(V_DAN || '��');
        LOOP
            DBMS_OUTPUT.PUT_LINE(V_DAN || 'X' || V_NUM || '=' || V_DAN * V_NUM);        
            V_NUM := V_NUM + 1;
            EXIT WHEN V_NUM > 9;
        END LOOP;
        V_NUM := 1;        
        V_DAN := V_DAN + 1;
        --V_DAN�� 10�̵Ǹ� ����������
        EXIT WHEN V_DAN > 9;
    END LOOP;

END;
/

--P.300
--F0R��
--
DECLARE 
    -- I NUMBER;: �ڵ����� ������ �Ǵϱ� ��������
BEGIN
    -- I : �ڵ����� ������ ����.
    -- ������ DECLARE���� �������� �ʴ��� 
    -- ���������� �ڵ����� ����Ǵ� ����
    -- �⺻ 1�� ����
    --1..10 => 1�� ���۰�, 10�� ���ᰪ
    -- ���۰� �տ� REVERSE�� �ִٸ� 1�� ���ҵ�
    FOR I IN REVERSE 1..10 LOOP
    DBMS_OUTPUT.PUT_LINE(I);
    END LOOP;
END;
/
DECLARE 
BEGIN
    FOR V_DAN IN 2..9 LOOP
        DBMS_OUTPUT.PUT_LINE(V_DAN || '��');
        FOR V_NUM IN 1..9 LOOP
         DBMS_OUTPUT.PUT_LINE(V_DAN || 'X' || V_NUM || '=' || (V_DAN * V_NUM));
        END LOOP;
    END LOOP;
END;
/

DECLARE
BEGIN
    -- 7��
    FOR I IN 1..7 LOOP 
        -- 1��
        FOR J IN 1..I LOOP
        DBMS_OUTPUT.PUT('*');
        END LOOP;  
        DBMS_OUTPUT.PUT_LINE('');    
    END LOOP;
END;
/

--P.301
-- ��ǰ�з��ڵ尡 P201�� ��ǰ�з���=> ����ĳ�־�
DECLARE
    V_NM VARCHAR2(60);
BEGIN
    SELECT  LPROD_NM + 0 INTO V_NM
    FROM    LPROD
    WHERE   LPROD_GU LIKE 'P2%';
    DBMS_OUTPUT.PUT_LINE('V_NM :' || V_NM);
    -- ���ǵ� ���� ó��
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN --ORA-01403
            DBMS_OUTPUT.PUT_LINE('�ش� ������ �����ϴ�.');
        WHEN TOO_MANY_ROWS THEN --ORA-01422
            DBMS_OUTPUT.PUT_LINE('�� �� �̻��� ���� ���Խ��ϴ�.');
        WHEN OTHERS THEN --ORS-01722(SQL ERROR MESSAGE)
            DBMS_OUTPUT.PUT_LINE('��Ÿ���� : ' || SQLERRM);
END;
/

--id�� z001�� ȸ���� �̸��� ������ ���ϱ�
--��, �ش� ������ ���� ��� ����ó�� �Ͻÿ�
/
DECLARE
    V_NAME VARCHAR2(60);
    V_JOB VARCHAR2(60);
BEGIN
    SELECT MEM_NAME, MEM_JOB INTO V_NAME , V_JOB
    FROM MEMBER 
    WHERE MEM_ID = 'z001';
        DBMS_OUTPUT.PUT_LINE('�̸� :' || V_NAME || '���� : '|| V_JOB);
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('�ش� ������ �����ϴ�.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('�����߻�: ' || SQLERRM);
END;
/

--P.301
--���ǵ��� ���� ������ ���
DECLARE
    --EXCEPTION�� ���� ����
    EXP_REFERENCE EXCEPTION;
    --EXCEPTION�� ������ 2232�� ������ ����
    PRAGMA EXCEPTION_INIT(EXP_REFERENCE, -2292);
BEGIN
    -- ORA-02292(child record found)
    DELETE FROM LPROD
    WHERE LPROD_GU = 'P101'; 
    EXCEPTION
        WHEN EXP_REFERENCE THEN
            DBMS_OUTPUT.PUT_LINE('���� �Ұ� : ' || SQLERRM);
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('��Ÿ ���� : ' || SQLERRM);
END;
/

-- P.302
-- ����� ���� ERROR
ACCEPT P_LGU PROMPT '����Ϸ��� ��ǰ�з��ڵ带 �Է��ϼ��� :'
DECLARE
    -- EXCEPTION�� ���� ����
    EXP_LPROD_GU EXCEPTION;
    --ACCEPT�� P_LGU������ ���� ����Ϸ��� �ּҸ� ã�ư��� ��
    V_LGU VARCHAR2(10) := '&P_LGU';
BEGIN
    IF V_LGU IN('P101','P102', 'P201', 'P202') THEN
        --�߻���Ű��
        RAISE EXP_LPROD_GU;
    END IF;
        DBMS_OUTPUT.PUT_LINE('��ϰ���');
    EXCEPTION
        WHEN EXP_LPROD_GU THEN
            DBMS_OUTPUT.PUT_LINE(V_LGU ||'�� ��ϺҰ�');
END;
/
SET SERVEROUTPUT
--CURSOR
-- 2005�⵵ ��ǰ�� ���Լ����� �հ�
DECLARE
    V_PROD VARCHAR2(20);
    V_QTY NUMBER;
    --Ŀ�� ����
    CURSOR GAEDDONGI IS 
        SELECT BUY_PROD, SUM(BUY_QTY) FROM BUYPROD
        WHERE EXTRACT(YEAR FROM BUY_DATE) = 2005
        GROUP BY BUY_PROD ORDER BY BUY_PROD ASC;
BEGIN
    --�����͸� �޸𸮷� BIND(�ø�)
    OPEN GAEDDONGI;
    --�۾� ����
    --�������� ����Ŵ. �����
    FETCH GAEDDONGI INTO V_PROD, V_QTY;
    WHILE GAEDDONGI %FOUND LOOP
        DBMS_OUTPUT.PUT_LINE(V_PROD || ',' || V_QTY);
        FETCH GAEDDONGI INTO V_PROD, V_QTY;
        END LOOP;
        
    --�����͸� �޸𸮿��� ����
    CLOSE GAEDDONGI;
END;
/
-- ������ ������ �޾� �̸� ȸ����� ���ϸ����� ����ϴ� Ŀ��
ACCEPT V_JOB PROMPT '������ �Է����ּ��� :'
DECLARE
 V_NAME VARCHAR2(60);
 V_MILEAGE NUMBER;
 -- SELECT ��� ���տ� CUR�̶�� �̸��� ����
 CURSOR CUR IS
SELECT  MEM_NAME
 ,   MEM_MILEAGE
FROM    MEMBER    
WHERE   MEM_JOB = '&V_JOB';
BEGIN
-- ������ �޸𸮷� ���ε�
    OPEN CUR;
--�����
 FETCH CUR INTO V_NAME, V_MILEAGE;
 -- ��ġ�ߴ��� �����Ͱ� �ִ�?
 WHILE CUR%FOUND LOOP
  DBMS_OUTPUT.PUT_LINE (V_NAME || ', ' || V_MILEAGE);
 FETCH CUR INTO V_NAME, V_MILEAGE;

 END LOOP;
 --�޸� ����
CLOSE CUR;
 
end;
/
-- FOR���� �̿���
/
ACCEPT V_JOB PROMPT '������ �Է����ּ��� :'

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

--CURSOR ����
/*
ȸ���� ����ݾ��� �� SUM(PROD_SALE*CART_QTY)��
20000000�� �ʰ��ϴ� ȸ���� ����غ���
ALIAS : ȸ��ID, ȸ����, ����ݾ���
CURSOR�� ����� ���
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
-- FOR������ ���
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
--��ǰ�ڵ带 �Ű�����(PARAMETER)�� �Ͽ� ������ ADD
--UPDATE ��뿩
SELECT PROD_ID
    ,  PROD_TOTALSTOCK
FROM  PROD
WHERE PROD_ID = 'P101000001';    

--���ν��� ����
-- ������ : �����м� + �ǹ̺м��� ó���ǰ�, ������ ĳ�ð����� �����
--          ����Ŭ�� �����ϴ� ���� �ٲ�
-- BIND���� : �Ű�����(�Ķ����(�μ�)�� ó��)

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
            DBMS_OUTPUT.PUT_LINE('�����߻� : ' || SQLERRM);
END;
/
EXEC USP_UPDATE('P101000001', 50);
/

-- ���ν��� ��������1
CREATE TABLE PROCTEST(
    PROC_SEQ NUMBER,
    PROC_CONTENT VARCHAR2(30),
    CONSTRAINT PK_PROCTEST PRIMARY KEY(PROC_SEQ)
    );

--1-1) ���ν��� PROC_TEST1�� ����
--�����ϸ� PROCTEST ���̺� 
--1, '������' �����Ͱ� �߰��ǵ��� ó��
--2, '������2'
--3, '������3'
--...
INSERT INTO PROCTEST(PROC_SEQ, PROC_CONTENT) VALUES (1, '������1');
INSERT INTO PROCTEST(PROC_SEQ, PROC_CONTENT) VALUES (2, '������2');
INSERT INTO PROCTEST(PROC_SEQ, PROC_CONTENT) VALUES (3, '������3');
SELECT * FROM PROCTEST;
CREATE OR REPLACE PROCEDURE PROC_TEST1(V_SEQ IN NUMBER)
IS
BEGIN
    INSERT INTO PROCTEST(PROC_SEQ, PROC_CONTENT) VALUES (V_SEQ, '������'||V_SEQ);
  
END;
/
EXEC PROC_TEST1(2);
/


SELECT * FROM PROCTEST;
INSERT INTO ���̺��(�÷����) VALUES(����);

UPDATE ���̺��
SET �÷� = ��
WHERE ����;

DELETE FROM ���̺��
WHERE ����;

--P.305
-- ȸ�����̵� �Է¹޾�(IN���ε庯��) �̸��� ��̸�
-- OUT �Ű�����(OUT���ε庯��)�� ó��
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

--ȸ�����̵�(MEM_ID) �� ������ �Է¹޾� ���ϸ��� ����(MEM_MILEAGE)�� 
--������Ʈ �ϴ� ���ν���(USP_MEMBER_UPDATE)�� �����ϱ�
--EXECUTE�� ���� ������(a001)ȸ���� ���ϸ��� ���� 
--100�� �߰��Ͽ� 5ȸ�� ���� 500���� �ø���.

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
        DBMS_OUTPUT.PUT_LINE('�����߻� : ' || SQLERRM);
END;
/
EXEC USP_MEMBER_UPDATE('a001', 100);
/

-- ȸ�� ���̵� ������ �ش� �̸��� �����ϴ� �Լ� �����
--���ν����� �޸� �Լ����� RETURNŸ���� ����
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
            DBMS_OUTPUT.PUT_LINE('�����߻� :' || SQLEERRM);
END;
/
SELECT FN_GETNAME('a001') FROM DUAL;

-- �Լ� ����
-- ������ ���� ����Ͻÿ�
-- ��ǰ�ڵ�, ��ǰ��, ��з��ڵ�, ��з���
-- �Լ��� ���, �Լ�����  FN_PRODNM
SELECT  PROD_ID ��ǰ�ڵ�
    ,   PROD_NAME ��ǰ��
    ,   PROD_LGU ��з��ڵ�
    ,   FN_GET_LPROD_NM(PROD_LGU) ��з���
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
--�⵵ �� ��ǰ�ڵ带 �Է� ������ �ش翬���� ��� �Ǹ� Ƚ���� ��ȯ

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
        DBMS_OUTPUT.PUT_LINE('���ܹ߻� : ' || SQLERRM);
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

---------Ʈ����----------------
CREATE OR REPLACE TRIGGER TG_LPROD_IN
--LPROD���̺� �����Ͱ� INSERT�� �Ŀ� BEGIN�� ó������
AFTER INSERT
ON LPROD
FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE('��ǰ�з��� �߰��Ǿ����ϴ�.');
   --NEW : ��� INSERT�� ���ο� ��
   INSERT INTO LPROD_BAK(LPROD_ID, LPROD_GU, LPROD_NM)
   VALUES(:NEW.LPROD_ID, :NEW.LPROD_GU, :NEW.LPROD_NM);
END;
/
--������� Ʈ���� Ȯ��
SELECT TRIGGER_NAME FROM USER_TRIGGERS;
/
SET SERVEROUTPUT ON;
/ 
--MAX(LPROD_GU) : P403
--SUBSTR(MAX(LPROD_GU), 2) : 403 +1 => 404=> P404
INSERT INTO LPROD(LPROD_ID, LPROD_GU, LPROD_NM) VALUES(
            (SELECT MAX(LPROD_ID) + 1 FROM LPROD),
            (SELECT 'P' || (SUBSTR(MAX(LPROD_GU), 2) + 1) FROM LPROD),
            'Ʈ���� �߰���1');
/
SELECT * FROM LPROD;

--------Ʈ����-----------------
CREATE TABLE LPROD_BAK
AS
SELECT * FROM LPROD;
/ 
SELECT * FROM LPROD_BAK;
/
---------Ʈ���� �ǽ��ϱ�--------
--�޿������� �ڵ� �߰���� Ʈ���� �ۼ��ϱ�
-- ������ ������ ���̺� ����
CREATE TABLE EMP01(
EMPNO NUMBER(4) PRIMARY KEY,
EMPNAME VARCHAR2(45),
EMPJOB VARCHAR2(60)
);
-- �޿��� ������ ���̺� ����
CREATE TABLE SAL01(
SALNO NUMBER(4) PRIMARY KEY,
SAL NUMBER(7,2),
EMPNO NUMBER(4) REFERENCES EMP01(EMPNO)
);
--�޿� ��ȣ�� �ڵ����� �����ϴ� �������� �����ϰ� 
-- �� �������κ��� �Ϸù�ȣ�� ��� �޿���ȣ�� �ο�
CREATE SEQUENCE SAL01_SAL_NO_SEQ
START WITH 1
INCREMENT BY 1;
/
-- Ÿ�̹� : AFTER(~�Ŀ�), �̺�Ʈ : INSERT(�Է�) 
CREATE OR REPLACE TRIGGER TGR_02
AFTER INSERT
ON EMP01
FOR EACH ROW
BEGIN 
-- NEW : EMP01���̺� �����͸� �Է��� �� ��
INSERT INTO SAL01 VALUES(
SAL01_SAL_NO_SEQ.NEXTVAL, 200, :NEW.EMPNO);
END;
/
INSERT INTO EMP01 VALUES (2201, '������', '���α׷���');
INSERT INTO EMP01 VALUES (2202, '������', '���α׷���');
INSERT INTO EMP01 VALUES (2203, '������', '���α׷���');

/
SELECT * FROM EMP01;
SELECT * FROM SAL01;
SELECT * FROM EMP01 A, SAL01 B WHERE A.EMPNO = B.EMPNO;
/
-- ����� �����Ǹ� �޿������� �ڵ������Ǵ� Ʈ����
DELETE FROM EMP01 WHERE EMPNO= 2203;
/
/*
�����ȣ 3�� �޿� ���̺��� �����ϰ� �ֱ� ������ ������ �Ұ����ϴ�
����� �����Ƿ��� �� ����� �޿� ������ �޿� ���̺��� �����Ǿ�� �մϴ�.
����� ������ ���� �� �� ����� �޿� ������ �Բ� ����
*/
--�̺�Ʈ : DELETE, Ÿ�̹� : AFTER
-- => EMP01 ���̺��� �����Ͱ� ������ �� BEGIN TLFGOD
CREATE OR REPLACE TRIGGER TRG_03
AFTER DELETE
ON EMP01
FOR EACH ROW
BEGIN
    --  OLD : 2202, ������(������ ��)
    DELETE FROM SAL01 
    WHERE EMPNO = :OLD.EMPNO;
END;
/
--��Ǫ������ �ּ���
DELETE FROM EMP01
WHERE EMPNO = 2203;

------------��Ű��-------------
--��Ű�� ����
/
CREATE OR REPLACE PACKAGE PROD_MGR
IS
--�����
    --��������
    P_PROD_LGU  PROD.PROD_LGU%TYPE;  
    --���ν���
    PROCEDURE PROD_LIST;
    PROCEDURE PROD_LIST (P_PROD_LGU  IN  PROD.PROD_LGU%TYPE);
    --�Լ�
    FUNCTION PROD_COUNT RETURN NUMBER;
    --����������
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
              DBMS_OUTPUT.PUT_LINE ( '��ǰ �з��� �����ϴ�.'); 
        WHEN  OTHERS  THEN  
             DBMS_OUTPUT.PUT_LINE ( '��Ÿ ���� :' || SQLERRM  ); 
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
        DBMS_OUTPUT.PUT_LINE ( '��Ÿ ���� :' || SQLERRM  ); 
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

-----------��Ű�� ���� ����-------------
CREATE OR REPLACE PACKAGE PKG_EASY
IS
        V_NAME VARCHAR2(60);
    --ȸ���� ���̵� �� ���ڸ� �޾� ���ϸ��� �ο�
    PROCEDURE PROC_MILEAGE_UP(P_ID IN VARCHAR2, P_MILEAGE IN NUMBER);
    --ȸ���� ���̵� �޾� �̸��� ����
    FUNCTION FN_GET_NAME(P_ID IN VARCHAR2)
        RETURN VARCHAR2;
END PKG_EASY;
/
--������� �켱 �������� ��
CREATE OR REPLACE PACKAGE BODY PKG_EASY
IS   
    --ȸ���� ���̵� �� ���ڸ� �޾� ���ϸ��� �ο� ->�󼼳���
    PROCEDURE PROC_MILEAGE_UP(P_ID IN VARCHAR2, P_MILEAGE IN NUMBER)
    IS
    BEGIN
        UPDATE MEMBER
        SET     MEM_MILEAGE = MEM_MILEAGE + P_MILEAGE
        WHERE   MEM_ID = P_ID;
        END PROC_MILEAGE_UP;

    --ȸ���� ���̵� �޾� �̸��� ����-> �󼼳���
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

