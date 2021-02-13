protocol Enablable: AnyObject {
	var isEnabled: Bool { get }
	func enable()
	func disable()
}
