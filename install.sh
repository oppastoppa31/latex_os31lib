#!/bin/bash

INSTALL_DIR="$(kpsewhich -var-value=TEXMFHOME)/tex/latex/os31lib"

mkdir build
rm -rf build/*

cd build || exit 1

# Copy the necessary files from the parent directory to the build directory.

# DocTex package.
cp ../os31lib.dtx .

# os31lib.ins is used to generate os31lib.sty from os31lib.dtx.
cp ../os31lib.ins .

# Generate os31lib.sty from os31lib.dtx using the .ins file.
latex ./os31lib.ins

# Generate os31lib.pdf from os31lib.dtx.
pdflatex ./os31lib.dtx

# Generate the index and glossary files.
makeindex -s gind.ist ./os31lib.idx
makeindex -s gglo.ist -o ./os31lib.gls ./os31lib.glo

# Generate complete os31lib.pdf from os31lib.dtx.
pdflatex ./os31lib.dtx
pdflatex ./os31lib.dtx
pdflatex ./os31lib.dtx

# Remove all the comment lines (starting with "%% ") from the generated files.
sed -i 's/%% //g' os31lib.cwl
sed -i 's/%% //g' os31lib.json

# Copy the generated os31lib.pdf to the parent directory for easy access to the
# documentation.
cp ./os31lib.pdf ../

# Copy the generated Intellisense metadata files to the parent directory for
# easy access to the completion metadata.
cp ./os31lib.cwl ../
cp ./os31lib.json ../

# Install the package globally.
mkdir -p "${INSTALL_DIR}"

cp os31lib.cwl "${INSTALL_DIR}/os31lib.cwl"
cp os31lib.json "${INSTALL_DIR}/os31lib.json"
cp os31lib.sty "${INSTALL_DIR}/os31lib.sty"
cp os31lib.pdf "${INSTALL_DIR}/os31lib.pdf"

# Regenerate the TeX filename database.
texhash

cd ..

echo "Installation complete."
echo "The os31lib package has been installed to ${INSTALL_DIR}."
