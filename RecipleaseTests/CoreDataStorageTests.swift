//
//  CoreDataStorageTests.swift
//  RecipleaseTests
//
//  Created by Sam on 27/07/2023.
//

import XCTest
import CoreData
@testable import Reciplease

class CoreDataStorageTests: XCTestCase {
    
    var mockStorageService: MockRecipeStorageService!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockStorageService = MockRecipeStorageService()
    }
    
    override func tearDownWithError() throws {
        mockStorageService = nil
        try super.tearDownWithError()
    }
    
    func testSaveRecipe() {
        let recipe = createTestRecipe()
        
        let expectation = XCTestExpectation(description: "Recipe saved")
        
        mockStorageService.save(recipe: recipe) { result in
            switch result {
            case .success:
                XCTAssertEqual(self.mockStorageService.recipes.count, 1)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Failed to save recipe: \(error)")
            }
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testRetrieveRecipes() {
        let recipe = createTestRecipe()
        mockStorageService.recipes.append(recipe)
        
        let expectation = XCTestExpectation(description: "Recipes retrieved")
        
        mockStorageService.retrieve { result in
            switch result {
            case .success(let recipes):
                XCTAssertEqual(recipes.count, 1)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Failed to retrieve recipes: \(error)")
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testDeleteRecipe() {
        let recipe = createTestRecipe()
        mockStorageService.recipes.append(recipe)
        
        let expectation = XCTestExpectation(description: "Recipe deleted")
        
        mockStorageService.delete(recipe) { result in
            switch result {
            case .success:
                XCTAssertEqual(self.mockStorageService.recipes.count, 0)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Failed to delete recipe: \(error)")
            }
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testDeleteNonExistingRecipe() {
        let recipe = createTestRecipe()
        
        let expectation = XCTestExpectation(description: "Non-existing recipe deletion")
        
        mockStorageService.delete(recipe) { result in
            switch result {
            case .success:
                XCTFail("Deleting non-existing recipe should fail")
            case .failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testRetrieveEmptyRecipes() {
        let expectation = XCTestExpectation(description: "Empty recipes retrieval")
        
        mockStorageService.retrieve { result in
            switch result {
            case .success(let recipes):
                XCTAssertEqual(recipes.count, 0)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Failed to retrieve recipes: \(error)")
            }
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    //MARK: - Create a sample recipe for testing
    private func createTestRecipe() -> Recipe {
        let recipe = Recipe(
            title: "Test Recipe",
            image: URL(string: "https://apple.com/image.jpg")!,
            like: 10,
            time: 30,
            url: URL(string: "https://apple.com/recipe")!)
        return recipe
    }
}
