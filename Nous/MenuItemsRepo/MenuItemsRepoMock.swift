	//
	//  MenuItemsRepoMock.swift
	//  NOUSAPP
	//
	//  Created by Omar Hassan  on 04/06/2022.
	//

import Foundation


class MenuItemsRepoMock: MenuItemsRepoProtocol{
	init(){}

	var mockResponse : (( _ onComplete: @escaping (MenuItemsReturnResponse) -> Void) -> ())? = nil

	func loadData( onComplete: @escaping (MenuItemsReturnResponse) -> Void) ->(){
		mockResponse?(onComplete)
	}
}


