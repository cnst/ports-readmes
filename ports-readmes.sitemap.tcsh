#!/usr/local/bin/tcsh
# http://ports.su/ sitemap generator
# Author: Constantine A. Murenin aka cnst, 2013-04-07

echo '<?xml version="1.0" encoding="UTF-8"?>'
echo '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">'

foreach i ('' `find share -type f -mtime -1 -name "*.html" | \
    sed 's#^share/##g;s#.html$##g'`)
	echo '<url><loc>http://ports.su/'$i'</loc></url>'
end

echo '</urlset>'
