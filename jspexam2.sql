--�÷��ù��� ����Ͽ� 10�� ������ �ǵ���
SELECT * 
FROM PRODUCT AS OF TIMESTAMP(SYSTIMESTAMP - INTERVAL '10' MINUTE);

-- ��� ���̺� ����� 
-- INSERT INTO ��������̺�
-- SELECT * FROM ������̺��
INSERT INTO PRODUCT
SELECT * FROM PRODUCT_BAK2;
COMMIT;

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
WHERE TABLE_NAME = 'ITEM';
-- WHERE�� ���̺�� �ٲ��ָ� ��!!