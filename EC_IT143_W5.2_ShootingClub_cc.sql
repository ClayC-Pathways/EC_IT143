-- ========================================
-- EC_IT143_W5.2_ShootingClub_cc.sql
-- Author: Clay C.
-- Date: 2025-10-04
-- Community: ShootingClub
-- Description: Step 3 SQL Answers for ShootingClub
-- ========================================

-- Question 1: How many members are listed in ShootingClub? (Author: Clay)
SELECT COUNT(*) AS TotalMembers
FROM dbo.ShootingClub;

-- Question 2: Which members joined in 2025? (Author: Clay)
SELECT MemberID, MemberName, JoinDate
FROM dbo.ShootingClub
WHERE YEAR(JoinDate) = 2025;

-- Question 3: What are the names of members who haven’t listed a join date? (Author: Clay)
SELECT MemberID, MemberName
FROM dbo.ShootingClub
WHERE JoinDate IS NULL;

-- Question 4: How many members joined before 2020? (Author: Peer)
SELECT COUNT(*) AS MembersBefore2020
FROM dbo.ShootingClub
WHERE JoinDate < '2020-01-01';
