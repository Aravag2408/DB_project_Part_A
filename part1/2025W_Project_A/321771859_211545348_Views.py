VIEWS_DICT = {
    "Q3":
        [
		"""
        CREATE VIEW Saved AS
SELECT c1.name , cc.savedContact, c2.city
FROM Contacts c1
JOIN CommonContacts cc ON c1.name = cc.contactSaver
JOIN Contacts c2 ON cc.savedContact = c2.name;
		""",
        """
        CREATE VIEW SavedMe AS
SELECT
    c.name,
    cc.contactSaver,
    COUNT(cc.contactSaver) OVER (PARTITION BY c.name) AS popularity
FROM Contacts c
JOIN CommonContacts cc ON c.name = cc.savedContact;
        """,
        """
        CREATE VIEW MultiContacts AS
SELECT DISTINCT s1.name
FROM Saved s1
JOIN Saved s2 ON s1.name = s2.name AND s1.city <> s2.city;    
        """,
        """
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
        """
        ]
    ,
    "Q4":
        [
        """
        CREATE VIEW CohesiveCities AS
SELECT c1.city
FROM Contacts c1 LEFT OUTER JOIN Contacts c2
ON c1.city = c2.city AND c1.name != c2.name
LEFT OUTER JOIN CommonContacts cc ON c1.name = cc.contactSaver AND c2.name = cc.savedContact
GROUP BY c1.city
HAVING COUNT(c2.name) = COUNT(cc.savedContact);
        """,
        """
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
        """,
        """
        CREATE VIEW MeetingsWithOrganized AS
SELECT DISTINCT a.date
FROM Attendance a INNER JOIN OrganizedContacts oc
ON a.contactName = oc.organizedContact;
        """
        ]
}



















