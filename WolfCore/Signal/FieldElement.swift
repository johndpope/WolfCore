//
//  FieldElement.swift
//  WolfCore
//
//  Created by Robert McNally on 7/10/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import Foundation

public struct FieldElement {
    public let t: [Int]

    public init() {
        t = [Int](repeating: 0, count: 10)
    }

    public init(_ i: [Int]) {
        assert(i.count == 10)
        t = i
    }

    private init(_ i: [Int64]) {
        t = [Int(i[0]), Int(i[1]), Int(i[2]), Int(i[3]), Int(i[4]), Int(i[5]), Int(i[6]), Int(i[7]), Int(i[8]), Int(i[9])]
    }

    public subscript(index: Int) -> Int {
        return t[index]
    }

    public var oneIfNegative: Int { return Int((self |> FieldElement.toData)[0]) & 1 }

    public static let zero = FieldElement()
    public static let one = FieldElement([1, 0, 0, 0, 0, 0, 0, 0, 0, 0])
    public static let d2 = FieldElement([-21827239, -5839606, -30745221, 13898782, 229458, 15978800, -12551817, -6495438, 29715968, 9444199])

    public static let zeroData = Data(bytes: [Byte](repeating: 0, count: 32))
}

extension FieldElement {
    /// returns f iff b == 0, g iff b == 1, otherwise undefined
    public static func pick(_ f: FieldElement, _ g: FieldElement, b: Int) -> FieldElement {
        let x = xored(f, g)
        let x2 = masked(x, -b)
        return xored(f, x2)
    }

    public static func oneIfEquals(_ f: FieldElement, _ g: FieldElement) -> Int {
        return oneIfEquals(f |> toData, g |> toData)
    }

    /// monadic transformer
    public static func oneIfZero(_ f: FieldElement) -> Int {
        return oneIfEquals(f |> toData, zeroData)
    }
}

extension FieldElement {
    public static func added(_ f: FieldElement, _ g: FieldElement) -> FieldElement {
        var h = [Int](repeating: 0, count: 10)
        for i in 0 ..< 10 {
            h[i] = f[i] + g[i]
        }
        return FieldElement(h)
    }

    public static func subtracted(_ f: FieldElement, _ g: FieldElement) -> FieldElement {
        var h = [Int](repeating: 0, count: 10)
        for i in 0 ..< 10 {
            h[i] = f[i] - g[i]
        }
        return FieldElement(h)
    }

    /// monadic transformer
    public static func negated(_ f: FieldElement) -> FieldElement {
        return FieldElement(f.t.map { -$0 })
    }

    public static func xored(_ f: FieldElement, _ g: FieldElement) -> FieldElement {
        var h = [Int](repeating: 0, count: 10)
        for i in 0 ..< 10 {
            h[i] = f[i] ^ g[i]
        }
        return FieldElement(h)
    }

    public static func masked(_ f: FieldElement, _ m: Int) -> FieldElement {
        var h = [Int](repeating: 0, count: 10)
        for i in 0 ..< 10 {
            h[i] = f[i] & m
        }
        return FieldElement(h)
    }
}

extension FieldElement {
    /// monadic transformer
    public static func fromData(_ d: Data) -> FieldElement {
        func load3(_ i: UnsafePointer<Byte>) -> Int64 {
            var result = Int64(i[0])
            result |= Int64(i[1]) << 8
            result |= Int64(i[2]) << 16
            return result
        }

        func load4(_ i: UnsafePointer<Byte>) -> Int64 {
            var result = Int64(i[0])
            result |= Int64(i[1]) << 8
            result |= Int64(i[2]) << 16
            result |= Int64(i[3]) << 24
            return result
        }

        return d.withUnsafeBytes { (s: UnsafePointer<Byte>) -> FieldElement in
            var h0 = load4(s)
            var h1 = load3(s + 4) << 6
            var h2 = load3(s + 7) << 5
            var h3 = load3(s + 10) << 3
            var h4 = load3(s + 13) << 2
            var h5 = load4(s + 16)
            var h6 = load3(s + 20) << 7
            var h7 = load3(s + 23) << 5
            var h8 = load3(s + 26) << 4
            var h9 = (load3(s + 29) & 8388607) << 2

            let carry9 = (h9 + (1 << 24)) >> 25; h0 += carry9 * 19; h9 -= carry9 << 25
            let carry1 = (h1 + (1 << 24)) >> 25; h2 += carry1; h1 -= carry1 << 25
            let carry3 = (h3 + (1 << 24)) >> 25; h4 += carry3; h3 -= carry3 << 25
            let carry5 = (h5 + (1 << 24)) >> 25; h6 += carry5; h5 -= carry5 << 25
            let carry7 = (h7 + (1 << 24)) >> 25; h8 += carry7; h7 -= carry7 << 25

            let carry0 = (h0 + (1 << 25)) >> 26; h1 += carry0; h0 -= carry0 << 26
            let carry2 = (h2 + (1 << 25)) >> 26; h3 += carry2; h2 -= carry2 << 26
            let carry4 = (h4 + (1 << 25)) >> 26; h5 += carry4; h4 -= carry4 << 26
            let carry6 = (h6 + (1 << 25)) >> 26; h7 += carry6; h6 -= carry6 << 26
            let carry8 = (h8 + (1 << 25)) >> 26; h9 += carry8; h8 -= carry8 << 26

            return FieldElement([h0, h1, h2, h3, h4, h5, h6, h7, h8, h9])
        }
    }

    /// monadic transformer
    public static func toData(_ h: FieldElement) -> Data {
        var h0 = h[0]
        var h1 = h[1]
        var h2 = h[2]
        var h3 = h[3]
        var h4 = h[4]
        var h5 = h[5]
        var h6 = h[6]
        var h7 = h[7]
        var h8 = h[8]
        var h9 = h[9]

        var q = (19 * h9 + (1 << 24)) >> 25
        q = (h0 + q) >> 26
        q = (h1 + q) >> 25
        q = (h2 + q) >> 26
        q = (h3 + q) >> 25
        q = (h4 + q) >> 26
        q = (h5 + q) >> 25
        q = (h6 + q) >> 26
        q = (h7 + q) >> 25
        q = (h8 + q) >> 26
        q = (h9 + q) >> 25

        h0 += 19 * q

        let carry0 = h0 >> 26; h1 += carry0; h0 -= carry0 << 26
        let carry1 = h1 >> 25; h2 += carry1; h1 -= carry1 << 25
        let carry2 = h2 >> 26; h3 += carry2; h2 -= carry2 << 26
        let carry3 = h3 >> 25; h4 += carry3; h3 -= carry3 << 25
        let carry4 = h4 >> 26; h5 += carry4; h4 -= carry4 << 26
        let carry5 = h5 >> 25; h6 += carry5; h5 -= carry5 << 25
        let carry6 = h6 >> 26; h7 += carry6; h6 -= carry6 << 26
        let carry7 = h7 >> 25; h8 += carry7; h7 -= carry7 << 25
        let carry8 = h8 >> 26; h9 += carry8; h8 -= carry8 << 26
        let carry9 = h9 >> 25;               h9 -= carry9 << 25

        var s = [Byte](repeating: 0, count: 32)
        s[0] = Byte(h0 >> 0)
        s[1] = Byte(h0 >> 8)
        s[2] = Byte(h0 >> 16)
        s[3] = Byte((h0 >> 24) | (h1 << 2))
        s[4] = Byte(h1 >> 6)
        s[5] = Byte(h1 >> 14)
        s[6] = Byte((h1 >> 22) | (h2 << 3))
        s[7] = Byte(h2 >> 5)
        s[8] = Byte(h2 >> 13)
        s[9] = Byte((h2 >> 21) | (h3 << 5))
        s[10] = Byte(h3 >> 3)
        s[11] = Byte(h3 >> 11)
        s[12] = Byte((h3 >> 19) | (h4 << 6))
        s[13] = Byte(h4 >> 2)
        s[14] = Byte(h4 >> 10)
        s[15] = Byte(h4 >> 18)
        s[16] = Byte(h5 >> 0)
        s[17] = Byte(h5 >> 8)
        s[18] = Byte(h5 >> 16)
        s[19] = Byte((h5 >> 24) | (h6 << 1))
        s[20] = Byte(h6 >> 7)
        s[21] = Byte(h6 >> 15)
        s[22] = Byte((h6 >> 23) | (h7 << 3))
        s[23] = Byte(h7 >> 5)
        s[24] = Byte(h7 >> 13)
        s[25] = Byte((h7 >> 21) | (h8 << 4))
        s[26] = Byte(h8 >> 4)
        s[27] = Byte(h8 >> 12)
        s[28] = Byte((h8 >> 20) | (h9 << 6))
        s[29] = Byte(h9 >> 2)
        s[30] = Byte(h9 >> 10)
        s[31] = Byte(h9 >> 18)

        return Data(bytes: s)
    }

    private static let oneIfZero: Data = {
        var a = [Byte](repeating: 0, count: 256)
        a[0] = 1
        return Data(bytes: a)
    }()

    /// Returns 1 iff f == g, else 0.
    private static func oneIfEquals(_ f: Data, _ g: Data) -> Int {
        let fp: UnsafePointer<Byte> = f.withUnsafeBytes { $0 }
        let gp: UnsafePointer<Byte> = g.withUnsafeBytes { $0 }
        var diff: Byte = 0
        diff |= fp[0] ^ gp[0]
        diff |= fp[1] ^ gp[1]
        diff |= fp[2] ^ gp[2]
        diff |= fp[3] ^ gp[3]
        diff |= fp[4] ^ gp[4]
        diff |= fp[5] ^ gp[5]
        diff |= fp[6] ^ gp[6]
        diff |= fp[7] ^ gp[7]
        diff |= fp[8] ^ gp[8]
        diff |= fp[9] ^ gp[9]
        diff |= fp[10] ^ gp[10]
        diff |= fp[11] ^ gp[11]
        diff |= fp[12] ^ gp[12]
        diff |= fp[13] ^ gp[13]
        diff |= fp[14] ^ gp[14]
        diff |= fp[15] ^ gp[15]
        diff |= fp[16] ^ gp[16]
        diff |= fp[17] ^ gp[17]
        diff |= fp[18] ^ gp[18]
        diff |= fp[19] ^ gp[19]
        diff |= fp[20] ^ gp[20]
        diff |= fp[21] ^ gp[21]
        diff |= fp[22] ^ gp[22]
        diff |= fp[23] ^ gp[23]
        diff |= fp[24] ^ gp[24]
        diff |= fp[25] ^ gp[25]
        diff |= fp[26] ^ gp[26]
        diff |= fp[27] ^ gp[27]
        diff |= fp[28] ^ gp[28]
        diff |= fp[29] ^ gp[29]
        diff |= fp[30] ^ gp[30]
        diff |= fp[31] ^ gp[31]
        return Int(oneIfZero[Int(diff)])
    }
}

extension FieldElement {
    public static func multiplied(_ f: FieldElement, _ g: FieldElement) -> FieldElement {
        let f0 = Int64(f[0])
        let f1 = Int64(f[1])
        let f2 = Int64(f[2])
        let f3 = Int64(f[3])
        let f4 = Int64(f[4])
        let f5 = Int64(f[5])
        let f6 = Int64(f[6])
        let f7 = Int64(f[7])
        let f8 = Int64(f[8])
        let f9 = Int64(f[9])

        let g0 = Int64(g[0])
        let g1 = Int64(g[1])
        let g2 = Int64(g[2])
        let g3 = Int64(g[3])
        let g4 = Int64(g[4])
        let g5 = Int64(g[5])
        let g6 = Int64(g[6])
        let g7 = Int64(g[7])
        let g8 = Int64(g[8])
        let g9 = Int64(g[9])

        let g1_19 = 19 * g1
        let g2_19 = 19 * g2
        let g3_19 = 19 * g3
        let g4_19 = 19 * g4
        let g5_19 = 19 * g5
        let g6_19 = 19 * g6
        let g7_19 = 19 * g7
        let g8_19 = 19 * g8
        let g9_19 = 19 * g9

        let f1_2 = 2 * f1
        let f3_2 = 2 * f3
        let f5_2 = 2 * f5
        let f7_2 = 2 * f7
        let f9_2 = 2 * f9

        let f0g0    = f0   * g0
        let f0g1    = f0   * g1
        let f0g2    = f0   * g2
        let f0g3    = f0   * g3
        let f0g4    = f0   * g4
        let f0g5    = f0   * g5
        let f0g6    = f0   * g6
        let f0g7    = f0   * g7
        let f0g8    = f0   * g8
        let f0g9    = f0   * g9
        let f1g0    = f1   * g0
        let f1g1_2  = f1_2 * g1
        let f1g2    = f1   * g2
        let f1g3_2  = f1_2 * g3
        let f1g4    = f1   * g4
        let f1g5_2  = f1_2 * g5
        let f1g6    = f1   * g6
        let f1g7_2  = f1_2 * g7
        let f1g8    = f1   * g8
        let f1g9_38 = f1_2 * g9_19
        let f2g0    = f2   * g0
        let f2g1    = f2   * g1
        let f2g2    = f2   * g2
        let f2g3    = f2   * g3
        let f2g4    = f2   * g4
        let f2g5    = f2   * g5
        let f2g6    = f2   * g6
        let f2g7    = f2   * g7
        let f2g8_19 = f2   * g8_19
        let f2g9_19 = f2   * g9_19
        let f3g0    = f3   * g0
        let f3g1_2  = f3_2 * g1
        let f3g2    = f3   * g2
        let f3g3_2  = f3_2 * g3
        let f3g4    = f3   * g4
        let f3g5_2  = f3_2 * g5
        let f3g6    = f3   * g6
        let f3g7_38 = f3_2 * g7_19
        let f3g8_19 = f3   * g8_19
        let f3g9_38 = f3_2 * g9_19
        let f4g0    = f4   * g0
        let f4g1    = f4   * g1
        let f4g2    = f4   * g2
        let f4g3    = f4   * g3
        let f4g4    = f4   * g4
        let f4g5    = f4   * g5
        let f4g6_19 = f4   * g6_19
        let f4g7_19 = f4   * g7_19
        let f4g8_19 = f4   * g8_19
        let f4g9_19 = f4   * g9_19
        let f5g0    = f5   * g0
        let f5g1_2  = f5_2 * g1
        let f5g2    = f5   * g2
        let f5g3_2  = f5_2 * g3
        let f5g4    = f5   * g4
        let f5g5_38 = f5_2 * g5_19
        let f5g6_19 = f5   * g6_19
        let f5g7_38 = f5_2 * g7_19
        let f5g8_19 = f5   * g8_19
        let f5g9_38 = f5_2 * g9_19
        let f6g0    = f6   * g0
        let f6g1    = f6   * g1
        let f6g2    = f6   * g2
        let f6g3    = f6   * g3
        let f6g4_19 = f6   * g4_19
        let f6g5_19 = f6   * g5_19
        let f6g6_19 = f6   * g6_19
        let f6g7_19 = f6   * g7_19
        let f6g8_19 = f6   * g8_19
        let f6g9_19 = f6   * g9_19
        let f7g0    = f7   * g0
        let f7g1_2  = f7_2 * g1
        let f7g2    = f7   * g2
        let f7g3_38 = f7_2 * g3_19
        let f7g4_19 = f7   * g4_19
        let f7g5_38 = f7_2 * g5_19
        let f7g6_19 = f7   * g6_19
        let f7g7_38 = f7_2 * g7_19
        let f7g8_19 = f7   * g8_19
        let f7g9_38 = f7_2 * g9_19
        let f8g0    = f8   * g0
        let f8g1    = f8   * g1
        let f8g2_19 = f8   * g2_19
        let f8g3_19 = f8   * g3_19
        let f8g4_19 = f8   * g4_19
        let f8g5_19 = f8   * g5_19
        let f8g6_19 = f8   * g6_19
        let f8g7_19 = f8   * g7_19
        let f8g8_19 = f8   * g8_19
        let f8g9_19 = f8   * g9_19
        let f9g0    = f9   * g0
        let f9g1_38 = f9_2 * g1_19
        let f9g2_19 = f9   * g2_19
        let f9g3_38 = f9_2 * g3_19
        let f9g4_19 = f9   * g4_19
        let f9g5_38 = f9_2 * g5_19
        let f9g6_19 = f9   * g6_19
        let f9g7_38 = f9_2 * g7_19
        let f9g8_19 = f9   * g8_19
        let f9g9_38 = f9_2 * g9_19

        var h0 = f0g0 + f1g9_38 + f2g8_19 + f3g7_38 + f4g6_19 + f5g5_38 + f6g4_19 + f7g3_38 + f8g2_19 + f9g1_38
        var h1 = f0g1 + f1g0    + f2g9_19 + f3g8_19 + f4g7_19 + f5g6_19 + f6g5_19 + f7g4_19 + f8g3_19 + f9g2_19
        var h2 = f0g2 + f1g1_2  + f2g0    + f3g9_38 + f4g8_19 + f5g7_38 + f6g6_19 + f7g5_38 + f8g4_19 + f9g3_38
        var h3 = f0g3 + f1g2    + f2g1    + f3g0    + f4g9_19 + f5g8_19 + f6g7_19 + f7g6_19 + f8g5_19 + f9g4_19
        var h4 = f0g4 + f1g3_2  + f2g2    + f3g1_2  + f4g0    + f5g9_38 + f6g8_19 + f7g7_38 + f8g6_19 + f9g5_38
        var h5 = f0g5 + f1g4    + f2g3    + f3g2    + f4g1    + f5g0    + f6g9_19 + f7g8_19 + f8g7_19 + f9g6_19
        var h6 = f0g6 + f1g5_2  + f2g4    + f3g3_2  + f4g2    + f5g1_2  + f6g0    + f7g9_38 + f8g8_19 + f9g7_38
        var h7 = f0g7 + f1g6    + f2g5    + f3g4    + f4g3    + f5g2    + f6g1    + f7g0    + f8g9_19 + f9g8_19
        var h8 = f0g8 + f1g7_2  + f2g6    + f3g5_2  + f4g4    + f5g3_2  + f6g2    + f7g1_2  + f8g0    + f9g9_38
        var h9 = f0g9 + f1g8    + f2g7    + f3g6    + f4g5    + f5g4    + f6g3    + f7g2    + f8g1    + f9g0

        var carry0 = (h0 + (1 << 25)) >> 26; h1 += carry0; h0 -= carry0 << 26
        var carry4 = (h4 + (1 << 25)) >> 26; h5 += carry4; h4 -= carry4 << 26
        let carry1 = (h1 + (1 << 24)) >> 25; h2 += carry1; h1 -= carry1 << 25
        let carry5 = (h5 + (1 << 24)) >> 25; h6 += carry5; h5 -= carry5 << 25
        let carry2 = (h2 + (1 << 25)) >> 26; h3 += carry2; h2 -= carry2 << 26
        let carry6 = (h6 + (1 << 25)) >> 26; h7 += carry6; h6 -= carry6 << 26
        let carry3 = (h3 + (1 << 24)) >> 25; h4 += carry3; h3 -= carry3 << 25
        let carry7 = (h7 + (1 << 24)) >> 25; h8 += carry7; h7 -= carry7 << 25
            carry4 = (h4 + (1 << 25)) >> 26; h5 += carry4; h4 -= carry4 << 26
        let carry8 = (h8 + (1 << 25)) >> 26; h9 += carry8; h8 -= carry8 << 26
        let carry9 = (h9 + (1 << 24)) >> 25; h0 += carry9 * 19; h9 -= carry9 << 25
            carry0 = (h0 + (1 << 25)) >> 26; h1 += carry0; h0 -= carry0 << 26

        return FieldElement([h0, h1, h2, h3, h4, h5, h6, h7, h8, h9])
    }

    /// monadic transformer
    public static func multipliedBy121666(_ f: FieldElement) -> FieldElement {
        let f0 = Int64(f[0])
        let f1 = Int64(f[1])
        let f2 = Int64(f[2])
        let f3 = Int64(f[3])
        let f4 = Int64(f[4])
        let f5 = Int64(f[5])
        let f6 = Int64(f[6])
        let f7 = Int64(f[7])
        let f8 = Int64(f[8])
        let f9 = Int64(f[9])

        var h0 = f0 * 121666
        var h1 = f1 * 121666
        var h2 = f2 * 121666
        var h3 = f3 * 121666
        var h4 = f4 * 121666
        var h5 = f5 * 121666
        var h6 = f6 * 121666
        var h7 = f7 * 121666
        var h8 = f8 * 121666
        var h9 = f9 * 121666

        let carry9 = (h9 + (1 << 24)) >> 25; h0 += carry9 * 19; h9 -= carry9 << 25
        let carry1 = (h1 + (1 << 24)) >> 25; h2 += carry1; h1 -= carry1 << 25
        let carry3 = (h3 + (1 << 24)) >> 25; h4 += carry3; h3 -= carry3 << 25
        let carry5 = (h5 + (1 << 24)) >> 25; h6 += carry5; h5 -= carry5 << 25
        let carry7 = (h7 + (1 << 24)) >> 25; h8 += carry7; h7 -= carry7 << 25
        let carry0 = (h0 + (1 << 25)) >> 26; h1 += carry0; h0 -= carry0 << 26
        let carry2 = (h2 + (1 << 25)) >> 26; h3 += carry2; h2 -= carry2 << 26
        let carry4 = (h4 + (1 << 25)) >> 26; h5 += carry4; h4 -= carry4 << 26
        let carry6 = (h6 + (1 << 25)) >> 26; h7 += carry6; h6 -= carry6 << 26
        let carry8 = (h8 + (1 << 25)) >> 26; h9 += carry8; h8 -= carry8 << 26

        return FieldElement([h0, h1, h2, h3, h4, h5, h6, h7, h8, h9])
    }

    /// monadic transformer
    public static func squared(_ f: FieldElement) -> FieldElement {
        let f0 = Int64(f[0])
        let f1 = Int64(f[1])
        let f2 = Int64(f[2])
        let f3 = Int64(f[3])
        let f4 = Int64(f[4])
        let f5 = Int64(f[5])
        let f6 = Int64(f[6])
        let f7 = Int64(f[7])
        let f8 = Int64(f[8])
        let f9 = Int64(f[9])

        let f0_2 = 2 * f0
        let f1_2 = 2 * f1
        let f2_2 = 2 * f2
        let f3_2 = 2 * f3
        let f4_2 = 2 * f4
        let f5_2 = 2 * f5
        let f6_2 = 2 * f6
        let f7_2 = 2 * f7

        let f5_38 = 38 * f5
        let f6_19 = 19 * f6
        let f7_38 = 38 * f7
        let f8_19 = 19 * f8
        let f9_38 = 38 * f9

        let f0f0    = f0   * f0
        let f0f1_2  = f0_2 * f1
        let f0f2_2  = f0_2 * f2
        let f0f3_2  = f0_2 * f3
        let f0f4_2  = f0_2 * f4
        let f0f5_2  = f0_2 * f5
        let f0f6_2  = f0_2 * f6
        let f0f7_2  = f0_2 * f7
        let f0f8_2  = f0_2 * f8
        let f0f9_2  = f0_2 * f9
        let f1f1_2  = f1_2 * f1
        let f1f2_2  = f1_2 * f2
        let f1f3_4  = f1_2 * f3_2
        let f1f4_2  = f1_2 * f4
        let f1f5_4  = f1_2 * f5_2
        let f1f6_2  = f1_2 * f6
        let f1f7_4  = f1_2 * f7_2
        let f1f8_2  = f1_2 * f8
        let f1f9_76 = f1_2 * f9_38
        let f2f2    = f2   * f2
        let f2f3_2  = f2_2 * f3
        let f2f4_2  = f2_2 * f4
        let f2f5_2  = f2_2 * f5
        let f2f6_2  = f2_2 * f6
        let f2f7_2  = f2_2 * f7
        let f2f8_38 = f2_2 * f8_19
        let f2f9_38 = f2   * f9_38
        let f3f3_2  = f3_2 * f3
        let f3f4_2  = f3_2 * f4
        let f3f5_4  = f3_2 * f5_2
        let f3f6_2  = f3_2 * f6
        let f3f7_76 = f3_2 * f7_38
        let f3f8_38 = f3_2 * f8_19
        let f3f9_76 = f3_2 * f9_38
        let f4f4    = f4   * f4
        let f4f5_2  = f4_2 * f5
        let f4f6_38 = f4_2 * f6_19
        let f4f7_38 = f4   * f7_38
        let f4f8_38 = f4_2 * f8_19
        let f4f9_38 = f4   * f9_38
        let f5f5_38 = f5   * f5_38
        let f5f6_38 = f5_2 * f6_19
        let f5f7_76 = f5_2 * f7_38
        let f5f8_38 = f5_2 * f8_19
        let f5f9_76 = f5_2 * f9_38
        let f6f6_19 = f6   * f6_19
        let f6f7_38 = f6   * f7_38
        let f6f8_38 = f6_2 * f8_19
        let f6f9_38 = f6   * f9_38
        let f7f7_38 = f7   * f7_38
        let f7f8_38 = f7_2 * f8_19
        let f7f9_76 = f7_2 * f9_38
        let f8f8_19 = f8   * f8_19
        let f8f9_38 = f8   * f9_38
        let f9f9_38 = f9   * f9_38

        var h0 = f0f0   + f1f9_76 + f2f8_38 + f3f7_76 + f4f6_38 + f5f5_38
        var h1 = f0f1_2 + f2f9_38 + f3f8_38 + f4f7_38 + f5f6_38
        var h2 = f0f2_2 + f1f1_2  + f3f9_76 + f4f8_38 + f5f7_76 + f6f6_19
        var h3 = f0f3_2 + f1f2_2  + f4f9_38 + f5f8_38 + f6f7_38
        var h4 = f0f4_2 + f1f3_4  + f2f2    + f5f9_76 + f6f8_38 + f7f7_38
        var h5 = f0f5_2 + f1f4_2  + f2f3_2  + f6f9_38 + f7f8_38
        var h6 = f0f6_2 + f1f5_4  + f2f4_2  + f3f3_2  + f7f9_76 + f8f8_19
        var h7 = f0f7_2 + f1f6_2  + f2f5_2  + f3f4_2  + f8f9_38
        var h8 = f0f8_2 + f1f7_4  + f2f6_2  + f3f5_4  + f4f4    + f9f9_38
        var h9 = f0f9_2 + f1f8_2  + f2f7_2  + f3f6_2  + f4f5_2

        var carry0 = (h0 + (1 << 25)) >> 26; h1 += carry0; h0 -= carry0 << 26
        var carry4 = (h4 + (1 << 25)) >> 26; h5 += carry4; h4 -= carry4 << 26
        let carry1 = (h1 + (1 << 24)) >> 25; h2 += carry1; h1 -= carry1 << 25
        let carry5 = (h5 + (1 << 24)) >> 25; h6 += carry5; h5 -= carry5 << 25
        let carry2 = (h2 + (1 << 25)) >> 26; h3 += carry2; h2 -= carry2 << 26
        let carry6 = (h6 + (1 << 25)) >> 26; h7 += carry6; h6 -= carry6 << 26
        let carry3 = (h3 + (1 << 24)) >> 25; h4 += carry3; h3 -= carry3 << 25
        let carry7 = (h7 + (1 << 24)) >> 25; h8 += carry7; h7 -= carry7 << 25
            carry4 = (h4 + (1 << 25)) >> 26; h5 += carry4; h4 -= carry4 << 26
        let carry8 = (h8 + (1 << 25)) >> 26; h9 += carry8; h8 -= carry8 << 26
        let carry9 = (h9 + (1 << 24)) >> 25; h0 += carry9 * 19; h9 -= carry9 << 25
            carry0 = (h0 + (1 << 25)) >> 26; h1 += carry0; h0 -= carry0 << 26

        return FieldElement([h0, h1, h2, h3, h4, h5, h6, h7, h8, h9])
    }

    public static func squared(f: FieldElement, times: Int) -> FieldElement {
        var result = f
        for _ in 0 ..< times {
            result = squared(result)
        }
        return result
    }

    /// monadic transformer
    public static func squared(_ times: Int) -> (FieldElement) -> FieldElement {
        return { (elem: FieldElement) -> FieldElement in
            return squared(f: elem, times: times)
        }
    }

    /// monadic transformer
    public static func squaredAndMultipliedBy2(f: FieldElement) -> FieldElement {
        let f0 = Int64(f[0])
        let f1 = Int64(f[1])
        let f2 = Int64(f[2])
        let f3 = Int64(f[3])
        let f4 = Int64(f[4])
        let f5 = Int64(f[5])
        let f6 = Int64(f[6])
        let f7 = Int64(f[7])
        let f8 = Int64(f[8])
        let f9 = Int64(f[9])

        let f0_2 = 2 * f0
        let f1_2 = 2 * f1
        let f2_2 = 2 * f2
        let f3_2 = 2 * f3
        let f4_2 = 2 * f4
        let f5_2 = 2 * f5
        let f6_2 = 2 * f6
        let f7_2 = 2 * f7

        let f5_38 = 38 * f5
        let f6_19 = 19 * f6
        let f7_38 = 38 * f7
        let f8_19 = 19 * f8
        let f9_38 = 38 * f9

        let f0f0    = f0   * f0
        let f0f1_2  = f0_2 * f1
        let f0f2_2  = f0_2 * f2
        let f0f3_2  = f0_2 * f3
        let f0f4_2  = f0_2 * f4
        let f0f5_2  = f0_2 * f5
        let f0f6_2  = f0_2 * f6
        let f0f7_2  = f0_2 * f7
        let f0f8_2  = f0_2 * f8
        let f0f9_2  = f0_2 * f9
        let f1f1_2  = f1_2 * f1
        let f1f2_2  = f1_2 * f2
        let f1f3_4  = f1_2 * f3_2
        let f1f4_2  = f1_2 * f4
        let f1f5_4  = f1_2 * f5_2
        let f1f6_2  = f1_2 * f6
        let f1f7_4  = f1_2 * f7_2
        let f1f8_2  = f1_2 * f8
        let f1f9_76 = f1_2 * f9_38
        let f2f2    = f2   * f2
        let f2f3_2  = f2_2 * f3
        let f2f4_2  = f2_2 * f4
        let f2f5_2  = f2_2 * f5
        let f2f6_2  = f2_2 * f6
        let f2f7_2  = f2_2 * f7
        let f2f8_38 = f2_2 * f8_19
        let f2f9_38 = f2   * f9_38
        let f3f3_2  = f3_2 * f3
        let f3f4_2  = f3_2 * f4
        let f3f5_4  = f3_2 * f5_2
        let f3f6_2  = f3_2 * f6
        let f3f7_76 = f3_2 * f7_38
        let f3f8_38 = f3_2 * f8_19
        let f3f9_76 = f3_2 * f9_38
        let f4f4    = f4   * f4
        let f4f5_2  = f4_2 * f5
        let f4f6_38 = f4_2 * f6_19
        let f4f7_38 = f4   * f7_38
        let f4f8_38 = f4_2 * f8_19
        let f4f9_38 = f4   * f9_38
        let f5f5_38 = f5   * f5_38
        let f5f6_38 = f5_2 * f6_19
        let f5f7_76 = f5_2 * f7_38
        let f5f8_38 = f5_2 * f8_19
        let f5f9_76 = f5_2 * f9_38
        let f6f6_19 = f6   * f6_19
        let f6f7_38 = f6   * f7_38
        let f6f8_38 = f6_2 * f8_19
        let f6f9_38 = f6   * f9_38
        let f7f7_38 = f7   * f7_38
        let f7f8_38 = f7_2 * f8_19
        let f7f9_76 = f7_2 * f9_38
        let f8f8_19 = f8   * f8_19
        let f8f9_38 = f8   * f9_38
        let f9f9_38 = f9   * f9_38

        var h0 = f0f0   + f1f9_76 + f2f8_38 + f3f7_76 + f4f6_38 + f5f5_38
        var h1 = f0f1_2 + f2f9_38 + f3f8_38 + f4f7_38 + f5f6_38
        var h2 = f0f2_2 + f1f1_2  + f3f9_76 + f4f8_38 + f5f7_76 + f6f6_19
        var h3 = f0f3_2 + f1f2_2  + f4f9_38 + f5f8_38 + f6f7_38
        var h4 = f0f4_2 + f1f3_4  + f2f2    + f5f9_76 + f6f8_38 + f7f7_38
        var h5 = f0f5_2 + f1f4_2  + f2f3_2  + f6f9_38 + f7f8_38
        var h6 = f0f6_2 + f1f5_4  + f2f4_2  + f3f3_2  + f7f9_76 + f8f8_19
        var h7 = f0f7_2 + f1f6_2  + f2f5_2  + f3f4_2  + f8f9_38
        var h8 = f0f8_2 + f1f7_4  + f2f6_2  + f3f5_4  + f4f4    + f9f9_38
        var h9 = f0f9_2 + f1f8_2  + f2f7_2  + f3f6_2  + f4f5_2

        h0 += h0
        h1 += h1
        h2 += h2
        h3 += h3
        h4 += h4
        h5 += h5
        h6 += h6
        h7 += h7
        h8 += h8
        h9 += h9

        var carry0 = (h0 + (1 << 25)) >> 26; h1 += carry0; h0 -= carry0 << 26
        var carry4 = (h4 + (1 << 25)) >> 26; h5 += carry4; h4 -= carry4 << 26
        let carry1 = (h1 + (1 << 24)) >> 25; h2 += carry1; h1 -= carry1 << 25
        let carry5 = (h5 + (1 << 24)) >> 25; h6 += carry5; h5 -= carry5 << 25
        let carry2 = (h2 + (1 << 25)) >> 26; h3 += carry2; h2 -= carry2 << 26
        let carry6 = (h6 + (1 << 25)) >> 26; h7 += carry6; h6 -= carry6 << 26
        let carry3 = (h3 + (1 << 24)) >> 25; h4 += carry3; h3 -= carry3 << 25
        let carry7 = (h7 + (1 << 24)) >> 25; h8 += carry7; h7 -= carry7 << 25
            carry4 = (h4 + (1 << 25)) >> 26; h5 += carry4; h4 -= carry4 << 26
        let carry8 = (h8 + (1 << 25)) >> 26; h9 += carry8; h8 -= carry8 << 26
        let carry9 = (h9 + (1 << 24)) >> 25; h0 += carry9 * 19; h9 -= carry9 << 25
            carry0 = (h0 + (1 << 25)) >> 26; h1 += carry0; h0 -= carry0 << 26

        return FieldElement([h0, h1, h2, h3, h4, h5, h6, h7, h8, h9])
    }

    /// monadic transformer
    public static func pow22523(_ z: FieldElement) -> FieldElement {
        let z2 = z |> squared
        let z8 = z2 |> squared(2)
        let z9 = z * z8
        let z11 = z2 * z9
        let z22 = z11 |> squared
        let z_5_0 = z9 * z22
        let z_10_5 = z_5_0 |> squared(5)
        let z_10_0 = z_10_5 * z_5_0
        let z_20_10 = z_10_0 |> squared(10)
        let z_20_0 = z_20_10 * z_10_0
        let z_40_20 = z_20_0 |> squared(20)
        let z_40_0 = z_40_20 * z_20_0
        let z_50_10 = z_40_0 |> squared(10)
        let z_50_0 = z_50_10 * z_10_0
        let z_100_50 = z_50_0 |> squared(50)
        let z_100_0 = z_100_50 * z_50_0
        let z_200_100 = z_100_0 |> squared(100)
        let z_200_0 = z_200_100 * z_100_0
        let z_250_50 = z_200_0 |> squared(50)
        let z_250_0 = z_250_50 * z_50_0
        let z_252_2 = z_250_0 |> squared(2)
        let z_252_3 = z_252_2 * z
        return z_252_3
    }

    /// monadic transformer
    public static func pow225521(_ z: FieldElement) -> FieldElement {
        let z2 = z |> squared
        let z8 = z2 |> squared(2)
        let z9 = z * z8
        let z11 = z2 * z9
        let z22 = z11 |> squared
        let z_5_0 = z9 * z22
        let z_10_5 = z_5_0 |> squared(5)
        let z_10_0 = z_10_5 * z_5_0
        let z_20_10 = z_10_0 |> squared(10)
        let z_20_0 = z_20_10 * z_10_0
        let z_40_20 = z_20_0 |> squared(20)
        let z_40_0 = z_40_20 * z_20_0
        let z_50_10 = z_40_0 |> squared(10)
        let z_50_0 = z_50_10 * z_10_0
        let z_100_50 = z_50_0 |> squared(50)
        let z_100_0 = z_100_50 * z_50_0
        let z_200_100 = z_100_0 |> squared(100)
        let z_200_0 = z_200_100 * z_100_0
        let z_250_50 = z_200_0 |> squared(50)
        let z_250_0 = z_250_50 * z_50_0
        let z_255_5 = z_250_0 |> squared(5)
        let z_255_21 = z_255_5 * z11
        return z_255_21
    }

    /// monadic transformer
    public static func inverted(_ z: FieldElement) -> FieldElement {
        return z |> pow225521
    }
}

public func + (left: FieldElement, right: FieldElement) -> FieldElement {
    return FieldElement.added(left, right)
}

public func - (left: FieldElement, right: FieldElement) -> FieldElement {
    return FieldElement.subtracted(left, right)
}

public prefix func - (right: FieldElement) -> FieldElement {
    return FieldElement.negated(right)
}

public func * (left: FieldElement, right: FieldElement) -> FieldElement {
    return FieldElement.multiplied(left, right)
}
