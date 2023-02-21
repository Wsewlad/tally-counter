//
//  Configuration.swift
//  
//
//  Created by  Vladyslav Fil on 22.02.2023.
//

import SwiftUI

//MARK: - ConfigurationStore
final class ConfigurationStore: ObservableObject {
    @Published var config: TallyCounter.Configuration
    
    init(config: TallyCounter.Configuration) {
        self.config = config
    }
}

//MARK: - Configuration
public extension TallyCounter {
    struct Configuration {
        var minValue: Int
        var maxValue: Int
        var controlsContainerWidth: CGFloat
        var showAmountLabel: Bool
        var controlsColor: Color
        var labelBackgroundColor: Color
        var controlsBackgroundColor: Color
        var controlsOnTapCircleColor: Color
        var controlsBackgroundOverlayColor: Color
        
        public init(
            minValue: Int = 0,
            maxValue: Int = 999,
            controlsContainerWidth: CGFloat = 300,
            showAmountLabel: Bool = true,
            controlsColor: Color = .white,
            labelBackgroundColor: Color = .labelBackground,
            controlsBackgroundColor: Color = .controlsBackground,
            controlsOnTapCircleColor: Color = .white,
            controlsBackgroundOverlayColor: Color = .black
        ) {
            self.minValue = minValue
            self.maxValue = maxValue
            self.controlsContainerWidth = controlsContainerWidth
            self.showAmountLabel = showAmountLabel
            self.controlsColor = controlsColor
            self.labelBackgroundColor = labelBackgroundColor
            self.controlsBackgroundColor = controlsBackgroundColor
            self.controlsOnTapCircleColor = controlsOnTapCircleColor
            self.controlsBackgroundOverlayColor = controlsBackgroundOverlayColor
        }
    }

}
