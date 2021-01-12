import AppKit

class GeneralPreferencesViewController: NSViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		buildView()
	}

	private func buildView() {
		guard let contentView = view.window?.contentView else { return }

		let gridView = NSGridView(views: [
			[
				NSTextField(labelWithString: "Show scroll bars:"),
				NSButton(radioButtonWithTitle: "Automatically based on mouse or trackpad", target: nil, action: nil)
			],
			[
				NSTextField(labelWithString: "Click in the scroll bar to:"),
				NSButton(radioButtonWithTitle: "Jump to the next page", target: nil, action: nil)
			]
		])

		gridView.translatesAutoresizingMaskIntoConstraints = false

		contentView.addSubview(gridView)

		NSLayoutConstraint.activate([
			gridView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
			gridView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
		])
	}

}
