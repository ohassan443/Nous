	//
	//  MenuItemsViewModelTests.swift
	//  NOUSAPPTests
	//
	//  Created by Omar Hassan  on 04/06/2022.
	//

import XCTest
@testable import NOUSAPP
import Combine

class MenuItemsViewModelTests: XCTestCase {

	var bag = Set<AnyCancellable>()
	override	func  tearDown(){
		for sub in bag {
		   sub.cancel()
		}
	}

	func testfailedUrlParsing()  {
		let MenuItemRepoMock = MenuItemsRepoMock()
		MenuItemRepoMock.mockResponse = {onComplete in
			onComplete(.onFail(error: urlLoadingError.failedUrlParsing))
		}

		let failedUrlParsingExpect = expectation(description: "failedUrlParsing")

		let viewModel = MenuItemsViewModel(menuItemsRepo: MenuItemRepoMock)

		viewModel.$menuItems.sink(receiveValue: {items in

			if case Result.failure(urlLoadingError.failedUrlParsing) = items {
				failedUrlParsingExpect.fulfill()
			}
		}).store(in: &bag)

		viewModel.loadEndPointData()

		waitForExpectations(timeout: 1)


	}
	func testNilData()  {
		let MenuItemRepoMock = MenuItemsRepoMock()
		MenuItemRepoMock.mockResponse = {onComplete in
			onComplete(.onFail(error: urlLoadingError.nilData))
		}

		let nilDataExpect = expectation(description: "nilData")

		let viewModel = MenuItemsViewModel(menuItemsRepo: MenuItemRepoMock)

		viewModel.$menuItems.sink(receiveValue: {items in

			if case Result.failure(urlLoadingError.nilData) = items {
				nilDataExpect.fulfill()
			}
		}).store(in: &bag)

		viewModel.loadEndPointData()

		waitForExpectations(timeout: 1)


	}

	func testSuccessState()  {
		let MenuItemRepoMock = MenuItemsRepoMock()
		let successItems = [MenuItem(id: 1, title: "1", itemDescription: "1", imageURL: "1"),
							MenuItem(id: 2, title: "2", itemDescription: "2", imageURL: "2")]
		MenuItemRepoMock.mockResponse = {onComplete in
			onComplete(.success(items:successItems))
		}

		let successExpect = expectation(description: "success")


		let viewModel = MenuItemsViewModel(menuItemsRepo: MenuItemRepoMock)

		viewModel.$menuItems.sink(receiveValue: {items in

			if case Result.success(let items) = items , successItems.count == items.count ,Set(items) == Set(successItems){
				successExpect.fulfill()
			}
		}).store(in: &bag)

		viewModel.loadEndPointData()

		waitForExpectations(timeout: 1)


	}




}
