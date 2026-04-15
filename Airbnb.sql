-- count of booking for each listing


select l.Listing_Id as ListingId, count(b.Booking_Id) as "Count of booking" from Airbnb_Listings l
left join Airbnb_Bookings as b
on l.Listing_Id=b.Listing_Id
group by l.Listing_Id


----tagging reductent listingId
select l.Listing_Id as ListingId, count(b.Booking_Id) as "Count of booking", case when count(b.Booking_Id)=0 then 1 else 0 end as Is_Reductent from Airbnb_Listings l
left join Airbnb_Bookings as b
on l.Listing_Id=b.Listing_Id
group by l.Listing_Id


----image count per listing

select Listing_Id , Image_Count from Airbnb_Images 



--- Single table

select l.Listing_Id as ListingId, count(b.Booking_Id) as "Count of booking", case when count(b.Booking_Id)=0 then 1 else 0 end as Is_Reductent,Max(I.Image_Count) as "Count of Images" from Airbnb_Listings l
left join Airbnb_Bookings as b
on l.Listing_Id=b.Listing_Id
left join Airbnb_Images as I

on l.Listing_Id=I.Listing_Id
group by l.Listing_Id


--- view creation

CREATE VIEW Airbnb_Listing_Summary
AS
SELECT 
    l.Listing_Id AS ListingId,
    COUNT(b.Booking_Id) AS Booking_Count,
    CASE 
        WHEN COUNT(b.Booking_Id) = 0 THEN 1 
        ELSE 0 
    END AS Is_Reductent,
    MAX(I.Image_Count) AS Image_Count
FROM Airbnb_Listings l
LEFT JOIN Airbnb_Bookings b
    ON l.Listing_Id = b.Listing_Id
LEFT JOIN Airbnb_Images I
    ON l.Listing_Id = I.Listing_Id
GROUP BY 
    l.Listing_Id;



-----reductant listing percentage


SELECT 
    COUNT(CASE WHEN Booking_Count = 0 THEN 1 END) * 100.0 / COUNT(*) 
    AS Redundant_Percentage
FROM Airbnb_Listing_Summary


--location with most reductant listing

SELECT 
    l.Location,
    COUNT(*) AS Redundant_Listings
FROM Airbnb_Listing_Summary la
JOIN Airbnb_Listings l
ON la.ListingId = l.Listing_Id
WHERE la.Is_Reductent = 1
GROUP BY l.Location
ORDER BY Redundant_Listings DESC;


--- Images vs Booking

SELECT 
    Image_Count,
    AVG(Booking_Count) AS Avg_Bookings
FROM Airbnb_Listing_Summary
GROUP BY Image_Count
ORDER BY Image_Count;

