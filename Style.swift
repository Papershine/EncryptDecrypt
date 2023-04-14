import SwiftUI

struct Style {
    
    static func monospace(_ t: String) -> Text {
        return Text(t).font(.custom("menlo", size: 18, relativeTo: .body)).foregroundColor(.blue)
    }
    
    static func superscript(_ t: String) -> Text {
        return Text(t).font(.custom("menlo", size: 10)).baselineOffset(5.0).foregroundColor(.blue)
    }
    
    static func monospaceBig(_ t: String) -> Text {
        return Text(t).font(.custom("menlo", size: 23, relativeTo: .body))
    }
    
    static func superscriptBig(_ t: String) -> Text {
        return Text(t).font(.custom("menlo", size: 18)).baselineOffset(7.0).foregroundColor(.blue)
    }
}
