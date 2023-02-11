//
//  ButtonPress.swift
//  GitHub_Finder_Composable
//
//  Created by Артем Калинкин on 17.12.2022.
//

import SwiftUI


struct ButtonPress: ViewModifier {
    typealias DragGetstureClosure = (DragGesture.Value) -> Void

    var onPress: DragGetstureClosure
    var onEnded: DragGetstureClosure

    func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged(onPress)
                    .onEnded(onEnded)
            )
    }
}

extension View {
    func animationEvents(
        onPress: @escaping () -> Void,
        onEnded: @escaping () -> Void
    ) -> some View {
        modifier(
            ButtonPress(
                onPress: {_ in withAnimation { onPress() }},
                onEnded: { _ in withAnimation { onEnded() }}
            )
        )
    }

    func navigate<NewView: View>(to view: NewView, when binding: Binding<Bool>) -> some View {
        NavigationView {
            ZStack {
                self
                    .navigationTitle("")
                    .navigationBarHidden(true)

                NavigationLink(
                    destination: view
                        .navigationTitle("")
                        .navigationBarHidden(true),
                    isActive: binding
                ) { EmptyView()}
            }
        }
        .navigationViewStyle(.stack)
    }
}

