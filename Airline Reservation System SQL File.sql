/* NAME - ANGELINA TELIDEVARA
COURSE - IFT 530 ADVANCED DATABASE MANAGEMENT SYSTEMS
SUBMISSION - 28-11-2023
PROFESSOR - ASHISH GULATI 
*/

GO
Create Database ANGEL_935;
GO
USE [ANGEL_935];

-- DROP DATABASE IF EXISTS ANGEL_935;
-- GO

--Create Airport table
CREATE TABLE Airport
(
Airport_ID int not null,
AirportName varchar(100),
AirportCity varchar(100),
AirportCountry varchar(100),
CONSTRAINT Airport_PK PRIMARY KEY (Airport_ID)
);

-- Select statement to show the output of the table
SELECT * FROM Airport;

-- DROP TABLE IF EXISTS Airport;
-- GO




-- create Passenger table 
create table Passenger 
(
Passenger_ID INT not null,
P_FirstName VARCHAR(100),
P_LastName VARCHAR(100),
P_Email VARCHAR(100) ,
P_PhoneNumber BIGINT not null ,
P_Address VARCHAR(100),
P_City VARCHAR(100),
P_State VARCHAR(100),
P_Zipcode VARCHAR(100) CONSTRAINT zip_chk CHECK (LEN(P_Zipcode)=5),
P_Country VARCHAR(100)
CONSTRAINT Passenger_ID_PK PRIMARY KEY (Passenger_ID)
);

-- Select statement to show the output of the table
SELECT * FROM Passenger;

-- DROP TABLE IF EXISTS Passenger;
-- GO



-- create Travel class
CREATE TABLE Travel_Class
(
 Travel_Class_ID INT NOT NULL,
 Travel_Class_Name VARCHAR(100) ,
 Travel_Class_Capacity BIGINT,
 CONSTRAINT Travel_Class_PK PRIMARY KEY (Travel_Class_ID)
);

-- Select statement to show the output of the table
SELECT * FROM Travel_Class;

-- DROP TABLE IF EXISTS Travel Class;
-- GO




-- create Calendar table
CREATE TABLE Calendar
(
 Day_Date Date NOT NULL,
 Business_Day_YN CHAR(1) ,
 CONSTRAINT Calendar_PK PRIMARY KEY (Day_Date)
);

-- Select statement to show the output of the table
SELECT * FROM Calendar;

-- DROP TABLE IF EXISTS Calendar;
-- GO



--ALTER TABLE Flight_Service ALTER [Service_Name] CONSTRAINT Service_chk CHECK([Service_Name] in ('Food','French Wine','Wifi','Entertainment','Lounge'));
-- create Flight Details table

CREATE TABLE Flight_Details (
 Flight_ID INT NOT NULL,
 Source_Airport_ID INT NOT NULL,
 Destination_Airport_ID INT NOT NULL ,
 Departure_Date_Time DateTime,
 Arrival_Date_time DateTime,
 Airplane_Type VARCHAR(100), --
 CONSTRAINT Flight_Details_PK PRIMARY KEY (Flight_ID),
 CONSTRAINT Flight_Details_Source_FK1 FOREIGN KEY (Source_Airport_ID) REFERENCES Airport(Airport_ID),
 CONSTRAINT Flight_Details_Destination_FK2 FOREIGN KEY (Destination_Airport_ID) REFERENCES Airport(Airport_ID),
 );

-- Select statement to show the output of the table
SELECT * FROM Flight_Details;

-- DROP TABLE IF EXISTS Flight_Details;
-- GO



 -- create Seat Details table
 CREATE TABLE Seat_Details
(
 Seat_ID VARCHAR(100) NOT NULL,
 Travel_Class_ID INT NOT NULL, 
 Flight_ID INT NOT NULL,
 CONSTRAINT Seat_Details_PK PRIMARY KEY (Seat_ID),
 CONSTRAINT Seat_Details_TravelClassID_FK1 FOREIGN KEY (Travel_Class_ID) REFERENCES Travel_Class(Travel_Class_ID),
 CONSTRAINT Seat_Details_FlightID_FK2 FOREIGN KEY (Flight_ID) REFERENCES Flight_Details(Flight_ID)
)

-- Select statement to show the output of the table
SELECT * FROM Seat_Details;

-- DROP TABLE IF EXISTS Seat_Details;
-- GO



-- create Reservation table 
 CREATE TABLE Reservation (
 Reservation_ID INT NOT NULL,
 Passenger_ID INT NOT NULL,
 Seat_ID VARCHAR(100) NOT NULL,
 --Default Value recorded below
 Date_Of_Reservation Date DEFAULT(getDate()),
 CONSTRAINT Reservation_PK PRIMARY KEY (Reservation_ID),
 CONSTRAINT Reservation_Passenger_ID_FK1 FOREIGN KEY (Passenger_ID) REFERENCES Passenger(Passenger_ID),
 CONSTRAINT Reservation_Seat_ID_FK2 FOREIGN KEY (Seat_ID) REFERENCES Seat_Details(Seat_ID)
 );

-- Select statement to show the output of the table
SELECT * FROM Reservation 

-- DROP TABLE IF Reservation;
-- GO


 -- create Payment Status table
 --add table again
  CREATE TABLE Payment_Status (
 Payment_ID INT NOT NULL IDENTITY(1,1),
 Payment_Status_YN CHAR(1) ,
 Payment_Due_Date Date,
 Payment_Amount INT,
 Reservation_ID INT NOT NULL,
 CONSTRAINT Payment_Status_PK PRIMARY KEY (Payment_ID),
 CONSTRAINT Payment_Reservation_ID_FK FOREIGN KEY (Reservation_ID) REFERENCES Reservation(Reservation_ID)
 );

-- Select statement to show the output of the table
SELECT * FROM Payment_Status

-- DROP TABLE IF Payment_Status;
-- GO


--create Flight cost table 
CREATE TABLE Flight_Cost
(   
 Seat_ID VARCHAR(100) NOT NULL,
 Valid_From_Date Date NOT NULL,
 Valid_To_Date Date NOT NULL,
 Cost BIGINT,
 CONSTRAINT Flight_Cost_PK PRIMARY KEY (Seat_ID,Valid_From_Date),
 CONSTRAINT Flight_Cost_Seat_ID_FK1 FOREIGN KEY (Seat_ID) REFERENCES Seat_Details(Seat_ID),
 CONSTRAINT Flight_Cost_Valid_From_Date_FK2 FOREIGN KEY (Valid_From_Date) REFERENCES Calendar(Day_Date),
 CONSTRAINT Flight_Cost_Valid_To_Date_FK3 FOREIGN KEY (Valid_To_Date) REFERENCES Calendar(Day_Date)
);

-- Select statement to show the output of the table
SELECT * FROM Flight_Cost;

-- DROP TABLE IF Flight_Cost;
-- GO



/*
-- create Flight Service table
create table Flight_Service
(
Service_ID INT not null,
[Service_Name] VARCHAR(100) CONSTRAINT Service_chk CHECK([Service_Name] in ('Food','French Wine','Wifi','Entertainment','Lounge')),
CONSTRAINT Flight_Service_PK PRIMARY KEY (Service_ID)
);

*/

--create Service offering table 
CREATE TABLE Service_Offering
(
 Travel_Class_ID INT NOT NULL,
 Service_ID  int NOT NULL,
 [Service_Name] VARCHAR(100),
 Offered_YN CHAR(1) ,
 From_Month VARCHAR(20),
 To_Month VARCHAR(20),
 CONSTRAINT Service_Offering_TCI_FK1 FOREIGN KEY (Travel_Class_ID) REFERENCES Travel_Class(Travel_Class_ID),
 CONSTRAINT Service_Offering_PK PRIMARY KEY (Travel_Class_ID,Service_ID)
);

-- Select statement to show the output of the table
SELECT * FROM Service_Offering;

-- DROP TABLE IF Service_Offering;
-- GO


--Creating indexes for all primary keys
CREATE UNIQUE INDEX SO_Index ON Service_Offering(Travel_Class_ID,Service_ID);
CREATE UNIQUE INDEX FC_Index ON Flight_Cost(Seat_ID,Valid_From_Date);
CREATE UNIQUE INDEX PS_Index ON Payment_Status(Payment_ID);
CREATE UNIQUE INDEX R_Index ON Reservation(Reservation_ID);
CREATE UNIQUE INDEX SD_Index ON Seat_Details(Seat_ID);
CREATE UNIQUE INDEX FD_Index ON Flight_Details(Flight_ID);
--CREATE UNIQUE INDEX FS_Index ON Flight_Service(Service_ID);
CREATE UNIQUE INDEX Cal_Index ON Calendar(Day_Date);
CREATE UNIQUE INDEX T_Index ON Travel_Class(Travel_Class_ID);
CREATE UNIQUE INDEX Pass_Index ON Passenger(Passenger_ID);
CREATE UNIQUE INDEX Air_Index ON Airport(Airport_ID);


/*
--Creating non clustered index
USE P4_FBS
CREATE NONCLUSTERED INDEX email_indx ON Passenger(P_Email);
CREATE NONCLUSTERED INDEX dep_indx ON Flight_Details(Departure_Date_Time);
CREATE NONCLUSTERED INDEX city_indx ON Airport(AirportCity);
go
sp_helpindex Airport
go
sp_helpindex Passenger
go
sp_helpindex Flight_Details
*/





/* 
   Insert Records into Airport Table
   This SQL script inserts a list of major international airports into the 'Airport' table. 
   Each entry includes a unique Airport_ID and details such as the AirportName, AirportCity, 
   and AirportCountry. The 'Airport' table is a key part of the airline reservation system, 
   as it stores the data necessary for flight origin and destination points.
*/

INSERT INTO Airport (Airport_ID, AirportName, AirportCity, AirportCountry) VALUES
(1, 'Heathrow Airport', 'London', 'United Kingdom'),
(2, 'John F. Kennedy International Airport', 'New York', 'United States'),
(3, 'Charles de Gaulle Airport', 'Paris', 'France'),
(4, 'Haneda Airport', 'Tokyo', 'Japan'),
(5, 'Dubai International Airport', 'Dubai', 'United Arab Emirates');
INSERT INTO Airport (Airport_ID, AirportName, AirportCity, AirportCountry) VALUES
(6, 'Los Angeles International Airport', 'Los Angeles', 'United States'),
(7, 'Frankfurt Airport', 'Frankfurt', 'Germany'),
(8, 'Indira Gandhi International Airport', 'New Delhi', 'India'),
(9, 'Singapore Changi Airport', 'Singapore', 'Singapore'),
(10, 'Sydney Kingsford Smith Airport', 'Sydney', 'Australia');


/* 
   Retrieve All Airport Records
   This query selects all records from the 'Airport' table, providing a complete list 
   of airports currently stored in the database.
*/

select * from Airport;

-- Drop Airport table if it exists
-- DROP TABLE IF EXISTS Airport;



/* 
   Insert Records into Passenger Table
   This SQL script inserts records into the 'Passenger' table of the airline reservation system.
   Each passenger is given a unique ID and their personal details such as name, email, phone number,
   and address are stored. This data is essential for managing bookings and customer relations.
*/


INSERT INTO Passenger (Passenger_ID, P_FirstName, P_LastName, P_Email, P_PhoneNumber, P_Address, P_City, P_State, P_Zipcode, P_Country) VALUES
(1, 'John', 'Doe', 'johndoe@email.com', 1234567890, '123 Main St', 'New York', 'NY', '10001', 'United States'),
(2, 'Emily', 'Smith', 'emilysmith@email.com', 2345678901, '456 Elm St', 'Los Angeles', 'CA', '90001', 'United States'),
(3, 'Amit', 'Patel', 'amitpatel@email.com', 3456789012, '789 Maple Ave', 'Houston', 'TX', '77001', 'United States'),
(4, 'Maria', 'Garcia', 'mariagarcia@email.com', 4567890123, '101 Oak St', 'Chicago', 'IL', '60601', 'United States'),
(5, 'Yuki', 'Tanaka', 'yukitanaka@email.com', 5678901234, '202 Pine St', 'San Francisco', 'CA', '94101', 'United States');

INSERT INTO Passenger (Passenger_ID, P_FirstName, P_LastName, P_Email, P_PhoneNumber, P_Address, P_City, P_State, P_Zipcode, P_Country) VALUES
(6, 'Lucas', 'Brown', 'lucasbrown@email.com', 6789012345, '303 Birch Rd', 'Miami', 'FL', '33101', 'United States'),
(7, 'Sophia', 'Martinez', 'sophiamartinez@email.com', 7890123456, '404 Cedar Ln', 'Dallas', 'TX', '75201', 'United States'),
(8, 'Oliver', 'Wilson', 'oliverwilson@email.com', 8901234567, '505 Walnut St', 'Atlanta', 'GA', '30301', 'United States'),
(9, 'Emma', 'Lee', 'emmalee@email.com', 9012345678, '606 Spruce Dr', 'Seattle', 'WA', '98101', 'United States'),
(10, 'Liam', 'Taylor', 'liamtaylor@email.com', 1234567890, '707 Chestnut Ave', 'Boston', 'MA', '02101', 'United States');


/* 
   Retrieve All Passenger Records
   This query is used to select and view all the records from the 'Passenger' table, 
   displaying the list of passengers currently stored in the database.
*/

select * from Passenger;

-- Drop Passenger table if it exists
-- DROP TABLE IF EXISTS Passenger;



/* 
   Insert Records into Travel_Class Table
   This SQL script populates the 'Travel_Class' table with various classes available in the airline service.
   Each travel class has a unique ID, a name, and a capacity. These records are essential for categorizing 
   seating arrangements and managing the capacity for each flight section.
*/

INSERT INTO Travel_Class (Travel_Class_ID, Travel_Class_Name, Travel_Class_Capacity) VALUES
(1, 'Economy', 180),
(2, 'Economy Plus', 150),
(3, 'Premium Economy', 120),
(4, 'Business', 80),
(5, 'First Class', 50),
(6, 'Ultra Economy', 200),
(7, 'Compact Economy', 160),
(8, 'Luxury', 40),
(9, 'Executive', 30),
(10, 'VIP', 20);


/* 
   Retrieve All Travel_Class Records
   This query fetches all records from the 'Travel_Class' table, displaying the different travel classes
   and their respective capacities.
*/

select * from Travel_Class;

-- Drop Travel class table if it exists
--DROP TABLE IF EXISTS Travel_Class;




/* 
   Insert Records into Calendar Table
   This script adds records to the 'Calendar' table, specifying dates and whether 
   they are business days ('Y' for yes, 'N' for no). This information is crucial for 
   operational planning, such as flight scheduling and reservation management.
*/

INSERT INTO Calendar (Day_Date, Business_Day_YN) VALUES
('2023-01-01', 'N'), -- Assuming this is a weekend or holiday
('2023-01-02', 'Y'),
('2023-01-03', 'Y'),
('2023-01-04', 'Y'),
('2023-01-05', 'Y'),
('2023-01-06', 'Y'),
('2023-01-07', 'N'), -- Assuming weekends are non-business days
('2023-01-08', 'N'),
('2023-01-09', 'Y'),
('2023-01-10', 'Y');


/* 
   Retrieve All Calendar Records
   This query fetches all the records from the 'Calendar' table, providing a complete overview 
   of the business and non-business days as recorded in the system.
*/

select * from Calendar;

-- Drop Calendar table if it exists
--DROP TABLE IF EXISTS Calendar;



/* 
   Insert Records into Flight_Details Table
   This SQL script adds flight scheduling information into the 'Flight_Details' table. 
   Each entry includes a unique Flight_ID and associated details such as Source_Airport_ID, 
   Destination_Airport_ID, Departure_Date_Time, Arrival_Date_time, and Airplane_Type. 
   This table is crucial for managing the flight schedules and aircraft assignments.
*/

INSERT INTO Flight_Details (Flight_ID, Source_Airport_ID, Destination_Airport_ID, Departure_Date_Time, Arrival_Date_time, Airplane_Type) VALUES
(1, 1, 2, '2023-01-01 08:00:00', '2023-01-01 12:00:00', 'Boeing 737'),
(2, 3, 4, '2023-01-02 09:30:00', '2023-01-02 14:00:00', 'Airbus A320'),
(3, 2, 5, '2023-01-03 07:15:00', '2023-01-03 10:45:00', 'Boeing 777'),
(4, 6, 7, '2023-01-04 06:00:00', '2023-01-04 09:30:00', 'Boeing 787 Dreamliner'),
(5, 8, 9, '2023-01-05 18:45:00', '2023-01-06 00:15:00', 'Airbus A380'),
(6, 5, 10, '2023-01-06 11:00:00', '2023-01-06 15:30:00', 'Boeing 747'),
(7, 7, 3, '2023-01-07 13:20:00', '2023-01-07 17:00:00', 'Embraer E190'),
(8, 4, 8, '2023-01-08 22:00:00', '2023-01-09 02:30:00', 'Airbus A330'),
(9, 9, 6, '2023-01-09 05:00:00', '2023-01-09 08:45:00', 'Boeing 737 MAX'),
(10, 10, 1, '2023-01-10 19:00:00', '2023-01-10 23:50:00', 'Airbus A350'),
(11, 2, 6, '2023-01-11 10:30:00', '2023-01-11 14:20:00', 'Boeing 767'),
(12, 3, 7, '2023-01-12 16:00:00', '2023-01-12 20:30:00', 'Boeing 757'),
(13, 8, 5, '2023-01-13 08:45:00', '2023-01-13 12:10:00', 'Airbus A340'),
(14, 1, 9, '2023-01-14 21:15:00', '2023-01-15 01:00:00', 'Bombardier CRJ900'),
(16, 6, 3, '2023-01-16 09:30:00', '2023-01-16 13:15:00', 'Airbus A320neo'),
(17, 10, 8, '2023-01-17 14:00:00', '2023-01-17 18:25:00', 'Boeing 737 MAX 8'),
(18, 5, 2, '2023-01-18 07:45:00', '2023-01-18 11:30:00', 'Airbus A220'),
(19, 7, 1, '2023-01-19 22:10:00', '2023-01-20 02:00:00', 'Embraer E195-E2'),
(20, 9, 4, '2023-01-20 12:00:00', '2023-01-20 15:50:00', 'Bombardier Q400');
(21, 3, 9, '2023-01-21 10:00:00', '2023-01-21 13:40:00', 'Boeing 787 Dreamliner');


/* 
   Retrieve All Flight_Details Records
   This query fetches all the records from the 'Flight_Details' table to display the scheduled flights.
*/

select * from Flight_Details;

-- Drop Flight_Details table if it exists
--DROP TABLE IF EXISTS Flight_Details;



/* 
   Insert Records into Seat_Details Table
   This SQL script inserts records into the 'Seat_Details' table of the airline reservation system.
   It specifies seat assignments for various flights, indicating the seat ID, the travel class ID,
   and the flight ID. This forms a crucial part of the reservation process, associating seats with 
   their respective flights and classes.
*/

INSERT INTO Seat_Details (Seat_ID, Travel_Class_ID, Flight_ID) VALUES
('6A', 6, 3),
('6B', 6, 3),
('7A', 7, 4),
('7B', 7, 4),
('8A', 8, 4),
('8B', 8, 4),
('9A', 9, 5),
('9B', 9, 5),
('10A', 10, 5),
('10B', 10, 5),
('1C', 1, 6),
('1D', 1, 6),
('2C', 2, 6),
('2D', 2, 6),
('3C', 3, 7),
('3D', 3, 7),
('4C', 4, 7),
('4D', 4, 7),
('5C', 5, 8),
('5D', 5, 8);

/* 
   Retrieve All Seat_Details Records
   This query is used to select and view all the records from the 'Seat_Details' table, 
   displaying the list of seat assignments currently stored in the database.
*/

select * from Seat_Details;

-- Drop Seat_Deatils table if it exists
--DROP TABLE IF EXISTS Seat_Deatils;





/* 
   Insert Records into Reservation Table
   This script adds records to the 'Reservation' table, linking passengers with specific seats.
   Each reservation has a unique ID, and is associated with a passenger ID and a seat ID.
   This table is crucial for tracking the reservations made by passengers.
*/


INSERT INTO Reservation (Reservation_ID, Passenger_ID, Seat_ID) VALUES
(21, 1, '6A'),
(22, 2, '6B'),
(23, 3, '7A'),
(24, 4, '7B'),
(25, 5, '8A'),
(26, 6, '8B'),
(27, 7, '9A'),
(28, 8, '9B'),
(29, 9, '10A'),
(30, 10, '10B'),
(31, 1, '1C'),
(32, 2, '1D'),
(33, 3, '2C'),
(34, 4, '2D'),
(35, 5, '3C'),
(36, 6, '3D'),
(37, 7, '4C'),
(38, 8, '4D'),
(39, 9, '5C'),
(40, 10, '5D');

/* 
   Retrieve All Reservation Records
   This query fetches all entries from the 'Reservation' table, allowing for review and verification 
   of the reservation details.
*/

Select * from Reservation;

-- Drop Reservation table if it exists
--DROP TABLE IF EXISTS Reservation;




/* 
   Insert Records into Payment_Status Table
   This script inserts payment details for various reservations into the 'Payment_Status' table.
   Each record includes whether the payment status is confirmed ('Y' for yes, 'N' for no),
   the due date for the payment, the amount, and the associated reservation ID.
   This data is crucial for managing financial transactions and customer account statuses.
*/

INSERT INTO Payment_Status (Payment_Status_YN, Payment_Due_Date, Payment_Amount, Reservation_ID) VALUES
('Y', '2023-02-01', 500, 21),
('N', '2023-02-02', 550, 22),
('Y', '2023-02-03', 600, 23),
('Y', '2023-02-04', 650, 24),
('N', '2023-02-05', 700, 25),
('Y', '2023-02-06', 750, 26),
('N', '2023-02-07', 800, 27),
('Y', '2023-02-08', 850, 28),
('N', '2023-02-09', 900, 29),
('Y', '2023-02-10', 950, 30),
('Y', '2023-02-11', 1000, 31),
('N', '2023-02-12', 1050, 32),
('Y', '2023-02-13', 1100, 33),
('N', '2023-02-14', 1150, 34),
('Y', '2023-02-15', 1200, 35),
('N', '2023-02-16', 1250, 36),
('Y', '2023-02-17', 1300, 37),
('N', '2023-02-18', 1350, 38),
('Y', '2023-02-19', 1400, 39),
('N', '2023-02-20', 1450, 40);

/* 
   Retrieve All Payment_Status Records
   This query fetches all records from the 'Payment_Status' table for review and verification
   of payment details associated with each reservation.
*/

Select * from Payment_Status;

-- Drop Payment Status table if it exists
--DROP TABLE IF EXISTS Payment_Status;




/* 
   Insert Records into Flight_Cost Table
   This SQL script inserts pricing details into the 'Flight_Cost' table for various seats on different flights.
   The data includes a unique Seat_ID and the period (Valid_From_Date to Valid_To_Date) during which the cost is applicable.
   The 'Cost' column specifies the price for that seat within the given date range.
   This information is critical for managing flight revenue and providing customers with cost details.
*/

INSERT INTO Flight_Cost (Seat_ID, Valid_From_Date, Valid_To_Date, Cost) VALUES
('6A', '2023-01-01', '2023-01-06', 200),
('6B', '2023-01-01', '2023-01-06', 200),
('7A', '2023-01-02', '2023-01-07', 250),
('7B', '2023-01-02', '2023-01-07', 250),
('8A', '2023-01-03', '2023-01-08', 300),
('8B', '2023-01-03', '2023-01-08', 300),
('9A', '2023-01-04', '2023-01-09', 350),
('9B', '2023-01-04', '2023-01-09', 350),
('10A', '2023-01-05', '2023-01-10', 400),
('10B', '2023-01-05', '2023-01-10', 400),
('1C', '2023-01-06', '2023-01-10', 450),
('1D', '2023-01-06', '2023-01-10', 450),
('2C', '2023-01-07', '2023-01-10', 500),
('2D', '2023-01-07', '2023-01-10', 500),
('3C', '2023-01-08', '2023-01-10', 550),
('3D', '2023-01-08', '2023-01-10', 550),
('4C', '2023-01-09', '2023-01-10', 600),
('4D', '2023-01-09', '2023-01-10', 600),
('5C', '2023-01-10', '2023-01-10', 650),
('5D', '2023-01-10', '2023-01-10', 650);

/* 
   Retrieve All Flight Cost Records
   This query fetches all records from the 'Flight_Cost' table to display the cost details
   for seats on various flights within the specified date ranges.
*/

select * from Flight_Cost;

-- Drop Flight cost table if it exists
--DROP TABLE IF EXISTS Flight_Cost;




/* 
   Insert Records into Service_Offering Table
   This script populates the 'Service_Offering' table with the services available in different travel classes. 
   Each service is associated with a Travel_Class_ID and a unique Service_ID.
   The Service_Name is specified along with whether it is currently offered (Offered_YN), 
   and the months during which the service is available (From_Month and To_Month).
*/

INSERT INTO Service_Offering (Travel_Class_ID, Service_ID, Service_Name, Offered_YN, From_Month, To_Month) VALUES
(1, 101, 'In-Flight Meal', 'Y', 'January', 'December'),
(1, 102, 'Extra Legroom', 'N', 'January', 'December'),
(2, 201, 'In-Flight Entertainment', 'Y', 'January', 'December'),
(2, 202, 'Wi-Fi', 'Y', 'June', 'August'),
(3, 301, 'Priority Boarding', 'Y', 'January', 'December'),
(3, 302, 'Lounge Access', 'N', 'April', 'September'),
(4, 401, 'Complimentary Drinks', 'Y', 'January', 'December'),
(4, 402, 'Flat Beds', 'Y', 'January', 'December'),
(5, 501, 'Chauffeur Service', 'Y', 'March', 'November'),
(5, 502, 'Private Cabins', 'N', 'May', 'October'),
(6, 601, 'Extra Luggage Allowance', 'Y', 'January', 'December'),
(6, 602, 'Free Seat Selection', 'N', 'April', 'October'),
(7, 701, 'Complimentary Snacks', 'Y', 'January', 'December'),
(7, 702, 'Additional Mile Points', 'Y', 'March', 'November'),
(8, 801, 'Gourmet Meals', 'Y', 'January', 'December'),
(8, 802, 'Personal Assistant', 'N', 'June', 'August'),
(9, 901, 'Private Lounge', 'Y', 'February', 'November'),
(9, 902, 'Limousine Transfer', 'Y', 'April', 'September'),
(10, 1001, 'On-board Shower', 'Y', 'January', 'December'),
(10, 1002, 'Private Chef', 'N', 'May', 'October');


/* 
   Retrieve All Service Offering Records
   This query fetches all records from the 'Service_Offering' table to display the services 
   available across all travel classes within the system.
*/

select * from Service_Offering;

-- Drop Service_Offering table if it exists
--DROP TABLE IF EXISTS Service_Offering;




--VIEWS

-- QUERY - 1

-- Selecting various fields related to payments and passenger details
SELECT ps.Payment_ID, ps.Reservation_ID, ps.Payment_Due_Date, ps.Payment_Amount, p.Passenger_ID, p.P_FirstName, p.P_LastName
FROM Payment_Status ps -- From the Payment_Status table
JOIN Reservation r ON ps.Reservation_ID = r.Reservation_ID -- Joining with the Reservation table
JOIN Passenger p ON r.Passenger_ID = p.Passenger_ID -- Joining with the Passenger table
WHERE ps.Payment_Status_YN = 'N' AND ps.Payment_Due_Date < GETDATE(); -- Filtering for overdue payments

--VIEW - 1 

-- Creating a view named OverduePayments
CREATE VIEW OverduePayments AS
-- Selecting various fields related to payments and passenger details
SELECT ps.Payment_ID, ps.Reservation_ID, ps.Payment_Due_Date, ps.Payment_Amount, p.Passenger_ID, p.P_FirstName, p.P_LastName
FROM Payment_Status ps -- From the Payment_Status table
JOIN Reservation r ON ps.Reservation_ID = r.Reservation_ID -- Joining with the Reservation table
JOIN Passenger p ON r.Passenger_ID = p.Passenger_ID -- Joining with the Passenger table
WHERE ps.Payment_Status_YN = 'N' AND ps.Payment_Due_Date < GETDATE(); -- Filtering for overdue payments

-- Executing the view to retrieve overdue payments
SELECT * FROM OverduePayments;

-- Dropping the OverduePayments view
-- DROP VIEW OverduePayments;




--VIEW - 2

-- QUERY - 2

SELECT 
    fd.Flight_ID, -- Includes Flight ID from Flight_Details
    fd.Departure_Date_Time, -- Includes Departure Date and Time
    fd.Arrival_Date_time, -- Includes Arrival Date and Time
    a.AirportName, -- Includes Airport Name from Airport table
    fd.Airplane_Type -- Includes Airplane Type
FROM 
    Flight_Details fd -- From the Flight_Details table
JOIN 
    Airport a ON fd.Source_Airport_ID = a.Airport_ID -- Joins with the Airport table to get Airport details
WHERE 
    a.Airport_ID = 2 AND -- Filters for a specific Airport ID, here it is 2
    fd.Departure_Date_Time BETWEEN '2023-01-01' AND '2023-04-01'; -- Filters flights between the specified dates


-- Creating a view named UpcomingFlightsByAirport
-- This view will display upcoming flight details for a specific airport within a specified date range
CREATE VIEW UpcomingFlightsByAirport AS
SELECT 
    fd.Flight_ID, -- Includes Flight ID from Flight_Details
    fd.Departure_Date_Time, -- Includes Departure Date and Time
    fd.Arrival_Date_time, -- Includes Arrival Date and Time
    a.AirportName, -- Includes Airport Name from Airport table
    fd.Airplane_Type -- Includes Airplane Type
FROM 
    Flight_Details fd -- From the Flight_Details table
JOIN 
    Airport a ON fd.Source_Airport_ID = a.Airport_ID -- Joins with the Airport table to get Airport details
WHERE 
    a.Airport_ID = 2 AND -- Filters for a specific Airport ID, here it is 2
    fd.Departure_Date_Time BETWEEN '2023-01-01' AND '2023-04-01'; -- Filters flights between the specified dates

-- To retrieve data from the view
SELECT * FROM UpcomingFlightsByAirport;

-- To drop the view if it exists
--DROP VIEW IF EXISTS UpcomingFlightsByAirport;
--DROP VIEW UpcomingFlightsByAirport;



--VIEW - 3


-- QUERY - 3

SELECT 
    fd.Flight_ID, -- Selecting Flight ID from Flight_Details table.
    a1.AirportCountry AS Departure_Country, -- Getting the country of the departure airport.
    a2.AirportCountry AS Arrival_Country, -- Getting the country of the arrival airport.
    DATEDIFF(MINUTE, fd.Departure_Date_Time, fd.Arrival_Date_time) AS Duration_Minutes -- Calculating the duration of the flight in minutes.
FROM Flight_Details fd
JOIN Airport a1 ON fd.Source_Airport_ID = a1.Airport_ID -- Joining with Airport table to get departure airport details.
JOIN Airport a2 ON fd.Destination_Airport_ID = a2.Airport_ID -- Joining with Airport table to get arrival airport details.
WHERE a1.AirportCountry <> a2.AirportCountry; -- Filtering for flights where departure and arrival countries are different.

-- Creating a view named 'View_FlightDurationInternational'.
-- This view is designed to display the duration of international flights,
-- which are identified as flights where the departure and arrival countries are different.
CREATE VIEW View_FlightDurationInternational AS
SELECT 
    fd.Flight_ID, -- Selecting Flight ID from Flight_Details table.
    a1.AirportCountry AS Departure_Country, -- Getting the country of the departure airport.
    a2.AirportCountry AS Arrival_Country, -- Getting the country of the arrival airport.
    DATEDIFF(MINUTE, fd.Departure_Date_Time, fd.Arrival_Date_time) AS Duration_Minutes -- Calculating the duration of the flight in minutes.
FROM Flight_Details fd
JOIN Airport a1 ON fd.Source_Airport_ID = a1.Airport_ID -- Joining with Airport table to get departure airport details.
JOIN Airport a2 ON fd.Destination_Airport_ID = a2.Airport_ID -- Joining with Airport table to get arrival airport details.
WHERE a1.AirportCountry <> a2.AirportCountry; -- Filtering for flights where departure and arrival countries are different.

-- Selecting all records from the newly created view to display the duration of international flights.
SELECT * FROM View_FlightDurationInternational;

-- Commented out script to drop the view if it already exists. Uncomment this line to execute the drop view command.
-- DROP VIEW IF EXISTS View_FlightDurationInternational;
-- DROP VIEW View_FlightDurationInternational;



--VIEW - 4


-- QUERY - 4:

SELECT Passenger_ID, P_FirstName, P_LastName, P_Country
FROM Passenger
WHERE P_Country = 'United States';

-- Create a view named View_PassengersByNationality
-- This view will display the ID, first name, last name, and country of passengers
-- who are from the United States
CREATE VIEW View_PassengersByNationality AS
SELECT Passenger_ID, P_FirstName, P_LastName, P_Country
FROM Passenger
WHERE P_Country = 'United States';

-- Select everything from the View_PassengersByNationality view
-- This will display all the passengers from the United States
SELECT * FROM View_PassengersByNationality;

-- Uncomment the below line to drop the view if it already exists
-- DROP VIEW IF EXISTS View_PassengersByNationality;
-- DROP VIEW View_PassengersByNationality;



--TRIGGERS

-- Creating a table to store audit information for the Airport table.
CREATE TABLE Airport_Audit
(
    Audit_ID INT IDENTITY(1,1) PRIMARY KEY, -- A unique identifier for each audit record.
    Airport_ID int,                         -- The ID of the airport being audited.
    AirportName varchar(100),               -- The name of the airport.
    AirportCity varchar(100),               -- The city where the airport is located.
    AirportCountry varchar(100),            -- The country where the airport is located.
    OperationType varchar(10),              -- The type of operation (INSERT, UPDATE, DELETE).
    ChangedOn datetime DEFAULT GETDATE()    -- The date and time when the change occurred.
);

-- Use this statement to drop the Airport_Audit table if it is no longer needed.
-- DROP TABLE Airport_Audit;


-- Trigger to capture INSERT operations on the Airport table and record them in the Airport_Audit table.
CREATE TRIGGER trg_Airport_Insert
ON Airport
AFTER INSERT
AS
BEGIN
    INSERT INTO Airport_Audit (Airport_ID, AirportName, AirportCity, AirportCountry, OperationType)
    SELECT Airport_ID, AirportName, AirportCity, AirportCountry, 'INSERT'
    FROM inserted;
END;

-- Use this statement to drop the trg_Airport_Insert trigger if it is no longer needed.
-- DROP TRIGGER trg_Airport_Insert;



-- Trigger to capture UPDATE operations on the Airport table and record them in the Airport_Audit table.
CREATE TRIGGER trg_Airport_Update
ON Airport
AFTER UPDATE
AS
BEGIN
    INSERT INTO Airport_Audit (Airport_ID, AirportName, AirportCity, AirportCountry, OperationType)
    SELECT Airport_ID, AirportName, AirportCity, AirportCountry, 'UPDATE'
    FROM inserted;
END

-- Use this statement to drop the trg_Airport_Update trigger if it is no longer needed.
-- DROP TRIGGER trg_Airport_Update;



-- Trigger to capture DELETE operations on the Airport table and record them in the Airport_Audit table.
CREATE TRIGGER trg_Airport_Delete
ON Airport
AFTER DELETE
AS
BEGIN
    INSERT INTO Airport_Audit (Airport_ID, AirportName, AirportCity, AirportCountry, OperationType)
    SELECT Airport_ID, AirportName, AirportCity, AirportCountry, 'DELETE'
    FROM deleted;
END

-- Use this statement to drop the trg_Airport_Delete trigger if it is no longer needed.
-- DROP TRIGGER trg_Airport_Delete;


-- Select and display all records from the Airport_Audit table.
SELECT * FROM Airport_Audit;

-- Insert a new record into the Airport table.
-- This will add an airport with ID 11, named 'Test Airport', located in 'Test City', 'Test Country'.
INSERT INTO Airport (Airport_ID, AirportName, AirportCity, AirportCountry) 
VALUES (11, 'LA AIRPORT', 'RICH CRUST', 'UNITED STATES');


-- Update the name of the airport with ID 11 to 'San Francisco International Airport'.
UPDATE Airport 
SET AirportName = 'San Francisco International Airport' 
WHERE Airport_ID = 11;

-- Retrieve and display all records from the Airport table to view the changes.
SELECT * FROM Airport;

-- Deletes the record from the Airport table where the Airport_ID is 11.
DELETE FROM Airport WHERE Airport_ID = 11;

-- Selects and displays all remaining records from the Airport table.
SELECT * FROM Airport;

-- Select and display all records from the Airport_Audit table.
SELECT * FROM Airport_Audit;




--STORED PROCEDURES


-- 1. Procedure to add a new passenger to the Passenger table
CREATE PROCEDURE sp_AddNewPassenger
    @Passenger_ID INT,
    @P_FirstName VARCHAR(100),
    @P_LastName VARCHAR(100),
    @P_Email VARCHAR(100),
    @P_PhoneNumber BIGINT,
    @P_Address VARCHAR(100),
    @P_City VARCHAR(100),
    @P_State VARCHAR(100),
    @P_Zipcode VARCHAR(100),
    @P_Country VARCHAR(100)
AS
BEGIN
    INSERT INTO Passenger (Passenger_ID, P_FirstName, P_LastName, P_Email, P_PhoneNumber, P_Address, P_City, P_State, P_Zipcode, P_Country)
    VALUES (@Passenger_ID, @P_FirstName, @P_LastName, @P_Email, @P_PhoneNumber, @P_Address, @P_City, @P_State, @P_Zipcode, @P_Country);
END;


EXEC sp_AddNewPassenger 
    @Passenger_ID = 11, 
    @P_FirstName = 'joe', 
    @P_LastName = 'antony', 
    @P_Email = 'joe.antony@email.com', 
    @P_PhoneNumber = 9700055546, 
    @P_Address = '123 Maple Street', 
    @P_City = 'Tempe', 
    @P_State = 'Arizona', 
    @P_Zipcode = '84631', 
    @P_Country = 'Arizona';

	select * from Passenger;


-- Procedure to remove the sp_AddNewPassenger procedure
DROP PROCEDURE sp_AddNewPassenger;



	-- 2. Procedure to update the details of an existing passenger in the Passenger table
CREATE PROCEDURE sp_UpdatePassenger
    @Passenger_ID INT,
    @New_P_FirstName VARCHAR(100),
    @New_P_LastName VARCHAR(100),
    @New_P_Email VARCHAR(100),
    @New_P_PhoneNumber BIGINT,
    @New_P_Address VARCHAR(100),
    @New_P_City VARCHAR(100),
    @New_P_State VARCHAR(100),
    @New_P_Zipcode VARCHAR(100),
    @New_P_Country VARCHAR(100)
AS
BEGIN
    UPDATE Passenger
    SET P_FirstName = @New_P_FirstName,
        P_LastName = @New_P_LastName,
        P_Email = @New_P_Email,
        P_PhoneNumber = @New_P_PhoneNumber,
        P_Address = @New_P_Address,
        P_City = @New_P_City,
        P_State = @New_P_State,
        P_Zipcode = @New_P_Zipcode,
        P_Country = @New_P_Country
    WHERE Passenger_ID = @Passenger_ID;
END;


EXEC sp_UpdatePassenger 
    @Passenger_ID = 11, 
    @New_P_FirstName = 'annie', 
    @New_P_LastName = 'vincent', 
    @New_P_Email = 'annie.vincent@email.com', 
    @New_P_PhoneNumber = 9788833321, 
    @New_P_Address = '456 Oak Avenue', 
    @New_P_City = 'Dallas', 
    @New_P_State = 'Texas', 
    @New_P_Zipcode = '54321', 
    @New_P_Country = 'Texas';

select * from Passenger;

-- Procedure to remove the sp_UpdatePassenger procedure
DROP PROCEDURE sp_UpdatePassenger;




--CURSORS

DECLARE @Passenger_ID INT, @FirstName VARCHAR(100), @LastName VARCHAR(100)

-- 1. Creating a cursor for passengers from the United States
DECLARE PassengerCursor CURSOR FOR
SELECT Passenger_ID, P_FirstName, P_LastName
FROM Passenger
WHERE P_Country = 'United States'

-- Opening the cursor
OPEN PassengerCursor

-- Fetching the first row from the cursor
FETCH NEXT FROM PassengerCursor INTO @Passenger_ID, @FirstName, @LastName

-- Looping through the rows
WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT 'Passenger ID: ' + CAST(@Passenger_ID AS VARCHAR) + ', Name: ' + @FirstName + ' ' + @LastName

    -- Fetching the next row from the cursor
    FETCH NEXT FROM PassengerCursor INTO @Passenger_ID, @FirstName, @LastName
END

-- Closing and deallocating the cursor
CLOSE PassengerCursor
DEALLOCATE PassengerCursor



-- 2. Declare the variables to store the data for each row the cursor fetches
DECLARE @Flight_ID INT;
DECLARE @DepartureTime DATETIME;
DECLARE @ArrivalTime DATETIME;

-- Creating a cursor for flights on a specific date
DECLARE FlightCursor CURSOR FOR
    SELECT Flight_ID, Departure_Date_Time, Arrival_Date_time
    FROM Flight_Details
    WHERE CAST(Departure_Date_Time AS DATE) IN ('2023-01-01', '2023-01-04', '2023-01-06', '2023-01-08', '2023-01-09', '2023-01-11');

-- Opening the cursor
OPEN FlightCursor;

-- Fetching the first row from the cursor
FETCH NEXT FROM FlightCursor INTO @Flight_ID, @DepartureTime, @ArrivalTime;

-- Looping through the rows
WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT 'Flight ID: ' + CAST(@Flight_ID AS VARCHAR) + ', Departure: ' + CAST(@DepartureTime AS VARCHAR) + ', Arrival: ' + CAST(@ArrivalTime AS VARCHAR);

    -- Fetching the next row from the cursor
    FETCH NEXT FROM FlightCursor INTO @Flight_ID, @DepartureTime, @ArrivalTime;
END;

-- Closing and deallocating the cursor
CLOSE FlightCursor;
DEALLOCATE FlightCursor;



-- DROPPING ALL THE TABLES 
-- Use this statement to drop the Airport table if it is no longer needed.
DROP TABLE Airport;

-- Use this statement to drop the Passenger table if it is no longer needed.
DROP TABLE Passenger;

-- Use this statement to drop the Travel_Class table if it is no longer needed.
DROP TABLE Travel_Class;

-- Use this statement to drop the Calendar table if it is no longer needed.
DROP TABLE Calendar;

-- Use this statement to drop the Flight_Details table if it is no longer needed.
DROP TABLE Flight_Details;

-- Use this statement to drop the Seat_Details table if it is no longer needed.
DROP TABLE Seat_Details;

-- Use this statement to drop the Reservation table if it is no longer needed.
DROP TABLE Reservation;

-- Use this statement to drop the Payment_Status table if it is no longer needed.
DROP TABLE Payment_Status;

-- Use this statement to drop the Flight_Cost table if it is no longer needed.
DROP TABLE Flight_Cost;

-- Use this statement to drop the Service_Offering table if it is no longer needed.
DROP TABLE Service_Offering;

-- Use this statement to drop the Airport_Audit table if it is no longer needed.
DROP TABLE Airport_Audit;


-- DROP DATABASE IF EXISTS ANGEL_935;
DROP DATABASE ANGEL_935;

