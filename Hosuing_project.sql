-- Cleaning data in SQL
Select * from [PortfolioProject ]..Housing
where LandUse= [Single family]

-------------------------------
---Standardise date format [change date format]
Select SaleDateConverted
from [PortfolioProject ]..Housing

Update [PortfolioProject ]..Housing
Set SaleDate = Convert(Date,Saledate)

ALTER Table [PortfolioProject ]..Housing
Add SaleDateConverted Date;

Update [PortfolioProject ]..Housing
Set SaleDateConverted = Convert(Date,Saledate)

------------------------------------------------------------------------------------------
-- populate propert address data when the parcel id is same but address missing for some, use join and condition give below
Select *
from [PortfolioProject ]..Housing
-- where PropertyAddress is NULL
order by ParcelID

Select a.ParcelID,a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from [PortfolioProject ]..Housing a
join [PortfolioProject ]..Housing b

on a .ParcelID = b. ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
 where a.PropertyAddress is null


 update a
 set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
 from [PortfolioProject ]..Housing a
join [PortfolioProject ]..Housing b

on a .ParcelID = b. ParcelID
and a.[UniqueID ] <> b.[UniqueID ]

------------------------------------------------------------------------------------------------------
---Breaking Address into indivdual (address, city,State)

Select propertyAddress
from [PortfolioProject ]..Housing

Select
SUBSTRING(PropertyAddress,1,Charindex(',',Propertyaddress) -1) as Address
,SUBSTRING(PropertyAddress,Charindex(',',Propertyaddress) +1, Len(PropertyAddress)) as City 
from [PortfolioProject ]..Housing


ALTER Table [PortfolioProject ]..Housing
Add NewAddress char(255);

Update [PortfolioProject ]..Housing
Set NewAddress = SUBSTRING(PropertyAddress,1,Charindex(',',Propertyaddress) -1)


ALTER Table [PortfolioProject ]..Housing
Add City char(255);

Update [PortfolioProject ]..Housing
Set City = SUBSTRING(PropertyAddress,Charindex(',',Propertyaddress) +1, Len(PropertyAddress))


Select *
from [PortfolioProject ]..Housing


Select OwnerAddress
from [PortfolioProject ]..Housing


Select
PARSENAME(Replace(Owneraddress,',','.'), 3) as Street,
PARSENAME(Replace(Owneraddress,',','.'), 2) as Own_City,
PARSENAME(Replace(Owneraddress,',','.'), 1) as State
from [PortfolioProject ]..Housing

ALTER Table [PortfolioProject ]..Housing
Add Street char(255);

Update [PortfolioProject ]..Housing
Set Street = PARSENAME(Replace(Owneraddress,',','.'), 3)

ALTER Table [PortfolioProject ]..Housing
Add Own_City char(255);

Update [PortfolioProject ]..Housing
Set Own_City = PARSENAME(Replace(Owneraddress,',','.'), 2)

ALTER Table [PortfolioProject ]..Housing
Add Own_State char(255);

Update [PortfolioProject ]..Housing
Set Own_State  = PARSENAME(Replace(Owneraddress,',','.'), 1)

-------------------------------------------------------------------------------------------------------------

--Change Y and N to yes and No

Select SoldAsVacant,COUNT(SoldAsVacant) as number
from [PortfolioProject ]..Housing
group by SoldAsVacant
Order by 2

Select SoldAsVacant
, Case when SoldAsVacant = 'Y' then 'Yes'
	   when SoldAsVacant = 'N' then 'No'
	   Else SoldAsVacant
	   End
From [PortfolioProject ]..Housing

Update [PortfolioProject ]..Housing
set SoldAsVacant = Case when SoldAsVacant = 'Y' then 'Yes'
	   when SoldAsVacant = 'N' then 'No'
	   Else SoldAsVacant
	   End

-------------------------------------------------------------------------------------------------------------
----------Removing Duplicates

With RownumCTE as(
Select *,
ROW_NUMBER() over(
Partition by ParcelID,PropertyAddress,Saleprice,Saledate,Legalreference
Order by uniqueId) Row_num

from [PortfolioProject ]..Housing
)

--Delete
--from RownumCTE
--where Row_num > 1
--Order by PropertyAddress


Select *
from RownumCTE
where Row_num > 1
Order by PropertyAddress

-------------------------------------------------------------------------------------------
---- Delete unused columns

Select * 
From [PortfolioProject ]..Housing

Alter table [PortfolioProject ]..Housing
drop Column OwnerAddress,Taxdistrict,propertyaddress


Alter table [PortfolioProject ]..Housing
drop Column SaleDate

Alter Table Housing rename Column SaleDateConverted to SaleDate;