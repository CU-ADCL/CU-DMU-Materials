# Use xournalpp to make pdfs from .xopp files if the pdf doesn't exist or the .xopp file is newer than the pdf
for file in *.xopp; do
  pdfname=$(echo "$file" | sed 's/.xopp/.pdf/')
  outputpath="../$pdfname"
  if [ ! -f "$outputpath" ] || [ "$file" -nt "$outputpath" ]; then
    xournalpp "$file" -p "$outputpath"
  fi
done
