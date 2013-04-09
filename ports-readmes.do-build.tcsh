#!/usr/local/bin/tcsh
# http://ports.su/ generator

alias idate	date "+%Y-%m-%dT%H:%M:%S%z"
alias uptime	'env LC_TIME=fr_FR.UTF-8 uptime | sed "s@^[ 0-9:AaPp]*[Mm]@@"'

echo `idate` "starting ${0}"
uptime
echo

set FILESDIR=files
set WRKBUILD=share
set LOCALBASE=.
set SQLPORTS=sqlports-compact-`date +%Y-%m-%d`.tgz

test ! -e ${FILESDIR}/make-readmes && exit 1

mkdir -p ${WRKBUILD} || exit 2

test ! -e ${SQLPORTS} && \
( mv sqlports-compact-*.tgz ${WRKBUILD}; \
echo `idate` "wget:"; \
time wget -6 --progress=dot:mega \
"ftp://ftp.nluug.nl/pub/OpenBSD/snapshots/packages/`uname -m`/sqlports-compact-*.tgz" \
-O ${SQLPORTS} ; echo; \
echo `idate` "tar:"; \
time tar -xzf ${SQLPORTS} share ; echo )

echo `idate` "perl make-readmes started..."
time env	TEMPLATESDIR=${FILESDIR} \
	OUTPUTDIR=${WRKBUILD} \
	DATABASE=${LOCALBASE}/share/sqlports-compact \
	    perl ${FILESDIR}/make-readmes >/dev/null
uptime
echo `idate` "perl make-readmes finished."
echo

echo `idate` generating sitemap.
time ${LOCALBASE}/ports-readmes.sitemap.tcsh > ${WRKBUILD}/sitemap.new.xml
mv ${WRKBUILD}/sitemap.new.xml ${WRKBUILD}/sitemap.xml
echo -n "sitemap.xml: "
fgrep '<loc>http://ports.su/' ${WRKBUILD}/sitemap.xml | wc -l
time wget -6 --progress=dot:mega -O /dev/null -S \
	"http://google.com/ping?sitemap=http://ports.su/sitemap.xml"
time wget -6 --progress=dot:mega -O /dev/null -S \
	"http://www.bing.com/ping?sitemap=http://ports.su/sitemap.xml"
echo

echo `idate` potentially stale:
time find ${WRKBUILD} -type f -mmin +60
echo

echo `idate` just how stale:
find ${WRKBUILD} -type f -mmin +60 | xargs stat -r | cut -d" " -f8,10,15 \
    | awk '{print "echo `date -r" $2 " +%Y-%m-%dT%H:%M:%S` " $3 " " $1}' \
    | sort -n -k4 | sh
echo

time
uptime
echo `idate` done.
