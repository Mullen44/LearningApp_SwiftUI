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
            
            // Next Lesson Button
            // Show only if it has a next lesson
            if model.hasNextLesson() {
                Button {
                    
                    // Advance to the next lesson
                    model.nextLesson()
                    
                } label: {
                    ZStack {
                        Rectangle()
                            .frame(height:48)
                            .foregroundColor(Color.green)
                            .cornerRadius(10)
                            .shadow(radius: 5)

                        Text("Next Lesson: \(model.currentModule!.content.lessons[model.currentLessonIndex + 1].title)")
                            .foregroundColor(.white)
                            .bold()
                    }
                }
            }
        }
        .padding(.horizontal, 20)
    }
}

