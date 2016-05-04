#!/bin/sh
#DMMのグラビアから1ページ目を抽出する例。

FILENAME="index.html"
OUTPUT=""
NEWFILENAME=""
TITLEMODE=FALSE
ACTRESSMODE=FALSE

function getranking(){

	#人気順の場合をdl
	wget http://www.dmm.com/digital/idol/-/list/=/sort=ranking/view=text/
	NEWFILENAME=`date "+%Y_%m_%d"`_ranking.html
	OUTPUT=`date "+%Y_%m_%d"`_ranking
	
	mv -f $FILENAME $NEWFILENAME
}

function getdate(){

	#新着順の場合 indexをdl
	wget http://www.dmm.com/digital/idol/-/list/=/sort=date/view=text/
	NEWFILENAME=`date "+%Y_%m_%d"`_date.html
	OUTPUT=`date "+%Y_%m_%d"`_date
	mv -f $FILENAME $NEWFILENAME
}

function selectmode(){
	echo  "What do you want? (t/a)_title_or_actress:"
	read select

	case "$select" in
		"t")
			echo "title mode select"
			TITLEMODE=TRUE
			;;
		"a")
			echo "actress mode select"
			ACTRESSMODE=TRUE
			;;

		\?)
			echo "mistake!"
			exit 1;;
	esac			

}

function ranking(){

	if [ $TITLEMODE = TRUE ] ; then
	grep /digital/idol/ "$NEWFILENAME"| cut -f4 -d">" | tr -d "</a" |tr -d "td" | grep -v spn|grep -v li |sed '/^$/d' |grep  -v opion >"$OUTPUT"_title.txt 

	fi

	if [ $ACTRESSMODE = TRUE ] ; then
		 grep /digital/idol/ "$NEWFILENAME" | cut -f3 -d">" |grep -v img | grep -v span | grep -v "<a href" | grep -v "option" |tr -d "</a" |sed -e "s/[0-9]//g"|tr -d "次へ"|tr -d "最後へ"| sed '/^$/d' | sed -e "1,15d" |LC_ALL=C  sort|LC_ALL=C uniq >"$OUTPUT"_actress.txt

	fi
}

function dating(){

	if [ $TITLEMODE = TRUE ] ; then
		grep /digital/idol/ "$NEWFILENAME" | cut -f4 -d">" | tr -d "</a" |tr -d "td" | grep -v spn|grep -v li |sed '/^$/d' |grep  -v opion | grep -v href > "$OUTPUT"_title.txt 

	fi		
			

	if [ $ACTRESSMODE = TRUE ] ; then
		grep /digital/idol/ "$NEWFILENAME" | cut -f3 -d">" |grep -v img | grep -v span | grep -v "<a href" | grep -v "option" |tr -d "</a" |sed -e "s/[0-9]//g"|tr -d "次へ"|tr -d "最後へ"| sed '/^$/d' | sed -e "1,15d"|LC_ALL=C sort| LC_ALL=C uniq > "$OUTPUT"_actress.txt

	fi

}

#ここから

if [ $# -ne 1 ] ; then
	    echo "Usage: prompt> $0 r_anking or d_ate "
	        exit 1
	fi


while getopts rd opt
do
	case ${opt} in
		r)
			selectmode
			getranking
			ranking
			;;
		d)
			selectmode
			getdate
			dating
			;;
		\?)
			echo "input r/d (ranking or date)"
			exit 1
			;;			
	esac
done	

