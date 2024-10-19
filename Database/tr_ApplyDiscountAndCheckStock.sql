USE ProductManagement
Go
CREATE OR ALTER TRIGGER ApplyDiscountAndCheckStock
ON Sales
BEFIRE INSERT
AS
BEGIN
    DECLARE @ProductID INT, @QuantitySold INT, @StoreID INT, @SaleDate DATE;
    DECLARE @AvailableStock INT, @Price DECIMAL(10, 2), @Discount DECIMAL(5, 2), @TotalPrice DECIMAL(10, 2);
    DECLARE @DiscountPercentage DECIMAL(5, 2), @HasDiscount BIT = 0;

    -- Get values from the inserted sale record
    SELECT @ProductID = i.ProductID, @QuantitySold = i.QuantitySold, @StoreID = i.StoreID, @SaleDate = i.SaleDate
    FROM Inserted i;

    -- Check available stock for the product in the specific store
    SELECT @AvailableStock = StockLevel
    FROM Inventory
    WHERE ProductID = @ProductID AND StoreID = @StoreID;

    -- Check if enough stock is available
    IF @AvailableStock >= @QuantitySold
    BEGIN
        -- Get the product price
        SELECT @Price = Price
        FROM Product
        WHERE ProductID = @ProductID;

        -- Check if there is a valid discount for the product during the sale date
        SELECT @DiscountPercentage = DiscountPercentage, @HasDiscount = 1
        FROM Discounts
        WHERE ProductID = @ProductID
        AND @SaleDate BETWEEN StartDate AND EndDate;

        -- If a discount is active, apply it
        IF @HasDiscount = 1
        BEGIN
            -- Calculate the discounted total price
            SET @TotalPrice = @QuantitySold * (@Price - (@Price * @DiscountPercentage / 100));
        END
        ELSE
        BEGIN
            -- No discount, calculate total price normally
            SET @TotalPrice = @QuantitySold * @Price;
        END

        -- Insert the sale with the calculated total price
        INSERT INTO Sales (SaleDate, ProductID, QuantitySold, TotalPrice, StoreID)
        SELECT SaleDate, ProductID, QuantitySold, @TotalPrice, StoreID
        FROM Inserted;

        -- Update the stock level in the inventory
        UPDATE Inventory
        SET StockLevel = StockLevel - @QuantitySold
        WHERE ProductID = @ProductID AND StoreID = @StoreID;
    END
    ELSE
    BEGIN
        -- Raise an error if there's not enough stock
        RAISERROR ('Not enough stock available for this product in the selected store.', 16, 1);
    END
END;
