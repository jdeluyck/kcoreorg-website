# change img with alt
sed -i -E 's/<img[^>]*src="([^"]*)[^>]*alt="([^"]*)[^>]*>/![\2](\1 "\2")/gi' *.md

# change img without alt
sed -i  -E 's/<img[^>]*src="([^"]*)[^>]/![](\1)/g' *.md

# Change a href
sed -i -E 's/<a[^>]*href="([^"]*)[^>]*>([^<]*)[^>]*>/[\2](\1)/gi' *.md

