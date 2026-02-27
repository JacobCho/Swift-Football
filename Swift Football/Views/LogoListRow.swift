//
//  LogoListRow.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-01-28.
//

import SwiftUI
import SDWebImageSwiftUI

struct LogoListRow: View {
    var listable: any LogoListable
    
    var body: some View {
        HStack() {
            WebImage(url: URL(string: listable.logo ?? "")) { phase in
                switch phase {
                case .success(let image):
                    image.resizable()
                case .failure(_), .empty:
                    Color.gray
                }
            }
            .indicator(.activity)
            .aspectRatio(contentMode: .fit)
            .frame(width: 40, height: 30)
            
            Text(listable.name ?? "")
                .padding(.leading, 8)
                .fontWeight(.semibold)
            Spacer()
            if let selectable = listable as? Selectable, selectable.isSelected {
                Image(systemName: "checkmark.circle.fill").foregroundStyle(.green)
                    .background(Color(.secondarySystemBackground))
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
        .listRowSeparator(.hidden)
        .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
    }
}
