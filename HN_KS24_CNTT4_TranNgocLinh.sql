DROP DATABASE IF EXISTS HN_KS24_CNTT4_TranNgocLinh;
CREATE DATABASE HN_KS24_CNTT4_TranNgocLinh;
USE HN_KS24_CNTT4_TranNgocLinh;

-- Bảng khách hàng
CREATE TABLE guests (
    guest_id INT PRIMARY KEY AUTO_INCREMENT,
    guest_name VARCHAR(100),
    phone VARCHAR(20)
);

-- Bảng phòng
CREATE TABLE rooms (
    room_id INT PRIMARY KEY AUTO_INCREMENT,
    room_type VARCHAR(50),
    price_per_day DECIMAL(10,0)
);

-- Bảng đặt phòng
CREATE TABLE bookings (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    guest_id INT,
    room_id INT,
    check_in DATE,
    check_out DATE,
    FOREIGN KEY (guest_id) REFERENCES guests(guest_id),
    FOREIGN KEY (room_id) REFERENCES rooms(room_id)
);
INSERT INTO guests (guest_name, phone) VALUES
('Nguyễn Văn An', '0901111111'),
('Trần Thị Bình', '0902222222'),
('Lê Văn Cường', '0903333333'),
('Phạm Thị Dung', '0904444444'),
('Hoàng Văn Em', '0905555555');

INSERT INTO rooms (room_type, price_per_day) VALUES
('Standard', 500000),
('Standard', 500000),
('Deluxe', 800000),
('Deluxe', 800000),
('VIP', 1500000),
('VIP', 2000000);

INSERT INTO bookings (guest_id, room_id, check_in, check_out) VALUES
(1, 1, '2024-01-10', '2024-01-12'), -- 2 ngày
(1, 3, '2024-03-05', '2024-03-10'), -- 5 ngày
(2, 2, '2024-02-01', '2024-02-03'), -- 2 ngày
(2, 5, '2024-04-15', '2024-04-18'), -- 3 ngày
(3, 4, '2023-12-20', '2023-12-25'), -- 5 ngày
(3, 6, '2024-05-01', '2024-05-06'), -- 5 ngày
(4, 1, '2024-06-10', '2024-06-11'); -- 1 ngày

-- PHẦN I – TRUY VẤN DỮ LIỆU CƠ BẢN
-- 1 Liệt kê tên khách và số điện thoại của tất cả khách hàng
select guest_name,phone from guests;

-- 2 Liệt kê các loại phòng khác nhau trong khách sạn
select distinct room_type from rooms;

-- 3 Hiển thị loại phòng và giá thuê theo ngày, sắp xếp theo giá tăng dần
select room_type,price_per_day from rooms order by price_per_day asc;

-- 4 Hiển thị các phòng có giá thuê lớn hơn 1.000.000
select * from rooms where price_per_day >1000000;

-- 5 Liệt kê các lần đặt phòng diễn ra trong năm 2024
select * from bookings where year(check_in) = 2024;

-- 6 Cho biết số lượng phòng của từng loại phòng
select room_type,count(*) as 'Total rooms' from rooms 
group by room_type;

-- PHẦN II – TRUY VẤN NÂNG CAO
-- 1 Hãy liệt kê danh sách các lần đặt phòng, Với mỗi lần đặt phòng, hãy hiển thị
select g.guest_name,r.room_type,b.check_in from bookings b
join guests g on b.guest_id = g.guest_id
join rooms r on b.room_id = r.room_id;

-- 2 Cho biết mỗi khách đã đặt phòng bao nhiêu lần
select g.guest_name , count(b.booking_id) as 'Total booking' from guests g
left join bookings b on g.guest_id = b.guest_id
group by g.guest_id,g.guest_name;

-- 3 Tính doanh thu của mỗi phòng, với công thức: “Doanh thu = số ngày ở× giá thuê theo ngày”
select r.room_id,SUM(DATEDIFF(b.check_out, b.check_in) * r.price_per_day) as 'Danh thu'from booking b
join rooms r on b.room_id = r.room_id
group by r.room_id;

-- 4 Hiển thị tổng doanh thu của từng loại phòng
select r.room_type,SUM(DATEDIFF(b.check_out, b.check_in) * r.price_per_day) as 'Tong danh thu' from booking b
join rooms r on b.room_id = r.room_id
group by r.room_type;

-- 5 Tìm những khách đã đặt phòng từ 2 lần trở lên
select g.guest_name, COUNT(b.booking_id) as 'So lan dat' from guests g
join booking b on g.guest_id = b.guest_id
group by g.guest_id, g.guest_name
having COUNT(b.booking_id) >= 2;

-- 6 Tìm loại phòng có số lượt đặt phòng nhiều nhất
select r.room_type, COUNT(b.booking_id) as 'So luot dat' from booking b
join rooms r on b.room_id = r.room_id
group by r.room_type
order by so_luot_dat desc
limit 1;

-- PHẦN III – TRUY VẤN LỒNG
-- 1 Hiển thị những phòng có giá thuê cao hơn giá trung bình của tất cả các phòng
SELECT * FROM rooms
WHERE price_per_day > (SELECT AVG(price_per_day)FROM rooms);
