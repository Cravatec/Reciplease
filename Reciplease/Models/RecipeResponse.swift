//
//  RecipeResponse.swift
//  Reciplease
//
//  Created by Sam on 08/09/2022.
//

import Foundation

// MARK: - Welcome

struct ResultRecipe: Decodable {
    let from, to, count: Int
    let hits: [Hit]
    
    enum CodingKeys: String, CodingKey {
        case from, to, count
        case hits
    }
}

// MARK: - Hit

struct Hit: Decodable {
    let recipe: APIRecipe
}

// MARK: - Recipe

struct APIRecipe: Decodable {
    let uri: String
    let label: String
    let image: URL
    let images: Images
    let url: URL
    let yield: Double
    let ingredientLines: [String]
    let ingredients: [RecipeIngredients]
    let totalTime: Double
}

// MARK: - Ingredient

struct RecipeIngredients: Decodable {
    let text: String
//    let quantity: Double
//    let measure: String?
//    let food: String
//    let weight: Double
//    let foodCategory: String?
//    let foodID: String
    let image: String?
    
//    enum CodingKeys: String, CodingKey {
//        case text, quantity, measure, food, weight, foodCategory
//        case foodID = "foodId"
//        case image
//    }
}

// MARK: - Images

struct Images: Decodable {
    let thumbnail, small, regular: Large
    let large: Large?

    enum CodingKeys: String, CodingKey {
        case thumbnail = "THUMBNAIL"
        case small = "SMALL"
        case regular = "REGULAR"
        case large = "LARGE"
    }
}

// MARK: - Large

struct Large: Decodable {
    let url: String
    let width, height: Int
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
