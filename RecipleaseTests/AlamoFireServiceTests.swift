//
//  AlamoFireServiceTests.swift
//  RecipleaseTests
//
//  Created by Sam on 02/08/2023.
//

import Foundation
import XCTest
import Alamofire
@testable import Reciplease

class AlamoFireServiceTests: XCTestCase {
    
    func testGetRecipesSuccess() {
        let expectation = self.expectation(description: "Get Recipes")
        AlamoFireFetchingRecipes.getRecipes(ingredients: "chicken") { result in
            switch result {
            case .success(let recipes):
                XCTAssertFalse(recipes.isEmpty)
                expectation.fulfill()
            case .failure:
                XCTFail()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGetRecipesWithMultipleIngredients() {
        let expectation = self.expectation(description: "Get Recipes")
        AlamoFireFetchingRecipes.getRecipes(ingredients: "chicken", "rice", "lemon") { result in
            switch result {
            case .success(let recipes):
                XCTAssertFalse(recipes.isEmpty)
                expectation.fulfill()
            case .failure:
                XCTFail()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGetRecipesWithNoIngredients() {
        let expectation = self.expectation(description: "Get Recipes")
        AlamoFireFetchingRecipes.getRecipes(ingredients: "") { result in
            switch result {
            case .success(let recipes):
                XCTAssertTrue(recipes.isEmpty)
                expectation.fulfill()
            case .failure:
                XCTFail()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGetRecipesWithInvalidIngredients() {
        let expectation = self.expectation(description: "Get Recipes")
        AlamoFireFetchingRecipes.getRecipes(ingredients: "invalidIngredient") { result in
            switch result {
            case .success(let recipes):
                XCTAssertTrue(recipes.isEmpty)
                expectation.fulfill()
            case .failure:
                XCTFail()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
}
