BAI 2 - Vi du Database Partition (MariaDB)

Muc tieu:
- Vi du don gian, de hieu cho 3 loai:
  1) Horizontal partition
  2) Vertical partition
  3) Function (logic) partition

Cau truc:
- 01-horizontal/horizontal_partition_demo.sql
- 01-horizontal/horizontal_partition_demo_no_procedure.sql
- 02-vertical/vertical_partition_demo.sql
- 03-function/function_partition_demo.sql

Cach chay trong MariaDB (DBeaver / HeidiSQL / phpMyAdmin / mysql cli):
1. Mo cong cu ket noi MariaDB
2. Chay file 01-horizontal truoc (tao DB partition_demo_db)
3. Chay file 02-vertical
4. Chay file 03-function

Neu SQL client bao loi 1064 khi chay file horizontal:
1. Dung file 01-horizontal/horizontal_partition_demo_no_procedure.sql
2. Chay bang che do Execute Script (khong phai Execute Statement)
3. Neu van loi, chay tung block theo thu tu tu tren xuong

Ket qua mong doi de chup minh chung:
- Horizontal:
  - table_user_01 co user Nam
  - table_user_02 co user Nu
  - vw_users_all gom du lieu tu 2 bang
- Vertical:
  - Query danh sach user chi doc user_core
  - Query chi tiet can join user_core + user_profile
- Function:
  - Co 3 nhom bang theo module auth/sales/reporting
  - reporting_daily_order_summary tong hop duoc doanh thu

Goi y noi ve performance (ngan gon):
- Horizontal: giam so dong phai quet moi bang theo nhom du lieu
- Vertical: giam IO cho query thuong dung vi bang chinh nhe hon
- Function: tach tai nghiep vu, tranh anh huong cheo giua cac module
