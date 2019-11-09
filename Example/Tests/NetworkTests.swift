import XCTest

class NetworkTests: XCTestCase {
  
  lazy var queue: OperationQueue = {
    var queue = OperationQueue()
    queue.name = "networkQueue"
    queue.maxConcurrentOperationCount = 4
    queue.qualityOfService = QualityOfService.userInitiated
    return queue
  }()
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testExample() {
    let exp = expectation(description: "Download json file")
    let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1")!
    let request = APIRequest(url: url)
    let operation = NetworkRequestOperation(request: request) { result in
      switch result {
      case let .success(response):
        if let data = response.body {
          do {
            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
              XCTFail()
              fatalError()
            }
            
            /*
             {
             "userId": 1,
             "id": 1,
             "title": "delectus aut autem",
             "completed": false
             }
             */
            
            guard let userId = json["userId"] as? Int, let id = json["id"] as? Int, let title = json["title"] as? String, let completed = json["completed"] as? Bool else {
              XCTFail()
              fatalError()
            }
            guard userId == 1, id == 1, title == "delectus aut autem", completed == false else {
              XCTFail()
              fatalError()
            }
            exp.fulfill()
          } catch {
            XCTFail()
            fatalError()
          }
        } else {
          XCTFail()
          fatalError()
        }
        
      case let .failure(error):
        XCTFail()
        fatalError()
      }
    }
    queue.addOperation(operation)
    wait(for: [exp], timeout: 5)
  }
  
  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measure() {
      // Put the code you want to measure the time of here.
    }
  }
  
}
