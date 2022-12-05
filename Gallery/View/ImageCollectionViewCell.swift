import UIKit
import Alamofire
import AlamofireImage

final class ImageCollectionViewCell: UICollectionViewCell {

    static let identifier = "ImageCollectionViewCell"
    
    @IBOutlet weak var galleryImage: UIImageView!
    
    static func nib() -> UINib {
        UINib(nibName: identifier, bundle: nil)
    }
    
    override func prepareForReuse() {
        galleryImage.image = nil
    }
    
    func setup(with photo: UIImage) {
        galleryImage.image = photo
    }
}
