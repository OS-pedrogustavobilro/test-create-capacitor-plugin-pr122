import Foundation

@objc public class CapacitorJava: NSObject {
    @objc public func echo(_ value: String) -> String {
        print(value)
        return value
    }
}
