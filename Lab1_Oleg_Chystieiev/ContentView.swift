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
                self.updateNumber()
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
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    viewModel.userSelectedPrime(isPrimeSelection: false)
                }) {
                    Text("Not Prime")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
            
            // Show the correct/incorrect feedback
            if viewModel.correctAnswers + viewModel.wrongAnswers > 0 {
            if viewModel.correctAnswers + viewModel.wrongAnswers % 10 == 0 {
                    Text("You got \(viewModel.correctAnswers) correct and \(viewModel.wrongAnswers) wrong answers")
                    .padding()
                    .foregroundColor(.blue)
                }
            }
            
            Spacer()
            
            // Show the tick/cross icons after selection
            if viewModel.correctAnswers > 0 {
                Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.system(size: 30))
            } else if viewModel.wrongAnswers > 0 {
                Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                        .font(.system(size: 30))
            }
                        
            Spacer()
            
            // Dialog after every 10 attempts
            if viewModel.showDialog {
                    VStack {
                        Text("You got \(viewModel.correctAnswers) correct and \(viewModel.wrongAnswers) wrong")
                    Button("Close") {
                            viewModel.showDialog = false
                            }
                    Button("Reset") {
                            viewModel.resetGame()
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 10)
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
