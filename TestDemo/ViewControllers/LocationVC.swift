import UIKit
import MapKit
import CoreLocation

class CustomAnnotation :NSObject , MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    let title: String?
    let subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}

protocol sendData {
    func data (locationAnnotation : CustomAnnotation)
}


class LocationVC: UIViewController {
    var titleOfCity = ""
    var subTitleOfCity = ""
    var shouldHideAnnotations = false
    var delegate : sendData!
    var postVIewOnlyLocation : CustomAnnotation!
    @IBOutlet var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.isUserInteractionEnabled = false
        if !shouldHideAnnotations {
            navigationItem.title = "Change Location"
            mapView.isUserInteractionEnabled = true
            addAnnotations(lattitude: 12.120000, longitude: 76.680000, title: "Nanjangud", subtitle:  "Mysore, Karnataka, India")
            addAnnotations(lattitude: 24.879999, longitude: 74.629997, title: "Chittorgarh", subtitle:  "Rajasthan, India" )
            addAnnotations(lattitude: 16.994444, longitude: 73.300003, title: "Ratnagiri", subtitle:  "Maharashtra, India" )
            addAnnotations(lattitude: 19.155001, longitude: 72.849998, title: "Goregaon", subtitle:  "Mumbai, Maharashtra, India" )
            addAnnotations(lattitude: 24.794500, longitude: 73.055000, title: "Pindwara", subtitle:  "Rajasthan, India" )
            addAnnotations(lattitude: 21.250000, longitude: 81.629997, title: "Raipur", subtitle:  "Chhattisgarh, India" )
            addAnnotations(lattitude: 16.166700, longitude: 74.833298, title: "Gokak", subtitle:  "Karnataka, India" )
            addAnnotations(lattitude: 26.850000, longitude: 80.949997, title: "Lucknow", subtitle:  "Uttar Pradesh, India" )
            addAnnotations(lattitude: 28.679079, longitude: 77.069710, title: "Delhi", subtitle:  "India" )
            addAnnotations(lattitude: 19.076090, longitude: 72.877426, title: "Mumbai", subtitle:  "Maharashtra, India")
            addAnnotations(lattitude: 20.2961, longitude: 85.8245, title: "Bhubaneswar", subtitle:  "Odisha, India")
            addAnnotations(lattitude: 19.8135, longitude: 85.8312, title: "Puri", subtitle:  "Odisha, India")
            addAnnotations(lattitude: 21.0574, longitude: 86.4963, title: "Bhadrak", subtitle:  "Odisha, India")
        } else {
            navigationItem.title = "View Location"
            mapView.addAnnotation(postVIewOnlyLocation)
        }
    }
    
    // Method for adding Custum Annotation
    func addAnnotations(lattitude : Double , longitude : Double , title : String , subtitle : String){
        let coordinate = CLLocationCoordinate2D(latitude: lattitude, longitude: longitude)
        let annotation = CustomAnnotation(coordinate: coordinate, title: title, subtitle: subtitle)
        mapView.addAnnotation(annotation)
    }
}


//MARK: MApView Delegate Methods :
extension LocationVC : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation {
            print("Selected Annotation : " + annotation.title!!)
            titleOfCity = annotation.title!!
            subTitleOfCity = (annotation.subtitle ?? "") ?? ""
            let location = CustomAnnotation(coordinate: annotation.coordinate, title: annotation.title!!, subtitle: annotation.subtitle!!)
            delegate.data(locationAnnotation: location)
            navigationController?.popViewController(animated: true)
        }
    }
}

