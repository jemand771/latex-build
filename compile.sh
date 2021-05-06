# ln -s /latex/_minted-main /latex/latex.out/_minted-main
if [ ! "$CLEAN_BUILD" == "" ] && [ -d "/latex/$BUILD_DIRECTORY_RELATIVE" ]; then
  rm -r /latex/$BUILD_DIRECTORY_RELATIVE
fi
mkdir -p /latex/$BUILD_DIRECTORY_RELATIVE
cp -r /latex/* /latex/$BUILD_DIRECTORY_RELATIVE/
cd /latex/$BUILD_DIRECTORY_RELATIVE
python3 /latexrun.py --latex-args=--shell-escape --bibtex-cmd biber -O . $WARNINGS $TARGET && \
cp /latex/$BUILD_DIRECTORY_RELATIVE/main.pdf /latex/main.pdf && \
if [ ! "$DELETE_TEMP" == "" ]; then
  rm -r /latex/$BUILD_DIRECTORY_RELATIVE
fi

#pdflatex --shell-escape "$TARGET"
#biber "$TARGET"
#pdflatex --shell-escape "$TARGET"
#pdflatex --shell-escape "$TARGET"