//
//  Model.swift
//  NOUSAPP
//
//  Created by Omar Hassan  on 29/05/2022.
//

import Foundation

struct MenuItemsWrapper: Codable {
	let items: [MenuItem]
}

struct MenuItem: Codable ,Identifiable,Hashable{
	let id: Int
	let title, itemDescription: String
	let imageURL: String


	func hash(into hasher: inout Hasher) {
			hasher.combine(id)
			hasher.combine(title)
		hasher.combine(itemDescription)
		hasher.combine(imageURL)
		}
	enum CodingKeys: String, CodingKey {
		case id, title
		case itemDescription = "description"
		case imageURL = "imageUrl"
	}
}
