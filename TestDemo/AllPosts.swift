import UIKit

class AllPosts: NSObject {
    var userName : String
    var caption : String
    var photo : UIImage
    var postLocation : String
    var currentDate : String
    var currentTime : String
    var locationAnnotation : CustomAnnotation
    
    init(userName: String, caption: String, photo: UIImage, postLocation: String, currentDate: String, currentTime: String, locationAnnotation: CustomAnnotation) {
        self.userName = userName
        self.caption = caption
        self.photo = photo
        self.postLocation = postLocation
        self.currentDate = currentDate
        self.currentTime = currentTime
        self.locationAnnotation = locationAnnotation
    } 
}
