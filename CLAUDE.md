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
- `data/lag.yaml` holds every team: hardcoded birth-year range, gender, training
  times, coach/contact, Spond signup URL
- Rendered by two shortcodes in `layouts/_shortcodes/`:
  - `lagvelger.html` — interactive "which team fits me?" module (front page)
  - `lagliste.html` — the team list on `/lag`. Emits **markdown**, so it must be
    called with the percent form (`{{%` … `%}}`); the angle form produces raw HTML
    and the team headings then vanish from Hextra's TOC sidebar
- `tilrettelagt: true` keeps a team (Diamantvolley) out of the age/gender matching
  and surfaces it as a separate link under the result instead
- Styling lives in `assets/css/custom.css` (plain CSS — Hextra's Tailwind CSS is
  precompiled, so new `hx:` classes do not exist in the build)
- New season: bump `sesong` plus every `fodselsaarFra`/`fodselsaarTil` by one, and
  update the per-hall training tables in `content/lag.md`

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