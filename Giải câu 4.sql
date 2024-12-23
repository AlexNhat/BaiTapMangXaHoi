-- Giải quyết các câu 4
-- câu 4.1
USE QuanLyBanHang
GO
DROP PROCEDURE IF EXISTS NV_BANHANGNHIEUNHAT ;
GO

create proc NV_BANHANGNHIEUNHAT as
BEGIN
	Declare @D1 float, @D2 float, @D3 float
	-- lấy lớn nhất của CN001

	SET @D1 = (
    SELECT TOP 1 SUM(SOLUONG_BAN) AS soluong 
    FROM QuanLyBanHang_CN001.dbo.BANHANG AS bh
    INNER JOIN QuanLyBanHang_CN001.dbo.NHANVIEN AS nv ON bh.MANV = nv.MANV
    GROUP BY NV.MANV
    ORDER BY soluong DESC
);

	-- Lấy lớn nhất của CN002
	SET @D2 = (
    SELECT TOP 1 SUM(SOLUONG_BAN) AS soluong 
    FROM QuanLyBanHang_CN002.dbo.BANHANG AS bh
    INNER JOIN QuanLyBanHang_CN002.dbo.NHANVIEN AS nv ON bh.MANV = nv.MANV
    GROUP BY NV.MANV
    ORDER BY soluong DESC
);
	-- Lấy lớn nhất của CN003
	SET @D3 = (
    SELECT TOP 1 SUM(SOLUONG_BAN) AS soluong 
    FROM QuanLyBanHang_CN003.dbo.BANHANG AS bh
    INNER JOIN QuanLyBanHang_CN003.dbo.NHANVIEN AS nv ON bh.MANV = nv.MANV
    GROUP BY NV.MANV
    ORDER BY soluong DESC
);
	-- Xử lý điều kiện
	if @D1 < @D2 set @D1 =@D2
	IF @D1 <@D3 SET @D1 = @D3
	
	SELECT 'CN001', NV.MANV FROM QuanLyBanHang_CN001.DBO.NHANVIEN AS NV 
	WHERE (SELECT SUM(SOLUONG_BAN) FROM QuanLyBanHang_CN001.dbo.BANHANG AS BH WHERE  BH.MANV = NV.MANV) = @D1


	UNION 
	SELECT 'CN002', NV.MANV FROM QuanLyBanHang_CN002.DBO.NHANVIEN AS NV 
	WHERE (SELECT SUM(SOLUONG_BAN) FROM QuanLyBanHang_CN002.dbo.BANHANG AS BH WHERE  BH.MANV = NV.MANV) = @D1
	UNION
	SELECT 'CN003', NV.MANV FROM QuanLyBanHang_CN003.DBO.NHANVIEN AS NV 
	WHERE (SELECT SUM(SOLUONG_BAN) FROM QuanLyBanHang_CN003.dbo.BANHANG AS BH WHERE  BH.MANV = NV.MANV) = @D1
END
GO
EXEC NV_BANHANGNHIEUNHAT
	GO

	-- câu 4.2 Cho biết tháng 3 chi nhánh nào có tổng số ngày công của nhân viên là thấp nhất?

	DROP PROCEDURE IF EXISTS CN_THANG ;
	GO



create proc CN_THANG
@thang INT
as
BEGIN
	DECLARE @D1 INT, @D2 INT, @D3 INT, @D INT 

	IF NOT EXISTS (SELECT 1 FROM QuanLyBanHang_CN001.DBO.CHAMCONG WHERE THANG = @thang)
	begin
	SET @D1 = 0
	end

	else
	-- cHO CN01
	begin
	set @D1 = (select sum(SO_NGAY_LV) FROM QuanLyBanHang_CN001.DBO.CHAMCONG AS BH
	INNER JOIN QuanLyBanHang_CN001.DBO.NHANVIEN AS NV ON BH.MANV = NV.MANV
	WHERE BH.THANG = @thang)
	end


	-- kiểm tra điều kiện cho CN002
	
	IF NOT EXISTS (SELECT 1 FROM QuanLyBanHang_CN002.DBO.CHAMCONG WHERE THANG = @thang)
	begin
	SET @D2 = 0
	end

	else

	begin
	-- CHO CN2
		set @D2 = (select sum(SO_NGAY_LV) FROM QuanLyBanHang_CN002.DBO.CHAMCONG AS BH
	INNER JOIN QuanLyBanHang_CN002.DBO.NHANVIEN AS NV ON BH.MANV = NV.MANV
	WHERE BH.THANG = @thang)
	end

	-- CHO CN03
	
	IF NOT EXISTS (SELECT 1 FROM QuanLyBanHang_CN003.DBO.CHAMCONG WHERE THANG = @thang)
	begin
	SET @D3 = 0
	end

	else
	-- cHO CN01
	begin
		set @D3 = (select sum(SO_NGAY_LV) FROM QuanLyBanHang_CN003.DBO.CHAMCONG AS BH
	INNER JOIN QuanLyBanHang_CN003.DBO.NHANVIEN AS NV ON BH.MANV = NV.MANV
	WHERE BH.THANG = @thang)
	end

	----- Kiểm tra điều kiện lớn nhất 
	SET @D = @D1
	if @D >@D2 set @D =@D2
	IF @D >@D3 SET @D = @D3
	Declare @MACN_1 CHAR(5), @MACN_2 CHAR(5), @MACN_3 CHAR(5)

	IF @D = @D1 SET @MACN_1 = 'CN001'
	IF @D = @D2 SET @MACN_2 = 'CN002'  
	IF @D = @D3 SET @MACN_3 = 'CN003'
	-- tra về kết quả của 2 chi nhanh
	SELECT @MACN_1 AS 'MACN_1',@D1 as SOLUONG_THANG_CN001, 
	@MACN_2 AS 'MACN_2', @D2 as SOLUONG_THANG_CN002, 
	@MACN_3 AS 'MACN_3',  @D3 as SOLUONG_THANG_CN003
	

END

GO
DECLARE @THANG INT;
SET @THANG = 4;
EXEC CN_THANG @THANG;





-- CÂU 4.3  Cho biết tên sản phầm bán được nhiều thứ 2??
GO

	DROP PROCEDURE IF EXISTS SP_NHIEUTHU2 ;
	GO
CREATE PROC SP_NHIEUTHU2 
AS
BEGIN
	-- kHỞI TẠO TEMP
	CREATE TABLE #TempResults (
    MASP VARCHAR(50),
    SL INT
	);

	INSERT INTO #TempResults (MASP, SL)
	SELECT MASP, SL FROM
		(
		-- LẤY TOP 2 CỦA CN001
		SELECT TOP (2) * FROM 
		( 	SELECT MASP, SUM(SOLUONG_BAN) AS SL 
    		FROM QuanLyBanHang_CN001.DBO.BANHANG 
    		GROUP BY MASP
		) AS Subquery_CN001
		ORDER BY SL DESC

		UNION ALL

		-- LẤY TOP 2 CỦA CN002
		SELECT TOP (2) * FROM 
		( 	SELECT MASP, SUM(SOLUONG_BAN) AS SL 
    		FROM QuanLyBanHang_CN002.DBO.BANHANG 
    		GROUP BY MASP
		) AS Subquery_CN002
		ORDER BY SL DESC

		UNION ALL

		-- LẤY TOP 2 CỦA CN003
		SELECT TOP (2) * FROM 
		( 	SELECT MASP, SUM(SOLUONG_BAN) AS SL 
    		FROM QuanLyBanHang_CN003.DBO.BANHANG 
    		GROUP BY MASP
		) AS Subquery_CN003
		ORDER BY SL DESC
	) AS Result
	ORDER BY SL DESC;


	DECLARE @TOP2 INT
	SELECT @TOP2 = SL
	FROM (
		SELECT SL, ROW_NUMBER() OVER (ORDER BY SL DESC) AS RowNum
		FROM #TempResults
	) AS Temp
	WHERE RowNum = 2;

	-- Truy vấn lại bảng tạm thời và lấy ra các số có số lượng bằng giá trị của biến @TOP2
	SELECT MASP, SL
	FROM #TempResults
	WHERE SL = @TOP2;

	DROP TABLE #TempResults;
END
GO

EXEC SP_NHIEUTHU2;

GO


DROP PROCEDURE IF EXISTS CHECK_CHINHANH;
GO

CREATE PROC CHECK_CHINHANH
@CN CHAR(5)
AS
BEGIN
	IF @CN = 'CN001'
	BEGIN
		RETURN SELECT * FROM QuanLyBanHang_CN001.DBO.NHANVIEN;
	END

	ELSE IF @CN = 'CN002'
	BEGIN
		RETURN SELECT * FROM QuanLyBanHang_CN002.DBO.NHANVIEN;
	END

	ELSE IF @CN = 'CN003'
	BEGIN
		RETURN SELECT * FROM QuanLyBanHang_CN003.DBO.NHANVIEN;
	END

	ELSE
	BEGIN
		RETURN 0;
	END
END
GO


















