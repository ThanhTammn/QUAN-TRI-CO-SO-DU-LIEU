create database THAOTAN
use THAOTAN
create table KhachHang
(
	MaKH		char(6) not null primary key,
	TenKH		varchar(100) not null,
	MST			char(10) not null,
	SDT			char(10) not null,
	DiaChi		varchar(100) not null,
	STK			varchar(50),
	NganHang	varchar(100)
)

create table NhaCungCap
(
	MaNCC		char(6) not null primary key,
	TenNCC		varchar(100) not null,
	MST			char(10) not null,
	Thue		float not null,
	SDT			char(10) not null,
	DiaChi		varchar(100) not null,
	STK			varchar(50),
	NganHang	varchar(100)
)

create table HHDV
(
	MaHHDV		char(6)			not null primary key,
	TenHHDV		varchar(100)	not null,
	Loai		char(2)			not null,
	DonVi		varchar(20)		not null,
	GiaBan		decimal(12,2)	not null,
	SLHHDV		decimal(10,2)	not null
)

create table Nhap
(
	MaDNH		char(6)			not null primary key,
	MaNCC		char(6)			not null,
	NgayNhap	date			not null,
	HTTT		varchar	(20)	not null,
	TongTien	decimal	(12,2)	not null,
	TrangThaiTT varchar	(20)	not null,
	foreign key (MaNCC) references NhaCungCap
)

create table Ban
(
	MaDBH		char(6)			not null primary key,
	MaKH		char(6)			not null,
	NgayBan		date			not null,
	HTTT		varchar(20)		not null,
	TongTien	decimal(12,2)	not null,
	TrangThaiTT varchar(20)		not null,
	foreign key (MaKH) references KhachHang
)

create table BanChiTiet
(
	MaDBH char(6) not null,
	MaHHDV char(6) not null,
	SLBan decimal(10,2) not null,
	primary key(MaDBH,MaHHDV),
	foreign key (MaDBH) references Ban,
	foreign key (MaHHDV) references HHDV
)

create table NhapChiTiet
(
	MaDNH	char(6)			not null,
	MaHHDV	char(6)			not null,
	SLNhap	decimal(10,2)	not null,
	GiaNhap decimal(10,2)	not null,
	primary key (MaDNH,MaHHDV),
	foreign key (MaDNH) references Nhap,
	foreign key (MaHHDV) references HHDV
)

create table HoaDonNopTKH
(
	MaPTKH		char(6)			not null primary key,
	MaDBH		char(6)			not null,
	NgayLap		date			not null,
	SoTienTT	decimal(12,2)	not null,
	SoNoConLai	decimal(12,2)	not null,
	HTTT		varchar(20)		not null,
	foreign key (MaDBH) references Ban
)

create table HoaDonNoNCC
(
	MaNoNCC		char(6)			not null primary key,
	MaDNH		char(6)			not null,
	NgayLap		date			not null,
	SoTienTT	decimal(12,2)	not null,
	SoNoConLai	decimal(12,2)	not null,
	HTTT		varchar(20)		not null,
	foreign key (MaDNH) references Nhap
)
