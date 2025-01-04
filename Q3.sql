-- creating a view for a person's saved contacts

CREATE VIEW Saved AS
    SELECT c1.name, cc.savedContact, c2.city
    FROM Contacts c1, CommonContacts cc, Contacts c2
    WHERE c1.name = cc.contactSaver AND cc.savedContact = c2.name;

--creating a view for the contacts that saved the person + number of the contacts

CREATE VIEW SavedMe AS
    SELECT c.name, cc.contactSaver, count(cc.contactSaver) AS popularity
    FROM Contacts c, CommonContacts cc
    WHERE c.name = cc.savedContact
    GROUP BY c.name, cc.contactSaver;


-- a popular person have contacts from at least two different cities

  CREATE VIEW MultiContacts AS
  SELECT s1.name
  FROM Saved s1, Saved s3
  WHERE s1.name = s3.name AND s1.city <> s3.city


-- A view for all the contacts he saved, saved him as well + his popularity's level is larger than all of his contacts

CREATE VIEW Popular AS
SELECT mc.name
FROM MultiContacts mc
JOIN SavedMe sm on mc.name = sm.name
WHERE NOT EXISTS(SELECT 1
     FROM SavedMe sm1
     WHERE sm1.name = mc.name
     AND NOT EXISTS(SELECT 1
                     FROM Saved s
                     WHERE s.name=mc.name AND s.savedContact =sm1.contactSaver))
AND sm.popularity >= ALL(SELECT sm2.popularity
                         FROM SavedMe sm2
                         WHERE sm2.contactSaver = mc.name);



--returning the value needed

SELECT a.date
FROM Attendance a, Popular p
WHERE EXISTS(SELECT 1
             FROM Popular p, Attendance a
             WHERE p.name = a.ContactName)
ORDER BY a.date ASC;


