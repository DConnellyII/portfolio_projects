--Select top 1000 entries
SELECT *
FROM nashville_housing
LIMIT 1000

---------------------------------------------------------------------------------------

--Populate Property Address Data
SELECT *
FROM nashville_housing
WHERE propertyaddress IS NULL
ORDER BY parcelid;

SELECT nh1.parcelid, nh1.propertyaddress, nh2.parcelid, nh2.propertyaddress, COALESCE(nh1.propertyaddress, nh2.propertyaddress)
FROM nashville_housing nh1
JOIN nashville_housing nh2
	ON nh1.parcelid = nh2.parcelid
	AND nh1.uniqueid <> nh2.uniqueid
WHERE nh1.propertyaddress IS NULL;

UPDATE nashville_housing nh1
SET propertyaddress = COALESCE(nh1.propertyaddress, nh2.propertyaddress)
FROM nashville_housing nh2
WHERE nh1.parcelid = nh2.parcelid
	AND nh1.uniqueid <> nh2.uniqueid
	AND nh1.propertyaddress IS NULL;

---------------------------------------------------------------------------------------

--Breaking out Property Address into Invidividual Columns (Address, City)
SELECT propertyaddress
FROM nashville_housing;

SELECT 
SUBSTRING(propertyaddress, 1, POSITION(',' IN propertyaddress) - 1) AS property_street_address,
SUBSTRING(propertyaddress, POSITION(',' IN propertyaddress) + 1) AS property_city
FROM nashville_housing;

ALTER TABLE nashville_housing
ADD property_street_address VARCHAR;
UPDATE nashville_housing
SET property_street_address = SUBSTRING(propertyaddress, 1, POSITION(',' IN propertyaddress) - 1);

ALTER TABLE nashville_housing
ADD property_city VARCHAR;
UPDATE nashville_housing
SET property_city = SUBSTRING(propertyaddress, POSITION(',' IN propertyaddress) + 1);

---------------------------------------------------------------------------------------

--Breaking out Owner Address into Invidividual Columns (Address, City, State)
SELECT owneraddress
FROM nashville_housing

SELECT
SPLIT_PART(REPLACE(owneraddress, ',', '.'), '.', -3) AS owner_street_address,
SPLIT_PART(REPLACE(owneraddress, ',', '.'), '.', -2) AS owner_city,
SPLIT_PART(REPLACE(owneraddress, ',', '.'), '.', -1) AS owner_state
FROM nashville_housing;

ALTER TABLE nashville_housing
ADD owner_street_address VARCHAR;
UPDATE nashville_housing
SET owner_street_address = SPLIT_PART(REPLACE(owneraddress, ',', '.'), '.', -3);

ALTER TABLE nashville_housing
ADD owner_city VARCHAR;
UPDATE nashville_housing
SET owner_city = SPLIT_PART(REPLACE(owneraddress, ',', '.'), '.', -2);

ALTER TABLE nashville_housing
ADD owner_state VARCHAR;
UPDATE nashville_housing
SET owner_state = SPLIT_PART(REPLACE(owneraddress, ',', '.'), '.', -1);

---------------------------------------------------------------------------------------

--Change Y and N to Yes and No in the 'Sold as Vacant' field
SELECT DISTINCT soldasvacant
FROM nashville_housing

SELECT DISTINCT soldasvacant, COUNT(soldasvacant)
FROM nashville_housing
GROUP BY soldasvacant
ORDER BY 2;

SELECT soldasvacant, 
CASE WHEN soldasvacant = 'Y' THEN'Yes'
	 WHEN soldasvacant = 'N' THEN 'No'
	 ELSE soldasvacant
	 END
FROM nashville_housing;

UPDATE nashville_housing
SET soldasvacant = CASE WHEN soldasvacant = 'Y' THEN'Yes'
	 WHEN soldasvacant = 'N' THEN 'No'
	 ELSE soldasvacant
	 END;

SELECT DISTINCT soldasvacant, COUNT(soldasvacant)
FROM nashville_housing
GROUP BY soldasvacant
ORDER BY 2;

---------------------------------------------------------------------------------------

--Remove Duplicates
WITH rownumcte AS (
  SELECT *,
    ROW_NUMBER() OVER (
      PARTITION BY parcelid, propertyaddress, saleprice, saledate, legalreference
      ORDER BY uniqueid
    ) AS row_num
  FROM nashville_housing
)
SELECT *
FROM nashville_housing
WHERE (parcelid, propertyaddress, saleprice, saledate, legalreference, uniqueid) IN (
  SELECT parcelid, propertyaddress, saleprice, saledate, legalreference, uniqueid
  FROM rownumcte
  WHERE row_num > 1
);

WITH rownumcte AS (
  SELECT *,
    ROW_NUMBER() OVER (
      PARTITION BY parcelid, propertyaddress, saleprice, saledate, legalreference
      ORDER BY uniqueid
    ) AS row_num
  FROM nashville_housing
)
SELECT *
FROM rownumcte
WHERE row_num > 1
ORDER BY propertyaddress;

---------------------------------------------------------------------------------------

--Delete Unused Columns
ALTER TABLE nashville_housing
DROP COLUMN owneraddress,
DROP COLUMN taxdistrict,
DROP COLUMN propertyaddress;






