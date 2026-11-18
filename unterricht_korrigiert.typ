// Angebots-Nutzungs-Modell (Nachbau) – Koordinaten in pt (1 Einheit = 1 px der Vorlage)
// Personen-Silhouetten: Lehrende = Wee People (ProPublica / Alberto Cairo),
// Schüler*innen = Little People (hochgeladene Schrift), beide als SVG aus den Glyphen extrahiert.

// ---------- Farbschema ----------
#let karminrot = rgb("#A51E37")
#let mattgold = rgb("#B4A069")
#let anthrazit = rgb("#32414B")
#let sand = rgb("#EEE9DD")
#let zinnober = rgb("#C8503C")
#let hellgruen = rgb("#7DA54B")
#let dunkelgruen = rgb("#326E1E")
#let indigo = rgb("#415A8C")
#let blau = rgb("#0069AA")
#let cyan = rgb("#50AAC8")
#let sandgold = rgb("#D7B469")

#set page(width: 748pt, height: 620pt, margin: 0pt, fill: white)
#set text(font: ("Liberation Sans", "Arial", "DejaVu Sans"), size: 7pt, fill: anthrazit, lang: "de")
#set par(leading: 0.45em, spacing: 0.5em)

// ---------- Helfer ----------
#let at(x, y, body) = place(top + left, dx: x * 1pt, dy: y * 1pt, body)
#let rrect(x0, y0, x1, y1, r: 9, ..args) = at(x0, y0, rect(width: (x1 - x0) * 1pt, height: (y1 - y0) * 1pt, radius: r * 1pt, ..args))
#let disc(cx, cy, r, ..args) = at(cx - r, cy - r, circle(radius: r * 1pt, ..args))
// zentrierter Textblock um (cx, cy)
#let tb(cx, cy, w, h, body) = at(cx - w / 2, cy - h / 2, box(width: w * 1pt, height: h * 1pt, align(center + horizon, body)))
#let lab(x, y, body) = at(x, y - 7, box(height: 14pt, align(horizon, body)))
#let note(xr, y, body, w: 260) = at(xr - w, y - 7, box(width: w * 1pt, height: 14pt, align(right + horizon, text(size: 6.4pt, body))))

#let pt-at(cx, cy, r, th) = (cx + r * calc.cos(th * 1deg), cy + r * calc.sin(th * 1deg))

// Dreieck-Pfeilspitze an (x,y), Richtung dir (Grad, y nach unten)
#let head(x, y, dir, s, fill) = {
  let d = (calc.cos(dir * 1deg), calc.sin(dir * 1deg))
  let n = (-d.at(1), d.at(0))
  let b = (x - s * d.at(0), y - s * d.at(1))
  at(0, 0, polygon(fill: fill,
    (x * 1pt, y * 1pt),
    ((b.at(0) + 0.65 * s * n.at(0)) * 1pt, (b.at(1) + 0.65 * s * n.at(1)) * 1pt),
    ((b.at(0) - 0.65 * s * n.at(0)) * 1pt, (b.at(1) - 0.65 * s * n.at(1)) * 1pt)))
}

// Kreisbogen von a0 bis a1 (Grad), optional Pfeilspitzen
#let arc(cx, cy, r, a0, a1, col, w: 4.5, h0: false, h1: false, s: 11) = {
  let n = 40
  let pts = range(n + 1).map(i => {
    let p = pt-at(cx, cy, r, a0 + (a1 - a0) * i / n)
    (p.at(0) * 1pt, p.at(1) * 1pt)
  })
  at(0, 0, curve(stroke: (paint: col, thickness: w * 1pt, cap: "butt"), curve.move(pts.first()), ..pts.slice(1).map(p => curve.line(p))))
  let sg = if a1 > a0 { 1 } else { -1 }
  if h1 { let p = pt-at(cx, cy, r, a1); head(p.at(0), p.at(1), a1 + sg * 90, s, col) }
  if h0 { let p = pt-at(cx, cy, r, a0); head(p.at(0), p.at(1), a0 - sg * 90, s, col) }
}

// Text auf Kreisbogen; bottom: false = Schrift außen oben lesbar (im Uhrzeigersinn), true = unten lesbar (gegen den Uhrzeigersinn)
#let arctext(cx, cy, r, mid, txt, size, col, bottom: false, tr: 0.6) = context {
  let cs = txt.clusters()
  let ws = cs.map(c => measure(text(size: size * 1pt, weight: "bold", c)).width.to-absolute().pt() + tr)
  let tot = ws.sum()
  let tdeg = tot / r * 180 / calc.pi
  let acc = 0
  for (i, c) in cs.enumerate() {
    let w = ws.at(i)
    let d = (acc + w / 2) / r * 180 / calc.pi
    let th = if bottom { mid + tdeg / 2 - d } else { mid - tdeg / 2 + d }
    let p = pt-at(cx, cy, r, th)
    let rot = if bottom { th - 90 } else { th + 90 }
    at(p.at(0) - w / 2 - 2, p.at(1) - size * 0.75,
      rotate(rot * 1deg, box(width: (w + 4) * 1pt, height: size * 1.5pt, align(center + horizon, text(size: size * 1pt, weight: "bold", fill: col, c)))))
    acc += w
  }
}

// Kleiner Blockpfeil (Tinte) in Richtung dir
#let block(x, y, dir, len, wid, col) = {
  let d = (calc.cos(dir * 1deg), calc.sin(dir * 1deg))
  let n = (-d.at(1), d.at(0))
  let pt(a, b) = ((x + a * d.at(0) + b * n.at(0)) * 1pt, (y + a * d.at(1) + b * n.at(1)) * 1pt)
  at(0, 0, polygon(fill: col,
    pt(0, -wid * 0.22), pt(len * 0.55, -wid * 0.22), pt(len * 0.55, -wid * 0.5), pt(len, 0),
    pt(len * 0.55, wid * 0.5), pt(len * 0.55, wid * 0.22), pt(0, wid * 0.22)))
}

// ---------- Ebenen ----------
#let l1 = anthrazit.lighten(78%)
#let l2 = anthrazit.lighten(86%)
#let l3 = l2
#let edge = white

#rrect(20, 4, 742, 616, fill: l1, stroke: 1.2pt + edge)
#rrect(49, 39, 732, 578, fill: l2, stroke: 1.2pt + edge)
#rrect(79, 75, 724, 542, fill: l3, stroke: 1.2pt + edge)

// Seitliche Kontext-Beschriftung
#at(0, 0, {
  place(top + left, dx: 6pt, dy: 205pt, rotate(-90deg, origin: top + left, box(width: 195pt, height: 12pt, align(center + horizon, text(size: 7.5pt, weight: "bold", tracking: 1.2pt)[AUSSERSCHULISCHE KONTEXTE]))))
  place(top + left, dx: 6pt, dy: 612pt, rotate(-90deg, origin: top + left, box(width: 280pt, height: 12pt, align(center + horizon, text(size: 7.5pt, weight: "bold", tracking: 1.2pt)[SCHULISCHE KONTEXTE]))))
})

// Pfeil-Chevrons am linken Rand (Einflüsse von außen)
#for (x, y) in ((54, 165), (62, 182), (54, 505), (62, 522)) {
  block(x, y, 0, 26, 18, white)
}

// Ebenen-Beschriftungen
#lab(52, 25, text(size: 11pt, weight: "bold")[Gesellschaft])
#note(728, 25, [z.B. Wirtschaftssystem, Sozialsystem])
#lab(80, 60, text(size: 11pt, weight: "bold")[Region])
#note(716, 60, [z.B. Infrastruktur, außerschulische Bildungsangebote])
#at(97, 91, text(size: 11pt, weight: "bold")[direktes \ soziales Umfeld])
#at(430, 98, box(width: 281pt, align(right, text(size: 6.4pt)[z.B. Familie, Freundeskreis, \ Nachbarschaft])))

// ---------- Unterricht ----------
#rrect(108, 203, 715, 507, r: 5, fill: white, stroke: 1pt + l1)
#lab(110, 525, text(size: 11pt, weight: "bold")[Klasse + Fach])
#note(713, 525, [z.B. Klassengröße, curriculare Inhalte])
#lab(80, 561, text(size: 11pt, weight: "bold")[Schule])
#note(713, 561, [z.B. Schulleitung, Kollegium])
#lab(52, 596, text(size: 11pt, weight: "bold")[Bildungssystem])
#note(728, 596, [z.B. Organisation des Schulsystems, Lehrerausbildung])
#tb(396, 266, 120, 20, text(size: 11pt, weight: "bold")[Unterricht])

// ---------- Personen ----------
// Lehrende (Weepeople)
#at(222, 100, image("assets/lehr_f.svg", height: 66pt))
#at(246, 96, image("assets/lehr_D.svg", height: 74pt))
#at(282, 100, image("assets/lehr_h.svg", height: 66pt))
// Schüler*innen (Littlepeople)
#at(517, 118, image("assets/schue_R.svg", height: 52pt))
#at(534, 100, image("assets/schue_Z.svg", height: 68pt))
#at(552, 104, image("assets/schue_E.svg", height: 62pt))
#at(568, 108, image("assets/schue_U.svg", height: 58pt))
#at(578, 117, image("assets/schue_F.svg", height: 52pt))

// Vor- und Nachbereitung: 6 Pfeile (3 gegenläufige Paare) wie im Original
#let arrow(x0, y0, x1, y1, col, sw: 6, hw: 16, hl: 10) = {
  let L = calc.sqrt(calc.pow(x1 - x0, 2) + calc.pow(y1 - y0, 2))
  let d = ((x1 - x0) / L, (y1 - y0) / L)
  let n = (-d.at(1), d.at(0))
  let q(a, b) = ((x0 + a * d.at(0) + b * n.at(0)) * 1pt, (y0 + a * d.at(1) + b * n.at(1)) * 1pt)
  at(0, 0, polygon(fill: col, stroke: (paint: col, thickness: 1pt, join: "round"),
    q(0, -sw / 2), q(L - hl, -sw / 2), q(L - hl, -hw / 2), q(L, 0),
    q(L - hl, hw / 2), q(L - hl, sw / 2), q(0, sw / 2)))
}
#let vn = blau.lighten(76%)
#arrow(355.8, 163.3, 337.5, 173.7, vn)
#arrow(348.3, 185, 367.5, 172.5, vn)
#arrow(460, 162.5, 479.2, 173.7, vn)
#arrow(467.5, 185, 449.2, 173, vn)
#arrow(400, 205, 400, 183.3, vn)
#arrow(415, 187.5, 415, 210.8, vn)
#tb(407.5, 163, 130, 28, text(size: 7.2pt, fill: anthrazit.lighten(10%))[Vor- und Nachbereitung \ des Unterrichts])

// Lehrende-Kreis
#disc(268, 218, 77, fill: sandgold.lighten(78%), stroke: 1pt + sandgold.lighten(30%))
#tb(268, 175, 120, 22, text(size: 12pt, weight: "bold")[Lehrende])
#tb(268, 232, 128, 100, [
  #text(weight: "bold", size: 7pt)[Professionelle \ Kompetenzen und \ individuelle Merkmale] \
  #text(size: 6.5pt)[z.B. Professionswissen, \ Überzeugungen, motivationale und emotionale Dispositionen (Traits)]
])

// Schüler*innen-Kreis
#disc(535, 220, 72, fill: sandgold.lighten(78%), stroke: 1pt + sandgold.lighten(30%))
#tb(542, 172, 110, 22, text(size: 12pt, weight: "bold")[Schüler\*innen])
#tb(552, 224, 110, 70, [
  #text(weight: "bold", size: 7pt)[Lernvoraus­setzungen] \
  #text(size: 6.5pt)[z.B. Vorwissen, Überzeugungen, motivationale und emotionale Dispositionen (Traits)]
])
#disc(497, 270, 31, fill: white, stroke: 1pt + sandgold.lighten(30%))
#tb(497, 270, 56, 40, text(size: 6.8pt, weight: "bold")[Mehr­dimen­sionale Bildungs­wirkungen])

// Pfeile Kreis -> Prozess
#block(258, 288, -100, 28, 12, hellgruen)
#block(575, 262, 100, 22, 11, hellgruen)

// ---------- Verarbeitung / Nutzung ----------
#let process(cx, cy, title, mot-left: true) = {
  disc(cx, cy, 62, fill: white, stroke: 1pt + sandgold.lighten(30%))
  disc(cx, cy, 46, fill: sandgold.lighten(80%), stroke: none)
  arctext(cx, cy, 54, -90, "KOGNITIONEN", 5, blau)
  arctext(cx, cy, 54, 148, "MOTIVATIONALES ERLEBEN", 4.8, blau, bottom: true, tr: 0.3)
  arctext(cx, cy, 54, 32, "EMOTIONALES ERLEBEN", 4.8, blau, bottom: true, tr: 0.3)
  arc(cx, cy, 54, -56, -12, blau.lighten(55%), w: 1.4, h1: true, s: 6)
  arc(cx, cy, 54, 198, 236, blau.lighten(55%), w: 1.4, h1: true, s: 6)
  tb(cx, cy, 80, 60, text(size: 7.2pt, weight: "bold", fill: blau)[#title])
}
#process(192, 350, [Verarbeitung \ des Angebots \ durch Lehrende])
#process(600, 350, [Nutzung \ des Angebots \ durch Schüler\*innen])

// ---------- Angebot / Ko-Konstruktion ----------
#let cx = 400
#let cy = 392
#at(cx - 112, cy - 112, circle(radius: 112pt, stroke: none, fill: gradient.radial(
  (hellgruen.transparentize(100%), 0%), (hellgruen.transparentize(100%), 0%),
  (hellgruen.transparentize(70%), 58%), (hellgruen.transparentize(100%), 100%))))
#disc(cx, cy, 66, fill: gradient.radial((hellgruen.lighten(50%), 0%), (hellgruen.lighten(18%), 100%)), stroke: none)
#disc(cx, cy, 80, fill: none, stroke: (paint: blau, thickness: 1.2pt, dash: "dashed"))

#arctext(cx, cy, 88, -90, "ANGEBOT", 7.5, hellgruen.darken(5%))
#arctext(cx, cy, 108, 205, "INTERPRETATION", 7, hellgruen)
#arctext(cx, cy, 108, 135, "WAHRNEHMUNG", 7, hellgruen, bottom: true)
#arctext(cx, cy, 108, -25, "INTERPRETATION", 7, hellgruen)
#arctext(cx, cy, 108, 45, "WAHRNEHMUNG", 7, hellgruen, bottom: true)
#arctext(cx, cy, 88, 90, "ANGEBOT", 7.5, hellgruen.darken(5%), bottom: true)

// Kreislauf-Pfeile
#arc(cx, cy - 2, 62, -123, -57, blau, w: 4.5, h0: true, h1: true)
#arc(cx, cy - 2, 62, -12, 52, blau, w: 4.5, h0: true, h1: true)
#arc(cx, cy - 2, 62, 128, 192, blau, w: 4.5, h0: true, h1: true)

#let bx(cx, cy, w, h, body) = {
  at(cx - w / 2, cy - h / 2, rect(width: w * 1pt, height: h * 1pt, radius: 2pt, fill: white, stroke: 0.8pt + blau))
  tb(cx, cy, w, h, text(size: 6.8pt, weight: "bold", fill: anthrazit)[#body])
}
#bx(352, 356, 52, 28, [Handeln \ Lehrende])
#bx(452, 356, 76, 28, [Handeln \ Schüler\*innen])
#bx(412, 458, 74, 28, [Unterrichts­gegenstand])
#tb(cx + 2, cy + 4, 70, 46, text(size: 8pt, weight: "bold", fill: white)[KO- \ KONSTRUK- \ TION])

// Grüne Pfeile zwischen Prozessen und Angebot
#block(257, 352, 0, 26, 14, hellgruen)
#block(284, 404, 180, 26, 14, hellgruen)
#block(539, 352, 180, 26, 14, hellgruen)
#block(513, 404, 0, 26, 14, hellgruen)
