//
//  ControlButton.swift
//  Tally Counter
//
//  Created by  Vladyslav Fil on 04.10.2021.
//

import SwiftUI

struct ControlButton: View {
    @EnvironmentObject var configurationStore: ConfigurationStore
    
    var config: TallyCounter.Configuration { self.configurationStore.config }
    
    var systemName: String
    var size: CGFloat
    var isActive: Bool
    var opacity: Double
    var action: () -> Void = {}
    
    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(size / 3.5)
                .frame(width: size, height: size)
                .foregroundColor(config.controlsColor.opacity(opacity))
                .background(Color.white.opacity(0.0000001))
                .clipShape(Circle())
        }
        .buttonStyle(
            ControlButtonStyle(
                systemName: systemName,
                size: size,
                config: config
            )
        )
        .contentShape(Circle())
    }
}
