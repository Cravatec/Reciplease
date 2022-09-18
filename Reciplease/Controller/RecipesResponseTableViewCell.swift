//
//  RecipesResponseTableViewCell.swift
//  Reciplease
//
//  Created by Sam on 18/09/2022.
//

import UIKit

class RecipesResponseTableViewCell: UITableViewCell {
    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var recipeTimeLabel: UILabel!
    @IBOutlet weak var recipeNoteLabel: UILabel!
    @IBOutlet weak var recipeIngredientsLabel: UILabel!
    @IBOutlet weak var recipeResponseTableView: UITableView!
    @IBOutlet weak var recipeImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
