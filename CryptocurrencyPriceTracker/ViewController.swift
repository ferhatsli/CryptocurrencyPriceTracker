//
//  ViewController.swift
//  CryptocurrencyPriceTracker
//
//  Created by Ferhat Taşlı on 15.11.2024.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate,UIPickerViewDataSource {
    
    let picker = UIPickerView()
    let price = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
        
        //Picker'ı yapılandırıyoruz
        picker.delegate = self
        picker.dataSource = self
        picker.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(picker)
        
        //Label Yapılandırıyoruz
        
        price.text = "Selecet a currency pair"
        price.font = UIFont.systemFont(ofSize: 24)
        price.textAlignment = .center
        price.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(price)
        
        
        NSLayoutConstraint.activate([
            picker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            picker.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            picker.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            picker.heightAnchor.constraint(equalToConstant: 200 ),
            
            
            price.bottomAnchor.constraint(equalTo: picker.topAnchor, constant: -20),
            price.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            price.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            
        ])
        
    }
    
    var crpCcy : [String] = ["BTC", "ETH", "XRP", "BCH"]
    var ccy : [String] = ["USD", "EUR", "GBP","JPY", "TRY","CHF"]

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return crpCcy.count
        } else {
            return ccy.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return crpCcy[row]
        } else {
            return ccy[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCrypto = crpCcy[picker.selectedRow(inComponent: 0)]
        let selectedCurrency = ccy[picker.selectedRow(inComponent: 1)]
        getPrice(crpCcy: selectedCrypto, ccy: selectedCurrency)
        
        
    }
    
    func getPrice(crpCcy: String, ccy: String) {
        guard let url = URL(string: "https://min-api.cryptocompare.com/data/price?fsym=\(crpCcy)&tsyms=\(ccy)") else { return }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data,
                      let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Double],
                      let price = json[ccy] else {
                    DispatchQueue.main.async {
                        self.price.text = "Error"
                    }
                    return
            }
                
                DispatchQueue.main.async {
                    let formatter = NumberFormatter()
                    formatter.currencyCode = ccy
                    formatter.numberStyle = .currency
                    if let formattedPrice = formatter.string(from: NSNumber(value: price)) {
                        self.price.text = formattedPrice
                    }
                }
            
            }.resume()
        
        
    }

}

