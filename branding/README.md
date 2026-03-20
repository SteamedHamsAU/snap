# Pane — Branding Assets

## Final Selections

| Asset | File | Rationale |
|-------|------|-----------|
| **App icon** | `icon/fire-ice.svg` | Bold, high-energy. Blue ultrawide with warm white MacBook and orange accent glow. |
| **Menu bar icon** | `icon/menubar-grey-depth@2x.svg` | Subtle depth via grey ultrawide, dark bezel, light screen. Best template-image balance. |
| **Prompt diagrams** | `renders/*.svg` | 14" MacBook (with notch/bezel/chin) + 27" 16:9 external at real-world proportions. |

### Menu bar template behaviour

macOS `NSStatusItem` template images use the **alpha channel only**. macOS ignores RGB
and composites the shape against the menubar's vibrancy material:

- **Light menubar** → shapes render dark
- **Dark menubar** → shapes render light/white
- **Auto/translucent** → macOS adjusts contrast dynamically to the wallpaper behind

Export the chosen SVG to PDF or PNG, add to `Assets.xcassets`, set *Render As: Template Image*.
Preview files (`menubar-template-{light,dark,auto}.svg`) show simulated template rendering
for all three candidates side by side.

## Icon Concept

The Pane icon depicts a **desk-view arrangement**: a 21:9 ultrawide monitor behind a MacBook Pro, viewed front-on. This directly represents what Pane does — managing display arrangements when you plug in an external monitor.

### Key design elements

- **Ultrawide (21:9)** — wide, sits behind, represents the external display
- **MacBook (16:10)** — in front and below, with:
  - Black bezel surround
  - Notch (bezel protruding into screen, not a cutout)
  - Thin base/chin barely wider than screen, with finger-groove lip indent
- **Overlap zone** — 32% vertical overlap where displays cross, with accent-coloured glow line at the seam
- **White background** — subtle gradient (#FFFFFF → #FAFAFA), macOS squircle (rx=228)
- **Contrasting display colours** — ultrawide and MacBook screen use different hues

## Working Files (`icon/`)

All candidates kept for reference. Final selections marked with ✅.

| File | Style | Notes |
|------|-------|-------|
| **`fire-ice.svg`** | Blue ultrawide, warm white MacBook, orange accent | **✅ App icon** |
| `mono-accent-blue.svg` | Grey displays, blue-only overlap glow | Minimal, distinctive |
| `things-duo.svg` | Navy ultrawide, blue MacBook, light blue accent | Professional, calm |
| `menubar-filled-back@2x.svg` | Black ultrawide+bezel, light grey screen | Best contrast |
| **`menubar-grey-depth@2x.svg`** | Grey ultrawide, dark bezel, light screen | **✅ Menu bar icon** |
| `menubar-shadow-depth@2x.svg` | Light ultrawide, black bezel, light screen | Inverted depth |
| `menubar-template-light.svg` | Template preview — light menubar | All 3 candidates side by side |
| `menubar-template-dark.svg` | Template preview — dark menubar | All 3 candidates side by side |
| `menubar-template-auto.svg` | Template preview — translucent menubar | All 3 candidates side by side |

## Menu Bar Icons

Template images for `NSStatusItem`. Monochrome — macOS handles dark/light mode inversion.

- **@2x (36×36)** — Retina. Full detail: notch, bezel, screen, base lip.
- **@1x (18×18)** — Non-Retina fallback. Simplified (no notch).

For production: export to PDF or PNG and add to `Assets.xcassets` as a template image.

## Prompt Screen Renders (`renders/`)

Display arrangement diagrams for the prompt window cards. Proportions based on a
14" MacBook Pro and 27" 16:9 external monitor at real-world size ratio (~1:1.94 width).

| File | Mode | Arrangement |
|------|------|-------------|
| `extend-right.svg` | Extend | External to the right of MacBook |
| `extend-left.svg` | Extend | External to the left of MacBook |
| `extend-above.svg` | Extend | External above MacBook |
| `mirror-macbook.svg` | Mirror | Optimise for MacBook (MacBook active, external dimmed) |
| `mirror-external.svg` | Mirror | Optimise for external (external active, MacBook dimmed) |

### Design tokens

MacBook scaled from `mono-accent-blue.svg` icon geometry — retains notch, black bezel,
screen gradient, and chin/base. External is the icon's ultrawide gradient as a single rect.

- **MacBook (72×45 bezel + 74×3 base):**
  - Bezel: `#0A0A0A`, rx=2
  - Screen: path with notch cutout, fill gradient `#E4E4E7→#D4D4D8`
  - Notch: 12px wide at top, ~3px deep, centred with rounded inner corners
  - Base/chin: `#2A2A2C`, rx=1.5, 1px wider than bezel each side
- **External (140×79):** single rect, gradient `#27272A→#18181B`, rx=3
- **Mirror dimmed (back display):** 30% opacity
- **Canvas:** 240×160, transparent background
- **Drop shadow:** `feDropShadow` 0 1 3 black @ 15%

## Design Exploration Archive

Full exploration history (variations a–j, ~150 SVGs, 30 colour palettes) is archived in `~/Developer/dev-diary/projects/pane/branding/`.

### Variation lineage

| Variation | Concept | Status |
|-----------|---------|--------|
| A | Stacked offset (OpenClaw original) | Explored |
| B | Side by side with gap | Explored |
| C | Arrow / snap motion indicator | Explored |
| D | Window pane grid (name play) | Explored |
| E | Mirror — identical overlapping rects | Explored |
| F | Depth — different-size overlap | Evolved into G |
| G | Desk view — ultrawide + MacBook | Evolved into H |
| H | + Black bezel + correct notch | Evolved into J |
| I | + Full keyboard/trackpad | Abandoned (too busy) |
| **J** | **H + front-on base/chin** | **✅ Final concept** |

## Colour Palette Categories

30 palettes were generated across these inspirations:

- **Complementary pairs**: blue-amber, indigo-gold, navy-coral, purple-lime, violet-emerald, blue-orange
- **Warm/cool contrast**: ocean-sunset, forest-rose, teal-magenta, steel-peach, slate-rose, cyan-red
- **Panic-inspired**: panic-deep, panic-sun, panic-play
- **Apple system**: apple-pro, apple-creative, apple-fresh
- **Indie Mac**: things-duo, craft-bold, bear-warm
- **Mono + accent glow**: mono-accent-{blue, red, green, purple, orange, cyan}
- **Bold**: neon-nights, fire-ice, electric
