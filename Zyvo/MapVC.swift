//
//  MapVC.swift
//  Zyvo
//
//  Created by ravi on 22/10/24.
//
//



import UIKit
import GoogleMaps
import CoreLocation
import Combine

class MapVC: UIViewController,GMSMapViewDelegate,LocationPickerDelegate {
    
    var backAction:(_ str : String ) -> () = { str in}
    
    @IBOutlet weak var view_Search: UIView!
//    var mapDatAArr = [MapData(id: 0, location: "", latitude: "44.968046", longitude: "-94.420307"),MapData(id: 1, location: "", latitude: "44.33328", longitude: "-89.132008"),MapData(id: 2, location: "", latitude: "33.755787", longitude: "-116.359998")]
    @IBOutlet weak var mapV: GMSMapView!
    
    var latitude : Double? = 0.0
    var longitude : Double? = 0.0
    
    private var markerMap: [String: GMSMarker] = [:]
    private var cancellables = Set<AnyCancellable>()
    private var viewModel = HomeDataViewModel()
    
    var getHomeDataArr : [HomeDataModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 14.0, *) {
            bindVC()
        } else {
            // Fallback on earlier versions
        }
        
        LocationPicker.shared.delegate = self
        LocationPicker.shared.checkLocationPermission()
        
       self.mapV.delegate = self

        view_Search.layer.borderWidth = 1.5
        view_Search.layer.borderColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1).cgColor
        view_Search.layer.cornerRadius = view_Search.layer.frame.height / 2
    }
    
    @objc func appDidBecomeActive() {
        // When the app returns from settings, check location again
        LocationPicker.shared.checkLocationPermission()
    }
    
   //  MARK: - LocationManagerHelperDelegate Methods
    func didUpdateLocation(latitude: Double, longitude: Double) {
        print("Latitude: \(latitude), Longitude: \(longitude)")
        self.latitude = latitude
        self.longitude = longitude
        self.viewModel.latitude = "\(latitude)"
        self.viewModel.longitude = "\(longitude)"
        self.viewModel.apiforGetHomeData()
    }
    
    func didFailWithError(error: Error) {
        print("Failed to get location: \(error.localizedDescription)")
    }
    
    @IBAction func btnWhereTap(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WhereVC") as! WhereVC
        vc.comeFrom = "Where"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnTime_Tap(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WhereVC") as! WhereVC
        vc.comeFrom = "Time"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnActivity_Tap(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WhereVC") as! WhereVC
        vc.comeFrom = "Activity"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnSearch_Tap(_ sender: UIButton) {
        
    }
    @IBAction func btnFilter_Tap(_ sender: UIButton) {
        
    }
    
    @IBAction func btnshowList_Tap(_ sender: UIButton) {
        

        self.backAction("Ravi")
        self.navigationController?.popViewController(animated: true)
        
    }

}

struct MapDataModel: Codable {
    let success: Bool?
    let code: Int?
    let message: String?
    let data: [MapData]?
}
struct MapData: Codable {
    let id: Int?
    let location, latitude, longitude, hourly_rate: String?

    enum CodingKeys: String, CodingKey {
        case id, location, latitude, longitude,hourly_rate
       
    }
}

//@available(iOS 14.0, *)
extension MapVC {
    func bindVC() {
        
        
        viewModel.$getHomeDataResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    self.getHomeDataArr?.removeAll()
                    self.getHomeDataArr = response.data
                    
                    guard let homeDataArr = self.getHomeDataArr, !homeDataArr.isEmpty else { return }

                       var bounds = GMSCoordinateBounds()
                       var firstCoordinate: CLLocationCoordinate2D?

                       for (index, i) in homeDataArr.enumerated() {
                           guard let latString = i.latitude, let lonString = i.longitude,
                                 let latitude = Double(latString), let longitude = Double(lonString) else { continue }

                           let positionKey = "\(latitude),\(longitude)"

                           if let existingMarker = self.markerMap[positionKey] {
                               // Marker already exists, update only if needed
                               if let customView = existingMarker.iconView as? MapPin {
                                   customView.updateView(price: i.hourlyRate ?? "")
                               }
                               continue // Skip adding a new marker
                           }

                           // Create a new marker
                           let marker = GMSMarker()
                           marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

                           if let customView = Bundle.main.loadNibNamed("MapPin", owner: self, options: nil)?.first as? MapPin {
                               customView.frame = CGRect(x: 0, y: 0, width: 120, height: 54)
                               marker.iconView = customView
                               customView.updateView(price: i.hourlyRate ?? "")
                           }

                           marker.map = self.mapV
                           self.markerMap[positionKey] = marker // Store marker to prevent duplicates

                           if index == 0 {
                               firstCoordinate = marker.position
                           }

                           bounds = bounds.includingCoordinate(marker.position)
                       }
                       guard let firstCoordinate = firstCoordinate else { return }
                       DispatchQueue.main.async {
                           let update = GMSCameraUpdate.fit(bounds, withPadding: 50)
                           self.mapV.animate(with: update)
                           
                           DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                               let centeredCamera = GMSCameraPosition.camera(withLatitude: firstCoordinate.latitude, longitude: firstCoordinate.longitude, zoom: self.mapV.camera.zoom + 100)
                             //
                               self.mapV.animate(to: centeredCamera)
                           }
                       }
                })
            }.store(in: &cancellables)
    }
}

