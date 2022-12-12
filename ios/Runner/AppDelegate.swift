import UIKit
import Flutter
import Firebase

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    GeneratedPluginRegistrant.register(with: self)
      
      registerAppMethodChannel()
      
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    fileprivate func registerAppMethodChannel() {
        let controller = window?.rootViewController as! FlutterViewController
        let methodChannel = FlutterMethodChannel(name: "so.informed.internal", binaryMessenger:controller.binaryMessenger)
        
        methodChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            
            if call.method == "lookUp" {
                guard let myWord = call.arguments as? String else {
                    result("Word not sent!")
                    return
                }
                let referenceController = UIReferenceLibraryViewController.init(term: myWord)
                controller.present(referenceController, animated: true)
            } else {
                result(FlutterMethodNotImplemented)
                return
            }
        })
    }
}
