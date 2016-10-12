import UIKit

class ImageViewController: UIViewController {
	@IBOutlet weak var imageView: UIImageView!
	
	var image: UIImage? = nil
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		imageView.image = image
	}	
}
