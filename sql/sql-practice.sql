


/* Welcome to the SQL mini project. For this project, you will use
Springboard' online SQL platform, which you can log into through the
following link:

https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

Note that, if you need to, you can also download these tables locally.

In the mini project, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */



/* Q1: Some of the facilities charge a fee to members, but some do not.
Please list the names of the facilities that do. */

SELECT name, membercost
FROM
country_club.Facilities
WHERE
membercost = 0;


/* Q2: How many facilities do not charge a fee to members? */

SELECT COUNT(*) FROM
country_club.Facilities
WHERE
membercost = 0;

/* Ans: 4 */


/* Q3: How can you produce a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost?
Return the
 
 facid,
 facility name,
 member cost, and
 monthly maintenance
 
 of the
facilities in question. */

SELECT facid, name, membercost, monthlymaintenance

FROM
country_club.Facilities
WHERE
membercost <= 0.2*monthlymaintenance
GROUP BY
facid



/* Q4: How can you retrieve the details of facilities with ID 1 and 5?
Write the query without using the OR operator. */

SELECT
*
FROM
country_club.Facilities
WHERE
facid IN (1,5);

/* Q5: How can you produce a list of facilities, with each labelled as

        'cheap' or
 
        'expensive',
 
depending on if their monthly maintenance cost is
more than $100? Return the name and monthly maintenance of the facilities
in question. */

SELECT
country_club.Facilities.name,
CASE
WHEN (monthlymaintenance > 100)
THEN 'expensive'
ELSE
'cheap'
END AS COST
FROM
country_club.Facilities




/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution.
from country_club.Members */

SELECT surname, firstname,

MAX(joindate)

FROM country_club.Members


/* Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */

SELECT        country_club.Bookings.memid,
country_club.Facilities.name,
CONCAT(country_club.Members.surname, ', ',country_club.Members.firstname)
AS fullname
FROM         country_club.Bookings

JOIN         country_club.Facilities
ON            country_club.Facilities.facid
= country_club.Bookings.facid

JOIN        country_club.Members
ON             country_club.Members.memid
= country_club.Bookings.memid

WHERE        name like 'Tennis Court %'
GROUP BY fullname LIMIT 0,10


/* Q8: How can you produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30? Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

select country_club.Bookings.memid, country_club.Bookings.starttime,
country_club.Facilities.name,
country_club.Facilities.membercost, country_club.Facilities.guestcost,
concat(country_club.Members.surname,', ',country_club.Members.firstname)
as fullname
from country_club.Bookings
join   country_club.Facilities
on country_club.Facilities.facid=country_club.Bookings.facid
join country_club.Members
on country_club.Members.memid=country_club.Bookings.memid
where Bookings.starttime like '2012-09-14%'
and (Facilities.membercost*Bookings.slots+Facilities.guestcost*Bookings.slots)>30
group by memid limit 0,5


/* Q9: This time, produce the same result as in Q8, but using a subquery. */

SELECT     bkfc.starttime, bkfc.memid,
CONCAT(Members.firstname, ' ', Members.surname) AS fullname,
bkfc.facid, bkfc.name, bkfc.cost
FROM
(SELECT country_club.Bookings.starttime,
 Bookings.memid, Bookings.facid, Facilities.name,
 CASE WHEN
 Bookings.memid = '0'
 THEN Bookings.slots*Facilities.guestcost
 ELSE Bookings.slots*Facilities.membercost
 END AS cost
 FROM Bookings
 
 JOIN country_club.Facilities
 ON         Facilities.facid = Bookings.facid) bkfc

JOIN country_club.Members
ON        Members.memid = bkfc.memid
Where     bkfc.starttime LIKE '2012-09-14%'

AND bkfc.cost >30

ORDER BY bkfc.cost DESC
limit 0, 5




/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

USE country_club;
SELECT
Bookings.facid,
Facilities.name,
SUM(CASE WHEN Bookings.memid = '0'
    
    THEN
    Bookings.slots*Facilities.guestcost
    ELSE
    Bookings.slots*Facilities.membercost END) AS revenue
FROM Bookings

JOIN Facilities
ON
Facilities.facid = Bookings.facid
GROUP BY name
HAVING revenue < 1000
ORDER BY revenue

