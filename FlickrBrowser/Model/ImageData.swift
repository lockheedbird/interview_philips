//
//  ImageData.swift
//  FlickrBrowser
//
//  Created by maxlev on 9/15/16.
//  Copyright © 2016 LokiSoftware. All rights reserved.
//

import UIKit

class SingleImageData {
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

class ImageContainer {
	var imageContainer: [Int:SingleImageData]
	
	init () {
		imageContainer = [:]
	}
	
	func addImage(tableRow: Int, image: SingleImageData) -> Void {
		imageContainer[tableRow] = image
	}
}

class SingleImageData1 {
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
	
	func downloadImageData(source: String) {
		if let requestURL = NSURL(string: source) {
			
			let session = NSURLSession.sharedSession()
			print("\(requestURL)")
			let task = session.dataTaskWithURL(requestURL) {
				(data, response, error) -> Void in
				
				if error == nil {
					print("error = \(error)")
					
					let httpResponse = response as! NSHTTPURLResponse
					let statusCode = httpResponse.statusCode
					print(statusCode)
					if (statusCode == 200) {
						self.image = UIImage(data: data!)
					}
				}
			}
			task.resume()
		}
	}
}



