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
    @Published var showDialog = false
    @Published var timerIsRunning = true
    @Published var currentAttempt = 0
    
    private var timer: Timer?
        
        init() {
            startTimer()
        }
        
        // Start the timer that updates the number every 5 seconds
        func startTimer() {
            timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
                //self.updateNumber()
            }
        }
    
    // Update number every 5 seconds
        func updateNumber() {
            currentNumber = Int.random(in: 1...100)
            currentAttempt += 1
            
            // If the user hasn't selected, mark it as wrong
            if currentAttempt % 10 == 0 {
                showDialog = true
            }
        }
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
