import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var myTable: UITableView!
    var indexForLocation = 0
    var isEditMode = false
    var editIndex = 0
    var postList = [AllPosts]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isEditMode = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreatePostVC" {
            let destinationVC = segue.destination as! CreatePostVC
            if isEditMode {
                destinationVC.editModePost = postList[editIndex]
                destinationVC.isEditMode = isEditMode
                destinationVC.isEditModeIndex = editIndex
                destinationVC.sendDelegate = self
                destinationVC.deleteDelegate = self
            }
            destinationVC.delegate = self
        }
        if segue.identifier == "seeLocation" {
            let destinationVC = segue.destination as! LocationVC
            destinationVC.shouldHideAnnotations = true
            destinationVC.postVIewOnlyLocation = postList[indexForLocation].locationAnnotation
        }
    }
    
    @objc func locationBtnTapped( sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: myTable)
        if let indexPath = myTable.indexPathForRow(at: point) {
            indexForLocation = indexPath.row
        }
        performSegue(withIdentifier: "seeLocation", sender: self)
    }
    @IBAction func addPostBtn(_ sender: Any) {
        performSegue(withIdentifier: "CreatePostVC", sender: self)
    }
}


//MARK: - All Protocol Methods :
extension ViewController : sendPostData , sendEditedData , deletePost {
    func data(indexForDelete: Int) {
        postList.remove(at: indexForDelete)
        myTable.reloadData()
    }
    
    func data(caption: String, location: CustomAnnotation, editIndex: Int, currentDate: String, currentTime: String) {
        let editedpost = postList[editIndex]
        editedpost.caption = caption
        editedpost.locationAnnotation = location
        editedpost.postLocation = "\(location.title ?? "")"
        editedpost.currentTime = currentTime
        editedpost.currentDate = currentDate
        myTable.reloadData()
    }
    
    func data(post: AllPosts) {
        postList.append(post)
        myTable.reloadData()
    }
}

//MARK: - TableView Delegate Methods
extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        postList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PostViewCell
        let post = postList[indexPath.row]
        cell.userNameLbl.text = " \(post.userName)"
        cell.captionLbl.text = " \(post.caption)"
        cell.locationBtn.setTitle(post.postLocation, for: .normal)
        cell.imageLbl.image = post.photo
        cell.locationBtn.tag = indexPath.row
        cell.locationBtn.addTarget(self, action: #selector(locationBtnTapped(sender :)), for: .touchUpInside)
        cell.dateLbl.text = "Date: \(post.currentDate)"
        cell.timeLbl.text = "Time: \(post.currentTime)"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        isEditMode = true
        editIndex = indexPath.row
        performSegue(withIdentifier: "CreatePostVC", sender: self)
    }
}
