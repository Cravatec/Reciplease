//
//  RecipeStorageService.swift
//  Reciplease
//
//  Created by Sam on 25/09/2022.
//

import Foundation
import CoreData
import UIKit

protocol RecipeStorageService {
    func save(recipe: Recipe, completion: (Result<(Void), Error>) -> Void)
    
    func retrieve(completion: (Result<[Recipe], Error>) -> Void)
    
    func delete(_ recipe: Recipe, completion: (Result<Void, Error>) -> Void)
}

final class CoreDataRecipeStorage: RecipeStorageService {
    
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    lazy var context = appDelegate?.persistentContainer.viewContext
    
    private enum StorageError: Error {
        case notFound
    }
    
    func retrieve(completion: (Result<[Recipe], Error>) -> Void) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreDataRecipe")
        do {
            guard let result = try context?.fetch(fetchRequest) as? [NSManagedObject] else {
                return completion(.failure(StorageError.notFound))
            }
            var recipes = [Recipe]()
            for data in result  {
                let title = data.value(forKey: "title") as? String
                let image = data.value(forKey: "image") as? String
                let ingredientsLitteral = data.value(forKey: "ingredients") as? String
                let ingredientsArray = ingredientsLitteral?.components(separatedBy: ",")
                let ingredients = ingredientsArray?.compactMap({ ingredientString in
                    RecipeIngredients(text: ingredientString, image: nil)
                })
                let like = data.value(forKey: "like") as? Double
                let time = data.value(forKey: "time") as? Double
                let url = data.value(forKey: "url") as? String
                let imageUrl = URL(string: image ?? "")
                let recipeUrl = URL(string: url ?? "")
                let recipe = Recipe(title: title,
                                    subtitle: nil,
                                    image: imageUrl,
                                    like: like,
                                    time: time,
                                    detailIngredients: nil,
                                    uri: nil,
                                    url: recipeUrl!,
                                    ingredients: ingredients)
                recipes.append(recipe)
            }
            completion(.success(recipes))
        } catch {
            completion(.failure(error))
        }
    }
    
    func save(recipe: Recipe, completion: (Result<(Void), Error>) -> Void) {
        let favoriteRecipe = NSEntityDescription.insertNewObject(forEntityName: "CoreDataRecipe", into: context!)
        favoriteRecipe.setValue(recipe.title, forKey: "title")
        favoriteRecipe.setValue(recipe.image?.absoluteString, forKey: "image")
        let ingredientsInLine = recipe.ingredients?.map({$0.text}).joined(separator: ",")
        favoriteRecipe.setValue(ingredientsInLine ?? "", forKey: "ingredients")
        favoriteRecipe.setValue(recipe.like, forKey: "like")
        favoriteRecipe.setValue(recipe.time, forKey: "time")
        favoriteRecipe.setValue(recipe.url.absoluteString, forKey: "url")
        do {
            try context!.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func delete(_ recipe: Recipe, completion: (Result<Void, Error>) -> Void) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreDataRecipe")
        fetchRequest.predicate = NSPredicate(format: "title == %@", recipe.title!)
        
        do {
            let result = try context?.fetch(fetchRequest) as? [NSManagedObject]
            guard let recipeToDelete = result?.first else {
                return completion(.failure(StorageError.notFound))
            }
            context?.delete(recipeToDelete)
            try context?.save()
            completion(.success(()))
            
        } catch {
            completion(.failure(error))
            print("Failed to fetch recipe from CoreData for deletion: \(error.localizedDescription)")
        }
    }
}
