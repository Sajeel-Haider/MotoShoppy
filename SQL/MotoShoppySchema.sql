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

create table orders (
  oid int primary key,
  cid INT,
  Date DATE,
  Delivered INT,
  foreign key (cid) references accounts(aid));

create table order_detail (
	oid int not null,
	pid int not null,
	quantity int not null,
	foreign key (oid) references orders (oid),
	foreign key (pid) references products (pid),
	primary key (oid,pid));

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