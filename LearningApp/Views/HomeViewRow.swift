//
//  ContentView.swift
//  LearningApp
//
//  Created by Andrew Mullen on 2021-12-06.
//

import SwiftUI

struct HomeViewRow: View {
    
    var image:String
    var title:String
    var description:String
    var count:String
    var time:String
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .aspectRatio(CGSize(width: 335, height: 175), contentMode: .fit)
            
            
            HStack {
                Image(image)
                    .resizable()
                    .frame(width: 116, height: 116)
                    .clipShape(Circle())
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 10) {
                    // Headling
                    Text(title)
                        .bold()
                    // Description
                    Text(description)
                        .padding(.bottom, 20)
                        .font(.caption)
                        .multilineTextAlignment(.leading)
                    
                    // Icon
                    HStack {
                        // Number of Lessons / Questions
                        Image(systemName: "text.book.closed")
                            .resizable()
                            .frame(width: 15, height: 15)
                        Text(count)
                            .font(Font.system(size: 10))
                        
                        Spacer()
                        
                        // Time
                        Image(systemName: "clock")
                            .resizable()
                            .frame(width: 15, height: 15)
                        Text(time)
                            .font(Font.system(size: 10))
                    }// End HStack
                }// End VStack
                .padding(.leading, 20)
            }// End Learning Card HStack
            .padding(.horizontal, 20)
        }// End Learning Card ZStack
    }
}

struct HomeViewRow_Previews: PreviewProvider {
    static var previews: some View {
        HomeViewRow(image: "swift", title: "Learn Swift", description: "some description", count: "20 Lessons", time: "2 hours")
    }
}
