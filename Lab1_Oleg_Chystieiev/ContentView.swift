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
    @Published var lastSelection: Bool? = nil
    @Published var isButtonDisabled: Bool = false
    @Published var elapsedTime = 0
    
    private var timer: Timer?
    
    init() {
        startTimer()
    }
    
    // Start the timer that updates the number every 5 seconds
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            self.updateNumber()
        }
        
        // Timer to update elapsed time every 1 second
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.elapsedTime += 1
        }
    }
    
    // Update number every 5 seconds
    func updateNumber() {
        currentNumber = Int.random(in: 1...100)
        currentAttempt += 1
        lastSelection = nil
        isButtonDisabled = false
        elapsedTime = 0
        
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
        
        isButtonDisabled = true
    
    }
    
    // Reset the game statistics
    func resetGame() {
        correctAnswers = 0
        wrongAnswers = 0
        currentAttempt = 0
        showDialog = false
        elapsedTime = 0
    }
}

// Main View
struct ContentView: View {
    @StateObject var viewModel = PrimeGameViewModel()

    var body: some View {
        VStack {
            Spacer()
            
            // Add the timer in the top right corner
            HStack {
                Spacer()
                Text("\(formatElapsedTime(viewModel.elapsedTime))")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding(.top, 20)
                        .padding(.trailing, 20)
                }
                        
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
                .disabled(viewModel.isButtonDisabled)
                
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
                .disabled(viewModel.isButtonDisabled)
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
    
    // Helper function to format elapsed time
    func formatElapsedTime(_ time: Int) -> String {
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
