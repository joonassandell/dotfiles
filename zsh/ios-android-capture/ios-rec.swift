// Records the screen of a USB-connected iPhone to a .mov file, the same way QuickTime's
// "New Movie Recording" does. Stops on Ctrl+C. Built and run by `ios-rec` in ios.zsh.
//
// Usage: ios-rec <output.mov> [device name]
// Without a device name, the only connected iPhone is used, or it asks when there are several.
// With IOS_REC_PICKED set to a path, the name of the phone used is written there.

import AVFoundation
import CoreMediaIO

func fail(_ message: String) -> Never {
  FileHandle.standardError.write((message + "\n").data(using: .utf8)!)
  exit(1)
}

let args = CommandLine.arguments
guard args.count >= 2 else { fail("Usage: ios-rec <output.mov> [device name]") }
let output = URL(fileURLWithPath: args[1])
let wanted = args.count >= 3 ? args[2] : nil

// iPhone screens are hidden from apps until they opt in.
var prop = CMIOObjectPropertyAddress(
  mSelector: CMIOObjectPropertySelector(kCMIOHardwarePropertyAllowScreenCaptureDevices),
  mScope: CMIOObjectPropertyScope(kCMIOObjectPropertyScopeGlobal),
  mElement: CMIOObjectPropertyElement(kCMIOObjectPropertyElementMain))
var allow: UInt32 = 1
CMIOObjectSetPropertyData(CMIOObjectID(kCMIOObjectSystemObject), &prop, 0, nil, 4, &allow)

// The phone takes a moment to show up after the opt-in.
func screens() -> [AVCaptureDevice] {
  AVCaptureDevice.DiscoverySession(deviceTypes: [.external], mediaType: .muxed, position: .unspecified)
    .devices.filter { $0.modelID == "iOS Device" }
}
var found: [AVCaptureDevice] = []
for _ in 0..<10 {
  found = screens()
  if let name = wanted { found = found.filter { $0.localizedName == name || $0.uniqueID == name } }
  if !found.isEmpty { break }
  RunLoop.current.run(until: Date().addingTimeInterval(0.5))
}
if found.isEmpty {
  fail(wanted.map { "No iPhone named \($0) found. Connect it with a USB cable and unlock it." }
    ?? "No iPhone found. Connect it with a USB cable and unlock it.")
}
// Phones show up one by one, so give a second one a moment before deciding there is only one.
if wanted == nil {
  RunLoop.current.run(until: Date().addingTimeInterval(1))
  found = screens()
}
// With several phones, ask which one (or fail when there is no one to ask).
var device = found[0]
if found.count > 1 {
  let names = found.map(\.localizedName)
  guard isatty(STDIN_FILENO) != 0 else {
    fail("Several iPhones connected. Set IOS_DEVICE to one of: \(names.joined(separator: ", "))")
  }
  FileHandle.standardError.write("Several iPhones connected:\n".data(using: .utf8)!)
  for (i, name) in names.enumerated() {
    FileHandle.standardError.write("  \(i + 1)) \(name)\n".data(using: .utf8)!)
  }
  FileHandle.standardError.write("Which one? ".data(using: .utf8)!)
  guard let line = readLine(), let pick = Int(line.trimmingCharacters(in: .whitespaces)),
        found.indices.contains(pick - 1) else { fail("No phone picked.") }
  device = found[pick - 1]
}
if let path = ProcessInfo.processInfo.environment["IOS_REC_PICKED"] {
  try? device.localizedName.write(toFile: path, atomically: true, encoding: .utf8)
}

let session = AVCaptureSession()
guard let input = try? AVCaptureDeviceInput(device: device), session.canAddInput(input) else {
  fail("Could not open \(device.localizedName). Is it unlocked, and does the terminal have camera access?")
}
session.addInput(input)
let movie = AVCaptureMovieFileOutput()
guard session.canAddOutput(movie) else { fail("Could not record from \(device.localizedName).") }
session.addOutput(movie)
// The default is close to uncompressed. H.264 keeps the file small.
if let video = movie.connection(with: .video) {
  movie.setOutputSettings([AVVideoCodecKey: AVVideoCodecType.h264], for: video)
}

final class Delegate: NSObject, AVCaptureFileOutputRecordingDelegate {
  // Printed only now: finding the phone and warming up takes a few seconds.
  func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo url: URL,
                  from connections: [AVCaptureConnection]) {
    print("Recording \(device.localizedName). Press Ctrl+C to stop.")
    fflush(stdout)
  }

  func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo url: URL,
                  from connections: [AVCaptureConnection], error: Error?) {
    if let error = error as NSError?,
       (error.userInfo[AVErrorRecordingSuccessfullyFinishedKey] as? Bool) != true {
      fail("Recording failed: \(error.localizedDescription)")
    }
    exit(0)
  }
}
let delegate = Delegate()

// Ctrl+C stops the recording; the file is finished in the delegate.
signal(SIGINT, SIG_IGN)
let stop = DispatchSource.makeSignalSource(signal: SIGINT, queue: .main)
stop.setEventHandler { movie.stopRecording() }
stop.resume()

session.startRunning()
// Recording right away fails with "Cannot Record": the phone needs a moment to start sending.
RunLoop.current.run(until: Date().addingTimeInterval(1.5))
try? FileManager.default.removeItem(at: output)
movie.startRecording(to: output, recordingDelegate: delegate)
dispatchMain()
