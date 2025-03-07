//
//  OutfitGenerator.swift
//  UTrend

import Foundation
import UIKit

class OutfitGenerator : UIViewController {

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.tableView.isScrollEnabled = false
    }
    @objc func refreshAll () {
        if tableView != nil {
            if let top = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TopCell {
                top.fetchTops()
            }
            if let bottom = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? BottomCell {
                bottom.fetchBottoms()
            }
            if let shoes = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? ShoeCell {
                shoes.fetchShoes()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func newOutfit(_ sender: UIButton) {
        // get reference to collection views
        let topCV = (tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TopCell)?.collectionView
        let botCV = (tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? BottomCell)?.collectionView
        let shoeCV = (tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? ShoeCell)?.collectionView
        // get the number of items in each view
        let topCount: Int = topCV!.numberOfItems(inSection: 0)
        let bottomCount: Int = botCV!.numberOfItems(inSection: 0)
        let shoeCount: Int = shoeCV!.numberOfItems(inSection: 0)

        // generate random index
        if (topCount != 0 && bottomCount != 0 && shoeCount != 0) {
            let randTop = Int.random(in: 0..<topCount)
            let randBottom = Int.random(in: 0..<bottomCount)
            let randShoes = Int.random(in: 0..<shoeCount)

            // slide to corresponding items
            topCV?.selectItem(at: IndexPath(item: randTop, section: 0), animated: true, scrollPosition: [])
            topCV?.scrollToItem(at: IndexPath(item: randTop, section: 0), at: [], animated: true)

            botCV?.selectItem(at: IndexPath(item: randBottom, section: 0), animated: true, scrollPosition: [])
            botCV?.scrollToItem(at: IndexPath(item: randBottom, section: 0), at: [], animated: true)

            shoeCV?.selectItem(at: IndexPath(item: randShoes, section: 0), animated: true, scrollPosition: [])
            shoeCV?.scrollToItem(at: IndexPath(item: randShoes, section: 0), at: [], animated: true)
        } else {
            let alert = UIAlertController(title: "Empty Wardrobe", message: "You have missing clothing items. Please upload them to create your cool fit!", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }

//        print ("random top: \(randTop)")
//        print ("random bottom: \(randBottom)")
//        print ("random shoe: \(randShoes)")

    }

    @IBAction func saveOutfit(_ sender: UIButton) {
        print("save outfit")
        
        UIImageWriteToSavedPhotosAlbum(save(), nil, nil, nil);
    }
    
    //get image from tableview
    func save() -> UIImage {
        
        let view = self.tableView
        UIGraphicsBeginImageContextWithOptions(self.tableView.bounds.size, false, 0.0)
        let context = UIGraphicsGetCurrentContext();
        view?.layer.render(in: context!);
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        
        return image;
    }
}

extension OutfitGenerator : UITableViewDelegate, UITableViewDataSource {
    func tableView( _ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if (indexPath.row == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TopCell", for: indexPath) as! TopCell
            return cell
        } else if (indexPath.row == 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BottomCell", for: indexPath) as! BottomCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShoeCell", for: indexPath) as! ShoeCell
            return cell
        }

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let height: CGFloat = tableView.frame.size.height

        if (indexPath.row == 0) {
            return (3*height)/8
        } else if (indexPath.row == 1) {
            return (3*height)/8
        } else {
            return (2*height)/8
        }
    }
}
