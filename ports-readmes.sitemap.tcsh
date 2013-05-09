#!/usr/local/bin/tcsh
# http://ports.su/ sitemap generator
# Author: Constantine A. Murenin aka cnst, 2013-04-07

echo '<?xml version="1.0" encoding="UTF-8"?>'
echo '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">'

echo '<url><loc>http://ports.su/</loc></url>'

foreach i (`find share -type f -mtime -1 -name "*.html" | \
    sed 's#^share/##g;s#\.html$##g'`)
	set lastmod
	set changefreq
	set priority
	if ( -d share/$i ) then
		#set lastmod=`stat -f %m share/$i`	# does not account for non-primary cat
		#set lastmod=`date -r $lastmod +%Y-%m-%d`
		#set lastmod="<lastmod>$lastmod</lastmod>"
		#set changefreq="<changefreq>monthly</changefreq>"
		#set priority="<priority>0.2</priority>"
	else
		#set lastmod=""
		#set changefreq="<changefreq>yearly</changefreq>"
		#set priority=""
	endif
	echo '<url><loc>http://ports.su/'$i'</loc>'$lastmod$changefreq$priority'</url>'
end

echo '</urlset>'
