#!/bin/bash
BUILDDIR_FULL=$BIND_PATH/$BUILD_DIRECTORY
if [ ! "$CLEAN_BUILD" = "" ] && [ -d "$BUILDDIR_FULL" ]; then
  rm -r "$BUILDDIR_FULL"
fi
mkdir -p "$BUILDDIR_FULL"
cp -r -u "$BIND_PATH"/* "$BUILDDIR_FULL/"
cd "$BUILDDIR_FULL"
# this variable is empty by default -> fill to disable
if [ "$DISABLE_PYTHONTEX" = "" ]; then
  # we could use a bare pdflatex here
  # however, latexrun itself is smart enough to only run pdflatex once
  # don't print the output since latexrun will be re-run anyway
  python3 /latexrun.py --latex-args=--shell-escape --bibtex-cmd biber -O . $WARNINGS $TARGET > /dev/null
  if [ -f "$TARGET.pytxcode" ]; then
    # only run pythontex if a pytxcode file was generated
    # this prevents the useless invocation of pythontex when the package wasn't used at all
    if ! pythontex --interpreter python:python3 $TARGET &> "$BUILDDIR_FULL/$TARGET.pythontex.log"; then
      # ony forward the pythontex log output if errors occured - we don't care otherwise
      cat "$TARGET.pythontex.log"
    fi
  fi
fi
LATEX_ARGS="--shell-escape"
if [ "$DISABLE_SYNCTEX" = "" ]; then
  LATEX_ARGS="$LATEX_ARGS --synctex=1"
fi
# this is a && chain - new files won't be copied if the build fails
python3 /latexrun.py --latex-args="$LATEX_ARGS" --bibtex-cmd biber -O . $WARNINGS $TARGET && \
if [ "$DISABLE_SYNCTEX" = "" ]; then
  # extract, rewrite and re-gz synctex
  gunzip $TARGET.synctex.gz
  # use python to re-write file paths (sed kept messing with windows' backslashes)
  python3 -c "import sys; print(sys.stdin.read().replace(*sys.argv[1:3]))" "$BUILDDIR_FULL" "$HOST_PATH" < $TARGET.synctex > synctex.temp
  mv synctex.temp $TARGET.synctex
  # LaTeX workshop uses an uncompressed .synctex file instead of .synctex.gz so we don't have to recompress it
  cp -u "$TARGET.synctex" "$BIND_PATH/$TARGET.synctex"
fi && \
cp -u "$TARGET.pdf" "$BIND_PATH/$TARGET.pdf" && \
if [ ! "$DELETE_TEMP" = "" ]; then
  cd /
  rm -r "$BUILDDIR_FULL"
fi
