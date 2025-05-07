import XCTest
@testable import MovieQuiz

final class MoviesLoaderTests: XCTestCase {
    
    func testSuccessLoading() throws {
        // Given
        let stubNetworkClient = StubNetworkClient(emulateError: false)
        let loader = MoviesLoader(networkClient: stubNetworkClient)
        
        // When
        let expectation = expectation(description: "Loading expectation")
        
        loader.loadMovies { result in
            // Then
            switch result {
            case .success(let movies):
                expectation.fulfill()
            case .failure(_):
                XCTFail("Unexpected failure")
            }
        }
       
       waitForExpectations(timeout: 1)
    }
    
    func testFailureLoading() throws {
        // Given
        let stubNetworkClient = StubNetworkClient(emulateError: false)
        let loader = MoviesLoader(networkClient: stubNetworkClient)
        
        // When
        let expectation = expectation(description: "Loading expectation")
        
        loader.loadMovies { result in
             // Then
             switch result {
             case .success(let movies):
                 expectation.fulfill()
             case .failure(_):
                 XCTFail("Unexpected failure")
             }
         }
         waitForExpectations(timeout: 1)
    }
}
