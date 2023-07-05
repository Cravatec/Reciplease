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

class CoreDataRecipeStorage: RecipeStorageService {
    
    func save(recipe: Recipe) {
    }
    
    func retrieve() -> [Recipe] {
        return []
    }
}

class CoreDataService: RecipeStorageService {
    
    let coreDataStack = CoreDataStack()
    
    func save(recipe: Recipe) {
        
        if (recipe.isFavorite) {
            coreDataStack.save(recipe: recipe)
        }
        else {
     //       coreDataStack.checkRecipeAlreadyFavorite(<#String#>)
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
