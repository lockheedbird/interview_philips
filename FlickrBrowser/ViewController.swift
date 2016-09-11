//
//  ViewController.swift
//  FlickrBrowser
//
//  Created by maxlev on 9/11/16.
//  Copyright © 2016 LokiSoftware. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var imageView: UIImageView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	@IBAction func getImage(sender: UIButton) {
		if let requestURL = NSURL(string:"https://farm2.staticflickr.com/1103/567229075_2cf8456f01_s.jpg") {
		
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
						if let image = UIImage(data: data!) {
							print(image.size)
							dispatch_async(dispatch_get_main_queue()) {
								self.imageView.image = image
							}
						}
					}
				}
			}
		task.resume()
		}
	}


	@IBAction func didTapButton(sender: UIButton) {
		if let requestURL = NSURL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=c754e354bae8187babe94a1715e047ae&text=Rome&format=json&nojsoncallback=1") {

			//		let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
			let session = NSURLSession.sharedSession()
			print("\(requestURL)")
			let task = session.dataTaskWithURL(requestURL) {
				(data, response, error) -> Void in
				
				print("error = \(error)")
				
				let httpResponse = response as! NSHTTPURLResponse
				let statusCode = httpResponse.statusCode
				print(statusCode)
				if (statusCode == 200) {
					print("Everyone is fine, file downloaded successfully.")
					
					do{
						
						let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
						
						if let photosInfo = json["photos"] as? [String: AnyObject] {
							if let photos = photosInfo["photo"] as?  [[String : AnyObject]] {
								for photo in photos {
								
									if let owner = photo["owner"] as? String {
										
										if let id = photo["id"] as? String {
											print(owner,id)
										}
									}
								}
							}
							
						}
						
					}catch {
						print("Error with Json: \(error)")
					}
					
				}
			}
			print("task.resume")
			task.resume()
		}
	}
}

