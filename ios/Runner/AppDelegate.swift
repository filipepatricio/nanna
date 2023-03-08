import UIKit
import Flutter
import Firebase
import StoreKit

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
                self.lookUp(with: controller, call: call, result: result)
            } else if call.method == "manageSubscription" {
                self.manageSubscription(result: result)
            } else {
                result(FlutterMethodNotImplemented)
                return
            }
        })
    }
    
    fileprivate func lookUp(with controller: FlutterViewController, call: FlutterMethodCall, result: FlutterResult) {
        guard let myWord = call.arguments as? String else {
            result("Word not sent!")
            return
        }
        let referenceController = UIReferenceLibraryViewController.init(term: myWord)
        controller.present(referenceController, animated: true)
        result("")
    }
    
    fileprivate func manageSubscription(result: @escaping FlutterResult) {
        if #available(iOS 15, *) {
            Task {
                do {
                    try await AppStore.showManageSubscriptions(in: self.window.windowScene!)
                    DispatchQueue.main.async {
                        result("")
                    }
                } catch {
                    DispatchQueue.main.async {
                        result(FlutterError(code: "manageSubscription",
                                            message: error.localizedDescription,
                                            details: nil))
                    }
                }
            }
        } else {
            if let url = URL(string: "itms-apps://apps.apple.com/account/subscriptions") {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:])
                }
            }
            result("")
        }
    }
}
