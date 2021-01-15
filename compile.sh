TARGET=main
pdflatex --shell-escape "$TARGET"
biber "$TARGET"
pdflatex --shell-escape "$TARGET"
pdflatex --shell-escape "$TARGET"