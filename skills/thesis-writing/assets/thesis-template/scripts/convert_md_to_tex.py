#!/usr/bin/env python3
"""Convert one thesis Markdown file into generated LaTeX chapter files."""

from __future__ import annotations

import argparse
import re
from html.parser import HTMLParser
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
DEFAULT_SOURCE = ROOT / "markdown" / "thesis.md"
DEFAULT_OUTPUT = ROOT / "chapters"
CITE_KEY = r"[A-Za-z0-9][A-Za-z0-9_:.+-]*"
LATEX_ESCAPES = {
    "\\": r"\textbackslash{}",
    "{": r"\{",
    "}": r"\}",
    "$": r"\$",
    "%": r"\%",
    "&": r"\&",
    "#": r"\#",
    "_": r"\_",
    "^": r"\textasciicircum{}",
    "~": r"\textasciitilde{}",
}
MARKDOWN_ESCAPABLE = frozenset(r"\`*{}[]()#+-.!_$%&")


def display_length(value: str) -> int:
    return sum(2 if ord(character) > 127 else 1 for character in value)


def is_number(value: str) -> bool:
    compact = (
        value.strip()
        .replace("$", "")
        .replace(r"\%", "")
        .replace("%", "")
        .replace(",", "")
        .replace(" ", "")
        .replace("+", "")
    )
    return compact in {"", "--", "—", "-"} or bool(
        re.fullmatch(r"-?\d*\.?\d+", compact)
    )


def escape_latex(text: str) -> str:
    escaped: list[str] = []
    index = 0
    while index < len(text):
        character = text[index]
        if (
            character == "\\"
            and index + 1 < len(text)
            and text[index + 1] in MARKDOWN_ESCAPABLE
        ):
            character = text[index + 1]
            index += 1
        escaped.append(LATEX_ESCAPES.get(character, character))
        index += 1
    return "".join(escaped)


def inline(text: str) -> str:
    """Convert the supported inline Markdown syntax to LaTeX."""
    protected: list[str] = []

    def stash(value: str) -> str:
        protected.append(value)
        return f"\x00T{len(protected) - 1}\x00"

    def convert_code(match: re.Match[str]) -> str:
        code = escape_latex(match.group(1))
        return stash(r"\texttt{%s}" % code)

    text = re.sub(r"`([^`]+)`", convert_code, text)
    text = re.sub(
        r"(?<!\\)\$(?:\\.|[^$\\])*\$",
        lambda match: stash(match.group(0)),
        text,
    )

    def convert_parenthetical_citation(match: re.Match[str]) -> str:
        keys = re.findall(rf"@({CITE_KEY})", match.group(1))
        return stash(r"\citep{%s}" % ",".join(keys))

    text = re.sub(r"\[([^\]]*?@[^\]]*?)\]", convert_parenthetical_citation, text)
    text = re.sub(
        rf"(?<![\w@])@({CITE_KEY})",
        lambda match: stash(r"\citet{%s}" % match.group(1)),
        text,
    )
    text = re.sub(
        r"\*\*(.+?)\*\*",
        lambda match: stash(r"\textbf{%s}" % escape_latex(match.group(1))),
        text,
    )
    text = escape_latex(text)
    token_pattern = re.compile(r"\x00T(\d+)\x00")
    while token_pattern.search(text):
        text = token_pattern.sub(
            lambda match: protected[int(match.group(1))], text
        )
    return text


def parse_heading(raw: str) -> tuple[str, str | None]:
    raw = raw.strip()
    attribute_match = re.search(r"\s*\{([^}]*)\}\s*$", raw)
    label = None
    if attribute_match:
        attributes = attribute_match.group(1)
        label_match = re.search(r"#([^\s.]+)", attributes)
        if label_match:
            label = label_match.group(1)
        raw = raw[: attribute_match.start()].strip()
    raw = re.sub(r"^(?:\d+(?:\.\d+)*)[　\s]+", "", raw)
    return raw, label


def chapter_title(raw: str) -> str:
    raw, _ = parse_heading(raw)
    return re.sub(
        r"^第[一二三四五六七八九十百]+章[　\s]*",
        "",
        raw,
    ).strip()


def table_cells(row: str) -> list[str]:
    row = row.strip().removeprefix("|").removesuffix("|")
    return [cell.strip() for cell in row.split("|")]


class HtmlTableParser(HTMLParser):
    """Flatten a Word-exported HTML table into rows for the LaTeX writer."""

    def __init__(self) -> None:
        super().__init__(convert_charrefs=True)
        self.rows: list[list[str]] = []
        self.current_row: list[str] | None = None
        self.current_cell: list[str] | None = None
        self.current_colspan = 1

    def handle_starttag(
        self, tag: str, attrs: list[tuple[str, str | None]]
    ) -> None:
        if tag == "tr":
            self.current_row = []
        elif tag in {"td", "th"}:
            self.current_cell = []
            attributes = dict(attrs)
            self.current_colspan = int(attributes.get("colspan") or 1)
        elif tag == "br" and self.current_cell is not None:
            self.current_cell.append("；")

    def handle_data(self, data: str) -> None:
        if self.current_cell is not None:
            self.current_cell.append(data)

    def handle_endtag(self, tag: str) -> None:
        if tag in {"td", "th"} and self.current_cell is not None:
            value = " ".join("".join(self.current_cell).split())
            if self.current_row is not None:
                self.current_row.append(value)
                self.current_row.extend([""] * (self.current_colspan - 1))
            self.current_cell = None
        elif tag == "tr" and self.current_row is not None:
            if self.current_row:
                self.rows.append(self.current_row)
            self.current_row = None


def html_table(raw: str) -> tuple[list[str], list[list[str]]]:
    parser = HtmlTableParser()
    parser.feed(raw)
    if not parser.rows:
        raise ValueError("An HTML table requires at least one row.")
    return parser.rows[0], parser.rows[1:]


def convert(source: Path, output_dir: Path) -> None:
    lines = source.read_text(encoding="utf-8").splitlines()
    output_dir.mkdir(parents=True, exist_ok=True)

    chapters: list[dict[str, object]] = []
    frontmatter: dict[str, list[str]] = {
        "abstract_zh": [],
        "abstract_en": [],
        "acknowledgements_zh": [],
    }
    current: list[str] | None = None
    index = 0

    def require_current() -> list[str]:
        if current is None:
            raise ValueError("Content must appear below a level-one heading (# Heading).")
        return current

    def emit(value: str = "") -> None:
        require_current().append(value)

    def next_nonempty(start: int) -> int:
        while start < len(lines) and not lines[start].strip():
            start += 1
        return start

    def read_table(start: int) -> tuple[list[str], list[list[str]], int]:
        rows: list[str] = []
        while start < len(lines) and lines[start].strip().startswith("|"):
            rows.append(lines[start].strip())
            start += 1
        if len(rows) < 2:
            raise ValueError("A Markdown table requires a header and separator row.")
        return table_cells(rows[0]), [table_cells(row) for row in rows[2:]], start

    def read_html_table(start: int) -> tuple[list[str], list[list[str]], int]:
        rows: list[str] = []
        while start < len(lines):
            rows.append(lines[start])
            start += 1
            if rows[-1].strip() == "</table>":
                header, data = html_table("\n".join(rows))
                return header, data, start
        raise ValueError("Unclosed HTML table.")

    def emit_table(
        caption: str | None,
        label: str | None,
        header: list[str],
        data: list[list[str]],
    ) -> None:
        column_count = len(header)
        for row in data:
            row.extend([""] * (column_count - len(row)))

        specifications: list[str] = []
        has_wrapped_column = False
        for column_index in range(column_count):
            values = [row[column_index] for row in data]
            nonempty = [value for value in values if value.strip() not in {"", "--", "—", "-"}]
            numeric = bool(nonempty) and all(is_number(value) for value in values)
            pure_math = bool(nonempty) and all(
                value.startswith("$") and value.endswith("$") for value in nonempty
            )
            if numeric:
                specifications.append("r")
            elif pure_math and display_length(header[column_index]) <= 14:
                specifications.append("l")
            elif display_length(header[column_index]) > 14 or max(
                [display_length(value) for value in values], default=0
            ) > 20:
                specifications.append("X")
                has_wrapped_column = True
            else:
                specifications.append("l")

        emit(r"\begin{table}[H]")
        emit(r"  \centering")
        emit(r"  \footnotesize")
        emit(r"  \setlength{\tabcolsep}{4pt}")
        if caption:
            emit(f"  \\caption{{{caption}}}")
        if label:
            emit(f"  \\label{{{label}}}")
        column_spec = "".join(specifications)
        if has_wrapped_column:
            emit(f"  \\begin{{tabularx}}{{\\textwidth}}{{{column_spec}}}")
        else:
            emit(r"  \begin{adjustbox}{max width=\textwidth}")
            emit(f"  \\begin{{tabular}}{{{column_spec}}}")
        emit(r"    \toprule")
        emit("    " + " & ".join(inline(cell) for cell in header) + r" \\")
        emit(r"    \midrule")
        for row in data:
            emit("    " + " & ".join(inline(cell) for cell in row) + r" \\")
        emit(r"    \bottomrule")
        if has_wrapped_column:
            emit(r"  \end{tabularx}")
        else:
            emit(r"  \end{tabular}")
            emit(r"  \end{adjustbox}")
        emit(r"\end{table}")
        emit()

    while index < len(lines):
        line = lines[index]
        stripped = line.strip()

        if line.startswith("# "):
            heading, heading_label = parse_heading(line[2:])
            normalized = heading.lower()
            if heading.startswith("參考文獻") or normalized == "references":
                break
            if heading.startswith("摘要"):
                current = frontmatter["abstract_zh"]
            elif normalized == "abstract":
                current = frontmatter["abstract_en"]
            elif heading.startswith("誌謝") or heading.startswith("謝辭"):
                current = frontmatter["acknowledgements_zh"]
            else:
                chapter_number = len(chapters) + 1
                chapter = {
                    "title": chapter_title(line[2:]),
                    "label": heading_label or f"c:chapter-{chapter_number:02d}",
                    "body": [],
                }
                chapters.append(chapter)
                current = chapter["body"]  # type: ignore[assignment]
            index += 1
            continue

        section_match = re.match(r"^(#{2,4})\s+(.+)$", line)
        if section_match:
            level = len(section_match.group(1))
            heading, heading_label = parse_heading(section_match.group(2))
            command = {2: "section", 3: "subsection", 4: "subsubsection"}[level]
            emit(f"\\{command}{{{inline(heading)}}}")
            if heading_label:
                emit(f"\\label{{{heading_label}}}")
            emit()
            index += 1
            continue

        if stripped.startswith("```"):
            emit(r"\begin{verbatim}")
            index += 1
            while index < len(lines) and not lines[index].strip().startswith("```"):
                emit(lines[index])
                index += 1
            emit(r"\end{verbatim}")
            emit()
            index += 1
            continue

        if stripped == "$$":
            equation: list[str] = []
            cursor = index + 1
            while cursor < len(lines) and lines[cursor].strip() != "$$":
                equation.append(lines[cursor])
                cursor += 1
            if cursor == len(lines):
                raise ValueError(f"Unclosed display-math block near line {index + 1}.")
            while require_current() and require_current()[-1] == "":
                require_current().pop()
            environment = "equation" if any(r"\tag{" in row for row in equation) else "equation*"
            emit(f"\\begin{{{environment}}}")
            for row in equation:
                emit(row.rstrip())
            emit(f"\\end{{{environment}}}")
            emit()
            index = cursor + 1
            continue

        figure_match = re.match(
            r"^!\[(.*?)\]\((.*?)\)\s*(?:\{#([^}]+)\})?\s*$", stripped
        )
        if figure_match:
            alt, path, explicit_label = figure_match.groups()
            caption = re.sub(r"^(?:圖|Figure)\s*\d+(?:\.\d+)?[　\s]*", "", alt)
            label = explicit_label
            number_match = re.search(r"(?:圖|Figure)\s*(\d+)\.(\d+)", alt)
            if label is None and number_match:
                label = f"fig:{number_match.group(1)}-{number_match.group(2)}"
            consumed = index
            quote_index = next_nonempty(index + 1)
            if quote_index < len(lines) and lines[quote_index].strip().startswith(">"):
                caption = lines[quote_index].strip().lstrip(">").strip()
                caption = re.sub(r"^\*\*(?:圖|Figure)\s*\d+(?:\.\d+)?\*\*[　\s]*", "", caption)
                consumed = quote_index
            emit(r"\begin{figure}[H]")
            emit(r"  \centering")
            emit(f"  \\includegraphics[width=\\linewidth]{{{path}}}")
            emit(f"  \\caption{{{inline(caption)}}}")
            if label:
                emit(f"  \\label{{{label}}}")
            emit(r"\end{figure}")
            emit()
            index = consumed + 1
            continue

        caption_match = re.match(r"^(?:表|Table)\s*(\d+)[.-](\d+)[　\s]+(.+)$", stripped)
        if caption_match:
            table_index = next_nonempty(index + 1)
            if table_index < len(lines) and lines[table_index].strip().startswith("|"):
                header, data, next_index = read_table(table_index)
                emit_table(
                    inline(caption_match.group(3)),
                    f"tab:{caption_match.group(1)}-{caption_match.group(2)}",
                    header,
                    data,
                )
                index = next_index
                continue
            if table_index < len(lines) and re.match(
                r"^<table(?:\s[^>]*)?>$", lines[table_index].strip()
            ):
                header, data, next_index = read_html_table(table_index)
                emit_table(
                    inline(caption_match.group(3)),
                    f"tab:{caption_match.group(1)}-{caption_match.group(2)}",
                    header,
                    data,
                )
                index = next_index
                continue

        if stripped.startswith("|"):
            header, data, next_index = read_table(index)
            emit_table(None, None, header, data)
            index = next_index
            continue

        if re.match(r"^<table(?:\s[^>]*)?>$", stripped):
            header, data, next_index = read_html_table(index)
            emit_table(None, None, header, data)
            index = next_index
            continue

        if stripped.startswith("- "):
            emit(r"\begin{itemize}")
            while index < len(lines) and lines[index].strip().startswith("- "):
                emit("  \\item " + inline(lines[index].strip()[2:]))
                index += 1
            emit(r"\end{itemize}")
            emit()
            continue

        if re.match(r"^\d+\.\s+", stripped):
            items: list[str] = []
            cursor = index
            while cursor < len(lines):
                item_match = re.match(r"^\d+\.\s+(.+)$", lines[cursor].strip())
                if not item_match:
                    break
                items.append(item_match.group(1))
                cursor += 1
            if len(items) >= 2:
                emit(r"\begin{enumerate}")
                for item in items:
                    emit("  \\item " + inline(item))
                emit(r"\end{enumerate}")
                emit()
                index = cursor
                continue

        if stripped == "---":
            index += 1
            continue
        if not stripped:
            emit()
            index += 1
            continue
        if stripped.startswith(">"):
            emit(inline(stripped.lstrip(">").strip()))
            emit()
            index += 1
            continue

        emit(inline(stripped))
        index += 1

    if not chapters:
        raise ValueError("No thesis chapters were found. Add at least one '# Chapter' heading.")

    for old_file in output_dir.glob("chapter_[0-9][0-9].tex"):
        old_file.unlink()

    generated_inputs: list[str] = []
    for chapter_number, chapter in enumerate(chapters, start=1):
        body = list(chapter["body"])
        while body and body[0] == "":
            body.pop(0)
        while body and body[-1] == "":
            body.pop()
        filename = f"chapter_{chapter_number:02d}.tex"
        output = [
            f"\\chapter{{{inline(str(chapter['title']))}}}",
            f"\\label{{{chapter['label']}}}",
            "",
            *body,
            "",
        ]
        (output_dir / filename).write_text("\n".join(output), encoding="utf-8")
        generated_inputs.append(f"\\input{{chapters/{filename.removesuffix('.tex')}}}")

    (output_dir / "generated_inputs.tex").write_text(
        "\n".join(generated_inputs) + "\n", encoding="utf-8"
    )

    for name, body in frontmatter.items():
        destination = output_dir / f"{name}.tex"
        cleaned = list(body)
        while cleaned and cleaned[0] == "":
            cleaned.pop(0)
        while cleaned and cleaned[-1] == "":
            cleaned.pop()
        if cleaned:
            destination.write_text("\n".join(cleaned) + "\n", encoding="utf-8")
        elif destination.exists():
            destination.unlink()

    print(f"Converted {source} into {len(chapters)} chapter file(s) in {output_dir}")


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("source", nargs="?", type=Path, default=DEFAULT_SOURCE)
    parser.add_argument("--output-dir", type=Path, default=DEFAULT_OUTPUT)
    arguments = parser.parse_args()
    convert(arguments.source.resolve(), arguments.output_dir.resolve())


if __name__ == "__main__":
    main()