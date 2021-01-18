if [ ! "$CLEAN_BUILD" == "" ]; then
  rm -r /latex/latex.out
fi
python3 /latexrun.py --latex-args=--shell-escape --bibtex-cmd biber $WARNINGS $TARGET
if [ ! "$DELETE_TEMP" == "" ]; then
  rm -r /latex/latex.out
fi

#pdflatex --shell-escape "$TARGET"
#biber "$TARGET"
#pdflatex --shell-escape "$TARGET"
#pdflatex --shell-escape "$TARGET"