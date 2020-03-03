//
//  RestaurantCell.swift
//  FoodNearby
//
//  Created by Rahul Dange on 03/03/20.
//  Copyright © 2020 Rahul Dange. All rights reserved.
//

import UIKit

class RestaurantCell: UITableViewCell {

	@IBOutlet weak var minimumCostLabel: UIImageView!
	@IBOutlet weak var deliveryLabel: UILabel!
	@IBOutlet weak var timerLabel: UILabel!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var favouriteBtn: UIButton!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

	// MARK: - Internal methods -
	func setupCell(restaurant: Restaurant) {
		
	}
}
