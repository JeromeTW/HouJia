import XCTest

class LoggerTests: XCTestCase {
  override func setUp() {
    super.setUp()
    logTextView.text = ""
    let fileManager = FileManager.default
    guard let cachesDirectory = fileManager.cachesDirectory else { return }
    do {
      try fileManager.removeItem(at: cachesDirectory)
    } catch {
      print(error.localizedDescription)
    }
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  enum URLError: Error {
    case invalidURL
  }
  
  func test_print_every_level() {
    logger.configure(shouldShow: true, shouldCache: false)
    let userString = "userString"
    let codeString = "codeString"
    let traceString = "traceString"
    let errorString = "errorString"
    let faultString = "faultString"
    logU(userString)
    logC(codeString)
    logT(issue: "#36", message: traceString)
    logE(URLError.invalidURL, message: errorString)
    logF(faultString)
    XCTAssert(logTextView.logText.contains(userString))
    XCTAssert(logTextView.logText.contains(codeString))
    XCTAssert(logTextView.logText.contains(traceString))
    XCTAssert(logTextView.logText.contains(errorString))
    XCTAssert(logTextView.logText.contains(faultString))
  }
  
  func test_log_file_is_existed() {
    logger.configure(shouldShow: false, shouldCache: true)
    let userString = "userString"
    let codeString = "codeString"
    let traceString = "traceString"
    let errorString = "errorString"
    let faultString = "faultString"
    logU(userString)
    logC(codeString)
    logT(issue: "#36", message: traceString)
    logE(URLError.invalidURL, message: errorString)
    logF(faultString)
    let fileManager = FileManager.default
    guard let cachesDirectory = fileManager.cachesDirectory else { return }
    let currentDateString = Date().string(format: "yyyy-MM-dd")
    let filePath = cachesDirectory.appendingPathComponent("\(currentDateString).log")

    XCTAssert(fileManager.fileExists(atPath: filePath.path))
  }
  
  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measure() {
      // Put the code you want to measure the time of here.
    }
  }
  
}
