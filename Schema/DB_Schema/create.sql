CREATE DATABASE IF NOT EXISTS erms;
USE erms;

SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS `User`;
SET FOREIGN_KEY_CHECKS=1;
CREATE TABLE IF NOT EXISTS `User` (
  username varchar(25) NOT NULL,
  `name` varchar(50) NOT NULL,
  `password` varchar(25) NOT NULL,
  PRIMARY KEY (username)
) ENGINE = InnoDB DEFAULT CHARSET = latin1;

SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS Individual;
SET FOREIGN_KEY_CHECKS=1;
CREATE TABLE IF NOT EXISTS Individual (
  username_Ind varchar(25) NOT NULL,
  jobTitle varchar(50) NOT NULL ,
  hiredDate date NOT NULL,
  PRIMARY KEY (username_Ind),
  CONSTRAINT IndividualUserFK
  FOREIGN KEY (username_Ind) REFERENCES `User`(username)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = latin1;

SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS Company;
SET FOREIGN_KEY_CHECKS=1;
CREATE TABLE IF NOT EXISTS Company (
  username_C varchar(25) NOT NULL,
  headquaterLocation varchar(50) NOT NULL,
  PRIMARY KEY (username_C),
  CONSTRAINT CompanyUserFK
  FOREIGN KEY (username_C) REFERENCES `User`(username)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS GovermentAgency;
SET FOREIGN_KEY_CHECKS=1;
CREATE TABLE IF NOT EXISTS GovermentAgency (
  username_G varchar(25) NOT NULL,
  jurisdiction varchar(50) NOT NULL,
  PRIMARY KEY (username_G),
  CONSTRAINT GovermentUserFK
  FOREIGN KEY (username_G) REFERENCES `User`(username)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS Municipality;
SET FOREIGN_KEY_CHECKS=1;
CREATE TABLE IF NOT EXISTS Municipality (
  username_M varchar(25) NOT NULL,
  populationSize int NOT NULL,
  PRIMARY KEY (username_M),
  CONSTRAINT MunicipalityUserFK
  FOREIGN KEY (username_M) REFERENCES `User`(username)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS Incident;
SET FOREIGN_KEY_CHECKS=1;
CREATE TABLE IF NOT EXISTS Incident (
  incidentID int NOT NULL AUTO_INCREMENT,
  description varchar(500) NOT NULL,
  occurDate date NOT NULL,
  username_Inc varchar(25) NOT NULL,
  longitude double NOT NULL,
  latitude double NOT NULL,
  PRIMARY KEY (incidentID),
  CONSTRAINT IncidentUserFK
  FOREIGN KEY (username_Inc) REFERENCES `User`(username)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS CostPer;
SET FOREIGN_KEY_CHECKS=1;
CREATE TABLE IF NOT EXISTS CostPer (
  costUnit varchar(10) NOT NULL,
  PRIMARY KEY (costUnit)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS ESF;
SET FOREIGN_KEY_CHECKS=1;
CREATE TABLE IF NOT EXISTS ESF (
  ESFNumber int NOT NULL,
  ESFDescription varchar(200) NOT NULL,
  PRIMARY KEY (ESFNumber)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS Resource;
SET FOREIGN_KEY_CHECKS=1;
CREATE TABLE IF NOT EXISTS Resource (
  resourceID int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  model varchar(25) DEFAULT NULL,
  `status` varchar(10) NOT NULL,
  longitude double NOT NULL,
  latitude double NOT NULL,
  esfNumber_R int NOT NULL,
  costUnit_R varchar(10) NOT NULL,
  costAmount double NOT NULL,
  availableDate date DEFAULT NULL,
  username_R varchar(25) NOT NULL,
  PRIMARY KEY (resourceID),
  CONSTRAINT ResourceUserFK
  FOREIGN KEY (username_R) REFERENCES `User` (username)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT ResourceESFFK
  FOREIGN KEY (ESFNumber_R) REFERENCES ESF (ESFNumber)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT RecourseCostPerFK
  FOREIGN KEY (costUnit_R) REFERENCES CostPer (costUnit)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS AdditionalESFs;
SET FOREIGN_KEY_CHECKS=1;
CREATE TABLE IF NOT EXISTS AdditionalESFs (
  ESFNumber_A int NOT NULL,
  resourceID_A int NOT NULL,
  PRIMARY KEY (ESFNumber_A, resourceID_A),
  CONSTRAINT AdditionalESFsESFFK
  FOREIGN KEY (ESFNumber_A) REFERENCES ESF (ESFNumber)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT AdditionalESFsResourceFK
  FOREIGN KEY (resourceID_A) REFERENCES Resource(resourceID)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS ResourceCapabilities;
SET FOREIGN_KEY_CHECKS=1;
CREATE TABLE IF NOT EXISTS ResourceCapabilities (
  resourceID_Res int NOT NULL,
  capability varchar(200) NOT NULL,
  PRIMARY KEY (resourceID_Res, capability),
  CONSTRAINT ResourceCapabilitiesResourceFK
  FOREIGN KEY (resourceID_Res) REFERENCES Resource(resourceID)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS Repair;
SET FOREIGN_KEY_CHECKS=1;
CREATE TABLE IF NOT EXISTS Repair (
  resourceID_Rep int NOT NULL,
  startDate_R date NOT NULL,
  endDate date NOT NULL,
  PRIMARY KEY (resourceID_Rep, startDate_R, endDate),
  CONSTRAINT RepairResourceFK
  FOREIGN KEY (resourceID_Rep) REFERENCES Resource(resourceID)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS Request;
SET FOREIGN_KEY_CHECKS=1;
CREATE TABLE IF NOT EXISTS Request(
  requestID int NOT NULL AUTO_INCREMENT,
  resourceID_Req int NOT NULL,
  incidentID_Req int NOT NULL,
  returnBy date NOT NULL,
  PRIMARY KEY (requestID),
  UNIQUE (incidentID_Req, resourceID_Req),
  CONSTRAINT RequestResourceFK
  FOREIGN KEY (resourceID_Req) REFERENCES Resource(resourceID)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT RequestIncidentFK
  FOREIGN KEY (incidentID_Req) REFERENCES Incident(incidentID)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS Deploy;
SET FOREIGN_KEY_CHECKS=1;
CREATE TABLE IF NOT EXISTS Deploy (
  requestID_D int NOT NULL,
  startDate_D date NOT NULL,
  returnDate date DEFAULT NULL,
  PRIMARY KEY (requestID_D),
  CONSTRAINT DeployRequestFK
  FOREIGN KEY (requestID_D) REFERENCES Request(requestID)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
