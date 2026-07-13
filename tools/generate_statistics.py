#!/usr/bin/env python3
"""Generate the GitHub Pages statistics view from the compiled Typst document."""

from __future__ import annotations

import argparse
import html
import json
import re
import subprocess
import tempfile
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
FONT_ARGS = ["--font-path", str(ROOT / "fonts")]
TOP_LIMIT = 5
EXCLUDED_SECTION_GROUPS = {"Preliminaries"}


def collect_document_data() -> dict[str, object]:
    probe = """#include "main.typ"

#context {
  let headings = query(heading).filter(it => it.outlined and it.level <= 2).map(it => (
    level: it.level,
    title: repr(it.body),
    page: counter(page).at(it.location()).first(),
  ))
  let refs = query(ref).map(it => {
    let found = query(it.target)
    if found.len() > 0 {
      let x = found.first()
      (
        target: repr(it.target),
        page: counter(page).at(x.location()).first(),
        pos: x.location().position(),
      )
    }
  }).filter(it => it != none)
  [#metadata((headings: headings, refs: refs)) <statistics-data>]
}
"""
    with tempfile.NamedTemporaryFile("w", dir=ROOT, suffix=".typ", delete=False, encoding="utf-8") as handle:
        handle.write(probe)
        probe_path = Path(handle.name)
    try:
        output = subprocess.check_output(
            ["typst", "query", str(probe_path), "<statistics-data>", "--one", "--field", "value", *FONT_ARGS],
            cwd=ROOT,
            text=True,
        )
    finally:
        probe_path.unlink(missing_ok=True)
    result = json.loads(output)
    assert isinstance(result, dict)
    return result


def section_ranking(headings: object, total_pages: int) -> list[dict[str, object]]:
    assert isinstance(headings, list)
    sections = []
    current_group = ""
    for index, heading in enumerate(headings):
        title = clean_repr(heading["title"])
        level = int(heading["level"])
        if level == 1:
            current_group = title
            continue
        if current_group in EXCLUDED_SECTION_GROUPS:
            continue
        start = int(heading["page"])
        next_page = next(
            (int(next_heading["page"]) for next_heading in headings[index + 1 :] if int(next_heading["level"]) == 2),
            total_pages + 1,
        )
        sections.append(
            {
                "title": title,
                "start": start,
                "pages": max(1, next_page - start),
            }
        )
    return sorted(sections, key=lambda item: (-int(item["pages"]), int(item["start"])))


def clean_repr(value: str) -> str:
    if value.startswith("[") and value.endswith("]"):
        return value[1:-1]
    text_parts = re.findall(r"\[([^\[\]]*)\]", value)
    return "".join(text_parts).strip() or value


def ref_ranking(references: object) -> list[dict[str, object]]:
    assert isinstance(references, list)
    grouped: dict[str, dict[str, object]] = {}
    for reference in references:
        target = reference["target"]
        if not re.fullmatch(r"<[^>]+>", target):
            continue
        label = target[1:-1]
        if label.startswith(("local-scope-", "_mannot-")):
            continue
        grouped.setdefault(label, {"label": label, "mentions": 0, "page": reference["page"], "pos": reference["pos"]})
        grouped[label]["mentions"] = int(grouped[label]["mentions"]) + 1
    return sorted(grouped.values(), key=lambda item: (-int(item["mentions"]), str(item["label"])))[:TOP_LIMIT]


def points(value: str) -> float:
    return float(value.removesuffix("pt"))


def render_preview(item: dict[str, object], output_dir: Path) -> str:
    label = str(item["label"])
    page = int(item["page"])
    position = item["pos"]
    y = points(position["y"])
    slug = re.sub(r"[^a-zA-Z0-9_-]+", "-", label).strip("-").lower()
    asset_dir = output_dir / "statistics-assets"
    asset_dir.mkdir(parents=True, exist_ok=True)
    asset = asset_dir / f"{slug}.svg"
    subprocess.run(
        ["typst", "compile", str(ROOT / "main.typ"), str(asset), "--pages", str(page), *FONT_ARGS],
        cwd=ROOT,
        check=True,
    )
    svg = asset.read_text(encoding="utf-8")
    crop_y = max(0.0, min(841.89 - 190.0, y - 85.0))
    svg = re.sub(r'viewBox="[^"]+"', f'viewBox="35 {crop_y:.2f} 525 190"', svg, count=1)
    svg = re.sub(r'width="[^"]+" height="[^"]+"', 'width="525pt" height="190pt"', svg, count=1)
    asset.write_text(svg, encoding="utf-8")
    return f"statistics-assets/{asset.name}"


def pdf_pages(pdf: Path) -> int:
    output = subprocess.check_output(["pdfinfo", str(pdf)], text=True)
    match = re.search(r"^Pages:\s+(\d+)$", output, re.MULTILINE)
    if not match:
        raise RuntimeError(f"Could not read page count from {pdf}")
    return int(match.group(1))


def page_html(sections: list[dict[str, object]], tags: list[dict[str, object]], total_pages: int) -> str:
    visible_sections = sections[:TOP_LIMIT]
    max_pages = max(int(section["pages"]) for section in sections)
    section_rows = "\n".join(
        f'''<li class="rank-row"><span class="rank">{rank}</span><div class="rank-copy"><strong>{html.escape(str(item["title"]))}</strong><span>Starts on page {item["start"]}</span></div><strong class="metric">{item["pages"]} pages</strong><span class="bar" style="--value:{int(item["pages"]) / max_pages:.3f}"></span></li>'''
        for rank, item in enumerate(visible_sections, 1)
    )
    tag_rows = "\n".join(
        f'''<article class="tag-row"><div class="tag-head"><span class="rank">{rank}</span><div><strong>{html.escape(str(item["label"]).replace("_", " "))}</strong><span>{item["mentions"]} mentions · page {item["page"]}</span></div></div><a href="main.pdf#page={item["page"]}" aria-label="Open target on page {item["page"]}"><img src="{item["asset"]}" alt="Rendered target for {html.escape(str(item["label"]))}" loading="lazy"></a></article>'''
        for rank, item in enumerate(tags, 1)
    )
    return f'''<!doctype html>
<html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Note Statistics · Partial Differential Equations</title><meta name="description" content="Live section and global tag rankings for the PDE Typst notes.">
<link rel="preconnect" href="https://fonts.googleapis.com"><link rel="preconnect" href="https://fonts.gstatic.com" crossorigin><link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet"><link rel="stylesheet" href="site.css">
</head><body class="site-body statistics-page"><div class="site-shell"><nav class="site-nav" aria-label="Primary navigation"><a class="site-brand" href="index.html">PDE Notes</a><div class="site-nav-links"><a href="index.html">Home</a><a href="main.pdf">Read PDF ↗</a><a class="is-current" href="statistics.html">Statistics</a></div></nav><header class="site-hero"><span class="site-eyebrow">Build-derived statistics</span><h1>Where the note gets dense.</h1><p>Rankings are regenerated from the compiled Typst document on every GitHub Pages deployment.</p><div class="summary"><div><strong>{total_pages}</strong><span>total pages</span></div><div><strong>{len(visible_sections)}</strong><span>ranked sections</span></div><div><strong>{sum(int(item["mentions"]) for item in tags)}</strong><span>top-tag mentions</span></div></div></header><main class="site-main statistics-main"><section id="hardest-sections"><h2>Hardest sections</h2><p class="statistics-intro">Measured by pages until the next level-two section. Preliminaries are omitted.</p><ol class="rank-list">{section_rows}</ol></section><section id="global-tags"><h2>Most mentioned global tags</h2><p class="statistics-intro">Only resolved global references count. Each preview is the content the tag points to.</p>{tag_rows}</section></main><footer class="site-footer">Generated from main.typ and main.pdf. <a href="index.html">Back to the homepage</a>.</footer></div></body></html>'''


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--output-dir", type=Path, default=ROOT)
    args = parser.parse_args()
    output_dir = args.output_dir.resolve()
    output_dir.mkdir(parents=True, exist_ok=True)
    total_pages = pdf_pages(ROOT / "main.pdf")
    data = collect_document_data()
    sections = section_ranking(data["headings"], total_pages)
    tags = ref_ranking(data["refs"])
    asset_dir = output_dir / "statistics-assets"
    if asset_dir.exists():
        for stale_asset in asset_dir.glob("*.svg"):
            stale_asset.unlink()
    for item in tags:
        item["asset"] = render_preview(item, output_dir)
    (output_dir / "statistics.html").write_text(page_html(sections, tags, total_pages), encoding="utf-8")
    print(f"Generated statistics.html with {len(sections)} sections and {len(tags)} tag previews")


if __name__ == "__main__":
    main()
