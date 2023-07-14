//
//  RecipesResponseTableViewCell.swift
//  Reciplease
//
//  Created by Sam on 18/09/2022.
//

import UIKit

protocol RecipesResponseTableViewCellDelegate: AnyObject {
    func didTapFavoriteButton(cell: RecipesResponseTableViewCell)
}

class RecipesResponseTableViewCell: UITableViewCell {
    
    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var recipeTimeLabel: UILabel!
    @IBOutlet weak var recipeNoteLabel: UILabel!
    @IBOutlet weak var recipeIngredientsLabel: UILabel!
    @IBOutlet weak var recipeResponseTableView: UITableView!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var timeLikeView: UIView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    weak var delegate: RecipesResponseTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        recipeImage.makeCornerRounded(cornerRadius: 10, borderWidth: 0.25)
        timeLikeView.makeCornerRounded(cornerRadius: 30, borderWidth: 0.25)
        favoriteButton.setTitle("", for: .normal)
    }
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        delegate?.didTapFavoriteButton(cell: self)
    }
}
