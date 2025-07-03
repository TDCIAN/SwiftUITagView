//
//  TagView.swift
//  SwiftUITagView
//
//  Created by 김정민 on 6/30/25.
//

import SwiftUI

struct TagView: View {
    
    var maxLimit: Int
    
    @Binding var tags: [Tag]
    
    var title: String = "Add Some Tags"
    
    var fontSize: CGFloat = 16
    
    // Adding Geometry Effect to Tag
    @Namespace var animation
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 15) {
            
            Text(title)
                .font(.callout)
                .foregroundStyle(Color.white)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 10) {
                    // Displaying tags
                    ForEach(getRows(), id: \.self) { rows in
                        HStack(spacing: 6) {
                            ForEach(rows) { row in
                                RowView(tag: row)
                            }
                        }
                    }
                }
                .frame(width: UIScreen.main.bounds.width - 80, alignment: .leading)
                .padding(.vertical)
                .padding(.bottom, 20)
            }
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(Color.gray.opacity(1), lineWidth: 1)
            )
            .overlay(
                Text("\(getSize(tags: tags))/\(maxLimit)")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.white)
                    .padding(12),
                alignment: .bottomTrailing
            )
            .animation(.easeInOut, value: tags)
        }
        .onChange(of: tags) { oldValue, newValue in
            // getting newly inserted value
            guard let last = tags.last else { return }
            
            // getting text size
            let font = UIFont.systemFont(ofSize: fontSize)
            
            let attributes = [NSAttributedString.Key.font: font]
            
            let size = (last.text as NSString).size(withAttributes: attributes)
            
            print("### size: \(size)")
            // Updating size
            tags[getIndex(tag: last)].size = size.width
        }
        
    }
    
    @ViewBuilder
    func RowView(tag: Tag) -> some View {
        Text(tag.text)
            .font(.system(size: 14, weight: .bold))
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(Color.white)
            )
            .foregroundStyle(Color.primary)
            .lineLimit(1)
            .contentShape(Capsule())
            .contextMenu {
                Button("Delete") {
                    tags.remove(at: getIndex(tag: tag))
                }
            }
            .matchedGeometryEffect(id: tag.id, in: animation)
    }
    
    private func getIndex(tag: Tag) -> Int {
        let index = tags.firstIndex { currentTag in
            return tag.id == currentTag.id
        } ?? 0
        
        return index
    }
    
    // Splitting the array when it exceeds the screen size
    private func getRows() -> [[Tag]] {
        var rows: [[Tag]] = []
        var currentRow: [Tag] = []
        
        // calculating text width
        var totalWidth: CGFloat = 0
        
        // For safety extra 10
        let screenWidth: CGFloat = UIScreen.main.bounds.width - 90
        
        tags.forEach { tag in
            // updating total width
            
            // adding the capsule size into total width with spacing
            // 14 + 14 + 6 + 6
            // extra 6 for safety
            totalWidth += (tag.size + 40)
            
            // checking if totalWidth is greater than size
            if totalWidth > screenWidth {
                // adding row in rows
                // clearing the data
                // checking for long string
                totalWidth = (!currentRow.isEmpty || rows.isEmpty ? (tag.size + 40) : 0)
                
                rows.append(currentRow)
                currentRow.removeAll()
                currentRow.append(tag)
            } else {
                currentRow.append(tag)
            }
        }
        
        // Safe check
        // If having any value storing it in rows
        if !currentRow.isEmpty {
            rows.append(currentRow)
            currentRow.removeAll()
        }
        
        return rows
    }

}

func addTag(tags: [Tag], text: String, fontSize: CGFloat, maxLimit: Int, completion: @escaping (Bool, Tag) -> ()) {

    // getting text size
    let font = UIFont.systemFont(ofSize: fontSize)
    
    let attributes = [NSAttributedString.Key.font: font]
    
    let size = (text as NSString).size(withAttributes: attributes)
    
    let tag = Tag(text: text, size: size.width)
    
    if (getSize(tags: tags) + text.count) <= maxLimit {
        completion(false, tag)
    } else {
        completion(true, tag)
    }
}

func getSize(tags: [Tag]) -> Int {
    var count: Int = 0
    
    tags.forEach { tag in
        count += tag.text.count
    }
    
    return count
}

#Preview {
    ContentView()
}
