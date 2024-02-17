select * from Manufacturer;
select * from ServicePhoto;
select * from [Service];
select * from ClientService;
select * from client;
select * from Gender;
select * from Tag;
select * from TagOfClient;
select * from ProductSale;
select * from ProductPhoto;
select * from Product;
select * from CategoryProduct;

--ЛАБОРАТОРНАЯ РАБОТА №5

--Выведите список всех предоставленных услуг за определенный
--период времени (сентябрь 2019 года), отсортированный по дате оказания услуги.

SELECT Title FROM Service 
WHERE id IN (
SELECT ServiceId FROM ClientService 
WHERE StartTime BETWEEN '01.09.2019' AND '30.09.2019');

--Список всех услуг, содержащие слово «замена» с указанием их
--стоимости.

SELECT Title,
		 Cost FROM Service 
WHERE Title LIKE '%Замена%';

--Список продаж товара, наименование которого начинается на
--«Учебник английского языка», с указанием даты продажи, отсортированный по
--дате продажи и количеству

SELECT title, 
		 saledate,
		 Quantity from ProductSale
join product on product.id = ProductSale.ProductID
where ProductID in (
select ID from Product 
where Title like 'Учебник английского языка%') 
order by SaleDate, Quantity;

--Выведите среднюю продолжительность услуги в минутах;

select avg(Duration / 60) as AvgDuration from Service;

--Количество различных поставщиков, осуществляющих поставки
--товаров (из таблицы Product);

select count(ManufacturerID) as CountManufacturerProduct from Product
where id in (
select productid from productsale);

--Дату рождения самого молодого и самого взрослого клиента
--компании;

select min(Birthday) as MinBirthday, 
		 max(Birthday) as MaxBirthday from client;

--Количество проданных товаров за ноябрь 2019 года;

select sum(Quantity) as QuantitySaleProductNovember2019 from productsale
where SaleDate between '01.11.2019' and '30.11.2019';

--Выведите количество товаров, стоимость которых более 1500 руб. с
--учетом скидки;

select count(id) as 'CountProductCostMore1500WithDiscount' from Service 
where cost * (1 - Discount) > 1500;

--Выведите количество клиентов мужского и женского пола;

select count(id) as CountClients,
	   gendercode as Gender from client
group by gendercode

--Выведите средний возраст клиентов.

select avg(year (getdate()) - year (Birthday)) as AvgAge from client;

--Выведите список товаров (ID и дату последней продажи), которые
--были проданы 2 и более раз за 2019 год.

select productid,
	   max(saledate) as LastSaleDate,
	  count(productID) as CountSale from productsale
where SaleDate between '01.01.2019' and '31.12.2019'
group by productid
having count(productID) >= 2;

--Выведите список поставщиков (ID), которые поставляют более
--одного товара. Отсортируйте по количеству поставляемых товаров в порядке
--убывания.

select Manufacturerid,
count(Manufacturerid) as CountProduct
from product
group by Manufacturerid
having count(Manufacturerid) > 1
order by count(Manufacturerid) desc;

--ЛАБОРАТОРНАЯ РАБОТА №6

--Сформулируйте запрос, возвращающий все заказы, в которых
--содержится товар «Dive in! Blue»select * from ProductSalewhere ProductID = (select id from product where title like 'Dive in! Blue');--Выведите сведения о предоставлении услуги под названием
--«Ремонт компрессора кондиционера»

select lastname, title, StartTime from ClientServicejoin [SERVICE] on ClientService.ServiceId = [Service].IDjoin Client on ClientService.ClientId = Client.idwhere SERVICEID in (select id from [SERVICE]where title like 'Ремонт компрессора кондиционера');--Сформулируйте запрос, возвращающий список всех клиентов,
--совершивших заказ за определенный период времени (первое полугодие 2019
--года). Отсортируйте список по фамилии клиента.select * from client where id in (select clientid from ClientServicewhere StartTime between '01.01.2019' and '30.06.2019')order by LastName;--Сформулируйте запрос, возвращающий список всех товаров,
--которые были проданы в текущем месяце 2019 года.

select title from Product
where id in (
select productid from ProductSale
where MONTH(SaleDate) = MONTH(GETDATE()) AND YEAR(SaleDate) = '2019');

--Сформулируйте запрос, возвращающий список услуг, которые
--были предоставлены более трех раз;

SELECT Title FROM Service
WHERE Id IN (SELECT ServiceId FROM ClientService 
GROUP BY ServiceId
HAVING COUNT(ServiceId) > 3);

--Выведите название и стоимость самого дорогого и самого дешевого
--товара;SELECT Title, 	   Cost FROM ProductWHERE Cost =(SELECT MIN(Cost) FROM Product) ORCost = (SELECT MAX(Cost) FROM Product); --Выведите название и продолжительность услуги с максимальной
--скидкой. Отсортируйте по продолжительности услуги от большего к меньшему;SELECT Title,	   Duration,	   discount FROM ServiceWHERE Discount = (SELECT MAX(Discount) FROM Service)ORDER BY Duration DESC;--Выведите название и стоимость самой дешевой услуги с учетом
--скидки.

select title,
	   (cost * (1 - Discount)) as CostWithDiscount from Service
where cost * (1 - Discount) = (
select min(cost * (1 - Discount)) from Service);

--ЛАБОРАТОРНАЯ РАБОТА №7

--Выведите список всех клиентов с указанием ФИО (в один столбец,
--разделенные пробелами) и контактных данных, а также количество оказанных
--ему услуг и дату последней услуги. Обратите внимание, что в списке должны
--быть выведены все клиенты, даже те, которым услуги не были оказаны ни разу.
--Отсортируйте по количеству предоставленных услуг.SELECT LastName +  ' ' + FirstName + ' ' +  Patronymic as FullName,	   Email, 	   Phone,	   count (clientid) as CountService,	   max (StartTime) as LastDate from clientleft join ClientService on client.id = ClientService.ClientIdgroup by FirstName, 	     LastName, 		 Patronymic, 		 Email, 		 Phone;--Выведите сведения о востребованности товаров. А именно:
--наименование, общая стоимость продаж товара, общее количество проданного
--товара, количество продаж товара, дата последней продажи. Отсортируйте –
--сначала самые востребованные товары.

Select title,
	   sum(Quantity * cost) as AllPriceSaleProduct,
	   sum(Quantity) as AllCountSaleProduct, 
	   count(Quantity) as CountSaleProduct,
	   max(SaleDate) as SaleDateLast
	   from Product
left join ProductSale on product.id = ProductSale.ProductID
group by title,
		 cost
order by AllCountSaleProduct desc;

--Выведите сведения об общей выручке от оказанных услуг (с учетом
--скидки на услугу), количестве оказанных услуг и средней продолжительности
--услуги в минутах за первое и второе полугодие 2019 года.

--За первое полугодие

SELECT SUM(cost * (1 - Discount)) AS SumSaleService,
	   COUNT(ClientService.ID) AS CountSaleService,
	   avg(duration / 60) as AvgDurationServiceInMinute FROM ClientService
JOIN Service ON ClientService.ServiceId = Service.ID
where YEAR(StartTime) = 2019 and MONTH(StartTime) between 1 and 6;

--За второе полугодие

SELECT SUM(cost * (1 - Discount)) AS SumSaleService,
	   COUNT(ClientService.ID) AS CountSaleService,
	   avg(duration / 60) as AvgDurationServiceInMinute FROM ClientService
JOIN Service ON ClientService.ServiceId = Service.ID
where YEAR(StartTime) = 2019 and MONTH(StartTime) between 7 and 12;

--Сформируйте статистику о самых востребованных услугах среди 
--клиентов от 18 до 25 лет, и от 26 до 35 лет. Выведите наименование услуг, 
--количество предоставленных услуг указанному диапазону клиентов.--Для клиентов от 18 до 25 лет

SELECT Title AS ServiceTitle,
	   COUNT(ClientService.ID) AS CountService FROM ClientService
JOIN Service ON ClientService.ServiceId = Service.ID
JOIN Client ON ClientService.ClientId = Client.ID
WHERE YEAR(GETDATE()) - YEAR(Birthday) BETWEEN 18 AND 25
GROUP BY Title
ORDER BY CountService DESC;

--Для клиентов от 26 до 35 лет

SELECT Title AS ServiceTitle,
	   COUNT(ClientService.ID) AS CountService FROM ClientService
JOIN Service ON ClientService.ServiceId = Service.ID
JOIN Client ON ClientService.ClientId = Client.ID
WHERE YEAR(GETDATE()) - YEAR(Birthday) BETWEEN 26 AND 35
GROUP BY Title
ORDER BY CountService DESC;

--Для формирования системы лояльности для клиентов, выведите 
--сведения о клиентах, день рождения которых в текущем месяце. Список должен 
--содержать ФИО, дату рождения, Email, количество совершенных заказов на 
--предоставление услуги, общую стоимость предоставленных услуг.

SELECT LastName +  ' ' + FirstName + ' ' +  Patronymic as FullName,
	   Birthday,
	   Email,
	   COUNT(ClientService.ID) AS CountServices,
	   SUM(cost) AS SumSaleService FROM ClientService
right JOIN Client ON ClientService.ClientId = Client.ID
left JOIN Service ON ClientService.ServiceId = Service.ID
WHERE MONTH(Birthday) = MONTH(GETDATE())
GROUP BY FirstName,
		 LastName,
		 Patronymic,
		 Birthday,
		 Email;

--ЛАБОРАТОРНАЯ РАБОТА №8

--Выведите каталог актуальных товаров. А именно, все сведения о 
--товаре, его производителе, количестве продаж. Выводить стоит только 
--те товары, статус которых – «Актуален».create view VW_ProductListasSELECT Title as TitleProduct,
	   Cost as CostProduct,
	   Description as DescriptionProduct,
	   MainImagePath as MainImagePathProduct,
	   Name as NameManufacturer,
	   count(ProductSale.productid) as QuantitySale FROM ProductSale 
right JOIN Product ON ProductSale.ProductID = Product.ID
JOIN Manufacturer ON Product.ManufacturerID = Manufacturer.ID
WHERE IsActive = 'True'
GROUP BY Product.ID,
		 Title,
		 Cost,
		 Description,
		 MainImagePath,
		 Name;

select * from VW_ProductList;

--Выведите сведения о услугах, оказанных в июне 2019 года. А именно: 
--Фамилию и инициалы клиента (воспользуйтесь функцией LEFT), 
--Название услуги, Стоимость с учетом скидки, Дату начала 
--предоставления услуги, Продолжительность в минутах, Дату 
--окончания предоставления услуги (воспользуйтесь функцией 
--DateAdd).

create view VW_ServiceListas
SELECT LastName + ' ' + LEFT(FirstName, 1) + '. ' + LEFT(Patronymic, 1) + '.' AS FullName,
	   Title AS TitleService,
	   cost * (1 - Discount) AS CostWithDiscount,
	   StartTime AS ServiceStartTime,
	   Duration / 60 AS ServiceDurationMinutes,
	   DATEADD(SECOND, Duration, StartTime) AS ServiceEndTime FROM ClientService
JOIN Service ON ServiceId = Service.ID
JOIN Client ON ClientId = Client.ID
WHERE YEAR(StartTime) = 2019 AND MONTH(StartTime) = 6;

select * from VW_ServiceList;

--Выведите сведения о всех продажах товаров: Наименование товара и 
--производитель по шаблону «Название_товара; Производитель: 
--Название_производителя»,
--Дата продажи, Количество проданного товара.

create view VW_ProductSaleListas
SELECT Title + '; Производитель: ' + Name AS Product,
	   SaleDate,
	   sum(Quantity) AS QuantitySale FROM ProductSale
JOIN Product ON ProductSale.ProductID = Product.ID
JOIN Manufacturer ON Product.ManufacturerID = Manufacturer.ID
group by title,
		 name,
		 SaleDate;

select * from VW_ProductSaleList;

--ЛАБОРАТОРНАЯ РАБОТА №9

--Если в базе данных есть клиенты, у которых день рождения в 
--текущем месяце, выведите сообщение «В текущем месяце есть 
--именинники среди клиентов компании!». В противном случае, 
--выведите соответствующее сообщение.

IF EXISTS (SELECT * FROM Client WHERE MONTH(Birthday) = MONTH(GETDATE()))
    PRINT 'В текущем месяце есть именинники среди клиентов компании!'
ELSE
    PRINT 'В текущем месяце нет именинников среди клиентов компании.';

--Дополните предыдущие условие и выведите количество
--именинников в текущем месяце.

DECLARE @CountOfBirthdayPeople INT;

	SELECT @CountOfBirthdayPeople = COUNT(Birthday) FROM Client
	WHERE MONTH(Birthday) = MONTH(GETDATE());
	IF @CountOfBirthdayPeople > 0
	   PRINT 'В текущем месяце есть ' + CAST (@CountOfBirthdayPeople AS NVARCHAR(10)) + ' именинников среди клиентов компании!'
	ELSE
	   PRINT 'В текущем месяце нет именинников среди клиентов компании.';

--Если общая сумма от продаж товаров (количество проданного 
--товара * стоимость) менее 200 000 руб., вывести сообщение 
--«Выручка составила – ‘Сумма продаж’. Нужно больше продаж!». 
--Иначе - «Выручка составила – ‘Сумма продаж’. Не плохо, но могли 
--бы и лучше!».

DECLARE @SumSale DECIMAL(10, 2);

	SELECT @SumSale = SUM(Quantity * Cost) FROM ProductSale
	JOIN Product ON ProductSale.ProductID = Product.ID;
	IF @SumSale < 200000
	   PRINT 'Выручка составила – ' + CAST(@SumSale AS NVARCHAR(20)) + ' руб. Нужно больше продаж!'
	ELSE
	   PRINT 'Выручка составила – ' + CAST(@SumSale AS NVARCHAR(20)) + ' руб. Не плохо, но могли бы и лучше!';

--Выведите список товаров: Название, Стоимость, Актуальность 
--(Если атрибут IsActive = TRUE, то вывести «Актуален», если 
--FALSE – «Не для продажи»)SELECT Title,
	   Cost,
	   CASE
	   WHEN IsActive = 'True' THEN 'Актуален'
	   WHEN IsActive = 'False' THEN 'Не для продажи'
    END 
	as IsActive FROM Product;

--Выведите список услуг: Название, Стоимость с учетом скидки, 
--Длительность (Если услуги длится менее 60 минут -
--Непродолжительная услуга, от 60 до 120 минут – Услуга средней 
--длительности, более 120 минут – Длительная услуга), 
--Длительность услуги в минутах. Отсортируйте список по 
--стоимости.

SELECT Title,
	   cost * (1 - Discount) AS CostWithDiscount,
	   CASE
	   WHEN Duration / 60 <= 60 THEN 'Непродолжительная услуга'
	   WHEN Duration / 60 > 60 AND  Duration / 60 <= 120 THEN 'Услуга средней длительности'
	   WHEN Duration / 60 > 120 THEN 'Длительная услуга'
	   END 
	   AS DurationCategory,
	   Duration / 60 AS DurationInMinutes FROM Service
ORDER BY CostWithDiscount;

--Выведите список клиентов: Фамилия И.О., Пол, Возраст, 
--Примечание (если клиент записан более 3ех раз на услугу –
--«Постоянный клиент», от 1 до 3ех – «Иногда заглядывает», 0 – «Ни 
--одной услуги не оказано. Как так?»
--Не забывайте, что у всех атрибутов должны быть наименования.

SELECT LastName + ' ' + LEFT(FirstName, 1) + '. ' + LEFT(Patronymic, 1) + '.' AS FullName,
	   GenderCode AS Gender,
	   DATEDIFF(YEAR, Birthday, GETDATE()) AS Age,
	   CASE
	   WHEN COUNT(ClientId) > 3 THEN 'Постоянный клиент'
	   WHEN COUNT(ClientId) BETWEEN 1 AND 3 THEN 'Иногда заглядывает'
	   ELSE 'Ни одной услуги не оказано. Как так?'
	   END
	   AS Comment FROM ClientService
right JOIN Client ON ClientService.ClientId = Client.ID
GROUP BY LastName,
		 FirstName,
		 Patronymic,
		 GenderCode,
		 Birthday;

--Не забывайте, что у всех атрибутов должны быть наименования.
--С использованием цикла добавьте в таблицу «Категория товара»
--10 строк по шаблону: Категория 1, Категория 2 … Категория 10.

DECLARE @Score INT = 1;

	WHILE @Score <= 10
	BEGIN
		INSERT INTO CategoryProduct (Title)
		VALUES ('Категория ' + CAST(@Score AS NVARCHAR(2)));
		SET @Score = @Score + 1;
	END;

select * from CategoryProduct;

--Рассчитайте среднюю стоимость товара. При помощи 
--конструкции WHILE увеличьте стоимость на 20% тех товаров, 
--стоимость которых ниже средней.

select * from Product; 

SELECT AVG(Cost) FROM Product;

CREATE TABLE #TempProduct
(
    ID INT,
    Cost DECIMAL(10, 2)
);
	DECLARE @AvgCost DECIMAL(10, 2);
		
		SELECT @AvgCost = AVG(Cost) FROM Product;
		DECLARE @ProductID INT,
				@CostProduct DECIMAL(10, 2);
		INSERT INTO #TempProduct (ID, Cost)
		SELECT ID,
			   Cost FROM Product
		WHERE Cost < @AvgCost;
		WHILE EXISTS (SELECT TOP 1 ID FROM #TempProduct)
		BEGIN
			SELECT TOP 1 @ProductID = ID, 
						 @CostProduct = Cost FROM #TempProduct;
			UPDATE Product
			SET Cost = Cost * 1.2
			WHERE ID = @ProductID;
			DELETE FROM #TempProduct
			WHERE ID = @ProductID;
		END
		DROP TABLE #TempProduct;

select * from Product;

--ЛАБОРАТОРНАЯ РАБОТА №10

--Создайте хранимую процедуру, которая выводит список услуг
--(Наименование, стоимость, продолжительность, дата начала оказания
--услуги), которые были оказаны в заданном диапазоне дат (при помощи
--входных параметров).alter proc PR_ServiceList	@FirstStartTime datetime,	@SecondStartTime datetimeas	select Title,		   Cost,		   Duration,		   StartTime	from   Service left join		   ClientService on service.ID = ClientService.ServiceId	where  StartTime between @FirstStartTime and @SecondStartTimeexec PR_ServiceList '01.01.2019','01.06.2019'--Создайте хранимую процедуру, которая в качестве входного
--параметра принимает наименование услуги. Возвращает: Количество
--раз, которое услуга была предоставлена; Общая сумма выручки от
--услуги.
alter proc PR_ListService	@TitleService nvarchar(100)as	select count(ServiceId) as CountService,		   count(ServiceId) * cost as SumIncomeService	from   Service right join		   ClientService on service.ID = ClientService.ServiceId	where  ServiceId = (						select id 						from Service						where Title like @TitleService)	group by cost		exec PR_ListService 'Замена сальника привода'--Рассчитайте среднюю стоимость товаров. При помощи хранимой
--процедуры выведите список товаров, которые дороже средней
--стоимости.