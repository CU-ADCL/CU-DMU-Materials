for file in ./*.pdf
do
    gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/screen -dNOPAUSE -dBATCH -sOutputFile=tmp.pdf "$file"
    mv tmp.pdf "$file"
done
