//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Guadoo on 2021/5/7.
//

import SwiftUI


struct FlagImage: View {
    
    let countries: [String]
    let number: Int

    var body: some View {
        Image(self.countries[number])
            .renderingMode(.original)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.white, lineWidth: 0.5))
            .shadow(color: .black, radius: 10)
    }
    
    init(countries: [String], number: Int) {
        self.countries = countries
        self.number = number
    }
}

struct ContentView: View{
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var userScore = 0
    
    @State private var animationRotation = 0.0
    @State private var animationZoom: CGFloat = 1
    
    @State private var isOpacity = false
    @State private var animationOpacity = 1.0
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.blue]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)

            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                
                ForEach(0 ..< 3) { number in
                    Button(action: {
                        // flag was tapped
                        self.flagTapped(number)
                
                        if number == correctAnswer {
                            withAnimation(.interpolatingSpring(stiffness: 1, damping: 2)){
                                self.animationRotation += 360
                            }
                        } else {
                            withAnimation(.easeInOut) {
                                self.animationZoom = 1.4
                            }
                        }
                    }, label: {
//------------------------------------------------------------------------------------
// Use standard Image view
//------------------------------------------------------------------------------------
//                        Image(self.countries[number])
//                            .renderingMode(.original)
//                            .clipShape(Capsule())
//                            .overlay(Capsule().stroke(Color.white, lineWidth: 0.5))
//                            .shadow(color: .black, radius: 10)
                        
                        FlagImage(countries: countries, number: number)
                        
                    })
                    .opacity(animationOpacity)
                    .rotation3DEffect(.degrees( number == correctAnswer ? animationRotation : 0), axis: (x: 0.0, y: 1.0, z: 0.0))
                    .scaleEffect(number == correctAnswer ? animationZoom : 1)
                    .alert(isPresented: $showingScore, content: {
                        Alert(title: Text(scoreTitle), message: Text("Your score is \(userScore)"), dismissButton: .default(Text("Continue"), action: {
                            self.askQuestion()
                        }))
                    })
                }
                
                Text("Your Current Score is \(userScore)")
                    .foregroundColor(.white)
                
                Button(isOpacity ? "Opacity 0.25" : "Opacity 1.0") {

                    isOpacity = !isOpacity
                    
                    withAnimation {
                        animationOpacity = {isOpacity ? 0.25 : 1.0}()
                    }
                }
                .padding()
                .background(Color.black)
                .foregroundColor(.white)
                .clipShape(Capsule())
                
                Spacer()
            }
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            userScore += 1
        } else {
            let flagCountry = countries[number]
            scoreTitle = "Wrong! That's the flag of \(flagCountry)"
            userScore -= 1
        }
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        animationZoom = 1
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
