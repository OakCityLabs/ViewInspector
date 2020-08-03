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
struct DisclosureGroupWithBinding: View {
    @Binding var isExpanded: Bool
    
    var body: some View {
        DisclosureGroup(isExpanded: $isExpanded, content: {
            Text("I will be hidden if this is false -> (\($isExpanded.wrappedValue.description))")
        }, label: {
            Button("Tap the arrow to expand!") {
                isExpanded = true
            }
        })
    }
}

@available(iOS 14.0, macOS 11.0, *)
extension DisclosureGroupWithBinding: Inspectable { }

@available(iOS 14.0, macOS 11.0, *)
final class DisclosureGroupTests: XCTestCase {
    
    func testWithSingleContentAndLabel() throws {
        let sampleDisclosure = DisclosureGroup(content: {
            Text("Content Text 123")
        }, label: {
            Text("Label Text 456")
        })
        
        print(sampleDisclosure)
        let contentText = try sampleDisclosure.inspect().disclosureGroup().text(0).string()
        XCTAssertEqual(contentText, "Content Text 123")
        
        let labelText = try sampleDisclosure.inspect().disclosureGroup().label().text().string()
        
        XCTAssertEqual(labelText, "Label Text 456")
    }
    
    func testWithVStackAsContent() throws {
        let sampleDisclosure = DisclosureGroup(content: {
            VStack {
                Text("First Entry")
                Text("Entry #2")
                Text("To Infinity And Beyond")
            }
        }, label: {
            Text("Disclose me!")
        })
        
        let contentVStack = try sampleDisclosure.inspect().disclosureGroup().vStack(0)
        
        XCTAssertEqual(contentVStack.count, 3)
        
        let text1 = try contentVStack.text(0).string()
        let text2 = try contentVStack.text(1).string()
        let text3 = try contentVStack.text(2).string()
        
        XCTAssertEqual(text1, "First Entry")
        XCTAssertEqual(text2, "Entry #2")
        XCTAssertEqual(text3, "To Infinity And Beyond")
    }
    
    ///testing the isExpanded flag
    /// Can't actually test right now if the content is visible/expanded
    /// testing if the flag binding changes
    func testExpansion() {
        let isExpanded = Binding<Bool>(wrappedValue: false)
        let contentWasShown = Binding<Bool>(wrappedValue: false)
            
        let disclosureView = DisclosureGroupWithBinding(isExpanded: isExpanded)
        XCTAssertFalse(disclosureView.isExpanded)
        
        //expanding with button
        try? disclosureView.inspect().disclosureGroup().label().button().tap()
        
        XCTAssertTrue(isExpanded.wrappedValue)
        
    }
    
    func testExtractionFromSingleViewContainer() throws {
        let sampleDisclosure = DisclosureGroup(content: {
            VStack {
                Text("First Entry")
                Text("Entry #2")
                Text("To Infinity And Beyond")
            }
        }, label: {
            Text("Disclose me!")
        })
        
        let view = AnyView(sampleDisclosure)
        XCTAssertNoThrow(try view.inspect().anyView().disclosureGroup())
    }
    
    func testExtractionFromMultipleViewContainer() throws {
        let sampleDisclosure = DisclosureGroup(content: {
            VStack {
                Text("First Entry")
                Text("Entry #2")
                Text("To Infinity And Beyond")
            }
        }, label: {
            Text("Disclose me!")
        })
        let view = VStack { sampleDisclosure; sampleDisclosure }
        XCTAssertNoThrow(try view.inspect().vStack().disclosureGroup(0))
        XCTAssertNoThrow(try view.inspect().vStack().disclosureGroup(1))
    }
    
}
