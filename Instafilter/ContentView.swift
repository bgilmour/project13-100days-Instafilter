//
//  ContentView.swift
//  Instafilter
//
//  Created by Bruce Gilmour on 2021-07-26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ActionSheetView()
    }
}

struct ActionSheetView: View {
    @State private var showingActionSheet = false
    @State private var backgroundColor = Color.white

    var body: some View {
        Text("Hello, world!")
            .font(.largeTitle)
            .frame(width: 300, height: 300)
            .background(backgroundColor)
            .onTapGesture {
                showingActionSheet = true
            }
            .actionSheet(isPresented: $showingActionSheet) {
                ActionSheet(title: Text("Change background"), message: Text("Select a new color"), buttons: [
                    .default(Text("Red")) { backgroundColor = .red },
                    .default(Text("Green")) { backgroundColor = .green },
                    .default(Text("Blue")) { backgroundColor = .blue },
                    .cancel()
                ])
            }
    }
}

struct BlurTextView: View {
    @State private var blurAmount: CGFloat = 0

    var body: some View {
        let blur = Binding<CGFloat>(
            get: {
                blurAmount
            },
            set: {
                blurAmount = $0
                print("New value is \(blurAmount)")
            }
        )

        VStack {
            Text("Hello, world!")
                .font(.largeTitle)
                .blur(radius: blurAmount)

            Slider(value: blur, in: 0 ... 20)
                .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
