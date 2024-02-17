DROP TABLE IF EXISTS ProductSale  
DROP TABLE IF EXISTS ProductPhoto
DROP TABLE IF EXISTS Product
DROP TABLE IF EXISTS Manufacturer
DROP TABLE IF EXISTS CategoryProduct 

CREATE TABLE Manufacturer
(
ID int IDENTITY(1,1) PRIMARY KEY NOT NULL,
[Name] nvarchar(100) NOT NULL,
StartDate date NULL
)
GO

CREATE TABLE CategoryProduct
(
	ID int IDENTITY(1,1) PRIMARY KEY NOT NULL,
	Title nvarchar(100) NOT NULL
)
GO

CREATE TABLE Product
(
	ID int IDENTITY(1,1) PRIMARY KEY NOT NULL,
	Title nvarchar(100) NOT NULL,
	Cost decimal(10,2) NOT NULL,
	[Description] nvarchar(max) NULL,
	MainImagePath PathFile NULL,
	IsActive bit NOT NULL DEFAULT 'TRUE',
	ManufacturerID int NULL foREIGN KEY REFERENCES manufacturer(ID),
	CategoryID int NULL FOREIGN KEY REFERENCES CategoryProduct(ID)
)
GO

CREATE TABLE ProductSale
(
	ID int IDENTITY(1,1) PRIMARY KEY NOT NULL,
	SaleDate datetime DEFAULT (getdate()),
	ProductID int NULL FOREIGN KEY REFERENCES Product(ID),
	Quantity int NOT NULL,
	ClientServiceID int NULL FOREIGN KEY REFERENCES ClientService(ID)
)
GO

CREATE TABLE ProductPhoto
(
ID int IDENTITY(1,1) PRIMARY KEY NOT NULL,
ProductID int NULL FOREIGN KEY REFERENCES Product(ID),
PhotoPath PathFile NULL
)
GO

ALTER TABLE CategoryProduct
ADD CONSTRAINT CN_Title UNIQUE (title)
GO