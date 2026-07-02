#import "/package/main.typ": init, vars
#import "@preview/tiaoma:0.3.0"

#let accent = rgb("#1e3a5f")
#let accent-light = rgb("#e8eef4")
#let muted = rgb("#5c6b7a")

#let subtitle-line(company, role) = {
  if company != none and role != none {
    company + " · " + role
  } else if company != none {
    company
  } else if role != none {
    role
  } else {
    none
  }
}

#init(
  fields: (
    (name: "name", type: vars.types.str, example: "John Doe", required: true),
    (name: "email", type: vars.types.str, example: "john.doe@example.com", required: true),
    (name: "company", type: vars.types.str, example: "Acme Corp", required: false),
    (name: "role", type: vars.types.str, example: "Software Engineer", required: false),
    (name: "ticketType", type: vars.types.str, example: "General", required: false),
  ),
  params: (
    (name: "eventId", type: vars.types.int, example: 123, required: true),
  ),
  layout: (
    width: 10cm,
    height: 7cm,
    margin: (x: 0.45cm, y: 0.4cm),
  ),
  meta: (
    name: "Conference Attendee Example 2",
    description: "Name badge for batch-printed event attendees with barcode check-in",
    version: "1.0.3",
    multipage: true,
    tags: ("badge", "event", "conference"),
  ),

  sql: (
    psql: (args: ()) => {
      let (p) = args
      "SELECT * FROM attendees WHERE eventId = " + str(p("eventId"))
    },
  ),
  body: args => [
    #let (index, total, data, fields, f) = args
    #let name = f("name")
    #let email = f("email")
    #let company = f("company")
    #let role = f("role")
    #let ticket-type = f("ticketType")
    #let subtitle = subtitle-line(company, role)

    #box(
      width: 100%,
      height: 100%,
      stroke: 0.6pt + accent.lighten(55%),
      radius: 4pt,
      clip: true,
    )[
      #block(height: 100%)[
        #stack(
          dir: ttb,
          spacing: 0cm,
        )[
          // Header
          #box(
            width: 100%,
            fill: accent,
            inset: (x: 0.5cm, y: 0.26cm),
          )[
            #grid(
              columns: (1fr, auto),
              align: (left, right),
              gutter: 0.35cm,
            )[
              #text(fill: white, size: 9pt, weight: "bold", tracking: 0.08em)[
                TECH SUMMIT 2026
              ]
              #text(fill: white.transparentize(15%), size: 7pt)[
                June 13-15 · San Francisco
              ]
            ]
          ]

          // Body
          #pad(x: 0.5cm, top: 0.35cm, bottom: 0.15cm)[
            #stack(
              dir: ttb,
              spacing: 0.22cm,
            )[
              #text(size: 17pt, weight: "bold", fill: accent)[#name]

              #if subtitle != none [
                #text(size: 9pt, fill: muted)[#subtitle]
              ] else [
                #box()
              ]

              #align(center)[
                #box(
                  fill: accent-light,
                  radius: 3pt,
                  inset: (x: 0.3cm, y: 0.22cm),
                )[
                  #tiaoma.code128(email, height: 0.75cm)
                ]
              ]
            ]
          ]

          #v(1fr)

          // Footer
          #pad(left: 0.5cm, right: 0.5cm, bottom: 0.28cm)[
            #grid(
              columns: (1fr, auto),
              align: (left, right),
            )[
              #if ticket-type != none [
                #box(
                  fill: accent.lighten(78%),
                  inset: (x: 0.25cm, y: 0.08cm),
                  radius: 2pt,
                )[
                  #text(size: 7pt, weight: "semibold", fill: accent)[#ticket-type]
                ]
              ] else [
                #box()
              ]
              #text(size: 7pt, fill: muted)[#index / #total]
            ]
          ]
        ]
      ]
    ]
  ],
)
