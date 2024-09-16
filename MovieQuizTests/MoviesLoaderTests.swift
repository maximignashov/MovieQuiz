//
//  MoviesLoaderTests.swift
//  MovieQuizTests
//
//  Created by Максим on 13.09.2024.
//

import XCTest
@testable import MovieQuiz

class MoviesLoaderTests: XCTestCase {
    func testSuccessLoading() {
        successFailureLoading(emulateError: false)
    }
    
    func testFailureLoading() {
        successFailureLoading(emulateError: true)
    }
    
    func successFailureLoading(emulateError: Bool) {
        let stubNetworkClient = StubNetworkClient(emulateError: emulateError)
        let loader = MoviesLoader(networkClient: stubNetworkClient)
        
        let expectation = expectation(description: "Loading expectation")
        
        loader.loadMovies { result in
            if emulateError {
                switch result {
                case .failure(let error):
                    XCTAssertNotNil(error)
                    expectation.fulfill()
                case .success(_):
                    XCTFail("Unexpected failure")
                }
            } else {
                switch result {
                case .success(let movies):
                    XCTAssertEqual(movies.items.count, 2)
                    expectation.fulfill()
                case .failure(_):
                    XCTFail("Unexpected failure")
                }
            }
        }
        
        waitForExpectations(timeout: 1)
    }
}
