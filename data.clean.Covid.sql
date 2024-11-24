select*
from PortfolioSqlDataclea.dbo.NashvilleHousing

--Standarize date fromat

select SaleDateConverted1, convert(date,SaleDate)
from PortfolioSqlDataclea..NashvilleHousing


ALTER TABLE PortfolioSqlDataclea..NashvilleHousing
Add SaleDateConverted1 date;

Update PortfolioSqlDataclea..NashvilleHousing
set SaleDateConverted1 = convert(date,SaleDate)
 


 -- Populate Property Address data

select *
from PortfolioSqlDataclea..NashvilleHousing
--where PropertyAddress is null
order by ParcelID

select a.ParcelID, a.PropertyAddress,b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioSqlDataclea..NashvilleHousing a
Join PortfolioSqlDataclea..NashvilleHousing b
  on a.ParcelID = b.ParcelID
  and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


update a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioSqlDataclea..NashvilleHousing a
Join PortfolioSqlDataclea..NashvilleHousing b
  on a.ParcelID = b.ParcelID
  and a.[UniqueID ] <> b.[UniqueID ]
 where a.PropertyAddress is null


 -- breaking out addres into individual column

 select PropertyAddress
from PortfolioSqlDataclea..NashvilleHousing
--where PropertyAddress is null
--order by ParcelID

select 
SUBSTRING(propertyAddress,1,CHARINDEX(',', PropertyAddress)-1) as Address,
SUBSTRING(propertyAddress,CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress)) as Address
from PortfolioSqlDataclea..NashvilleHousing


ALTER TABLE PortfolioSqlDataclea..NashvilleHousing
Add Propertystreet Nvarchar(255);

Update PortfolioSqlDataclea..NashvilleHousing
set Propertystreet = SUBSTRING(propertyAddress,1,CHARINDEX(',', PropertyAddress)-1) 


ALTER TABLE PortfolioSqlDataclea..NashvilleHousing
Add propertycity Nvarchar(255);

Update PortfolioSqlDataclea..NashvilleHousing
set Propertycity = SUBSTRING(propertyAddress,CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress)) 

 select *
from PortfolioSqlDataclea..NashvilleHousing




--another way of doing it parsename only recognize period

select OwnerAddress
from PortfolioSqlDataclea..NashvilleHousing

select 
Parsename(Replace(OwnerAddress,',','.'),3)
,Parsename(Replace(OwnerAddress,',','.'),2)
,Parsename(Replace(OwnerAddress,',','.'),1)
from PortfolioSqlDataclea..NashvilleHousing


ALTER TABLE PortfolioSqlDataclea..NashvilleHousing
Add ownertystreet Nvarchar(255);

Update PortfolioSqlDataclea..NashvilleHousing
set ownertystreet = Parsename(Replace(OwnerAddress,',','.'),3)


ALTER TABLE PortfolioSqlDataclea..NashvilleHousing
Add ownerycity Nvarchar(255);

Update PortfolioSqlDataclea..NashvilleHousing
set ownerycity = Parsename(Replace(OwnerAddress,',','.'),2)


ALTER TABLE PortfolioSqlDataclea..NashvilleHousing
Add ownerstate Nvarchar(255);

Update PortfolioSqlDataclea..NashvilleHousing
set ownerstate = Parsename(Replace(OwnerAddress,',','.'),1)

select *
from PortfolioSqlDataclea..NashvilleHousing



-- change Y and N to yes and no in 'sold as vacant'


select Distinct(SoldAsVacant), count (SoldAsVacant)
from PortfolioSqlDataclea..NashvilleHousing
group by SoldAsVacant
order by 2 



select SoldAsVacant
,CASE when SoldAsVacant = 'Y' then 'YES'
      when SoldAsVacant = 'N' then 'NO'
	  else SoldAsVacant
	  end
from PortfolioSqlDataclea..NashvilleHousing
group by SoldAsVacant
order by 2 


Update PortfolioSqlDataclea..NashvilleHousing
set SoldAsVacant = CASE when SoldAsVacant = 'Y' then 'YES'
      when SoldAsVacant = 'N' then 'NO'
	  else SoldAsVacant
	  end





-- Remove Duplicates
--we using CTE

with RownNumCTE as (
select *
     ,ROW_NUMBER() over (
	 partition BY parcelID,
	              propertyaddress,
				  salePrice,
				  saledate,
				  legalReference
				  Order by
				    uniqueID
					) row_num

            
from PortfolioSqlDataclea..NashvilleHousing
)
select*
from RownNumCTE
where row_num > 1
order by PropertyAddress


-- delete unused column

select *
from PortfolioSqlDataclea..NashvilleHousing

ALTER TABLE PortfolioSqlDataclea..NashvilleHousing
drop column OwnerAddress, taxdistrict, propertyaddress,saledate