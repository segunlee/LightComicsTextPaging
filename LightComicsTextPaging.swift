//
//  LightComicsTextPaging.swift
//  LightComicsTextPaging
//
//  Created by SegunLee on 2020/01/02.
//

import UIKit
import CoreText

public struct LCTPRequestModel {
	public var string: String
	public var attributes: [NSAttributedString.Key: Any]
	public var containerSize: CGSize
	public var attributedString: NSAttributedString {
		return NSAttributedString(string: string, attributes: attributes)
	}
	
	public init(string: String, attributes: [NSAttributedString.Key : Any], containerSize: CGSize) {
		self.string = string
		self.attributes = attributes
		self.containerSize = containerSize
	}
}

public struct LCTPResultModel {
	public var string: String
	public var attrubutes: [NSAttributedString.Key: Any]
	public var containerSize: CGSize
	public var stringRanges: [String] = [String]()
	
	public init(request model: LCTPRequestModel) {
		self.string = model.string
		self.attrubutes = model.attributes
		self.containerSize = model.containerSize
	}
}


public class LightComicsTextPaging {
	
	public static func calculate(request model: LCTPRequestModel,
						  isCancelled: inout Bool,
						  progress: ((Float, Int) -> Void)?,
						  completion: @escaping ((LCTPResultModel) -> Void)) {
		
		var result = LCTPResultModel(request: model)
		
		let rect = CGRect(x: 0, y: 0, width: model.containerSize.width, height: model.containerSize.height)
		let attributedString = model.attributedString
		
		var calculateContentOffset: UInt64 = 0
		var calculatePageFinished: Bool = false
		var progressValue: Float = 0.0
		let path = CGMutablePath()
		path.addRect(rect)
		
		
		var defaultLength = 8000
		while !calculatePageFinished && !isCancelled {
			
			var substringRange = NSRange(location: Int(calculateContentOffset), length: defaultLength)
			if substringRange.location + substringRange.length > attributedString.length {
				substringRange.length = attributedString.length - substringRange.location
			}
			
			let childString = attributedString.attributedSubstring(from: substringRange)
			
			let frameSetter = CTFramesetterCreateWithAttributedString(childString)
			let frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, nil)
			let visibleRange = CTFrameGetVisibleStringRange(frame)
			let pageRange = NSRange(location: Int(calculateContentOffset), length: visibleRange.length)
			
			if visibleRange.length == 0 {
				defaultLength += 500
				continue
			}
			
			result.stringRanges.append(NSStringFromRange(pageRange))
			if (Int(calculateContentOffset) + visibleRange.length) != attributedString.length {
				calculateContentOffset += UInt64(visibleRange.length)
			} else {
				calculateContentOffset += UInt64(visibleRange.length)
				calculatePageFinished = true
			}
			
			let newProgressValue = Float(calculateContentOffset) / Float(attributedString.length)
			if newProgressValue != progressValue {
				progressValue = newProgressValue
				progress?(progressValue, result.stringRanges.count)
			}
		}
		
		guard !isCancelled else { return }
		completion(result)
	}
	
	
}
