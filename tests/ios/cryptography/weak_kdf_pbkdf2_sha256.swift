import CommonCrypto
import Foundation

let password = "password"
let salt = "saltData".data(using: .utf8)!
let keyByteCount = 16
var derivedKey = [UInt8](repeating: 0, count: keyByteCount)

// ruleid: weak_kdf_pbkdf2_sha256
CCKeyDerivationPBKDF(CCPBKDFAlgorithm(kCCPBKDF2),password, password.count, [UInt8](salt), salt.count, CCPseudoRandomAlgorithm(kCCPRFHmacAlgSHA256), 100_000, &derivedKey, derivedKey.count)

// ok: weak_kdf_pbkdf2_sha256
CCKeyDerivationPBKDF(CCPBKDFAlgorithm(kCCPBKDF2),password, password.count, [UInt8](salt), salt.count, CCPseudoRandomAlgorithm(kCCPRFHmacAlgSHA256), 1_000_000, &derivedKey, derivedKey.count)