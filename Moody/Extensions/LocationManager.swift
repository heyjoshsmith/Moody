//
//  LocationManager.swift
//  Moody
//
//  Created by Josh Smith on 11/16/22.
//

import Foundation
import MapKit
import CoreLocation
import UserNotifications

class LocationManager: NSObject, ObservableObject {
        
    let location = CLLocationCoordinate2D(latitude: 33.92413, longitude: -84.34048)
    let notificationCenter = UNUserNotificationCenter.current()
    lazy var storeRegion = makeStoreRegion()
    @Published var leftWork = false
    
    lazy var locationManager = makeLocationManager()
    
    private func makeLocationManager() -> CLLocationManager {
      
      let manager = CLLocationManager()
      manager.allowsBackgroundLocationUpdates = true
      
      return manager
    }

    
    private func makeStoreRegion() -> CLCircularRegion {
      
      let region = CLCircularRegion(
        center: location,
        radius: 2,
        identifier: UUID().uuidString)
      
      region.notifyOnExit = true
      
      return region
    }

    
    func validateLocationAuthorizationStatus() {
      
      switch locationManager.authorizationStatus {
      
      case .notDetermined, .denied, .restricted:
        
        print("Location Services Not Authorized")
        locationManager.requestWhenInUseAuthorization()
        requestNotificationAuthorization()

      
      case .authorizedWhenInUse, .authorizedAlways:
        
        print("Location Services Authorized")
        requestNotificationAuthorization()

      default:
        break
      }
    }

    
    private func requestNotificationAuthorization() {
      
      let options: UNAuthorizationOptions = [.sound, .alert]
      
      notificationCenter
        .requestAuthorization(options: options) { [weak self] result, _ in
          
          print("Auth Request result: \(result)")
          if result {
            self?.registerNotification()
          }
        }
    }

    
    private func registerNotification() {
      
      let notificationContent = UNMutableNotificationContent()
      notificationContent.title = "Rate Your Mood"
      notificationContent.body = "Tap into your emotions, how are you feeling?"
      notificationContent.sound = .default

      
      let trigger = UNLocationNotificationTrigger(region: storeRegion, repeats: false)

      
      let request = UNNotificationRequest(
        identifier: UUID().uuidString,
        content: notificationContent,
        trigger: trigger)

      
      notificationCenter
        .add(request) { error in
          if error != nil {
            print("Error: \(String(describing: error))")
          }
        }
    }

    
    override init() {
      super.init()
      
      notificationCenter.delegate = self
    }

}

extension LocationManager: UNUserNotificationCenterDelegate {
  
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    
    print("Received Notification")
    leftWork = true
    
    completionHandler()
  }

  
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler:
      @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    
    print("Received Notification in Foreground")
    leftWork = true
    
    completionHandler(.sound)
  }
}
