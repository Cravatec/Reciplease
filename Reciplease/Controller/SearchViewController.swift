//
//  SearchViewController.swift
//  Reciplease
//
//  Created by Sam on 31/08/2022.
//

import UIKit

class SearchViewController: UITableViewController {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var recipeTimeLabel: UILabel!
    @IBOutlet weak var recipeNoteLabel: UILabel!
    @IBOutlet weak var recipeIngredientsLabel: UILabel!
    
    
//TODO: - updateUI -> download image, update Labels,
    
    var recipe: Recipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AlamoFireFetchingRecipes.getRecipes(ingredients: "avocado") { [weak self] result in
                        guard let self = self else { return }
                        }
    }
}
