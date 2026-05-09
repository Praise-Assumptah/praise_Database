-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: May 09, 2026 at 11:38 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `Hospital_Equipt_Management_System`
--

-- --------------------------------------------------------

--
-- Table structure for table `Departments`
--

CREATE TABLE `Departments` (
  `Dept_ID` int(11) NOT NULL,
  `Dept_Name` varchar(100) NOT NULL,
  `Floor_Location` varchar(50) NOT NULL,
  `Head_Of_Dept` varchar(100) NOT NULL,
  `Contact_Extension` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `Departments`
--

INSERT INTO `Departments` (`Dept_ID`, `Dept_Name`, `Floor_Location`, `Head_Of_Dept`, `Contact_Extension`) VALUES
(101, 'Radiology', '1st Floor, Wing A', 'Dr. Sarah Chen', 'Ext 405'),
(102, 'Intensive Care(ICU)', '2nd Floor, Wing B', 'Dr.Marcus Otto', 'Ext 911'),
(103, 'Cardiology', '3rd Floor,Wing C', 'Dr.Claire Arinda', 'Ext 234'),
(104, 'Operating Theater', '2nd Floor, Wing A', 'Dr.Agatha Ayesiga', 'Ext 143'),
(105, 'Emergency Room', 'Ground Floor', 'Dr.Elena Rodrick', 'Ext 911');

-- --------------------------------------------------------

--
-- Table structure for table `Equipment`
--

CREATE TABLE `Equipment` (
  `Equip_ID` int(11) NOT NULL,
  `Name` varchar(100) NOT NULL,
  `Status` varchar(50) NOT NULL,
  `Dept_ID` int(11) DEFAULT NULL,
  `Supplier_ID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `Equipment`
--

INSERT INTO `Equipment` (`Equip_ID`, `Name`, `Status`, `Dept_ID`, `Supplier_ID`) VALUES
(1, 'MRI Scanner', 'Operational', 101, 501),
(2, 'Ventilator v-40', 'Needs Repair', 102, 502),
(3, 'Defibrillator', 'Operational', 103, 501),
(4, 'X-Ray Mobile', 'Operational', 101, 501),
(5, 'Infusion Pump', 'Operational', 102, 502),
(6, 'CT Scanner', 'Operational', 101, 503),
(7, 'Anesthesia Machine', 'Operational', 104, 501),
(8, 'Patient Monitor', 'Operational', 102, 502),
(9, 'Dialysis Machine', 'Operational', 105, 502),
(10, 'Surgical Laser', 'Broken', 104, 502);

-- --------------------------------------------------------

--
-- Table structure for table `Maintenance_Log`
--

CREATE TABLE `Maintenance_Log` (
  `Log_ID` int(11) NOT NULL,
  `Log_Date` date NOT NULL,
  `Description` text NOT NULL,
  `Equip_ID` int(11) DEFAULT NULL,
  `Tech_ID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `Maintenance_Log`
--

INSERT INTO `Maintenance_Log` (`Log_ID`, `Log_Date`, `Description`, `Equip_ID`, `Tech_ID`) VALUES
(7001, '2026-04-20', 'Annual Calibration', 1, 903),
(7002, '2026-04-22', 'Battery Replacement', 3, 901),
(7003, '2026-04-25', 'Sensor Error Fix', 2, 902);

-- --------------------------------------------------------

--
-- Table structure for table `Suppliers`
--

CREATE TABLE `Suppliers` (
  `Supplier_ID` int(11) NOT NULL,
  `Company_Name` varchar(100) NOT NULL,
  `Contact_Person` varchar(100) NOT NULL,
  `Phone_Number` varchar(20) DEFAULT NULL,
  `Address` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `Suppliers`
--

INSERT INTO `Suppliers` (`Supplier_ID`, `Company_Name`, `Contact_Person`, `Phone_Number`, `Address`) VALUES
(501, 'MedTech Solutions', 'James Wilson', '+256 700 123456', '12 Industrial Area, Kampala'),
(502, ' Global Health COrp', 'Linda Mujuni', '+256 722 987654', '45 Medical Way, Nairobi'),
(503, 'Precision Bio', 'Robert Okello', '+256 755 000111', ' Plot 8, Jinja Road');

-- --------------------------------------------------------

--
-- Table structure for table `Technician`
--

CREATE TABLE `Technician` (
  `Tech_ID` int(11) NOT NULL,
  `Tech_Name` varchar(100) NOT NULL,
  `Specialty` varchar(100) NOT NULL,
  `Experience_Level` varchar(50) DEFAULT NULL,
  `Availability` varchar(20) DEFAULT 'Available'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `Technician`
--

INSERT INTO `Technician` (`Tech_ID`, `Tech_Name`, `Specialty`, `Experience_Level`, `Availability`) VALUES
(901, 'Praise Assumptah', 'Bio_Medical Eng', 'Senior', 'Available'),
(902, 'John Doe', 'Electrical Sys', ' Senior', 'On Repair'),
(903, 'Mary Atuhaire', 'Imaging Tech', 'Junior', 'Available'),
(904, 'Isaac Musoke', 'Radiology Specialist', 'Senior', 'Available'),
(905, 'Robert Okello', 'Laboratory Diagnostics', 'Intermediate', 'Available');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `Departments`
--
ALTER TABLE `Departments`
  ADD PRIMARY KEY (`Dept_ID`);

--
-- Indexes for table `Equipment`
--
ALTER TABLE `Equipment`
  ADD PRIMARY KEY (`Equip_ID`),
  ADD KEY `fk_dept` (`Dept_ID`),
  ADD KEY `fk_supplier` (`Supplier_ID`);

--
-- Indexes for table `Maintenance_Log`
--
ALTER TABLE `Maintenance_Log`
  ADD PRIMARY KEY (`Log_ID`),
  ADD KEY `fk_equip` (`Equip_ID`),
  ADD KEY `fk_tech` (`Tech_ID`);

--
-- Indexes for table `Suppliers`
--
ALTER TABLE `Suppliers`
  ADD PRIMARY KEY (`Supplier_ID`);

--
-- Indexes for table `Technician`
--
ALTER TABLE `Technician`
  ADD PRIMARY KEY (`Tech_ID`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `Equipment`
--
ALTER TABLE `Equipment`
  ADD CONSTRAINT `fk_dept` FOREIGN KEY (`Dept_ID`) REFERENCES `Departments` (`Dept_ID`),
  ADD CONSTRAINT `fk_supplier` FOREIGN KEY (`Supplier_ID`) REFERENCES `Suppliers` (`Supplier_ID`);

--
-- Constraints for table `Maintenance_Log`
--
ALTER TABLE `Maintenance_Log`
  ADD CONSTRAINT `fk_equip` FOREIGN KEY (`Equip_ID`) REFERENCES `Equipment` (`Equip_ID`),
  ADD CONSTRAINT `fk_tech` FOREIGN KEY (`Tech_ID`) REFERENCES `Technician` (`Tech_ID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
