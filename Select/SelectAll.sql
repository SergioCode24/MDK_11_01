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

--������������ ������ �5

--�������� ������ ���� ��������������� ����� �� ������������
--������ ������� (�������� 2019 ����), ��������������� �� ���� �������� ������.

SELECT Title FROM Service 
WHERE id IN (
SELECT ServiceId FROM ClientService 
WHERE StartTime BETWEEN '01.09.2019' AND '30.09.2019');

--������ ���� �����, ���������� ����� ������� � ��������� ��
--���������.

SELECT Title,
		 Cost FROM Service 
WHERE Title LIKE '%������%';

--������ ������ ������, ������������ �������� ���������� ��
--�������� ����������� �����, � ��������� ���� �������, ��������������� ��
--���� ������� � ����������

SELECT title, 
		 saledate,
		 Quantity from ProductSale
join product on product.id = ProductSale.ProductID
where ProductID in (
select ID from Product 
where Title like '������� ����������� �����%') 
order by SaleDate, Quantity;

--�������� ������� ����������������� ������ � �������;

select avg(Duration / 60) as AvgDuration from Service;

--���������� ��������� �����������, �������������� ��������
--������� (�� ������� Product);

select count(ManufacturerID) as CountManufacturerProduct from Product
where id in (
select productid from productsale);

--���� �������� ������ �������� � ������ ��������� �������
--��������;

select min(Birthday) as MinBirthday, 
		 max(Birthday) as MaxBirthday from client;

--���������� ��������� ������� �� ������ 2019 ����;

select sum(Quantity) as QuantitySaleProductNovember2019 from productsale
where SaleDate between '01.11.2019' and '30.11.2019';

--�������� ���������� �������, ��������� ������� ����� 1500 ���. �
--������ ������;

select count(id) as 'CountProductCostMore1500WithDiscount' from Service 
where cost * (1 - Discount) > 1500;

--�������� ���������� �������� �������� � �������� ����;

select count(id) as CountClients,
	   gendercode as Gender from client
group by gendercode

--�������� ������� ������� ��������.

select avg(year (getdate()) - year (Birthday)) as AvgAge from client;

--�������� ������ ������� (ID � ���� ��������� �������), �������
--���� ������� 2 � ����� ��� �� 2019 ���.

select productid,
	   max(saledate) as LastSaleDate,
	  count(productID) as CountSale from productsale
where SaleDate between '01.01.2019' and '31.12.2019'
group by productid
having count(productID) >= 2;

--�������� ������ ����������� (ID), ������� ���������� �����
--������ ������. ������������ �� ���������� ������������ ������� � �������
--��������.

select Manufacturerid,
count(Manufacturerid) as CountProduct
from product
group by Manufacturerid
having count(Manufacturerid) > 1
order by count(Manufacturerid) desc;

--������������ ������ �6

--������������� ������, ������������ ��� ������, � �������
--���������� ����� �Dive in! Blue�select * from ProductSalewhere ProductID = (select id from product where title like 'Dive in! Blue');--�������� �������� � �������������� ������ ��� ���������
--������� ����������� ������������

select lastname, title, StartTime from ClientServicejoin [SERVICE] on ClientService.ServiceId = [Service].IDjoin Client on ClientService.ClientId = Client.idwhere SERVICEID in (select id from [SERVICE]where title like '������ ����������� ������������');--������������� ������, ������������ ������ ���� ��������,
--����������� ����� �� ������������ ������ ������� (������ ��������� 2019
--����). ������������ ������ �� ������� �������.select * from client where id in (select clientid from ClientServicewhere StartTime between '01.01.2019' and '30.06.2019')order by LastName;--������������� ������, ������������ ������ ���� �������,
--������� ���� ������� � ������� ������ 2019 ����.

select title from Product
where id in (
select productid from ProductSale
where MONTH(SaleDate) = MONTH(GETDATE()) AND YEAR(SaleDate) = '2019');

--������������� ������, ������������ ������ �����, �������
--���� ������������� ����� ���� ���;

SELECT Title FROM Service
WHERE Id IN (SELECT ServiceId FROM ClientService 
GROUP BY ServiceId
HAVING COUNT(ServiceId) > 3);

--�������� �������� � ��������� ������ �������� � ������ ��������
--������;SELECT Title, 	   Cost FROM ProductWHERE Cost =(SELECT MIN(Cost) FROM Product) ORCost = (SELECT MAX(Cost) FROM Product); --�������� �������� � ����������������� ������ � ������������
--�������. ������������ �� ����������������� ������ �� �������� � ��������;SELECT Title,	   Duration,	   discount FROM ServiceWHERE Discount = (SELECT MAX(Discount) FROM Service)ORDER BY Duration DESC;--�������� �������� � ��������� ����� ������� ������ � ������
--������.

select title,
	   (cost * (1 - Discount)) as CostWithDiscount from Service
where cost * (1 - Discount) = (
select min(cost * (1 - Discount)) from Service);

--������������ ������ �7

--�������� ������ ���� �������� � ��������� ��� (� ���� �������,
--����������� ���������) � ���������� ������, � ����� ���������� ���������
--��� ����� � ���� ��������� ������. �������� ��������, ��� � ������ ������
--���� �������� ��� �������, ���� ��, ������� ������ �� ���� ������� �� ����.
--������������ �� ���������� ��������������� �����.SELECT LastName +  ' ' + FirstName + ' ' +  Patronymic as FullName,	   Email, 	   Phone,	   count (clientid) as CountService,	   max (StartTime) as LastDate from clientleft join ClientService on client.id = ClientService.ClientIdgroup by FirstName, 	     LastName, 		 Patronymic, 		 Email, 		 Phone;--�������� �������� � ���������������� �������. � ������:
--������������, ����� ��������� ������ ������, ����� ���������� ����������
--������, ���������� ������ ������, ���� ��������� �������. ������������ �
--������� ����� �������������� ������.

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

--�������� �������� �� ����� ������� �� ��������� ����� (� ������
--������ �� ������), ���������� ��������� ����� � ������� �����������������
--������ � ������� �� ������ � ������ ��������� 2019 ����.

--�� ������ ���������

SELECT SUM(cost * (1 - Discount)) AS SumSaleService,
	   COUNT(ClientService.ID) AS CountSaleService,
	   avg(duration / 60) as AvgDurationServiceInMinute FROM ClientService
JOIN Service ON ClientService.ServiceId = Service.ID
where YEAR(StartTime) = 2019 and MONTH(StartTime) between 1 and 6;

--�� ������ ���������

SELECT SUM(cost * (1 - Discount)) AS SumSaleService,
	   COUNT(ClientService.ID) AS CountSaleService,
	   avg(duration / 60) as AvgDurationServiceInMinute FROM ClientService
JOIN Service ON ClientService.ServiceId = Service.ID
where YEAR(StartTime) = 2019 and MONTH(StartTime) between 7 and 12;

--����������� ���������� � ����� �������������� ������� ����� 
--�������� �� 18 �� 25 ���, � �� 26 �� 35 ���. �������� ������������ �����, 
--���������� ��������������� ����� ���������� ��������� ��������.--��� �������� �� 18 �� 25 ���

SELECT Title AS ServiceTitle,
	   COUNT(ClientService.ID) AS CountService FROM ClientService
JOIN Service ON ClientService.ServiceId = Service.ID
JOIN Client ON ClientService.ClientId = Client.ID
WHERE YEAR(GETDATE()) - YEAR(Birthday) BETWEEN 18 AND 25
GROUP BY Title
ORDER BY CountService DESC;

--��� �������� �� 26 �� 35 ���

SELECT Title AS ServiceTitle,
	   COUNT(ClientService.ID) AS CountService FROM ClientService
JOIN Service ON ClientService.ServiceId = Service.ID
JOIN Client ON ClientService.ClientId = Client.ID
WHERE YEAR(GETDATE()) - YEAR(Birthday) BETWEEN 26 AND 35
GROUP BY Title
ORDER BY CountService DESC;

--��� ������������ ������� ���������� ��� ��������, �������� 
--�������� � ��������, ���� �������� ������� � ������� ������. ������ ������ 
--��������� ���, ���� ��������, Email, ���������� ����������� ������� �� 
--�������������� ������, ����� ��������� ��������������� �����.

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

--������������ ������ �8

--�������� ������� ���������� �������. � ������, ��� �������� � 
--������, ��� �������������, ���������� ������. �������� ����� ������ 
--�� ������, ������ ������� � ���������.create view VW_ProductListasSELECT Title as TitleProduct,
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

--�������� �������� � �������, ��������� � ���� 2019 ����. � ������: 
--������� � �������� ������� (�������������� �������� LEFT), 
--�������� ������, ��������� � ������ ������, ���� ������ 
--�������������� ������, ����������������� � �������, ���� 
--��������� �������������� ������ (�������������� �������� 
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

--�������� �������� � ���� �������� �������: ������������ ������ � 
--������������� �� ������� ���������_������; �������������: 
--��������_��������������,
--���� �������, ���������� ���������� ������.

create view VW_ProductSaleListas
SELECT Title + '; �������������: ' + Name AS Product,
	   SaleDate,
	   sum(Quantity) AS QuantitySale FROM ProductSale
JOIN Product ON ProductSale.ProductID = Product.ID
JOIN Manufacturer ON Product.ManufacturerID = Manufacturer.ID
group by title,
		 name,
		 SaleDate;

select * from VW_ProductSaleList;

--������������ ������ �9

--���� � ���� ������ ���� �������, � ������� ���� �������� � 
--������� ������, �������� ��������� �� ������� ������ ���� 
--���������� ����� �������� ��������!�. � ��������� ������, 
--�������� ��������������� ���������.

IF EXISTS (SELECT * FROM Client WHERE MONTH(Birthday) = MONTH(GETDATE()))
    PRINT '� ������� ������ ���� ���������� ����� �������� ��������!'
ELSE
    PRINT '� ������� ������ ��� ����������� ����� �������� ��������.';

--��������� ���������� ������� � �������� ����������
--����������� � ������� ������.

DECLARE @CountOfBirthdayPeople INT;

	SELECT @CountOfBirthdayPeople = COUNT(Birthday) FROM Client
	WHERE MONTH(Birthday) = MONTH(GETDATE());
	IF @CountOfBirthdayPeople > 0
	   PRINT '� ������� ������ ���� ' + CAST (@CountOfBirthdayPeople AS NVARCHAR(10)) + ' ����������� ����� �������� ��������!'
	ELSE
	   PRINT '� ������� ������ ��� ����������� ����� �������� ��������.';

--���� ����� ����� �� ������ ������� (���������� ���������� 
--������ * ���������) ����� 200 000 ���., ������� ��������� 
--�������� ��������� � ������ ������. ����� ������ ������!�. 
--����� - �������� ��������� � ������ ������. �� �����, �� ����� 
--�� � �����!�.

DECLARE @SumSale DECIMAL(10, 2);

	SELECT @SumSale = SUM(Quantity * Cost) FROM ProductSale
	JOIN Product ON ProductSale.ProductID = Product.ID;
	IF @SumSale < 200000
	   PRINT '������� ��������� � ' + CAST(@SumSale AS NVARCHAR(20)) + ' ���. ����� ������ ������!'
	ELSE
	   PRINT '������� ��������� � ' + CAST(@SumSale AS NVARCHAR(20)) + ' ���. �� �����, �� ����� �� � �����!';

--�������� ������ �������: ��������, ���������, ������������ 
--(���� ������� IsActive = TRUE, �� ������� ���������, ���� 
--FALSE � ��� ��� �������)SELECT Title,
	   Cost,
	   CASE
	   WHEN IsActive = 'True' THEN '��������'
	   WHEN IsActive = 'False' THEN '�� ��� �������'
    END 
	as IsActive FROM Product;

--�������� ������ �����: ��������, ��������� � ������ ������, 
--������������ (���� ������ ������ ����� 60 ����� -
--����������������� ������, �� 60 �� 120 ����� � ������ ������� 
--������������, ����� 120 ����� � ���������� ������), 
--������������ ������ � �������. ������������ ������ �� 
--���������.

SELECT Title,
	   cost * (1 - Discount) AS CostWithDiscount,
	   CASE
	   WHEN Duration / 60 <= 60 THEN '����������������� ������'
	   WHEN Duration / 60 > 60 AND  Duration / 60 <= 120 THEN '������ ������� ������������'
	   WHEN Duration / 60 > 120 THEN '���������� ������'
	   END 
	   AS DurationCategory,
	   Duration / 60 AS DurationInMinutes FROM Service
ORDER BY CostWithDiscount;

--�������� ������ ��������: ������� �.�., ���, �������, 
--���������� (���� ������ ������� ����� 3�� ��� �� ������ �
--����������� ������, �� 1 �� 3�� � ������� �����������, 0 � ��� 
--����� ������ �� �������. ��� ���?�
--�� ���������, ��� � ���� ��������� ������ ���� ������������.

SELECT LastName + ' ' + LEFT(FirstName, 1) + '. ' + LEFT(Patronymic, 1) + '.' AS FullName,
	   GenderCode AS Gender,
	   DATEDIFF(YEAR, Birthday, GETDATE()) AS Age,
	   CASE
	   WHEN COUNT(ClientId) > 3 THEN '���������� ������'
	   WHEN COUNT(ClientId) BETWEEN 1 AND 3 THEN '������ �����������'
	   ELSE '�� ����� ������ �� �������. ��� ���?'
	   END
	   AS Comment FROM ClientService
right JOIN Client ON ClientService.ClientId = Client.ID
GROUP BY LastName,
		 FirstName,
		 Patronymic,
		 GenderCode,
		 Birthday;

--�� ���������, ��� � ���� ��������� ������ ���� ������������.
--� �������������� ����� �������� � ������� ���������� ������
--10 ����� �� �������: ��������� 1, ��������� 2 � ��������� 10.

DECLARE @Score INT = 1;

	WHILE @Score <= 10
	BEGIN
		INSERT INTO CategoryProduct (Title)
		VALUES ('��������� ' + CAST(@Score AS NVARCHAR(2)));
		SET @Score = @Score + 1;
	END;

select * from CategoryProduct;

--����������� ������� ��������� ������. ��� ������ 
--����������� WHILE ��������� ��������� �� 20% ��� �������, 
--��������� ������� ���� �������.

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

--������������ ������ �10

--�������� �������� ���������, ������� ������� ������ �����
--(������������, ���������, �����������������, ���� ������ ��������
--������), ������� ���� ������� � �������� ��������� ��� (��� ������
--������� ����������).alter proc PR_ServiceList	@FirstStartTime datetime,	@SecondStartTime datetimeas	select Title,		   Cost,		   Duration,		   StartTime	from   Service left join		   ClientService on service.ID = ClientService.ServiceId	where  StartTime between @FirstStartTime and @SecondStartTimeexec PR_ServiceList '01.01.2019','01.06.2019'--�������� �������� ���������, ������� � �������� ��������
--��������� ��������� ������������ ������. ����������: ����������
--���, ������� ������ ���� �������������; ����� ����� ������� ��
--������.
alter proc PR_ListService	@TitleService nvarchar(100)as	select count(ServiceId) as CountService,		   count(ServiceId) * cost as SumIncomeService	from   Service right join		   ClientService on service.ID = ClientService.ServiceId	where  ServiceId = (						select id 						from Service						where Title like @TitleService)	group by cost		exec PR_ListService '������ �������� �������'--����������� ������� ��������� �������. ��� ������ ��������
--��������� �������� ������ �������, ������� ������ �������
--���������.