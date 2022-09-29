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
    
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    private lazy var context = appDelegate?.persistentContainer.viewContext
    
    func retrieve() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreDataRecipe")
        do {
            guard let result = try context?.fetch(fetchRequest) as? [NSManagedObject] else { return }
            for data in result  {
                let title = data.value(forKey: "title") as? String
            }
        } catch {
            
        }
    }
    
    func save() {
        
    }
}


