-- Creating a VIEW for contacts saved by users, including the city of the saved contact
CREATE VIEW Saved AS
SELECT c1.name , cc.savedContact, c2.city
FROM Contacts c1
JOIN CommonContacts cc ON c1.name = cc.contactSaver
JOIN Contacts c2 ON cc.savedContact = c2.name;

-- Creating a VIEW for users who saved a person, including their popularity (number of people who saved them)
CREATE VIEW SavedMe AS
SELECT
    c.name,
    cc.contactSaver,
    COUNT(cc.contactSaver) OVER (PARTITION BY c.name) AS popularity
FROM Contacts c
JOIN CommonContacts cc ON c.name = cc.savedContact;


-- Creating a VIEW for people with contacts in at least two different cities
CREATE VIEW MultiContacts AS
SELECT DISTINCT s1.name
FROM Saved s1
JOIN Saved s2 ON s1.name = s2.name AND s1.city <> s2.city;


-- Creating a VIEW for popular people:
-- They are saved by others, have contacts in multiple cities, and are more popular than all their contacts
CREATE VIEW Popular AS
SELECT mc.name
FROM MultiContacts mc
WHERE NOT EXISTS (
    -- Check if there is any contact saved by this person that didn't save them back
    SELECT 1
    FROM Saved s
    WHERE s.name = mc.name
      AND NOT EXISTS (
          SELECT 1
          FROM Saved s2
          WHERE s2.name = s.savedContact AND s2.savedContact = s.name
      )
)
AND NOT EXISTS (
    -- Check if any contact is equally or more popular than this person
        SELECT 1
        FROM Saved s
        JOIN SavedMe sm_contact ON sm_contact.name = s.savedContact -- Popularity of the contact
        JOIN SavedMe sm_person ON sm_person.name = mc.name          -- Popularity of the person
        WHERE s.name = mc.name
          AND sm_contact.popularity > sm_person.popularity -- If any contact is equally or more popular
    );


-- Querying the required results:
-- Retrieving attendance dates of the popular people
SELECT DISTINCT a.date
FROM Attendance a
JOIN Popular p ON a.contactName = p.name
ORDER BY a.date ASC;



