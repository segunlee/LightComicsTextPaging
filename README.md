# LightComicsTextPaging

[![CI Status](https://img.shields.io/travis/segunlee/LightComicsTextPaging.svg?style=flat)](https://travis-ci.org/segunlee/LightComicsTextPaging)
[![Version](https://img.shields.io/cocoapods/v/LightComicsTextPaging.svg?style=flat)](https://cocoapods.org/pods/LightComicsTextPaging)
[![License](https://img.shields.io/cocoapods/l/LightComicsTextPaging.svg?style=flat)](https://cocoapods.org/pods/LightComicsTextPaging)
[![Platform](https://img.shields.io/cocoapods/p/LightComicsTextPaging.svg?style=flat)](https://cocoapods.org/pods/LightComicsTextPaging)

## Example

```swift
let request = LCTPRequestModel(string: sampleString, attributes: sampleAttributes, containerSize: CGSize(width: 320, height: 560))
var cancel = false

LightComicsTextPaging.calculate(request: request, isCancelled: &cancel, progress: nil, completion: { (result) in

  print("String length:\t\(result.string.count)")
  print("Number of page:\t\(result.stringRanges.count)")
 
  /*
		result.stringRanges
		{0, 1136}
		{1136, 1077}
		{2213, 1039}
		{3252, 1005}
		{4257, 1048}
		{5305, 985}
		{6290, 1108}
		{7398, 1106}
		...
  */
})
```

**check out Tests.swift**



## Installation

```ruby
pod 'LightComicsTextPaging'
```

## Author

segunlee, segunleedev@gmail.com

## License

LightComicsTextPaging is available under the MIT license. See the LICENSE file for more info.
