
import UIKit

//struct FileFormat {
//    static func getFileFormat(fileUrl: String) -> String {
//        let link = fileUrl.components(separatedBy: "?").first ?? ""
//        //addingPercentEncoding
//        let fileType = URL(string: link)?.lastPathComponent.components(separatedBy: ".").last ?? ""
//        return fileType
//    }
//    static func getMediaType(url: String) -> (MediaType, CGFloat) {
//        
//        let fileType = FileFormat.getFileFormat(fileUrl: url).lowercased()
//        
//        switch fileType {
//        case "jpeg", "jpg", "png", "gif", "tiff", "bmp":
//            return (.Image,150)
//        case "m4a", "mp3", "wav", "wma", "aac", "mpeg":
//            return (.Audio,30)
//        case "mov", "mp4", "mpeg4", "wmv", "mkv", "Webm", "flv", "3gb":
//            return (.Video,40)
//        case "doc", "docx", "xls", "xlsx", "ppt", "pptx", "pdf":
//            return (.Application,40)
//        case "txt":
//            return (.Text,40)
//        default:
//            return (.None,0)
//            
//        }
//    }
//}
//
