import Foundation

protocol Stylist {
    /// Allows this node to style the passed Attributed String.
    /// Makes the markdown more visually appealing.
    func style(_ string: NSMutableAttributedString) -> Void
}
