//
//  ScratchPad.swift
//  FlickrBrowser
//
//  Created by maxlev on 10/2/16.
//  Copyright © 2016 LokiSoftware. All rights reserved.
//

import Foundation

class ScratchPad {
//	func photosDataBasedOnSearchTerm1(searchTerm: String) {
//		photoDictionaryByRow.removeAll()
//		tableSize = 0
//		tableView.reloadData()
//		
//		if let requestURL = NSURL(string: FlickrSearchRequestString(searchTerm: searchTerm).buildRequest()) {
//			let session = NSURLSession.sharedSession()
//			print("\(requestURL)")
//			let task = session.dataTaskWithURL(requestURL) {
//				(data, response, error) -> Void in
//				
//				print("error = \(error)")
//				
//				let httpResponse = response as! NSHTTPURLResponse
//				let statusCode = httpResponse.statusCode
//				print(statusCode)
//				if (statusCode == 200) {
//					print("Everyone is fine, file downloaded successfully.")
//					
//					do{
//						
//						let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
//						
//						if let photosInfo = json["photos"] as? [String: AnyObject] {
//							if let photos = photosInfo["photo"] as?  [[String : AnyObject]] {
//								self.tableSize = photos.count
//								dispatch_async(dispatch_get_main_queue()) {
//									self.tableView.reloadData()
//								}
//								var row: Int = 0
//								for photo in photos {
//									if let owner = photo["owner"] as? String {
//										if let id = photo["id"] as? String {
//											self.downloadSizes(id, row: row)
//											print(owner,id)
//										}
//									}
//									row = row + 1
//								}
//							}
//							
//						}
//						
//					}
//					catch {
//						print("Error with Json: \(error)")
//					}
//				}
//			}
//			print("task.resume")
//			task.resume()
//		}
//	}
//	
//	func downloadImageData1(source: String, row: Int) {
//		if let requestURL = NSURL(string: source) {
//			let session = NSURLSession.sharedSession()
//			print("\(requestURL)")
//			let task = session.dataTaskWithURL(requestURL) {
//				(data, response, error) -> Void in
//				if error == nil {
//					print("error = \(error)")
//					let httpResponse = response as! NSHTTPURLResponse
//					let statusCode = httpResponse.statusCode
//					print(statusCode)
//					if (statusCode == 200) {
//						if let image = UIImage(data: data!) {
//							print(image.size)
//							self.photoDictionaryByRow[row] = image
//							if (self.photoDictionaryByRow.count == self.tableSize) {
//								dispatch_async(dispatch_get_main_queue()) {
//									self.searchBar.userInteractionEnabled = true
//								}
//							}
//							dispatch_async(dispatch_get_main_queue()) {
//								self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: row, inSection: 0)], withRowAnimation:.Automatic)
//							}
//						}
//					}
//				}
//			}
//			task.resume()
//		}
//	}
	
	
//	func downloadSizes1(photoID: String, row: Int, photo: Photo) {
//		if let requestURL = NSURL(string: FlickrGetSizesRequestString(photoID: photoID).buildRequest()) {
//			print("Download sizes request URL: \(requestURL)")
//			let session = NSURLSession.sharedSession()
//			let task = session.dataTaskWithURL(requestURL) {
//				(data, response, error) -> Void in
//				if error == nil {
//					let httpResponse = response as! NSHTTPURLResponse
//					let statusCode = httpResponse.statusCode
//					if (statusCode == 200) {
//						let json = try! NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
//						
//						if let sizesInfo = json["sizes"] as? [String: AnyObject] {
//							if let sizes = sizesInfo["size"] as?  [[String : AnyObject]] {
//								if let size = sizes.first {
//									if let source = size["source"] as? String {
//										print("image source: \(source)")
//										
//										self.downloadImageData(source, row: row, photo: photo)
//									}
//								}
//							}
//						}
//					}
//				}
//			}
//			task.resume()
//		}
//	}
	
//	func downloadSizes1(photoID: String, row: Int, photo: Photo) {
//		print("*****************************************************")
//		downloadSizes.fetchResponseData(FlickrGetSizesRequestString(photoID: photoID).buildRequest(), callback: { (response) in
//			if let responseData = response as? NSData {
//				let json = try! NSJSONSerialization.JSONObjectWithData(responseData, options:.AllowFragments)
//				if let sizesInfo = json["sizes"] as? [String: AnyObject] {
//					if let sizes = sizesInfo["size"] as?  [[String : AnyObject]] {
//						if let size = sizes.first {
//							if let source = size["source"] as? String {
//								print("image source: \(source)")
//								
//								self.downloadImageData(source, row: row, photo: photo)
//							}
//						}
//					}
//				}
//			}
//		})
//	}

}
