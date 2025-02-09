# Use xournalpp to make pdfs from .xopp files if the pdf doesn't exist or the .xopp file is newer than the pdf 
for file in *.xopp; do
  pdfname=$(echo "$file" | sed 's/.xopp/.pdf/')
  if [ ! -f "$pdfname" ] || [ "$file" -nt "$pdfname" ]; then
    xournalpp "$file" -p "$pdfname"
  fi
done
