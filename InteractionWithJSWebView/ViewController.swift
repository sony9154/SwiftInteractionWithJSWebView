//
//  ViewController.swift
//  InteractionWithJSWebView
//
//  Created by Hsu Hua on 2023/8/25.
//

import UIKit
import WebKit


class WebViewController: UIViewController {
    var mWebView: WKWebView? = nil
    
    @IBOutlet weak var msgTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var receivedJSTextField: UITextField!
    
    override func viewDidLoad() {
        msgTextField.clearButtonMode = .whileEditing
        receivedJSTextField.clearButtonMode = .whileEditing
        super.viewDidLoad()
        loadURL()
    }
    
    private func loadURL() {
        // init and load request in webview.
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = WKUserContentController()
        configuration.userContentController.add(self, name: "ToApp")
        mWebView = WKWebView(frame: self.view.frame, configuration: configuration)
        mWebView?.frame.origin.y = submitButton.frame.origin.y + CGFloat(20)
        if let mWebView = mWebView {
            
            guard let url =
                    URL(string: "https://1572979.playcode.io") // https://1572979.playcode.io
            else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            mWebView.load(request)
            
            self.view.addSubview(mWebView)
            self.view.sendSubviewToBack(mWebView)
        }
    }
    
    
    
    
    @IBAction func sendMsgToJavaScript(_ sender: UIButton) {
        guard let text = msgTextField.text else { return }
        mWebView?.evaluateJavaScript("sendMessage('\(text)')") { (result, err) in
            print(result, err)
        
        }
    }
}


extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Strat to load")
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish to load")
    }
}


extension WebViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        receivedJSTextField.text = String(describing: message.body)
//        print(message.body)
    }
}
