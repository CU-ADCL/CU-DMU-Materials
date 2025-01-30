
# Use xournalpp to make pdf versions of all .xopp files
for file in *.xopp; do
  pdfname=$(echo "$file" | sed 's/.xopp/.pdf/')
  xournalpp "$file" -p "$pdfname"
done
