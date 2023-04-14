import SwiftUI

struct Style {
    
    static func monospace(_ t: String, color: Color = .blue) -> Text {
        return Text(t).font(.custom("menlo", size: 18, relativeTo: .body)).foregroundColor(color)
    }
    
    static func superscript(_ t: String, color: Color = .blue) -> Text {
        return Text(t).font(.custom("menlo", size: 10)).baselineOffset(5.0).foregroundColor(color)
    }
    
    static func monospaceBig(_ t: String) -> Text {
        return Text(t).font(.custom("menlo", size: 21, relativeTo: .body))
    }
    
    static func superscriptBig(_ t: String) -> Text {
        return Text(t).font(.custom("menlo", size: 18)).baselineOffset(7.0).foregroundColor(.blue)
    }
}
