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
	
	public static func fastCalculate(request model: LCTPRequestModel,
						  isCancelled: inout Bool,
						  progress: ((Float, Int) -> Void)?,
						  completion: @escaping ((LCTPResultModel) -> Void)) {
		
		var result = LCTPResultModel(request: model)
		
		let attributedString = model.attributedString
		var calculateContentOffset: UInt64 = 0
		var calculatePageFinished: Bool = false
		var progressValue: Float = 0.0
		let path = CGPath(rect: CGRect(origin: .zero, size: model.containerSize), transform: nil)
		
		
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
			
			defaultLength = visibleRange.length + 500
			
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
	
	public static func calculate2(request model: LCTPRequestModel, isCancelled: inout Bool, completion: @escaping ((LCTPResultModel) -> Void)) {
		// NOTE: From Internet Sources
		
		var result = LCTPResultModel(request: model)
		
		let frameSetter = CTFramesetterCreateWithAttributedString(model.attributedString)
		var stringRange = CFRange(location: 0, length: 0)
		let attributedStringLength = model.attributedString.length
		let path = CGPath(rect: CGRect(origin: .zero, size: model.containerSize), transform: nil)
		
		repeat {
			let frame = CTFramesetterCreateFrame(frameSetter, stringRange, path, nil)
			let visibleRange = CTFrameGetVisibleStringRange(frame)
			let pageRange = NSRange(location: stringRange.location, length: visibleRange.length)
			result.stringRanges.append(NSStringFromRange(pageRange))
			stringRange.location += visibleRange.length
			
		} while stringRange.location < attributedStringLength && !isCancelled
		
		completion(result)
		
	}
	
	
	public static func calculate3(request model: LCTPRequestModel, isCancelled: inout Bool, completion: @escaping ((LCTPResultModel) -> Void)) {
		// NOTE: From Internet Sources
		
		var result = LCTPResultModel(request: model)
		
		let attrString = model.attributedString
		let frameSetter = CTFramesetterCreateWithAttributedString(attrString)
		let path = CGPath(rect: CGRect(origin: .zero, size: model.containerSize), transform: nil)
		var range = CFRangeMake(0, 0)
		var rangeOffset: NSInteger = 0
		
		repeat {
			let frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(rangeOffset, 0), path, nil)
			range = CTFrameGetVisibleStringRange(frame)
			result.stringRanges.append(NSStringFromRange(NSMakeRange(rangeOffset, range.length)))
			rangeOffset += range.length
			
		} while range.location + range.length < attrString.length && !isCancelled
		
		completion(result)
	}
	
}
