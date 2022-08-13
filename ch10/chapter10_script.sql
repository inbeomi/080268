-- 10-1
USE mywork;

CREATE TABLE emp_test (
       emp_no    INT          NOT NULL,
       emp_name  VARCHAR(30)  NOT NULL,
       hire_date DATE             NULL,
       salary    INT              NULL,
       PRIMARY KEY (emp_no) 
);
     

-- 10-2
-- 단일 로우 입력 INSERT 문
-- 컬럼과 값은 개수, 데이터 형이 일치해야 함.
INSERT INTO emp_test ( emp_no, emp_name, hire_date, salary )
              VALUES ( 1001, '아인슈타인', '2021-01-01', 1000);
 
SELECT *
  FROM emp_test;
  
-- 10-3
INSERT INTO emp_test ( emp_no, emp_name, hire_date )
              VALUES ( 1002, '아이작뉴턴', '2021-02-01');
 
SELECT *
  FROM emp_test;
 

-- 10-4
-- 컬렴명 순서와 입력갑 순서가 같아야 함. 
INSERT INTO emp_test ( hire_date, emp_no, emp_name )
              VALUES ( '2021-02-10', 1003, '갈릴레오' );
 
SELECT *
  FROM emp_test;
 

-- 10-5
-- NOT NULL 속성 컬럼에 만약 값을 넣지 않았더라면 오류가 발생함. 값을 반드시 입력해줘야 함
-- 아래의 예시는 오류가 발생함.
INSERT INTO emp_test ( emp_no, hire_date  )
              VALUES ( 1004, '2021-02-10' );
 

-- 10-6
-- 기본 키 컬럼에는 중복 값 입력이 불가함. 1003이 중복된 값이라 오류가 발생함.
INSERT INTO emp_test ( emp_no, emp_name, hire_date )
              VALUES ( 1003, '리처드파인만', '2021-01-10' );


-- 10-7
-- 테이블에 컬럼이 이미 존재한 경우, 컬럼명을 생략해도 됨
-- 이 때, 순서는 기존 테이블 컬럼의 순서를 따름.
INSERT INTO emp_test 
              VALUES ( 1004, '리처드파인만', '2021-01-10', 3000 );
 
SELECT *
  FROM emp_test;
 

-- 10-8
-- 다중 로우 입력 INSERT 문
INSERT INTO emp_test VALUES 
ROW ( 1005, '퀴리부인',  '2021-03-01', 4000 ),
ROW ( 1006, '스티븐호킹', '2021-03-05', 5000 );
 
SELECT *
  FROM emp_test;
  

-- 10-9
-- ROW를 생략 가능
INSERT INTO emp_test VALUES 
( 1007, '마이클패러데이','2021-04-01', 2200 ),
( 1008, '맥스웰',     '2021-04-05', 3300 ),
( 1009, '막스플랑크',  '2021-04-05', 4400 );
 
SELECT *
  FROM emp_test;
 
       
-- 10-10
CREATE TABLE emp_test2 (
       emp_no    INT          NOT NULL,
       emp_name  VARCHAR(30)  NOT NULL,
       hire_date DATE             NULL,
       salary    INT              NULL,
       PRIMARY KEY (emp_no) 
);

  

-- 10-11
-- SELECT 문이 결합된 INSERT 문
-- SELECT 문이 반환한 결과 값을 INSERT 해줌. 따라서 SELECT가 반환하는 컬럼 개수와 INSERT 컬럼 개수가 동일해야 함.
INSERT INTO emp_test2 ( emp_no, emp_name, hire_date, salary )
SELECT emp_no, emp_name, hire_date, salary
  FROM emp_test
 WHERE emp_no IN (1001,1002);
 
SELECT *
  FROM emp_test2 ;

-- 10-12
-- 컬럼을 따로 명시하지 않음. 모든 컬럼에 값을 넣겠다는 의미. 단 순서는 주의
INSERT INTO emp_test2 
SELECT *
  FROM emp_test
 WHERE emp_no IN (1003,1004);
 
SELECT *
  FROM emp_test2 ;
 

-- 10-13
-- 기본 키가 중복되면서 오류가 발생함. 
INSERT INTO emp_test2 ( emp_no, emp_name, hire_date, salary )
SELECT emp_no, emp_name, hire_date, salary
  FROM emp_test
 WHERE emp_no >= 1004;


-- 10-14
-- +10을 해줌으로써 기본키가 중복되지 않게 함.
INSERT INTO emp_test
SELECT emp_no + 10, emp_name, hire_date, 100
  FROM emp_test
 WHERE emp_no >= 1008;
 
SELECT *
  FROM emp_test; 
 
 
-- 10-15
CREATE TABLE emp_update1
SELECT *
  FROM emp_test;
 
-- 기본 키 속성도 추가 부여하기 위해 ALTER를 사용..? 
ALTER TABLE emp_update1
  ADD CONSTRAINT PRIMARY KEY (emp_no);
  
  
CREATE TABLE emp_update2
SELECT *
  FROM emp_test2;
  
ALTER TABLE emp_update2
  ADD CONSTRAINT PRIMARY KEY (emp_no);
  
 
 
-- 10-16 
-- 단일 테이블 데이터 수정
-- Safe Updates 설정 변경이 필요함. (WHERE 절이 없는 UPDATE와 DELETE문 실행시 오류가 나는 것을 해결하기 위함)
-- 즉, "너 조건 없이 모든 값을 바꾸고 싶은 게 맞아?" 를 한 번 더 확인해보기 위함. 
-- NULL + 100 = NULL 이다.
UPDATE emp_update1
   SET emp_name = CONCAT(emp_name, '2'),
       salary   = salary + 100;
       
SELECT *
  FROM emp_update1;

  
-- 10-17
-- 기본 키 중복 에러.
-- 1018를 1019로 UPDATE 하는 과정에서 기존의 1019와 중복한 값이 되어버림.
UPDATE emp_update1
   SET emp_no = emp_no + 1
 WHERE emp_no >= 1018;


-- 10-18
-- 기본 키가 중복될 줄 알았지만 오류가 나지 않음.
-- DESC 덕분에 업데이트 하는 과정에서 중복이 발생하지 않아 정상 처리가 됨
UPDATE emp_update1
   SET emp_no = emp_no + 1
 WHERE emp_no >= 1018
 ORDER BY emp_no DESC;
 
SELECT *
  FROM emp_update1; 

-- 10-19
-- 다중 테이블 데이터 수정
UPDATE emp_update2 a, 
       emp_update1 b
   SET a.salary = b.salary + 1000
 WHERE a.emp_no = b.emp_no;
 
SELECT *
  FROM emp_update2;
 
       
-- 10-20
UPDATE emp_update2 a, 
       emp_update1 b
   SET b.salary = IFNULL(b.salary, 0),
       a.salary = b.salary + 2000
 WHERE a.emp_no = b.emp_no;
 
SELECT *
  FROM emp_update2;
  
SELECT *
  FROM emp_update1;
  
       
-- 10-21
-- 입력과 수정을 동시에 처리
-- ON DUPLICATE KEY UPDATE : 기본 키 값 충돌이 발생하는 로우에서는 신규로 값을 입력하는 것이 아니라 기존에 저장된 값을 변경함.
INSERT INTO emp_update2 
SELECT emp_no, emp_name, hire_date, salary
  FROM emp_update1 a
 WHERE emp_no BETWEEN 1003 AND 1005
ON DUPLICATE KEY UPDATE emp_name = a.emp_name, 
                        salary   = a.salary;
 
SELECT *
  FROM emp_update2;
       
       
-- 10-22
CREATE TABLE emp_delete AS
SELECT *
  FROM emp_test;
  
ALTER TABLE emp_delete
ADD CONSTRAINT PRIMARY KEY (emp_no);
       
SELECT *
  FROM emp_delete;
  
  
-- 10-23
-- 단일 테이블 데이터 삭제. 로우 단위로 삭제하기에 컬럼을 따로 지정할 필요가 없음
DELETE FROM emp_delete
 WHERE salary IS NULL;
 
SELECT *
  FROM emp_delete; 
 
       
-- 10-24
-- WHERE 조건에 맞는 단일 테이블 삭제. WHERW 절이 없으면 데이터 전체 삭제
DELETE FROM emp_delete;
 
SELECT *
  FROM emp_delete; 
 
       
-- 10-25
INSERT INTO emp_delete
SELECT *
  FROM emp_test;
  
SELECT *
  FROM emp_delete
 ORDER BY emp_name; 
       
-- 10-26
-- ORDER BY 절 명시하면 해당 순서대로 데이터 삭제
-- LIMIT 삭제 데이터 개수 제한 (위에서 차례로 없어짐)
DELETE FROM emp_delete
 WHERE emp_name = '맥스웰'
 ORDER BY emp_no DESC
 LIMIT 1;
 
SELECT *
  FROM emp_delete
 WHERE emp_name = '맥스웰';
 

-- 10-27
CREATE TABLE emp_delete2 AS
SELECT *
  FROM emp_test;
  
ALTER TABLE emp_delete2
ADD CONSTRAINT PRIMARY KEY (emp_no);

SELECT *
  FROM emp_delete2;
  
  
-- 10-28
-- 다중 테이블 데이터 삭제하기
-- DELETE와 FROM 사이에 명시한 별칭에 해당하는 테이블 데이터만 삭제
-- a, b 테이블 양쪽에 모두 적용됨.
DELETE a, b
  FROM emp_delete a
      ,emp_delete2 b
 WHERE a.emp_no = b.emp_no;
 
SELECT *
  FROM emp_delete;
  
SELECT *
  FROM emp_delete2;
   
   
-- 10-29
DELETE FROM emp_delete2;

INSERT INTO emp_delete 
SELECT *
  FROM emp_test
 WHERE emp_no <> 1018;
 
INSERT INTO emp_delete2 
SELECT *
  FROM emp_test;
  
SELECT *
  FROM emp_delete;
  
SELECT *
  FROM emp_delete2;
  
  
-- 10-30
-- 다중 테이블 데이터 삭제하기 방법2
-- USING
DELETE FROM b
 USING emp_delete a, emp_delete2 b
 WHERE a.emp_no = b.emp_no;
  
SELECT *
  FROM emp_delete;
  
SELECT *
  FROM emp_delete2;
  
  
-- 10-31
-- COMMIT : 데이터 입력, 수정, 삭제한 후 이 작업을 영구적으로 테이블에 반영
-- ROLLBACK : 데이터 입력, 수정, 삭제한 후 이 작업을 취소
-- AutoCommit 속성 : COMMIT 문을 명시적으로 실행 안해도 입력, 수정, 삭제 데이터 테이블에 반영
-- autocommit 확인
SELECT @@AUTOCOMMIT;

-- autocommit 비활성화
-- 0: 비활성화, 1: 활성화
SET autocommit = 0;  

-- autocommit 변경 확인
SELECT @@AUTOCOMMIT;

  
-- 10-32
CREATE TABLE emp_tran1 AS
SELECT *
  FROM emp_test;
  
ALTER TABLE emp_tran1
ADD CONSTRAINT PRIMARY KEY (emp_no);  
  
CREATE TABLE emp_tran2 AS
SELECT *
  FROM emp_test;

ALTER TABLE emp_tran2
ADD CONSTRAINT PRIMARY KEY (emp_no);


-- 10-33
-- emp_tran1 삭제 
DELETE FROM emp_tran1;

-- emp_tran2 삭제
DELETE FROM emp_tran2;

-- 삭제 취소
ROLLBACK;

-- 데이터 확인
SELECT *
  FROM emp_tran1;
  
SELECT *
  FROM emp_tran2;



-- 10-34
-- emp_tran1 삭제 
DELETE FROM emp_tran1;

-- 삭제 반영
COMMIT;

-- emp_tran2 삭제
DELETE FROM emp_tran2;

-- 삭제 취소
-- 마지막 COMMIT이 이루어진 시점으로 되돌아 감.
-- 즉, 위 사례에서는 emp_tran2 삭제를 되돌리기 함. emp_tran1은 삭제가 반영된 상태
ROLLBACK;

-- 데이터 확인
SELECT *
  FROM emp_tran1;
  
SELECT *
  FROM emp_tran2;


-- 10-35
-- START TRANSACTION 문 : 트랜잭션 선언, 일시적 자동커밋 비활성화
-- SAVE POINT 식별자 : 트랜잭션 안에서 특정 지점 설정
-- ROLLBACK TO SAVEPOINT 식별자 : 식별자 부분까지 DML 작업 취소

-- autocommit 활성화 
SET autocommit = 1;

-- 데이터 입력 
INSERT INTO emp_tran1
SELECT *
  FROM emp_test;

-- 입력 취소 처리
-- 자동 커밋이 활성화 되어 있어 ROLLBACK 처리가 안 됨
ROLLBACK;

-- emp_tran1 조회 
SELECT *
  FROM emp_tran1;
    

-- 10-36
-- 트랜잭션 시작 
START TRANSACTION;

-- 데이터 삭제 
DELETE FROM emp_tran1
 WHERE emp_no >= 1006;
 
-- 데이터 수정
UPDATE emp_tran1
   SET salary = 0
 WHERE salary IS NULL;

-- START TRANSACTION 덕분에 일시적으로 자동커밋이 비활성화되어 ROLLBACK 처리가 잘 반영됨
ROLLBACK;


SELECT *
  FROM emp_tran1;
  
  
-- 10-37
START TRANSACTION;

-- savepoint A 설정 
SAVEPOINT A;

-- 삭제1 
DELETE FROM EMP_TRAN1 
WHERE SALARY IS NULL;

-- savepoint B 설정 
SAVEPOINT B;

-- 삭제2
DELETE FROM EMP_TRAN1
WHERE EMP_NAME = '맥스웰'
ORDER BY emp_no
LIMIT 1;

-- savepoint B 이후 작업 취소
-- 삭제 2만 적용만 원래 상태로  되돌리는..
ROLLBACK TO SAVEPOINT B;

COMMIT;

SELECT * 
  FROM EMP_TRAN1;



  
  
-- 1분 퀴즈 1
USE mywork;

INSERT INTO emp_test VALUES
(2001,'장영실','2020-01-01', 1500),
(2002,'최무선','2020-01-31', NULL);


-- 1분 퀴즈 2
UPDATE emp_update2 a, 
       emp_update1 b
   SET a.emp_name = b.emp_name
 WHERE a.emp_no = b.emp_no
   AND a.emp_no IN (1001, 1002) ;


-- 1분 퀴즈 3
DELETE FROM emp_delete
 WHERE emp_name = '막스플랑크'
 ORDER BY emp_no
 LIMIT 1;
 
 
-- 1분 퀴즈 4
START TRANSACTION;

-- 잘못 삭제한 DELETE 문
DELETE FROM emp_tran2
 WHERE salary = 100;
 
-- 데이터 확인 
SELECT *
  FROM emp_tran2;
  
-- 삭제 작업 취소   
ROLLBACK;  


-- Self Check 1.
INSERT INTO emp_test2 ( emp_no, emp_name, hire_date, salary )
SELECT emp_no, emp_name, hire_date, salary
  FROM emp_test a
 WHERE emp_no >= 1004
   AND NOT EXISTS ( SELECT 1
                      FROM emp_test2 b
                     WHERE a.emp_no = b.emp_no) ;

 
 
-- Self Check 2.
CREATE TABLE box_office_copy AS
SELECT years, ranks, movie_name, release_date, sale_amt, audience_num, 0 last_year_audi_num
  FROM box_office
 WHERE 1 = 2;
 
INSERT INTO box_office_copy
SELECT years, ranks, movie_name, release_date, sale_amt, audience_num, 0
  FROM box_office
 WHERE YEAR(release_date) = 2019
   AND audience_num >= 8000000;

-- Self Check 3.
UPDATE box_office_copy a
      ,box_office b
  SET a.last_year_audi_num = b.audience_num
WHERE a.ranks = b.ranks
  AND YEAR(b.release_date) = 2018;
 
 
-- Self Check 4 
DELETE FROM dept_emp
 WHERE SYSDATE() NOT BETWEEN from_date AND to_date;
 
-- Self Check 5
-- 1.트랜잭션 시작
START TRANSACTION;

-- 2.box_office_copy2 테이블 복제 
CREATE TABLE box_office_copy2 AS
SELECT *
  FROM box_office_copy; 

-- 3.box_office_copy2 테이블 전체 삭제 
DELETE FROM box_office_copy2;


-- 4.2017년 1~10위 데이터 선택해 INSERT 
INSERT INTO box_office_copy2
SELECT years, ranks, movie_name, release_date, sale_amt, audience_num, 0
  FROM box_office
 WHERE YEAR(release_date) = 2017
   AND ranks BETWEEN 1 AND 10;
   
-- 5.모든 작업 취소
ROLLBACK;
