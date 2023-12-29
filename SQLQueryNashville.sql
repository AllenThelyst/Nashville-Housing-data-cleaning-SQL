

--cleaning data in SQL

----Standardize date format

--SELECT SaleDateConverted, CONVERT (Date,saledate)
--FROM [Portfolio Project].dbo.NashvilleHousing

--ALTER TABLE Nashvillehousing 
--Add saleDateConverted Date;

--update NashvilleHousing 
--SET SaleDateConverted = Convert (date,saledate)

----Select SaleDateConverted 
--From NashvilleHousing

--Populate Property Address

select *
from NashvilleHousing
--where PropertyAddress is Null
order by ParcelID

select a.parcelID, b.parcelID, a.propertyaddress, b.propertyaddress, ISNULL (a.propertyaddress,b.PropertyAddress)
from [Portfolio Project].dbo.NashvilleHousing a
join [Portfolio Project].dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID 
AND A.[UniqueID ] <> B.[UniqueID ]
where a.PropertyAddress is NULL

UPDATE a
SET PropertyAddress = ISNULL (a.propertyaddress,b.PropertyAddress)
from [Portfolio Project].dbo.NashvilleHousing a
join [Portfolio Project].dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID 
AND A.[UniqueID ] <> B.[UniqueID ]

--Breaking out Address into Individual Colums (Address, City, State)

select PropertyAddress
from NashvilleHousing

select 
SUBSTRING (propertyaddress, 1, CHARINDEX(',', PropertyAddress)-1)as address
, SUBSTRING (propertyaddress,CHARINDEX(',', PropertyAddress)+1,len (propertyaddress))as address
FROM [Portfolio Project].dbo.NashvilleHousing

ALTER TABLE Nashvillehousing 
Add propertysplitaddress varchar (255);

update NashvilleHousing 
SET Propertysplitaddress = SUBSTRING (propertyaddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE Nashvillehousing 
Add propertysplitcit1 varchar(255);

update NashvilleHousing 
SET propertysplitcit1=  SUBSTRING (propertyaddress,CHARINDEX(',', PropertyAddress)+1,len (propertyaddress))

select
PARSENAME (REPLACE(owneraddress,',', '.'),3)
,PARSENAME (REPLACE(owneraddress,',', '.'),2)
,PARSENAME (REPLACE(owneraddress,',', '.'),1)
from [Portfolio Project].dbo.NashvilleHousing

ALTER TABLE Nashvillehousing 
Add Ownersplitaddress varchar (255);

update NashvilleHousing 
SET Ownersplitaddress  = PARSENAME (REPLACE(owneraddress,',', '.'),3)

ALTER TABLE Nashvillehousing 
Add Ownersplitcity varchar (255);

update NashvilleHousing 
SET Ownersplitcity  = PARSENAME (REPLACE(owneraddress,',', '.'),2)

ALTER TABLE Nashvillehousing 
Add Ownersplitstate varchar (255);

update NashvilleHousing 
SET Ownersplitstate  = PARSENAME (REPLACE(owneraddress,',', '.'),1)

select *
from [Portfolio Project].dbo.NashvilleHousing

--Change Y and N to YES AND no

select Distinct (SoldAsVacant), COUNT(SoldasVacant)
From [Portfolio Project].dbo.NashvilleHousing
Group by SoldAsVacant
order by 2

select SoldAsVacant
, case When SoldasVacant = 'N' then 'No'
     When SoldasVacant = 'Y' then 'Yes'
	 ELSE SoldasVacant
	 END
From [Portfolio Project].dbo.NashvilleHousing

update NashvilleHousing
SET SoldasVacant = case When SoldasVacant = 'N' then 'No'
     When SoldasVacant = 'Y' then 'Yes'
	 ELSE SoldasVacant
	 END

-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	Partition by ParcelID,
	Propertyaddress, 
	saledate,
	legalreference
	ORDER by 
	uniqueID
	)
	row_num

from NashvilleHousing
)
Select *
From RowNumCTE
where row_num > 1

--Delete unused colums

select*
From [Portfolio Project].dbo.NashvilleHousing

ALTER TABLE [Portfolio Project].dbo.NashvilleHousing
DROP COLUMN TaxDistrict, SaleDate, OwnerAdress, PropertyAddress