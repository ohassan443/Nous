//
//  MenuItemsProtocol.swift
//  NOUSAPP
//
//  Created by Omar Hassan  on 04/06/2022.
//

import Foundation
enum MenuItemsReturnResponse {
	case success(items : [MenuItem])
	case onFail(error:urlLoadingError)
}

protocol MenuItemsRepoProtocol{

	func loadData( onComplete: @escaping (MenuItemsReturnResponse) -> Void) -> Void
}
