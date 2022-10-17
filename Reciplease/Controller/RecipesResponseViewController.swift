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
    private let service: RecipeStorageService = CoreDataService()
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipesResponseTable", for: indexPath) as? RecipesResponseTableViewCell
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
        let favoriteImage = UIImage(systemName: "heart.fill")
        let notFavoriteImage = UIImage(systemName: "heart")
        cell?.favoriteButton.setImage(recipe.isFavorite ? favoriteImage : notFavoriteImage, for: .normal)
        return cell ?? UITableViewCell()
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

extension RecipesResponseViewController: RecipesResponseTableViewCellDelegate {
    func didTapFavoriteButton(cell: RecipesResponseTableViewCell) {
        
        if let indexPath = recipesResponseTableView.indexPath(for: cell) {
            var recipe = recipes[indexPath.row]
            service.save(recipe: recipe)
            recipe.isFavorite = true
            recipes.insert(recipe, at: indexPath.row)
            let favoriteImage = UIImage(systemName: "heart.fill")
            cell.favoriteButton.setImage(favoriteImage, for: .normal)
            recipesResponseTableView.reloadData()
        }
    }
}
