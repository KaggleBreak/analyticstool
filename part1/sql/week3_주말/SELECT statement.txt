/*****************************************************************************************************/
/* SELECT 문 데이터 가져오기의 축복 */
/* 1. 강력한 SELECT문을 경험하고, 테이블 안의 중요한 정보에 대한 접근 방법을 배우게 됩니다.
   2. WHERE, AND 그리고 OR을 사용해서 원하느 데이터를 얻고 필요없는 데이터는 표시하지 않는 방법을 배우게 됩니다. */
/*****************************************************************************************************/

/* p.97 */
/* 연습문제 */
/* 헤드퍼스트 라운지에서 메뉴에 과일 음료를 추가하려 합니다. 1장에서 배운 내용을 가지고, 이 페이지의 테이블을 만들고 아래 데이터를 추가하세요.
   이 테이블은 test라는 데이터베이스의 일부입니다. drinks는 easy_drinks라는 테이블을 가지고 있고, 
   테이블에는 두 개의 원료만을 이용해서 만드는 음료들의 제조법이 포함되어 있습니다. */

USE test;
/* 1) easy_drinks 데이터베이스 만들기 */
CREATE TABLE easy_drinks (drink_name VARCHAR(16), main VARCHAR(20), AMOUNT1 DEC(3,1), second VARCHAR(20), amount2 DEC(4,2), directions VARCHAR(250));
/* DECIMAL Type */
/* In a DECIMAL column declaration, the precision and scale can be (and usually is) specified; for example: 
   ex) salary DECIMAL(5,2)
=> In this example, 5 is the precision and 2 is the scale. The precision represents the number of significant digits that are stored for values, 
   and the scale represents the number of digits that can be stored following the decimal point. 
   Standard SQL requires that DECIMAL(5,2) be able to store any value with five digits and two decimals, 
   so values that can be stored in the salary column range from -999.99 to 999.99. */

/* 잘 만들어졌는지 확인 */
SELECT * FROM easy_drinks;
/* 데이터 집어넣기 */
INSERT INTO easy_drinks
VALUES
('Blackthorn', 'tonic water', 1.5, 'pineapple juice', 1, 'stir with ics, strain into cocktail glass with lemon twist'),
('Blue Moon', 'soda', 1.5, 'blueberry juice', 0.75, 'stir with ice, strain into cocktail glass with lemon twist'),
('Oh My Gosh', 'peach nectar', 1, 'pineapple juice', 1, 'stir with ice, strain into shot glass'),
('Lime Fizz', 'Sprite', 1.5, 'lime juice', 0.75, 'stir with ice, strain into cocktail glass'),
('Kiss on the Lips', 'cherry juice', 2, 'apricot nectar', 7, 'serve over ice with straw'),
('Hot Gold', 'peach nectar', 3, 'orange juice', 6, 'pour hot orange juice in  mug and add peach nectar'),
('Lone Tree', 'soda', 1.5, 'cherry juice', 0.75, 'stir with ice, strain into cocktail glass'),
('Greyhound', 'soda', 1.5, 'grapefruit juice', 0.75, 'serve over ice, strain into cocktail glass'),
('Indian Summer', 'apple juice', 2, 'hot tea', 6, 'add juice to mug and top off with hot tea'),
('Bull Frog', 'iced tea', 1.5, 'lemonade', 5, 'serve over ice with lime slice'),
('Soda and It', 'soda', 2, 'grape juice', 1, 'shake in cocktail glass, no ice');
SELECT * FROM easy_drinks;

/* p.98 음료 이름 맞추기 */
/* 지금 생성한 easy_drinks 테이블을 사용해서 아래의 쿼리를 실행하보세요. 
   결과값으로 무엇이 나오는지 작성해보세요 */
SELECT * FROM easy_drinks WHERE main = 'Sprite';               /* Lime Fizz */
SELECT * FROM easy_drinks WHERE main = soda;                   /* No Result */   
SELECT * FROM easy_drinks WHERE amount2 = 6;                   /* Hot Gold, Indian Summer */   
SELECT * FROM easy_drinks WHERE second = "orange juice";       /* Hot Gold */
SELECT * FROM easy_drinks WHERE amount1 < 1.5;                 /* Oh My Gosh */
SELECT * FROM easy_drinks WHERE amount2 < '1';                 /* Blue Moon, Lime Fizz, Lone Tree, Greyhound */ 
SELECT * FROM easy_drinks WHERE main > 'soda';                 /* Blackthorn, Lime Fizz */ 
SELECT * FROM easy_drinks WHERE amount1 = '1.5';               /* Blackthorn, Blue Moon, Lime Fizz, Lone Tree, Greyhound, Bull Frog */

/* p.102 데이터 타입을 알아내는 방법 */
/* 옳바른 WHERE 절을 작성하려면, 각 데이터 타입의 형식이 맞아야 합니다.
   주로 데이터 타입을 어떻게 나타내는지를 살펴봅시다. */
  
/* 1. 따옴표 사용  : CHAR, VARCHAR, DATE, DATETIME, TIME, TIMESTAMP, BLOB
   2. 따옴표 사용X : DEC, INT */
   
/* p.109 특정 데이터 SELECT */
/* 원하는 열만을 SELECT하는 방법을 알아야 합니다. 
   이 SELECT 쿼리를 실행하기 전에, 결과 테이블이 어떨지 그려보세요 */
SELECT drink_name, main, second FROM easy_drinks WHERE main = 'soda';

/* p.112 연필을 깎으며 */
/* Kiss on the Lips를 가져오는 방법들 */
/* kiss on the Lips를 가져오는 SELECT 문을 네 개 작성해보세요 */
SELECT drink_name FROM easy_drinks WHERE second = 'apricot nectar';
SELECT drink_name FROM easy_drinks WHERE amount2 = 7;
SELECT drink_name FROM easy_drinks WHERE directions = 'serve over ice with straw';
SELECT drink_name FROM easy_drinks WHERE drink_name = 'Kiss on the Lips';
/* 위 방법은 거의 사용하지 않는 방법이지만 원하는 결과를 반환,
   또 drink_name 열에 잘못된 문자가 있는지를 확인할 때 사용 가능 */
   
/* Bull Frog를 가져오는 SELECT문을 세 개 작성해 보세요 */
SELECT drink_name FROM easy_drinks WHERE main='iced tea';
SELECT drink_name FROM easy_drinks WHERE second='lemonade';
SELECT drink_name FROM easy_drinks WHERE directions='serve over ice with lime slice';

/* p.121 숫자형 값 찾기 */
/* easy_drinks 테이블에서 소다수를 1온스 이상 포함한 음료수를 하나의 쿼리로 모두 찾고 싶다고 한다. */
SELECT drink_name FROM easy_drinks WHERE main='soda' AND amount1 = 1.5;
SELECT drink_name FROM easy_drinks WHERE main='soda' AND amount1 = 2;

/* p.123 하나면 충분합니다 */
/* 두 개의 쿼리를 사용하는 것은 시간 낭비이고 1.75온스나 3온스를 포함한 음료수는 두 개의 쿼리로는 찾을 수 없는 음료수입니다. 
   이 방법 대신 크거나 같다 기호를 사용할 수 있습니다. */
SELECT drink_name FROM easy_drinks WHERE main='soda' AND amount1 > 1;

/* p.124~125 비교 연산자 */
/* = : 같다, <> : 같지 않다 , < : 작다, > : 크다, <= : 작거나 같다, >= : 크거나 같다 */

/* p.126 비교 연산자를 사용하여 숫자형 데이터 찾기 */
/* 헤드퍼스트 라운지에 음료수의 가격과 영양 정보를 담고 있는 테이블이 있습니다.
   라운지에서는 이익을 늘리기 위해 비싸고 칼로리가 낮은 음료수를 주력 상품으로 하려합니다. 
   drink_info 테이블에서 3.5달러 이상이고 50칼로리 이하의 음료수를 찾는데 비교 연산자를 사용합니다. */
/* carbs : 각 음료수에 함유된 탄수화물(carbohydrate)의 총량
   calories : 각 음료수에 함유된 칼로리                     */
CREATE TABLE drink_info (drink_name VARCHAR(16), cost DEC(2,1), carbs DEC(3,1), color VARCHAR(20), ice VARCHAR(4), calories INT(4));
/* 잘 만들어졌는지 확인 */
SELECT * FROM drink_info;
/* 데이터 집어넣기 */
INSERT INTO drink_info
VALUE
('Blackthorn', 3, 8.4, 'Yellow', 'Y', 33),
('Blue Moon', 2.5, 3.2, 'blue', 'Y', 12),
('Oh My Gosh', 3.5, 8.6, 'orange', 'Y', 12),
('Lime Fizz', 2.5, 5.4, 'green', 'Y', 24),
('Kiss on the Lips', 5.5, 42.5, 'purple', 'Y', 171),
('Hot Gold', 3.2, 32.1, 'orange', 'N', 135),
('Lone Tree', 3.6, 4.2, 'red', 'Y', 17),
('Greyhound', 4, 14, 'yellow', 'Y', 50),
('Indian Summer', 2.8, 7.2, 'brown', 'N', 30),
('Bull Frog', 2.6, 21.5, 'tan', 'Y', 80),
('Soda and It', 3.8, 4.7, 'red', 'N', 19);
SELECT * FROM drink_info;

SELECT drink_name FROM drink_info WHERE cost >= 3.5 AND calories < 50;

/* p.127 연필을 깎으며 */
/* 여러 조건을 결합한 쿼리를 만들어 봅시다. 다음의 정보를 반환하는 쿼리를 작성해보세요.
   각 쿼리의 결과도 작성하세요. */
/* 1. 얼음이 들어가고, 색깔은 노란색이며 33칼로리 이상인 음료수의 가격 */
SELECT drink_name, cost FROM drink_info WHERE ice = 'Y' AND color = 'yellow' AND calories >= 33;
/* 가격 : 3달러, 4달러 */
/* 2. 탄수화물을 4그램 이상 포함하지 않고 얼음을 사용하는 음료수의 이름과 색깔 */
SELECT drink_name, color FROM drink_info WHERE carbs <= 4 AND ice='Y';
/* 음료수의 이름과 색깔 : Blue Moon, blue */
/* 3. 칼로리가 80 이상인 각 음료수의 가격 */
SELECT drink_name, cost FROM drink_info WHERE calories >= 80;
/* 가격 : 5.5달러, 3.2달러, 2.6달러 */
/* 4. Greyhound와 Kiss on the Lips라는 음료수와 각 음료수의 색깔과 얼음의 사용 여부를 음료수의 이름을 사용하지 않고 쿼리 */
/* 음료수의 이름, 음료수의 색깔, 그리고 얼음사용여부가 사용되는 변수 */
/* 가장 근사하게 공통되는 조건은 3.8달러 이상 */
SELECT drink_name, color, ice FROM drink_info WHERE cost >= 3.8;
/* Kiss on the Lips, Greyhound */

/* p.129 비교 연산자를 이용한 문자열 처리 */
/* CHAR과 VARCHAR 같은 문자열 열에서 문자열을 비교하는 것도 비슷하게 동작합니다. 
   비교 연산자는 모든 것을 알파벳 순서로 비교합니다. */
SELECT drink_name FROM drink_info WHERE drink_name >= 'L' AND drink_name < 'M';

/* p.130 함유물 찾기 */
/* 한 바텐더에게 체리 쥬스가 함유된 칵테일을 만들어 달라는 주문이 들어왔습니다.
   그 칵테일을 찾는 데에 다음 두 개의 쿼리를 사용할 수 있습니다. */
SELECT drink_name FROM easy_drinks WHERE main='cherry juice';   /* kiss on the Lips */
SELECT drink_name FROM easy_drinks WHERE second='cherry juice'; /* Lone Tree */

/* p.131 죽는냐 사느냐 */
/* 두 개의 쿼리를 OR로 결합할 수 있습니다. 
   이 조건은 두 조건 중 하나가 만족하면 그것을 결과로 반환합니다. 
   그래서 두 개의 쿼ㅣ를 사용하는 대신 OR로 다음의 결과를 두 쿼리로 결합할 수 있습니다. */
SELECT drink_name FROM easy_drinks WHERE main='cherry juice' OR second='cherry juice';

/* 연필을 깎으며 */
/* 아래 두 개의 SELECT에서 필요없는 부분을 지우고 OR을 추가하여 하나의 SELECT문으로 만드세요 */
/* SELECT drink_name FROM easy_drinks WHERE main='orange juice';
   SELECT drink_name FROM easy_drinks WHERE main='apple juice'; */
SELECT drink_name FROM easy_drinks WHERE main='orange juice' OR main='apple juice';

/**************************************************** 완전 중요!!!! ************************************************************************/
/* p.137 NULL을 찾으려면 IS NULL을 사용하세요 */
/* 직접 NULL을 사용할 수 없습니다. 하지만 키워드를 써서 NULL을 찾을 수 있습니다. 
   ex) SELECT drink_name FROM drink_info WHERE calories IS NULL;         */
   
/* p.139 한 단어를 써서 시간을 아껴야죠 : LIKE */
/* 캘리포니아에 너무 많은 도시가 있고, 잘못 입력한 문자가 있을 수도 있습니다. 앞에서와 같이 OR을 사용하는 방식은 시간이 
   너무 많이 걸립니다. 다행스럽게도, 시간을 아껴줄 LIKE라는 키워드가 있어서 와일드카드 문자와 같이 사용하려면 문자의 일부만으로 일치하는 결과를 찾아냅니다. 
   ex) SELECT * FROM my_contacts WHERE location LIKE '%CA'; */

/* p.140 LIKE 좀 더 살피기 */
/* LIKE는 와일드카드랑 잘 어울립니다. 첫 번째는 퍼센트 기호, %입니다. 이는 다수의 불특정 문자를 의미합니다. 
   ex) SELECT first_name FROM my_contacts WHERE first_name LIKE '%im'; : %는 다수의 불특정 문자를 대신하는 문자입니다. 
   ex) SELECT first_name FROM my_contacts WHERE first_name LIKE '_im'; : _는 단 하나의 불특정 문자를 대신하는 문자입니다. */

/* p.143 비교 연산자와 AND를 사용하여 범위 정하기 */
/* 헤드퍼스트 라운지의 사람들이 칼로리 함유량이 일정 범위 안에 있는 음료수를 찾습니다. 칼로리의 양이 30 이상 60 이하인 음료수의 이름을 
   찾으려면 어떤 쿼리문을 사용해야 할까요? */
SELECT drink_name FROM drink_info WHERE calories >= 30 AND calories <= 60;

/* p. 144 사실 더 좋은 방법이 있어요 */
/* BETWEEN 키워드를 대신 사용할 수 있습니다. 앞 장의 쿼리보다 더 짧고 결과는 같습니다. 시작과 끝(30과 60)e도 포함한다는 점에 주의하세요.
   BETWEEN은 <와 >이 아니고, <=와 => 기로를 사용하는 것과 같습니다. */
SELECT drink_name FROM drink_info WHERE calories BETWEEN 30 AND 60;

/* p. 145 연필을 깎으며 */
/* 1. 앞 페이지의 쿼리를 60 칼로리 초과, 30 칼로리 미만인 음료수의 이름을 찾는 쿼리로 변경하세요. */
SELECT drink_name FROM drink_info WHERE calories < 30 OR calories > 60;
/* 2. 문자열 BETWEEN을 사용해 봅시다. G~O로 시작하는 음료수의 이름을 찾는 쿼리를 작성하세요. */ 
SELECT drink_name FROM drink_info WHERE drink_name BETWEEN 'G' AND 'O';

/* p.147~148 */
/* OR을 여러 개 쓰지 말고, IN이라는 키워드를 사용해서 쿼리를 간단하게 할 수 있스빈다. 
   IN을 괄호 안에 여러 값과 함께 사용하세요. 
   ex) SELECT date_name FROM black_book WHERE rating IN ('innovative', 'fabulous', 'delightful', 'pretty good');
   
   좋지 않았던 데이트의 이름을 찾으려면 IN을 사용한 문장에 키워드 NOT을 붙이면 됩니다. NOT은 반대의 결과 즉, IN이 표시하는 집합과 일치하지 않는
   행을 반환합니다. 
   ex) SELECT date_name FROM black_book WHERE rating NOT IN ('innovative', 'fabulous', 'delightful', 'pretty good'); */
   
/* p.149 */
/* IN에서처럼 NOT을 BETWEEN이나 LIKE와 함께 사용할 수 있습니다. 
   기억해야 할 사항은 NOT이 WHERE 바로 다음에 나와야 한다는 것입니다. 
   ex) SELECT drink_name FROM drink_info WHERE NOT carbs BETWEEN 3 AND 5;
   NOT을 AND나 OR과 같이 사용하면 AND나 OR 바로 뒤에 나와야 합니다. 
   ex) SELECT date_name FROM black_book WHERE NOT date_name LIKE 'A%' AND NOT date_name LIKE 'B%'*/
    
/* p.150 ~ p.151 */
/* 아래의 WHERE 절을 가능한 간단하게 다시 작성해보세요. AND, OR, NOT, BETWEEN, LIKE, IN, IS NULL과 같이 비교 연산자를 사용할 수 있습니다.
   이 장에서 사용된 테이블을 다시 한번 살펴보세요. */
/* 1. SELECT drink_name FROM easy_drinks WHERE NOT amount1 < 1.50 */
SELECT drink_name FROM easy_drinks WHERE AMOUNT1 >= 1.50;
/* 2. SELECT drink_name FROM drink_info WHERE NOT ice = 'Y'; */
SELECT drink_name FROM drink_info where ice='N';
/* 3. SELECT drink_name FROM drink_info WHERE NOT calories < 20; */
SELECT drink_name FROM drink_info WHERE calories >= 20;
/* 4. SELECT drink_name FROM easy_drinks WHERE main='peach nectar' OR main='soda'; */
SELECT drink_name FROM easy_drinks WHERE main BETWEEN 'P' AND 'T';
/* 5. SELECT drink_name FROM drink_info WHERE NOT calories = 0; */
SELECT drink_name FROM drink_info WHERE calories > 0;
/* 6. SELECT drink_name FROM drink_info WHERE NOT carbs BETWEEN 3 AND 5; */
SELECT drink_name FROM drink_info WHERE carbs < 3 or carbs > 5;
/*****************************************************************************************************************************************/