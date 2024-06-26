import UIKit

extension UIImage {
    func sameAspectRatio(newHeigt: CGFloat) -> UIImage {
        let scale = newHeigt / size.height
        let newWidth = size.width * scale
        let newSize = CGSize(width: newWidth, height: newHeigt)
        return UIGraphicsImageRenderer(size: newSize).image {_ in
            self.draw(in: .init(origin: .zero, size: newSize))
        }
    }
}
