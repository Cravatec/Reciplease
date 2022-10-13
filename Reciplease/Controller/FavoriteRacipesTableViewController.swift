//
//  FavoriteRacipesTableViewController.swift
//  Reciplease
//
//  Created by Sam on 07/10/2022.
//

import UIKit
import CoreData

class FavoriteRacipesTableViewController: UITableViewController {
    
    @IBOutlet var favoriteTableView: UITableView!
    
    private let coreDataService = CoreDataService()
    
    var favoriteRecipes: [Recipe] = [] {
        didSet {
            favoriteTableView.reloadData()
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteRecipes = coreDataService.retrieve()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favoriteTableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteRecipes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "favorites", for: indexPath) as? RecipesResponseTableViewCell else {
            return UITableViewCell()
        }
        guard indexPath.row < favoriteRecipes.count else { return cell }
        let recipe = favoriteRecipes[indexPath.row]
        cell.recipeImage.image = UIImage(named: "default_Image.jpg")
        if let url = recipe.image {
            cell.recipeImage.imageLoadingFromURL(url: url)
        }
        cell.recipeTitleLabel.text = recipe.title!
        cell.recipeTimeLabel.text = "🕐 \(String(describing: recipe.time!))"
        cell.recipeNoteLabel.text  = "❤️ \(String(describing: recipe.like!))"
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = favoriteRecipes[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "segueFavoriteToRecipe", sender: self)
    }
}
