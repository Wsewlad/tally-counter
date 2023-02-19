//
//  CounterView.swift
//  Tally Counter
//
//  Created by  Vladyslav Fil on 29.09.2021.
//

import SwiftUI

public struct TallyCounter: View {
    private enum Direction {
        case none, left, right, down
    }
    var controlsContainerWidth: CGFloat = 300
    var minValue = 0
    var maxValue = 999
    
    @State var count: Int = 0
    @State private var labelOffset: CGSize = .zero
    @State private var draggingDirection: Direction = .none
    @State private var amount: Int = 0
    
    public init() {
        
    }
    
    public var body: some View {
        let dragGesture = DragGesture()
            .onChanged { value in
                findDirection(translation: value.translation)

                var newWidth = value.translation.width * 0.75
                var newHeight = value.translation.height * 0.75
                
                if self.labelOffset.width >= labelOffsetXLimit {
                    newWidth = value.translation.width * 0.55
                } else if self.labelOffset.width <= -labelOffsetXLimit {
                    newWidth = value.translation.width * 0.55
                }
                
                if self.labelOffset.height >= labelOffsetYLimit {
                    newHeight = newHeight *  0.55
                } else if value.translation.height < 0 {
                    newHeight = 0
                }
                
                withAnimation {
                    self.labelOffset = .init(
                        width: self.draggingDirection == .down ? 0 : newWidth,
                        height: self.draggingDirection == .down ? newHeight : 0
                    )
                }
                
                var newAmount = Int(labelOffsetXInPercents * 100)
                
                if newAmount < 0 && count + newAmount < minValue {
                    newAmount = -(count % newAmount)
                } else if count + newAmount > maxValue {
                    newAmount = maxValue - count
                }
                
                self.amount = newAmount
            }
            .onEnded { value in
                if draggingDirection == .right {
                    self.increase()
                } else if draggingDirection == .left {
                    self.decrease()
                } else if draggingDirection == .down {
                    self.reset()
                }
                
                self.amount = 0
                
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
                .gesture(dragGesture)
        }
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
            // TODO: - add controlsBackground color
                .fill(Color.gray)
                .overlay(
                    Color.black.opacity(controlsContainerOpacity)
                        .clipShape(RoundedRectangle(cornerRadius: controlsContainerCornerRadius))
                )
                .frame(width: controlsContainerWidth, height: controlsContainerHeigth)
        )
        .offset(controlsContainerOffset)
    }
}

//MARK: - Label View
private extension TallyCounter {
    var labelView: some View {
        Text("\(count)")
            .foregroundColor(.white)
            .frame(width: labelSize, height: labelSize)
        // TODO: - add controlsBackground labelBackground
            .background(Color.gray.opacity(0.8))
            .clipShape(Circle())
            .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 5)
            .font(.system(size: labelFontSize, weight: .semibold, design: .rounded))
            .contentShape(Circle())
            .onTapGesture {
                self.count = maxValue
            }
            .overlay(
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
            .offset(self.labelOffset)
    }
}

//MARK: - Computed Properties
private extension TallyCounter {
    var defaultControlsOpacity: Double { 0.4 }
    var spacing: CGFloat { controlsContainerWidth / 10 }
    
    var controlsContainerHeigth: CGFloat { controlsContainerWidth / 2.5 }
    var controlsContainerCornerRadius: CGFloat { controlsContainerWidth / 4.9 }
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
    
    var controlFrameSize: CGFloat { controlsContainerWidth / 4.2 }
    
    var leftControlOpacity: Double {
        if labelOffset.width < 0 {
            return -Double(labelOffset.width / (labelOffsetXLimit * 0.65)) + defaultControlsOpacity
        } else {
            return defaultControlsOpacity - controlsOpacity - labelOffsetXInPercents / 3.5
        }
    }
    var rightControlOpacity: Double {
        if labelOffset.width > 0 {
            return Double(labelOffset.width / (labelOffsetXLimit * 0.65)) + defaultControlsOpacity
        } else {
            return defaultControlsOpacity - controlsOpacity + labelOffsetXInPercents / 3.5
        }
    }
    
    var labelSize: CGFloat { controlsContainerWidth / 3 }
    var labelFontSize: CGFloat { labelSize / 2.5 }
    var labelOffsetXLimit: CGFloat { controlsContainerWidth / 3 + spacing }
    var labelOffsetYLimit: CGFloat { controlsContainerHeigth / 1.2 }
    var labelOffsetXInPercents: Double {
        Double(labelOffset.width / labelOffsetXLimit)
    }
    var labelOffsetYInPercents: Double {
        Double(labelOffset.height / labelOffsetYLimit)
    }
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
        if self.count != minValue { self.count -= abs(self.amount == 0 ? 1 : self.amount) }
    }
    func increase() {
        if self.count < maxValue { self.count += self.amount == 0 ? 1 : self.amount }
    }
    func reset() { self.count = 0 }
}

struct TallyCounter_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(34)
            
            TallyCounter()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        // TODO: - add controlsBackground screenBackground
        .background(Color.black.edgesIgnoringSafeArea(.vertical))
    }
}
