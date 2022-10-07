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

 //   var coreData

    func save(recipe: Recipe) {

    }

    func retrieve() -> [Recipe] {
        return []
    }

}

class CoreDataService: RecipeStorageService {
    
    let coreDataStack = CoreDataStack()
    
    func save(recipe: Recipe) {
        coreDataStack.save(recipe: recipe)
    }
    
    func retrieve() -> [Recipe] {
        return coreDataStack.retrieve()
    }
    
}
