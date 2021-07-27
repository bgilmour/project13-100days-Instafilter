//
//  ContentView.swift
//  Instafilter
//
//  Created by Bruce Gilmour on 2021-07-26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        BlurTextView()
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
