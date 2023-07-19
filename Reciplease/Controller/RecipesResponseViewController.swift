//
//  RecipesResponseViewController.swift
//  Reciplease
//
//  Created by Sam on 15/09/2022.
//

import Foundation
import UIKit
import CoreData

protocol SearchViewControllerDelegate {
    func didFinishLoadingRecipes( _ recipes: [Recipe])
}

class RecipesResponseViewController: UIViewController {
    
    var recipes = [Recipe]()
    private var selectedRecipe: Recipe?
    private let service: RecipeStorageService = CoreDataRecipeStorage()
    
    @IBOutlet weak var recipesResponseTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToRecipe", let recipe = selectedRecipe {
            guard let recipeViewController = segue.destination as? RecipeViewController else { return }
            recipeViewController.selectedRecipe = recipe
        }
    }
}

extension RecipesResponseViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeTableViewCell", for: indexPath) as? RecipeTableViewCell
        cell?.delegate = self
        let recipe = recipes[indexPath.row]
        cell?.recipeImage.image = UIImage(named: "default_Image.jpg")
        if let url = recipe.image {
            cell?.recipeImage.imageLoadingFromURL(url: url)
        }
        cell?.recipeTitleLabel.text = recipe.title!
        cell!.recipeTimeLabel.text = "🕐 \(String(describing: recipe.time!))"
        cell?.recipeNoteLabel.text  = "❤️ \(String(describing: recipe.like!))"
        cell?.recipeIngredientsLabel.text = recipe.detailIngredients!
        setStatusFavorite(cell: cell, recipe: recipe)
        return cell ?? UITableViewCell()
    }
    
    func setStatusFavorite(cell:RecipeTableViewCell?, recipe:Recipe) {
        let favoriteImage = UIImage(systemName: "heart.fill")
        let notFavoriteImage = UIImage(systemName: "heart")
        cell?.favoriteButton.setImage(recipe.isFavorite ? favoriteImage : notFavoriteImage, for: .normal)
    }
}

extension RecipesResponseViewController: SearchViewControllerDelegate {
    func didFinishLoadingRecipes(_ recipes: [Recipe]) {
        self.recipes = recipes
        recipesResponseTableView.reloadData()
        activityIndicator.stopAnimating()
    }
}

extension RecipesResponseViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRecipe = recipes[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "segueToRecipe", sender: self)
    }
}

extension RecipesResponseViewController: RecipeTableViewCellDelegate {
    func didTapFavoriteButton(cell: RecipeTableViewCell) {
        
        if let indexPath = recipesResponseTableView.indexPath(for: cell) {
            var recipe = recipes[indexPath.row]
            recipe.isFavorite = !recipe.isFavorite
            service.save(recipe: recipe) { result in 
                
            }
            recipes[indexPath.row] = recipe
            setStatusFavorite(cell: cell, recipe: recipe)
        }
    }
}
