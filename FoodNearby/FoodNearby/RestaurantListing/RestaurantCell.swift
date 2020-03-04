//
//  RestaurantCell.swift
//  FoodNearby
//
//  Created by Rahul Dange on 03/03/20.
//  Copyright © 2020 Rahul Dange. All rights reserved.
//

import UIKit

class RestaurantCell: UITableViewCell {

	@IBOutlet weak var statusLabel: UILabel!
	@IBOutlet weak var ratingView: RatingView!
	@IBOutlet weak var minimumCostLabel: UILabel!
	@IBOutlet weak var deliveryLabel: UILabel!
	@IBOutlet weak var distanceLabel: UILabel!
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
		self.nameLabel.text = restaurant.name
		
		// -- set distance
		if let distance = restaurant.sortingValues.distance {
			self.distanceLabel.text = String.init(format: "%.2f km", distance/1000)
		}
		
		// -- set delivery cost
		if let deliveryCost = restaurant.sortingValues.deliveryCosts {
			self.deliveryLabel.text = deliveryCost == 0.0 ? "Free" : String.init(format: "%.2f €", deliveryCost/100)
		}
		
		// -- set Minimum cost
		if let minCost = restaurant.sortingValues.minCost {
			self.minimumCostLabel.text = String.init(format: "%.2f €", minCost/100)
		}
		
		// -- set rating
		if let rating = restaurant.sortingValues.ratingAverage {
			self.ratingView.rating = rating
		}
		
		// -- handle favourite
		favouriteBtn.setImage(UIImage(systemName: (restaurant.isFavourite ?? false) ? "suit.heart.fill" : "suit.heart"), for: .normal)
	
		// -- handle status and status label color
		self.statusLabel.text = restaurant.status.rawValue.capitalized
		switch restaurant.status {
			case .closed:
				self.statusLabel.textColor = UIColor.systemRed
			
			case .orderAhead:
				self.statusLabel.textColor = UIColor.systemOrange
			
			case .statusOpen:
				self.statusLabel.textColor = UIColor.systemGreen
		}
	}
}
