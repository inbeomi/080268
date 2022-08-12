USE mywork;

-- 9-1
SELECT YEAR(a.release_date), a.movie_name, a.sale_amt
  FROM box_office a
 WHERE a.ranks = 1
 ORDER BY 1;
 

-- 9-2
SELECT YEAR(a.release_date), a.movie_name, a.sale_amt, AVG(a.sale_amt)
  FROM box_office a
 WHERE a.ranks = 1
 GROUP BY 1, 2
 ORDER BY 1;
 

-- 9-3
SELECT AVG(sale_amt)
  FROM box_office
 WHERE ranks = 1;
 

-- 9-4
USE world;

-- 스칼라(scalar) 서브쿼리 : SELECT 절에 있는 서브쿼리
-- 단일 로우, 단일 값을 반환해야 함
-- 메인쿼리와 조인 하는 것이 일반적임
SELECT a.name, a.district, a.population, a.countrycode, 
       ( SELECT b.name
           FROM country b
          WHERE a.countrycode = b.code 
       ) countryname
FROM city a;
 

-- 9-5
-- 스칼라 서브쿼리는 하나의 컬럼 역할을 함.
-- 그러나 아래 예시에서는 두 개의 컬럼을 반환하려고 해서 오류가 남.
SELECT a.name, a.district, a.population, a.countrycode, 
       ( SELECT b.name, b.continent
           FROM country b
          WHERE a.countrycode = b.code 
       ) countryname
FROM city a;
 

-- 9-6
-- 아래 예시도 오류가 남
-- 단일 로우가 아닌 전체 테이블이 반환되기에 메인쿼리와 조인할 필요가 있음.
SELECT a.name, a.district, a.population, a.countrycode, 
       ( SELECT b.name
           FROM country b
       ) countryname
FROM city a;


-- 9-7
USE mywork;

SELECT a.dept_no, a.dept_name, b.emp_no
  FROM departments a
 INNER JOIN dept_manager b
    ON a.dept_no = b.dept_no
 WHERE SYSDATE() BETWEEN b.from_date AND b.to_date;
 

-- 9-8
-- 위와 동일한 결과값을 반환함.
SELECT a.dept_no, a.dept_name,
      ( SELECT b.emp_no
          FROM dept_manager b
         WHERE a.dept_no = b.dept_no
           AND SYSDATE() BETWEEN b.from_date AND b.to_date
      ) emp_no
  FROM departments a
 ORDER BY 1;
  

-- 9-9
SELECT b.dept_no, b.emp_no, c.first_name, c.last_name
  FROM dept_manager b, 
       employees c
 WHERE b.emp_no = c.emp_no
   AND SYSDATE() BETWEEN b.from_date AND b.to_date;
 
       
-- 9-10
-- 파생(derived) 테이블 : FROM 절에 있는 서브쿼리
-- 여러 로우, 여러 값 반환 가능
-- 메인쿼리와 조인. 조인 조건은 메인쿼리에서만 가능함.
SELECT a.dept_no, a.dept_name,
       mng.emp_no, mng.first_name, mng.last_name
  FROM departments a, 
      ( SELECT b.dept_no, b.emp_no, c.first_name, c.last_name
          FROM dept_manager b, 
               employees c
         WHERE b.emp_no = c.emp_no
          AND SYSDATE() BETWEEN b.from_date AND b.to_date
      ) mng
 WHERE a.dept_no = mng.dept_no
 ORDER BY 1;
  

-- 9-11
SELECT a.dept_no, a.dept_name,
       b.emp_no, c.first_name, c.last_name
  FROM departments a, 
       dept_manager b, 
       employees c
 WHERE a.dept_no = b.dept_no
   AND b.emp_no  = c.emp_no
   AND SYSDATE() BETWEEN b.from_date AND b.to_date
 ORDER BY 1;
 

-- 9-12
SELECT a.dept_no, a.dept_name,
       COUNT(*) cnt, SUM(c.salary) salary, AVG(c.salary) dept_avg
  FROM departments a, 
       dept_emp b, 
       salaries c
 WHERE a.dept_no = b.dept_no
   AND b.emp_no  = c.emp_no
   AND SYSDATE() BETWEEN b.from_date AND b.to_date
   AND SYSDATE() BETWEEN c.from_date AND c.to_date
 GROUP BY a.dept_no, a.dept_name
 ORDER BY 1;
 

-- 9-13
SELECT AVG(f.salary)
  FROM ( SELECT a.dept_no, a.dept_name,
                COUNT(*) cnt, SUM(c.salary) salary
           FROM departments a, 
                dept_emp b, 
                salaries c
          WHERE a.dept_no = b.dept_no
            AND b.emp_no  = c.emp_no
            AND SYSDATE() BETWEEN b.from_date AND b.to_date
            AND SYSDATE() BETWEEN c.from_date AND c.to_date
          GROUP BY a.dept_no, a.dept_name
       ) f ;
 
-- 9-14
-- 서브쿼리 구조부터 파악하는 게 좋다. 
SELECT YEAR(a.release_date), a.ranks, a.movie_name,
       ROUND(a.sale_amt / b.total_amt * 100,2) percentage
  FROM box_office a
 INNER JOIN (SELECT YEAR(release_date) years, SUM(sale_amt) total_amt
               FROM box_office
              WHERE YEAR(release_date) >= 2015
              GROUP BY 1
             ) b
    ON YEAR(a.release_date) = b.years
 WHERE a.ranks <= 3
 ORDER BY 1, 2;
 
 
-- 9-15
-- 메인쿼리와 조인을 할 때 서브쿼리 WHERE 절 내에서 조인을 할 경우, 오류가 발생함.
-- 서브쿼리 밖에다가 조인 조건을 작성하면 해결됨. 
SELECT a.dept_no, a.dept_name,
       mng.emp_no, mng.first_name, mng.last_name
  FROM departments a, 
      ( SELECT b.dept_no, b.emp_no, c.first_name, c.last_name
          FROM dept_manager b, 
               employees c
         WHERE b.emp_no = c.emp_no
           AND SYSDATE() BETWEEN b.from_date AND b.to_date
           AND a.dept_no = b.dept_no
      ) mng
  ORDER BY 1;
 
 
-- 9-16
-- LATERAL 파생 테이블
-- 서브쿼리 앞에 LATERAL을 추가하면 메인쿼리와의 조인 조건을 서브쿼리 내에 기술할 수 있음.
SELECT a.dept_no, a.dept_name,
       mng.emp_no, mng.first_name, mng.last_name
  FROM departments a, 
      LATERAL 
      ( SELECT b.dept_no, b.emp_no, c.first_name, c.last_name
          FROM dept_manager b, 
               employees c
         WHERE b.emp_no = c.emp_no
           AND SYSDATE() BETWEEN b.from_date AND b.to_date
           AND a.dept_no = b.dept_no
      ) mng
  ORDER BY 1;
  
  
-- 9-17
SELECT a.dept_no, a.dept_name,
       mng.emp_no, mng.first_name, mng.last_name
  FROM departments a
 INNER JOIN LATERAL 
      ( SELECT b.dept_no, b.emp_no, c.first_name, c.last_name
          FROM dept_manager b, 
               employees c
         WHERE b.emp_no = c.emp_no
           AND SYSDATE() BETWEEN b.from_date AND b.to_date
           AND a.dept_no = b.dept_no
      ) mng
  ORDER BY 1;  
  

-- 9-18
-- WHERE 절의 서브쿼리 = 조건 서브쿼리
-- 조건 비교 값으로 서브쿼리가 사용됨. 서브쿼리 반환 값이 조건 비교 값
-- 단일 혹은 여러 값 반환 가능
-- ANY, SOME, ALL, IN, EXISTS 연산자 등을 사용함
-- IN과 EXISTS는 유사한데 성능적인 측면에서 EXISTS가 더 나음..?
SELECT ranks, movie_name, sale_amt
  FROM box_office
 WHERE YEAR(RELEASE_DATE) = 2019
   AND sale_amt >= ( SELECT MAX(sale_amt)
                       FROM box_office
                      WHERE YEAR(release_date) = 2018
                   );


-- 9-19
-- 오류가 발생함. 
-- 서브쿼리가 반환하는 로우가 3개인데, 이것을 WHERE 절 내에서 비교할 수 없어서.
SELECT ranks, movie_name, sale_amt
  FROM box_office
 WHERE YEAR(RELEASE_DATE) = 2019
   AND sale_amt >= ( SELECT sale_amt
                       FROM box_office
                      WHERE YEAR(release_date) = 2018
                        AND ranks BETWEEN 1 AND 3
                   );
 
       
-- 9-20
-- 서브쿼리가 반한하는 게 많지만 ANY 연산자 덕분에 오류가 안 남
SELECT ranks, movie_name, sale_amt
  FROM box_office
 WHERE YEAR(RELEASE_DATE) = 2019
   AND sale_amt >= ANY ( SELECT sale_amt
                           FROM box_office
                          WHERE YEAR(release_date) = 2018
                            AND ranks BETWEEN 1 AND 3
                       );
       
-- 9-21
-- ALL도 마찬가지. 
SELECT ranks, movie_name, sale_amt
  FROM box_office
 WHERE YEAR(RELEASE_DATE) = 2019
   AND sale_amt >= ALL ( SELECT sale_amt
                           FROM box_office
                          WHERE YEAR(release_date) = 2018
                            AND ranks BETWEEN 1 AND 3
                       );
       
       
-- 9-22
SELECT ranks, movie_name, director
  FROM box_office
 WHERE YEAR(RELEASE_DATE) = 2019
   AND movie_name IN ( SELECT movie_name
                       FROM box_office
                      WHERE YEAR(release_date) = 2018
                   );
       
-- 9-23
SELECT ranks, movie_name, director
  FROM box_office
 WHERE YEAR(RELEASE_DATE) = 2019
   AND (movie_name, director) IN ( SELECT movie_name, director
                                     FROM box_office
                                    WHERE YEAR(release_date) = 2018
                                 );
       
-- 9-24
SELECT ranks, movie_name, release_date, sale_amt, rep_country
  FROM box_office
 WHERE YEAR(RELEASE_DATE) = 2019
   AND ranks BETWEEN 1 AND 100
   AND rep_country NOT IN ( SELECT rep_country
                              FROM box_office
                             WHERE YEAR(release_date) = 2018
                               AND ranks BETWEEN 1 AND 100
                          );
 
       
-- 9-25
-- EXISTS : 값이 존재하는가. > 성능 면에서는 IN보다는 유리하다. 
-- SELECT 이름보다는 조인 조건이 더 중요. 따라서 컬럼 이름은 아무거나 써도 됨?
SELECT ranks, movie_name, director
  FROM box_office a
 WHERE YEAR(RELEASE_DATE) = 2019
   AND EXISTS ( SELECT 1
                  FROM box_office b
                 WHERE YEAR(release_date) = 2018
                   AND a.movie_name = b.movie_name
              );
       
       
-- 9-26
SELECT ranks, movie_name, release_date, sale_amt, rep_country
  FROM box_office a
 WHERE YEAR(RELEASE_DATE) = 2019
   AND ranks BETWEEN 1 AND 100
   AND NOT EXISTS ( SELECT 1
                      FROM box_office b
                     WHERE YEAR(release_date) = 2018
                       AND ranks BETWEEN 1 AND 100
                       AND a.rep_country = b.rep_country
                  );
       
       
-- 1ºÐ ÄûÁî 2
USE world;

SELECT a.name, a.district, a.population, a.countrycode, 
       ( SELECT CONCAT(b.name, ' / ', b.continent) 
           FROM country b
          WHERE a.countrycode = b.code 
       ) countryname
FROM city a;


-- 1ºÐ ÄûÁî 3
USE mywork;

SELECT ranks, movie_name, director
  FROM box_office a
 WHERE YEAR(release_date) = 2019
   AND EXISTS ( SELECT 1
                  FROM box_office b
                 WHERE YEAR(b.release_date) = 2018
                   AND a.movie_name = b.movie_name
                   AND a.director   = b.director
              );



-- Self Check 1.
USE mywork;

SELECT YEAR(a.release_date), a.movie_name, a.sale_amt
  FROM box_office a, 
       ( SELECT AVG(sale_amt) avg_amt
           FROM box_office
          WHERE ranks = 1
       ) b
 WHERE a.ranks = 1
   AND a.sale_amt > b.avg_amt
 ORDER BY 1;
 
 
-- Self Check 2.
SELECT k.dept_no, a.emp_no, a.salary, k.sal
  FROM salaries a
      ,( SELECT b.dept_no,  MAX(c.salary) sal
           FROM dept_emp b
          INNER join salaries c
             ON b.emp_no = c.emp_no
          WHERE SYSDATE() BETWEEN c.from_date AND c.to_date
          GROUP BY 1 
        ) k
 WHERE a.salary = k.sal
 ORDER BY 1;


-- Self Check 3.
SELECT years, 
       SUM(CASE WHEN months BETWEEN  1 AND  3 THEN sal_amt ELSE 0 END) qt1_amt,
       SUM(CASE WHEN months BETWEEN  4 AND  6 THEN sal_amt ELSE 0 END) qt2_amt,
       SUM(CASE WHEN months BETWEEN  7 AND  9 THEN sal_amt ELSE 0 END) qt3_amt,
       SUM(CASE WHEN months BETWEEN 10 AND 12 THEN sal_amt ELSE 0 END) qt4_amt
 FROM (      
        SELECT YEAR(release_date) years, 
               MONTH(release_date) months, 
               SUM(sale_amt) sal_amt
          FROM box_office
         WHERE YEAR(release_date) IN (2018,2019)
         GROUP BY 1, 2
      ) a
 GROUP BY 1
 ORDER BY 1;
 
 
 
-- Self Check 4 
SELECT COUNT(*)
  FROM employees a
 WHERE NOT EXISTS ( SELECT 1
                      FROM dept_emp b
                    WHERE SYSDATE() BETWEEN b.from_date AND b.to_date
                      AND a.emp_no = b.emp_no
                  ) ;
