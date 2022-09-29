//
//  Recipe.swift
//  Reciplease
//
//  Created by Sam on 27/08/2022.
//

import Foundation

struct Recipe {
    
    // MARK: - Properties
    
    var title: String?
    var subtitle: String?
    var image: URL?
    var like: Double?
    var time: Double?
    var detailIngredients: String?
    var uri: String?
    var url: URL
    var ingredients: [RecipeIngredients]?
}
