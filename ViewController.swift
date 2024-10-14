//
//  ViewController.swift
//  Jsondata
//
//  Created by Anuteja Reddy on 14/10/24.
//

import UIKit
import CoreData

class ViewController: UIViewController,UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return study.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let studyData = study[indexPath.row]
        cell?.textLabel?.text = studyData.uid
        cell?.textLabel?.text = studyData.bundleName
        return cell!
    }
    
    
    @IBOutlet weak var table: UITableView!
    var study : [Userdata] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let Userdata = loadJson()
        {
            savedata(Userdata: Userdata)
        }
        study = fetchdata()
        table.dataSource = self
    }
    func loadJson()->[UserDataJSON]?{
        guard let url = Bundle.main.url(forResource: "UsersData", withExtension: "json") else {
            print("file not found")
            return nil
        }
        
            do{
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let userdata = try decoder.decode([UserDataJSON].self,from:data)
                print(userdata)
                
                return userdata
            }
            catch{
                print("error in loading JSON file\(error.localizedDescription)")
                return nil
            }
        }
    func savedata(Userdata:[UserDataJSON])
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
        let context = appDelegate.persistentContainer.viewContext
        for data in Userdata
        {
            let studyData = NSEntityDescription.insertNewObject(forEntityName: "Userdata", into: context) as! Userdata
            studyData.uid = data.uid
            studyData.itemdescription = data.itemdecription
            studyData.bundleCoverImage = data.bundleCoverImage
            studyData.bundleID = data.bundleId
            studyData.bundleName = data.bundleName
            studyData.firstName = data.firstname
            studyData.lastName = data.lastName
            studyData.fname = data.fname
            studyData.lName = data.lName
            studyData.listPrice = data.listprice
            studyData.sellingPrice = data.sellingPrice
            studyData.test = data.test
            studyData.testCount = data.testCount
            studyData.subjectId = data.subjectID
            studyData.qualification = data.qualification
            studyData.mName = data.mName
        }
        do{
            try context.save()
        }catch{print("failed to save")
        }
        
    }
    func fetchdata()->[Userdata]
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return[]}
        let context = appDelegate.persistentContainer.viewContext
        let fetchrequest = NSFetchRequest<Userdata>(entityName:"Userdata")
        do{
            let study = try context.fetch(fetchrequest)
            return study
        }
        catch{
            print("failed")
            return []
        }
        
    }
}
