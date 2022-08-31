//
//  FetchingRecipes.swift
//  Reciplease
//
//  Created by Sam on 31/08/2022.
//

import Foundation
import Alamofire

class FetchingRecipes {
    static func getRecipes(ingredients: String) {
        let url = URL(string: "https://api.edamam.com/api/recipes/v2")
        let parameters: Parameters = ["q": ingredients, "maxResult": 20, "type": "public", "app_id": ApiKey.app_id, "app_key": ApiKey.app_key]
        let request = AF.request(url!, method: .get, parameters: parameters)
        request.responseJSON { (data) in
              print(data) }
}
}
