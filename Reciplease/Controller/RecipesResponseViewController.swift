//
//  RecipesResponseViewController.swift
//  Reciplease
//
//  Created by Sam on 15/09/2022.
//

import Foundation
import UIKit

class RecipesResponseViewController: UIViewController {

    @IBOutlet weak var recipesResponseTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

class RecipesResponseTableViewCell: UITableViewCell {
    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var recipeTimeLabel: UILabel!
    @IBOutlet weak var recipeNoteLabel: UILabel!
    @IBOutlet weak var recipeIngredientsLabel: UILabel!
    @IBOutlet weak var recipeResponseTableView: UITableView!
}
