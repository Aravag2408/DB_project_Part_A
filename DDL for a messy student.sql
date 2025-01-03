CREATE TABLE Contact(
    ContactName VARCHAR(50) PRIMARY KEY,
    Address VARCHAR(50),
    PhoneNumber VARCHAR(12),
    CHECK(PhoneNumber LIKE '9725%')
)

CREATE TABLE ListOfContacts(
    ContactName1 VARCHAR(50) PRIMARY KEY,
    ContactName2 VARCHAR(50),
    --PRIMARY KEY (ContactName1, ContactName2), --or maybe like this?
    UNIQUE (ContactName1, ContactName2), --האם זה אומר שהסדר ההפוך לא יהיה?
    FOREIGN KEY (ContactName1)
    REFERENCES Contact ON DELETE CASCADE, -- make sure we don't need - ON DELETE CASCADE,
    FOREIGN KEY (ContactName2)
    REFERENCES Contact, -- ON DELETE CASCADE - pycharm doesn't allow us to reference twice to the same table
    CHECK (ContactName1<>ContactName2)
)
    --cyclic foreign key constraint
--mashu

CREATE TABLE ZoomMeetings(
    StartingTime TIMESTAMP PRIMARY KEY,
    ZoomContent VARCHAR(50)
)

CREATE TABLE MeetingParticipation(
    ContactName VARCHAR(50),
    StartingTime TIMESTAMP,
    PRIMARY KEY (ContactName, StartingTime),
    FOREIGN KEY (ContactName)
    REFERENCES Contact ON DELETE CASCADE,
    FOREIGN KEY (StartingTime)
    REFERENCES ZoomMeetings, -- ON DELETE CASCADE, we can't use it with timestampe
    -- we can't implement on DDL there must be at least one person in a meeting!
)

CREATE TABLE MeetingDelay(
    DelayCause VARCHAR(50),
    DelayedParticipant VARCHAR(50),
    StartingTime TIMESTAMP,
    DelayDuration INT,
    PRIMARY KEY (DelayCause, StartingTime), --DelayedParticipant part of the primary key?
    FOREIGN KEY (DelayedParticipant, StartingTime)
    REFERENCES MeetingParticipation(ContactName, StartingTime),
    FOREIGN KEY (DelayCause) --DelayCause doesn't have to participate in the meeting
    REFERENCES Contact(ContactName),
    CHECK (DelayCause<>DelayedParticipant),

)

CREATE TABLE Folder(
    FolderID VARCHAR(50) PRIMARY KEY,
    FolderName VARCHAR(50),
    CreationDate DATE,
    ParentFolderID VARCHAR(50),
    FOREIGN KEY (ParentFolderID)
    REFERENCES Folder(FolderID),
)

CREATE TABLE Files(
    FileName   VARCHAR(50),
    FileType VARCHAR(3),
    FolderID   VARCHAR(50),
    FileSize  INT,
    PRIMARY KEY (FileName, FileType, FolderID),
    FOREIGN KEY (FolderID)
        REFERENCES Folder ON DELETE CASCADE

    --how can we show overlap???
)

CREATE TABLE DBFile(
    FileName   VARCHAR(50),
    FileType VARCHAR(3),
    FolderID   VARCHAR(50),
    FileSize  INT,
    CorrectFormat BIT, --recognize this field???BIT MAYBE?
    PRIMARY KEY (FileName, FileType, FolderID),
    FOREIGN KEY (FileName, FileType, FolderID)
        REFERENCES Files ON DELETE CASCADE -- weird
)

CREATE TABLE ImportantFile(
    FileName  VARCHAR(50),
    FileType VARCHAR(3),
    FolderID  VARCHAR(50),
    FileSize  INT,
    ContactName VARCHAR(50),
    StartingTime TIMESTAMP,
    WorkedOnHours INT, --dynamic field
    PRIMARY KEY (FileName, FileType, FolderID),
    FOREIGN KEY (FileName, FileType, FolderID)
    REFERENCES Files ON DELETE CASCADE,
    FOREIGN KEY (ContactName, StartingTime)
    REFERENCES MeetingParticipation, --ON DELETE CASCADE, problem with timestamp
    --check if aggregation needed !!!
)

CREATE TABLE Access(
    aDate DATE, --PRIMARY KEY,
    aCause VARCHAR(50),
    FileName   VARCHAR(50),
    FileType VARCHAR(3),
    FolderID   VARCHAR(50),
    ContactName VARCHAR(50),
    PRIMARY KEY (aDate, FileName, FileType, FolderID, ContactName), --to be discussed
    FOREIGN KEY (FileName, FileType, FolderID)
    REFERENCES Files ON DELETE CASCADE,
    FOREIGN KEY (ContactName)
    REFERENCES Contact ON DELETE CASCADE
)

CREATE TABLE Exceptions(
    eID VARCHAR(50) PRIMARY KEY,
    RiskLevel INT,
    aDate DATE,
    aCause VARCHAR(50),
    FileName   VARCHAR(50),
    FileType VARCHAR(3),
    FolderID   VARCHAR(50),
    ContactName VARCHAR(50),
    CHECK(RiskLevel BETWEEN 0 AND 10),
    FOREIGN KEY (aDate, FileName, FileType, FolderID, ContactName)
    REFERENCES Access
)

DROP TABLE Exceptions;
DROP TABLE Access;
DROP TABLE ImportantFile;
DROP TABLE DBFile;
DROP TABLE Files;
DROP TABLE Folder;
DROP TABLE MeetingDelay;
DROP TABLE MeetingParticipation;
DROP TABLE ZoomMeetings;
DROP TABLE ListOfContacts;
DROP TABLE Contact;

