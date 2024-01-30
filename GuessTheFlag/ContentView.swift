//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Lexter Tapawan on 17/01/2024.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - PROPERTIES
    
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var userScore: Int = 0
    @State private var showingScore = false
    @State private var showingResults = false
    @State private var scoreTitle = ""
    @State private var questionCounter = 1
    @State private var countries = allCountries.shuffled()
    @State private var highscore: Int = UserDefaults.standard.integer(forKey: "HighScore")
    @State private var selectedFlag = -1
    
    static let allCountries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    
    // MARK: - METHODS
    
    func flagTapped(_ number: Int) {
        selectedFlag = number
        
        if number == correctAnswer {
            scoreTitle = "Correct!"
            userScore += 1
            
        } else {
            let needsThe = ["UK", "US"]
            let theirAnswer = countries[number]
            
            if needsThe.contains(theirAnswer) {
                scoreTitle = "Wrong! You chose the flag of the \(countries[number])"
            } else {
                scoreTitle = "Wrong! You chose the flag of \(countries[number])"
            }
        }
        if questionCounter == 8 {
            showingResults = true
        } else {
            showingScore = true
        }
    }
    
    func askQuestion() {
        countries.remove(at: correctAnswer)
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        questionCounter += 1
        selectedFlag = -1
    }
    
    func newGame() {
        questionCounter = 0
        userScore = 0
        countries = Self.allCountries
        askQuestion()
    }
    
    func newHighScore() {
        highscore = userScore
        UserDefaults.standard.set(highscore, forKey: "HighScore")
    }
    
    //func executeDelete() {
    //    print("Deleted!!")
    //}
    
    // MARK: - BODY
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 400)
            .ignoresSafeArea()
            VStack {
                Spacer()
                Text("Guess The Flag")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline)
                            .fontWeight(.heavy)
                        Text(countries[correctAnswer])
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            FlagImage(name: countries[number])
                        }
                        .rotation3DEffect(
                            .degrees(selectedFlag == number ? 360 : 0), axis: (x: 0.0, y: 1.0, z: 0.0))
                        .blur(radius: selectedFlag == -1 || selectedFlag == number ? 0 : 3)
                        //.saturation(selectedFlag == -1 || selectedFlag == number ? 1 : 0)
                        //.scaleEffect(selectedFlag == -1 || selectedFlag == number ? 1.0 : 0.25)
                        //.opacity(selectedFlag == -1 || selectedFlag == number ? 1.0 : 0.25)
                        
                        .animation(.default, value: selectedFlag)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                Spacer()
                Spacer()
                HStack {
                    Text("Score: \(userScore)")
                        .foregroundStyle(.white)
                        .font(.title2.bold())
                    Spacer()
                    //                    Text("High Score: \(highscore)")
                    //                        .foregroundStyle(.white)
                    //                    .font(.title2.bold())
                }
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        }
        .alert("Game Over", isPresented: $showingResults) {
            Button("Start Again", action: newGame)
        } message: {
            Text("You final score was \(userScore)")
        }
    }
    
    // MARK: - BUTTONS AND ALERTS SAMPLES
    //        Button("Show Alert") {
    //            showingAlert = true
    //        }
    //        //        .alert("Important Message", isPresented: $showingAlert) {
    //        //            Button("Delete", role: .destructive) {}
    //        //            Button("Cancel", role: .cancel) {}
    //        .alert("Important Message", isPresented: $showingAlert) {
    //            Button("OK", role: .destructive) {}
    //            Button("Cancel", role: .cancel) {}
    //        } message: {
    //            Text("Please read this.")
    //        }
    
    // MARK: - BUTTON STYLE SAMPLES
    //        VStack {
    //            Button("Button 1") {}
    //                .buttonStyle(.bordered)
    //            Button("Button 2", role: .destructive) {}
    //                .buttonStyle(.bordered)
    //            Button("Button 3") {}
    //                .buttonStyle(.borderedProminent)
    //                .tint(.mint)
    //            Button("Button 4", role: .destructive) {}
    //                .buttonStyle(.borderedProminent)
    //            Button {
    //                print("Button 4 was tapped!")
    //            } label: {
    //                Image(systemName: "pencil")
    //            }
    //            .padding()
    //            Button("Edit", systemImage: "pencil") {
    //                print("Edit button tapped")
    //            }
    //            .padding()
    //            Button {
    //                print("Edit button tapped")
    //            } label: {
    //                Label("Edit", image: "pencil")
    //                    .padding()
    //                    .foregroundStyle(.white)
    //                    .background(.red)
    //            }
    //        }
}

// MARK: - PREVIEW

#Preview {
    ContentView()
}
