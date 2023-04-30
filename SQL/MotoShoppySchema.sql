create database MotoShoppy
go
use MotoShoppy
go
drop table accounts
drop table products
drop table orders
drop table order_detail
drop table reviews
drop table cart
drop table wishlist
drop table chat

create table accounts 
	(aid int not null identity,
	aName Varchar(20) not null,
	city varchar(15) not null,
	phone varchar(12) not null,
	email varchar(30) not null unique,
	password varchar(20) not null,
	type int not null,
	address varchar(100) not null,
	check (type in (0,1,2)),
	primary key (aid));

create table products
	(pid int not null identity,
	pName VARCHAR(20) not null,
	category varchar(20) not null,
	Description varchar(100),
	price float not null,
	quantity int not null,
	sid int not null,
	img image
	primary key (pid),
	foreign key (sid) references accounts (aid) on delete cascade,
	);
alter table products add approval int not null default 0

create table orders (
  oid int primary key identity,
  cid INT,
  Date DATE,
  Delivered INT,
  foreign key (cid) references accounts(aid) on delete set null);

create table order_detail (
	oid int not null identity,
	pid int not null,
	quantity int not null,
	foreign key (oid) references orders (oid),
	foreign key (pid) references products (pid) on delete cascade,
	primary key (oid,pid));

create table reviews (
	oid int foreign key references orders (oid),
	pid int foreign key references products (pid) on delete cascade,
	text varchar(100),
	rating int not null,
	check (rating in (1,2,3,4,5)),
	primary key(oid,pid));

create table cart (
	aid int foreign key references accounts(aid) on delete cascade,
	pid int foreign key references products(pid),
	quantity int not null,
	primary key (aid,pid));

create table wishlist (
	aid int foreign key references accounts(aid) on delete cascade,
	pid int foreign key references products(pid),
	primary key (aid,pid));

create table chat (
	chatid int not null identity,
	sid int foreign key references accounts (aid) on delete cascade,
	DandT datetime,
	text varchar(100) not null,
	primary key (chatid,sid,DandT));
create table Categories (
	category_id int  primary key,
	category_title varchar(100)
)
--SIGNUP PROCEDURE (1)
create procedure SignUp
@aName varchar(20),@city varchar(15),@phone varchar(12),@email varchar(30),@pass varchar(20),@type int,@address varchar(100),@status int output
as begin
	declare @num int
	select @num=count(*) from accounts a
	where @email=a.email
	if (@num=0)
	begin
		insert into accounts(aName,city,phone,email,password,type,address) values
		(@aName,@city,@phone,@email,@pass,@type,@address);
		set @status=1
		Print 'Signup Successful'
	end
	else
	begin
		set @status=0
		Print 'Signup Unsuccessful, email already exists'
	end
end
--TESTING SIGNUP
declare @status int
exec SignUp'Fahad Ajmal','Lahore','03090078602','fahad.ajmal@gmail.com','fahad123',1,'House #4, Street #20,Block B, Phase 2, PCSIR, Lahore',@status output
select @status as Status
select * from accounts
--LOGIN PROCEDURE (2)
create procedure Login
@email varchar(30),@pass varchar(20),@status int output
as begin
	declare @num int
	select @num=count(*) from accounts a
	where a.password=@pass and a.email=@email
	if (@num=1)
	begin
	set @status=1
	Print 'Login Successful'
	end
	else
	begin
	set @status=0
	Print 'Invalid email id or password'
	end
end
--TESTING LOGIN
declare @status int
exec Login 'fahad.ajmal@gmail.com','fahad123',@status output
select @status as Status

--TOP SELLING (3)
CREATE VIEW topSelling
AS
SELECT Top 5 p.pid FROM order_detail o
JOIN products p ON p.pid=o.pid
GROUP BY p.pid
ORDER BY  SUM(o.quantity) desc

SELECT * FROM topSelling


--SEARCH PRODUCTS (4)
create Procedure searchProducts
@name varchar(100)
AS
BEGIN
	if EXISTS (SELECT * FROM products Where pName LIKE ('%'+@name+'%') and approval=1)
	BEGIN
		SELECT * FROM products Where pName LIKE ('%'+@name+'%') and approval=1
	END
	else
	BEGIN
		print 'Product not found'
	END
END
EXEC searchProducts
@name='Gloves'

--CATEGORY (5)
create Procedure categorize
@cate varchar(100)
AS
BEGIN
	if EXISTS (SELECT * FROM products Where category=@cate and approval=1)
	BEGIN
		SELECT * FROM products Where category=@cate and approval=1
	END
	else
	BEGIN
		print 'No Such Category Exists'
	END
END

EXEC categorize
@cate='Safety Gear'

--ADD PRODUCT PROCEDURE (6)
create procedure addProduct
@pName varchar(20), @category varchar(20), @Description varchar(100), @price float, @quantity int, @sid int,@img image,@status int output
as begin
	declare @num int
	select @num=count(*) from products p
	where @pName=p.pName and @sid=p.sid
	if (@num=0)
	begin
		insert into products(pName,category,Description,price,quantity,sid,img) values
		(@pName,@category,@Description,@price,@quantity,@sid,@img);
		set @status=1
		Print 'Product added Successfully'
	end
	else
	begin
		set @status=0
		Print 'Failed to add product, this product name already exists'
	end
end
--ADD PRODUCT TESTING
declare @status int
exec addProduct 'Gloves', 'Safety Gear','Riderz Gloves, Fully padded',1500,5,1,NULL,@status output
select @status as Status
select * from products

--DELETE PRODUCT PROCEDURE (7)
create procedure delProduct
@pid int,@status int output
as begin
	declare @num int
	select @num = count(*) from products where pid=@pid
	if (@num!=0)
	begin
		set @status=1
		delete from products
		where pid=@pid
		Print 'Product deleted'
	end
	else
	begin
		set @status=0
		Print 'No product found'
	end
end
--DELETE PRODUCT TESTING
declare @status int
exec addProduct 'Gloves', 'Safety Gear','Riderz Gloves, FUlly padded',1500,5,1,NULL,@status output
select * from products
declare @status int
exec delProduct 1,@status output

--DELETE ACCOUNT PROCEDURE (8)
create procedure delAccount
@aid int,@status int output
as begin
	declare @num int
	select @num = count(*) from accounts where aid=@aid
	if (@num!=0)
	begin
		set @status=1
		delete from accounts
		where aid=@aid
		Print 'Account deleted'
	end
	else
	begin
		set @status=0
		Print 'No Account found'
	end
end
--DELETE ACCOUNT TESTING
select * from accounts
declare @status int
exec delAccount 2,@status output
declare @status int
exec SignUp'Sajeel','Haider','03090078601','sajeel.haider@gmail.com','sajeel123',1,'House #5, Street #22,Block C, Phase 1, PCSIR, Lahore',@status output

--VIEW For admin to see all unapproved products (9)
create view AllUnApp
as 
	select * from products join accounts on accounts.aid=products.sid
	where approval=0 

select * from AllUnApp

--PROCEDURE FOR admin to approve a product (10)
create procedure adminApprove
@pid int
as begin
	declare @num int
	select @num=count(*) from products where pid=@pid
	if (@num=1)
	begin
		update products
		set approval=1
		where pid=@pid
		Print 'Product approved successfully'
	end
	else
	begin
		Print 'Product not found'
	end
end

exec adminApprove 1
--PROCEDURE FOR Seller to See his all products (11)
create PROCEDURE sellerViewProducts
@accId int
AS
BEGIN
	SELECT * FROM products 
	where sid=@accId
END

EXEC sellerViewProducts 2

--PROCEDURE FOR Seller to See his approved products (12)
create PROCEDURE sellerViewProductsApp
@accId int
AS
BEGIN
	SELECT * FROM products 
	where sid=@accId and approval=1
END

EXEC sellerViewProductsApp
2

--PROCEDURE FOR Seller to See his Unapproved products (13)
create PROCEDURE sellerViewProductsUnApp
@accId int
AS
BEGIN
	SELECT * FROM products 
	where sid=@accId and approval=0
END

EXEC sellerViewProductsUnApp
2



--View for total orders so far (14)
CREATE View totalOrders
as
	SELECT COUNT(o.oid) FROM orders o where o.Delivered=1


--View for total customers registered (15)
CREATE view totalCustomers
AS
	SELECT COUNT(a.aid) FROM accounts a WHERE a.type=2


--View for total sellers registrered (16)
CREATE view totalSellers
AS
	SELECT COUNT(a.aid) FROM accounts a WHERE a.type=1

--View for checking total sales (17)
CREATE view totalSales
AS
	SELECT SUM(p.price*p.quantity) FROM order_detail od 
	JOIN products p ON p.pid=od.pid

