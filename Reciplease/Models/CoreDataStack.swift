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
    var selectedRecipe: Recipe!
    // MARK: - Singleton
    static let shared = CoreDataStack()
    
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    private lazy var context = appDelegate?.persistentContainer.viewContext
    
    func retrieve() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreDataRecipes")
        do {
            guard let result = try context?.fetch(fetchRequest) as? [NSManagedObject] else { return }
            for data in result  {
                let title = data.value(forKey: "title") as? String
                let image = data.value(forKey: "image") as? String
                let ingredients = data.value(forKey: "ingredients") as? String
                let like = data.value(forKey: "like") as? Double
                let time = data.value(forKey: "time") as? Double
                let url = data.value(forKey: "url") as? String
                print(data)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func save() {
        let favoriteRecipe = NSEntityDescription.insertNewObject(forEntityName: "CoreDataRecipes", into: context!)
        favoriteRecipe.setValue(selectedRecipe.title, forKey: "title")
        favoriteRecipe.setValue(selectedRecipe.image, forKey: "image")
        favoriteRecipe.setValue(selectedRecipe.ingredients, forKey: "ingredients")
        favoriteRecipe.setValue(selectedRecipe.like, forKey: "like")
        favoriteRecipe.setValue(selectedRecipe.time, forKey: "time")
        favoriteRecipe.setValue(selectedRecipe.url, forKey: "url")
        print(favoriteRecipe)
        do {
            try context!.save()
           
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    
}


