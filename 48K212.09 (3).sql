
use THAOTAN

------- DUMP CSDL----------


-------KhachHang-------------
create proc KH
as
begin
	declare @MaKH		char(6),		
			@MST		char(10),	
			@SDT		char(10),
			@TenKH		varchar(100),				
			@DiaChi		varchar(100),
			@NganHang	varchar(100),
			@dauso		varchar(10),
			@i			int=1
	-- dau SDT
	declare @dsdauso TABLE (a NVARCHAR(10))
	insert into @dsdauso (a)
	values ('096'), ('097'), ('098'), ('086'),('039'),('039'),('038'),('037'),('036'),('035'),('034'),('033'),('032')
	--
	while @i<=1000
		begin
			set @MaKH= 'KH' + REPLICATE('0',4-len(@i))+CAST(@i as varchar(6)) 

			set @TenKH= 'Khach Hang ' + CAST(@i as varchar(6))

			set @DiaChi= 'Dia chi khach hang '+ cast(@i as varchar(6))

			set @NganHang = 'Ngan hang ' + cast(floor(rand()*10+1) as varchar(1))

			-- Mst
			declare @a INT = 1, @b varchar(10)=''
			while @a <= 10
			begin
				set @b = @b + cast(CAST(RAND() * 10+1 as int) as varchar);  
				set @a = @a + 1;
			end
			set @MST=@b
			
			-- SDT
			set @dauso = (select top 1 a from @dsdauso order by newid())
			
			declare @c int = 1, @d varchar(10)=''
			while @c <= 7
			begin
				set @d = @d + cast(CAST(RAND() * 10+1 as int) as varchar);  
				set @c = @c + 1;
			end
			set @SDT=@dauso+@b

			if @SDT not in (select SDT from KhachHang) and @MST not in (select MST from KhachHang )
				begin
					insert into KhachHang
					values(@MaKH,@TenKH, @MST ,@SDT,@DiaChi,@SDT,@NganHang)
					set @i=@i+1
				end
		end	
end

exec KH

select*from KhachHang

------ NhaCungCap-----------

create proc NCC
as
begin
	declare @MaNCC		char(6),		
			@MST		char(10),	
			@Thue		float,		
			@SDT		char(10),
			@TenNCC		varchar(100),				
			@DiaChi		varchar(100),
			@NganHang	varchar(100),
			@dauso		varchar(6),
			@i			int=1

	-- dau SDT
	declare @dsdauso TABLE (a NVARCHAR(10))
	insert into @dsdauso (a)
	values ('096'), ('097'), ('098'), ('086'),('039'),('039'),('038'),('037'),('036'),('035'),('034'),('033'),('032')

	-- ds thue
	declare @dsthue table (b float)
	insert into @dsthue(b)
	values (0.1),(0.08)
	--
	while @i<=1000
		begin
			set @MaNCC= 'CC' + REPLICATE('0',4-len(@i))+CAST(@i as varchar(6)) 

			set @TenNCC= 'Nha cung cap ' + CAST(@i as varchar(6))

			set @Thue= (select top 1 b from @dsthue order by newid())

			set @DiaChi='Dia chi NCC '+ cast(@i as varchar(6))

			set @NganHang = 'Ngan hang ' + cast(floor(rand()*10+1) as varchar(1))
			
			-- Mst
			declare @a int = 1, @b varchar(10)=''
			while @a <= 10
			begin
				set @b = @b + cast(CAST(RAND() * 10+1 as int) as varchar);  
				SET @a = @a + 1;
			END
			set @MST=@b
			
			-- SDT
			set @dauso = (select top 1 a from @dsdauso order by newid())

			DECLARE @c INT = 1, @d varchar(10)=''
			WHILE @c <= 7
			BEGIN
				SET @d = @d + cast(cast(rand() * 10+1 AS int) as varchar);  
				SET @c = @c + 1;
			END
			set @SDT=@dauso+@b
		
			if @SDT not in (select SDT from NhaCungCap) and @MST not in (select MST from NhaCungCap )
				begin	
					insert into NhaCungCap 
					values(@MaNCC,@TenNCC,,@MST, @Thue,@SDT, @DiaChi,@SDT,@NganHang)
					set @i=@i+1
				end
		end	
end		

exec NCC
select*from NhaCungCap

---------HHDV----------

create proc HangHoaDV
as
begin
	declare @MaHHDV		char(6),		
			@TenHHDV	varchar(100),
			@Loai		char(2),		
			@DonVi		varchar(20),	
			@GiaBan		decimal(12,2),
			@SLHHDV		decimal(10,2),
			@i			int=1

	-- ds donvi
	declare @dsdonvi table (b nvarchar(10))
	insert into @dsdonvi(b)
	values ('mét'),('kg'),('m3'),('m2')
	--
	while @i<=1000
		begin
			set @MaHHDV= 'HH' + replicate('0',4-len(@i))+cast(@i as varchar(6)) 

			set @TenHHDV= 'San pham ' + CAST(@i as varchar(6))

			set @Loai = 'HH' 

			set @DonVi= (select top 1 b from @dsdonvi order by newid())
	
			set @GiaBan= 0

			set @SLHHDV= 0
						
			-- INSERT
			insert into HHDV (MaHHDV, TenHHDV, Loai, DonVi, GiaBan, SLHHDV)
			values(@MaHHDV,@TenHHDV, @Loai,@DonVi,@GiaBan,@SLHHDV)
			set @i=@i+1
		end	
	set @i =1
	while @i<=5
		begin
			set @MaHHDV= 'HH' + replicate('0',4-len(@i))+cast(@i as varchar(6)) 

			set @TenHHDV= 'Dich vu ' + CAST(@i as varchar(6))

			set @Loai = 'DV'

			set @DonVi= (select top 1 b from @dsdonvi order by newid())

			set @GiaBan= floor(rand()*100+1)

			set @SLHHDV= floor(rand()*10+1)
					
			-- INSERT
			insert into HHDV (MaHHDV, TenHHDV, Loai, DonVi, GiaBan, SLHHDV)
			values(@MaHHDV,@TenHHDV, @Loai,@DonVi,@GiaBan,@SLHHDV)

			set @i=@i+1
		end	
end	
	--- Loai: HH - Hàng hóa ; DV - Dịch vụ 

exec HangHoaDV
select*from HHDV

-----------Nhap-----------

create proc NhapHH
as
begin
	declare @MaDNH			char(6),		
			@MaNCC			char(6),		
			@NgayNhap		date,		
			@HTTT			nvarchar(20),	
			@TrangThaiTT	nvarchar(20),
			@TongTien		decimal(12,2),
			@i				int=1,
			@a				int=1

	declare @dsHTTT table (a varchar(50)) 
	insert into @dsHTTT (a) 
	values (N'TM'), (N'CK')
	--- Hình thức thanh toán: TM - Tiền mặt	; CK - Chuyển khoản 
while @i<=1000
		begin
			set @MaDNH= 'NH'+REPLICATE(0,4-len(@i))+cast(@i as varchar(5))

			set @MaNCC= (select top 1 MaNCC from NhaCungCap order by newid())
			
			set @NgayNhap= DATEADD(DAY,cast(rand()*DATEDIFF(day,'2023-01-01','2024-01-01')+1 as int),'2023-01-01')

			set @HTTT=(select top 1 a from @dsHTTT order by newid())

			set @TrangThaiTT= 'N'
			--- Trạng thái thanh toán: N - Nợ ; HT: Hoàn thành

			set @TongTien = 0
			
			insert into Nhap (MaDNH, MaNCC, NgayNhap, HTTT, TongTien, TrangThaiTT)
			values(@MaDNH,@MaNCC,@NgayNhap,@HTTT,@TongTien,@TrangThaiTT)

			set @i=@i+1
		end	
end
 
exec NhapHH
select *from Nhap

-------NhapChiTiet-----------
create proc NhapCT
as
begin
	declare @MaDNH		char(6),		
			@MaHHDV		char(6),		
			@SLNhap		decimal(10,2),
			@GiaNhap	decimal(10,2),
			@i			int =1,
			@a			int=1,
			@thue		float
	
	while @i<=1000
		begin
			
			set @MaDNH= 'NH'+replicate(0,4-len(@i))+cast(@i as varchar(5))
			
			set @MaHHDV= 'HH' + replicate('0',4-len(@i))+cast(@i as varchar(6))

			set @SLNhap= floor(rand()*200+100) 

			set @GiaNhap=floor(rand()*1000+1)
			
			select @thue=Thue from NhaCungCap where MaNCC = (select MaNCC from Nhap where MaDNH=@MaDNH) 
			-- update Tong tien bang Nhap
			update Nhap
			set TongTien= @GiaNhap*@SLNhap + @SLNhap*@GiaNhap*@thue
			where MaDNH=@MaDNH

			-- update Gia ban
			update HHDV
			set GiaBan= @GiaNhap + 0.3*@GiaNhap
			where MaHHDV=@MaHHDV

			-- update slhhdv
			update HHDV
			set SLHHDV=SLHHDV+@SLNhap
			where MaHHDV=@MaHHDV

			insert into NhapChiTiet
			values(@MaDNH,@MaHHDV,@SLNhap,@GiaNhap)
			set @i=@i +1
		end

	while @a<=5
		begin
			set @MaDNH=(select top 1 MaDNH from Nhap order by newid())

			set @MaHHDV=(select top 1 MaHHDV	from HHDV 
												where Loai='DV'
												order by newid())
			set @SLNhap=(select SLNhap	from NhapChiTiet
										where MaDNH=@MaDNH )

			set @GiaNhap = floor(rand()*100+1)

			select @thue=Thue from NhaCungCap where MaNCC = (select MaNCC from Nhap where MaDNH=@MaDNH) 

			--update tong tien+dich vu
			update Nhap
			set TongTien= TongTien + @GiaNhap*@SLNhap + @SLNhap*@GiaNhap*@thue
			where MaDNH=@MaDNH

			insert into NhapChiTiet
			values(@MaDNH,@MaHHDV,@SLNhap,@GiaNhap)

			set @a=@a+1
				
		end
end
exec NhapCT


-----------Ban hang------------ 
create proc BanH
as
begin
	declare @MaDBH			char(6),		
			@MaKH 			char(6),
			@NgayBan		date,		
			@HTTT			varchar(50),	
			@TongTien 		decimal(12, 2),
			@TrangThaiTT	varchar(50),
			@i				int=1

			declare @dsHTTT table (a varchar(50)) 
			insert into @dsHTTT (a) 
			values (N'TM'), (N'CK')

while @i<=1000
		begin
			set @MaDBH= 'BH' + replicate('0',4-len(@i))+cast(@i as varchar(6)) 

			set @MaKH = (select top 1 MaKH from KhachHang order by NEWID())

			set @NgayBan= DATEADD(DAY,cast(rand()*DATEDIFF(day,'2024-02-01',getdate())+1 as int),'2024-02-01')

			set @HTTT = (select top 1 a from @dsHTTT order by NEWID())
			
			set @TrangThaiTT = 'N'

			set @TongTien = 0

			insert into Ban (MaDBH, MaKH, NgayBan, HTTT, TongTien, TrangThaiTT) 
            values (@MaDBH, @MaKH, @NgayBan, @HTTT, @TongTien, @TrangThaiTT)

			set @i = @i + 1 
		end 
end 

exec BanH
select*from Ban

------------Ban Chi Tiet------------
create proc BanCT
as
begin
    declare 	@i		int = 1,
				@a		int = 1,
            	@MaDBH 	char(6),
            	@MaHHDV char(6),
            	@SLBan 	decimal(10, 2),
				@GiaBan decimal(10,2)

    	while @i<=1000
		begin
			
			set @MaDBH= 'BH'+REPLICATE(0,4-len(@i))+cast(@i as varchar(5))
			
			set @MaHHDV='HH' + replicate('0',4-len(@i))+cast(@i as varchar(6))

			set @SLBan= floor(rand()*100+1) 

			-- update tong tien ban
			select @GiaBan = GiaBan from HHDV where MaHHDV=@MaHHDV
			update Ban
			set TongTien=(@SLBan*@GiaBan) +(@SLBan*@GiaBan)*0.8
			where MaDBH=@MaDBH 

			-- update SLHHDV
			update HHDV
			set SLHHDV=SLHHDV-@SLBan
			where MaHHDV=@MaHHDV


			insert into BanChiTiet
			values(@MaDBH,@MaHHDV,@SLBan)
			set @i=@i +1
		end

	while @a<=5
		begin
			set @MaDBH=(select top 1 MaDBH from Ban order by newid())

			set @MaHHDV=(select top 1 MaHHDV	from HHDV 
												where Loai='DV'
												order by newid())
			set @SLBan=(select SLBan	from BanChiTiet
										where MaDBH=@MaDBH )

			-- update tong tien ban + them tien dich vu
			select @GiaBan = GiaBan from HHDV where MaHHDV=@MaHHDV
			update Ban
			set TongTien=TongTien +@GiaBan*@SLBan +@GiaBan*@SLBan*0.8
			where MaDBH=@MaDBH 


			insert into BanChiTiet
			values(@MaDBH,@MaHHDV,@SLBan)

			set @a=@a+1
				
		end
end

exec BanCT
select*from Ban

----------HoaDonNoNCC-----------
create proc HDNoNCC
as
begin

    declare @MaNoNCC	char(6),		
            @MaDNH		char(6),		
            @NgayLap	date,		
            @SoTienTT	decimal(12,2),	
            @SoNoConLai	decimal(12,2),	
            @HTTT		varchar(20),
			@i			INT = 1

	declare @dsHTTT table (a varchar(50)) 
	insert into @dsHTTT (a) 
	values (N'TM'), (N'CK')

    while @i <= 1000
    begin
        set @MaNoNCC = 'PT' + REPLICATE('0', 4 - LEN(@i)) + CasT(@i as VARCHAR(6));

        select @MaDNH = 'NH' + REPLICATE(0,4-LEN(@i)) + cast(@i as varchar(5))

        select @NgayLap = NgayNhap from Nhap where MaDNH=@MaDNH

        set @SoTienTT = 0

		set @HTTT= (select top 1 a from @dsHTTT order by newid())

        set @SoNoConLai = (select TongTien from Nhap where MaDNH=@MaDNH)-@SoTienTT
		
        insert into  HoaDonNoNCC 
        values (@MaNoNCC, @MaDNH, @NgayLap,@SoTienTT,@SoNoConLai,@HTTT);

        set @i = @i + 1;
    end
end

exec HDNoNCC
select*from HoaDonNoNCC

----------HoaDonNopTKH------------

create proc HDPTKH
as
begin
    declare @MaPTKH		char(6)	,		
            @MaDBH		char(6)	,		
            @NgayLap	date	,		
            @SoTienTT	decimal(12,2),	
            @SoNoConLai	decimal(12,2),	
            @HTTT		varchar(20),		
			@i INT = 1

	declare @dsHTTT table (a varchar(50)) 
	insert into @dsHTTT (a) 
	values (N'TM'), (N'CK')

    while @i <= 1000
    begin
        set @MaPTKH = 'TK' + REPLICATE('0', 4 - LEN(@i)) + cast(@i as VARCHAR(6));

        set @MaDBH = 'BH' + REPLICATE('0', 4 - LEN(@i)) + cast(@i as VARCHAR(6));
	
        select @NgayLap = NgayBan from Ban where MaDBH=@MaDBH
		
        set @SoTienTT = 0

        set @SoNoConLai = (select TongTien from Ban where MaDBH=@MaDBH)-@SoTienTT

		set @HTTT= (select top 1 a from @dsHTTT order by newid())

        insert into HoaDonNopTKH

        values (@MaPTKH, @MaDBH, @NgayLap, @SoTienTT, @SoNoConLai,@HTTT);

        set @i = @i + 1;
    end
end

exec HDPTKH
select*from Ban


----------Thêm CONSTRAINT-----------

alter table HHDV
add constraint a
check(SLHHDV >0)

alter table HHDV
add constraint b
check(GiaBan >0)

alter table HHDV
add constraint ten
unique (TenHHDV)

alter table KhachHang
add constraint c
unique (MST)

alter table KhachHang
add constraint d
unique (SDT)

alter table NhaCungCap
add constraint e
unique (SDT)

alter table NhaCungCap
add constraint f
unique (MST)

alter table HoaDonNoNCC
add constraint nocc
check(SoNoConLai >=0)

alter table HoaDonNopTKH
add constraint nopt
check(SoNoConLai >=0)


--------------MODULE------------

-- 1. Kiểm tra sự tồn tại của khách hàng 

go
create function ktraKH (@TenKH varchar(50), @SDT varchar(10))
returns bit
as
begin
	declare @ret bit
	if	exists ( select 1	from KhachHang
							where TenKH = @TenKH AND SDT = @SDT)
		begin
			set @ret=1
		end
	else
		begin
			set @ret=0
		end
	return @ret
end

-- 2. Kiểm tra sự tồn tại của nhà cung cấp 

go
create function ktraNCC (@TenNCC varchar(50), @SDT varchar(10))
returns bit
as
begin
	declare @ret bit
	if	exists ( select 1	from NhaCungCap
							where TenNCC = @TenNCC AND SDT = @SDT)
		begin
			set @ret=1
		end
	else
		begin
			set @ret=0
		end
	return @ret
end


-- 3. Kiểm tra sự tồn tại của hàng hóa 

go
create function ktraHH (@MaHH varchar(10))
returns bit
as
begin
	declare @ret bit, @Loai char(1)
	if	@MaHH in (select MaHHDV from HHDV ) 
		begin
			select @Loai=Loai from HHDV where MaHHDV=@MaHH
			if @Loai='X'
				set @ret=0
			else
				set @ret=1
		end
	else 
		begin
			set @ret=0
		end
	return @ret
end


-- 4. Tính tổng tiền nhập hàng cho một đơn hàng cụ thể

go
create function TongTienNH (@MaDNH varchar(10))
returns decimal(12,2)
as
begin
	declare  @TongTien decimal(12,2)=0, @MaNCC varchar(10), @Thue float

	if @MaDNH in (select MaDNH from NhapChiTiet)
		begin
			select @MaNCC = MaNCC from Nhap where MaDNH=@MaDNH
			select @Thue = Thue from NhaCungCap where MaNCC = @MaNCC

			select @TongTien = (select sum(SLNhap*GiaNhap*(1+@Thue))	from NhapChiTiet
																		where MaDNH=@MaDNH
																		group by MaDNH)
		end
	return @tongtien
end

-- 5. Tính tổng tiền bán hàng cho một đơn hàng cụ thể

go
create function TongTienBH (@MaDBH varchar(10))
returns decimal(12,2)
as
begin
	declare  @TongTien decimal(12,2)=0

	if @MaDBH in (select MaDBH from BanChiTiet)
		begin
			select @TongTien = (select sum(SLBan*GiaBan*(1+0.08))	from BanChiTiet	join HHDV on HHDV.MaHHDV = BanChiTiet.MaHHDV
																	where MaDBH=@MaDBH
																	group by MaDBH)
		end
	return @tongtien
end

--6. Tính số nợ còn lại của hóa đơn khi biết mã hóa đơn

go
create function TinhNoCL (@MaHD varchar(10))
returns decimal(12,2)
as
begin
	declare @TongTien decimal(12,2), @SoTienTT decimal(12,2), @SoNoConLai decimal(12,2)

	if @MaHD like 'NH%'
		begin
			select @TongTien=TongTien	from Nhap
										where MaDNH=@MaHD

			if @MaHD not in (select MaDNH from HoaDonNoNCC)
				begin
					set @SoNoConLai= @TongTien
				end
			else
				begin
					select @SoTienTT = sum(SoTienTT)	from HoaDonNoNCC
														where MaDNH=@MaHD

					set @SoNoConLai=@TongTien-@SoTienTT
				end
			
		end

	if @MaHD like 'BH%'
		begin
			select @TongTien=TongTien	from Ban
										where MaDBH=@MaHD

			if @MaHD not in (select MaDBH from HoaDonNopTKH)
				begin
					set @SoNoConLai= @TongTien
				end
			else
				begin
					select @SoTienTT = sum(SoTienTT)	from HoaDonNopTKH
														where MaDBH=@MaHD

					set @SoNoConLai=@TongTien-@SoTienTT
				end
		end
	return @SoNoConLai
end


-- 7. Tạo mã mới khi biết bảng cần tạo

go
create function TaoMaMoi (@TenBang nvarchar(50))
returns nvarchar(20)
as
begin
    declare @Ma varchar(20)
    declare @MaMoi varchar(20)

    if @TenBang = 'KhachHang'
        set @Ma = (select max(MaKH) from KhachHang)
    else if @TenBang = 'NhaCungCap'
        set @Ma = (select max(MaNCC) from NhaCungCap)
    else if @TenBang = 'HHDV'
        set @Ma = (select max(MaHHDV) from HHDV)
    else if @TenBang = 'Nhap'
        set @Ma = (select max(MaDNH) from Nhap)
    else if @TenBang = 'Ban'
        set @Ma = (select max(MaDBH) from Ban)
    else if @TenBang = 'HoaDonNoNCC'
        set @Ma = (select max(MaNoNCC) from HoaDonNoNCC)
    else if @TenBang = 'HoaDonNopTKH'
        set @Ma = (select max(MaPTKH) from HoaDonNopTKH)
    else
        return N'không hợp lệ'
    
    set @MaMoi = LEFT(@Ma,2) + right('0000'+ cast(cast(RIGHT(@Ma, 4) as int) + 1 as varchar(10)),4)
    
    return @MaMoi
end


-- 8. Đồng bộ hóa dữ liệu giữa bảng nhập chi tiết (NhapChiTiet) với bảng hàng hóa dịch vụ (HHDV) và bảng (Nhap) khi thêm, cập nhật dữ liệu

go
create trigger dbdlNCT 
on NhapChiTiet
after insert, update 
as
begin
	declare @MaDNH varchar(10), @SLNhap decimal(12,2), @GiaNhap decimal(12,2), @GiaBan decimal(12,2), @TongTien decimal(12,2), @MaHHDV varchar(10)
	
	select @SLNhap=SLNhap, @GiaNhap=GiaNhap, @MaHHDV=MaHHDV , @MaDNH=MaDNH from inserted
	-- cap nhat so luong hang hoa
	if exists (select*from deleted)
		begin
			update HHDV
			set SLHHDV=SLHHDV + (@SLNhap - (select SLNhap from deleted))
			where MaHHDV=@MaHHDV 
		end
	else
		begin
			update HHDV
			set SLHHDV=SLHHDV + @SLNhap 
			where MaHHDV=@MaHHDV 
		end

	-- cap nhat gia ban
	select @GiaBan=GiaBan	from HHDV
							where MaHHDV=@MaHHDV

	update HHDV
	set GiaBan=@GiaNhap*1.2
	where MaHHDV=@MaHHDV and (@GiaBan =0 or @GiaBan <@GiaNhap)
	
	-- cap nhat tong tien
	update Nhap
	set TongTien=dbo.TongTienNH (@MaDNH)
	where MaDNH=@MaDNH
end

-- 9. Đồng bộ hóa dữ liệu giữa bảng nhập chi tiết (BanChiTiet) với bảng hàng hóa dịch vụ (HHDV) và bảng (Ban)

go
create trigger dbdlBCT 
on BanChiTiet
after insert, update, delete 
as
begin
	declare @SLBan int, @GiaBan decimal(12,2), @MaHHDV varchar(10), @TongTien decimal(12,2),@MaDBH varchar(10)

	select @SLBan = SLBan, @MaHHDV= MaHHDV, @MaDBH=MaDBH from inserted

	-- Cập nhật số lượng hàng hóa

	if exists (select*from deleted) 
		begin
				-- Kiểm tra số lượng tồn kho
				
			if (@SLBan - (select SLBan  from deleted)) > (select SLHHDV from HHDV where MaHHDV=@MaHHDV)
				begin
					raiserror ('Số lượng bán không thể vượt quá số lượng tồn kho', 16, 1);
					rollback
				end
	
			else
				begin
					update HHDV
					set SLHHDV=SLHHDV - (@SLBan - (select SLBan  from deleted))
					where MaHHDV=(select MaHHDV from inserted)
				end
		end

	else
		begin
			if @SLBan > (select SLHHDV from HHDV where MaHHDV=@MaHHDV)
				begin
					raiserror ('Số lượng bán không thể vượt quá số lượng tồn kho', 16, 1);
					rollback
				end
			else 
				begin
					update HHDV
					set SLHHDV=SLHHDV - @SLBan
					where MaHHDV=(select MaHHDV from inserted)
				end
		end

		-- Cập nhật tổng tiền
	
		set @TongTien=dbo.TongTienBH (@MaDBH)
		update Ban
		set TongTien=@TongTien
		where MaDBH=@MaDBH
end


-- 10. Cập nhật trạng thái thanh toán của bảng Nhap sau khi thanh toán xong nợ

go
create trigger TrangThaiTT
on HoaDonNoNCC
after insert,update
as
begin
	declare @no decimal(12,2),@MaDNH varchar(10)
	select @no=SoNoConLai, @MaDNH=MaDNH from inserted
    update Nhap
    set TrangThaiTT = 'HT'
	where @no=0 and MaDNH=@MaDNH 
end;

-- 11. Cập nhật trạng thái thanh toán của bảng Ban sau khi thanh toán xong nợ

go
create trigger TrangThaiTTB
on HoaDonNopTKH
after insert,update
as
begin
    declare @no decimal(12,2),@MaDBH varchar(10)
	select @no=SoNoConLai,@MaDBH=MaDBH from inserted
    update Ban
    set TrangThaiTT = 'HT'
	where @no=0 and MaDBH=@MaDBH
end;

-- 12. Thay vì xóa dữ liệu trong bảng KhachHang kiểm tra nếu TrangThaiTT=HT cập nhật TenKH=X. Ngược lại, hủy thao tác

create trigger dlKH
on KhachHang
instead of delete
as
begin
	declare @TTTT varchar(3)
	select @TTTT = TrangThaiTT	from Ban
								where MaKH=(select MaKH from deleted)
	if @TTTT = 'HT'
		begin
			update KhachHang
			set TenKH='X'
			where MaKH= (select MaKH from deleted)
		end
	else
		begin
			rollback
		end
end


-- 13. Thay vì xóa dữ liệu NhaCungCap thì kiểm tra nếu TrangThaiTT=HT cập nhật TenNCC=X. Ngược lại, hủy thao tác

create trigger dlNCC
on NhaCungCap
instead of delete
as
begin
	declare @TTTT varchar(3)
	select @TTTT = TrangThaiTT	from Nhap
								where MaNCC=(select MaNCC from deleted)
	if @TTTT = 'HT'
		begin
			update NhaCungCap
			set TenNCC='X'
			where MaNCC= (select MaNCC from deleted)
		end
	else
		begin
			rollback
		end
end

-- 14. Thay vì xóa dữ liệu HHDV thì cập nhật Loai=X.

create trigger dlHHDV
on HHDV
instead of delete
as
begin
	update HHDV
	set Loai='X'
	where MaHHDV= (select MaHHDV from deleted)

end

-- 15. Đồng bộ hóa dữ liệu bảng NhapChiTiet với bảng HHDV và bảng Nhap

go
create trigger dlNCT 
on NhapChiTiet
after delete 
as
begin
	declare @SLNhap int, @MaHHDV varchar(10), @TongTien decimal(12,2),@MaDNH varchar(10)

	select @SLNhap = SLNhap, @MaDNH=MaDNH from deleted

    -- Cập nhật số lượng hàng hóa

	update HHDV
	set SLHHDV= SLHHDV - @SLNhap
	where MaHHDV=(select MaHHDV from deleted)
		
	-- Cập nhật tổng tiền
	set @TongTien=dbo.TongTienNH (@MaDNH)
	update Nhap
	set TongTien=@TongTien
	where MaDNH=@MaDNH
end

-- 16. Đồng bộ hóa dữ liệu bảng BanChiTiet với bảng HHDV và bảng Ban
 
go
create trigger dlBCT 
on BanChiTiet
after delete 
as
begin
	declare @SLBan int, @MaHHDV varchar(10), @TongTien decimal(12,2),@MaDBH varchar(10)

	select @SLBan = SLBan, @MaHHDV= MaHHDV, @MaDBH=MaDBH from deleted
	
		update HHDV
		set SLHHDV=SLHHDV + @SLBan 
		where MaHHDV=(select MaHHDV from deleted)
						

		-- Cập nhật tổng tiền
	
		set @TongTien=dbo.TongTienBH (@MaDBH)
		update Ban
		set TongTien=@TongTien
		where MaDBH=@MaDBH
end

-- 17. Tính tong no của 1 NCC

create function NoNCC (@MaNCC varchar(10))
returns decimal(12,2)
as
begin
	declare @TongTien decimal(12,2), @SoTienTT decimal(12,2), @No decimal(12,2)
	select @TongTien= sum(TongTien) from Nhap 
									where MaNCC=@MaNCC

	select @SoTienTT = sum(SoTienTT)	from HoaDonNoNCC	join Nhap on Nhap.MaDNH=HoaDonNoNCC.MaDNH
										where MaNCC=@MaNCC
	
	set @No = @TongTien-@SoTienTT
	
	return @No						
end

-- 18. Tính tong no của 1 KhachHang

create function NoKH (@MaKH varchar(10))
returns decimal(12,2)
as
begin
	declare @TongTien decimal(12,2), @SoTienTT decimal(12,2), @No decimal(12,2)
	select @TongTien= sum(TongTien) from Ban
									where MaKH=@MaKH

	select @SoTienTT = sum(SoTienTT)	from HoaDonNopTKH	join Ban on Ban.MaDBH=HoaDonNopTKH.MaDBH
										where MaKH=@MaKH
	
	set @No = @TongTien-@SoTienTT
	
	return @No						
end

