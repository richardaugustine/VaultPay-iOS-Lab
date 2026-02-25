import Foundation

func createDemoBackupFile() {
    let text = "DEMO_SECRET=1234"

    if let docs = FileManager.default.urls(for: .documentDirectory,
                                           in: .userDomainMask).first {
        let fileURL = docs.appendingPathComponent("demo.txt")
        try? text.write(to: fileURL, atomically: true, encoding: .utf8)
    }
}
