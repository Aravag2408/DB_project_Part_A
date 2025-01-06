CREATE TABLE Contacts(
    name VARCHAR(50) PRIMARY KEY,
    phone CHAR(10),
    city VARCHAR(50)
);


CREATE TABLE CommonContacts(
    contactSaver VARCHAR(50),
    savedContact VARCHAR(50),
    nickname VARCHAR(50),
    PRIMARY KEY (contactSaver, savedContact),
    FOREIGN KEY (contactSaver) REFERENCES Contacts(name) ON DELETE CASCADE,
    FOREIGN KEY (savedContact) REFERENCES Contacts(name), -- ON DELETE CASCADE,
    CHECK (contactSaver <> savedContact)
);

CREATE TABLE Attendance(
    date DATE,
    contactName VARCHAR(50),
    delay INT CHECK (delay >= 0),
    PRIMARY KEY (date, contactName),
    FOREIGN KEY (contactName) REFERENCES Contacts(name) ON DELETE CASCADE
);

