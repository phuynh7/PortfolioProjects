--Using Oracle to simplify the given data for an warehouse
-- Changes made were:
--changed subpart entity to assembly and added assembly num as pk and partnum as fk
--shortened names
--combined emp name, address, manager, worker,into one employee entity
--changed employee addresses from multiple to one
--added order quantity to old backorder entity
--removed original_date from old backorder entity
--removed checked_out from item entity b/c transitive dependency
--add part name to part entity
--added assembly name to assembly entity
--Supervisor column added to employee table

--Drop tables
DROP TABLE ITEM;
DROP TABLE BATCH;
DROP TABLE OLD_BACKORDER;
DROP TABLE CURRENT_BACKORDER;
DROP TABLE PART;
DROP TABLE ASSEMBLY;
DROP TABLE EMP_PHONE;
DROP TABLE EMPLOYEE;
DROP TABLE BIN;
DROP TABLE WAREHOUSE;

--Date formating
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MON-YYYY';

--table for Warehouse
CREATE TABLE WAREHOUSE (
  WAREHOUSE_ID VARCHAR2(4) PRIMARY KEY
);
--Table for Bin
CREATE TABLE BIN (
  BIN_NUM NUMBER(2) PRIMARY KEY,
  WAREHOUSE_ID VARCHAR2(4) CONSTRAINT WARE_FK REFERENCES WAREHOUSE(WAREHOUSE_ID),
  BIN_CAPACITY NUMBER(3) NOT NULL
);
--Table for Employee
CREATE TABLE EMPLOYEE (
  EMP_NUM NUMBER(6) NOT NULL,
  EMP_FNAME varchar2(10) NOT NULL,
  EMP_LNAME varchar2(20) NOT NULL,
  EMP_MNAME varchar2(10) NOT NULL,
  EMP_STREET_NUM NUMBER(6) NOT NULL,
  EMP_STREET_NAME varchar2(20) NOT NULL,
  EMP_CITY varchar2(20) NOT NULL,
  EMP_STATE varchar2(2) NOT NULL,
  EMP_ZIPCODE NUMBER(6) NOT NULL,
  Supervisor NUMBER(6),
  PRIMARY KEY (EMP_NUM)
  );
--Table for EMP phone
CREATE TABLE EMP_PHONE (
  EMP_NUM NUMBER(6) constraint EMP_NUMfk References Employee(EMP_NUM),
  AREA_CODE NUMBER(3),
  PHONE_NUM NUMBER(6),
  PRIMARY KEY (AREA_CODE, PHONE_NUM)
);
--Table for Assembly 
CREATE TABLE ASSEMBLY (
  ASSEMBLY_ID VARCHAR2(4) PRIMARY KEY,
  ASSEMBLY_NAME VARCHAR(15),
 CONSTRAINT assem_ck CHECK (ASSEMBLY_ID IN('ENG','CHA','BOD'))
);
--Table for Part
CREATE TABLE Part (
  PART_NUM VARCHAR2(5) Primary KEY,
  PART_NAME VARCHAR2(15),
  ASSEMBLY_ID VARCHAR2(4) CONSTRAINT ASSEM_FK REFERENCES ASSEMBLY(ASSEMBLY_ID)
);
--Table for Current Backorder
CREATE TABLE CURRENT_BACKORDER (
  CBACK_ID VARCHAR2(4) PRIMARY KEY,
  PART_NUM VARCHAR2(5) CONSTRAINT CBPart_fk REFERENCES PART(PART_NUM),
  ORIGINAL_QTY NUMBER(20),
  BO_DATE Date NOT NULL,
  EMP_NUM NUMBER(6) Constraint CBEMP_fk References EMPLOYEE(EMP_NUM)
);
--Table for Old Backorder
CREATE TABLE OLD_BACKORDER (
  OBACK_ID NUMBER(4) Primary Key,
  PART_NUM VARCHAR2(5) constraint OPart_fk References PART(PART_NUM),
  BO_DATE DATE NOT NULL,
  FULFILLED_DATE DATE NOT NULL,
  QTY_ORDER NUMBER(10),
  EMP_NUM NUMBER(6) Constraint EMP_fk References EMPLOYEE(EMP_NUM)
);

--Table for Batch
CREATE TABLE BATCH (
  BATCH_NUM NUMBER(3) PRIMARY KEY,
  PART_NUM VARCHAR2(5) CONSTRAINT BPart_fk REFERENCES PART(PART_NUM),
  WAREHOUSE_ID VARCHAR2(4) CONSTRAINT BWAR_FK REFERENCES WAREHOUSE(WAREHOUSE_ID),
  BIN_NUM NUMBER(2) CONSTRAINT BBIN_fk REFERENCES BIN(BIN_NUM),
  BAT_SIZE NUMBER(3),
  DATE_IN DATE NOT NULL,
  EMP_NUM number(6) CONSTRAINT BEMP_fk REFERENCES Employee(EMP_NUM)
 );
--Table for Item 
CREATE TABLE ITEM(
  ITEM_NUM NUMBER(3) NOT NULL PRIMARY KEY,
  PART_NUM VARCHAR2(5) CONSTRAINT Part_fk REFERENCES PART(PART_NUM),
  BATCH_NUM NUMBER(3) CONSTRAINT bat_fk REFERENCES Batch(BATCH_NUM),
  DATE_OUT DATE,
  EMP_NUM number(6) CONSTRAINT iemp_fk REFERENCES Employee(EMP_NUM)
);


--Insert for warehouse
Insert into warehouse Values('LYUU');
Insert into warehouse Values('MYHO');
Insert into warehouse Values('WTJU');
Insert into warehouse Values('QNIJ');
Insert into warehouse Values('OSPG');
Insert into warehouse Values('ZFKW');
Insert into warehouse Values('RUCY');
Insert into warehouse Values('AZUA');
Insert into warehouse Values('VNQO');
Insert into warehouse Values('LAMY');
--Insert for BIN
Insert into bin values (0, 'LYUU', 100); 
Insert into bin values(1, 'LYUU', 100);
Insert into bin values(2, 'LYUU', 100);
Insert into bin values(3, 'LYUU', 100);
Insert into bin values(4, 'MYHO', 200);
Insert into bin values(5, 'MYHO', 200);
Insert into bin values(6, 'MYHO', 200);
Insert into bin values(7, 'MYHO', 200);
Insert into bin values(8, 'MYHO', 200);
Insert into bin values(9, 'MYHO', 200);
Insert into bin values (10,'WTJU', 300);
Insert into bin values(11,'WTJU', 300);
Insert into bin values(12,'WTJU', 300);
Insert into bin values(13,'WTJU', 300);
Insert into bin values (14,'QNIJ', 400);
Insert into bin values(15,'QNIJ', 400);
Insert into bin values(16,'QNIJ', 400);
Insert into bin values(17,'QNIJ', 400);
Insert into bin values (18,'OSPG', 500);
Insert into bin values(19,'OSPG', 500);
Insert into bin values(20,'OSPG', 500);
Insert into bin values(21,'OSPG', 500);
Insert into bin values (22,'ZFKW', 150);
Insert into bin values(23,'ZFKW', 150);
Insert into bin values(24,'ZFKW', 150);
Insert into bin values(25,'ZFKW', 150);
Insert into bin values (26,'RUCY', 250);
Insert into bin values(27,'RUCY', 250);
Insert into bin values(28,'RUCY', 250);
Insert into bin values(29,'RUCY', 250);
Insert into bin values (30,'AZUA', 350);
Insert into bin values(31,'AZUA', 350);
Insert into bin values(32,'AZUA', 350);
Insert into bin values(33,'AZUA', 350);
Insert into bin values (34,'VNQO', 350);
Insert into bin values(35,'VNQO', 350);
Insert into bin values(36,'VNQO', 350);
Insert into bin values(37,'VNQO', 350);
Insert into bin values (38,'LAMY', 150);
Insert into bin values(39,'LAMY', 150);
Insert into bin values(40,'LAMY', 150);
Insert into bin values(41,'LAMY', 150);
--Inserts for employee
Insert into Employee values (548210, 'Rudy', 'Lloyd', 'Rudolph', 6181, 'Gilded Boulevard', 'Garland', 'TX', 75007, null);
Insert into Employee values (985173, 'Emanuel', 'Stevens', 'Ron', 00635,  'Art Avenue', 'Goldendale', 'TX', 75009,  null);
Insert into Employee values (810174, 'Melanie', 'Stevenson', 'Inez', 214599, 'Pearl Way', 'Imboden', 'TX', 75013, null);	
Insert into Employee values (849325, 'Hilda', 'Nichols', 'Linda', 531048, 'Campus Street', 'Duvall', 'TX', 75019,  null);
Insert into Employee values (104586, 'Tamara', 'Wong', 'Elsa', 7299, 'Coral Street', 'Duvall', 'TX', 75019, 693147);
Insert into Employee values (213584, 'Tim', 'Collier', 'Esther', 23236, 'Union Street', 'Garland', 'TX', 75007, 810174);
Insert into Employee values (693147, 'Gina', 'Paul', 'Ervin', 5206, 'Palm Avenue', 'Kirby', 'TX', 75022, 985173);
Insert into Employee values (361015, 'Chris', 'Joseph', 'Dorothy', 71257, 'Acorn Lane', 'Berryville', 'TX', 75243, 849325);
Insert into Employee values (148926, 'Austin', 'Patterson', 'Perry', 11722, 'Canal Street', 'Berryville', 'TX', 75243, 104586);
Insert into Employee values (978102, 'Bill', 'Rogers', 'Lamb', 29848, 'Peace Avenue', 'Kirby', 'TX', 75022, 693147);
--Inserts for Emp_phone
Insert into emp_phone values (548210, 469, 932671);
Insert into emp_phone values(985173, 214, 519621);
Insert into emp_phone values(810174, 972, 691753);
Insert into emp_phone values(849325, 972, 852107);
Insert into emp_phone values(104586, 214, 710841);	
Insert into emp_phone values(213584, 214, 410216);
Insert into emp_phone values(693147, 469, 710169);
Insert into emp_phone values(361015, 972, 817104);
Insert into emp_phone values(148926, 945, 942510);
Insert into emp_phone values(978102, 469, 154789);
--values for assembly
INSERT INTO assembly values ('ENG', 'Engine');
INSERT INTO assembly values ('BOD','Body');
INSERT INTO assembly values ('CHA','Chassis');
--insert for part
INSERT INTO PART VALUES ('1000a', 'Engine', 'ENG');
INSERT INTO PART VALUES('1001b', 'Transmission','CHA'); 
INSERT INTO PART VALUES('1002c', 'Battery','ENG');
INSERT INTO PART VALUES ('1003d', 'Alternator','ENG'); 
INSERT INTO PART VALUES('1004e', 'Radiator','ENG'); 
INSERT INTO PART VALUES('1005f', 'Brakes','BOD'); 
INSERT INTO PART VALUES('1006g', 'Tires','BOD');
INSERT INTO PART VALUES ('1007h', 'Muffler','BOD');
INSERT INTO PART VALUES('1008i', 'Fuel Tank', 'CHA'); 
INSERT INTO PART VALUES('1009j', 'Trunk', 'BOD');
--insert for Current_backorder
Insert into current_backorder values (1000, '1000a', 10, '02-FEB-2022', 693147);
Insert into current_backorder values (1001, '1009j', 100, '09-FEB-2022', 693147);
Insert into current_backorder values (1002, '1001b', 55, '11-FEB-2022', 104586);
Insert into current_backorder values (1003, '1008i', 40, '12-FEB-2022', 810174);
Insert into current_backorder values (1004, '1002c', 30, '12-FEB-2022', 985173);
Insert into current_backorder values (1005, '1005f', 32, '14-FEB-2022', 849325);
Insert into current_backorder values (1006, '1003d', 98, '15-FEB-2022', 810174);
Insert into current_backorder values (1007, '1000a', 160, '18-FEB-2022', 104586);
Insert into current_backorder values (1008, '1005f', 100, '20-FEB-2022', 849325);
Insert into current_backorder values (1009, '1004e', 235, '21-FEB-2022', 985173);
--insert for Old_backorder
Insert into old_backorder values (0001, '1000a', '01-JAN-2022', '03-JAN-2022', 20, 693147);
Insert into old_backorder values (0002, '1001b', '03-JAN-2022', '08-JAN-2022', 100, 849325);
Insert into old_backorder values (0003, '1002c', '04-JAN-2022', '05-JAN-2022', 90, 810174);
Insert into old_backorder values (0004, '1003d', '05-JAN-2022', '09-JAN-2022', 50, 693147);
Insert into old_backorder values (0005, '1005f', '06-JAN-2022', '10-JAN-2022', 200, 985173);
Insert into old_backorder values(0006, '1004e', '07-JAN-2022', '12-JAN-2022', 70, 104586);
Insert into old_backorder values(0007, '1000a', '10-JAN-2022', '15-JAN-2022', 60, 849325);
Insert into old_backorder values(0008, '1004e', '11-JAN-2022', '17-JAN-2022', 122, 985173);
Insert into old_backorder values(0009, '1003d', '15-JAN-2022', '17-JAN-2022', 20, 104586);
Insert into old_backorder values(0010, '1009j', '18-JAN-2022', '25-JAN-2022', 120, 985173);
--insert for Batch
INSERT INTO BATCH VALUES (1, '1000a', 'LYUU', 27, 100,'01-JAN-2022', 548210);
INSERT INTO BATCH VALUES(2, '1001b', 'MYHO', 30, 200, '01-FEB-2022', 985173);
INSERT INTO BATCH VALUES(3,'1002c', 'WTJU', 33,300, '01-MAR-2022', 810174);
INSERT INTO BATCH VALUES(4, '1003d', 'QNIJ', 36,400, '01-APR-2022', 849325);
INSERT INTO BATCH VALUES(5, '1004e', 'OSPG', 39,500, '01-MAY-2022', 104586);
INSERT INTO BATCH VALUES(6, '1005f', 'ZFKW', 23,150, '01-JUN-2022', 213584);
INSERT INTO BATCH VALUES(7, '1006g', 'RUCY', 28,250, '01-JUL-2022', 693147);
INSERT INTO BATCH VALUES(8, '1007h', 'AZUA', 32,350, '01-AUG-2022', 361015);
INSERT INTO BATCH VALUES(9, '1008i', 'VNQO', 36,350, '01-SEP-2022', 148926);
INSERT INTO BATCH VALUES(10,'1009j', 'LAMY',41,400, '01-OCT-2022', 978102);
--insert for item
INSERT INTO ITEM VALUES (001, '1000a', 1, '01-JAN-2022',548210);
INSERT INTO ITEM VALUES(002, '1001b', 2,'01-FEB-2022', 985173);
INSERT INTO ITEM VALUES(003,'1002c', 3,'01-MAR-2022',810174);
INSERT INTO ITEM VALUES(004, '1003d', 4,'01-APR-2022' ,849325);
INSERT INTO ITEM VALUES(005, '1004e', 5, '01-MAY-2022',104586);
INSERT INTO ITEM VALUES(006, '1005f', 6,'01-JUN-2022' ,213584);
INSERT INTO ITEM VALUES(007, '1006g', 7, '01-JUL-2022',693147);
INSERT INTO ITEM VALUES(008, '1007h', 8,'01-AUG-2022' ,361015);
INSERT INTO ITEM VALUES(009, '1008i', 9, '01-SEP-2022',148926);
INSERT INTO ITEM VALUES(010, '1009j', 10, '01-OCT-2022',978102);
