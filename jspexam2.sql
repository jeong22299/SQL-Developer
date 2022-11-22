--�÷��ù��� ����Ͽ� 10�� ������ �ǵ���
SELECT * 
FROM PRODUCT AS OF TIMESTAMP(SYSTIMESTAMP - INTERVAL '10' MINUTE);

-- ��� ���̺� ����� 
-- INSERT INTO ��������̺�
-- SELECT * FROM ������̺��
INSERT INTO MEM
SELECT * FROM MEM_BAK;
COMMIT;
CREATE TABLE MEM_BAK AS
SELECT * FROM MEM;

--���� ī�ắȯ(https://heavenly-appear.tistory.com/270)
-- WHERE�� ���̺�� �ٲ��ָ� ��!!
SELECT COLUMN_NAME
, DATA_TYPE
, CASE WHEN DATA_TYPE='NUMBER' THEN 'private int ' || FN_GETCAMEL(COLUMN_NAME) || ';'
WHEN DATA_TYPE IN('VARCHAR2','CHAR') THEN 'private String ' || FN_GETCAMEL(COLUMN_NAME) || ';'
WHEN DATA_TYPE='DATE' THEN 'private Date ' || FN_GETCAMEL(COLUMN_NAME) || ';'
ELSE 'private String ' || FN_GETCAMEL(COLUMN_NAME) || ';'
END AS CAMEL_CASE
, '' RESULTMAP
FROM ALL_TAB_COLUMNS
WHERE TABLE_NAME = 'ATTACH'; --  ���̺�� �ٲ��ָ� ��!!

SELECT  ORGCODE, ORGSTARTDATE, ORGENDDATE, ORGNAME, ORGLEVEL, ORGSTEP, ORGUPPERCODE, ORGNOTE
FROM ORG_BASE
WHERE  SUBSTR(ORGCODE,3,8) = '000000'
ORDER BY ORGCODE;

--VARCHAR2(Variable Character 2) : 4000Bytes ����
--CLOB(Character Large Object) : 4GB, ����
--BLOB(Binary Large Object) : 2GB, ���̳ʸ�(�̹��� , ������, ����)
