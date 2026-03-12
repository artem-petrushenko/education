import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
  private let METHOD_CHANNEL = "com.example.methodChannel"
  private let EVENT_CHANNEL = "com.example.eventChannel"
  private let BASIC_MESSAGE_CHANNEL = "com.example.basicMessageChannel"

  private var eventSink: FlutterEventSink?
  private var timer: Timer?
  private var counter = 0

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    let controller = window?.rootViewController as! FlutterViewController

    // MethodChannel
    let methodChannel = FlutterMethodChannel(name: METHOD_CHANNEL, binaryMessenger: controller.binaryMessenger)
    methodChannel.setMethodCallHandler { [weak self] call, result in
      guard let self = self else { return }
      if call.method == "openGeneralSettings" {
        if let url = URL(string: "App-Prefs:root=General") {
                if UIApplication.shared.canOpenURL(url) {
                  UIApplication.shared.open(url)
                }
              }
        result(nil)
      } else {
        result(FlutterMethodNotImplemented)
      }
    }

    // EventChannel
    let eventChannel = FlutterEventChannel(name: EVENT_CHANNEL, binaryMessenger: controller.binaryMessenger)
    eventChannel.setStreamHandler(self)

    // BasicMessageChannel
    let basicMessageChannel = FlutterBasicMessageChannel(name: BASIC_MESSAGE_CHANNEL, binaryMessenger: controller.binaryMessenger, codec: FlutterStringCodec.sharedInstance())

    basicMessageChannel.setMessageHandler { (message: Any?, reply: @escaping FlutterReply) in
      if let text = message as? String {
        reply("Received: \(text)")
      } else {
        reply("Invalid message")
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

// MARK: - EventChannel StreamHandler
extension AppDelegate: FlutterStreamHandler {
  func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    self.eventSink = events
    counter = 0

    timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
      events(self.counter)
      self.counter += 1
    }

    return nil
  }

  func onCancel(withArguments arguments: Any?) -> FlutterError? {
    timer?.invalidate()
    timer = nil
    eventSink = nil
    return nil
  }
}



