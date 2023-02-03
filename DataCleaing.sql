/*
Cleaning data in SQL queires
*/

Select * 
From PortfolioProject.dbo.NashVille_Housing

/*
Standarize date format
*/

Select SaleDateConverted, CONVERT(Date, SaleDate)
From PortfolioProject.dbo.NashVille_Housing

Update NashVille_Housing
Set SaleDate = CONVERT(Date, SaleDate)

Alter Table NashVille_Housing
Add SaleDateConverted Date;

Update NashVille_Housing
Set SaleDateConverted = CONVERT(Date, SaleDate)

/*
Populate Property Address Data
If the parcelID is the same and the property address is NULL, let's fill the NULL with the address with the same parcelID
*/

Select *
From PortfolioProject.dbo.NashVille_Housing
--Where PropertyAddress is Null
order by ParcelID

Select vec.ParcelID, vec.PropertyAddress, xec.ParcelID, xec.PropertyAddress, ISNULL(vec.propertyaddress, xec.PropertyAddress) -- when its null take vec.property and put it into xec property 
From PortfolioProject.dbo.NashVille_Housing vec
join PortfolioProject.dbo.NashVille_Housing xec
	on vec.ParcelID = xec.ParcelID
	AND vec.[UniqueID ] <> xec.[UniqueID ] -- ParcelID will repeat itself, unique won't
	where vec.PropertyAddress is null

Update vec
set PropertyAddress = ISNULL(vec.propertyaddress, xec.PropertyAddress)
From PortfolioProject.dbo.NashVille_Housing vec
join PortfolioProject.dbo.NashVille_Housing xec
	on vec.ParcelID = xec.ParcelID
	AND vec.[UniqueID ] <> xec.[UniqueID ]
where vec.PropertyAddress is null

/*
Breaking out address into individual columns(address, city, state)
*/

Select PropertyAddress
From PortfolioProject.dbo.NashVille_Housing
--Where PropertyAddress is Null

Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', propertyAddress)-1) As Address
, SUBSTRING(PropertyAddress,  CHARINDEX(',', propertyAddress)+ 1, LEN(PropertyAddress)) As Address
From PortfolioProject.dbo.NashVille_Housing


Alter Table NashVille_Housing
Add PropertySplitAddress nvarchar(255);

Update NashVille_Housing
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', propertyAddress)-1)

Alter Table NashVille_Housing
Add PropertySplitCity nvarchar(255);

Update NashVille_Housing
Set PropertySplitCity = SUBSTRING(PropertyAddress,  CHARINDEX(',', propertyAddress)+ 1, LEN(PropertyAddress))


Select *
From PortfolioProject.dbo.NashVille_Housing

Select OwnerAddress
From PortfolioProject.dbo.NashVille_Housing

Select PARSENAME(REPLACE(OwnerAddress,',', '.'),3)
, PARSENAME(REPLACE(OwnerAddress,',', '.'),2)
,PARSENAME(REPLACE(OwnerAddress,',', '.'),1)
From PortfolioProject.dbo.NashVille_Housing

Alter Table NashVille_Housing
Add OwnerSplitAddresses nvarchar(255);

Update NashVille_Housing
Set OwnerSplitAddresses = PARSENAME(REPLACE(OwnerAddress,',', '.'),3)

Alter Table NashVille_Housing
Add OwnerSplitCity nvarchar(255);

Update NashVille_Housing
Set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',', '.'),2)

Alter Table NashVille_Housing
Add OwnerSplitState nvarchar(255);

Update NashVille_Housing
Set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',', '.'),1)

Alter Table NashVille_Housing
Drop column OwnerSplitAddress

/*
Change Y and N to Yes and no in "sold as Vacant" field
*/

Select Distinct(SoldAsVacant), count(SoldAsVacant)
From PortfolioProject.dbo.NashVille_Housing
group by SoldasVacant
order by 2

Select SoldAsVacant
	, CASE When SoldAsVacant = 'Y' then 'Yes'
		When SoldAsVacant = 'N' then 'No'
		Else SoldAsVacant
		End
From PortfolioProject.dbo.NashVille_Housing

update NashVille_Housing
SET SoldAsVacant =  CASE When SoldAsVacant = 'Y' then 'Yes'
		When SoldAsVacant = 'N' then 'No'
		Else SoldAsVacant
		End
/*
Removing duplicates
*/

With RowNumCTE as (
Select *, ROW_NUMBER() OVER (
	PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
	Order by UniqueID) row_num
From PortfolioProject.dbo.NashVille_Housing
--order by ParcelID
)
select *  
from RowNumCTE
where row_num >1

/*
Delete unused Columns
*/

select *
from PortfolioProject.dbo.NashVille_Housing

Alter Table NashVille_Housing
Drop column OwnerAddress, TaxDistrict, PropertyAddress

Alter Table NashVille_Housing
Drop column SaleDate

Alter Table NashVille_Housing
Drop column OwnerName

/*
Split two First names and Last name
*/

Select PARSENAME(REPLACE(OwnerName,',', '.'),1)
, PARSENAME(REPLACE(OwnerName,',', '.'),2)
From PortfolioProject.dbo.NashVille_Housing

select OwnerName
from PortfolioProject.dbo.NashVille_Housing

Alter Table NashVille_Housing
Add OwnerSplitFName nvarchar(255);

Update NashVille_Housing
Set OwnerSplitFname = PARSENAME(REPLACE(OwnerName,',', '.'),1)

Alter Table NashVille_Housing
Add OwnerSplitLName nvarchar(255);

Update NashVille_Housing
Set OwnerSplitLname = PARSENAME(REPLACE(OwnerName,',', '.'),2)





