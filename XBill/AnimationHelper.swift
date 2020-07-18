//
//  AnimationHelper.swift
//  XBill
//
//  Created by Bryan Mansell on 18/07/2020.
//  Copyright © 2020 Bryan Mansell. All rights reserved.
//

import SpriteKit

class AnimationHelper {
    
    static func loadTextures(from atlas: SKTextureAtlas, withName name: String) -> [SKTexture] {
        var textures = [SKTexture]()
        for index in 0..<atlas.textureNames.count {
            let textureName = name + String(index)
            textures.append(atlas.textureNamed(textureName))
        }
        return textures
    }
}
