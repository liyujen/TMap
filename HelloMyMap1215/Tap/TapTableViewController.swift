////
////  TapTableViewController.swift
////  TMap
////
////  Created by student on 2022/3/14.
////
//
//import UIKit
//import CoreData
//import MapKit
//import CoreLocation
//class TapTableViewController: UITableViewController{
//
//    @IBOutlet weak var tapView: UITableView!
//    var data : [AnnotationData] = []
//    //載入資料
//    required init?(coder: NSCoder) {
//        super.init (coder: coder)
//        self.loadFromCoreData()
//        //假資料
//        //        for i in 0..<3 {
//        //            let  tap = Tap()
//        //            tap.pointtext = "地點\(i)"
//        //            tap.viewpointtext = "\(i)"
//        //            data.append(tap)
//        //        }
//
//        NotificationCenter.default.addObserver(self, selector: #selector(finishUpdate(notification:)), name: .tapUpdated , object: nil)
//
//    }
//    @objc
//    func finishUpdate(notification: Notification){
//        if  let tap = notification.userInfo?["tap"] as? AnnotationData{
//            self.didFinishUpdateTap(tap: tap)
//        }
//    }
//
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.tableView.dataSource = self
//        self.tableView.delegate = self
//
//        self.navigationItem.leftBarButtonItem =
//        self.editButtonItem
//
//        if #available(iOS 11.0, *) {
//            self.navigationController?.navigationBar.prefersLargeTitles = true
//        }
//        // Uncomment the following line to preserve selection between presentations
//        // self.clearsSelectionOnViewWillAppear = false
//
//        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//        // self.navigationItem.rightBarButtonItem = self.editButtonItem
//    }
//    //Coredata
//    // MARK: Core data
//    func saveToCoreData(){
//        CoreDataHelper.shared.saveContext()
//
//    }
//
//    func loadFromCoreData(){
//
//        let moc = CoreDataHelper.shared.managedObjectContext()
//        let request = NSFetchRequest<LocationData>(entityName: "Tap")
//
//        moc.performAndWait{
//            do{
//                //執行查詢的請求,回傳[Tap]
//                let result = try moc.fetch(request)
//                self.data = result
//            }catch{
//                print("error\(error)")
//                self.data = []
//            }
//        }
//    }
//    override func setEditing(_ editing: Bool, animated: Bool) {
//        super.setEditing(editing, animated: true)
//        self.tableView.setEditing(editing, animated: true)
//    }
//
//    @IBAction func edit(_ sender: Any) {
//        let isEditing = tableView.isEditing
//        //self.tableView.isEditing = !isEditing
//        self.tableView.setEditing(!isEditing, animated: true)
//    }
//    @IBAction func addTap(_ sender: Any) {
//        let moc = CoreDataHelper.shared.managedObjectContext()
//        let tap = LocationData(context: moc)
//        tap.pointtext = " New Tap"
//        self.data.append(tap)
//
//        let  indexPath  = IndexPath(row:self.data.count-1, section:0)
//        self.tableView.insertRows(at:[indexPath], with:.automatic)
//        self.saveToCoreData()
//
//        //        if let noteVC = self.storyboard?.instantiateViewController(withIdentifier: "noteVC") as? NoteViewController{
//        //            //自己產生UINavigationController  點+上方的bar
//        //            noteVC.delegate = self
//        //            let naviCtrl = UINavigationController(rootViewController: noteVC)
//        //            self.present(naviCtrl, animated: true, completion: nil)
//    }
//
//
//    // MARK: - Table view data source
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return self.data.count//回傳筆數 10筆
//    }
//
//    //每筆資料長怎樣
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let tapcell = tableView.dequeueReusableCell(withIdentifier: "tapCell", for: indexPath) as! TableViewCell
//        //        let tapcell = TableViewCell(style:.default, reuseIdentifier: "tapcell")
//        let tapCell = self.data[indexPath.row]
//        tapcell.titleText.text = tapCell.pointtext
//        tapcell.subTitleText.text = tapCell.viewpointtext
//
//        tapcell.imageView?.image = tapCell.thumbnailImage()
//        //tapcell.showsReorderControl = true
//        //tapcell.accessoryType = .disclosureIndicator
//        // Configure the cell...
//
//        return tapcell
//    }
//
//
//    /*
//     // Override to support conditional editing of the table view.
//     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//     // Return false if you do not want the specified item to be editable.
//     return true
//     }
//     */
//
//    //刪除
//    // Override to support editing the table view.
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//
//        if editingStyle == .delete {
//            let deletedTap = self.data.remove(at:indexPath.row)
//            let moc = CoreDataHelper.shared.managedObjectContext()
//            moc.performAndWait {
//                moc.delete(deletedTap)
//            }
//            tableView.deleteRows(at: [indexPath], with: .fade)
//            self.saveToCoreData()
//        }
//        //        else if editingStyle == .insert {
//        //
//        //            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        //        }
//    }
//
//
//
//    //使用者拖拉cell
//    // Override to support rearranging the table view.
//    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        let tap = self.data.remove(at: fromIndexPath.row)
//        self.data.insert(tap, at: destinationIndexPath.row)
//
//    }
//    //點選
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("位置\(indexPath.row)被點選")
//        tableView.deselectRow(at: indexPath, animated: true)
//
//        //       if let tapVC = self.storyboard?.instantiateViewController(withIdentifier: "TapVC"){
//        //            self.navigationController?.pushViewController(tapVC, animated: true)
//        //        }
//
//    }
//    //    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) ->CGFloat {
//    //        return indexPath.row % 2 == 0 ? 80 : 40
//    //    }
//
//    /*
//     // Override to support conditional rearranging of the table view.
//     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
//     // Return false if you do not want the item to be re-orderable.
//     return true
//     }
//     */
//
//    /*
//     // MARK: - Navigation
//
//     // In a storyboard-based application, you will often want to do a little preparation before navigation
//
//
//     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//     Get the new view controller using segue.destination.
//     Pass the selected object to the new view controller.
//     }
//     */
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        //指定連的線
//
//        if segue.identifier == "tapSegue" {
//            let tapVC = segue.destination as! TapViewController
//            if let indexPath = self.tableView.indexPathForSelectedRow{
//                let tap = self.data[indexPath.row]
//                tapVC.locationData = tap
//            }
//        }
//    }
//    //按下done,被通知的方法
//    func didFinishUpdateTap(tap : AnnotationData) {
//        self.saveToCoreData()
//        self.tableView.reloadData()
//    }
//}
