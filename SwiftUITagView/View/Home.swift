//
//  Home.swift
//  SwiftUITagView
//
//  Created by 김정민 on 6/30/25.
//

import SwiftUI

struct Home: View {
    
    @State var text: String = ""
    
    @State var tags: [Tag] = []
    
    var body: some View {
        VStack {
            Text("Filter\nMenus")
                .font(.system(size: 38, weight: .bold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Custom Tag View
            TagView(maxLimit: 150, tags: $tags)
                .frame(height: 280)
                .padding(.top, 20)
            
            // TextFiled
            TextField("apple", text: $text)
                .font(.title3)
                .padding(.vertical, 12)
                .padding(.horizontal)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(Color.white.opacity(0.2), lineWidth: 1)
                )
                .environment(\.colorScheme, .dark) // Setting only TextField as dark
                .padding(.vertical, 20)
            
            // Add Button
            Button {
                // adding Tag
                tags.append(addTag(text: text, fontSize: 16))
                text = ""
            } label: {
                Text("Add Tag")
                    .fontWeight(.semibold)
                    .foregroundStyle(.gray)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 45)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .disabled(text == "")
            .opacity(text == "" ? 0.6 : 1)
            
        }
        .padding(15)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Color.blue
                .ignoresSafeArea()
        )
        
    }
}

#Preview {
    Home()
}
