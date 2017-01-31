//
//  HBChannel.swift
//  EHWidget
//
//  Created by EricHo on 9/12/2016.
//  Copyright © 2016 E H. All rights reserved.
//

import Foundation

class HBChannel: NSObject {
    
    struct EncodeKey {
        static let keyIdentifier = "channelIdentifier"
        static let keyDisplayName = "channelDisplayName"
        static let keyDescription = "channelDescription"
        static let keyEnableChannel = "enableChannel"
        static let keyEnableNotification = "enableNotification"
    }
    
    var channelIdentifier:String
    var channelDisplayName:String
    var channelDescription:String
    var enableChannel:Bool = true
    var enableNotification:Bool = true
    
    
    init(channelIdentifier:String, channelDisplayName:String, channelDescription:String, enableChannel:Bool, enableNotification:Bool) {
        self.channelIdentifier = channelIdentifier
        self.channelDisplayName = channelDisplayName
        self.channelDescription = channelDescription
        self.enableChannel = enableChannel
        self.enableNotification = enableNotification
    }
    
    //reference
    //http://stackoverflow.com/documentation/swift/5360/nscoding#t=201612060240087456178
    convenience init(coder aDecoder: NSCoder) {
        let valueIdentifier = (aDecoder.decodeObject(forKey: HBChannel.EncodeKey.keyIdentifier) as? String) ?? ""
        let valueDisplayName = (aDecoder.decodeObject(forKey: HBChannel.EncodeKey.keyDisplayName) as? String) ?? ""
        let valueDescription = (aDecoder.decodeObject(forKey: HBChannel.EncodeKey.keyDescription) as? String) ?? ""
        let valueChannel = aDecoder.decodeBool(forKey: HBChannel.EncodeKey.keyEnableChannel)
        let valueNotification  = aDecoder.decodeBool(forKey: HBChannel.EncodeKey.keyEnableNotification)
        self.init(channelIdentifier:valueIdentifier, channelDisplayName:valueDisplayName, channelDescription:valueDescription, enableChannel:valueChannel, enableNotification:valueNotification)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encode(self.channelIdentifier, forKey: HBChannel.EncodeKey.keyIdentifier)
        aCoder.encode(self.channelDisplayName, forKey: HBChannel.EncodeKey.keyDisplayName)
        aCoder.encode(self.channelDescription, forKey: HBChannel.EncodeKey.keyDescription)
        aCoder.encode(self.enableChannel, forKey: HBChannel.EncodeKey.keyEnableChannel)
        aCoder.encode(self.enableNotification, forKey: HBChannel.EncodeKey.keyEnableNotification)
    }
}

//extension HBChannel:Equatable {}
func ==( lhs: HBChannel, rhs: HBChannel) -> Bool {
    let result = (lhs.channelIdentifier == rhs.channelIdentifier) && (lhs.channelDisplayName == rhs.channelDisplayName) && (lhs.channelDescription == rhs.channelDescription) && (lhs.enableChannel && rhs.enableChannel) && (lhs.enableNotification && rhs.enableNotification)
    return result
}

//######################################
