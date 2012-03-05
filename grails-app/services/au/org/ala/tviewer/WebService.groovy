package au.org.ala.tviewer

import org.codehaus.groovy.grails.commons.ConfigurationHolder
import grails.converters.JSON
import org.codehaus.groovy.grails.web.converters.exceptions.ConverterException
import groovyx.net.http.HTTPBuilder
import groovyx.net.http.ContentType


class WebService {

    def get(String url) {
        def conn = new URL(url).openConnection()
        try {
            conn.setConnectTimeout(10000)
            conn.setReadTimeout(50000)
            return conn.content.text
        } catch (SocketTimeoutException e) {
            def error = [error: "Timed out calling web service. URL= \${url}."]
            println error.error
            return error as JSON 
        } catch (Exception e) {
            def error = [error: "Failed calling web service. ${e.getClass()} ${e.getMessage()} URL= ${url}."]
            println error.error
            return error as JSON
        }
    }

    def getJson(String url) {
        def conn = new URL(url).openConnection()
        try {
            conn.setConnectTimeout(10000)
            conn.setReadTimeout(50000)
            def json = conn.content.text
            return JSON.parse(json)
        } catch (ConverterException e) {
            def error = ['error': "Failed to parse json. ${e.getClass()} ${e.getMessage()} URL= ${url}."]
            println error.error
            return error
        } catch (SocketTimeoutException e) {
            def error = [error: "Timed out getting json. URL= \${url}."]
            println error.error
            return error
        } catch (Exception e) {
            def error = [error: "Failed to get json from web service. ${e.getClass()} ${e.getMessage()} URL= ${url}."]
            println error.error
            return error
        }
    }

    def doJsonPost(String url, String path, String postBody) {
        println "post = " + postBody
        def http = new HTTPBuilder(url)
        http.request( groovyx.net.http.Method.POST, groovyx.net.http.ContentType.JSON ) {
            uri.path = path
            body = postBody
            requestContentType = ContentType.URLENC

            response.success = { resp, json ->
                println "bulk lookup = " + json
                return json
            }

            response.failure = { resp ->
                def error = [error: "Unexpected error: ${resp.statusLine.statusCode} : ${resp.statusLine.reasonPhrase}"]
                println error.error
                return error
            }
        }

    }
}