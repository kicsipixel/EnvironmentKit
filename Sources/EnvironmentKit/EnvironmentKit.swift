//
//  EnvironmentKit.swift
//
//
//  Created by Szabolcs Tóth on 19.08.2024.
//  Copyright © 2024 Szabolcs Tóth. All rights reserved.
//

import Foundation
import Hummingbird

/// Different environments:
/// - production: running in Docker
/// - development: only PostgreSQL database running in Docker
/// - test: only test (non-persistent) database running in Docker
public enum AppEnvironments: String {
    case production
    case development
    case test
}

public protocol AppEnvironmentsProtocol {
    var applicationEnvironment: AppEnvironments { get }
    var databasePort: Int { get }
}

/// Set the required environment and database port will set accordingly
public struct AppEnv: AppEnvironmentsProtocol {
    public init(applicationEnvironment: AppEnvironments, env: Environment) {
        self.applicationEnvironment = applicationEnvironment
        self.env = env
    }
    
    public var applicationEnvironment: AppEnvironments
    
    public let env: Environment
    
    public var hostname: String {
        switch applicationEnvironment {
        case .production:
            env.get("DATABASE_HOST") ?? "localhost"
        case .development, .test:
            "localhost"
        }
    }
    
    public var databasePort: Int {
        switch applicationEnvironment {
        case .production, .development:
            return 5432
        case .test:
            return 5433
        }
    }
}
