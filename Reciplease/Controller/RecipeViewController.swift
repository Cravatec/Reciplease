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
    
    @IBAction func tapFavoriteButton(_ sender: Any) {
        didTapFavoriteButton()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userInterface()
    }
    
    @IBAction func getDirections(_ sender: Any) {
        UIApplication.shared.open(selectedRecipe.url)
    }
    
    
    
    func userInterface() {
        recipeImageView?.image = UIImage(named: "default_Image.jpg")
        if let url = selectedRecipe.image {
            recipeImageView.imageLoadingFromURL(url: url)
        }
        recipeImageView.makeCornerRounded(cornerRadius: 10, borderWidth: 0.25)
        recipeTimeLikeView.makeCornerRounded(cornerRadius: 30, borderWidth: 0.25)
        recipeTimeLabel?.text = "🕐 \(String(describing: selectedRecipe.time!)) min"
        recipeLikeLabel?.text = "❤️ \(String(describing: selectedRecipe.like!)) Like"
        recipeTitleLabel?.text = selectedRecipe.title
        guard CoreDataRecipeStorage.shared.isFavorite(recipeTitle: selectedRecipe.title!)
        else {
            recipeFavoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
            return
        }
        recipeFavoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
    }
    
    func didTapFavoriteButton() {
        guard CoreDataRecipeStorage.shared.isFavorite(recipeTitle: selectedRecipe.title!)
        else {
            recipeFavoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            CoreDataRecipeStorage.shared.save(recipe: selectedRecipe) { result in
            }
            return
        }
        recipeFavoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        CoreDataRecipeStorage.shared.delete(selectedRecipe) { result in
            recipeFavoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
}

// MARK: - TableViewDataSource

extension RecipeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let recipe = selectedRecipe else { return 1 }
        return recipe.ingredients?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard selectedRecipe != nil else { return UITableViewCell() }
        guard let ingredientCell = recipeIngredientTable.dequeueReusableCell(
            withIdentifier: "recipeIngredientCell",
            for: indexPath
        ) as? IngredientTableViewCell else { return UITableViewCell() }
        let ingredient = selectedRecipe.ingredients?[indexPath.row].text
        let ingredientImageURL = selectedRecipe.ingredients?[indexPath.row].imageURL
        ingredientCell.configureCell(with: ingredientImageURL, ingredientText: ingredient ?? "No ingredient")
        return ingredientCell
    }
}
