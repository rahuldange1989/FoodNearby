//
//  RestaurantModel.swift
//  FoodNearby
//
//  Created by Rahul Dange on 02/03/20.
//  Copyright © 2020 Rahul Dange. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Welcome
struct RestaurantListResponse: Codable {
    let restaurants: [Restaurant]
}

// MARK: - Restaurant
class Restaurant: Codable, Equatable {
	let name: String
    let status: Status
    let sortingValues: SortingValues
	var isFavourite: Bool?
	
	init(name: String, status: Status, sortingValues: SortingValues, isFavourite: Bool?) {
		self.name = name
		self.status = status
		self.sortingValues = sortingValues
		self.isFavourite = isFavourite
	}
	
	static func == (lhs: Restaurant, rhs: Restaurant) -> Bool {
		return lhs.name == rhs.name
	}
}

// MARK: - SortingValues
struct SortingValues: Codable {
    let bestMatch, newest: Double?
    let ratingAverage: Double?
    let distance, popularity, averageProductPrice, deliveryCosts: Double?
    let minCost: Double?
}

enum Status: String, Codable {
    case closed = "closed"
    case orderAhead = "order ahead"
    case statusOpen = "open"
	
	func getStatusColor() -> UIColor {
		switch self {
			case .closed:
				return UIColor.systemRed
			
			case .orderAhead:
				return UIColor.systemOrange
			
			case .statusOpen:
				return UIColor.systemGreen
		}
	}
}

enum SortOptions: String {
	case bestMatch = "Best match"
	case newest = "Newest"
	case ratingAverage = "Rating average"
	case distance = "Distance"
	case popularity = "Popularity"
	case averageProductPrice = "Average product price"
	case deliveryCosts = "Delivery cost"
	case minCost = "Minimum cost"
	
	func rawValueString() -> String {
		return self.rawValue
	}
}
