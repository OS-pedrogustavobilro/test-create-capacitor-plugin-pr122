import Foundation
import Capacitor

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(CapacitorJavaToKotlinPlugin)
public class CapacitorJavaToKotlinPlugin: CAPPlugin, CAPBridgedPlugin {
    public let identifier = "CapacitorJavaToKotlinPlugin"
    public let jsName = "CapacitorJavaToKotlin"
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "echo", returnType: CAPPluginReturnPromise)
    ]
    private let implementation = CapacitorJavaToKotlin()

    @objc func echo(_ call: CAPPluginCall) {
        let value = call.getString("value") ?? ""
        call.resolve([
            "value": implementation.echo(value)
        ])
    }
}
