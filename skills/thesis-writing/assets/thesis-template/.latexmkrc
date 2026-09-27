@default_files = ('thesis.tex');

$pdf_mode = 1;
$pdflatex = 'xelatex -interaction=nonstopmode -synctex=1 %O %S';
$bibtex = 'bibtex %O %B';
$bibtex_use = 1;
