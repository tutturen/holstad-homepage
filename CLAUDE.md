# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Hugo-based website for Holstad IL Volleyball (holstadvolley.com) using the Hextra theme. The site contains news articles, team information, membership details, and other club-related content.

## Development Commands

### Local Development
```bash
# Start development server
hugo server --logLevel debug --disableFastRender -p 1313

# Alternative using the provided script
./dev-start.sh

# Update Hugo modules
hugo mod get -u
hugo mod tidy
```

### Build and Deploy
```bash
# Build for production
hugo --gc --minify --baseURL "https://holstadvolley.com/"

# The site automatically deploys to GitHub Pages via GitHub Actions on pushes to main branch
```

## Architecture

### Content Structure
- `content/` - All site content in Markdown format
  - `nyheter/` - News articles with date-prefixed filenames
  - Individual pages for membership, teams, prices, etc.
- `static/` - Static assets (images, documents, favicon files)
  - `dokumenter/` - PDFs and official documents organized by year
  - `styret/` - Board member photos
- `public/` - Generated site output (ignored in git)

### Teams data (single source of truth)
- `data/lag.yaml` is the only place training times live. It holds every team
  (birth-year range, gender, coach/contact, Spond URL, `farge`), the halls and
  their courts (`haller`), the weekday order (`dager`), and non-team hall
  bookings (`andreBookinger`). `content/lag.md` has no schedule tables
- Each `treninger` entry is `{dag, fra, til, sted, bane}` — `bane` is one court
  name or a list — plus optional `oppvarming` (minutes before `fra`) and `notat`
- **One team card, one template.** `_partials/lag/kort.html` is the only place a
  team card is built; `lagvelger` and `lagliste` both call it, so their markup
  cannot drift apart (it had: different button text, different training-time
  layout, two parallel CSS class families). Its `tittel` param is the one real
  difference — the front page renders the team name as an `<h4>` inside the card,
  `/lag` needs it as a markdown heading outside so Hextra's TOC picks it up. It
  returns HTML on a **single line**, which goldmark requires for the `/lag` case
- Rendered by three shortcodes in `layouts/_shortcodes/`:
  - `lagvelger.html` — interactive "which team fits me?" module (front page).
    All cards are rendered server-side and hidden; the JS only toggles `hidden`
    on year/gender change. It builds no DOM — that was what let the two cards
    diverge in the first place
  - `lagliste.html` — the team list on `/lag`
  - `timeplan.html` — the schedule calendar on `/lag`: one CSS grid per
    (day, hall), courts as columns, one grid row per 5 minutes, so block height
    is proportional to duration. Mobile metrics tighten below 640px so three
    courts still fit side by side on a 375px phone; below 336px the grid is
    switched off and the
    blocks fall out as a chronological list, so the template emits them sorted
    by start time
- `lagliste` and `timeplan` emit **markdown**, so they must be called with the
  percent form (`{{%` … `%}}`); the angle form produces raw HTML and the headings
  then vanish from Hextra's TOC sidebar
- Every team has its own colour, not a shared category colour — people look for
  their own team. `farge` on a team is an HSL hue 0-359 or a name (`blå`,
  `lilla`, …); `_partials/lag/farger.html` resolves it and auto-assigns a hue to
  teams that omit it. Only the hue reaches the HTML (`--tp-h`); saturation and
  lightness for light/dark mode live in `custom.css`. The same hue tints the
  team card, so card and schedule blocks read as the same team. Non-team
  bookings stay neutral (grey striped, or black outline for `type: apen`) so
  colour always means team
- Shared helpers in `layouts/_partials/lag/`: `kort.html` (the team card),
  `minutter.html` / `klokke.html` (HH:MM ↔ minutes), `booking.html` (normalises
  + validates one booking), `treningstekst.html` (structured booking →
  "18:30 - 20:15" / "Åshallen, gammel del" — the court is only named when the
  hall sets `visBaneIKort: true`, since Åsgård's court split is tentative and
  belongs in the schedule, while Åshallen's halves are what tell Tullball's two
  sessions apart), `farger.html` (team → hue),
  `aarstekst.html` ("For jenter født 2012-2013")
- Bad schedule data fails the build (`errorf`), so CI's `hugo --minify` step
  catches it. Two sessions on the same court at the *same* times means a shared
  court and renders side by side; *partial* overlap also renders side by side but
  logs a `WARN` — it is a booking clash in the data
- `tilrettelagt: true` keeps a team (Diamantvolley) out of the age/gender matching
  and surfaces it as a separate link under the result instead
- Styling lives in `assets/css/custom.css` (plain CSS — Hextra's Tailwind CSS is
  precompiled, so new `hx:` classes do not exist in the build)
- New season: bump `sesong` plus every `fodselsaarFra`/`fodselsaarTil` by one, and
  update the `treninger` blocks in `data/lag.yaml`

### Configuration
- `hugo.yaml` - Main Hugo configuration with menu structure and theme settings
- `go.mod` - Hugo module dependencies (primarily Hextra theme v0.8.0)
- `i18n/en.yaml` - Internationalization strings

### Key Features
- Uses Hugo modules for theme management
- Hextra theme provides search functionality and responsive design
- Norwegian language content with club-specific navigation
- GitHub Pages deployment via GitHub Actions workflow

### Content Patterns
- News articles follow naming convention: `YYYY-MM-DD-article-title.md`
- All content uses frontmatter with title, date, and optional tags
- Images stored in `static/` directory and referenced with absolute paths