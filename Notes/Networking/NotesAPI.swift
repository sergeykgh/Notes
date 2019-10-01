//
//  NotesAPI.swift
//  Notes
//
//  Created by Sergey Korotkevich on 01/10/2019.
//  Copyright © 2019 Sergey Korotkevich. All rights reserved.
//

import Foundation

class NotesAPI {
    static let notesEndpoint = "https://private-9aad-note10.apiary-mock.com/notes"
    
    enum HttpMethod {
        static let GET = "GET"
        static let POST = "POST"
        static let PUT = "PUT"
        static let DELETE = "DELETE"
    }
    
    enum ErrorMessage {
        static let generalError = "Something went wrong"
        static let connectionError = "Network connection error"
    }

    static func getNotes(completionHandler: @escaping ([Note]?, String?) -> Void) {
        guard let urlRequest = createUrlRequest(httpMethod: HttpMethod.GET, resourceId:nil, data:nil) else {
            completionHandler(nil, ErrorMessage.generalError)
            return
        }
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            let error = validateResponse(response: response, error: error, statusCode: 200)
            if error != nil {
                completionHandler(nil, error)
            }
            var notes: [Note]? = nil
            if data != nil {
                notes = parseGetNotesReponse(data: data!)
            }
            completionHandler(notes, notes != nil ? nil : ErrorMessage.generalError)
        }
        task.resume()
    }
    
    static func getNote(id: Int, completionHandler: @escaping (Note?, String?) -> Void) {
        guard let urlRequest = createUrlRequest(httpMethod: HttpMethod.GET, resourceId:String(id), data:nil) else {
            completionHandler(nil, ErrorMessage.generalError)
            return
        }
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            let error = validateResponse(response: response, error: error, statusCode: 200)
            if error != nil {
                completionHandler(nil, error)
            }
            var note: Note? = nil
            if data != nil {
                note = parseGetNoteReponse(data: data!)
            }
            completionHandler(note, note != nil ? nil : ErrorMessage.generalError)
        }
        task.resume()
    }
    
    static func addNote(title: String, completionHandler: @escaping (String?) -> Void) {
        let jsonData = try? JSONSerialization.data(withJSONObject: ["title": title])
        
        guard let urlRequest = createUrlRequest(httpMethod: HttpMethod.POST, resourceId:nil, data:jsonData) else {
            completionHandler(ErrorMessage.generalError)
            return
        }
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            let error = validateResponse(response: response, error: error, statusCode: 201)
            completionHandler(error)
        }
        task.resume()
    }
    
    static func deleteNote(id: Int, completionHandler: @escaping (String?) -> Void) {
        guard let urlRequest = createUrlRequest(httpMethod: HttpMethod.DELETE, resourceId:String(id), data:nil) else {
            completionHandler(ErrorMessage.generalError)
            return
        }
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            let error = validateResponse(response: response, error: error, statusCode: 204)
            completionHandler(error)
        }
        task.resume()
    }
    
    static func updateNote(id: Int, title: String, completionHandler: @escaping (String?) -> Void) {
        let jsonData = try? JSONSerialization.data(withJSONObject: ["title": title])
        
        guard let urlRequest = createUrlRequest(httpMethod: HttpMethod.PUT, resourceId:String(id), data:jsonData) else {
            completionHandler(ErrorMessage.generalError)
            return
        }
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            let error = validateResponse(response: response, error: error, statusCode: 201)
            completionHandler(error)
        }
        task.resume()
    }
    
    static func createUrlRequest(httpMethod: String, resourceId: String?, data:Data?) -> URLRequest? {
        let urlString = notesEndpoint + (resourceId != nil ? "/" + resourceId! : "")
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod
        if data != nil {
            urlRequest.httpBody = data!
        }
        
        return urlRequest
    }
    
    static func validateResponse(response: URLResponse?, error: Error?, statusCode: Int) -> String? {
        guard let response = response as? HTTPURLResponse,
            error == nil else {
            return ErrorMessage.connectionError
        }

        if response.statusCode != statusCode {
            return ErrorMessage.generalError
        }

        return nil
    }
    
    static func parseGetNotesReponse(data: Data) -> [Note]?
    {
        do {
            let jsonResponse = try JSONSerialization.jsonObject(with:
                data, options: [])
            
            guard let jsonArray = jsonResponse as? [[String: Any]] else {
                return nil
            }
            
            var result: [Note] = []
            for obj in jsonArray {
                guard let note = parseNote(obj: obj) else {
                    return nil
                }
                result.append(note)
            }
            return result
            
        } catch {
            return nil
        }
    }
    
    static func parseGetNoteReponse(data: Data) -> Note?
    {
        do {
            let jsonResponse = try JSONSerialization.jsonObject(with:
                data, options: [])
            
            guard let obj = jsonResponse as? [String: Any] else {
                return nil
            }
            guard let note = parseNote(obj: obj) else {
                return nil
            }
            return note
            
        } catch {
            return nil
        }
    }
    
    static func parseNote(obj: [String: Any]) -> Note? {
        guard let id = obj["id"] as? Int else {
            return nil
        }
        guard let title = obj["title"] as? String else {
            return nil
        }
        
        return Note(id: id, title: title)
    }
}
