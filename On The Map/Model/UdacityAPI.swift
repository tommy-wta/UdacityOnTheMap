//
//  UdacityApi.swift
//  On The Map
//
//  Created by Tommy Lam on 12/8/20.
//

import Foundation

class UdacityAPI {

    struct Auth {
        static var sessionId: String? = nil
        static var key = ""
        static var firstName = ""
        static var lastName = ""
        static var objectId = ""
    }

    enum Endpoints {

        static let base = "https://onthemap-api.udacity.com/v1"

        case postAndDelete
        case getPublicUserData
        case signUpUrl

        var stringValue : String {
            switch self {
            case .postAndDelete: return Endpoints.base + "/session"
            case .getPublicUserData: return Endpoints.base + "/users/" + Auth.key
            case .signUpUrl: return "https://auth.udacity.com/sign-up"
            }
        }
        var url: URL {
             return URL(string: stringValue)!
        }
    }

    // Login VC related functions
    class func login(userEmail: String, password: String, completion: @escaping (Bool, Error?)->Void) {
        let httpBody = "{\"udacity\": {\"username\": \"\(userEmail)\", \"password\": \"\(password)\"}}"
        postRequestTask(url: Endpoints.postAndDelete.url, responseType: LoginResponse.self, body: httpBody, completion: {(completionResponse, error) in
            if let response = completionResponse {
                Auth.key = response.account.key
                print("Auth Key")
                print(Auth.key)
                Auth.sessionId = response.session.id
                print("Auth Session")
                print(Auth.sessionId)
                completion(true,nil)
            } else {
                completion(false,error)
            }
        })
    }

    class func logout(completion: @escaping () -> Void) {
        var request = URLRequest(url: Endpoints.postAndDelete.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                print("Error logging out.")
                // Shouldnt happen
                return
            }
            let range = (5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
            Auth.sessionId = ""
            completion()
        }
        task.resume()
    }

    class func postRequestTask<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: String, completion: @escaping (ResponseType?, Error?) -> Void) {

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body.data(using: String.Encoding.utf8)

        let session = URLSession.shared

        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                print("error != nil")
                return
            }
            guard let completedData = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            do {
                let range = (5..<completedData.count)
                let newData = completedData.subdata(in: range)
                let responseObject = try JSONDecoder().decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
                print("successful")
                print(String(data: newData, encoding: .utf8)!)
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
          }
          task.resume()
    }
}
