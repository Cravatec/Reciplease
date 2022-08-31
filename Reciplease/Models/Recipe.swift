//
//  Recipe.swift
//  Reciplease
//
//  Created by Sam on 27/08/2022.
//

import Foundation

typealias Ingredient = [String: Any]

struct Recipe {
    let title: String
    let imageURL: URL
    let ingredients: [Ingredient]
    let executionTime: String
    let note: Double
    let instructions: URL
}

