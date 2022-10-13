//
//  RecipeViewController.swift
//  Reciplease
//
//  Created by Sam on 25/09/2022.
//

import Foundation
import UIKit
import CoreData

class RecipeViewController: UIViewController {
    var selectedRecipe: Recipe!
    
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeTimeLabel: UILabel!
    @IBOutlet weak var recipeLikeLabel: UILabel!
    @IBOutlet weak var recipeTimeLikeView: UIView!
    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var recipeIngredientTable: UITableView!
    @IBOutlet weak var recipeFavoriteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeImageView.makeCornerRounded(cornerRadius: 10, borderWidth: 0.25)
        recipeTimeLikeView.makeCornerRounded(cornerRadius: 30, borderWidth: 0.25)
        recipeTimeLabel?.text = "🕐 \(String(describing: selectedRecipe.time))"
        recipeLikeLabel?.text = "❤️ \(String(describing: selectedRecipe.like))"
        recipeTitleLabel?.text = selectedRecipe.title
        recipeImageView?.image = UIImage(named: "default_Image.jpg")
        if let url = selectedRecipe.image {
            recipeImageView.imageLoadingFromURL(url: url)
        }
    }
    
    @IBAction func getDirections(_ sender: Any) {
        UIApplication.shared.open(selectedRecipe.url)
    }
}
// MARK: - TableViewDataSource

extension RecipeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let recipe = selectedRecipe else { return 1 }
        return recipe.ingredients!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard selectedRecipe != nil else { return UITableViewCell() }
        guard let ingredientCell = recipeIngredientTable.dequeueReusableCell(
            withIdentifier: "recipeIngredientCell",
            for: indexPath
        ) as? IngredientTableViewCell else { return UITableViewCell() }
        let ingredientLabel = selectedRecipe.ingredients![indexPath.row].text
        let imageString = selectedRecipe.ingredients![indexPath.row].image
        let ingredientImage = URL(string: imageString!)
        ingredientCell.configureCell(with: ingredientImage, ingredientText: "\(String(describing:ingredientLabel))")
        return ingredientCell
    }
}
