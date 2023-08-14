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
    
    // MARK: - Singleton pattern
    
    static let shared = AlamoFireFetchingRecipes()
    
    private init() {}
    
    //MARK: - Methods
    
    static func getRecipes(ingredients: String..., callback: @escaping (Result<[Recipe], Error>) -> Void) {
        let url = URL(string: "https://api.edamam.com/api/recipes/v2")
        
        let ingredientsInLine = ingredients.joined(separator: ",")
        
        let parameters: Parameters = ["q": ingredientsInLine, "maxResult": 20, "type": "public", "app_id": ApiKey.app_id, "app_key": ApiKey.app_key]
        
        _ = AF.request(url!, method: .get, parameters: parameters).responseDecodable(of: ResultRecipe.self) { response in
            if let resultRecipe = response.value {
                let recipes = resultRecipe.hits.map { hit in
                    Recipe(hit: hit)
                }
                callback(.success(recipes))
                return
            }
            if let error = response.error {
                callback(.failure(error))
            }
        }
    }
    
}

private extension Recipe {
    init(hit: Hit) {
        title = hit.recipe.label
        time = hit.recipe.totalTime
        like = hit.recipe.yield
        detailIngredients = String(describing:hit.recipe.ingredientLines)
        image = hit.recipe.image
        ingredients = hit.recipe.ingredients.map({ ingredient in
            RecipeIngredient(text: ingredient.text, imageURL: String(ingredient.image ?? ""))
        })
        url = hit.recipe.url
    }
}
