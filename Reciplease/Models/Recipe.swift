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
    var like: Int?
    var time: Int?
    var detailIngredients: String?
    var uri: String?
    var url: URL
    var ingredients: [RecipeIngredient]?
    var isFavorite: Bool = false
}

struct RecipeIngredient {
    let text: String
    let imageURL: String
}
