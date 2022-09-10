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
    
    static func getRecipes(ingredients: String..., callback: @escaping (Result<ResultRecipe, Error>) -> Void) {
        let url = URL(string: "https://api.edamam.com/api/recipes/v2")
        
        let ingredientsInLine = ingredients.joined(separator: ",")
        
        let parameters: Parameters = ["q": ingredientsInLine, "maxResult": 20, "type": "public", "app_id": ApiKey.app_id, "app_key": ApiKey.app_key]
        
        _ = AF.request(url!, method: .get, parameters: parameters).responseDecodable(of: ResultRecipe.self) { response in
            if let recipe = response.value {
                callback(.success(recipe))
                print(recipe)
                return
            }
            if let error = response.error {
                callback(.failure(error))
                print(error)
            }
        }
    }
}
