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
    
    static func getRecipes(ingredients: String..., callback: @escaping (ResultRecipe?) -> Void) {
        let url = URL(string: "https://api.edamam.com/api/recipes/v2")
        
        let ingredientsInLine = ingredients.joined(separator: ",")
        
        let parameters: Parameters = ["q": ingredientsInLine, "maxResult": 20, "type": "public", "app_id": ApiKey.app_id, "app_key": ApiKey.app_key]
        
        let request = AF.request(url!, method: .get, parameters: parameters).responseDecodable(of: ResultRecipe.self) { response in
            guard let recipe = response.value else {
                callback(nil)
                return
            }
            callback(recipe)
            print(recipe)
        }
    }
    }
