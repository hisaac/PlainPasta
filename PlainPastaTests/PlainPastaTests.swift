// Created by Isaac Halvorson on 9/9/20

// swiftlint:disable implicitly_unwrapped_optional

@testable import Plain_Pasta
import XCTest
import os.log

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

	func testPlaintextifiedCopyDoesNotFilterSimplePasteboardItem() throws {
		// Given
		let mockPasteboardItem = NSPasteboardItem()
		mockPasteboardItem.setString("string", forType: .string)

		// When
		let filteredMockPasteboardItem = mockPasteboardItem.plaintextifiedCopy()

		// Then
		XCTAssertEqual(filteredMockPasteboardItem.types, mockPasteboardItem.types)
		for type in filteredMockPasteboardItem.types {
			XCTAssertEqual(filteredMockPasteboardItem.data(forType: type), mockPasteboardItem.data(forType: type))
		}
	}

	func testPlaintextifiedCopyFiltersUnwantedPasteboardContent() throws {
		// Given
		let mockPasteboardItem = NSPasteboardItem()

		// Pasteboard types Plain Pasta will ignore
		mockPasteboardItem.setString("string", forType: .string)
		mockPasteboardItem.setData(Data(), forType: .png)

		mockPasteboardItem.setString("dyn.type", forType: NSPasteboard.PasteboardType("dyn.type"))
		for type in PasteboardMonitor.pasteboardTypeFilterList {
			mockPasteboardItem.setString("\(type.self)", forType: type)
		}

		// When
		let filteredComplexPasteboardItem = mockPasteboardItem.plaintextifiedCopy()

		// Then

		// Check types that should not have been filtered
		XCTAssertEqual(filteredComplexPasteboardItem.string(forType: .string), "string")
		XCTAssertNotNil(filteredComplexPasteboardItem.data(forType: .png))

		// Check types that should have been filtered
		XCTAssertNil(filteredComplexPasteboardItem.string(forType: NSPasteboard.PasteboardType("dyn.type")))
		for type in PasteboardMonitor.pasteboardTypeFilterList {
			XCTAssertNil(filteredComplexPasteboardItem.string(forType: type))
		}
	}

	func testPlaintextifiedCopyDoesNotFilterWhenNoTypesPassedIn() throws {
		// Given
		let mockPasteboardItem = NSPasteboardItem()
		for type in PasteboardMonitor.pasteboardTypeFilterList {
			mockPasteboardItem.setString("\(type.self)", forType: type)
		}

		// When
		let unfilteredMockPasteboardItem = mockPasteboardItem.plaintextifiedCopy(filteredTypes: [])

		// Then
		XCTAssertFalse(unfilteredMockPasteboardItem.types.isEmpty)
		XCTAssertEqual(unfilteredMockPasteboardItem.types, mockPasteboardItem.types)
		for type in PasteboardMonitor.pasteboardTypeFilterList {
			XCTAssertEqual(unfilteredMockPasteboardItem.string(forType: type), mockPasteboardItem.string(forType: type))
		}
	}

	// MARK: - PasteboardMonitor Tests

	func testPasteboardMonitorWritesToPasteboard() throws {
		// Given
		let mockPasteboardItem = NSPasteboardItem()
		mockPasteboardItem.setString("string", forType: .string)

		let mockPasteboard = try XCTUnwrap(self.mockPasteboard)
		let mockPasteboardMonitor = PasteboardMonitor(for: mockPasteboard, logger: OSLog.default)

		// When
		mockPasteboard.clearContents()
		mockPasteboard.writeObjects([mockPasteboardItem])
		mockPasteboardMonitor.checkPasteboard(mockPasteboard)

		// Then
		let firstPasteboardItem = try XCTUnwrap(mockPasteboard.pasteboardItems?.first)
		XCTAssertEqual(firstPasteboardItem.string(forType: .string), "string")
	}

	func testPasteboardMonitorDoesNothingIfInternalChangeCountAndPasteboardChangeCountEqual() throws {
		// Given
		let mockPasteboardItem = NSPasteboardItem()
		mockPasteboardItem.setString("string", forType: .string)

		let mockPasteboard = try XCTUnwrap(self.mockPasteboard)
		mockPasteboard.clearContents()
		mockPasteboard.writeObjects([mockPasteboardItem])

		let mockPasteboardMonitor = PasteboardMonitor(for: mockPasteboard, logger: OSLog.default)

		// When
		mockPasteboardMonitor.checkPasteboard(mockPasteboard)

		// Then
		let firstPasteboardItem = try XCTUnwrap(mockPasteboard.pasteboardItems?.first)
		XCTAssertEqual(firstPasteboardItem, mockPasteboardItem)
	}
}
