//
//  DisclosureGroup.swift
//  ViewInspector
//
//  Created by Sayam Patel on 8/2/20.
//

import SwiftUI

public extension ViewType {
    
    struct DisclosureGroup: KnownViewType {
        public static var typePrefix: String = "DisclosureGroup"
    }
}

public extension ViewType.DisclosureGroup {
    struct Label: KnownViewType {
        public static var typePrefix: String = "DisclosureGroup"
    }
}

// MARK: - Content Extraction

extension ViewType.DisclosureGroup: MultipleViewContent {
    public static func children(_ content: Content) throws -> LazyGroup<Content> {
        let content = try Inspector.attribute(label: "content", value: content.view)
        return try Inspector.viewsInContainer(view: content)
    }
}

extension ViewType.DisclosureGroup.Label: SingleViewContent {
    
    public static func child(_ content: Content) throws -> Content {
        let view = try Inspector.attribute(label: "label", value: content.view)
        return try Inspector.unwrap(view: view, modifiers: [])
    }
}

// MARK: - Extraction from SingleViewContent parent

@available(iOS 13.0, macOS 10.15, tvOS 13.0, *)
public extension InspectableView where View: SingleViewContent {
    
    func disclosureGroup() throws -> InspectableView<ViewType.DisclosureGroup> {
        return try .init(try child())
    }
}

// MARK: - Extraction from MultipleViewContent parent

@available(iOS 13.0, macOS 10.15, tvOS 13.0, *)
public extension InspectableView where View: MultipleViewContent {
    
    func disclosureGroup(_ index: Int) throws -> InspectableView<ViewType.DisclosureGroup> {
        return try .init(try child(at: index))
    }
}

// MARK: - Custom Attributes

@available(iOS 13.0, macOS 10.15, tvOS 13.0, *)
public extension InspectableView where View == ViewType.DisclosureGroup {
    
    func label() throws -> InspectableView<ViewType.DisclosureGroup.Label> {
        return try .init(content)
    }
    
    func isExpanded() throws -> Binding<Bool> {
        return try Inspector
            .attribute(label: "_isExpanded",
                                       value: content.view,
                                       type: Binding<Bool>.self)
    }
}
