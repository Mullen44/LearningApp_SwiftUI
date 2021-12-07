//
//  ContentView.swift
//  LearningApp
//
//  Created by Andrew Mullen on 2021-12-06.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        ScrollView {
            LazyVStack {
                // Confirm that current module is set
                if model.currentModule != nil {
                    ForEach(0..<model.currentModule!.content.lessons.count){ index in
                        NavigationLink {
                            ContentDetailView()
                                .onAppear(perform: {
                                    model.beginLesson(index)
                                })
                        } label: {
                            ContentViewRow(index:index)
                        }

                        
                    }
                }

            }
            .padding()
            .navigationTitle("Learn \(model.currentModule?.category ?? "")")
            .accentColor(.black)
            
        }
    }
}

