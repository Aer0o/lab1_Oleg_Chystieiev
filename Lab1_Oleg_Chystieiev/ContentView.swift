//
//  ContentView.swift
//  Lab1_Oleg_Chystieiev
//
//  Created by Oleg Chystieiev on 2025-02-11.
//

import SwiftUI

// ViewModel to handle logic and state
class PrimeGameViewModel: ObservableObject {
    @Published var currentNumber = Int.random(in: 1...100)
    @Published var correctAnswers = 0
    @Published var wrongAnswers = 0
}

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
