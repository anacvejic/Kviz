//
//  MyError.swift
//  Kviz_znanja
//
//  Created by anacvejic on 10/21/22.
//  Copyright © 2022 anacvejic. All rights reserved.
//

import Foundation
enum MyError: Error{
    
    case encodingError
}

extension Encodable{
    
    func toJson(excluding keys: [String] = [String]()) throws -> [String: Any]{
        
        let objectData = try JSONEncoder().encode(self)
        let jsonOBject = try JSONSerialization.jsonObject(with: objectData, options: [])
        guard var json = jsonOBject as? [String: Any] else {
            throw MyError.encodingError
        }
        
        for key in keys{
            
            json[key] = nil
        }
        
        return json
    }
}
