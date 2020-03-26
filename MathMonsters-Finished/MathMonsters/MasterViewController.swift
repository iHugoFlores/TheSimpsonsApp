/**
 * Copyright (c) 2019 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

protocol MonsterSelectionDelegate: class {
  func monsterSelected(_ newMonster: Monster)
}

class MasterViewController: UITableViewController {
  let monsters = [
    Monster(name: "Cat-Bot", description: "MEE-OW",
            iconName: "meetcatbot", weapon: .sword),
    Monster(name: "Dog-Bot", description: "BOW-WOW",
            iconName: "meetdogbot", weapon: .blowgun),
    Monster(name: "Explode-Bot", description: "BOOM!",
            iconName: "meetexplodebot", weapon: .smoke),
    Monster(name: "Fire-Bot", description: "Will Make You Steamed",
            iconName: "meetfirebot", weapon: .ninjaStar),
    Monster(name: "Ice-Bot", description: "Has A Chilling Effect",
            iconName: "meeticebot", weapon: .fire),
    Monster(name: "Mini-Tomato-Bot", description: "Extremely Handsome",
            iconName: "meetminitomatobot", weapon: .ninjaStar)
  ]
  
  weak var delegate: MonsterSelectionDelegate?

  // MARK: - Table view data source

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return monsters.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    let monster = monsters[indexPath.row]
    cell.textLabel?.text = monster.name
    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedMonster = monsters[indexPath.row]
    delegate?.monsterSelected(selectedMonster)
    if
      let detailViewController = delegate as? DetailViewController,
      let detailNavigationController = detailViewController.navigationController {
        splitViewController?.showDetailViewController(detailNavigationController, sender: nil)
    }
  }
}
