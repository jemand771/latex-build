BUILDDIR_FULL=$BIND_PATH/$BUILD_DIRECTORY
if [ ! "$CLEAN_BUILD" == "" ] && [ -d "$BUILDDIR_FULL" ]; then
  rm -r "$BUILDDIR_FULL"
fi
mkdir -p "$BUILDDIR_FULL"
cp -r -u "$BIND_PATH"/* "$BUILDDIR_FULL/"
cd "$BUILDDIR_FULL"
# this variable is empty by default -> fill to disable
if [ "$DISABLE_PYTHONTEX" == "" ]; then
  # we could use a bare pdflatex here
  # however, latexrun itself is smart enough to only run pdflatex once
  # don't print the output since latexrun will be re-run anyway
  python3 /latexrun.py --latex-args=--shell-escape --bibtex-cmd biber -O . $WARNINGS $TARGET > /dev/null
  if [ -f "$BUILDDIR_FULL/$TARGET.pytxcode" ]; then
    # only run pythontex if a pytxcode file was generated
    # this prevents the useless invocation of pythontex when the package wasn't used at all
    if ! pythontex --interpreter python:python3 $TARGET &> "$BUILDDIR_FULL/$TARGET.pythontex.log"; then
      # ony forward the pythontex log output if errors occured - we don't care otherwise
      cat "$BUILDDIR_FULL/$TARGET.pythontex.log"
    fi
  fi
fi
# this is a && chain - new files won't be copied if the build fails
python3 /latexrun.py --latex-args=--shell-escape --bibtex-cmd biber -O . $WARNINGS $TARGET && \
cp -u "$BUILDDIR_FULL/main.pdf" "$BIND_PATH/main.pdf" && \
if [ ! "$DELETE_TEMP" == "" ]; then
  rm -r "$BUILDDIR_FULL"
fi
