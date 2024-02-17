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

--1. �������� ������ ���� ��������������� ����� �� ������������
--������ ������� (�������� 2019 ����), ��������������� �� ���� �������� ������.

SELECT Title FROM Service 
WHERE id IN (
SELECT ServiceId FROM ClientService 
WHERE StartTime BETWEEN '01.09.2019' AND '30.09.2019');

--2. ������ ���� �����, ���������� ����� ������� � ��������� ��
--���������.

SELECT Title,
		 Cost FROM Service 
WHERE Title LIKE '%������%';

--3. ������ ������ ������, ������������ �������� ���������� ��
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

--4. �������� ������� ����������������� ������ � �������;

select avg(Duration / 60) as AvgDuration from Service;

--5. ���������� ��������� �����������, �������������� ��������
--������� (�� ������� Product);

select count(ManufacturerID) as CountManufacturerProduct from Product
where id in (
select productid from productsale);

--6. ���� �������� ������ �������� � ������ ��������� �������
--��������;

select min(Birthday) as MinBirthday, 
		 max(Birthday) as MaxBirthday from client;

--7. ���������� ��������� ������� �� ������ 2019 ����;

select sum(Quantity) as QuantitySaleProductNovember2019 from productsale
where SaleDate between '01.11.2019' and '30.11.2019';

--8. �������� ���������� �������, ��������� ������� ����� 1500 ���. �
--������ ������;

select count(id) as 'CountProductCostMore1500WithDiscount' from Service 
where cost * (1 - Discount) > 1500;

--9. �������� ���������� �������� �������� � �������� ����;

select count(id) as CountClients,
	   gendercode as Gender from client
group by gendercode

--10. �������� ������� ������� ��������.

select avg(year (getdate()) - year (Birthday)) as AvgAge from client;

--11. �������� ������ ������� (ID � ���� ��������� �������), �������
--���� ������� 2 � ����� ��� �� 2019 ���.

select productid,
	   max(saledate) as LastSaleDate,
	  count(productID) as CountSale from productsale
where SaleDate between '01.01.2019' and '31.12.2019'
group by productid
having count(productID) >= 2;

--12. �������� ������ ����������� (ID), ������� ���������� �����
--������ ������. ������������ �� ���������� ������������ ������� � �������
--��������.

select Manufacturerid,
count(Manufacturerid) as CountProduct
from product
group by Manufacturerid
having count(Manufacturerid) > 1
order by count(Manufacturerid) desc;

--������������ ������ �6

--1. ������������� ������, ������������ ��� ������, � �������
--���������� ����� �Dive in! Blue�select * from ProductSalewhere ProductID = (select id from product where title like 'Dive in! Blue');--2. �������� �������� � �������������� ������ ��� ���������
--������� ����������� ������������

select lastname, title, StartTime from ClientServicejoin [SERVICE] on ClientService.ServiceId = [Service].IDjoin Client on ClientService.ClientId = Client.idwhere SERVICEID in (select id from [SERVICE]where title like '������ ����������� ������������');--3. ������������� ������, ������������ ������ ���� ��������,
--����������� ����� �� ������������ ������ ������� (������ ��������� 2019
--����). ������������ ������ �� ������� �������.select * from client where id in (select clientid from ClientServicewhere StartTime between '01.01.2019' and '30.06.2019')order by LastName;--4. ������������� ������, ������������ ������ ���� �������,
--������� ���� ������� � ������� ������ 2019 ����.

select title from Product
where id in (
select productid from ProductSale
where MONTH(SaleDate) = MONTH(GETDATE()) AND YEAR(SaleDate) = '2019');

--5. ������������� ������, ������������ ������ �����, �������
--���� ������������� ����� ���� ���;

SELECT Title FROM Service
WHERE Id IN (SELECT ServiceId FROM ClientService 
GROUP BY ServiceId
HAVING COUNT(ServiceId) > 3);

--6. �������� �������� � ��������� ������ �������� � ������ ��������
--������;SELECT Title, 	   Cost FROM ProductWHERE Cost =(SELECT MIN(Cost) FROM Product) ORCost = (SELECT MAX(Cost) FROM Product); --7. �������� �������� � ����������������� ������ � ������������
--�������. ������������ �� ����������������� ������ �� �������� � ��������;SELECT Title,	   Duration,	   discount FROM ServiceWHERE Discount = (SELECT MAX(Discount) FROM Service)ORDER BY Duration DESC;--8. �������� �������� � ��������� ����� ������� ������ � ������
--������.

select title,
	   (cost * (1 - Discount)) as CostWithDiscount from Service
where cost * (1 - Discount) = (
select min(cost * (1 - Discount)) from Service);

--������������ ������ �7

--1. �������� ������ ���� �������� � ��������� ��� (� ���� �������,
--����������� ���������) � ���������� ������, � ����� ���������� ���������
--��� ����� � ���� ��������� ������. �������� ��������, ��� � ������ ������
--���� �������� ��� �������, ���� ��, ������� ������ �� ���� ������� �� ����.
--������������ �� ���������� ��������������� �����.SELECT LastName +  ' ' + FirstName + ' ' +  Patronymic as FullName,	   Email, 	   Phone,	   count (clientid) as CountService,	   max (StartTime) as LastDate from clientleft join ClientService on client.id = ClientService.ClientIdgroup by FirstName, 	     LastName, 		 Patronymic, 		 Email, 		 Phone;--2. �������� �������� � ���������������� �������. � ������:
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

--3. �������� �������� �� ����� ������� �� ��������� ����� (� ������
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

--4. ����������� ���������� � ����� �������������� ������� ����� 
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

--5. ��� ������������ ������� ���������� ��� ��������, �������� 
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

--1. �������� ������� ���������� �������. � ������, ��� �������� � 
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

--2. �������� �������� � �������, ��������� � ���� 2019 ����. � ������: 
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

--3. �������� �������� � ���� �������� �������: ������������ ������ � 
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

--1. ���� � ���� ������ ���� �������, � ������� ���� �������� � 
--������� ������, �������� ��������� �� ������� ������ ���� 
--���������� ����� �������� ��������!�. � ��������� ������, 
--�������� ��������������� ���������.

IF EXISTS (SELECT * FROM Client WHERE MONTH(Birthday) = MONTH(GETDATE()))
    PRINT '� ������� ������ ���� ���������� ����� �������� ��������!'
ELSE
    PRINT '� ������� ������ ��� ����������� ����� �������� ��������.';

--2. ��������� ���������� ������� � �������� ����������
--����������� � ������� ������.

DECLARE @CountOfBirthdayPeople INT;

	SELECT @CountOfBirthdayPeople = COUNT(Birthday) FROM Client
	WHERE MONTH(Birthday) = MONTH(GETDATE());
	IF @CountOfBirthdayPeople > 0
	   PRINT '� ������� ������ ���� ' + CAST (@CountOfBirthdayPeople AS NVARCHAR(10)) + ' ����������� ����� �������� ��������!'
	ELSE
	   PRINT '� ������� ������ ��� ����������� ����� �������� ��������.';

--3. ���� ����� ����� �� ������ ������� (���������� ���������� 
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

--4. �������� ������ �������: ��������, ���������, ������������ 
--(���� ������� IsActive = TRUE, �� ������� ���������, ���� 
--FALSE � ��� ��� �������)SELECT Title,
	   Cost,
	   CASE
	   WHEN IsActive = 'True' THEN '��������'
	   WHEN IsActive = 'False' THEN '�� ��� �������'
    END 
	as IsActive FROM Product;

--5. �������� ������ �����: ��������, ��������� � ������ ������, 
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

--6. �������� ������ ��������: ������� �.�., ���, �������, 
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

--7. �� ���������, ��� � ���� ��������� ������ ���� ������������.
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

--8. ����������� ������� ��������� ������. ��� ������ 
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

--1. �������� �������� ���������, ������� ������� ������ �����
--(������������, ���������, �����������������, ���� ������ ��������
--������), ������� ���� ������� � �������� ��������� ��� (��� ������
--������� ����������). create or alter proc PR_ServiceList	@FirstStartTime datetime,	@SecondStartTime datetimeas	select Title,		   Cost * 1 - Discount AS CostWithDiscount,		   Duration,		   StartTime	from   Service left join		   ClientService on service.ID = ClientService.ServiceId	where  StartTime between @FirstStartTime and @SecondStartTimeexec PR_ServiceList '01.01.2019','01.06.2019'--2. �������� �������� ���������, ������� � �������� ��������
--��������� ��������� ������������ ������. ����������: ����������
--���, ������� ������ ���� �������������; ����� ����� ������� ��
--������.
create or alter proc PR_ListService	@TitleService nvarchar(100)as	select count(ServiceId) as CountService,		   sum(cost * 1 - Discount) as SumIncomeService	from   Service right join		   ClientService on service.ID = ClientService.ServiceId	where  Title like @TitleService		exec PR_ListService '������ �������� �������'--3. ����������� ������� ��������� �������. ��� ������ ��������
--��������� �������� ������ �������, ������� ������ �������
--���������.create or alter proc PR_OverAVGCostProductListas	select Title,		   cost	from product 	where Cost > (				  select avg(Cost) 				  FROM product);		exec PR_OverAVGCostProductList--4. �������� �������� ���������, ������� ����� ��������� � �������� 
--�������� ��������� �������� ������, ����� ��� ������ �� ������ � 
--����� �������� ������� (��������, ������� �������� �� 15.09.2021
--������ - 7(78)972-73-11) � ��������� ��������� ����������: - ����
--������� � ��������� ������� �������� ��� � ���� ������, ������� 
--��������������� ��������� �������� � ��������� ������� 
--�������� ��� � ���� ������, ��� ������ �� ������ �������� �������� � 
--�������. � ���� ������ � ��������� ��������� ��� � ���� ������, 
--������� ��������������� ���������: ���������� ������������ 
--������������ ������, ����� ������ � ����� �������� ���. � ���� 
--������ � ������� � ������ ������� ���������, �������� ������ �� 
--������ � ������� ClientService � ������� ��������� ������� �� ������ 
--������� ���������! ������� �.�. ������� �� ������ �������� ������ 
--�� ���� � ����� ������.

create or alter proc PR_ClientServiceList	@TitleService nvarchar(100),	@StartTimeService datetime,	@PhoneClient nvarchar(20)as	if not exists (
				   select *
				   from Client 
				   where Phone = @PhoneClient)
	    begin
	        print '������� � ��������� ������� �������� ��� � ���� ������, ��� ������ �� ������ �������� �������� � �������';
	        return;
	    end	else if not exists (						select * 						from Service						where						Title like @TitleService)		begin			print '��������� ������������ ������������ ������, ����� ������ � ����� �������� ���';			return;		end	else		declare @FullName nvarchar(100) = (
										   select LastName + ' ' + 
										   LEFT(FirstName, 1) + '. ' + 
										   LEFT(Patronymic, 1) + '.' AS FullName 
										   from Client 
										   where  Phone = @PhoneClient);
		begin
			insert into ClientService (ClientID, ServiceID, StartTime) 
			values((
					select ID
					from Client
					where Phone = @PhoneClient), (
												  select ID
												  from Service
												  where Title like @TitleService), @StartTimeService);
		    print '������ �� ������ ������� ���������! ' + @FullName + ' ������� �� ������ ' + @TitleService + ' �� ' + Cast(@StartTimeService AS NVARCHAR(50));
			return;
	    end					exec PR_ClientServiceList '������ �������� �������','01.03.2019 12:40:00','79221023265'		--5. �������� �������� ���������, ������� � �������� ��������
--��������� ����� ��������� ��� ���� (��������, 01.01.2021 �
--01.02.2021, ��� ���� ������ ���� �� ����������� ��� �����), �
--����������: ������ �������, ������� ���� ������� � ���������
--������ ������� (�������� ������, �������� �������������, ����,
--����������, �����, ���� �������). ���� �� ������ ������ �� ����
--�������, ������� ��������������� ���������. ���� ��� �����
--������� ���������� ������ ���� �� �������, �� ������� ������ ������
--������ �� ��������� ���� (��������, 01.01.2021).

create or alter proc PR_SalesOnDate
	@firstDate date,
	@secondDate date = null
as
	if not exists(
				  select * 
				  from ProductSale
				  where SaleDate BETWEEN @firstDate AND @secondDate or
				  year(SaleDate) = year(@firstDate) and month(SaleDate) = month(@firstDate) and day(SaleDate) = day(@firstDate))
	begin 
			print '� ��������� ������ ������� �� ������ ������ �� ���� �������';
			return;
		end
	else
		begin
			select title,
				   name,
				   cost,
				   quantity,
				   quantity * cost as "SummSale",
				   SaleDate
				   From ProductSale left join 
				   Product on Product.ID = ProductSale.ProductID left join 
				   Manufacturer on Product.ManufacturerID = Manufacturer.ID
				   where SaleDate BETWEEN @firstDate AND @secondDate or
				   year(SaleDate) = year(@firstDate) and month(SaleDate) = month(@firstDate) and day(SaleDate) = day(@firstDate)
				   return;
		end

exec PR_SalesOnDate '09.02.2019', '07.03.2019'

--������������ ������ �11

--1. �������� ���������� INSERT, ������� ����� ��������� �
--������� Client �������� � ���� �������� �� �������� �
--���������� ��������. ���������� ��������� � ���� TRY
--CATCH. ������������� ������, ���������, ��� ����������
--�������� ���������.

begin try 
begin transaction
	insert into Client 
	(FirstName, LastName, Patronymic, Birthday, RegistrationDate, Email, Phone, GenderCode) 
	values 
	('������', '����', '��������', '2000.01.02', '2003.04.09 01:02:03.040', 'ivanov.i.i@mail.ru', '7(01)234-56-78', '�');
	insert into Client 
	(FirstName, LastName, Patronymic, Birthday, RegistrationDate, Email, Phone, GenderCode) 
	values 
	('������', 'ϸ��', '��������', '2010.11.12', '2003.04.09 05:06:07.080', 'petrov.p.p@gmail.com', '7(91)011-12-13', '�');
	insert into Client 
	(FirstName, LastName, Patronymic, Birthday, RegistrationDate, Email, Phone, GenderCode) 
	values 
	('�������', '�����', '���������', '2016.02.18', '2003.04.09 09:10:11.121', 'romanov.r.r@yandex.ru', '7(14)151-61-71', '�');
	--������ � ��������� insert: ������� ���������� � �������� ����� ������ � ������� 'GenderCode'
	insert into Client 
	(FirstName, LastName, Patronymic, Birthday, RegistrationDate, Email, Phone, GenderCode) 
	values 
	('��������', '�������', '����������', '2022.04.24', '2003.04.09 13:41:51.617', 'nikolaev.n.n@mail.ru', '7(81)920-21-22', 1);
commit transaction
print 'Transaction committed'
end try

begin catch
	rollback
	print 'Transaction rolled back';
	throw
end catch

--2. �������� �������� ���������, ������� ����� ��������� �
--�������� ������� ���������� �������� ������ � ����������.
--����������: ���������� �������� � ������� ProductSale
--�������� � �������, ���� ������� ����������� ��� �������
--��������� ����. ���� ������ � ����� ��������� � ���� ������ ���,
--�������� ��������������� ���������. � ������ ���������
--���������� ������ � �������, �������� ���������: �������� �
--������� ������ ��������� ������ � ���������� ����������� ��
--����� ����� ������ * ���������� ��������� � ���� ������. ���
--��������� ��������� ������ ����������� ���� TRY CATCH

create or alter proc PR_TitleOfProductAndCountOfProduct
	@TitleOfProduct nvarchar(100),
	@CountOfProduct int
as
	if not exists(
				  select * 
				  from Product
				  where Title = @TitleOfProduct)
	begin 
		print '������ � ����� ��������� � ���� ������ ���';
		return;
	end
	else
		declare @SumSale int = (
								select Cost * @CountOfProduct
								from Product
								where Title = @TitleOfProduct);
		begin
			begin try 
			begin transaction
				insert into ProductSale 
				(SaleDate, ProductID, Quantity) 
				values 
				(GETDATE(), (
							 select id 
							 from Product
							 where Title = @TitleOfProduct), @CountOfProduct);
				print '�������� � ������� ������ ' + @TitleOfProduct + ' � ���������� ' + Cast(@CountOfProduct AS NVARCHAR(12)) + ' ��. �� ����� ' + Cast(@SumSale AS NVARCHAR(12)) + ' ��������� � ���� ������';
			commit transaction
			print 'Transaction committed'
			end try
			
			begin catch
				rollback
				print 'Transaction rolled back';
				throw
			end catch
			return;
		end

exec PR_TitleOfProductAndCountOfProduct 'Super Minds. Level 4. Workbook with Online Resources', 2

--������������ ������ �12

--1. �������� ���������������� �������, ������� � �������� �������
--���������� ����� ��������� ���� ������ �������������� ������ �
--����������������� ������. ���������� � ���� ���������
--�������������� ������.

create or alter function DateAndDurationService 
(@StartDate datetime, 
@Duration int)
Returns datetime
AS
Begin
declare @endDate datetime = DATEADD(Second, @Duration, @StartDate)
  return @endDate;
end
go

select dbo.DateAndDurationService('2019-06-10 16:40:00.000', 1200) as EndDate

--2. �������� ���������������� �������, ������� ����� ����������
--�������, ���������� ��������� ����������: �������� ������,
--��� � ����� �������� ������� (������: ������ ���� �������� / ���.
--+7(777)777-77-77), ���� ������ �������������� ������, ���� ���������
--�������������� ������ (���������� ��� ������ ������ �����
--��������� ���������������� �������), ��������� ������. � ��������
--������� ���������� ������� ������ ��������� �������� ���
--(��������, �� ������ ������� �� 01.01.2019 �� 01.06.2019)

create or alter function TableService 
(@StartDate date, 
@EndDate date)
Returns table
AS
  return (
		  select Title,
				 LastName + ' ' + 
				 FirstName + ' ' + 
				 Patronymic + ' / ���. ' + 
				 Phone AS FullNameAndPhone,
				 StartTime,
				 dbo.DateAndDurationService(StartTime, Duration) as EndDate,
				 Cost * (1 - Discount) as Cost
				 from Service left join 
				 ClientService on service.ID = ClientService.ServiceId join
				 Client on ClientService.ClientId = Client.ID
				 where StartTime between @StartDate and @EndDate);

select * from dbo.TableService('2019-06-10', '2019-10-14')

--3. �������� ���������������� �������, ������� ����� ����������
--������� ��������� �������.

create or alter function AVGCostProduct()
Returns table
AS
  return (
		  select avg(cost) as AVGCost
		  from Product);

Select * from dbo.AVGCostProduct()

--4. �������� ���������������� �������, ������� ����� ����������
--�������, ���������� ��������� ����������: ������������
--������, ������������ �������������, ���� ������, ���������� ��
--������� ��������� ������ (���������� ��� ������ ������ �����
--��������� ���������������� �������). � �������������� �����
--������ ������� �������� ������ ���������� ������.

create or alter function TableProduct()
Returns table
AS
  return (
		  select Title,
				 Name,
				 Cost,
				 Cost - (
						 Select *
						 from dbo.AVGCostProduct()) as DeviationFromAVGCostProduct
				 from Product left join
				 Manufacturer on Product.ManufacturerID = Manufacturer.ID
				 where IsActive = 1);

select * from dbo.TableProduct()

--������� �� �������������� ������ (���������� ����������).
--�������� ������� PersonalDiscount ���� ������ decimal(3,2) � �������
--Client. ������ ���� ��� ����������� ��� ������������ ������������ ������
--������� � ����������� �� ����� ����� �� ��������� ����� ������� �������.
--��������� ������� ������� �������� �� ��������� = 0. �����, ��������
--�������� ���������, ������� � ����������� �� ����� ����� �� ���������
--����� ������� ����� ��������� ������� PersonalDiscount �� ���������
--��������: ���� ����� � ������� �� 0 �� 5000 ������ ������������ � ������ 5%
--(0,05), �� 5000 �� 10000 ������������ � ������ 10% (0,1), ����� 10000 � ������
--15% (0,15).

create or alter proc PR_PersonalDiscount 
as 
	Declare @PersonalDiscount decimal(3,2),
			@Counter int = 1
	while @Counter < (
					  select max(ID) 
					  from client)
	begin
		if((
			select SUM(cost)
			from service right join 
			ClientService on Service.Id = ClientService.ServiceId
			where ClientId = @Counter) <= 5000)
		begin
			update Client
			set PersonalDiscount = 0.05
			where ID = @Counter
		end
		else if((
				 select SUM(cost)
				 from service right join 
				 ClientService on Service.Id = ClientService.ServiceId
				 where ClientId = @Counter) > 5000 AND (
														select SUM(cost)
														from service right join 
														ClientService on Service.Id = ClientService.ServiceId
														where ClientId = @Counter) <= 10000)
		begin
			update Client
			set PersonalDiscount = 0.1
			where ID = @Counter
		end
		else 
		begin
			update Client
			set PersonalDiscount = 0.15
			where ID = @Counter
		end
		Set @Counter += 1
	end
	
exec PR_PersonalDiscount

select * from Client
	
--������������ ������ �13.1

--1. �������� �������, ������� ����� ��������� ������� ������
--(���������� ���������� � �������� ��������������� ���������),
--������ �������� - �� ��� ������� (���� isActive � false).

