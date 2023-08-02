//
//  IngredientTableViewCell.swift
//  Reciplease
//
//  Created by Sam on 29/09/2022.
//

import UIKit

class IngredientTableViewCell: UITableViewCell {

    @IBOutlet weak var ingredientImage: UIImageView!
    @IBOutlet weak var ingredientLabel: UILabel!
    
    func configureCell(with url: URL?, ingredientText: String) {
        if let url = url {
            ingredientImage.imageLoadingFromURL(url: url)
        }
        ingredientLabel.text = ingredientText
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        ingredientImage.layer.cornerRadius = 60 / 2
        selectionStyle = .none
    }
}
