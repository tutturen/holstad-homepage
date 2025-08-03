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