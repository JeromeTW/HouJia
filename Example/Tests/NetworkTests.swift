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
  
  func test_get_request() {
    let url = URL(string: "https://postman-echo.com/get?foo1=bar1&foo2=bar2")!
    let request = APIRequest(url: url)
    let args = ["foo1": "bar1", "foo2": "bar2"]
    startPostManGetRequest(request: request, exceptionArgs: args)
  }
  
  func test_get_request_with_queryItems() {
    let url = URL(string: "https://postman-echo.com/get")!
    let queryItems = [
        URLQueryItem(name: "item key", value: "產品"),
        URLQueryItem(name: "size", value: "small"),
        URLQueryItem(name: "current", value: nil)
    ]
    let args = ["item key": "產品", "size": "small", "current": ""]
    guard let request = APIRequest(withoutQueryItemsURL: url, queryItems: queryItems) else {
      XCTFail()
      return
    }
    startPostManGetRequest(request: request, exceptionArgs: args)
  }
  
  func startPostManGetRequest(request: APIRequest, exceptionArgs: [String: String]? = nil, exceptionHeaders: [String: String]? = nil) {
    let exp = expectation(description: "request successfully")
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
               "args": {
                 "foo1": "bar1",
                 "foo2": "bar2"
               },
               "headers": {
                 "x-forwarded-proto": "https",
                 "host": "postman-echo.com",
                 "accept": "*//*",
                 "accept-encoding": "gzip, deflate",
                 "cache-control": "no-cache",
                 "postman-token": "5c27cd7d-6b16-4e5a-a0ef-191c9a3a275f",
                 "user-agent": "PostmanRuntime/7.6.1",
                 "x-forwarded-port": "443"
               },
               "url": "https://postman-echo.com/get?foo1=bar1&foo2=bar2"
             }
             */
            
            guard let headers = json["headers"] as? [String: String] else {
              XCTFail()
              fatalError()
            }
            
            exceptionHeaders?.forEach {
              XCTAssert(headers[$0.key] == $0.value)
            }
            
            logT(issue: "NetworkTest", message: "headers: \(headers)")
            if let responseArgs = json["args"] as? [String: String] {
              logT(issue: "NetworkTest", message: "responseArgs: \(responseArgs)")
              XCTAssert(responseArgs == exceptionArgs)
            }
            
            if let url = json["url"] as? String {
              logT(issue: "NetworkTest", message: "url: \(url)")
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
  
  func test_get_request_with_header() {
    let url = URL(string: "https://postman-echo.com/headers")!
    let headers: [HTTPHeader] = [
      HTTPHeader(field: "h1", value: "v1"),
      HTTPHeader(field: "h2", value: "v2")
      ]
    let exceptionHeaders = ["h1": "v1", "h2": "v2"]
    let request = APIRequest(url: url, headers: headers)
    startPostManGetRequest(request: request, exceptionHeaders: exceptionHeaders)
  }
  
}
