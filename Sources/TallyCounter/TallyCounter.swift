//
//  CounterView.swift
//  Tally Counter
//
//  Created by  Vladyslav Fil on 23.02.2023.
//

import SwiftUI

public struct TallyCounter: View {
    //MARK: - Private
    private enum Direction {
        case none, left, right, down
    }
    
    @State private var localAmount: Int = 0
    @State private var labelOffset: CGSize = .zero
    @State private var draggingDirection: Direction = .none
    
    //MARK: - Configurable
    @Binding var count: Int
    var bindingAmount: Binding<Int>?
    
    @StateObject private var configurationStore: ConfigurationStore
    
    var config: Configuration { self.configurationStore.config }
    
    public init(
        count: Binding<Int>,
        amount: Binding<Int>? = nil,
        config: Configuration = Configuration()
    ) {
        self._count = count
        self.bindingAmount = amount
        self._configurationStore = .init(wrappedValue: ConfigurationStore(config: config))
    }
    
    public var body: some View {
        let labelDragGesture = DragGesture()
            .onChanged { value in
                findDirection(translation: value.translation)

                var newWidth = value.translation.width * 0.55
                var newHeight = value.translation.height * 0.55
                
                // Set limits
                newWidth = newWidth > labelOffsetXLimit ? labelOffsetXLimit : newWidth
                newWidth = newWidth < -labelOffsetXLimit ? -labelOffsetXLimit : newWidth
                
                newHeight = newHeight > labelOffsetYLimit ? labelOffsetYLimit : newHeight
                
                if value.translation.height < 0 {
                    newHeight = 0
                }
                
                withAnimation {
                    self.labelOffset = .init(
                        width: self.draggingDirection == .down ? 0 : newWidth,
                        height: self.draggingDirection == .down ? newHeight : 0
                    )
                }
                
                var newAmount = Int(labelOffsetXInPercents * 100)
                
                if newAmount < 0 && count + newAmount < config.minValue {
                    newAmount = -(count % newAmount)
                } else if count + newAmount > config.maxValue {
                    newAmount = config.maxValue - count
                }
                
                self.amountProxy.wrappedValue = newAmount
            }
            .onEnded { value in
                if draggingDirection == .right {
                    self.increase()
                } else if draggingDirection == .left {
                    self.decrease()
                } else if draggingDirection == .down {
                    self.reset()
                }
                
                self.amountProxy.wrappedValue = 0
                
                withAnimation {
                    self.labelOffset = .zero
                    self.draggingDirection = .none
                }
            }
        
        return ZStack {
            controlsContainerView
                .animation(.interpolatingSpring(stiffness: 350, damping: 15))
            
            labelView
                .animation(.interpolatingSpring(stiffness: 350, damping: 20))
                .gesture(labelDragGesture)
        }
        .environmentObject(configurationStore)
    }
}

//MARK: - Controls Container
private extension TallyCounter {
    var controlsContainerView: some View {
        HStack(spacing: spacing) {
            ControlButton(
                systemName: "minus",
                size: controlFrameSize,
                isActive: draggingDirection == .left,
                opacity: leftControlOpacity,
                action: decrease
            )
            
            ControlButton(
                systemName: "xmark",
                size: controlFrameSize,
                isActive: draggingDirection == .down,
                opacity: controlsOpacity
            )
            .allowsHitTesting(false)
            
            ControlButton(
                systemName: "plus",
                size: controlFrameSize,
                isActive: draggingDirection == .right,
                opacity: rightControlOpacity,
                action: increase
            )
        }
        .padding(.horizontal, spacing)
        .background(
            RoundedRectangle(cornerRadius: controlsContainerCornerRadius)
                .fill(config.controlsBackgroundColor)
                .overlay(
                    config.controlsBackgroundOverlayColor
                        .opacity(controlsContainerOpacity)
                        .clipShape(RoundedRectangle(cornerRadius: controlsContainerCornerRadius))
                )
                .frame(width: config.controlsContainerWidth, height: controlsContainerHeigth)
        )
        .offset(controlsContainerOffset)
    }
}

//MARK: - Label View
private extension TallyCounter {
    var labelView: some View {
        Text("\(count)")
            .lineLimit(1)
            .minimumScaleFactor(0.1)
            .foregroundColor(.white)
            .padding(10)
            .frame(width: labelSize, height: labelSize)
            .background(config.labelBackgroundColor.opacity(0.8))
            .clipShape(Circle())
            .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 5)
            .font(.system(size: labelFontSize, weight: .semibold, design: .rounded))
            .contentShape(Circle())
            .onTapGesture(perform: self.setMax)
            .if(config.showAmountLabel) {
                $0.overlay(
                    VStack {
                        HStack {
                            Spacer()
                            if amount != 0 {
                                Text("\(amount > 0 ? "+" : "")\(amount)")
                            }
                        }
                        .foregroundColor(.white.opacity(0.6))
                        .font(.system(size: labelFontSize / 2, weight: .semibold, design: .rounded))
                        .animation(.interactiveSpring())
                        
                        Spacer()
                    }
                )
            }
            .offset(self.labelOffset)
    }
}

//MARK: - Controls Computed Properties
private extension TallyCounter {
    var defaultControlsOpacity: Double { 0.4 }
    var spacing: CGFloat { config.controlsContainerWidth / 10 }
    
    var controlsContainerHeigth: CGFloat { config.controlsContainerWidth / 2.5 }
    var controlsContainerCornerRadius: CGFloat { config.controlsContainerWidth / 4.9 }
    var controlsContainerOffset: CGSize {
        .init(
            width: labelOffset.width / 6,
            height: labelOffset.height / 6
        )
    }
    var controlsContainerOpacity: Double {
        controlsOpacity * 0.2 + abs(labelOffsetXInPercents) * 0.25
    }
    var controlsOpacity: Double { labelOffsetYInPercents }
    
    var controlFrameSize: CGFloat { config.controlsContainerWidth / 4.2 }
    
    var leftControlOpacity: Double {
        if labelOffset.width < 0 {
            return -Double(labelOffset.width / (labelOffsetXLimit * 0.65)) + defaultControlsOpacity
        } else {
            return defaultControlsOpacity
        }
    }
    var rightControlOpacity: Double {
        if labelOffset.width > 0 {
            return Double(labelOffset.width / (labelOffsetXLimit * 0.65)) + defaultControlsOpacity
        } else {
            return defaultControlsOpacity
        }
    }
}

//MARK: - Label Computed Properties
private extension TallyCounter {
    var labelSize: CGFloat { config.controlsContainerWidth / 3 }
    var labelFontSize: CGFloat { labelSize / 2.5 }
    var labelOffsetXLimit: CGFloat { config.controlsContainerWidth / 2 }
    var labelOffsetYLimit: CGFloat { controlsContainerHeigth / 1.2 }
    var labelOffsetXInPercents: Double {
        Double(labelOffset.width / labelOffsetXLimit)
    }
    var labelOffsetYInPercents: Double {
        Double(labelOffset.height / labelOffsetYLimit)
    }
    
    /// `Binding` workaround allowing optionally pass `amount` parameter to the component.
    /// If `amount` is passed `TallyCounter(..., amount: $amount)`, it will be set to `bindingAmount` variable and used in  component.
    /// Else `localAmount` will be used
    var amountProxy: Binding<Int> {
        .init(
            get: {
                if let bindingAmount {
                    return bindingAmount.wrappedValue
                } else {
                    return localAmount
                }
            },
            set: { newValue in
                if bindingAmount != nil {
                    bindingAmount?.wrappedValue = newValue
                } else {
                    localAmount = newValue
                }
            }
        )
    }
    
    var amount: Int { self.amountProxy.wrappedValue }
}

//MARK: - Helper methods
private extension TallyCounter {
    private func findDirection(translation: CGSize) {
        withAnimation {
            if translation.height <= 30 {
                if translation.width > 0 {
                    self.draggingDirection = .right
                } else if translation.width < 0 {
                    self.draggingDirection = .left
                }
            } else if self.draggingDirection == .none {
                self.draggingDirection = .down
            }
        }
    }
}

//MARK: - Operations
private extension TallyCounter {
    func decrease() {
        if self.count != config.minValue {
            self.count -= abs(self.amount == 0 ? 1 : self.amount)
        }
    }
    func increase() {
        if self.count < config.maxValue {
            self.count += self.amount == 0 ? 1 : self.amount
        }
    }
    func setMax() { self.count = config.maxValue }
    func reset() { self.count = 0 }
}

//MARK: - Preview
struct PreviewWrapper: View {
    @State private var count: Int = 0
    
    var body: some View {
        VStack {
            TallyCounter(
                count: $count,
                config: .init(
                    maxValue: 2233500,
                    controlsContainerWidth: 300
                )
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.screenBackground.edgesIgnoringSafeArea(.vertical))
    }
}

struct TallyCounter_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper()
            .preferredColorScheme(.dark)
    }
}
