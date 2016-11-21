//
//  FlagBuilder.swift
//  Taylor
//
//  Created by Dmitrii Celpan on 11/10/15.
//  Copyright © 2015 YOPESO. All rights reserved.
//

let Flags = [HelpShort, HelpLong, VersionLong, VersionShort]

final class FlagBuilder {
    
    func flag(_ flag: String) -> Flag {
        switch flag {
        case HelpShort, HelpLong:
            return HelpFlag()
        case VersionLong, VersionShort:
            return VersionFlag()
        default:
            return HelpFlag()
        }
        
    }
    
}
