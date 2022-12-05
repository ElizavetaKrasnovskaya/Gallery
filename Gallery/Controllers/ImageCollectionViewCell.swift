import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var galleryImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func update(image: UIImage) {
        galleryImage.image = image
    }
}
