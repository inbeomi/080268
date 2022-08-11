-- 7-1
USE world;

SELECT continent
  FROM country
 GROUP BY continent;
 

-- 7-2
SELECT continent, region
  FROM country
 GROUP BY continent, region
 ORDER BY 1, 2;
 

-- 7-3
SELECT continent, region
  FROM country
 GROUP BY 1, 2
 ORDER BY 1, 2;
 

-- 7-4
SELECT SUBSTRING(district,1,2) DO -- 첫 번째 위치에서 두 글자를 잘라옴
  FROM city
 WHERE countrycode = 'KOR'
 GROUP BY SUBSTRING(district,1,2)
 ORDER BY 1;
 

-- 7-5
-- 그룹화 대상 컬럼과 조화하는 컬럼이 일치해야 올바른 집계 쿼리가 가능함
-- 오류는 안나긴 하지만 서로 일치하게 컬럼들을 작성하자. 
SELECT continent
  FROM country
 GROUP BY region
 ORDER BY 1;
 

-- 7-6
SELECT DISTINCT continent -- 해당 컬럼의 고유한 값만 조회됨. GROUP BY 절을 사용한 것과 같은 효과를 냄
  FROM country;
  

-- 7-7
SELECT DISTINCT continent, region
  FROM country
 ORDER BY 1, 2;
 

-- 7-8
SELECT COUNT(*), COUNT(continent)
  FROM country;
  

-- 7-9
SELECT COUNT(*), COUNT(2)
  FROM country
 WHERE continent = 'Europe';
 
       
-- 7-10
SELECT COUNT(DISTINCT continent) -- 고유한 값들의 개수를 카운트함
  FROM country; 
  

-- 7-11
SELECT MAX(population), MIN(population), AVG(population) -- 최대, 최소, 평균
  FROM COUNTRY
 WHERE continent = 'Europe';
 

-- 7-12
SELECT SUM(population), VAR_POP(population), STDDEV_POP(population) -- 합계, 분산, 표준편차
  FROM COUNTRY
 WHERE continent = 'Europe';
 

-- 7-13
USE mywork;

-- 연도별 개봉 영화 편수 집계하기
SELECT YEAR(release_date) release_year, COUNT(*)
  FROM box_office
 GROUP BY YEAR(release_date)
 ORDER BY 1 DESC; 
 

-- 7-14
-- 2019년 개봉 영화의 유형별 최대, 최소 매출액과 전체 매출액 집계하기
SELECT movie_type, MAX(sale_amt), MIN(sale_amt), SUM(sale_amt)
  FROM box_office
 WHERE YEAR(release_date) = 2019
 GROUP BY movie_type
 ORDER BY 1;
 

-- 7-15
-- 2019년 개봉 영화 중 매출액이1억 원 이상인 영화의 분기별, 배급사별 개봉 영화 수와 매출액 집계하기
SELECT QUARTER(release_date) 분기, distributor 배급사, 
       COUNT(*) 영화편수, ROUND(SUM(sale_amt) / 100000000) 매출_억원
  FROM box_office
 WHERE 1=1 -- 이것은 왜 있는거지? 없어도 동일한 결과값이 반환됨.
   AND EXTRACT(YEAR FROM release_date) =  2019
   AND distributor IS NOT NULL
   AND sale_amt >= 100000000
 GROUP BY QUARTER(release_date), distributor
 ORDER BY 1, 2, 3;


-- 7-16
SELECT movie_type 영화유형, SUM(sale_amt) 금액
  FROM box_office
 WHERE YEAR(release_date) = 2019
   AND SALE_AMT > 10000000
 GROUP BY movie_type
 ORDER BY 1 DESC;
 
       
-- 7-17
SELECT movie_type 영화유형, SUM(sale_amt) 금액
  FROM box_office
 WHERE YEAR(release_date) = 2019
   AND SALE_AMT > 10000000
 GROUP BY movie_type WITH ROLLUP ; -- WITH ROLLUP으로 소계와 총계를 구함.
 
       
-- 7-18
SELECT MONTH(release_date) 월, 
       movie_type 영화유형, SUM(sale_amt) 금액
  FROM box_office
 WHERE YEAR(release_date) = 2019
   AND QUARTER(release_date) = 1
   AND SALE_AMT > 10000000
 GROUP BY MONTH(release_date), movie_type WITH ROLLUP ; -- GROUP BY에서 지정된 컬럼 별로 소계와 총계를 계산함
       
       
-- 7-19
SELECT movie_type 영화유형, SUM(sale_amt) 금액
  FROM box_office
 WHERE YEAR(release_date) = 2019
 GROUP BY movie_type WITH ROLLUP;
       
       
-- 7-20
SELECT MONTH(release_date) 월, movie_type 영화유형, SUM(sale_amt) 금액, GROUPING(movie_type) -- GROUPING은 WITH ROLLUP으로 반환된 값은 1로, 아닌 것(기존 데이터)
   AND SALE_AMT > 10000000 
 GROUP BY MONTH(release_date), movie_type WITH ROLLUP;
       
       
-- 7-21
SELECT IF(GROUPING(movie_type) = 1, '전체합계', movie_type) 영화유형, -- 1은 WITH ROLLUP으로 반환된 값이라 NULL을 '전체합계'로 표현하기 위함
       SUM(sale_amt) 금액 
  FROM box_office
 WHERE YEAR(release_date) = 2019
 GROUP BY movie_type WITH ROLLUP;
 
       
-- 7-22
SELECT EXTRACT(YEAR_MONTH FROM release_date) 개봉년월, 
       COUNT(*) 개봉편수
  FROM box_office
 WHERE ranks BETWEEN 1 AND 10
 GROUP BY EXTRACT(YEAR_MONTH FROM release_date)
 ORDER BY 1 DESC;
       
       
-- 7-23
SELECT EXTRACT(YEAR_MONTH FROM release_date) 개봉년월, 
       COUNT(*) 개봉편수
  FROM box_office
 WHERE 1=1
   AND ranks BETWEEN 1 AND 10
   AND COUNT(*) > 1
 GROUP BY EXTRACT(YEAR_MONTH FROM release_date)
 ORDER BY 1 DESC;
       
       
-- 7-24
SELECT EXTRACT(YEAR_MONTH FROM release_date) 개봉년월, 
       COUNT(*) 개봉편수
  FROM box_office
 WHERE 1=1
   AND ranks BETWEEN 1 AND 10
 GROUP BY EXTRACT(YEAR_MONTH FROM release_date)
 HAVING COUNT(*) > 1 -- 집계 함수 결과 값에 대한 조건은 HAVING 절로 주어야 함.
 ORDER BY 1 DESC;
       

-- 7-25
SELECT EXTRACT(YEAR_MONTH FROM release_date) 개봉년월, 
       COUNT(*) 개봉편수,
       ROUND(SUM(sale_amt) / 100000000) 금액_억원
  FROM box_office
 WHERE 1=1
   AND ranks BETWEEN 1 AND 10
 GROUP BY EXTRACT(YEAR_MONTH FROM release_date)
 HAVING ROUND(SUM(sale_amt) / 100000000) >= 1500
 ORDER BY 1 DESC;
 
 
 
-- 7-26
SELECT MONTH(release_date) 월, 
       movie_type 영화유형, SUM(sale_amt) 금액
  FROM box_office
 WHERE YEAR(release_date) = 2019
   AND QUARTER(release_date) = 1
   AND SALE_AMT > 10000000
 GROUP BY MONTH(release_date), movie_type WITH ROLLUP 
 HAVING GROUPING(movie_type) = 1;
       

-- 1분퀴즈 1
USE world;

SELECT countrycode, COUNT(*)
  FROM city
 GROUP BY countrycode;

-- 1분퀴즈 2
USE world;

SELECT continent, COUNT(*)
  FROM country 
 GROUP BY continent WITH ROLLUP;


-- Self Check1
USE world;

SELECT continent, SUM(surfacearea), SUM(population), COUNT(*)
  FROM country
 GROUP BY continent
 ORDER BY 2 DESC, 3 DESC;

-- Self Check2
USE mywork;

SELECT CASE WHEN ranks BETWEEN 1 AND 10 THEN '상위10'
            ELSE '나머지'
       END 순위별, SUM(sale_amt)
  FROM box_office
 WHERE YEAR(release_date) = 2019
 GROUP BY 1;

-- Self Check3
SELECT rep_country, SUM(audience_num)
  FROM box_office
 WHERE YEAR(release_date) = 2019
 GROUP BY rep_country WITH ROLLUP
 HAVING SUM(audience_num) >= 500000;

-- Self Check4
SELECT YEAR(release_date), director, SUM(audience_num), COUNT(*)
  FROM box_office
 WHERE YEAR(release_date) >= 2015
   AND audience_num >= 1000000
 GROUP BY 1, 2
HAVING COUNT(*) > 1
 ORDER BY 1, 2;

