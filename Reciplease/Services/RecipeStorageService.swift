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
    
    static let shared = CoreDataRecipeStorage()
    
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
                let ingredientText = data.value(forKey: "ingredients") as! String
                let ingredientImage = data.value(forKey: "ingredientImage") as! String
                let like = data.value(forKey: "like") as? Int
                let time = data.value(forKey: "time") as? Int
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
                                    ingredients: ingredientsConverterForCell(text: ingredientText, image: ingredientImage))
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
        let ingredientsText = recipe.ingredients?.map({$0.text}).joined(separator: " • ")
        favoriteRecipe.setValue(ingredientsText ?? "", forKey: "ingredients")
        let ingredientImage = recipe.ingredients?.compactMap({$0.imageURL}).joined(separator: " • ")
        favoriteRecipe.setValue(ingredientImage ?? "", forKey: "ingredientImage")
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
    
    func isFavorite(recipeTitle: String) -> Bool {
        var isFavorite: Bool
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreDataRecipe")
        fetchRequest.predicate = NSPredicate(format: "title == %@", recipeTitle)
        let recipeTitle = try? context?.fetch(fetchRequest)
        if recipeTitle?.count ?? 1 > 0 {
            isFavorite = true
        } else {
            isFavorite = false
        }
        return isFavorite
    }
}

private func ingredientsConverterForCell(text: String, image: String) -> [RecipeIngredient] {
    let text = text.components(separatedBy: " • ")
    let imageURL = image.components(separatedBy: " • ")
    var ingredients: [RecipeIngredient] = []
    
    for (index, text) in text.enumerated() {
        var image: String?
        if imageURL.indices.contains(index) {
            image = imageURL[index]
        }
        
        let ingredient = RecipeIngredient(text: text, imageURL: image ?? "")
        ingredients.append(ingredient)
    }
    return ingredients
}
