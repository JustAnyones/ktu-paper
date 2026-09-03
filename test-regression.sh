#!/bin/bash

# Clean up previous test results
if [ -d "tests/original-res" ]; then
    rm -r tests/original-res
fi
if [ -d "tests/modified-res" ]; then
    rm -r tests/modified-res
fi
if [ -d "tests/modified" ]; then
    rm -r tests/modified
fi
if [ -d "tests/original/src" ]; then
    rm -r tests/original/src
fi

mkdir -p tests/original-res
mkdir -p tests/modified-res

# Copy current template
cp -r src/ tests/original/src

cp -r tests/original tests/modified
# replace the "#import "@local/ktu-paper:0.1.0"" 
# with "#import "./src/lib.typ"" in the modified files
find tests/modified -type f -name "*.typ" -exec \
    sed -i 's/#import "@local\/ktu-paper:0.1.0"/#import ".\/src\/lib.typ"/g' {} \;
find tests/modified -type f -name "ataskaita.typ" -exec \
    sed -i 's/setup-page/ktu-paper/g' {} \;

# Compile the original document
typst compile --root tests/original tests/original/ataskaita.typ "tests/original-res/{0p}.png"
# Compile the modified document
typst compile --root tests/modified tests/modified/ataskaita.typ "tests/modified-res/{0p}.png"
typst compile --root tests/modified tests/modified/ataskaita.typ "tests/modified.pdf"

# Compare the results
diff -r tests/original-res tests/modified-res
if [ $? -eq 0 ]; then
    echo "No differences found between original and modified results."
else
    echo "Differences found between original and modified results."
fi
