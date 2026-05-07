DROP DATABASE IF EXISTS merch_store;
CREATE DATABASE merch_store;
USE merch_store;

CREATE TABLE USERS(
	User_id INT NOT NULL,
    Fname VARCHAR(15) NOT NULL,
    Lname VARCHAR(15) NOT NULL,
    Semester VARCHAR(5),
    Year INT,
    Phone VARCHAR(10),
    Email VARCHAR(30),
    State VARCHAR(2),
    City VARCHAR(15),
    Zip INT,
    Address VARCHAR(40),
    Unit_no INT,
    PRIMARY KEY(User_id)
);
 
 CREATE TABLE MERCH_STOCK(
	Product_id INT NOT NULL,
    Product_name VARCHAR(20),
    Product_type VARCHAR(20),
    Price DECIMAL(10,2),
    Stock_Quantity INT,
    PRIMARY KEY(Product_id)
);
    
CREATE TABLE ORDERS(
	Order_id INT NOT NULL,
    Order_date DATE,
    Num_items_in_order INT,
    Order_status VARCHAR(20),
    Customer_id INT NOT NULL,
    PRIMARY KEY(Order_id),
    FOREIGN KEY (customer_ID) REFERENCES USERS(User_id)
);

CREATE TABLE PAYMENT(
	Payment_id INT NOT NULL,
    Payment_date DATE NOT NULL,
    Card_no INT,
    Security_no INT,
    Expiration_date DATE NOT NULL,
    Paid_w_id INT NOT NULL,
    PRIMARY KEY(Payment_id),
    FOREIGN KEY(Paid_w_id) REFERENCES ORDERS(Order_id)
);

CREATE TABLE DELIVERY(
	Delivery_id INT NOT NULL,
	Delivery_date DATE,
    Method VARCHAR(20),
    Status VARCHAR(100),
    Sent_id INT NOT NULL,
    Customer_d_id INT NOT NULL,
    PRIMARY KEY(Delivery_id),
    FOREIGN KEY(Sent_id) REFERENCES ORDERS(Order_id),
    FOREIGN KEY(Customer_d_id) REFERENCES USERS(User_id)
);
    
CREATE TABLE ORDER_ITEM(
    Order_ID        INT NOT NULL,
    Line_number     INT NOT NULL,
    Prod_ID         INT NOT NULL,
    Item_ID         INT NOT NULL,
    Item_quantity   INT NOT NULL,
    PRIMARY KEY (Order_ID, Line_number),
    FOREIGN KEY (Order_ID) REFERENCES ORDERS(Order_ID),
    FOREIGN KEY (Prod_ID)  REFERENCES MERCH_STOCK(Product_ID)
);	
    
INSERT INTO USERS
VALUES (1, 'Alice', 'Brown', 'FA', 2023, '5731234567', 'alice@email.com', 'MO', 'Columbia', 65201, '123 Elm St', NULL);
INSERT INTO USERS
VALUES (2, 'Bob', 'Smith', 'SP', 2024, '5739876543', 'bob@email.com', 'MO', 'Columbia', 65201, '456 Oak Ave', 2);
INSERT INTO USERS
VALUES (3, 'Carol', 'Jones', 'FA', 2022, '5731112222', 'carol@email.com', 'IL', 'Chicago', 60601, '789 Pine Rd', NULL);
INSERT INTO USERS
VALUES (4, 'David', 'Lee', 'SP', 2023, '5733334444', 'david@email.com', 'MO', 'Kansas City', 64101, '321 Maple Dr', 5);
INSERT INTO USERS
VALUES (5, 'Eva', 'Garcia', 'FA', 2024, '5735556666', 'eva@email.com', 'KS', 'Overland Park', 66210, '654 Cedar Blvd', NULL);
 
INSERT INTO MERCH_STOCK
VALUES (1, 'TShirt', 'Apparel', 20.00, 100);
INSERT INTO MERCH_STOCK
VALUES (2, 'Hoodie', 'Apparel', 45.00, 50);
INSERT INTO MERCH_STOCK
VALUES (3, 'Water Bottle', 'Accessory', 14.99, 75);
INSERT INTO MERCH_STOCK
VALUES (4, 'Backpack', 'Accessory', 59.99, 30);
INSERT INTO MERCH_STOCK
VALUES (5, 'Hat', 'Apparel', 22.00, 60);
INSERT INTO MERCH_STOCK
VALUES (6, 'Hoodie', 'Apparel', 45.00, 120);
INSERT INTO MERCH_STOCK
VALUES (7, 'Sticker Pack', 'Stationery', 4.99, 200);
INSERT INTO MERCH_STOCK
VALUES (8, 'Phone Case', 'Accessory', 17.99, 45);
INSERT INTO MERCH_STOCK
VALUES (9, 'Purse', 'Accessory', 12.99, 80);
INSERT INTO MERCH_STOCK
VALUES (10, 'Sweatpants', 'Apparel', 39.99, 40);
 
INSERT INTO ORDERS
VALUES (101, '2024-01-15', 2, 'Delivered', 1);
INSERT INTO ORDERS
VALUES (102, '2024-02-20', 1, 'Shipped', 2);
INSERT INTO ORDERS
VALUES (103, '2024-03-05', 3, 'In Progress', 3);
INSERT INTO ORDERS
VALUES (104, '2024-03-10', 1, 'Cancelled', 4);
INSERT INTO ORDERS
VALUES (105, '2024-04-01', 2, 'Delivered', 5);
INSERT INTO ORDERS
VALUES (106, '2024-04-15', 1, 'Shipped', 1);
INSERT INTO ORDERS
VALUES (107, '2024-05-01', 2, 'In Progress', 2);
 
INSERT INTO PAYMENT
VALUES (201, '2024-01-15', 4111, 123, '2026-12-01', 101);
INSERT INTO PAYMENT
VALUES (202, '2024-02-20', 4222, 456, '2025-08-01', 102);
INSERT INTO PAYMENT
VALUES (203, '2024-03-05', 4333, 789, '2027-03-01', 103);
INSERT INTO PAYMENT
VALUES (204, '2024-03-10', 4444, 321, '2026-06-01', 104);
INSERT INTO PAYMENT
VALUES (205, '2024-04-01', 4555, 654, '2025-11-01', 105);
INSERT INTO PAYMENT
VALUES (206, '2024-04-15', 4666, 987, '2026-09-01', 106);
INSERT INTO PAYMENT
VALUES (207, '2024-05-01', 4777, 111, '2027-01-01', 107);
 
INSERT INTO DELIVERY
VALUES (301, '2024-01-20', 'Standard', 'Delivered', 101, 1);
INSERT INTO DELIVERY
VALUES (302, '2024-02-25', 'Express', 'Shipped', 102, 2);
INSERT INTO DELIVERY
VALUES (303, NULL, 'Standard', 'In Progress', 103, 3);
INSERT INTO DELIVERY
VALUES (304, NULL, 'Standard', 'Cancelled', 104, 4);
INSERT INTO DELIVERY
VALUES (305, '2024-04-07', 'Express', 'Delivered', 105, 5);
INSERT INTO DELIVERY
VALUES (306, NULL, 'Standard', 'Shipped', 106, 1);
INSERT INTO DELIVERY
VALUES (307, NULL, 'Express', 'In Progress', 107, 2);
 
INSERT INTO ORDER_ITEM
VALUES (101, 1, 1, 1001, 2);
INSERT INTO ORDER_ITEM
VALUES (101, 2, 3, 1002, 1);
INSERT INTO ORDER_ITEM
VALUES (102, 1, 2, 1003, 1);
INSERT INTO ORDER_ITEM
VALUES (103, 1, 4, 1004, 1);
INSERT INTO ORDER_ITEM
VALUES (103, 2, 5, 1005, 1);
INSERT INTO ORDER_ITEM
VALUES (103, 3, 6, 1006, 1);
INSERT INTO ORDER_ITEM
VALUES (104, 1, 7, 1007, 3);
INSERT INTO ORDER_ITEM
VALUES (105, 1, 8, 1008, 1);
INSERT INTO ORDER_ITEM
VALUES (105, 2, 9, 1009, 2);
INSERT INTO ORDER_ITEM
VALUES (106, 1, 10, 1010, 1);
INSERT INTO ORDER_ITEM
VALUES (107, 1, 1, 1011, 2);
INSERT INTO ORDER_ITEM
VALUES (107, 2, 2, 1012, 1);

USE merch_store;

ALTER TABLE USERS ADD COLUMN username VARCHAR(30);
ALTER TABLE USERS ADD COLUMN password VARCHAR(30);

UPDATE USERS SET username = 'alice', password = 'alice123' WHERE User_id = 1;
UPDATE USERS SET username = 'bob', password = 'bob123' WHERE User_id = 2;
UPDATE USERS SET username = 'carol', password = 'carol123' WHERE User_id = 3;
UPDATE USERS SET username = 'david', password = 'david123' WHERE User_id = 4;
UPDATE USERS SET username = 'eva', password = 'eva123' WHERE User_id = 5;
