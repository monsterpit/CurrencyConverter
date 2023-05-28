//
//  ExchangeRateViewControllerUITests.swift
//  CurrencyConverterUITests
//
//  Created by Vikas Salian on 15/05/23.
//

@testable import CurrencyConverter
import XCTest

final class ExchangeRateViewControllerUITests: XCTestCase{
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
        try super.tearDownWithError()
    }

    func testAmountTextField() throws {
        setAmountInTextField()
        XCTAssert(app.textFields["amountTextField"].value as! String == "100", "Amount text field should contain '100'")
    }
    
    func testCurrencySelection() throws {
        selectCurrencyFromDropDown()
        
        XCTAssert(app.textFields["currencySelectorView"].value as! String == "USD", "Selected currency should be 'USD'")
    }
    
    func testExchangeRatesCollectionView() throws {
        let collectionView = app.collectionViews["exchangeRatesCollectionView"]
        XCTAssert(collectionView.exists, "Exchange rates collection view should exist")
        
        var firstCell = collectionView.cells.element(boundBy: 0)
        XCTAssert(!firstCell.exists, "First cell should exist in the collection view if we have nothing set")
        
        selectCurrencyFromDropDown()
        setAmountInTextField()

        // Create an expectation for the API response
        let apiExpectation = expectation(description: "API response")

        // Simulate a delay for the API response (for demonstration purposes)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {

            // Fulfill the expectation when the API response is received
            apiExpectation.fulfill()
        }

        // Wait for the API response with a timeout
        waitForExpectations(timeout: 5) { error in

            // Check if an error occurred during the waiting period
            if let error = error {
                XCTFail("Failed to receive API response: \(error)")
            }

            //Get first Visible Cell
            firstCell = collectionView.cells.element(boundBy: 0)

            let rateLabel = firstCell.staticTexts["rateLabel"]
            XCTAssert(rateLabel.exists, "Rate label should exist in the first cell")
            XCTAssert(rateLabel.label.isEmpty == false, "Rate label should not be empty")
        }
    }
    
    private func setAmountInTextField(){
        app.textFields["amountTextField"].tap()
        app.textFields["amountTextField"].typeText("100")
        app.buttons["Done"].tap()
    }
    
    private func selectCurrencyFromDropDown(){
        app.textFields["currencySelectorView"].tap()
        
        // Access the dropDown table view
        let tableView = app.tables["DropdownTableView"]
        
        // Find the cell
        let cell = tableView.cells.containing(.staticText, identifier: "USD").firstMatch
        
        //Tap on the cell
        cell.tap()
    }
}
