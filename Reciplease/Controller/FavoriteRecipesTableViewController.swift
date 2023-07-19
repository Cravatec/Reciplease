//
//  FavoriteRacipesTableViewController.swift
//  Reciplease
//
//  Created by Sam on 07/10/2022.
//

import UIKit
import CoreData

class FavoriteRecipesTableViewController: UITableViewController {
    
    @IBOutlet var favoriteTableView: UITableView!
    
    private let coreDataService = CoreDataRecipeStorage()
    
    var selectedRecipe: Recipe?
    
    var favoriteRecipes: [Recipe] = [] {
        didSet {
            favoriteTableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favoriteRecipes = coreDataService.retrieve()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteRecipes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeTableViewCell", for: indexPath) as? RecipeTableViewCell else {
            return UITableViewCell()
        }
        guard indexPath.row < favoriteRecipes.count else { return cell }
        let recipe = favoriteRecipes[indexPath.row]
        cell.recipeImage.image = UIImage(named: "default_Image.jpg")
        if let url = recipe.image {
            cell.recipeImage.imageLoadingFromURL(url: url)
        }
        cell.recipeTitleLabel.text = recipe.title
        cell.recipeTimeLabel.text = "🕐 \(String(describing: recipe.time!))"
        cell.recipeNoteLabel.text  = "❤️ \(String(describing: recipe.like!))"
        let favoriteImage = UIImage(systemName: "heart.fill")
        cell.favoriteButton.setImage(favoriteImage, for: .normal)
        cell.delegate = self
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueFavoriteToRecipe", let recipe = selectedRecipe {
            guard let recipeViewController = segue.destination as? RecipeViewController else { return }
            recipeViewController.selectedRecipe = recipe
        }
    }
    
    func setStatusFavorite(cell:RecipeTableViewCell?, recipe:Recipe) {
        let favoriteImage = UIImage(systemName: "heart.fill")
        let notFavoriteImage = UIImage(systemName: "heart")
        cell?.favoriteButton.setImage(recipe.isFavorite ? favoriteImage : notFavoriteImage, for: .normal)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRecipe = favoriteRecipes[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "segueFavoriteToRecipe", sender: self)
    }
}

extension FavoriteRecipesTableViewController: RecipeTableViewCellDelegate {
    func didTapFavoriteButton(cell: RecipeTableViewCell) {
        
        if let indexPath = tableView.indexPath(for: cell) {
            var recipe = favoriteRecipes[indexPath.row]
            recipe.isFavorite = !recipe.isFavorite
            coreDataService.delete(recipe: recipe)
            favoriteRecipes[indexPath.row] = recipe
            setStatusFavorite(cell: cell, recipe: recipe)
            favoriteTableView.reloadData()
        }
    }
}
