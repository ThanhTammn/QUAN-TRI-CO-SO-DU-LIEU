use ThaoTanthu

-- Thêm CONSTRAINT 
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
	select @no=SoNoConLai,@MaDNH=MaDNH from inserted
    update Nhap
    set TrangThaiTT = 'HT'
	where @no=0 and MaDNH=@MaDNH 
end;


----test
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

