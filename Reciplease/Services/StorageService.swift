//
//  StorageService.swift
//  Reciplease
//
//  Created by Sam on 25/09/2022.
//

import Foundation
import CoreData

protocol RecipeStorageService {
    func save(recipe: Recipe)
    
    func retrieve() -> [Recipe]
}

final class CoreDataRecipeStorage: RecipeStorageService {
    
    let coreDataStack = CoreDataStack()
    
    func save(recipe: Recipe) {
        coreDataStack.save(recipe: recipe)
    }
    
    func delete(recipe: Recipe) {
        coreDataStack.delete(recipe) { result in
            print("Deletion Result \(result)")
        }
    }
    
    func retrieve() -> [Recipe] {
        return coreDataStack.retrieve()
    }
    
    func checkRecipeAlreadyFavorite(with recipeTitle: String) -> Bool {
        if coreDataStack.checkRecipeAlreadyFavorite(recipeTitle) {
            return true
        } else {
            return false
        }
    }
    
}
