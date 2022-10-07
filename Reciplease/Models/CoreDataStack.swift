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
    private lazy var context = appDelegate?.persistentContainer.viewContext
    
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
                let ingredients = data.value(forKey: "ingredients") as? String
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
                                    ingredients: nil)
                recipes.append(recipe)
                print("retrieve")
            }
            return recipes
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func save(recipe: Recipe) {
        let favoriteRecipe = NSEntityDescription.insertNewObject(forEntityName: "CoreDataRecipe", into: context!)
        favoriteRecipe.setValue(recipe.title, forKey: "title")
        favoriteRecipe.setValue(recipe.image?.absoluteString, forKey: "image")
        favoriteRecipe.setValue(recipe.ingredients, forKey: "ingredients")
        favoriteRecipe.setValue(recipe.like, forKey: "like")
        favoriteRecipe.setValue(recipe.time, forKey: "time")
        favoriteRecipe.setValue(recipe.url.absoluteString, forKey: "url")
        do {
            try context!.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}


