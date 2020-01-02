import XCTest
import LightComicsTextPaging

class Tests: XCTestCase {
    
	// MARK: - Properties
	var sampleString: String = String.randomString(length: 4000000)
	var sampleAttributes: [NSAttributedString.Key: Any] {
		let style = NSMutableParagraphStyle()
		style.lineSpacing = 0
		return [
			NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
			NSAttributedString.Key.paragraphStyle: style
		]
	}
	
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testExample() {
        XCTAssert(true, "Pass")
    }
	
	func testCalculatePaging() {
		
		let request = LCTPRequestModel(string: sampleString, attributes: sampleAttributes, containerSize: CGSize(width: 320, height: 560))
		var cancel = false
		
		
		let openDurationDate1 = Date()
		LightComicsTextPaging.fastCalculate(request: request, isCancelled: &cancel, progress: { (progress, pagingCount) in
		
//			print("progress: \(progress)\t|\tpagingCount: \(pagingCount)")
			
		}, completion: { (result) in
			
			print("String length:\t\(result.string.count)")
			print("Number of page:\t\(result.stringRanges.count)")
			print("fastCalculate takes \(Date().timeIntervalSince(openDurationDate1)) seconds")
		})
		
		let openDurationDate2 = Date()
		LightComicsTextPaging.calculate2(request: request, isCancelled: &cancel) { (result) in
			print("String length:\t\(result.string.count)")
			print("Number of page:\t\(result.stringRanges.count)")
			print("calculate2 takes \(Date().timeIntervalSince(openDurationDate2)) seconds")
		}

	}
		
}

extension String {
	static func randomString(length: Int) -> String {
		let letters = " abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789 "
		return String((0..<length).map{ _ in letters.randomElement()! })
	}
}
