
import UIKit
import MapKit

final class MapViewController : UIViewController {
    
    private let myLocation = MapAnnotation(title: "Me", coordinate: CLLocationCoordinate2D(latitude: 54.966251, longitude: 82.961725))
    private let zooLocation = MapAnnotation(title: "Zoo", coordinate: CLLocationCoordinate2D(latitude: 55.056651, longitude: 82.888998))
    private let chessClubLocation = MapAnnotation(title: "Chess", coordinate: CLLocationCoordinate2D(latitude: 54.987291, longitude: 82.886743))
    private let nsuLocation = MapAnnotation(title: "NSU", coordinate: CLLocationCoordinate2D(latitude: 54.843243, longitude: 83.088801))
    private let rssLocation = MapAnnotation(title: "RSS", coordinate: CLLocationCoordinate2D(latitude: 55.018649, longitude: 82.928595))
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        
        let latLonMeters = 20000.0

        let region = MKCoordinateRegion(center: myLocation.coordinate, latitudinalMeters: latLonMeters, longitudinalMeters: latLonMeters)
        
        mapView.setCenter(myLocation.coordinate, animated: true)
        mapView.setRegion(region, animated: true)
        
        mapView.delegate = self
        mapView.addAnnotations([myLocation, zooLocation, chessClubLocation, nsuLocation, rssLocation])
        
        return mapView
    }()
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = Colors.News.background
        
        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.left.top.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension MapViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let annotationView = MKAnnotationView()
        annotationView.annotation = annotation
        annotationView.image = UIImage(named: "pin")
        
        return annotationView
    }
}
