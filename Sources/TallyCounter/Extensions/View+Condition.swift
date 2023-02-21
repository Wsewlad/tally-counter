//
//  View+Condition.swift
//  
//
//  Created by  Vladyslav Fil on 21.02.2023.
//

import SwiftUI

public extension View {
    @ViewBuilder
    func `if`<Transform: View>(_ condition: Bool, transform: (Self) -> Transform) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }

    @ViewBuilder
    func `if`<Transform: View>(_ condition: () -> Bool, transform: (Self) -> Transform) -> some View {
        if condition() {
            transform(self)
        } else {
            self
        }
    }
    
    @ViewBuilder
    func `if`<TransformIf: View, TransformElse: View>(
        _ condition: Bool,
        transform: (Self) -> TransformIf,
        else elseTransform: (Self) -> TransformElse
    ) -> some View {
        if condition {
            transform(self)
        } else {
            elseTransform(self)
        }
    }

    @ViewBuilder
    func `if`<TransformIf: View, TransformElse: View>(
        _ condition: () -> Bool,
        transform: (Self) -> TransformIf,
        else elseTransform: (Self) -> TransformElse
    ) -> some View {
        if condition() {
            transform(self)
        } else {
            elseTransform(self)
        }
    }
}
