//
//  CropView.swift
//  NC2 Crop
//
//  Created by kwak on 6/14/24.
//

import SwiftUI

enum Crop: Equatable {
    case circle
    case rectangle
    case starShape
    case custom(CGSize)
    
    func name()->String {
        switch self {
        case .circle:
            return "Circle"
        case .rectangle:
            return "Rectangle"
        case .starShape:
            return "StarShape"
        case let .custom(cGSize) :
            return "Custom \(Int(cGSize.width))X\(Int(cGSize.height))"
        }
    }
    
    func size()->CGSize {
        switch self {
        case .circle:
            return .init(width: 350, height: 350)
        case .rectangle:
            return .init(width: 350, height: 350)
        case .starShape:
            return .init(width: 400, height: 400)
        case .custom(let cGSize):
            return cGSize
        }
    }
}

struct CropShape: Shape {
    var crop: Crop = .circle
    
    func path(in rect: CGRect) -> Path {
        
        switch crop {
        case .circle:
            return getCirclePath(in: rect)
        case .rectangle:
            return getRectanlePath(in: rect)
        case .starShape:
            return getStarPath(in: rect)
        default:
            return getStarPath(in: rect)
        }
    }
    
    func getCirclePath(in rect: CGRect) -> Path {
        var path = Path()
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        path.addArc(center: center, radius: radius, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 360), clockwise: false)
        
        return path
    }
    
    func getRectanlePath(in rect: CGRect) -> Path {
        var path = Path()
        
        path.addRect(rect)
        
        return path
    }
    
    func getStarPath(in rect: CGRect) -> Path {
        var path = Path()
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let size = min(rect.width, rect.height) * 0.4
        
        path.move(to: CGPoint(x: center.x, y: center.y - size))
        path.addQuadCurve(to: CGPoint(x: center.x + size, y: center.y), control: CGPoint(x: center.x + size * 0.2, y: center.y - size * 0.2))
        path.addQuadCurve(to: CGPoint(x: center.x, y: center.y + size), control: CGPoint(x: center.x + size * 0.2, y: center.y + size * 0.2))
        path.addQuadCurve(to: CGPoint(x: center.x - size, y: center.y), control: CGPoint(x: center.x - size * 0.2, y: center.y + size * 0.2))
        path.addQuadCurve(to: CGPoint(x: center.x, y: center.y - size), control: CGPoint(x: center.x - size * 0.2, y: center.y - size * 0.2))
        path.closeSubpath()
        
        return path
    }
}
