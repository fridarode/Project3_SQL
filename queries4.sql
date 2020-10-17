#Sheets workbook: https://drive.google.com/drive/folders/1RHOkeSM-bIRmkkIodKZw1Ek9BQelW91d?usp=sharing
#q1 What kinds of music does Chinook have?
SELECT g.Name genre_name, COUNT(*)
FROM Track t
JOIN Album a
ON t.AlbumId = a.AlbumId
JOIN Artist s
ON a.ArtistId = s.ArtistId
JOIN Genre g
ON t.GenreId = g.GenreId
GROUP BY 1
ORDER BY 2 DESC;

#q2 What kinds of music do the customers listen to?
SELECT  c.FirstName||" "||c.LastName customer_name, g.Name genre_name, COUNT(g.Name) top_genres_by_tracks_purchased
			FROM Customer c
			JOIN Invoice i
			ON c.CustomerId = i.CustomerId
			JOIN InvoiceLine l
			ON i.InvoiceId = l.InvoiceId
			JOIN Track t
			ON l.TrackId = t.TrackId
			JOIN Genre g
			ON t.GenreId = g.GenreId
			GROUP BY 1,2;

#q3 What kinds do each customer listen to?
WITH q2 AS (SELECT  c.FirstName||" "||c.LastName customer_name, g.Name genre_name, COUNT(g.Name) topcount
			FROM Customer c
			JOIN Invoice i
			ON c.CustomerId = i.CustomerId
			JOIN InvoiceLine l
			ON i.InvoiceId = l.InvoiceId
			JOIN Track t
			ON l.TrackId = t.TrackId
			JOIN Genre g
			ON t.GenreId = g.GenreId
			GROUP BY 1,2
			ORDER BY 1, 3 DESC)

SELECT q2.genre_name, SUM(q2.topcount) genre_count
FROM q2
GROUP BY 1
ORDER BY 2 DESC;

#q4
WITH q1 AS (SELECT c.FirstName||" "||c.LastName customer_name, g.Name genre_name, COUNT(g.Name) top_genre_by_tracks_purchased
			FROM Customer c
			JOIN Invoice i
			ON c.CustomerId = i.CustomerId
			JOIN InvoiceLine l
			ON i.InvoiceId = l.InvoiceId
			JOIN Track t
			ON l.TrackId = t.TrackId
			JOIN Genre g
			ON t.GenreId = g.GenreId
			GROUP BY 1,2
			ORDER BY 1,3 DESC)

SELECT *
FROM q1
GROUP BY 1
HAVING 3 = MAX(3)
ORDER BY 3 DESC;

==========================================================
The counts:
#music inventory
SELECT DISTINCT (SELECT COUNT(ArtistId) FROM Artist) AS num_artists, (SELECT COUNT(AlbumId) FROM Album) AS num_albums, (SELECT COUNT(TrackId) FROM Track) AS num_tracks
FROM Track t
JOIN Album a
ON t.AlbumId = a.AlbumId
JOIN Artist s
ON a.ArtistId = s.ArtistId;

#csr to customer
SELECT c.SupportRepId, e.FirstName||" "||e.LastName csr_name, COUNT(c.SupportRepId) csr_to_customer, e.Email
FROM Customer c
JOIN Employee e
ON c.SupportRepId = e.EmployeeId
GROUP BY 1
ORDER BY 3 DESC;

#employees
SELECT e.FirstName||" "||e.LastName employee_name
FROM Employee e;

#customers
SELECT (SELECT COUNT(CustomerId) customer_count FROM Customer) AS customer_count, (SELECT COUNT(*) FROM Employee) AS employee_count, (SELECT COUNT(DISTINCT(e.LastName))
FROM Customer c
JOIN Employee e
ON c.SupportRepId = e.EmployeeId) AS csr_customer
FROM Customer
GROUP BY csr_customer;
