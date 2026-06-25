# PDF Export Module

## Overview

The PDF export module in `RecordNote` generates a multi-page A4 PDF from a note inside the note details flow. The export is driven from the note details menu, lets the user choose which sections to include, and renders the PDF using SwiftUI page views plus `ImageRenderer` and `CGContext`.

The module currently supports:

- Summary on the first page
- Tasks split across multiple pages
- Transcript split across multiple pages
- Shared footer with page number
- Temporary file output as `note.pdf`

## Entry Point

The export starts from the note details menu:

- `MenuComponets.MenuAction.savePdf`
- `NoteDetailsViewModel.savePdf()`

Inside `savePdf()`:

1. The menu is closed.
2. `PDFOptionsSheet` is presented.
3. The user selects content options.
4. `NoteDetailsUseCases.execute(note:duration:options:)` is called.
5. The generated PDF URL is stored in `pdfUrl`.

Important current note:

- The view model still exports `NoteRealModelInfoModel.pcintMock` instead of the active `noteModel`.
- Share presentation after export is still commented out.

## Main Files

### Domain

- `RecordNote/Domain Layer/Repositories/PDFExportService/PDFExportServiceProtocol.swift`
- `RecordNote/Domain Layer/Repositories/PDFExportService/PDFExportService.swift`
- `RecordNote/Domain Layer/NoteDetailsUseCases/NoteDetailsUseCases.swift`

### Presentation

- `RecordNote/Presentation Layer/NoteDetailsModule/ViewModel/NoteDetailsViewModel.swift`
- `RecordNote/Presentation Layer/NoteDetailsModule/Compentes/PDFOptionsSheet.swift`
- `RecordNote/Presentation Layer/NoteDetailsModule/Compentes/PDF/PDFFirstPageView.swift`
- `RecordNote/Presentation Layer/NoteDetailsModule/Compentes/PDF/PDFTasksPageView.swift`
- `RecordNote/Presentation Layer/NoteDetailsModule/Compentes/PDF/PDFTranscriptPageView.swift`
- `RecordNote/Presentation Layer/NoteDetailsModule/Compentes/PDF/PDFFooterView.swift`

### Helpers

- `RecordNote/Extensions + UICustoms/PDFPageBuilder.swift`

## Export Flow

### 1. Option Selection

`PDFOptionsSheet` exposes three export options through `PDFContentOption`:

- `summary`
- `tasks`
- `transcript`

The selected options are returned to the view model as a `Set<PDFContentOption>`, then converted to an array for the use case call.

### 2. Page Planning

`PDFExportService.export(note:duration:options:)` is the main renderer.

It always creates:

- One first page using `PDFFirstPageView`

It conditionally creates:

- Task pages when `.tasks` is selected
- Transcript pages when `.transcript` is selected

Page splitting is handled by `PDFPageBuilder`:

- `taskChunks(from:tasksPerPage:)`
- `transcriptChunks(from:paragraphsPerPage:)`

Current chunking rules:

- Tasks: 8 per page
- Transcript paragraphs: 6 per page

### 3. Rendering

For each page:

1. A SwiftUI view is wrapped in `AnyView`.
2. `ImageRenderer` renders the page.
3. `CGContext` opens a PDF page.
4. The rendered page is drawn into the PDF context.
5. The PDF is written to a temporary file.

Output file:

- `FileManager.default.temporaryDirectory.appendingPathComponent("note.pdf")`

## Page Composition

### First Page

`PDFFirstPageView` includes:

- App branding
- Export date
- Note title
- Note date
- Audio duration
- Summary section when selected
- Footer with page number

The first page currently does not render tasks or transcript content directly. Those sections are moved into dedicated follow-up pages.

### Tasks Pages

`PDFTasksPageView` includes:

- Header with branding and export date
- Tasks section title
- Task rows using `TaskRow`
- Note date per task row
- Footer with page number

### Transcript Pages

`PDFTranscriptPageView` includes:

- Header with branding and export date
- Transcript section title
- Paragraph list
- Footer with page number

Paragraphs are generated from the transcript by splitting on double line breaks in `String.pdfParagraphs()`.

## Design Decisions

- A4 is fixed at `595.2 x 841.8`
- Each PDF page is rendered as a standalone SwiftUI view
- Tasks and transcript use deterministic chunking instead of runtime text measurement
- Footer paging is calculated before rendering using total page count
- The implementation requires `iOS 16+` because it uses `ImageRenderer`

## Current Strengths

- Clear separation between export orchestration and page UI
- Easy to extend with new page types
- Predictable page count
- Reusable chunking logic
- Consistent visual structure across all pages

## Current Gaps

### Functional

- Export still uses mock data in `NoteDetailsViewModel.savePdf()`
- Share flow is not wired after PDF generation
- The output file name is always `note.pdf`
- No error surface is shown to the user on failure

### Rendering

- Transcript pagination is paragraph-count based, not height based
- Long paragraphs can still overflow visually
- Repeated task titles could collide with `ForEach(id: \.title)`
- Export date formatting is inconsistent between pages

### Reliability

- No unit tests for chunking
- No snapshot or rendering tests for PDF pages
- No stress test for very long transcript content

## Recommended Next Improvements

1. Replace `.pcintMock` with `noteModel` in `NoteDetailsViewModel.savePdf()`.
2. Present the share sheet automatically after a successful export.
3. Generate a unique file name based on note title or note id.
4. Move to height-aware transcript pagination for safer rendering.
5. Add tests for:
   - empty options
   - empty tasks
   - empty transcript
   - large transcript
   - page count calculation

## Quick Summary

This module is a structured SwiftUI-based PDF pipeline for exporting note content into branded multi-page A4 documents. The architecture is already modular and readable. The main work left is finishing production wiring, improving pagination robustness, and adding tests.
