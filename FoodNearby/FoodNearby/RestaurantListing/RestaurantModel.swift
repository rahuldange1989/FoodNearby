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
struct Restaurant: Codable {
    let name: String
    let status: Status
    let sortingValues: SortingValues
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
