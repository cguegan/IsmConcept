//
//  RemoteConfigService.swift
//  iChecks
//
//  Created by Christophe Guégan on 11/09/2024.
//

import Foundation

@Observable
class RemoteConfigService {
    var welcomeMessage: String = """
The ISM Code establishes safety-management objectives and requires a safety management system (SMS) to be established by **Yachting Concept Monaco** who has assumed the responsibility for operating yachts (>500GT) and has agreed to take over all duties and responsibility imposed by the Code. 

The purpose of the **International Safety Management** (ISM) Code is to provide an international standard for the safe management and operation of ships and for pollution prevention.
"""
    
    var companyAddress = "Yachting Concept Monaco SARL\n36 Rue Grimaldi\n98000 Monaco"
    var companyIMONumber = "6151749"
    var copyright = """
This set of documentation is strongly protected by copyright laws and belongs to **Yachting Concept Monaco**. Any unauthorized use, copying, modification, or distribution of this documentation is strictly prohibited.
"""
    var dpaOnWatch = "Christophe Guegan"
    var email = "dpa@yachtingconceptmonaco.com"
    var emergencyNumber = "+377 99 92 36 48"
    
}
