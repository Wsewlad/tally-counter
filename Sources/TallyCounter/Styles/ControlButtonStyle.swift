//
//  ControlButtonStyle.swift
//  Tally Counter
//
//  Created by  Vladyslav Fil on 30.09.2021.
//

import SwiftUI

struct ControlButtonStyle: ButtonStyle {
    var config: TallyCounter.Configuration
    
    var systemName: String
    var size: CGFloat
    var padding: CGFloat
    
    init(systemName: String, size: CGFloat, config: TallyCounter.Configuration) {
        self.systemName = systemName
        self.size = size
        self.padding = size / 3.5
        self.config = config
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .overlay(
                ZStack {
                    Circle()
                        .fill(config.controlsOnTapCircleColor)
                    
                    Image(systemName: systemName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(padding)
                        .foregroundColor(config.controlsBackgroundColor)
                }
                .frame(width: size, height: size)
                .opacity(configuration.isPressed ? 1 : 0)
                .animation(.linear(duration: 0.1))
            )
            .font(.system(size: 60, weight: .thin, design: .rounded))
        }
}
