//
//  DisclosureGroupTests.swift
//  ViewInspectorTests
//
//  Created by Sayam Patel on 8/3/20.
//

import XCTest
import SwiftUI
@testable import ViewInspector

@available(iOS 14.0, macOS 11.0, *)
final class DisclosureGroupTests: XCTestCase {

    func testWithSingleContentAndLabel() throws {
        let sampleView = DisclosureGroup(content: {
            Text("Content Text 123")
        }, label: {
            Text("Label Text 456")
        })
        
        let contentText = try sampleView.inspect().disclosureGroup().text(0).string()
        XCTAssertEqual(contentText, "Content Text 123")
        
        let labelText = try sampleView.inspect().disclosureGroup().label().text().string()
        
        XCTAssertEqual(labelText, "Label Text 456")
    }

}
