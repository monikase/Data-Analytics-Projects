/* 3.1 Your colleague has written a query to find the list of orders connected to special offers.
The query works fine but the numbers are off, investigate where the potential issue lies. */

SELECT DISTINCT                        -- DISTINCT removed duplicate rows from joined tables set.
  sales_detail.SalesOrderId,
  sales_detail.OrderQty,
  sales_detail.UnitPrice,
  sales_detail.LineTotal,
  sales_detail.ProductId,
  sales_detail.SpecialOfferID,
  spec_offer_product.ModifiedDate,
  spec_offer.Category,
  spec_offer.Description
FROM `tc-da-1.adwentureworks_db.salesorderdetail` AS sales_detail
JOIN `tc-da-1.adwentureworks_db.specialofferproduct` AS spec_offer_product
ON sales_detail.SpecialOfferID = spec_offer_product.SpecialOfferID --Connect on Special OfferID
JOIN `tc-da-1.adwentureworks_db.specialoffer` AS spec_offer
ON spec_offer_product.SpecialOfferID = spec_offer.SpecialOfferID
ORDER BY LineTotal DESC;

/* 3.2 Your colleague has written this query to collect basic Vendor information.
The query does not work, look into the query and find ways to fix it.
Can you provide any feedback on how to make this query be easier to debug/read? */

SELECT 
  vendor.VendorID AS Id,
  vendor_contact.ContactID,
  vendor_contact.ContactTypeId,
  vendor.Name,
  vendor.CreditRating,
  vendor.ActiveFlag,
  vendor_address.AddressId,
  address.City
FROM `tc-da-1.adwentureworks_db.vendor` AS vendor
LEFT JOIN `tc-da-1.adwentureworks_db.vendorcontact` AS vendor_contact
ON vendor.VendorID = vendor_contact.VendorID
LEFT JOIN `tc-da-1.adwentureworks_db.vendoraddress` AS vendor_address
ON vendor.VendorID = vendor_address.VendorID
LEFT JOIN `tc-da-1.adwentureworks_db.address` AS address
ON vendor_address.AddressID = address.AddressID

/*
Alias was not correctly written - b and vendor_contact, d and address
For better understanding changed aliases.
Address used wrong JOIN
*/
