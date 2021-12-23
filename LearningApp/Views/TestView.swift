//
//  TestView.swift
//  LearningApp
//
//  Created by Andrew Mullen on 2021-12-22.
//

import SwiftUI
import CoreMedia

struct TestView: View {
    
    @EnvironmentObject var model: ContentModel
    @State var selectedAnswerIndex:Int?
    @State var submitted = false
    
    @State var numCorrect = 0
    
    var body: some View {
        
        
        if model.currentQuestion != nil {
            
            VStack(alignment: .leading) {
                // Questiuon number
                Text("Question \(model.currentQuestionIndex + 1) of \(model.currentModule?.test.questions.count ?? 0)")
                    .padding(.leading, 20)
                
                // Question
                CodeTextView()
                    .padding(.horizontal, 20)
                
                // Answers
                ScrollView {
                    VStack {
                        ForEach(0..<model.currentQuestion!.answers.count, id: \.self) { index in
                            
                            
                            Button{
                                // TODO
                                // Track the selected index
                                selectedAnswerIndex = index
                                
                            } label: {
                                ZStack {
                                    // If the user has not submitted
                                    if submitted == false {
                                        RectangleCard(color: index == selectedAnswerIndex ? .gray : .white)
                                            .frame(height: 48)
                                    }
                                    else {
                                        // Answer has been submitted
                                        if index == selectedAnswerIndex && index == model.currentQuestion!.correctIndex || index == model.currentQuestion!.correctIndex {
                                            // User has selected the right answer
                                            RectangleCard(color: .green)
                                                .frame(height: 48)
                                        }
                                        else if index == selectedAnswerIndex && index != model.currentQuestion!.correctIndex {
                                            // User has selected the wrong answer
                                            // Show red background
                                            RectangleCard(color: .red)
                                                .frame(height: 48)
                                        }
                                        else {
                                            RectangleCard()
                                                .frame(height:48)
                                        }
                                    }// End if else
                                    Text(model.currentQuestion!.answers[index])
                                }// ZStack
                            }// Button Label
                            .disabled(submitted)
                            
                        } // ForEach Loop
                    }.padding()
                        .accentColor(.black)
                }// Scroll View
                
                // Submit Answer Button
                Button {
                    // Check if answer is submitted
                    if submitted == true {
                        // Answer has already been submitted, move to next question
                        model.nextQuestion()
                        
                        // Reset properties
                        submitted = false
                        selectedAnswerIndex = nil
                    }
                    else {
                        // Change submitted state to true
                        submitted = true
                        // Check the answer and keep track
                        if selectedAnswerIndex == model.currentQuestion!.correctIndex {
                            numCorrect += 1
                        }
                    }
                } label: {
                    ZStack {
                        RectangleCard(color: .green)
                            .frame(height: 48)
                        Text(buttonText)
                            .bold()
                            .foregroundColor(.white)
                    }
                    .padding()
                }
                .disabled(selectedAnswerIndex == nil)

            }// VStack
            .navigationBarTitle("\(model.currentModule?.category ?? "") Test")
        }
        else {
            // If current question is nil show the result view
            TestResultView(numCorrect: numCorrect)
        }
    }
    
    var buttonText: String {
        // Check if answer has been submitted
        if submitted == true {
            if model.currentQuestionIndex + 1 == model.currentModule!.test.questions.count {
                // Then this is the last question
                return "Finish"
            }
            else {
                // There is another question
                return "Next" // Or finished
            }
        }
        else {
            return "Submit"
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
