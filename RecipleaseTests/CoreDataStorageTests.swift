//
//  CoreDataStorageTests.swift
//  RecipleaseTests
//
//  Created by Sam on 27/07/2023.
//

import XCTest
@testable import Reciplease

final class CoreDataStorageTests: XCTestCase {
    
    var storageService: RecipeStorageService!
    
    override func setUp() {
        super.setUp()
        storageService = CoreDataRecipeStorage.shared
    }
    
    override func tearDown() {
        storageService = nil
        super.tearDown()
    }
    
    func testRetrieveRecipes() {
        let expectation = self.expectation(description: "Retrieve recipes")
        storageService.retrieve { result in
            switch result {
            case .success(let recipes):
                XCTAssertFalse(recipes.isEmpty, "Failed to retrieve recipes")
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Failed to retrieve recipes with error: \(error)")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testDeleteRecipe() {
        let expectation = self.expectation(description: "Delete recipe")
        let recipe = Recipe(title: "Test Recipe", subtitle: nil, image: nil, like: 0, time: 0, detailIngredients: nil, uri: nil, url: URL(string: "https://www.example.com")!, ingredients: [])
        storageService.delete(recipe) { result in
            switch result {
            case .success:
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Failed to delete recipe with error: \(error)")
            }
        }
        waitForExpectations(timeout: 5, handler:nil)
    }
}
