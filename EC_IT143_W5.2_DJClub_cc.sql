-- ========================================
-- EC_IT143_W5.2_DJClub_cc.sql
-- Author: Clay C.
-- Date: 2025-10-04
-- Community: DJClub
-- Description: Step 3 SQL Answers for DJClub
-- ========================================

-- Question 1: How many clubs are listed in DJClub? (Author: Clay)
SELECT COUNT(*) AS TotalClubs
FROM dbo.DJClub;

-- Question 2: Which clubs have a category of 'Techno' or 'House'? (Author: Clay)
SELECT DJID, DJName, Genre
FROM dbo.DJClub
WHERE Genre IN ('Techno', 'House');

-- Question 3: What are the names of all clubs with no category listed? (Author: Clay)
SELECT DJID, DJName
FROM dbo.DJClub
WHERE Genre IS NULL;

-- Question 4: How many clubs have a category assigned? (Author: Peer)
SELECT COUNT(*) AS CategorizedClubs
FROM dbo.DJClub
WHERE Genre IS NOT NULL;
