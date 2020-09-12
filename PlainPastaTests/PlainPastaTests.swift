// Created by Isaac Halvorson on 9/9/20

// swiftlint:disable implicitly_unwrapped_optional

@testable import Plain_Pasta
import XCTest

class PlainPastaTests: XCTestCase {

	var mockPasteboard: NSPasteboard?

	override func setUpWithError() throws {
		mockPasteboard = NSPasteboard.withUniqueName()
	}

	override func tearDownWithError() throws {
		mockPasteboard?.releaseGlobally()
		mockPasteboard = nil
	}

	// MARK: - NSPasteboardItem.plaintextifiedCopy Tests

	func testPlaintextifiedCopyFiltersUnwantedPasteboardContent() throws {
		// Given
		let mockPasteboardItem = NSPasteboardItem()

		// Pasteboard types Plain Pasta will ignore
		mockPasteboardItem.setString("string", forType: .string)
		mockPasteboardItem.setData(Data(), forType: .pdf)

		// Pasteboard types Plain Pasta will explicitly filter
		mockPasteboardItem.setString("html", forType: .html)
		mockPasteboardItem.setString("rtf", forType: .rtf)
		mockPasteboardItem.setString("rtfd", forType: .rtfd)
		mockPasteboardItem.setString(
			"public.url-name",
			forType: NSPasteboard.PasteboardType("public.url-name")
		)
		mockPasteboardItem.setString(
			"CorePasteboardFlavorType 0x75726C6E",
			forType: NSPasteboard.PasteboardType("CorePasteboardFlavorType 0x75726C6E")
		)
		mockPasteboardItem.setString(
			"WebURLsWithTitlesPboardType",
			forType: NSPasteboard.PasteboardType("WebURLsWithTitlesPboardType")
		)
		mockPasteboardItem.setString(
			"dyn.",
			forType: NSPasteboard.PasteboardType("dyn.foo")
		)

		// When
		let filteredComplexPasteboardItem = mockPasteboardItem.plaintextifiedCopy

		// Then

		// Check types that should not have been filtered
		XCTAssertEqual(filteredComplexPasteboardItem.string(forType: .string), "string")
		XCTAssertNotNil(filteredComplexPasteboardItem.data(forType: .pdf))

		// Check types that should have been filtered
		XCTAssertNil(filteredComplexPasteboardItem.string(forType: .html))
		XCTAssertNil(filteredComplexPasteboardItem.string(forType: .rtf))
		XCTAssertNil(filteredComplexPasteboardItem.string(forType: .rtfd))
		XCTAssertNil(
			filteredComplexPasteboardItem.string(forType: NSPasteboard.PasteboardType("public.url-name"))
		)
		XCTAssertNil(
			filteredComplexPasteboardItem.string(forType: NSPasteboard.PasteboardType("CorePasteboardFlavorType 0x75726C6E"))
		)
		XCTAssertNil(
			filteredComplexPasteboardItem.string(forType: NSPasteboard.PasteboardType("WebURLsWithTitlesPboardType"))
		)
		XCTAssertNil(
			filteredComplexPasteboardItem.string(forType: NSPasteboard.PasteboardType("dyn.foo"))
		)
	}

	func testPlaintextifiedCopyDoesNotFilterSimplePasteboardItem() throws {
		// Given
		let mockPasteboardItem = NSPasteboardItem()
		mockPasteboardItem.setString("string", forType: .string)

		// When
		let filteredMockPasteboardItem = mockPasteboardItem.plaintextifiedCopy

		// Then
		XCTAssertEqual(filteredMockPasteboardItem.types, mockPasteboardItem.types)
		for type in filteredMockPasteboardItem.types {
			XCTAssertEqual(filteredMockPasteboardItem.data(forType: type), mockPasteboardItem.data(forType: type))
		}
	}

	// MARK: - PasteboardMonitor Tests

	func testPasteboardMonitorWritesToPasteboard() throws {
		// Given
		let mockPasteboardItem = NSPasteboardItem()
		mockPasteboardItem.setString("string", forType: .string)

		let mockPasteboard = try XCTUnwrap(self.mockPasteboard)
		let mockPasteboardMonitor = PasteboardMonitor(for: mockPasteboard)

		// When
		mockPasteboard.clearContents()
		mockPasteboard.writeObjects([mockPasteboardItem])
		mockPasteboardMonitor.checkPasteboard(mockPasteboard)

		// Then
		let firstPasteboardItem = try XCTUnwrap(mockPasteboard.pasteboardItems?.first)
		XCTAssertEqual(firstPasteboardItem, mockPasteboardItem)
	}

	func testPasteboardMonitorDoesNothingIfInternalChangeCountAndPasteboardChangeCountEqual() throws {
		// Given
		let mockPasteboardItem = NSPasteboardItem()
		mockPasteboardItem.setString("string", forType: .string)

		let mockPasteboard = try XCTUnwrap(self.mockPasteboard)
		mockPasteboard.clearContents()
		mockPasteboard.writeObjects([mockPasteboardItem])

		let mockPasteboardMonitor = PasteboardMonitor(for: mockPasteboard)

		// When
		mockPasteboardMonitor.checkPasteboard(mockPasteboard)

		// Then
		let firstPasteboardItem = try XCTUnwrap(mockPasteboard.pasteboardItems?.first)
		XCTAssertEqual(firstPasteboardItem, mockPasteboardItem)
	}
}
