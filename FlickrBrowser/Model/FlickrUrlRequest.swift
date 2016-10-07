//
//  FlickrUrlRequest.swift
//  FlickrBrowser
//
//  Created by maxlev on 10/1/16.
//  Copyright © 2016 LokiSoftware. All rights reserved.
//

import Foundation

class FlickrUrlRequest {
	var responseData: NSData? = nil
	var requestURL: NSURL? = nil
	
	func fetchResponseData(source: String, callback: (AnyObject) -> ()) {
//		print("==================== REQUEST URL STRING =========================")
//		print(source)
//		print("=================================================================")
		requestURL = NSURL(string: source)!
		let session = NSURLSession.sharedSession()
		let task = session.dataTaskWithURL(requestURL!) {
			(data, response, error) -> Void in
			if error == nil {
				//print("error = \(error)")
				let httpResponse = response as! NSHTTPURLResponse
				let statusCode = httpResponse.statusCode
				//print(statusCode)
				if (statusCode == 200) {
					callback(data!)
				}
			}
		}
		task.resume()
	}
	
	func getResponseData() -> NSData {
		return responseData!
	}
	
	func setResponseData(data: NSData) {
		responseData = data
	}
	
	func printData() {
		print(responseData)
	}
}
