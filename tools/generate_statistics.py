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
<style>
:root{{--paper:#f7f7f4;--surface:#fff;--ink:#17201d;--muted:#66706c;--line:#d9dedb;--teal:#167d83;--coral:#c95743}}
*{{box-sizing:border-box}} body{{margin:0;background:var(--paper);color:var(--ink);font:15px/1.5 Inter,ui-sans-serif,system-ui,sans-serif;letter-spacing:0}} a{{color:inherit}} .shell{{width:min(1100px,calc(100% - 32px));margin:auto}} nav{{height:64px;display:flex;align-items:center;justify-content:space-between;border-bottom:1px solid var(--line)}} nav a{{text-decoration:none;font-weight:700}} nav .back{{color:var(--teal)}} header{{padding:64px 0 38px;border-bottom:1px solid var(--line)}} .eyebrow{{font:700 12px ui-monospace,monospace;text-transform:uppercase;color:var(--coral)}} h1{{font:800 clamp(36px,7vw,72px)/1.02 Georgia,serif;margin:12px 0;max-width:760px}} header p{{color:var(--muted);max-width:620px;font-size:17px}} .summary{{display:flex;gap:28px;margin-top:28px}} .summary strong{{display:block;font-size:24px}} .summary span,.rank-copy span,.tag-head span{{display:block;color:var(--muted);font-size:13px}} main{{display:grid;grid-template-columns:1fr 1.25fr;gap:56px;padding:48px 0 80px}} h2{{font:700 25px Georgia,serif;margin:0 0 8px}} .intro{{color:var(--muted);margin:0 0 24px}} ol{{list-style:none;padding:0;margin:0}} .rank-row{{position:relative;display:grid;grid-template-columns:32px 1fr auto;gap:12px;align-items:center;padding:15px 0;border-top:1px solid var(--line);overflow:hidden}} .rank{{font:700 13px ui-monospace,monospace;color:var(--coral)}} .metric{{font-size:13px}} .bar{{position:absolute;left:44px;bottom:0;width:calc((100% - 44px)*var(--value));height:2px;background:var(--teal)}} .tag-row{{border-top:1px solid var(--line);padding:16px 0 22px}} .tag-head{{display:grid;grid-template-columns:32px 1fr;gap:12px;margin-bottom:12px}} .tag-head strong{{overflow-wrap:anywhere}} .tag-row a{{display:block;background:#fff;border:1px solid var(--line);overflow:hidden}} .tag-row img{{display:block;width:100%;height:150px;object-fit:cover}} footer{{border-top:1px solid var(--line);padding:24px 0 48px;color:var(--muted);font-size:13px}}
@media(max-width:800px){{header{{padding-top:42px}} main{{grid-template-columns:1fr;gap:48px}} .summary{{gap:18px}} .tag-row img{{height:120px}}}}
@media(prefers-color-scheme:dark){{:root{{--paper:#141816;--surface:#1c211f;--ink:#eef2ef;--muted:#a3ada8;--line:#343b37;--teal:#56bdc0;--coral:#ed8a75}} .tag-row a{{background:#fff}}}}
</style></head><body><div class="shell"><nav><a href="index.html">PDE Notes</a><a class="back" href="main.pdf">Open PDF ↗</a></nav><header><span class="eyebrow">Build-derived statistics</span><h1>Where the note gets dense.</h1><p>Rankings are regenerated from the compiled Typst document on every GitHub Pages deployment.</p><div class="summary"><div><strong>{total_pages}</strong><span>total pages</span></div><div><strong>{len(visible_sections)}</strong><span>ranked sections</span></div><div><strong>{sum(int(item["mentions"]) for item in tags)}</strong><span>top-tag mentions</span></div></div></header><main><section><h2>Hardest sections</h2><p class="intro">Measured by pages until the next level-two section. Preliminaries are omitted.</p><ol>{section_rows}</ol></section><section><h2>Most mentioned global tags</h2><p class="intro">Only resolved global references count. Each preview is the content the tag points to.</p>{tag_rows}</section></main><footer>Generated from main.typ and main.pdf. Click a preview to open its source page.</footer></div></body></html>'''


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
