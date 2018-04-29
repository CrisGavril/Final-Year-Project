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
