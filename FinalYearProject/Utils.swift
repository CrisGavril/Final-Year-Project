//
//  Utils.swift
//  FinalYearProject
//
//  Created by Cristina  on 29/04/2018.
//  Copyright © 2018 Cristina . All rights reserved.
//

import Foundation
import SceneKit

extension matrix_float4x4 {
    var translation: float3 {
        return float3(columns.3.x, columns.3.y, columns.3.z)
    }
}

extension UIView {
    
    func getScreenshot() -> UIImage? {
        let size = CGSize(width: self.frame.width, height: self.frame.height)
        
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale);
        
        let rect = CGRect(origin: .zero, size: size)
        self.drawHierarchy(in: rect, afterScreenUpdates: true)
        
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext()
        return image
    }
    
}
