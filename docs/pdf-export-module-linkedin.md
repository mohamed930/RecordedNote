# PDF Export Module Case Study

I built a PDF export module for the `RecordNote` iOS app to turn meeting notes into clean, shareable multi-page documents.

## What It Does

The feature lets users export a note as PDF from the note details screen and choose which sections to include:

- Summary
- Tasks
- Transcript

The result is a branded A4 PDF with:

- A structured first page
- Dedicated task pages
- Dedicated transcript pages
- Page numbering footer

## How It Was Built

I implemented the module with SwiftUI and a service-based architecture:

- `PDFOptionsSheet` handles user content selection
- `NoteDetailsViewModel` triggers the export flow
- `PDFExportService` builds and renders the PDF
- `PDFPageBuilder` splits large content into multiple pages
- Dedicated SwiftUI page views render each PDF page layout

Rendering is done with:

- `ImageRenderer`
- `CGContext`
- Fixed A4 sizing for consistent output

## Technical Highlights

- Multi-page PDF generation from SwiftUI views
- Modular page rendering per section
- Configurable export options
- Transcript chunking into paragraph-based pages
- Task chunking into paginated task lists
- Consistent branding and footer pagination across pages

## Why This Matters

This module turns raw note content into a portable format that is easier to:

- share
- archive
- review outside the app
- use in work and meeting workflows

It also creates a strong base for future improvements like:

- direct share flow
- file naming by note title
- smarter height-based pagination
- export testing for long transcripts

## My Contribution

I worked on the module architecture, page composition, pagination strategy, and export rendering flow. The implementation keeps the UI layer separate from the export service, which makes the feature easier to maintain and extend.

## Short LinkedIn Version

Built a PDF export module for an iOS note-taking app using SwiftUI, `ImageRenderer`, and `CGContext`. The feature exports meeting notes into branded multi-page A4 PDFs with selectable sections like summary, tasks, and transcript, using a modular rendering pipeline and page chunking strategy for scalable output.
