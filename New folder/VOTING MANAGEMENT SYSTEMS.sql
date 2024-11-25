create database VOTE_SYSTEM;
show databases;
use VOTE_SYSTEM;
CREATE TABLE tbl_voters (iVoterID INT NOT NULL AUTO_INCREMENT , 
vVoterName VARCHAR(50) NOT NULL , 
vEmail VARCHAR(50) NOT NULL , 
vPassword VARCHAR(50) NOT NULL , 
vAddress VARCHAR(50) NOT NULL , 
PRIMARY KEY (iVoterID));
describe tbl_voters;
CREATE TABLE tbl_votes 
(iVoteID INT NOT NULL AUTO_INCREMENT , 
dtDateTimeCast DATETIME NOT NULL , PRIMARY KEY 
 (iVoteID));
 describe tbl_votes;
 CREATE TABLE tbl_candidates
 (
  iCandidateID int(11) NOT NULL AUTO_INCREMENT ,
  vCandidateName varchar(50) NOT NULL,
  vPicturePath varchar(50) NOT NULL,
  PRIMARY KEY 
 (iCandidateID)
); 
describe tbl_candidates;
CREATE TABLE tbl_position 
(
iPositionID INT NOT NULL AUTO_INCREMENT ,
vPositionName VARCHAR(50) NOT NULL , 
PRIMARY KEY (iPositionID)
);
describe tbl_position;
CREATE TABLE tbl_parties 
(iPartyID INT NOT NULL AUTO_INCREMENT ,
 vPartyName VARCHAR(50) NOT NULL , 
vPartyImagePath VARCHAR(50) NOT NULL , PRIMARY KEY (iPartyID)
);
describe tbl_parties;
INSERT INTO tbl_position (iPositionID,vPositionName)
VALUES (10,'Mayor'),(20,'Council Member'),(35,'School Board Member'),(50,'Treasurer'),(75,'Secretary'),(90,'Auditor');
select * from tbl_position; 
INSERT INTO tbl_voters (vVoterName, vEmail, vPassword, vAddress) 
VALUES('Alice Smith', 'alice@example.com', 'password123', '123 Maple St'),
('Bob Johnson', 'bob@example.com', 'password456', '456 Oak St'),
('Charlie Brown', 'charlie@example.com', 'password789', '789 Pine St'),
('Diana Prince', 'diana@example.com', 'password101', '101 Elm St'),
('Ethan Hunt', 'Ethan@example.com', 'password202', '202 Birch St'),
('Fiona Apple', 'fiona@example.com', 'password303', '303 Cedar St');
select * from tbl_voters;
INSERT INTO tbl_parties (vPartyName, vPartyImagePath) 
VALUES('Democratic Party', 'images/democratic_party.png'),
('Republican Party', 'images/republican_party.png'),
('Independent', 'images/independent.png'),
('Green Party', 'images/green_party.png'),
('Libertarian Party', 'images/libertarian_party.png'),
('Socialist Party', 'images/socialist_party.png');
select * from tbl_parties;
INSERT INTO tbl_candidates (IcandidateID, vCandidateName, vPicturePath) 
VALUES(12,'John Doe', 'images/john_doe.png'),
(34,'Jane Doe', 'images/jane_doe.png'),
(56,'Jim Beam', 'images/jim_beam.png'),
(28,'Jack Daniels','images/jack_daniels.png'),
(88,'Jill Hill', 'images/jill_hill.png'),
(79,'Joe Bloggs','images/joe_bloggs.png');
select * from tbl_candidates;
INSERT INTO tbl_votes(ivoteID,dtDateTimeCast)
VALUES(1,'2023-08-22 21:38:10'),
  (2, '2023-08-21 15:30:20'),
  (3, '2024-08-23 09:45:40'),
  (4,'2023-08-20  08:30:30'),
  (5,'2023-08-18  10:10:35');
  select * from tbl_votes;
ALTER TABLE tbl_votes
ADD FOREIGN KEY (ICandidateID) REFERENCES tbl_candidates(ICandidateID);
ALTER TABLE tbl_candidates
ADD FOREIGN KEY (iPositionID) REFERENCES tbl_position(iPositionID),
ADD FOREIGN KEY (iPartyID) REFERENCES tbl_parties(iPartyID);
DESCRIBE tbl_votes;
ALTER TABLE tbl_votes
ADD ICandidateID INT;
ALTER TABLE tbl_votes
ADD CONSTRAINT fk_candidate
FOREIGN KEY (ICandidateID)
REFERENCES tbl_candidates(ICandidateID)
ON DELETE CASCADE;
DESCRIBE tbl_candidates;
ALTER TABLE tbl_candidates
ADD iPositionID INT,
ADD iPartyID INT;
ALTER TABLE tbl_candidates
ADD CONSTRAINT fk_position
FOREIGN KEY (iPositionID) REFERENCES tbl_position(iPositionID)
ON DELETE CASCADE,
ADD CONSTRAINT fk_party
FOREIGN KEY (iPartyID) REFERENCES tbl_parties(iPartyID)
ON DELETE CASCADE;
ALTER TABLE  tbl_voters 
ADD UNIQUE (ivoterID);
 ALTER TABLE tbl_voters
DROP PRIMARY KEY;
ALTER TABLE tbl_voters
ADD PRIMARY KEY (vVoterName);
SELECT vVoterName, COUNT(*)
FROM tbl_voters
GROUP BY vVoterName
HAVING COUNT(*) > 1;
CREATE TEMPORARY TABLE temp_voters AS
SELECT MIN(iVoterID) AS min_id
FROM tbl_voters
GROUP BY vVoterName;
DROP TEMPORARY TABLE temp_voters;
describe tbl_voters;
select* from tbl_voters;
CREATE VIEW voter_info_view AS 
SELECT iVoterID, vAddress
FROM tbl_voters;


#view for candidate information at a glance
CREATE VIEW candidate_info_view AS
SELECT c.iCandidateID, c.vCandidateName, o.vPositionName, p.vPartyName, c.vPicturePath
FROM tbl_candidates c, tbl_parties p, tbl_position o WHERE o.iPositionID=c.iPositionID and p.iPartyID=c.iPartyID;

#view to see what candidate is vying for what party
CREATE VIEW position_info_view AS
SELECT c.vCandidateName ,p.vPositionName
FROM tbl_position p, tbl_candidates c WHERE p.iPositionID=c.iPositionID ;

#view to check each candidate's party
CREATE VIEW party_info_view AS
SELECT c.vCandidateName, p.vPartyName
FROM tbl_parties p, tbl_candidates c WHERE p.iPartyID=c.iPartyID;

#view to get the results of each candidate
CREATE VIEW real_time_results_view AS
SELECT v.iCandidateID, COUNT(v.iVoteID) as Votes, 
d.vCandidateName as Candidate_Name, p.vPositionName as Position
FROM tbl_votes v, tbl_candidates d , tbl_position p where v.iCandidateID=d.iCandidateID and p.iPositionID=d.iPositionID
GROUP BY Position;
DELIMITER $$
CREATE PROCEDURE RegisterVoter(IN vName VARCHAR(50), IN vEmail VARCHAR(50), IN vPassword VARCHAR(50), IN vAddress VARCHAR(50))
BEGIN
    DECLARE emailCount INT;
    SELECT COUNT(vEmail) INTO emailCount FROM tbl_voters WHERE vEmail = vEmail;
    IF emailCount = 0 THEN
        INSERT INTO tbl_voters (vVoterName, vEmail, vPassword, vAddress) VALUES (vName, vEmail, vPassword, vAddress);
        SELECT 'Registration successful' AS Message;
    ELSE
        SELECT 'Email already registered' AS Message;
    END IF;
    END$$
DELIMITER ;
DELIMITER $$
select* from tbl_candidates;
select* from tbl_votes;
select* from tbl_voters;
select*from tbl_parties;
select*from tbl_position;
ALTER TABLE tbl_voters
ADD COLUMN iVoterID INT NOT NULL AUTO_INCREMENT;
INSERT INTO tbl_voters(iVoterID) VALUES ('1,2,3,4,5');
CREATE PROCEDURE GetElectionResults()
BEGIN
    SELECT v.iCandidateID, d.vCandidateName, p.vPositionName, COUNT(v.iVoteID) AS Votes
    FROM tbl_votes v
    INNER JOIN tbl_candidates d ON v.iCandidateID = d.iCandidateID
    INNER JOIN tbl_position p ON d.iPositionID = p.iPositionID
    GROUP BY v.iCandidateID, d.vCandidateName, p.vPositionName
    ORDER BY p.vPositionName, Votes DESC;
END$$
DELIMITER ;
DELIMITER $$
CREATE PROCEDURE VoterLogin(IN vEmail VARCHAR(50), IN vPassword VARCHAR(50))
BEGIN
    DECLARE loginSuccess INT;
    SELECT COUNT(*) INTO loginSuccess FROM tbl_voters WHERE vEmail = vEmail AND vPassword = vPassword;
    IF loginSuccess = 1 THEN
        SELECT 'Login successful' AS Message;
 ELSE
        SELECT 'Login failed. Check your credentials.' AS Message;
    END IF;
END$$
DELIMITER ;
Describe tbl_voters;
select* from tbl_voters;
INSERT INTO tbl_voters (iVoterID) 
VALUES (1), (2), (3), (4), (5);
INSERT INTO tbl_voters (iVoterID, vVoterName,vEmail, vPassword, vAddress) 
VALUES 
(1, 'Alice Smith','alice@example.com', 'password123', '123 Maple St'),
(2, 'Bob Johnson','bob@example.com', 'password456', '456 Oak St'),
(3, 'Charlie Brown','charlie@example.com', 'password789', '789 Pine St'),
(4, 'Diana White','diana@example.com', 'password101', '101 Elm St'),
(5, 'Eve Black','Ethan@example.com', 'password202', '202 Birch St'),
(6,'Fiona Apple', 'fiona@example.com', 'password303', '303 Cedar St');
INSERT INTO tbl_voters (vVoterName, vEmail, vPassword, vAddress) 
VALUES 
('Alice Smith', 'alice@example.com', 'password123', '123 Maple St'),
('Bob Johnson', 'bob@example.com', 'password456', '456 Oak St'),
('Charlie Brown', 'charlie@example.com', 'password789', '789 Pine St'),
('Diana White', 'diana@example.com', 'password101', '101 Elm St'),
('Eve Black', 'Ethan@example.com', 'password202', '202 Birch St'),
('Fiona Apple', 'fiona@example.com', 'password303', '303 Cedar St');



