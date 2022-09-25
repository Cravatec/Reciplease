//
//  RecipeViewController.swift
//  Reciplease
//
//  Created by Sam on 25/09/2022.
//

import Foundation
import UIKit
import CoreData

//recipeTable

class RecipeViewController: UIViewController {
    var recipe: Recipe!
    
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeTimeLabel: UILabel!
    @IBOutlet weak var recipeLikeLabel: UILabel!
    @IBOutlet weak var recipeTimeLikeView: UIView!
    @IBOutlet weak var recipeTitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeTimeLabel.text = "🕐 \(String(describing: recipe.time!))"
        recipeLikeLabel.text = "❤️ \(String(describing: recipe.like!))"
        recipeTitleLabel.text = recipe.title
        recipeImageView.image = UIImage(named: "default_Image.jpg")
        if let url = recipe.image {
            recipeImageView.imageLoadingFromURL(url: url)
        }
    }

}
