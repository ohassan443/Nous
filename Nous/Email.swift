	//
	//  Email.swift
	//  NOUSAPP
	//
	//  Created by Omar Hassan  on 05/06/2022.
	//

import Foundation
import MessageUI

struct PlatformMailService {
	var name : String
	var mailBodyUrl :URL
}

class EmailService: NSObject, MFMailComposeViewControllerDelegate {
	public static let shared = EmailService()

	func sendEmail(subject:String, body:String, to:String, completion: @escaping (Bool) -> Void){

		let availableMailClients = createEmailUrl(to: to, subject: subject, body: body)

		if (availableMailClients.isEmpty == false){


			let alert = UIAlertController(title: "Choose Mail Client", message: "", preferredStyle: UIAlertController.Style.alert)
			availableMailClients.forEach({client in
				alert.addAction(UIAlertAction(title: client.name, style: .default, handler: { (_) in
					UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
					UIApplication.shared.open(client.mailBodyUrl)
				}))
			})
			alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
			}))

			UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
		} else if MFMailComposeViewController.canSendMail(){
			let picker = MFMailComposeViewController()
			picker.setSubject(subject)
			picker.setMessageBody(body, isHTML: true)
			picker.setToRecipients([to])
			picker.mailComposeDelegate = self

			UIApplication.shared.windows.first?.rootViewController?.present(picker,  animated: true, completion: nil)
		}

		completion(MFMailComposeViewController.canSendMail())
	}

	func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
		controller.dismiss(animated: true, completion: nil)
	}

	private func createEmailUrl(to: String, subject: String, body: String) -> [PlatformMailService]{
		let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
		let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

		let gmailUrl = URL(string: "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
		let outlookUrl = URL(string: "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
		let yahooMail = URL(string: "ymail://mail/compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
		let defaultUrl = URL(string: "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)")

		var list : [PlatformMailService] = []
		if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
			list.append(PlatformMailService(name: "Gmail", mailBodyUrl: gmailUrl))
		}
		if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
			list.append( PlatformMailService(name: "Outlook", mailBodyUrl: outlookUrl))

		}
		if let yahooMail = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
			list.append( PlatformMailService(name: "Yahoo", mailBodyUrl: yahooMail))
		}
		if let defaultMail = defaultUrl, UIApplication.shared.canOpenURL(defaultMail) {
			list.append( PlatformMailService(name: "Mail App", mailBodyUrl: defaultMail))
		}

		return list
	}




}
