//
//  StockView.swift
//  Micro Charts
//
//  Created by Xu, Sheng on 12/18/19.
//  Copyright © 2019 sstadelman. All rights reserved.
//

import SwiftUI

enum DragState {
    case inactive
    case pressing
    case dragging(translation: CGSize)
    
    var translation: CGSize {
        switch self {
        case .inactive, .pressing:
            return .zero
        case .dragging(let translation):
            return translation
        }
    }
    
    var isPressing: Bool {
        switch self {
        case .pressing, .dragging:
            return true
        case .inactive:
            return false
        }
    }
}

struct StockView: View {
    @EnvironmentObject var model: ChartModel
    
    @State var closestPoint:CGPoint = .zero
    @State var closestDataIndex:Int = 0
    @State var showIndicator = false
    @State var draggingStockView = false
    
    // scale is not allowed to be less than 1.0
    @State var lastScale: CGFloat = 1.0
    @State var lastStartPos: Int = 0
    
    init() {
        lastScale = 0
        lastStartPos = 0
    }
    
    @GestureState var dragState = DragState.inactive
    //@GestureState var position = CGPoint.zero
    
    var body: some View {
        GeometryReader { geometry in
            self.chartView(in: geometry.frame(in: .local))
        }
    }
    
    func chartView(in rect: CGRect) -> some View {
        let xAxisHeight:CGFloat = 24
        let yAxisWidth:CGFloat = 20
        
        let width = rect.size.width - yAxisWidth
        let height = rect.size.height - xAxisHeight
        let linesRect = CGRect(x: yAxisWidth, y: 0, width: width, height: height)
        
        // drag to show the indicator
        let pan = LongPressGesture(minimumDuration: 0.5)
            .sequenced(before: DragGesture())
            .onChanged({ value in
                switch value {
                case .second(true, let drag):
                    if let value = drag {
                        self.showIndicator = true
                        self.closestPoint = self.calClosestDataPoint(toPoint: value.location, rect: linesRect)
                    }
                default:
                    break
                }
            })
            .onEnded({ _ in
                self.showIndicator = false
            })
        
        // drag chart horizontally or drag to show the indicator
        let drag = DragGesture()
            .onChanged({ value in
                // not zoomed in
                if self.model.scale == 1.0 {
                    self.showIndicator = true
                    self.closestPoint = self.calClosestDataPoint(toPoint: value.location, rect: linesRect)
                    return
                }
                
                self.draggingStockView = true
                let maxPos = Int(linesRect.size.width * (self.model.scale - 1))
                let tmp = self.lastStartPos - Int(value.translation.width)
                if self.model.panChartToDataPointOnly {
                    let unitWidth: CGFloat = linesRect.size.width * self.model.scale / CGFloat(StockUtility.numOfDataItmes(self.model) - 1)
                    let closestIndex = Int(CGFloat(tmp) / unitWidth)
                    self.model.startPos = Int(CGFloat(closestIndex) * unitWidth).clamp(low: 0, high: maxPos)
                }
                else {
                    self.model.startPos = tmp.clamp(low: 0, high: maxPos)
                }
            })
            .onEnded({ value in
                self.showIndicator = false
                self.draggingStockView = false
                self.lastStartPos = self.model.startPos
            })
        
        // zoom in & out
        let mag = MagnificationGesture()
            .onChanged({ value in
                self.showIndicator = false
                let count = StockUtility.numOfDataItmes(self.model)
                let maxScale = max(1, CGFloat(count - 1) / 2)
                let tmp = self.lastScale * value.magnitude
                self.model.scale = tmp.clamp(low: 1.0, high: maxScale)
                let width = linesRect.size.width
                let midPos: CGFloat = (CGFloat(self.lastStartPos) + width / 2) / (self.lastScale * width)
                
                let maxPos: Int = Int(width * (self.model.scale - 1))
                self.model.startPos = Int(midPos * width * self.model.scale - width/2).clamp(low: 0, high: maxPos)
            })
            .onEnded({ value in
                self.lastScale = self.model.scale
                self.lastStartPos = self.model.startPos
            })
            .exclusively(before: drag)
        
        return ZStack {
            if model.userInteractionEnabled {
                StockLinesView(rect: linesRect)
                    .frame(width: linesRect.size.width, height: linesRect.size.height)
                    .offset(x: linesRect.origin.x/2, y: -xAxisHeight/2)
                    .opacity(draggingStockView ? 0.4 : 1.0)
                    .gesture(pan)
                    .gesture(drag)
                    .gesture(mag)
            }
            else {
                StockLinesView(rect: linesRect)
                    .offset(x: linesRect.origin.x/2, y: -xAxisHeight/2)
            }
            
            XAxisView(rect: CGRect(x: yAxisWidth, y: rect.size.height - xAxisHeight, width: width, height: xAxisHeight))
            
            YAxisView(rect: CGRect(x:0, y: 0, width: yAxisWidth, height: height), chartWidth: linesRect.size.width)
            
            if self.showIndicator && closestDataIndex >= 0 {
                StockIndicatorView(rect: linesRect, closestPoint: $closestPoint, closestDataIndex: $closestDataIndex)
            }
        }
    }
    
    func calClosestDataPoint(toPoint: CGPoint, rect: CGRect) -> CGPoint {
        let width = rect.size.width
        
        let unitWidth: CGFloat = width * model.scale / CGFloat(StockUtility.numOfDataItmes(model) - 1)
        let startIndex = Int((CGFloat(model.startPos) / unitWidth).rounded(.up))
        let startOffset: CGFloat = (unitWidth - CGFloat(model.startPos).truncatingRemainder(dividingBy: unitWidth)).truncatingRemainder(dividingBy: unitWidth)
        
        let minVal = CGFloat(model.ranges?[model.currentSeriesIndex].lowerBound ?? 0)
        let maxVal = CGFloat(model.ranges?[model.currentSeriesIndex].upperBound ?? 0)
        let index: Int = Int((toPoint.x - startOffset) / unitWidth + 0.5) + startIndex
        
        self.closestDataIndex = index.clamp(low: 0, high: StockUtility.lastValidDimIndex(model))
        
        let currentData = StockUtility.dimensionValue(model, categoryIndex: self.closestDataIndex)
        let x = rect.origin.x + startOffset + CGFloat(self.closestDataIndex - startIndex) * unitWidth
        let y = rect.size.height - (CGFloat(currentData ?? 0) - minVal) * rect.size.height / (maxVal - minVal) + rect.origin.y
        
        return CGPoint(x: x, y: y)
    }
}

struct StockView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(Tests.stockModels) {
            StockView().environmentObject($0)
        }
        .frame(width:300, height: 200, alignment: .topLeading)
        .previewLayout(.sizeThatFits)
    }
}

extension Comparable {
    func clamp(low: Self, high: Self) -> Self {
        if (self > high) {
            return high
        } else if (self < low) {
            return low
        }

        return self
    }
}