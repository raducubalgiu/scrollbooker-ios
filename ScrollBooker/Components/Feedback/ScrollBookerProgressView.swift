//
//  ScrollBookerProgressview.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 24.09.2026.
//

import SwiftUI

// MARK: - Geometrie (aceeași ca în logo, coordonate din viewBox-ul original)

private enum SBGeometry {
static let strokeWidth: CGFloat = 84
static let playBox = CGRect(x: 310, y: 174, width: 421, height: 416)
static let fullBox = CGRect(x: 288, y: 174, width: 465, height: 699)

static func addPlay(to p: inout Path) {
p.move(to: CGPoint(x: 352, y: 500))
p.addLine(to: CGPoint(x: 352, y: 258))
p.addQuadCurve(to: CGPoint(x: 406.59, y: 225.39), control: CGPoint(x: 352, y: 196))
p.addLine(to: CGPoint(x: 661.41, y: 362.61))
p.addQuadCurve(to: CGPoint(x: 661.84, y: 422.18), control: CGPoint(x: 716, y: 392))
p.addLine(to: CGPoint(x: 436, y: 548))
}
static func addTail(to p: inout Path, move: Bool) {
if move { p.move(to: CGPoint(x: 436, y: 548)) }
p.addCurve(to: CGPoint(x: 700, y: 700),
control1: CGPoint(x: 560, y: 478), control2: CGPoint(x: 760, y: 560))
p.addCurve(to: CGPoint(x: 330, y: 770),
control1: CGPoint(x: 640, y: 860), control2: CGPoint(x: 420, y: 860))
}
}

enum SBPart { case play, tail, full }

/// Forma logo-ului, scalată în rect-ul primit (păstrează proporțiile).
struct SBShape: Shape {
var part: SBPart
var box: CGRect { part == .play ? SBGeometry.playBox : SBGeometry.fullBox }

func path(in rect: CGRect) -> Path {
var p = Path()
switch part {
case .play: SBGeometry.addPlay(to: &p)
case .tail: SBGeometry.addTail(to: &p, move: true)
case .full: SBGeometry.addPlay(to: &p); SBGeometry.addTail(to: &p, move: false)
}
let s = min(rect.width / box.width, rect.height / box.height)
let dx = rect.midX - box.midX * s, dy = rect.midY - box.midY * s
return p.applying(CGAffineTransform(a: s, b: 0, c: 0, d: s, tx: dx, ty: dy))
}
}

// MARK: - Loader

enum SBLoaderStyle { case play, tail, snake }

struct ScrollBookerLoader: View {
var style: SBLoaderStyle = .snake
var color: Color = .white
var size: CGFloat = 40
@Environment(\.accessibilityReduceMotion) private var reduceMotion

private var duration: Double { style == .snake ? 1.5 : 1.6 }
private var aspect: CGFloat {
let b = style == .play ? SBGeometry.playBox : SBGeometry.fullBox
return b.width / b.height
}

var body: some View {
TimelineView(.animation) { ctx in
let t = ctx.date.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: duration) / duration
GeometryReader { geo in
let lw = SBGeometry.strokeWidth * scale(in: geo.size)
let stroke = StrokeStyle(lineWidth: lw, lineCap: .round, lineJoin: .round)
ZStack { content(t: t, stroke: stroke) }
}
}
.frame(width: size * aspect, height: size)
.accessibilityLabel("Se încarcă")
}

private func scale(in s: CGSize) -> CGFloat {
let b = style == .play ? SBGeometry.playBox : SBGeometry.fullBox
return min(s.width / b.width, s.height / b.height)
}

@ViewBuilder
private func content(t: Double, stroke: StrokeStyle) -> some View {
let track = color.opacity(0.16)
if reduceMotion {
SBShape(part: style == .play ? .play : .full).stroke(color, style: stroke)
.opacity(0.6 + 0.4 * cos(t * 2 * .pi))
} else {
switch style {
case .play: // se desenează, apoi se șterge din capăt
let e = easeInOut(t < 0.5 ? t * 2 : (t - 0.5) * 2)
SBShape(part: .play).stroke(track, style: stroke)
SBShape(part: .play)
.trim(from: t < 0.5 ? 0 : e, to: t < 0.5 ? e : 1)
.stroke(color, style: stroke)
case .tail: // play fix, coada se completează
let p = min(t / 0.7, 1)
let fade = t > 0.85 ? 1 - (t - 0.85) / 0.15 : 1
SBShape(part: .tail).stroke(track, style: stroke)
SBShape(part: .play).stroke(color, style: stroke)
SBShape(part: .tail).trim(from: 0, to: easeInOut(p))
.stroke(color, style: stroke).opacity(fade)
case .snake: // segment care parcurge tot logo-ul
let len = 0.26
let head = -len + easeInOut(t) * (1 + len)
SBShape(part: .full).stroke(track, style: stroke)
SBShape(part: .full)
.trim(from: max(0, head), to: min(1, max(0, head + len)))
.stroke(color, style: stroke)
}
}
}

private func easeInOut(_ x: Double) -> Double { x < 0.5 ? 4 * x * x * x : 1 - pow(-2 * x + 2, 3) / 2 }
}

// MARK: - Progres real (varianta 2, controlată din cod)

/// Coada se umple în funcție de `progress` (0...1), de ex. la upload de video.
struct ScrollBookerProgress: View {
var progress: Double
var color: Color = .white
var size: CGFloat = 40

var body: some View {
GeometryReader { geo in
let b = SBGeometry.fullBox
let s = min(geo.size.width / b.width, geo.size.height / b.height)
let stroke = StrokeStyle(lineWidth: SBGeometry.strokeWidth * s, lineCap: .round, lineJoin: .round)
ZStack {
SBShape(part: .tail).stroke(color.opacity(0.16), style: stroke)
SBShape(part: .play).stroke(color, style: stroke)
SBShape(part: .tail).trim(from: 0, to: min(max(progress, 0), 1)).stroke(color, style: stroke)
}
.animation(.easeOut(duration: 0.25), value: progress)
}
.frame(width: size * SBGeometry.fullBox.width / SBGeometry.fullBox.height, height: size)
}
}

#Preview {
HStack(spacing: 40) {
ScrollBookerLoader(style: .play)
ScrollBookerLoader(style: .tail)
ScrollBookerLoader(style: .snake, color: .orange)
}
.padding(40)
.background(Color.black)
}
