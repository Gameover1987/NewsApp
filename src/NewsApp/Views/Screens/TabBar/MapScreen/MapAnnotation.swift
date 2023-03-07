
import Foundation
import MapKit

final class MapAnnotation : NSObject, MKAnnotation {
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
    
    var title: String?
    
    var coordinate: CLLocationCoordinate2D
}
