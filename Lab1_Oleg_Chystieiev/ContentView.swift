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
    @Published var currentAttempt = 0
    @Published var lastSelection: Bool? = nil // Keeps track of the last selection (Prime/Not Prime)
    
    private var timer: Timer?
    
    init() {
        startTimer()
    }
    
    // Start the timer that updates the number every 5 seconds
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            self.updateNumber()
        }
    }
    
    // Update number every 5 seconds
    func updateNumber() {
        currentNumber = Int.random(in: 1...100)
        currentAttempt += 1
        lastSelection = nil // Reset the selection state to hide the tick/cross icons
        
        // Show the dialog after every 10 attempts
        if currentAttempt % 10 == 0 {
            showDialog = true
        }
    }
    
    // Check if the number is prime
    func isPrime(_ number: Int) -> Bool {
        guard number > 1 else { return false }
        for i in 2..<number {
            if number % i == 0 {
                return false
            }
        }
        return true
    }
    
    // Handle the user's choice of Prime or Not Prime
    func userSelectedPrime(isPrimeSelection: Bool) {
        // Determine if the current number is prime
        let correctAnswer = isPrime(currentNumber)
        
        // If the user's selection matches the correct answer, increase the correct count, otherwise increase the wrong count
        if correctAnswer == isPrimeSelection {
            correctAnswers += 1
            lastSelection = true
        } else {
            wrongAnswers += 1
            lastSelection = false
        }
    
    }
    
    // Reset the game statistics
    func resetGame() {
        correctAnswers = 0
        wrongAnswers = 0
        currentAttempt = 0
        showDialog = false
    }
}

// Main View
struct ContentView: View {
    @StateObject var viewModel = PrimeGameViewModel()

    var body: some View {
        VStack {
            Spacer()
            
            // Display the current number
            Text("\(viewModel.currentNumber)")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            Spacer()
            
            HStack {
                Button(action: {
                    viewModel.userSelectedPrime(isPrimeSelection: true)
                }) {
                    Text("Prime")
                        .font(.title2)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .frame(minWidth: 100, minHeight: 50)
                }
                
                Button(action: {
                    viewModel.userSelectedPrime(isPrimeSelection: false)
                }) {
                    Text("Not Prime")
                        .font(.title2)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .frame(minWidth: 100, minHeight: 50)
                }
            }
            .padding()

            // Show the correct/incorrect feedback
            if let lastSelection = viewModel.lastSelection {
                if lastSelection {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.system(size: 30))
                } else {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                        .font(.system(size: 30))
                }
            }

            Spacer()

            // Dialog after every 10 attempts
            if viewModel.showDialog {
                VStack {
                    Text("You got \(viewModel.correctAnswers) correct and \(viewModel.wrongAnswers) wrong answers")
                        .font(.title2)
                        .padding(.bottom, 20)
                    HStack {
                        Button("Close") {
                            viewModel.showDialog = false
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .frame(minWidth: 100, minHeight: 50)
                        
                        Button("Reset") {
                            viewModel.resetGame()
                        }
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .frame(minWidth: 100, minHeight: 50)
                    }
                    .padding(.horizontal, 20)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .shadow(radius: 10)
                .padding()
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
