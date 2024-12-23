CREATE DATABASE TRUNGTAM
go
use TRUNGTAM
go
create table Tinh_TP(MA_T_TP varchar(8) primary key, TEN_TP varchar(40), DT float, DS float)
create table Mien(MA_T_TP varchar(8)primary key, MIEN varchar(10),constraint FK_TinhTP foreign key(MA_T_TP) references Tinh_tp(MA_T_TP))
create table Biengioi(MA_T_TP varchar(8)not null, NUOC varchar(10) not null,constraint FK_Tinh foreign key (MA_T_TP) references Tinh_tp(MA_T_TP))
alter table Biengioi add constraint BG primary key (MA_T_TP,NUOC)
create table Langgieng(MA_T_TP varchar(8)not null, L_Gieng varchar(8) not null)
alter table Langgieng add constraint LG primary key (MA_T_TP,L_Gieng)
alter table langgieng add constraint RB20  foreign key (Ma_T_TP) references Tinh_tp(MA_T_TP)
go




 
