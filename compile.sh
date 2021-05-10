# ln -s /latex/_minted-main /latex/latex.out/_minted-main
BUILDDIR_FULL=$BIND_PATH/$BUILD_DIRECTORY
if [ ! "$CLEAN_BUILD" == "" ] && [ -d "$BUILDDIR_FULL" ]; then
  rm -r "$BUILDDIR_FULL"
fi
mkdir -p "$BUILDDIR_FULL"
cp -r "$BIND_PATH"/* "$BUILDDIR_FULL/"
cd "$BUILDDIR_FULL"
python3 /latexrun.py --latex-args=--shell-escape --bibtex-cmd biber -O . $WARNINGS $TARGET && \
cp "$BUILDDIR_FULL/main.pdf" "$BIND_PATH/main.pdf" && \
if [ ! "$DELETE_TEMP" == "" ]; then
  rm -r "$BUILDDIR_FULL"
fi

#pdflatex --shell-escape "$TARGET"
#biber "$TARGET"
#pdflatex --shell-escape "$TARGET"
#pdflatex --shell-escape "$TARGET"