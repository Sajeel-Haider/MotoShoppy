create database MotoShoppy
go
use MotoShoppy
go
create table accounts 
	(aid int not null,
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
	(pid int not null,
	pName VARCHAR(20) not null,
	category varchar(20) not null,
	Description varchar(100),
	price float not null,
	quantity int not null,
	sid int not null,
	img image
	primary key (pid),
	foreign key (sid) references accounts (aid),
	);

alter table products add constraint delSellerProducts foreign key (sid) references accounts (aid) on delete cascade --to delete products of a seller when seller is removed

create table orders (
  oid int primary key,
  cid INT,
  Date DATE,
  Delivered INT,
  foreign key (cid) references accounts(aid));

alter table orders add constraint nullcusID foreign key (cid) references accounts (aid) on delete set null 

create table order_detail (
	oid int not null,
	pid int not null,
	quantity int not null,
	foreign key (oid) references orders (oid),
	foreign key (pid) references products (pid),
	primary key (oid,pid));

alter table order_detail add constraint nullpID foreign key (pid) references products (pid) on delete cascade --because pid not nullable


create table reviews (
	oid int foreign key references orders (oid),
	pid int foreign key references products (pid),
	text varchar(100),
	rating int not null,
	check (rating in (1,2,3,4,5)),
	primary key(oid,pid));

create table cart (
	aid int foreign key references accounts(aid),
	pid int foreign key references products(pid),
	quantity int not null,
	primary key (aid,pid));

create table wishlist (
	aid int foreign key references accounts(aid),
	pid int foreign key references products(pid),
	primary key (aid,pid));

create table chat (
	chatid int not null,
	sid int foreign key references accounts (aid),
	DandT datetime,
	text varchar(100) not null,
	primary key (chatid,sid,DandT));


--SIGNUP PROCEDURE
create procedure SignUp
@aName varchar(20),@city varchar(15),@phone varchar(12),@email varchar(30),@pass varchar(20),@type int,@address varchar(100),@status int output
as begin
	declare @num int
	select @num=count(*) from accounts a
	where @email=a.email
	if (@num=0)
	begin
		declare @aid int
		select @aid=(max(a.aid)+1) from accounts a
		if (@aid is NULL)
		begin
			set @aid=1
		end
		insert into accounts values
		(@aid,@aName,@city,@phone,@email,@pass,@type,@address);
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

--LOGIN PROCEDURE
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

--TOP SELLING
CREATE VIEW topSelling
AS
SELECT Top 5 p.pid FROM order_detail o
JOIN products p ON p.pid=o.pid
GROUP BY p.pid
ORDER BY  SUM(o.quantity) desc

SELECT * FROM topSelling


--SEARCH PRODUCTS
Create Procedure searchProducts
@name varchar(100)
AS
BEGIN
	if EXISTS (SELECT * FROM products Where pName LIKE ('%'+@name+'%'))
	BEGIN
		SELECT * FROM products Where pName LIKE ('%'+@name+'%')
	END
	else
	BEGIN
		print 'Product not found'
	END
END
EXEC searchProducts
@name='Leather'

--CATEGORY
CREATE Procedure categorize
@cate varchar(100)
AS
BEGIN
	if EXISTS (SELECT * FROM products Where category=@cate)
	BEGIN
		SELECT * FROM products Where category=@cate
	END
	else
	BEGIN
		print 'No Such Category Exists'
	END
END
EXEC categorize
@cate='Safety Gear'

--UPDATE ACCOUNT PROCEDURE
create procedure UpdateAcc
@aName varchar(20),@city varchar(15),@phone varchar(12),@email varchar(30),@pass varchar(20),@type int,@address varchar(100),@status int output
as begin
	declare @num int
	select @num=count(*) from accounts a
	where @email=a.email and @pass=a.password
	if (@num=1) --
	begin
		declare @aid int
		select @aid=(max(a.aid)+1) from accounts a
		if (@aid is NULL)
		begin
			set @aid=1
		end
		insert into accounts values
		(@aid,@aName,@city,@phone,@email,@pass,@type,@address);
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
exec SignUp'Fahad Ajmal','Lahore','03090078602','fahad.ajmal@gmail.com','fahad123',2,'House #4, Street #20,Block B, Phase 2, PCSIR, Lahore',@status output
select @status as Status

--DELETE PRODUCT PROCEDURE
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
insert into products values (1, 'Helmet', 'Safety Gear','Scorpion Helmet, 2 DOT Rating',3500,5,1,NULL)
select * from products
declare @status int
exec delProduct 1,@status output

--DELETE ACCOUNT PROCEDURE
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
exec SignUp'Fahad Ajmal','Lahore','03090078602','fahad.ajmal@gmail.com','fahad123',2,'House #4, Street #20,Block B, Phase 2, PCSIR, Lahore',@status output



