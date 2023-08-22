//
//  MockRecipeStorageService.swift
//  RecipleaseTests
//
//  Created by Sam on 22/08/2023.
//

import Foundation
import CoreData
@testable import Reciplease

class MockRecipeStorageService: RecipeStorageService {
    var recipes: [Recipe] = []
    
    func save(recipe: Recipe, completion: (Result<Void, Error>) -> Void) {
        recipes.append(recipe)
        completion(.success(()))
    }
    
    func retrieve(completion: (Result<[Recipe], Error>) -> Void) {
        completion(.success(recipes))
    }
    
    func delete(_ recipe: Recipe, completion: (Result<Void, Error>) -> Void) {
        if let index = recipes.firstIndex(where: { $0.title == recipe.title }) {
            recipes.remove(at: index)
            completion(.success(()))
        } else {
            completion(.failure(CoreDataRecipeStorage.StorageError.notFound))
        }
    }
}
