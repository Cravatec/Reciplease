//
//  CoreDataStack.swift
//  Reciplease
//
//  Created by Sam on 29/09/2022.
//

import Foundation
import CoreData
import UIKit

class CoreDataStack {
    // MARK: - Singleton
    static let shared = CoreDataStack()
    
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
                print("retrieve")
            }
            completion(.success(recipes))
        } catch {
            completion(.failure(error))
        }
    }
    
    func retrieve() -> [Recipe] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreDataRecipe")
        do {
            guard let result = try context?.fetch(fetchRequest) as? [NSManagedObject] else {
                return []
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
                print("retrieve")
            }
            return recipes
        } catch {
            print(error.localizedDescription)
            return []
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
            print("Save in CoreData")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func save(recipe: Recipe) {
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
            print("Save in CoreData")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func checkRecipeAlreadyFavorite(_ recipeTitle: String) -> Bool {
        let fetchRequest: NSFetchRequest<CoreDataStorage> = NSFetchRequest(entityName: "CoreDataRecipe")
        fetchRequest.predicate = NSPredicate(format: "title == %@", recipeTitle)
        do {
            let recipes = try context?.fetch(fetchRequest)
            return recipes!.isEmpty
        } catch {
            return false
        }
    }
}


