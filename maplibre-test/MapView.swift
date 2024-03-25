//
//  MapView.swift
//  maplibre-test
//
//  Created by Sean McNutt on 3/25/24.
//
import MapLibre
import MapKit
import SwiftUI

struct MapView: UIViewRepresentable {
  
    func makeUIView(context: Context) -> MLNMapView {
        // read the key from property list
        let mapTilerKey = getMapTilerkey()
        validateKey(mapTilerKey)
        
        // Build the style url
        let styleURL = URL(string: "https://api.maptiler.com/maps/streets/style.json?key=\(mapTilerKey)")
        
        // create the mapview
        let mapView = MLNMapView(frame: .zero, styleURL: styleURL)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.logoView.isHidden = true
        mapView.setCenter(
            CLLocationCoordinate2D(latitude: 39.961698, longitude: -75.197213),
            zoomLevel: 10,
            animated: false)
        
        // use the coordinator only if you need
        // to respond to the map events
        mapView.delegate = context.coordinator
        
        return mapView
    }
    
    func updateUIView(_ uiView: MLNMapView, context: Context) {}
    
    func makeCoordinator() -> MapView.Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, MLNMapViewDelegate {
        var control: MapView
        
        init(_ control: MapView) {
            self.control = control
        }

        func mapViewDidFinishLoadingMap(_ mapView: MLNMapView) {
            // write your custom code which will be executed
            // after map has been loaded
        }
    }
    
    func getMapTilerkey() -> String {
        let mapTilerKey = Bundle.main.object(forInfoDictionaryKey: "MapTilerKey") as? String
        validateKey(mapTilerKey)
        return mapTilerKey!
    }
    
    func validateKey(_ mapTilerKey: String?) {
        if (mapTilerKey == nil) {
            preconditionFailure("Failed to read MapTiler key from info.plist")
        }
        let result: ComparisonResult = mapTilerKey!.compare("placeholder", options: NSString.CompareOptions.caseInsensitive, range: nil, locale: nil)
        if result == .orderedSame {
            preconditionFailure("Please enter correct MapTiler key in info.plist[MapTilerKey] property")
        }
    }
}


