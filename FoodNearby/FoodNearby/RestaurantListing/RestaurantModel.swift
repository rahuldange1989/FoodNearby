//
//  RestaurantModel.swift
//  FoodNearby
//
//  Created by Rahul Dange on 02/03/20.
//  Copyright © 2020 Rahul Dange. All rights reserved.
//

import Foundation


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
