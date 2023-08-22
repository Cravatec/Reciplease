//
//  RecipleaseUITests.swift
//  RecipleaseUITests
//
//  Created by Sam on 27/08/2022.
//

import XCTest
@testable import Reciplease

class RecipleaseUITests: XCTestCase {
    
    override func setUpWithError() throws {
        app.launch()

        continueAfterFailure = false
        
        XCUIDevice.shared.orientation = .portrait
    }
    
    let app = XCUIApplication()
    var textField: XCUIElement { app.textFields["Salad, Tomato, Onion, ..."] }
    
    func testA_SearchUI() {
        textField.tap()
        textField.tap()
        
        app.keys["A"].tap()
        app.keys["p"].tap()
        app.keys["p"].tap()
        app.keys["l"].tap()
        app.keys["e"].tap()
        app/*@START_MENU_TOKEN@*/.staticTexts["Add"]/*[[".buttons[\"Add\"].staticTexts[\"Add\"]",".staticTexts[\"Add\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        app.buttons["Search Button"].staticTexts["Search Recipes"].tap()
        
        let recipeResponse = app.tables.children(matching: .cell).element(boundBy: 0).staticTexts["Title"]
        while !recipeResponse.exists {
            sleep(1)
        }
        
        XCTAssertTrue(recipeResponse.exists)
    }
    
    func testB_AddFavorites() {
        textField.tap()
        textField.tap()
        
        app/*@START_MENU_TOKEN@*/.keys["S"]/*[[".keyboards.keys[\"S\"]",".keys[\"S\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.keys["a"]/*[[".keyboards.keys[\"a\"]",".keys[\"a\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.keys["l"]/*[[".keyboards.keys[\"l\"]",".keys[\"l\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.keys["a"]/*[[".keyboards.keys[\"a\"]",".keys[\"a\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.keys["d"]/*[[".keyboards.keys[\"d\"]",".keys[\"d\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.staticTexts["Add"]/*[[".buttons[\"Add\"].staticTexts[\"Add\"]",".staticTexts[\"Add\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        app.buttons["Search Button"].staticTexts["Search Recipes"].tap()
        
        app.tables.children(matching: .cell).element(boundBy: 0).buttons["Favorite Button"].tap()
    }
    
    func testC_OpenRecipeInFavoritesAndGetTheRecipeButton() {
        app.tabBars["Tab Bar"].buttons["Favorites"].tap()
        app.tables.cells.children(matching: .other).element(boundBy: 0).tap()
        app/*@START_MENU_TOKEN@*/.staticTexts["Get the Recipe➾"]/*[[".buttons[\"Get the Recipe➾\"].staticTexts[\"Get the Recipe➾\"]",".staticTexts[\"Get the Recipe➾\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
    }
    
    func testD_DeleteFavorites() {
        app.tabBars["Tab Bar"].buttons["Favorites"].tap()
        
        let favButton = app.tables/*@START_MENU_TOKEN@*/.buttons["Favorite Button"]/*[[".cells.buttons[\"Favorite Button\"]",".buttons[\"Favorite Button\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        while !favButton.exists {
            sleep(1)
        }
        app.tables/*@START_MENU_TOKEN@*/.buttons["Favorite Button"]/*[[".cells.buttons[\"Favorite Button\"]",".buttons[\"Favorite Button\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let noFavortite = app.tables["You don’t have any favorites yet,\ntouch the ❤️ to add one"].staticTexts["You don’t have any favorites yet,\ntouch the ❤️ to add one"]
        
        XCTAssertTrue(noFavortite.exists)
    }
}
