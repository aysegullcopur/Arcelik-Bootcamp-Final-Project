//
//  DateAndTimeSelectionViewController.swift
//  Charger
//
//  Created by Aysegul COPUR on 16.07.2022.
//

import UIKit

class DateAndTimeSelectionViewController: UIViewController {
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var datePickerToolBar: UIToolbar!
    @IBOutlet weak var datePickerDoneItem: UIBarButtonItem!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var continueButton: UIButton!
    
    @IBOutlet weak var socketInfoLabel1: UILabel!
    @IBOutlet weak var socketInfoLabel2: UILabel!
    @IBOutlet weak var socketInfoLabel3: UILabel!
    
    @IBOutlet weak var socketSlotsColletionView1: UICollectionView!
    @IBOutlet weak var socketSlotsColletionView2: UICollectionView!
    @IBOutlet weak var socketSlotsColletionView3: UICollectionView!
    
    @IBAction func continueButtonTapped(_ sender: UIButton) {
        if properDateTime() {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let appointmentDetailViewController = storyBoard.instantiateViewController(withIdentifier: "AppointmentDetailViewController") as! AppointmentDetailViewController
            appointmentDetailViewController.selectedStation = selectedStation
            appointmentDetailViewController.selectedSocket = selectedSocket
            appointmentDetailViewController.selectedSocketTimeSlot = selectedSocketTimeSlot
            navigationController?.pushViewController(appointmentDetailViewController, animated: true)
        }
        else {
            presentAlert(title: String(localized: "improperDateErrorMessage"))
        }
    }
    
    private func properDateTime() -> Bool {
        let currentDate = Date()
        if let date = selectedSocket?.appointmentDateString, let time = selectedSocketTimeSlot?.timeString { return
            compareDateFormatter.date(from: date + time)! >= currentDate
        }
        return false
    }
    
    var pickedDate: Date?
    let compareDateFormatter = DateFormatter()
    let textFieldDateFormatter = DateFormatter()
    let apiDateFormatter = DateFormatter()
    
    var socket1: SocketModel?
    var socket2: SocketModel?
    var socket3: SocketModel?
    
    var selectedStation: APIAllStationModel?
    var selectedSocket: SocketModel?
    var selectedSocketTimeSlot: SocketTimeSlot?
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        compareDateFormatter.dateFormat = "yyyy-MM-ddHH:mm"
        textFieldDateFormatter.dateFormat = "d MMM yyyy"
        apiDateFormatter.dateFormat = "yyyy-MM-dd"
        
        dateTextField.attributedPlaceholder = NSAttributedString(
            string: String(localized: "enterDatePlaceholder"),
            attributes: [
                .font: UIFont.systemFont(ofSize: 18),
                .foregroundColor: #colorLiteral(red: 0.7176470588, green: 0.7411764706, blue: 0.7960784314, alpha: 1)
            ]
        )
        dateTextField.delegate = self
        dateTextField.inputAccessoryView = datePickerToolBar
        dateTextField.inputView = datePicker
        
        datePickerDoneItem.action = #selector(datePickerDoneItemTapped)
        datePickerDoneItem.target = self
        
        socketSlotsColletionView1.dataSource = self
        socketSlotsColletionView2.dataSource = self
        socketSlotsColletionView3.dataSource = self
        socketSlotsColletionView1.delegate = self
        socketSlotsColletionView2.delegate = self
        socketSlotsColletionView3.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.tintColor = UIColor.lightGray
    }
    
    private func fetchSocketAvailability() {
        guard let userId = UserDefaultsLogin.userId else { return }
        guard let pickedDate = pickedDate else { return }
        guard let stationId = selectedStation?.id else { return }
        
        view.isUserInteractionEnabled = false
        activityIndicator.startAnimating()
        
        let dateString = apiDateFormatter.string(from: pickedDate)
        
        API.stationAvailability(userId: userId, date: dateString, stationId: stationId, completion: { result in
            switch result {
            case .success(let station):
                self.configureStationData(station)
            case .failure(_):
                self.presentAlert(title: String(localized: "genericErrorMessage"))
            }
            
            self.continueButton.isEnabled = false
            self.view.isUserInteractionEnabled = true
            self.activityIndicator.stopAnimating()
        })
    }
    
    private func configureStationData(_ station: APIStationTimeAvailabilityModel) {
        socket1 = nil
        socket2 = nil
        socket3 = nil
        selectedSocket = nil
        selectedSocketTimeSlot = nil
        
        if station.sockets.count > 0 {
            let apiSocket1 = station.sockets[0]
            socket1 = SocketModel(
                apiSocket: apiSocket1,
                appointmentDateString: apiSocket1.day.date,
                timeSlots: apiSocket1.day.timeSlots
            )
        }
        if station.sockets.count > 1 {
            let apiSocket2 = station.sockets[1]
            socket2 = SocketModel(
                apiSocket: apiSocket2,
                appointmentDateString: apiSocket2.day.date,
                timeSlots: apiSocket2.day.timeSlots
            )
        }
        if station.sockets.count > 2 {
            let apiSocket3 = station.sockets[2]
            socket3 = SocketModel(
                apiSocket: apiSocket3,
                appointmentDateString: apiSocket3.day.date,
                timeSlots: apiSocket3.day.timeSlots
            )
        }
        
        setSocketInfo(label: socketInfoLabel1, socket: socket1)
        setSocketInfo(label: socketInfoLabel2, socket: socket2)
        setSocketInfo(label: socketInfoLabel3, socket: socket3)
        
        reloadSlotCollectionViews()
    }
    
    private func setSocketInfo(label: UILabel, socket: SocketModel?) {
        if let socket = socket {
            label.text = socket.apiSocket.chargeType + "•" + socket.apiSocket.socketType
        }
        else {
            label.text = "-"
        }
    }
    
    private func reloadSlotCollectionViews() {
        socketSlotsColletionView1.reloadData()
        socketSlotsColletionView2.reloadData()
        socketSlotsColletionView3.reloadData()
    }
    
    private func presentAlert(title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: String(localized: "alertActionOkayTitle") , style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    @objc private func datePickerDoneItemTapped() {
        dateTextField.endEditing(true)
    }
    
}

extension DateAndTimeSelectionViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        dateTextField.text = textFieldDateFormatter.string(from: datePicker.date)
        pickedDate = datePicker.date
        fetchSocketAvailability()
    }
    
}

extension DateAndTimeSelectionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeSlotCollectionViewCell", for: indexPath) as! TimeSlotCollectionViewCell
        let socket = socket(for: collectionView)!
        let socketTimeSlot = socket.timeSlots[indexPath.item]
        cell.setSelected(socketTimeSlot.isSelected)
        cell.titleLabel.text = socketTimeSlot.timeString
        cell.titleLabel.textColor = !socketTimeSlot.isOccupied ? .white : #colorLiteral(red: 0.7176470588, green: 0.7411764706, blue: 0.7960784314, alpha: 1)
        cell.isUserInteractionEnabled = !socketTimeSlot.isOccupied
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return socket(for: collectionView)?.timeSlots.count ?? 0
    }
    
    private func socket(for collectionView: UICollectionView) -> SocketModel? {
        if collectionView == socketSlotsColletionView1 {
            return socket1
        }
        else if collectionView == socketSlotsColletionView2 {
            return socket2
        }
        else if collectionView == socketSlotsColletionView3 {
            return socket3
        }
        return nil
    }
    
}

extension DateAndTimeSelectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        deselectAllSlots()
        let socket = socket(for: collectionView)
        let timeSlot = socket?.timeSlots[indexPath.item]
        timeSlot?.isSelected = true
        selectedSocket = socket
        selectedSocketTimeSlot = timeSlot
        reloadSlotCollectionViews()
        continueButton.isEnabled = true
        dateTextField.endEditing(true)
    }
    
    private func deselectAllSlots() {
        socket1?.timeSlots.forEach({ $0.isSelected = false })
        socket2?.timeSlots.forEach({ $0.isSelected = false })
        socket3?.timeSlots.forEach({ $0.isSelected = false })
    }
    
}
