//
//  ViewController.swift
//  MapLocator
//
//  Created by Peter Herman
//

import UIKit
import MapKit

var universalArray = [Double]()
var searchText = String()

struct coors {
    static var lat = 0.0
    static var long = 0.0
}

struct ipBuilder {
    var state = "00"
    var county = "000"
    var tract = "000000"
}

class ViewController: UIViewController, UISearchBarDelegate, MKMapViewDelegate{
    
    var searchController:UISearchController!
    var annotation:MKAnnotation!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    
    
    @IBAction func showSearchBar(sender: AnyObject) {
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = self
        presentViewController(searchController, animated: true, completion: nil)

    }
    
    @IBOutlet var mapView: MKMapView!

    //MARK: UISearchBar Delegate
    func searchBarSearchButtonClicked(searchBar: UISearchBar){
        //1
        searchBar.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
        if self.mapView.annotations.count != 0{
            annotation = self.mapView.annotations[0]
            self.mapView.removeAnnotation(annotation)
        }

        universalArray.removeAll()
        
        //2
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        searchText = searchBar.text!
        localSearch = MKLocalSearch(request: localSearchRequest)
        
        
        localSearch.startWithCompletionHandler { (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil{
                let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
                return
            }
            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.title = searchBar.text
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)
            
            
            coors.lat = self.pointAnnotation.coordinate.latitude
            coors.long = self.pointAnnotation.coordinate.longitude
            
            let reID = "pin"
            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: reID)
            self.mapView.centerCoordinate = self.pointAnnotation.coordinate
            self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
 
            self.updateIPFCC("2014")
            self.updateIPFCC("2013")
            self.updateIPFCC("2012")
            self.updateIPFCC("2011")
            self.updateIPFCC("2010")
            
        }
    }
    

    
    //MARK: - REST calls
    // This makes the GET call to FCC Api. It simply gets the Census FIPS code from the long lat of the geocoded address and displays it on the screen.
   
    func updateIPFCC(year: String) {
        var ipB = ipBuilder()
        let lngString:String = String(format:"%f", coors.long)
        let latString:String = String(format:"%f", coors.lat)
        
        
        let firstEnd: String = "https://data.fcc.gov/api/block/find?format=jsonp&latitude="
        let secondEnd: String = "&longitude="
        let thirdEnd: String =  "&showall=false"
        let postEndpoint = firstEnd + latString + secondEnd + lngString + thirdEnd
        
        let session = NSURLSession.sharedSession()
        let url = NSURL(string: postEndpoint)!
        session.dataTaskWithURL(url, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            guard let realResponse = response as? NSHTTPURLResponse where
                realResponse.statusCode == 200 else {
                    print("Not a 200 response")
                    return
            }
            do {
                if let ipString = NSString(data:data!, encoding: NSUTF8StringEncoding) {
                    // Print what we got from the call
                    let stateString = ipString.substringWithRange(NSRange(location: 27, length: 2))
                    ipB.state = stateString
                    let countyString = ipString.substringWithRange(NSRange(location: 29, length: 3))
                    ipB.county = countyString
                    let tractString = ipString.substringWithRange(NSRange(location: 32, length: 6))
                    ipB.tract = tractString
                }
            }
            
            
            //Now call the Census American Community Survey Api Using the FIPS Code
            let httpCensus = "http://api.census.gov/data/"
            let censusYear = year + "/acs5"
            let censusKey = "&key=ccda5ba8300d0a723e4cba2a1a0e7cf9b2768b46"
            let startParams = "?get="
            let medianAge = "B01002_001E"
            let medIncome = ",B06011_001E"
            let medRent = ",B25058_001E"
            let totalPop = ",B01003_001E"
            let vacantUnits = ",B25002_003E"
            let occupiedUnits = ",B25002_002E"
            let ownerOccupied = ",B25003_002E"
            let renterOccupied = ",B25003_003E"
            
            let geography = "&for=tract:" + ipB.tract + "&in=state:" + ipB.state + "+county:" + ipB.county
            let tractCall = httpCensus + censusYear + startParams + medianAge + medIncome + medRent + totalPop + vacantUnits + occupiedUnits + ownerOccupied + renterOccupied + geography + censusKey
            let sessionN = NSURLSession.sharedSession()
            
            print(tractCall)
            let urlN = NSURL(string: tractCall)!
            sessionN.dataTaskWithURL(urlN, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                // Make sure we get an OK response
                guard let realResponseN = response as? NSHTTPURLResponse where
                    realResponseN.statusCode == 200 else {
                        print("Not a 200 response")
                        return
                }
                
                
                do {
                    if let ipStringN = NSString(data:data!, encoding: NSUTF8StringEncoding) {
                        // Print what we got from the call
                        let fullCallBackArray = ipStringN.componentsSeparatedByString("\n")
                        
                        let callBackArray = fullCallBackArray[1].componentsSeparatedByString(",")
                        print(callBackArray)

                        
                        
                        let ageString = callBackArray[0]
                        let incomeString = callBackArray[1]
                        let medRentString = callBackArray[2]
                        let totalPopString = callBackArray[3]
                        let vacantUnitsString = callBackArray[4]
                        let occupiedUnitsString = callBackArray[5]
                        let ownerOccupiedString = callBackArray[6]
                        let renterOccupiedString = callBackArray[7]
                        
                        
                        
                        let medAgeArray = ageString.componentsSeparatedByString("[")
                        print(medAgeArray)
                        let medAgeD = medAgeArray[1].stringByReplacingOccurrencesOfString("\"", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                        let medIncomeD = incomeString.stringByReplacingOccurrencesOfString("\"", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                        let medRentD = medRentString.stringByReplacingOccurrencesOfString("\"", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                        let totalPopD = totalPopString.stringByReplacingOccurrencesOfString("\"", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                        let vacantUnitsD = vacantUnitsString.stringByReplacingOccurrencesOfString("\"", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                        let occupiedUnitsD = occupiedUnitsString.stringByReplacingOccurrencesOfString("\"", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                        let ownerOccupiedD = ownerOccupiedString.stringByReplacingOccurrencesOfString("\"", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                        let renterOccupiedD = renterOccupiedString.stringByReplacingOccurrencesOfString("\"", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                        print(renterOccupiedD)
                        
                        universalArray.append(Double(medAgeD)!)
                        universalArray.append(Double(medIncomeD)!)
                        universalArray.append(Double(medRentD)!)
                        universalArray.append(Double(totalPopD)!)
                        universalArray.append(Double(vacantUnitsD)!)
                        universalArray.append(Double(occupiedUnitsD)!)
                        universalArray.append(Double(ownerOccupiedD)!)
                        universalArray.append(Double(renterOccupiedD)!)

                    }
                }
            }).resume()
        }).resume()
    }
    func printAge(text: Array<String>) {
        let medAgeNum = Double(text[0])
        print(medAgeNum)
    }
    
    @IBAction func goToGraphPage(sender: AnyObject) {
        print("Onto Next Page")
    }
    

}


