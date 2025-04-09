//
//  FloatingButtonView.swift
//  Utils
//
//  Created by Israel Manzo on 4/9/25.
//

import SwiftUI

struct FloatingButtonView: View {
    var body: some View {
        NavigationView {
            ZStack {
                List(0..<10) { item in
                    NavigationLink {
                        
                    } label: {
                        Text("Item \((item + 1))")
                    }
                }
                FloatingButtonUtilsView()
            }
        }
    }
}

#Preview {
    FloatingButtonView()
}

public struct FloatingButtonUtilsView: View {
    let color: Color = .blue
    public var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        // action
                    } label: {
                        Image(systemName: "plus")
                            .font(.title.weight(.semibold))
                            .padding()
                            .background(color)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                    .padding()
                }
            }
        }
    }
}
