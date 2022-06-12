go
use master
go
--drop database AnimalShelter
--GO
create database AnimalShelter
go
use AnimalShelter

CREATE TABLE dbo.[User](
	UserId int NOT NULL Primary Key, 
	UserType int NOT NULL Default(0),
	UserName varchar(30) NOT NULL,
	Password varchar(20) NOT NULL,
	DOB date CHECK(DOB<GETDATE()),  -- dob LESS than current date
	Gender varchar(1) CHECK (Gender='M' OR Gender='F') ,
	Email varchar(50) NOT NULL CHECK(Email LIKE('%@%'))
)

CREATE TABLE dbo.[Member](
	UserId int NOT NULL foreign key References [User](UserId) ON DELETE CASCADE ON UPDATE CASCADE,
	MemberID int NOT NULL primary key
)

CREATE TABLE dbo.[Billing](
	MemberID int NOT NULL Foreign key references Member(MemberID) ON DELETE CASCADE ON UPDATE CASCADE,
	CardNo varchar(16) NOT NULL,
	CVC varchar(3) NOT NULL,
	ExpDate date NOT NULL,
	AmountSpent float NOT NULL DEFAULT(0) CHECK(AmountSpent>=0),
	Balance float NOT NULL CHECK(Balance>=0)
	primary key(MemberID,CardNo)
)

CREATE TABLE dbo.[Employee](
	UserID int NOT NULL foreign key References [User](UserId) ON DELETE CASCADE ON UPDATE CASCADE,
	EID int NOT NULL,
	Salary int,
	Primary Key (EID)
)

CREATE TABLE dbo.[Vets](
	EID int NOT NULL Foreign key references Employee(EID) ON DELETE CASCADE ON UPDATE CASCADE,
	Degree varchar(50),
	YearOfGrad date CHECK(YearOfGrad<GETDATE()),
	Experience int
)

CREATE TABLE dbo.[Animal](
	AnimalID int NOT NULL Primary Key,
	Species varchar(20),
	Gender varchar(1) CHECK (Gender='M' OR Gender='F'),
	Colour varchar(15),
	Age int,
)

CREATE TABLE dbo.[Paid_Shelter](
	AnimalID int NOT NULL foreign key References [Animal](AnimalID) ON DELETE CASCADE ON UPDATE CASCADE,
	MemberID int NOT NULL foreign key References [Member](MemberID) ON DELETE CASCADE ON UPDATE CASCADE,
	TimeLeft time,
	Charges int,
	PickupTime time,
	Primary Key (AnimalID, MemberID, TimeLeft)
)

CREATE TABLE dbo.[Rescued](
	AnimalID int NOT NULL foreign key References [Animal](AnimalID) ON DELETE CASCADE ON UPDATE CASCADE,
	Location varchar(20),
	DateOfRescue date,
	Primary Key (AnimalID)
)

CREATE TABLE dbo.[Injured](
	AnimalID int NOT NULL foreign key References [Animal](AnimalID) ON DELETE CASCADE ON UPDATE CASCADE,
	Injury varchar(20),
	Disease varchar(20),
	AdmittDate date NOT NULL,
	DischargeDate date,
	Primary Key (AnimalID, AdmittDate)
)

CREATE TABLE dbo.[ToBeAdopted](
	AnimalID int NOT NULL foreign key References [Animal](AnimalID) ON DELETE CASCADE ON UPDATE CASCADE,
	DropDate date NOT NULL,
	AdoptDate date,
	Primary Key (AnimalID)
)

CREATE TABLE dbo.[Blacklist](
	UserID int NOT NULL foreign key References [User](UserId) ON DELETE CASCADE ON UPDATE CASCADE,
	DateOfBlacklist date,
	Reason varchar(50),
	Primary Key (UserId)
)

CREATE TABLE dbo.[Post](
	UserID int NOT NULL foreign key References [User](UserId) ON DELETE CASCADE ON UPDATE CASCADE,
	PostID int Primary Key NOT NULL,
	PostDate date,
	Content varchar(500) NOT NULL,
)

CREATE TABLE dbo.[Comment](
	UserID int NOT NULL foreign key References [User](UserId),
	PostID int NOT NULL foreign key References [Post](PostID) ON DELETE CASCADE ON UPDATE NO ACTION,
	CommentID int NOT NULL Primary Key,
	CommentDate date,
	Content varchar(500) NOT NULL,
)



CREATE PROCEDURE SIGNUPMEMBER
@name varchar(30),
@password varchar(30),
@DOB Date,
@Gender varchar(1),
@email varchar(50),
@usertype int,   -- 0: signup as memeber, 1: signup as employee, 2: signup as vet employee
@salary int NULL,
@gradyear Date NULL,
@degree varchar(50) NULL,
@exp int NULL,
@msg varchar(30) OUTPUT,
@Id_1 int OUTPUT,   
@Id_2 int OUTPUT  --USERS will have 2 id's UserId used to login, and a Member/Employee Id. RETURN those 2 as well
AS
BEGIN

	DECLARE @uid int,@eid int, @mid int, @status int 
	SET @uid=(SELECT ISNULL(MAX([User].UserId),0) FROM [User])+1
	SET @Id_1=@uid
	SET @Id_2 = -1
	SET @mid=(SELECT ISNULL(MAX([Member].MemberID),0) FROM [Member])+1
	SET @eid=(SELECT ISNULL(MAX([Employee].EID),0) FROM [Employee])+1
	INSERT INTO [User] VALUES(@uid,@usertype,@name,@password,@DOB,@Gender,@email)
	SELECT @status=ISNULL([User].UserId,-1) FROM [User] WHERE [User].UserId=@uid
	IF(@status<>-1)
	BEGIN
		IF(@usertype=0)
		BEGIN
			SET @Id_2=@mid
			INSERT INTO [Member] VALUES(@uid,@mid)
		END
		ELSE IF(@usertype=1)
		BEGIN
			SET @Id_2=@eid
			INSERT INTO [Employee] VALUES(@uid,@eid,@salary)
			SELECT @status=ISNULL( [Employee].UserId,-1) FROM  [Employee] WHERE [Employee].UserId=@uid
			IF(@status=-1)
			BEGIN
				SET @msg='Employee Signup failed, verify details and retry'
				Delete from [User] WHERE UserId=@uid
			END
		END
		ELSE IF(@usertype=2)
		BEGIN
			SET @Id_2=@eid
			INSERT INTO [Employee] VALUES(@uid,@eid,@salary)
			SELECT @status=ISNULL( [Employee].UserId,-1) FROM  [Employee] WHERE [Employee].UserId=@uid
			IF(@status=-1)
			BEGIN
				SET @msg='Employee Signup failed, verify details and retry'
				Delete from [User] WHERE UserId=@uid
			END
			ELSE
			BEGIN
				INSERT INTO [Vets] VALUES(@eid,@degree,@gradyear,@exp)
				SELECT @status=ISNULL( [Vets].EID,-1) FROM  [Vets] WHERE [VETS].EID=@eid
				IF(@status=-1)
				BEGIN
					SET @msg='Vet Signup failed, verify details and retry'
					Delete from [Employee] WHERE EID=@eid
				END
			END
		END
	END
	ELSE
	BEGIN
		SET @msg='Signup failed, verify details and retry'
	END
	IF(@status<>-1)
	BEGIN
		SET @msg='Signup Success'
	END
END

DECLARE @m varchar(30),@id1 int, @id2 int
EXECUTE SIGNUPMEMBER
@name='A',
@password ='1234',
@DOB = '2000-02-06',
@Gender = 'F',
@email='g@b.com',
@usertype=2,
@salary=200,
@gradyear='2001-08-08',
@degree='BSCS',
@exp=6,
@msg=@m OUTPUT,
@Id_1=@id1 OUTPUT, 
@Id_2=@id2 OUTPUT
Select @m AS Statis


SELECT*FROM [User]
SELECT * FROM Member
SELECT*FROM Employee
SELECT *FROM Vets

-------------------------------------------------------------

CREATE PROCEDURE UserLogin
@userid int,
@Pass VARCHAR(30),
@Status INT OUTPUT
AS
BEGIN
Declare @type int
IF EXISTS 
	(
		SELECT UserId, [Password]
		FROM [User]
		WHERE UserId=@userid AND [Password]=@Pass
	)
BEGIN SELECT @Status= UserType FROM [User] WHERE UserId=@userid AND [Password]=@Pass
END
ELSE
BEGIN SET @Status=-1
END
END

DECLARE @LoginSuccess INT 
EXECUTE UserLogin
@userid=1,
@Pass ='1234',
@Status=@LoginSuccess OUTPUT
SELECT @LoginSuccess AS [Status]

-------------------------------------------------------------

CREATE PROCEDURE AddBilling
@mid int, @C_no varchar(16), @cvc varchar(3), @expiry Date, @bal float, @msg varchar(100) OUTPUT
AS
BEGIN
	IF (EXISTS(Select Member.MemberID FROM Member WHERE MemberID=@mid)) AND
		(NOT EXISTS (Select Billing.CardNo FROM Billing WHERE Billing.MemberID=@mid AND Billing.CardNo=@C_no))
		AND (LEN(@C_no)=16 AND LEN(@cvc)=3) AND (@expiry > GETDATE())
	BEGIN
		INSERT INTO Billing VALUES (@mid,@C_no,@cvc,@expiry,0,@bal) --amount spent 0 initialy
		SET @msg = 'Billing Added Successfully'
	END
	ELSE
	BEGIN
		SET @msg = 'Operation failed: incorrect information or card already exists'
	END
END

Declare @billingMasg varchar(100)
EXECUTE AddBilling
@mid=1, @C_no='1234111111111111', @cvc='111',@expiry='2025-09-09',@bal=25000,@msg=@billingMasg OUTPUT
SELECT @billingMasg AS [Status]
SELECT * FROM Billing

-------------------------------------------------------------

CREATE PROCEDURE MakeTrasaction
@mid int, @card varchar(16), @cvc varchar(3), @expiry Date, @cost float, @msg varchar(100) OUTPUT
AS
BEGIN
	DECLARE @spending float, @currBal float
	IF EXISTS (SELECT Billing.MemberID FROM Billing WHERE MemberID=@mid AND CardNo=@card AND @cvc=CVC AND @expiry=ExpDate)
	BEGIN
		SET @currBal=(SELECT Balance FROM Billing WHERE MemberID=@mid AND CardNo=@card)
		SET @spending=(SELECT AmountSpent FROM Billing WHERE MemberID=@mid AND CardNo=@card)
		IF(@currBal>=@cost AND @expiry>GETDATE())
		BEGIN
			SET @currBal=@currBal-@cost
			SET @spending=@spending+@cost
			UPDATE Billing SET Balance=@currBal, AmountSpent=@spending WHERE MemberID=@mid AND CardNo=@card
			SET @msg='Transaction Successfull. Balance: '+CAST(@currBal AS varchar) + ' Total Spending: '+ CAST(@spending AS varchar)
		END
		ELSE
		BEGIN
			SET @msg = 'Transaction failed: Card expired, or not enough balance'
		END
	END
	ELSE
	BEGIN
		SET @msg='Transaction failed: Invalid card details.'
	END
END

Declare @output varchar(100)
EXECUTE MakeTrasaction
@mid=1,@card='1234111111111111',@cvc='111',@expiry='2025-09-09',@cost=500, @msg=@output OUTPUT
SELECT @output AS TransactionResult
SELECT * FROM Billing
-------------------------------------------------------------

CREATE PROCEDURE MakePost
@uid int,
@PostContent varchar(500),
@msg varchar(100) OUTPUT,
@id int OUTPUT
AS
BEGIN
	IF (NOT EXISTS (SELECT UserId FROM [Blacklist] WHERE UserId=@uid)) 
		AND (EXISTS (SELECT UserId FROM [User] WHERE UserId=@uid))
	BEGIN
		DECLARE @pid int
		SET @pid=(SELECT ISNULL(MAX([Post].PostID),0) FROM [Post])+1
		INSERT INTO Post VALUES(@uid,@pid,GETDATE(),@PostContent)
		SET @msg = 'Post Created Successfully'
		SET @id = @pid
	END
	ELSE
	BEGIN
		SET @msg = 'Posting Failed: User not registered or Blaclisted'
		SET @id=0
	END
END

DECLARE @postRes varchar(100), @resId int
EXECUTE MakePost
@uid=1,
@PostContent='Hellooo!!!',
@msg=@postRes OUTPUT, @id=@resId  OUTPUT
Select @postRes AS [Status]
Select * From Post

-------------------------------------------------------------

--INSERT INTO Blacklist VALUES(1,GETDATE(),'testing')

CREATE PROCEDURE MakeCommentOnPost
@uid int, @pid int, @commentContent varchar(500), @msg varchar(100) OUTPUT, @id int OUTPUT
AS
BEGIN
	IF (NOT EXISTS (SELECT UserId FROM [Blacklist] WHERE UserId=@uid)) 
		AND (EXISTS (SELECT UserId FROM [User] WHERE UserId=@uid))
		AND (EXISTS (SELECT PostId FROM [Post] WHERE PostId=@pid))
	BEGIN
		DECLARE @cid int
		SET @cid=(SELECT ISNULL(MAX([Comment].CommentID),0) FROM [Comment])+1
		INSERT INTO Comment VALUES(@uid,@pid,@cid,GETDATE(),@commentContent)
		SET @msg = 'Post Created Successfully'
		SET @id = @cid
	END
	ELSE
	BEGIN
		SET @msg = 'Posting Failed: User or Post doesn''t exist or User Blacklisted'
		SET @id=-1
	END
END

DECLARE @cRes varchar(100),@resId int
EXECUTE MakeCommentOnPost
@uid=2, @pid=1, @commentContent='Heloo ??', @msg=@cRes OUTPUT, @id=@resId OUTPUT
SELECT @cRes AS [Status]
SELECT * FROM Comment

-------------------------------------------------------------

CREATE PROCEDURE UpdateBlacklist
@uid int, @operation int, @reason varchar(50), @MSG VARCHAR(100)OUTPUT  -- operation 0: add user to list, 1: remove user from list
AS
BEGIN

	IF(@operation=0 AND EXISTS(Select [User].UserId FROM [User] WHERE UserId=@uid) AND NOT EXISTS(Select Blacklist.UserID FROM Blacklist Where UserID=@uid))
	BEGIN
		INSERT INTO Blacklist VALUES(@uid,GETDATE(),@reason)
		SET @MSG='Added user to Blacklist'
	END
	ELSE IF(@operation=1 AND EXISTS(Select [User].UserId FROM [User] WHERE UserId=@uid) AND EXISTS(Select Blacklist.UserID FROM Blacklist Where UserID=@uid))
	BEGIN
		DELETE FROM Blacklist WHERE UserID=@uid
		SET @MSG='Removed user from Blacklist'
	END
	ELSE
	BEGIN
		SET @MSG='Userid not found or not eligible for the operation'
	END
END

Declare @bl_result varchar(100)
EXECUTE UpdateBlacklist
@uid=1, @operation=0, @reason='test', @MSG=@bl_result OUTPUT
Select @bl_result AS Result
Select * From Blacklist

----------------------------------------------------------------------
CREATE PROCEDURE AddAnimal
@specie varchar(20), @gend varchar(1), @col varchar(15),@age int, @msg varchar(100) OUTPUT
AS
BEGIN
	Declare @aid int
	Set @aid= (SELECT ISNULL(MAX(AnimalID),0) FROM [Animal])+1
	INSERT INTO Animal Values(@aid,@specie,@gend,@col,@age)
	SET @msg = 'Animal added'
END

Declare @result varchar(100)
EXECUTE AddAnimal
@specie='patwari', @gend='M',@col='Brown',@age=50, @msg=@result OUTPUT
Select @result AS [res]
Select*from Animal

---------------------------------------------------------------------

CREATE PROCEDURE AdmitInjured
@id int, @injury varchar(20),@disease varchar(20), @msg varchar(100) OUTPUT
AS
BEGIN
	IF(EXISTS (Select AnimalID FROM Animal where AnimalID=@id) AND NOT EXISTS(Select AnimalID, AdmitTDate From Injured WHERE AnimalID=@id AND AdmittDate<>GETDATE()))
	BEGIN
		INSERT INTO Injured VALUES(@id,@injury,@disease,GETDATE(),NULL)
		SET @msg='Added entry to medical conditions list'
	END
	ELSE
	BEGIN
		Set @msg='Animal id not found, or entry for the day already present'
	END
END

Declare @m varchar(100)
EXECUTE AdmitInjured
@id=1, @injury='not moving', @disease='dead', @msg=@m OUTPUT
SELECT @m AS res
SELECT * FROM Injured

----------------------------------------------------------------------------------

CREATE PROCEDURE DischargeAnimal
@id int, @admitdate Date, @msg VARCHAR(100) OUTPUT
AS
BEGIN

	IF (EXISTS(Select AnimalID, AdmitTDate From Injured WHERE AnimalID=@id AND DischargeDate=NULL))
	BEGIN
		UPDATE Injured SET DischargeDate=GETDATE() WHERE AnimalID=@id AND AdmittDate=@admitdate
		SET @msg='Added entry to medical conditions list'
	END
	ELSE
	Begin
		SET @msg='Entry not found or animal already discharged'
	END
END

Declare @m varchar(100)
EXECUTE DischargeAnimal
@id=1, @admitdate = '2022-04-30', @msg=@m OUTPUT
SELECT @m AS res
SELECT * FROM Injured


 
