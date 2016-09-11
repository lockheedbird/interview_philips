//
//  ImageViewController.swift
//  FlickrBrowser
//
//  Created by maxlev on 9/11/16.
//  Copyright © 2016 LokiSoftware. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
	@IBOutlet weak var imageView: UIImageView!
	
	var image: UIImage? = nil
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		imageView.image = image
	}
	
}
