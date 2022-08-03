-- 메모
'''
cmd 명령어
       mysql -uroot -p0000 (root계정의 비밀번호)
       exit
       
Ctrl + Enter : 커서가 위치한 한 문장만 실행

윈도우에서는 대소문자 구분 x, 그러나 리눅스 등에서는 구분함. ⇒ 대문자로 명령어를 쓰자.
'''

-- DB 생성 후 schemas 새로고침
CREATE DATABASE 데이터베이스명; 
CREATE DATABASE [IF NOT EXISTS] 데이터베이스명;


-- DB 삭제
DROP DATABASE 데이터베이스명; 


-- 해당 DB에 접근. 접근 이후에 테이블을 생성, 삭제, 변경 등을 진행함.
use 데이터베이스명; 


-- 테이블 생성하기
CREATE TABLE [IF NOT EXISTS] 테이블명
(
       칼럼1 데이터타입 NOT NULL,
       칼럼2 데이터타입 NULL,
       칼럼3 데이터타입, -- NULL은 생략 가능, NOT NULL 반드시 명시
);


-- 테이블 구조 조회
DESC 테이블명;
DESCRIBE 테이블명;


-- 테이블 삭제하기
DROP TABLE 테이블명;

-- 테이블 생성과 동시에 기본키를 설정하는 법
-- 방법 1) 테이블 생성, 기본키 추가 
CREATE TABLE highschool_students (
       student_no    VARCHAR(20)  NOT NULL PRIMARY KEY, -- 기본키는 값 입력 필수이고 중복이 안됨.
       student_name  VARCHAR(100) NOT NULL,             -- 테이블 하나 당 기본 키는 한 개만 생성 가능함.
       grade         TINYINT          NULL,             -- PRIMARY KEY만을 지정하면 NOT NULL을 생략해도 자동으로 적용됨.
       class         VARCHAR(50)      NULL,
       gender        VARCHAR(20)      NULL,
       age           SMALLINT         NULL,
       enter_date    DATE
);


-- 방법 2) 테이블 생성, 기본키 추가
CREATE TABLE highschool_students (
       student_no    VARCHAR(20)  NOT NULL,
       student_name  VARCHAR(100) NOT NULL,
       grade         TINYINT          NULL,
       class         VARCHAR(50)      NULL,
       gender        VARCHAR(20)      NULL,
       age           SMALLINT         NULL,
       enter_date    DATE,
       PRIMARY KEY (student_no)    -- [CONSTRAINT]: 제약조건이란 의미이며, 생략이 가능함
);


-- 방법 2) 테이블 생성, 기본키 추가
CREATE TABLE highschool_students (
       student_no    VARCHAR(20)  NOT NULL,
       student_name  VARCHAR(100) NOT NULL,
       grade         TINYINT          NULL,
       class         VARCHAR(50)      NULL,
       gender        VARCHAR(20)      NULL,
       age           SMALLINT         NULL,
       enter_date    DATE,
       CONSTRAINT  PRIMARY KEY (student_no)
);


-- 테이블을 먼저 만든 후에 기본키를 설정하는 법
-- 기본 키 추가
ALTER TABLE highschool_students
ADD PRIMARY KEY (student_no);

-- 기본 키 삭제
ALTER TABLE highschool_students
DROP PRIMARY KEY ;


-- 코드
SELECT COUNT(*) FROM box_office;

SELECT COUNT(*) FROM employees;

SELECT COUNT(*) FROM departments;

SELECT COUNT(*) FROM dept_manager;

SELECT COUNT(*) FROM dept_emp;

SELECT COUNT(*) FROM titles;

SELECT COUNT(*) FROM salaries;



