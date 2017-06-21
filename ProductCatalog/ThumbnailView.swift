import Foundation
import UIKit
import Kingfisher
class ThumbnailView: UICollectionViewCell {
    
    @IBOutlet weak var productImage: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    func configure(product: Product) {
        name.text = product.productName
        let url = URL(string: "https://res.cloudinary.com/dh8cnckcf/image/upload/v1497952591/catalog/" + "\(product.productId)")
        productImage.kf.setImage(with: url)
    }
}
