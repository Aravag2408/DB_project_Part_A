QUERY_ANSWERS = {
    "Q3":
        """
        SELECT DISTINCT a.date
FROM Attendance a
JOIN Popular p ON a.contactName = p.name
ORDER BY a.date ASC;

        """
    ,
    "Q4":
        """
        SELECT c.name, MIN(a1.date) AS firstEverMeetingDate
FROM Contacts c INNER JOIN CohesiveCities cc ON c.city = cc.city
INNER JOIN Attendance a1 ON c.name = a1.contactName
WHERE EXISTS (
    SELECT 1
    FROM MeetingsWithOrganized mwo INNER JOIN Attendance a2 on mwo.date = a2.date
)
GROUP BY c.name;
        """
}
