//
//  FloatingButtonView.swift
//  Utils
//
//  Created by Israel Manzo on 4/9/25.
//

import SwiftUI

struct FloatingButtonView: View {
    var body: some View {
        FloatingButtonUtilsView()
    }
}

#Preview {
    FloatingButtonView()
}

public struct FloatingButtonUtilsView: View {
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
                            .background(Color.pink)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                    .padding()
                }
            }
        }
    }
}
