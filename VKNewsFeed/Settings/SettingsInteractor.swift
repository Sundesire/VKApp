//
//  SettingsInteractor.swift
//  VKNewsFeed
//
//  Created by Иван Бабушкин on 28.11.2019.
//  Copyright (c) 2019 Ivan Babushkin. All rights reserved.
//

import UIKit

protocol SettingsBusinessLogic {
  func makeRequest(request: Settings.Model.Request.RequestType)
}

class SettingsInteractor: SettingsBusinessLogic {

  var presenter: SettingsPresentationLogic?
  var service: SettingsService?
  
  func makeRequest(request: Settings.Model.Request.RequestType) {
    if service == nil {
      service = SettingsService()
    }
  }
  
}
