//
//  Command.swift
//  Redux
//
//  Created by SSD on 5/23/19.
//  Copyright © 2019 beard. All rights reserved.
//

import Foundation

protocol Command {
    var file: StaticString? { get set }
    var function: StaticString? { get set }
    var line: UInt? { get set}
}

extension Command {
        
    var file: StaticString? {
        get { return nil } set { }
    }
    
    var function: StaticString? {
        get { return nil } set { }
    }
    
    var line: UInt? {
        get { return nil } set { }
    }
}

extension Command {
     var debugDescription: String {
        return """
        \(String(describing: type(of: self)))(
        file: \(String(describing: file)),
        function: \(String(describing: function)),
        line: \(String(describing: line))
        )
        """
    }
}

protocol CommandableWithParameters: Command {
    associatedtype Response
    var callback: ((Response) -> Void)? { get set}
    init()
    func execute(_ response: Response)
}

extension CommandableWithParameters {
    
    init?(
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line,
        _ callback: @escaping (Response) -> Void
        ) {
        self.init()
        self.callback = callback
        self.file = file
        self.function = function
        self.line = line
    }
    
    func execute(_ response: Response) {
        callback?(response)
    }
}

protocol CommandableWithoutParameters: Command {
    var callback: (() -> Void)? { get set}
    init()
    func execute()
}

extension CommandableWithoutParameters {
    
    init?(
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line,
       _ callback: @escaping () -> Void
        ) {
        self.init()
        self.callback = callback
        self.file = file
        self.function = function
        self.line = line
    }
    
    func execute() {
        callback?()
    }
}

final class CommandsDispatcher {
   private var commands = [Command?]()
    
    func set(_ commands: [Command?]) {
        self.commands = commands
    }
    
    func getCommand<T: Command>(_ type: T.Type) -> T? {
        
        guard let index = commands.firstIndex(where: { $0.self is T } ) else {
            return nil
        }
 
        return (commands[index] as? T).self
    }
}

