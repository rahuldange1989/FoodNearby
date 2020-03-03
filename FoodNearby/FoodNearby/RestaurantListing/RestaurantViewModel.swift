//
//  RestaurantViewModel.swift
//  FoodNearby
//
//  Created by Rahul Dange on 02/03/20.
//  Copyright © 2020 Rahul Dange. All rights reserved.
//

import Foundation

protocol RestaurantListUpdateDelegate {
	func updateRestaurantList(list: [Restaurant])
}

class RestaurantViewModel {
	
	var delegate: RestaurantListUpdateDelegate? = nil
	
	init() {
		
	}
	
	// MARK: - Internal Methods -
}
