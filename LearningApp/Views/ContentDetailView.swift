//
//  ContentDetailView.swift
//  LearningApp
//
//  Created by Andrew Mullen on 2021-12-06.
//

import SwiftUI
import AVKit

struct ContentDetailView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        
        let lesson = model.currentLesson
        let url = URL(string: Constants.videoHostUrl + (lesson?.video ?? ""))
        
        VStack {
            if url != nil {
                // Only show video if we get a valid URL
                VideoPlayer(player: AVPlayer(url: url!))
                    .cornerRadius(10)
            }
            // TODO: Description
            
            CodeTextView()
            
            // Next Lesson Button
            // Show only if it has a next lesson
            if model.hasNextLesson() {
                Button {
                    
                    // Advance to the next lesson
                    model.nextLesson()
                    
                } label: {
                    ZStack {
                        RectangleCard(color: Color.green)
                            .frame(height:48)

                        Text("Next Lesson: \(model.currentModule!.content.lessons[model.currentLessonIndex + 1].title)")
                            .foregroundColor(.white)
                            .bold()
                    }
                }
            }
            else {
                // Show Complete button
                Button {
                    
                    // take user back to the home view
                    model.currentContentSelected = nil
                    
                } label: {
                    ZStack {
                        RectangleCard(color: Color.green)
                            .frame(height:48)

                        Text("Complete")
                            .foregroundColor(.white)
                            .bold()
                    }
                }
                
            }
        }
        .padding(.horizontal, 20)
        .navigationBarTitle(lesson?.title ?? "")
    }
}

