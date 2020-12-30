//
//  ParseAPI.swift
//  On The Map
//
//  Created by Tommy Lam on 12/8/20.
//

import Foundation

class ParseAPI {

    class func getStudentLocationUsingUrl(completion: @escaping([StudentLocationData]?, Error?) -> Void) {
        getParseRequestTask(url: UdacityAPI.Endpoints.studentLocationUrl.url, responseType: AllLocations.self) { (completionData, error) in
            if let locationData = completionData {
                //print("location data output: " + String(locationData.results.count))
                //print(locationData.results)
                completion(locationData.results, nil)
            } else {
                //print("Get location failed")
                completion([], error)
            }
        }
    }

    class func addNewLocation(locationData: StudentLocationData, completion: @escaping (Bool, Error?) -> Void) {
        let body = "{\"uniqueKey\": \"\(locationData.uniqueKey ?? "")\", \"firstName\": \"\(locationData.firstName)\", \"lastName\": \"\(locationData.lastName)\",\"mapString\": \"\(locationData.mapString)\", \"mediaURL\": \"\(locationData.mediaURL)\",\"latitude\": \(locationData.latitude), \"longitude\": \(locationData.longitude)}"
        ParseAPI.postRequestTask(url: UdacityAPI.Endpoints.addNewLocation.url, responseType: PostNewStudentLocation.self, body: body, completion: {(completionResponse, error) in
            if let response = completionResponse {
                if response.createdAt != nil {
                    UdacityAPI.Auth.objectId = response.objectId ?? ""
                    completion(true, nil)
                } else {
                    completion(false, error)
                }
            }
        })
    }

    class func getParseRequestTask<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)

        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error...
                completion(nil, error)
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            do {
                let responseObject = try JSONDecoder().decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }

    class func postRequestTask<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: String, completion: @escaping (ResponseType?, Error?) -> Void) {

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        request.httpBody = body.data(using: String.Encoding.utf8)

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let session = URLSession.shared

        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            print(String(data: data!, encoding: .utf8)!)
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            do {
                let responseObject = try JSONDecoder().decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
}
