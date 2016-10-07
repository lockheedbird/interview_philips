//
//  ImageData.swift
//  FlickrBrowser
//
//  Created by maxlev on 9/15/16.
//  Copyright © 2016 LokiSoftware. All rights reserved.
//

import UIKit

class SingleImageJsonObject {
	var imageData:[[String : AnyObject]] = []
	var processedImage: SingleImageData? = nil
	
	func singleImage(responseData: NSData) {
		let json = try! NSJSONSerialization.JSONObjectWithData(responseData, options:.AllowFragments)
		if let sizesInfo = json["sizes"] as? [String: AnyObject] {
			if let sizes = sizesInfo["size"] as?  [[String : AnyObject]] {
				imageData = sizes
				//print("*****************************************************")
				//print(imageData)
				//print("*****************************************************")
			}
		}
	}
	
	func getImageSourceByLabel(label: String = "Square") -> String? {
		// Download biggest possible image
		// return imageData.last!["source"] as? String
		
		for item in imageData {
			if let image = item as NSDictionary? {
				let key = image["label"] as? String
				if key == label {
					return image["source"] as? String
				}
			}
		}
		return nil
	}
}

class ImageCollection {
	var images: [Int:SingleImageJsonObject]
	
	init () {
		images = [:]
	}
	
	func addImage(tableRow: Int, image: SingleImageJsonObject) -> Void {
		images[tableRow] = image
	}
}















class SingleImageData2 {
	let imageData: NSDictionary
	
	init (imageData: [String: AnyObject] ) {
		self.imageData = imageData
	}
	
	func printImageData() -> Void {
		for image in self.imageData {
			print(image)
		}
	}
	
	func imageSourceByLabel(label: String) -> String {
		var imageSource: String? = nil
		if let images = self.imageData["size"] as? [NSDictionary] {
			print("============ IMAGES DICT ==============")
			print(images)
			print("===============================================")
			for image in images {
				print("============= SINGLE IMAGE ================")
				print(image)
				print("===============================================")
				if let imageForLabel = image  as? [String: AnyObject] {
					if let imageLabel = imageForLabel["label"] as? String {
						print("============== IMAGE LABEL ===============")
						print(imageLabel)
						print("===============================================")
						if imageLabel == label {
							imageSource = imageForLabel["source"] as? String
							print(" ===================================>>>>>>>>> \(imageSource)")
							break
						}
						else
						{
							print("=============>>>>>>>>> DANGER DANGER DANGER <<<<<<<<<<<<<<================")
							print(imageForLabel)
							print("=============>>>>>>>>> DANGER DANGER DANGER <<<<<<<<<<<<<<================")
						}
					}
				}
			}
		}
	
		// TODO: Guard against missing labels that make imageSource == nil
		return imageSource!
	}
	
//	func keys() -> Array<Any> {
//		return imageData.keys
//	}
}






class SingleImageData {
	var image:  UIImage? = nil
	var label:  String //"Square"
	var width:  Int    // 75
	var height: Int    // 75
	var source: String //"https:\/\/farm9.staticflickr.com\/8480\/29063840663_fdd44ac783_s.jpg"
	var url:    String //https:\/\/www.flickr.com\/photos\/mtlmonti\/29063840663\/sizes\/sq\/"
	var media:  String //photo
	
	init(data: [String: AnyObject]) {
		label = data["label"]! as! String
		width = data["width"]! as! Int
		height = data["height"]! as! Int
		source = data["source"]! as! String
		url = data["url"]! as! String
		media = data["media"]! as! String
	}
}



