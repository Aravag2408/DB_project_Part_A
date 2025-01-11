SELECT * FROM Contacts;
SELECT * FROM CommonContacts;
SELECT * FROM Attendance;


-- View to determine cohesive cities
CREATE VIEW CohesiveCities AS
SELECT c1.city
FROM Contacts c1 LEFT OUTER JOIN Contacts c2
ON c1.city = c2.city AND c1.name != c2.name
LEFT OUTER JOIN CommonContacts cc ON c1.name = cc.contactSaver AND c2.name = cc.savedContact
GROUP BY c1.city
HAVING COUNT(c2.name) = COUNT(cc.savedContact);

DROP VIEW CohesiveCities;
SELECT * FROM CohesiveCities;


-- View to identify organized contacts
CREATE VIEW OrganizedContacts AS
SELECT DISTINCT cc.contactSaver AS organizedContact
FROM CommonContacts cc INNER JOIN Contacts c1
ON cc.savedContact = c1.Name -- Match saved contacts with their details
LEFT JOIN Attendance a1
ON a1.contactName = cc.contactSaver -- Check punctuality
WHERE cc.nickname = c1.name -- Nickname matches the saved contact's name
  AND (a1.delay IS NULL OR a1.delay <= 50) -- No delays greater than 50 minutes
  AND NOT EXISTS ( -- ensures that we explicitly exclude any contact with a delay >50, regardless of other punctual records
      SELECT 1
      FROM Attendance a2
      WHERE a2.contactName = cc.contactSaver AND a2.delay > 50
  );

DROP VIEW OrganizedContacts;
SELECT * FROM OrganizedContacts;


-- View to find meetings with organized contacts
CREATE VIEW MeetingsWithOrganized AS
SELECT DISTINCT a.date
FROM Attendance a INNER JOIN OrganizedContacts oc
ON a.contactName = oc.organizedContact;

DROP VIEW MeetingsWithOrganized;
SELECT * FROM MeetingsWithOrganized;


-- Combine results to get final output
SELECT c.name, MIN(a1.date) AS firstEverMeetingDate
FROM Contacts c INNER JOIN CohesiveCities cc ON c.city = cc.city
INNER JOIN Attendance a1 ON c.name = a1.contactName
WHERE EXISTS (
    SELECT 1
    FROM MeetingsWithOrganized mwo INNER JOIN Attendance a2 on mwo.date = a2.date
)
GROUP BY c.name;


-- Correct Answer: {('Abigail Shaffer', '2023-01-07'), ('Dylan Miller', '2023-01-08'), ('Tommy Walter', '2023-01-08'), ('Elizabeth Fowler', '2023-01-11'), ('Brittany Farmer', '2023-01-11'), ('Angelica Tucker', '2023-01-08'), ('Shane Henderson', '2023-01-08'), ('Eric Carney', '2023-02-24'), ('Jeffrey Chavez', '2023-01-08'), ('Stephanie Ross', '2023-01-08')}