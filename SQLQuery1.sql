
DROP TABLE BAC.dbo.Biengioi;
GO

drop table BAC.dbo.Langgieng
SELECT * INTO BAC.dbo.Biengioi FROM Biengioi WHERE MA_T_TP IN (SELECT MA_T_TP FROM Tinh_TP WHERE MA_T_TP IN (SELECT MA_T_TP FROM Mien WHERE Mien='BAC'));

create database NAM
create database TRUNG
 select * into NAM.dbo.BienGioi from Biengioi where MA_T_TP in 
     ( select MA_T_TP from Tinh_TP where MA_T_TP in(select MA_T_TP from Mien where Mien='NAM' ))
 select * into TRUNG.dbo.BienGioi from Biengioi where MA_T_TP in 
      ( select MA_T_TP from Tinh_TP where MA_T_TP in( select MA_T_TP from Mien where Mien='TRUNG' ))
-- phantan table Langgieng
 select * into BAC.dbo.LangGieng from Langgieng where MA_T_TP in 
      ( select MA_T_TP from Tinh_TP where MA_T_TP in(select MA_T_TP from Mien where Mien='BAC') )
 select * into NAM.dbo.LangGieng from Langgieng where MA_T_TP in 
    ( select MA_T_TP from Tinh_TP where MA_T_TP in(select MA_T_TP from Mien where Mien='NAM' ))
 select * into TRUNG.dbo.LangGieng from Langgieng where MA_T_TP in 
      ( select MA_T_TP from Tinh_TP where MA_T_TP in( select MA_T_TP from Mien where Mien='TRUNG' ))


create proc DS_Lon_Nhat as
	Declare @D1 float, @D2 float, @D3 float

	set @D1=  (select max(DS) from BAC.dbo.Tinh_TP)
	set @D2=  (select max(DS) from NAM.dbo.Tinh_TP)
	set @D3=  (select max(DS) from TRUNG.dbo.Tinh_TP)
	if @D1 > @D2 set @D1 =@D2
	IF @D1 >@D3 SET @D1 = @D3
	
	SELECT TEN_TP, DS FROM BAC.DBO.Tinh_TP WHERE DS =@D1
	UNION 
	SELECT TEN_TP, DS FROM NAM.DBO.Tinh_TP WHERE DS =@D1
	UNION
	SELECT TEN_TP, DS FROM TRUNG.DBO.Tinh_TP WHERE DS =@D1

EXEC DS_Lon_Nhat
	