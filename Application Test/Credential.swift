//
//  Credential.swift
//  DCBExternalApplication
//
//  Created by Pierre Jonny Cau on 12/03/2020.
//  Copyright © 2020 Buongiorno. All rights reserved.
//

import DCBApiExt
import Foundation

struct Credential {
    static let dcbClient: DCBApiClient = {
        let domain = URL(string: "http://acq.kidjo.tv")!

        return DCBApiClient(baseDomain: domain,
                            confInfoDomain: domain,
                            apikey: "556a42415047494483",
                            catalog: "fr-kidjoadv",
                            country: "fr",
                            namespace: "external")
    }()

    static let logging = true
}
