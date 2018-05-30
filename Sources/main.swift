//
//  main.swift
//  PerfectTemplate
//
//  Created by Kyle Jessup on 2015-11-05.
//	Copyright (C) 2015 PerfectlySoft, Inc.
//
//===----------------------------------------------------------------------===//
//
// This source file is part of the Perfect.org open source project
//
// Copyright (c) 2015 - 2016 PerfectlySoft Inc. and the Perfect project authors
// Licensed under Apache License v2.0
//
// See http://perfect.org/licensing.html for license information
//
//===----------------------------------------------------------------------===//
//

import PerfectHTTP
import PerfectHTTPServer
import PerfectLib

let server = HTTPServer()

var routes = Routes()

let data = AllGarages()





//GET ALL GARAGES
routes.add(method: .get, uri: "/garages", handler: {
    request, response in
    
    // Setting the response content type explicitly to application/json
    response.setHeader(.contentType, value: "application/json")
    // Setting the body response to the JSON list generated
    response.appendBody(string: data.list())
    // Signalling that the request is completed
    response.completed()
}
)

//GET ONE GARAGE
routes.add(method: .get, uri: "/garages/{name}", handler: {
    request, response in
    
    // Setting the response content type explicitly to application/json
    response.setHeader(.contentType, value: "application/json")
    // Setting the body response to the JSON list generated
    
    if let garageName = request.urlVariables["name"]{
        print(garageName)
        response.appendBody(string: data.getGarage(garageName)!)
    }
    
    // Signalling that the request is completed
    response.completed()
}
)


//GET ONE Car
routes.add(method: .get, uri: "/garages/{garage}/{car}", handler: {
    request, response in
    
    // Setting the response content type explicitly to application/json
    response.setHeader(.contentType, value: "application/json")
    // Setting the body response to the JSON list generated
    
    if let garageName = request.urlVariables["garage"]{
        print(garageName)
        if let carName = request.urlVariables["car"] {
            print(carName)
            response.appendBody(string: data.getCar(garageName: garageName, carName: carName)!)
        }
        
    }
    
    // Signalling that the request is completed
    response.completed()
}
)





//POST ONE GARAGE
routes.add(method: .post, uri: "/garages", handler: {
    request, response in
    
    // Setting the response content type explicitly to application/json
    response.setHeader(.contentType, value: "application/json")
    // Adding a new "person", passing the complete HTTPRequest object to the function.

    response.appendBody(string: data.add(request.postBodyString!)!)

    
    // Signalling that the request is completed
    response.completed()
}
)

//POST ONE CAR
routes.add(method: .post, uri: "/garages/{name}", handler: {
    request, response in
    
    // Setting the response content type explicitly to application/json
    response.setHeader(.contentType, value: "application/json")
    // Adding a new "person", passing the complete HTTPRequest object to the function.
    
    if let garageName = request.urlVariables["name"]{
        print(garageName)
        
        
        response.appendBody(string: data.postCarInGarage(endPoint: garageName, jsonString: request.postBodyString!)!)

    }
    
    
    // Signalling that the request is completed
    response.completed()
}
)

//DELETE one GARAGE
routes.add(method: .delete, uri: "/garages/{name}", handler: {
    request, response in
    
    response.setHeader(.contentType, value: "application/json")
    
    if let garageName = request.urlVariables["name"]{
        let out = data.delete(garageName)
        response.appendBody(string: out!)
        
    }
    
    // Completed
    response.completed()
}
)

//DELETE one Car
routes.add(method: .delete, uri: "/garages/{name}/{car}", handler: {
    request, response in
    
    response.setHeader(.contentType, value: "application/json")
    
    if let garageName = request.urlVariables["name"]{
        if let carName = request.urlVariables["car"] {
            let out = data.delete(garageName: garageName, carName: carName)
            response.appendBody(string: out!)
        }
 
    }
    
    // Completed
    response.completed()
}
)




// An example request handler.
// This 'handler' function can be referenced directly in the configuration below.
func handler(request: HTTPRequest, response: HTTPResponse) {
    // Respond with a simple message.
    response.setHeader(.contentType, value: "text/html")
    response.appendBody(string: "<html><title>Hello, world!</title><body>Hello, worldsss!</body></html>")
    // Ensure that response.completed() is called when your processing is done.
    response.completed()
}

// Configuration data for an example server.
// This example configuration shows how to launch a server
// using a configuration dictionary.


let confData = [
    "servers": [
        // Configuration data for one server which:
        //	* Serves the hello world message at <host>:<port>/
        //	* Serves static files out of the "./webroot"
        //		directory (which must be located in the current working directory).
        //	* Performs content compression on outgoing data when appropriate.
        [
            "name":"localhost",
            "port":8181,
            "routes":[
                ["method":"get", "uri":"/", "handler":handler],
                ["method":"get", "uri":"/**", "handler":PerfectHTTPServer.HTTPHandler.staticFiles,
                 "documentRoot":"./webroot",
                 "allowResponseFilters":true]
            ],
            "filters":[
                [
                    "type":"response",
                    "priority":"high",
                    "name":PerfectHTTPServer.HTTPFilter.contentCompression,
                    ]
            ]
        ]
    ]
]

// Add the routes to the server.
server.addRoutes(routes)

// Set a listen port of 8181
server.serverPort = 8181

do {
    // Launch the HTTP server.
    try server.start()
} catch PerfectError.networkError(let err, let msg) {
    print("Network error thrown: \(err) \(msg)")
}






