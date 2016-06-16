//
//  SQLite.swift
//  WolfCore
//
//  Created by Robert McNally on 6/6/15.
//  Copyright © 2016 Arciem. All rights reserved.
//

import Foundation

//
// Useful: http://stackoverflow.com/questions/24102775/accessing-an-sqlite-database-in-swift
//

public enum SQLiteReturnCode: Int32 {
    case OK = 0     /* Successful result */

    case Error      /* SQL error or missing database */
    case Internal   /* Internal logic error in SQLite */
    case Perm       /* Access permission denied */
    case Abort      /* Callback routine requested an abort */
    case Busy       /* The database file is locked */
    case Locked     /* A table in the database is locked */
    case NoMem      /* A malloc() failed */
    case ReadOnly   /* Attempt to write a readonly database */
    case Interrupt  /* Operation terminated by sqlite3_interrupt()*/
    case IOErr      /* Some kind of disk I/O error occurred */
    case Corrupt    /* The database disk image is malformed */
    case NotFound   /* Unknown opcode in sqlite3_file_control() */
    case Full       /* Insertion failed because database is full */
    case CantOpen   /* Unable to open the database file */
    case Protocol   /* Database lock protocol error */
    case Empty      /* Database is empty */
    case Schema     /* The database schema changed */
    case TooBig     /* String or BLOB exceeds size limit */
    case Constraint /* Abort due to constraint violation */
    case Mismatch   /* Data type mismatch */
    case Misuse     /* Library used incorrectly */
    case NoLFS      /* Uses OS features not supported on host */
    case Auth       /* Authorization denied */
    case Format     /* Auxiliary database format error */
    case Range      /* 2nd parameter to sqlite3_bind out of range */
    case NotADB     /* File opened that is not a database file */
    case Notice     /* Notifications from sqlite3_log() */
    case Warning    /* Warnings from sqlite3_log() */
}

public enum SQLiteStepResult: Int32 {
    case Row = 100  /* sqlite3_step() has another row ready */
    case Done       /* sqlite3_step() has finished executing */
}

let SQLITE_STATIC = unsafeBitCast(0, sqlite3_destructor_type.self) // swiftlint:disable:this variable_name
let SQLITE_TRANSIENT = unsafeBitCast(-1, sqlite3_destructor_type.self) // swiftlint:disable:this variable_name

extension SQLiteReturnCode: Error {
    public var message: String {
        return "\(rawValue)"
    }
}

extension SQLiteReturnCode : CustomStringConvertible {
    public var description: String {
        return "\(message)"
    }
}

public class SQLite {
    private var db: COpaquePointer = nil

    public init(fileURL: URL) throws {
        let error = SQLiteReturnCode(rawValue: sqlite3_open(fileURL.path!, &db))!
        guard error == .OK else {
            throw error
        }
    }

    deinit {
        sqlite3_close(db)
    }

    public func exec(sql: String) throws {
        let error = SQLiteReturnCode(rawValue: sqlite3_exec(db, sql, nil, nil, nil))!
        guard error == .OK else {
            throw error
        }
    }

    public func prepare(sql: String) throws -> Statement {
        return try Statement(db: self, sql: sql)
    }

    public func beginTransaction() {
        try! exec("BEGIN")
    }

    public func commitTransaction() {
        try! exec("COMMIT")
    }

    public func rollbackTransaction() {
        try! exec("ROLLBACK")
    }

    public class Statement {
        let db: SQLite
        let sql: String
        var statement: COpaquePointer = nil

        init(db: SQLite, sql: String) throws {
            self.db = db
            self.sql = sql
            let error = SQLiteReturnCode(rawValue: sqlite3_prepare_v2(db.db, sql, -1, &statement, nil))!
            guard error == .OK else {
                throw error
            }
        }

        deinit {
            sqlite3_finalize(statement)
        }

        private func indexForParameterName(name: String) -> Int {
            return Int(sqlite3_bind_parameter_index(statement, ":\(name)"))
        }

        public func bindParameterIndex(index: Int, toInt n: Int) {
            sqlite3_bind_int(statement, Int32(index), Int32(n))
        }

        public func bindParameterIndex(index: Int, toURL url: URL) {
            sqlite3_bind_text(statement, Int32(index), url.absoluteString, -1, SQLITE_TRANSIENT)
        }

        public func bindParameterIndex(index: Int, toBLOB data: Data) {
            sqlite3_bind_blob(statement, Int32(index), UnsafePointer<Void>(data.bytes), Int32(data.length), SQLITE_TRANSIENT)
        }

        public func bindParameterName(name: String, toInt n: Int) {
            bindParameterIndex(indexForParameterName(name), toInt: n)
        }

        public func bindParameterName(name: String, toURL url: URL) {
            bindParameterIndex(indexForParameterName(name), toURL: url)
        }

        public func bindParameterName(name: String, toBLOB data: Data) {
            bindParameterIndex(indexForParameterName(name), toBLOB: data)
        }

        public func step() throws -> SQLiteStepResult {
            let rawReturnCode = sqlite3_step(statement)
            if let stepResult = SQLiteStepResult(rawValue: rawReturnCode) {
                return stepResult
            } else {
                throw SQLiteReturnCode(rawValue: rawReturnCode)!
            }
        }

        public func reset() {
            sqlite3_reset(statement)
        }

        public var columnCount: Int {
            return Int(sqlite3_column_count(statement))
        }

        public func columnNameForIndex(index: Int) -> String {
            let s = sqlite3_column_name(statement, Int32(index))
            return String.fromCString(s)!
        }

        public func intValueForColumnIndex(index: Int) -> Int {
            return Int(sqlite3_column_int(statement, Int32(index)))
        }

        public func stringValueForColumnIndex(index: Int) -> String? {
            let s = sqlite3_column_text(statement, Int32(index))
            if s != nil {
                return String.fromCString(UnsafePointer<Int8>(s))!
            } else {
                return nil
            }
        }

        public func urlValueForColumnIndex(index: Int) -> URL? {
            if let string = stringValueForColumnIndex(index) {
                return URL(string: string)
            } else {
                return nil
            }
        }

        public func blobValueForColumnIndex(index: Int) -> Data? {
            let b = sqlite3_column_blob(statement, Int32(index))
            if b != nil {
                let len = Int(sqlite3_column_bytes(statement, Int32(index)))
                return Data(bytes: b, length: len)
            } else {
                return nil
            }
        }
    }
}
