//
//  FetchingRecipes.swift
//  Reciplease
//
//  Created by Sam on 31/08/2022.
//

import Foundation
import Alamofire
import SwiftUI

class AlamoFireFetchingRecipes {
    
    static func getRecipes(ingredients: String..., completion: (x) -> Void) {
        let url = URL(string: "https://api.edamam.com/api/recipes/v2")
        
        let ingredientsInLine = ingredients.joined(separator: ",")
        
        let parameters: Parameters = ["q": ingredientsInLine, "maxResult": 20, "type": "public", "app_id": ApiKey.app_id, "app_key": ApiKey.app_key]
        
        let request = AF.request(url!, method: .get, parameters: parameters)
        request.responseJSON { (data) in
            if case .success(let result) = data.result {
                if let hitsDictionary = result as? [String:Any] {
                    //                    print(hitsDictionary["hits"] as? [[String:Any]])
                    if let hitsArray = hitsDictionary["hits"] as? [[String:Any]] {
                        let recipes = hitsArray.map { dict in
                            let recipe = dict["recipe"] as? [String:Any]
//                            print("== + ==\(recipe)\n")
                            let recipeData = try? JSONSerialization.data(withJSONObject: recipe!)
                            let result = try? JSONDecoder().decode(RecipeDataModel.self, from: recipeData!)
                            print("Resultat: \(String(describing: result))")
                        }
                    }
                    //                    let recipesArray = hitsDictionnary.map { <#(key: String, value: Any)#> in
                    //                        <#code#>
                    //                    }
                    
                }
            }
        }
    }
    
}

struct RecipeDataModel: Decodable {
    let title: String
    let imageURL: String
    let ingredients: [String]
    let executionTime: String
    let note: Double
    let instructions: String
    
    enum CodingKeys: CodingKey {
        case title
        case imageURL
        case ingredients
        case executionTime
        case note
        case instructions
    }
}
