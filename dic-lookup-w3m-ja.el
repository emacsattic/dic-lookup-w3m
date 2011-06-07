;;; dic-lookup-w3m-ja.el --- look up dictionaries on the Internet

;; Copyright (C) 2008, 2009, 2010, 2011  mcprvmec

;; Author: mcprvmec

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:

;; Look up in dictionaries on the Internet using emacs-w3m.

;;; Code:

(defvar dic-lookup-w3m-search-engine-alist '())

(defun dic-lookup-w3m-search-engine-postget (list)
  (append
   list
   (mapcar
    '(lambda (elem)
       (append
	(list (concat (nth 0 elem) "-get")
	      (concat (nth 1 elem) "?" (nth 3 elem))
	      (nth 2 elem))
	(if (nth 4 elem)
	    (append '(nil) (nthcdr 4 elem)))))
    list)))

(mapc
 '(lambda (elem) (add-to-list 'dic-lookup-w3m-search-engine-alist elem))
 `(
   ;; yahoo dtype; 0:$B9q8l(B, 1:$B1QOB(B, 2:$B$9$Y$F$N<-=q(B, 3:$BOB1Q(B, 5:$BN`8l(B
   ("ej-yahoo" "http://dic.yahoo.co.jp/dsearch?enc=UTF-8&p=%s&dtype=1"
    utf-8 nil "$B%W%m%0%l%C%7%V1QOBCf<-E5(B"
    dic-lookup-w3m-suitable-engine-pattern)
   ("ej-yahoo2" "http://dic.yahoo.co.jp/dsearch?enc=UTF-8&p=%s&dtype=1&dname=1ss"
    utf-8 nil "$B?7%0%m!<%P%k1QOB<-E5(B"
    dic-lookup-w3m-suitable-engine-pattern)
   ("je-yahoo" "http://dic.yahoo.co.jp/dsearch?enc=UTF-8&p=%s&dtype=3"
    utf-8 nil "$B%W%m%0%l%C%7%VOB1QCf<-E5(B")
   ("je-yahoo2" "http://dic.yahoo.co.jp/dsearch?enc=UTF-8&p=%s&dtype=3&dname=2ss"
    utf-8 nil "$B%K%e!<%;%s%A%e%j!<OB1Q<-E5(B")
   ("jj-yahoo" "http://dic.yahoo.co.jp/dsearch?enc=UTF-8&p=%s&dtype=0"
    utf-8 nil "$BBg<-@t(B")
   ("jj-yahoo2" "http://dic.yahoo.co.jp/dsearch?enc=UTF-8&p=%s&dtype=0&dname=0ss"
    utf-8 nil "$BBg<-NS(B")
   ("thesaurus-j-yahoo" "http://dic.yahoo.co.jp/dsearch?enc=UTF-8&p=%s&dtype=5"
    utf-8 nil "$BI,7HN`8l<BMQ<-E5(B")
   ("encyclopedia-yahoo" "http://100.yahoo.co.jp/search?p=%s"
    utf-8 nil "$BF|K\BgI42JA4=q(B")

   ;; excite
   ("ej-excite" "http://www.excite.co.jp/dictionary/english_japanese/?search=%s"
    utf-8 nil "$B?71QOBCf<-E5Bh#6HG!"?7OB1QCf<-E5Bh#4HG!J8&5f<R!K(B")
   ("jj-excite" "http://www.excite.co.jp/dictionary/japanese/?search=%s"
    utf-8 nil "$BBg<-NSBhFsHG!J;0>JF2!K(B")
   ("cj-excite" "http://www.excite.co.jp/dictionary/chinese_japanese/?search=%s"
    utf-8 nil "$B%G%$%j!<%3%s%5%$%9CfF|<-E5!J;0>JF2!K(B")
   ("jc-excite" "http://www.excite.co.jp/dictionary/japanese_chinese/?search=%s"
    utf-8 nil "$B%G%$%j!<%3%s%5%$%9F|Cf<-E5!J;0>JF2!K(B")
   ("ej-computer-excite"
    "http://www.excite.co.jp/dictionary/english_japanese/?dictionary=COMP_EJ&search=%s"
    utf-8 nil "$B1QOB%3%s%T%e!<%?MQ8l<-E5(B")
   ("je-computer-excite"
    "http://www.excite.co.jp/dictionary/english_japanese/?dictionary=COMP_EJ&search=%s"
    utf-8 nil "$B1QOB%3%s%T%e!<%?MQ8l<-E5(B")


   ;; ALC
   ("ej-alc" "http://eow.alc.co.jp/%s/UTF-8/" utf-8 nil "$B1Q<-O:(B")
   ("ej-alc-business-put" "http://home.alc.co.jp/db/owa/bdicn_sch" utf-8
    "w=%s" "$B%S%8%M%91Q8l<-=q(B")
   ("ej-alc-gogen-put" "http://home.alc.co.jp/db/owa/etm_sch" shift_jis
    "instr=%s&stg=1" "$B8l8;<-E5(B")
   ("ej-alc-business"
    "http://home.alc.co.jp/db/owa/bdicn_sch?w=%s"
    utf-8 nil "$B%S%8%M%91Q8l<-=q(B")
   ("ej-alc-gogen" "http://home.alc.co.jp/db/owa/etm_sch?instr=%s&stg=1"
    shift_jis nil "$B8l8;<-E5(B")

   ;; webster $B1Q1Q(B
   ("ee-webster" "http://www.merriam-webster.com/dictionary/%s"
    utf-8 nil "Merriam-Webster Collegiate Dictionary")
   ("thesaurus-webster" "http://www.merriam-webster.com/thesaurus/%s"
    utf-8 nil "Merriam-Webster Collegiate Thesaurus")

   ;; cambridge $B1Q1Q(B
   ("ee-cambridge" "http://dictionary.cambridge.org/results.asp?searchword=%s"
    nil nil "Cambridge Advanced Learner's Dictionary")

   ;; longman $B1Q1Q(B
   ("ee-longman" "http://www.ldoceonline.com/search/?q=%s" utf-8 nil
    "Longman Dictionary of Contemporary English & Longman Advanced American Dictionary")

   ;; oxford $B1Q1Q(B
   ("ee-oxford"
    "http://www.oup.com/oald-bin/web_getald7index1a.pl?search_word=%s"
    utf-8 nil "Oxford Advanced Learner's Dictionary")

   ;; onelook $B1Q1Q(B
   ("ee-onelook" "http://www.onelook.com/?w=grammar&ls=a"
    nil nil "$BLs(B1000$B$N<-=q$r0l3g8!:w(B")

   ;; yahoo.com
   ("ee-yahoo.com"
    "http://education.yahoo.com/reference/dictionary/?s=%s" nil nil
    "The American Heritage$(D"n(B Dictionary of the English Language, Fourth Edition.")
   ("enes-yahoo.com"
    "http://education.yahoo.com/reference/dict_en_es/?s=%s" nil nil
    "The American Heritage$(D"n(B Spanish Dictionary: Spanish/English, Ingl$(D+1(Bs/Espa$(D+P(Bol")
   ("esen-yahoo.com"
    "http://education.yahoo.com/reference/dict_en_es/?s=%s" nil nil
    "The American Heritage$(D"n(B Spanish Dictionary: Spanish/English, Ingl$(D+1(Bs/Espa$(D+P(Bol")

   ;; BNC corpus
   ;; http://www.natcorp.ox.ac.uk/tools/chapter4.xml.ID=FIMNU#CQL
   ("corpus-bnc" "http://bnc.bl.uk/saraWeb.php?qy=%s&mysubmit=Go"
    nil nil "The British National Corpus (BNC)")

   ;; collins corpus
   ;; A query is made up of one or more terms concatenated with a + symbol.
   ;; dog+4bark "dog" followed by "bark" with up to 4 words intervening
   ;; blew@+away the set of words blow blows blowing blew followed by
   ;; the word away
   ;; cut* "cut", "cuts" and "cutting". probably a bad idea.
   ;; cut|cuts|cutting match an explicit set of words.
   ;; wordform/part-of-speech
   ;; (fool|fools|fooling|fooled)/VERB grouping
   ;; rather+JJ word "rather" is immediately followed by an adjective.
   ("corpus-collins"
    "http://www.collins.co.uk/Corpus/CorpusPopUp.aspx?query=%s&corpus=ukephem+ukmags+bbc+ukbooks+times+today+usbooks+npr+usephem+ukspok&width=100"
    nil nil "Collins Cobuild Corpus")

   ;; EReK corpus $B1Q8l$N%&%'%V%Z!<%8$r%3!<%Q%9$H$_$J$7$F8!:w$9$k(B
   ("corpus-erek" "http://erek.ta2o.net/news/%s.html" utf-8 nil
    "$B1Q8l$G=q$+$l$?%&%'%V%Z!<%8$N%F%-%9%H$r5pBg$JNcJ8=8!J%3!<%Q%9!K$H$_$J$7$F8!:w$9$k(B")

   ;; Dictionary.com
   ("thesaurus-rogets" "http://thesaurus.reference.com/browse/%s?jss=0"
    nil nil "Roget's 21st Century Thesaurus, Third Edition")
   ("ee-dictionrary.com" "http://dictionary.reference.com/browse/%s?jss=0"
    nil nil "English-English")

   ;; Visual Thesaurus thesaurus
   ("thesaurus-visualthesaurus"
    "http://www.visualthesaurus.com/browse/en/%s" nil nil
    "The Visual Thesaurus is an online thesaurus and dictionary of over 145,000 words")

   ;; kotonoha $BF|K\8l%3!<%Q%9(B
   ;; (setq w3m-use-cookies t)$B$,I,MW!#$5$i$K8!:wA0$K0lEY(B
   ;; http://www.kotonoha.gr.jp/cgi-bin/search_form.cgi?viaTopPage=1 $B$r3+$/(B
   ("corpus-j-kotonoha"
    "http://www.kotonoha.gr.jp/demo/search_result?query_string=%s&genre=$BGr=q(B&genre=Yahoo!$BCN7CB^(B&genre=$B=q@R(B&genre=$B9q2q2q5DO?(B&entire_period=1"
    utf-8 nil "KOTONOHA $B8=Be=q$-8@MU6Q9U%3!<%Q%9(B")

   ;; $B@D6uJ88K(B $BF|K\8lMQNc8!:w(B
   ("corpus-j-aozora" "http://www.tokuteicorpus.jp/team/jpling/kwic/search.cgi"
    shift_jis "cgi=1&sample=0&mode=1&kw=%s" nil "$B@D6uJ88K(B $BF|K\8lMQNc8!:w(B")

   ;; $B3J%U%l!<%`8!:w(B http://nlp.kuee.kyoto-u.ac.jp/nl-resource/caseframe.html
   ("corpus-j-caseframe" "http://reed.kuee.kyoto-u.ac.jp/cf-search/"
    euc-jp "text=%s"
    "$B3J%U%l!<%`8!:w(B; $BMQ8@$H$=$l$K4X78$9$kL>;l$rMQ8@$N3FMQK!$4$H$K@0M}$7$?$b$N(B")
   ("corpus-j-caseframe-get"
    "http://reed.kuee.kyoto-u.ac.jp/cf-search/?text=%s" euc-jp nil
    "$B3J%U%l!<%`8!:w(B; $BMQ8@$H$=$l$K4X78$9$kL>;l$rMQ8@$N3FMQK!$4$H$K@0M}$7$?$b$N(B")

   ;; Weblio $BN`8l<-E5(B
   ("thesaurus-j-weblio" "http://thesaurus.weblio.jp/content/%s" utf-8 nil
    "Weblio $BLs(B650000$B8l$NN`8l$dF15A8l!&4XO"8l$H%7%=!<%i%9$r<}O?(B")
   ("ej-weblio" "http://ejje.weblio.jp/content/%s" utf-8 nil
    "$B8&5f<R?71QOBCf<-E5(B")
   ("je-weblio" "http://ejje.weblio.jp/content/%s" utf-8 nil
    "$B8&5f<R?7OB1QCf<-E5(B")
   ("jj-all-weblio" "http://www.weblio.jp/content/%s" utf-8 nil
    "$B;0>JF2%G%$%j!<%3%s%5%$%99q8l<-E5B>(B")

   ;; LSD Life Science Dictionary project
   ("ej-lsd" "http://lsd-project.jp/weblsd/begin/%s" utf-8 nil
    "Life Science Dictionary")
   ("corpus-lsd" "http://lsd-project.jp/weblsd/conc2/%s" utf-8 nil
    "Life Science Dictionary project corpus")
   ("thesaurus-lsd"
    "http://lsd-project.jp/cgi-bin/lsdproj/draw_tree.pl?opt=c&query=%s"
    utf-8 nil "Life Science Dictionary project $B%7%=!<%i%9(B")
   ("tr-ej-lsd" "http://lsd.pharm.kyoto-u.ac.jp/cgi-bin/lsdproj/etoj-cgi04.pl"
    shift_jis "query=%s&lang=japanese&DIC=LSD"
    "Life Science Dictionary project $BK]Lu(B")

   ;; RNN $B;~;v1Q8l<-E5(B
   ("ej-jijieigo" "http://rnnnews.jp/search/result/?q=%s" euc-jp nil
    "RAPID NEWS NETWORK $B;~;v1Q8l<-E5(B")
   ("je-jijieigo" "http://rnnnews.jp/search/result/?q=%s" euc-jp nil
    "RAPID NEWS NETWORK $B;~;v1Q8l<-E5(B")

   ;; FOKS Forgiving Online Kanji Search
   ;; $BFI$_J}$N$o$+$i$J$$=O8l$NFI$_$r!JIT@53N$G$b!K$$$l$F!"@5$7$$FI$_$r(B
   ;; $BD4$Y$i$l$^$9!#(B
   ("kanji-foks" "http://foks.info/search/?query=%s&action=Search" utf-8 nil
    "FOKS Forgiving Online Kanji Search $B4A;z(B")

   ;; babylon
   ("ej-babylon" "http://www.babylon.com/definition/%s/Japanese" utf-8 nil
    "$B%P%S%m%s(B")
   ("je-babylon" "http://www.babylon.com/definition/%s/Japanese" utf-8 nil
    "$B%P%S%m%s(B")
   ("jj-babylon" "http://www.babylon.com/definition/%s/Japanese" utf-8 nil
    "$B%P%S%m%s(B(Wikipedia)")
   ("ee-babylon" "http://www.babylon.com/definition/%s/English" utf-8 nil
    "$B%P%S%m%s(B")

   ;; infoseek
   ("ej-infoseek"
    "http://dictionary.infoseek.ne.jp/search/result?q=%s&t=0&r=ejje"
    utf-8 nil "$B%W%m%0%l%C%7%V1QOBCf<-E5(B($BBh#4HG(B)")
   ("je-infoseek"
    "http://dictionary.infoseek.ne.jp/search/result?q=%s&t=0&r=ejje"
    utf-8 nil "$B%W%m%0%l%C%7%VOB1QCf<-E5(B($BBh#3HG(B)")
   ("jj-infoseek"
    "http://dictionary.infoseek.ne.jp/search/result?q=%s&t=0&r=lang"
    utf-8 nil "$B%G%8%?%kBg<-@t(B")
   ("jj-etc-infoseek"
    "http://dictionary.infoseek.ne.jp/search/result?q=%s&t=0&r=etc"
    utf-8 nil "$B$=$NB>$N;vE5(B")

   ;; kotobank
   ("jj-kotobank" "http://kotobank.jp/search/result?q=%s"
    utf-8 nil "$BJ#?t<-=q8!:w(B $B%G%8%?%kBg<-@t(B, $B%^%$%Z%G%#%"(B, $BCN7CB"(B, etc.")

   ;; $B4A;z$N=q$-=g(B
   ;; $B=q$-=g$G(BGO
   ("kanji-kakijun" "http://www.winttk.com/kakijun/dbf/profile.cgi"
    shift_jis "key=%s&hor=1&max=1" "$B4A;z$N=q$-=g(B")

   ;; goo
   ("ej-goo" "http://ext.dictionary.goo.ne.jp/srch/ej/%s/m0u/"
    utf-8 nil "$B;0>JF2(B EXCEED$B1QOB<-E5!"1Q<-O:(B")
   ("je-goo" "http://ext.dictionary.goo.ne.jp/srch/je/%s/m0u/"
    utf-8 nil "$B;0>JF2(B EXCEED$BOB1Q<-E5!"1Q<-O:(B")
   ("jj-goo" "http://ext.dictionary.goo.ne.jp/srch/jn/%s/m0u/"
    utf-8 nil "$B;0>JF2(B $BBg<-NSBhFsHG!"%G%$%j!<?78l<-E5(B+$B&A(B")
   ("jj-yojijukugo-goo" "http://ext.dictionary.goo.ne.jp/srch/idiom/%s/m0u/"
    utf-8 nil "$B;0>JF2(B $B?7L@2r;M;z=O8l<-E5(B")
   ("it-goo" "http://ext.dictionary.goo.ne.jp/srch/it/%s/m0u/"
    utf-8 nil "IT$BMQ8l(B")
   ("all-goo" "http://ext.dictionary.goo.ne.jp/srch/all/%s/m0u/"
    utf-8 nil "$B$9$Y$F$N<-=q(B")

   ;; ocn goo
   ("ej-ocn"
    "http://ocndictionary.goo.ne.jp/search.php?MT=%s&kind=ej&mode=0&kwassist=0"
    euc-jp nil "$B;0>JF2(B EXCEED$B1QOB<-E5(B")
   ("je-ocn"
    "http://ocndictionary.goo.ne.jp/search.php?MT=%s&kind=je&mode=0&kwassist=0"
    euc-jp nil "$B;0>JF2(B EXCEED$BOB1Q<-E5(B")
   ("jj-ocn"
    "http://ocndictionary.goo.ne.jp/search.php?MT=%s&kind=jn&mode=0&kwassist=0"
    euc-jp nil "$B;0>JF2(B $BBg<-NSBhFsHG!"%G%$%j!<?78l<-E5(B+$B&A(B")
   ("all-ocn"
    "http://ocndictionary.goo.ne.jp/search.php?MT=%s&kind=all&mode=0&kwassist=0"
    euc-jp nil "$B$9$Y$F$N<-=q(B")

   ;; gigadict
   ("JG-gigadict"
    "http://cgi.geocities.jp/abelinternational/cgi/dicjg.cgi?mode=search&word=%s&page_max=50"
    utf-8 nil "$BF|FH<-E5!J%I%$%D8l!K(B")
   ("GJ-gigadict"
    "http://cgi.geocities.jp/abelinternational/cgi/dicgj.cgi?mode=search&word=%s&page_max=50"
    utf-8 nil "$BFHOB<-E5!J%I%$%D8l!K(B")
   ("JF-gigadict"
    "http://cgi.geocities.jp/abelinternational/cgi/dicjf.cgi?mode=search&word=%s&page_max=50"
    utf-8 nil "$BF|J)<-E5!J%U%i%s%98l!K(B")
   ("FJ-gigadict"
    "http://cgi.geocities.jp/abelinternational/cgi/dicfj.cgi?mode=search&word=%s&page_max=50"
    utf-8 nil "$BJ)OB<-E5!J%U%i%s%98l!K(B")
   ("PJ-gigadict"
    "http://cgi.geocities.jp/abelinternational/cgi/dicpj.cgi?mode=search&word=%s&page_max=50"
    utf-8 nil "$BIrOB<-E5!J%]%k%H%,%k8l!K(B")
   ("JI-gigadict"
    "http://cgi.geocities.jp/abelinternational/cgi/dicji.cgi?mode=search&word=%s&page_max=50"
    utf-8 nil "$BF|0K<-E5!J%$%?%j%"8l!K(B")
   ("IJ-gigadict"
    "http://cgi.geocities.jp/abelinternational/cgi/dicij.cgi?mode=search&word=%s&page_max=50"
    utf-8 nil "$B0KOB<-E5!J%$%?%j%"8l!K(B")
   ("JS-gigadict"
    "http://cgi.geocities.jp/abelinternational/cgi/dicjs.cgi?mode=search&word=%s&page_max=50"
    utf-8 nil "$BOB@><-E5!J%9%Z%$%s8l!K(B")
   ("SJ-gigadict"
    "http://cgi.geocities.jp/abelinternational/cgi/dicsj.cgi?mode=search&word=%s&page_max=50"
    utf-8 nil "$B@>OB<-E5!J%9%Z%$%s8l!K(B")
   ("JK-gigadict"
    "http://cgi.geocities.jp/abelinternational/cgi/dicjko.cgi?mode=search&word=%s&page_max=50"
    utf-8 nil "$BF|4Z<-E5!J4Z9q8l!K(B")
   ("KJ-gigadict"
    "http://cgi.geocities.jp/abelinternational/cgi/dickoj.cgi?mode=search&word=%s&page_max=50"
    utf-8 nil "$B4ZF|<-E5!J4Z9q8l!K(B")
   ("JT-gigadict"
    "http://cgi.geocities.jp/abelinternational/cgi/dicjt.cgi?mode=search&word=%s&page_max=50"
    utf-8 nil "$BOBEZ<-E5!J%H%k%38l!K(B")
   ("TJ-gigadict"
    "http://cgi.geocities.jp/abelinternational/cgi/dictj.cgi?mode=search&word=%s&page_max=50"
    utf-8 nil "$BEZOB<-E5!J%H%k%38l!K(B")
   ("JR-gigadict"
    "http://cgi.geocities.jp/abelinternational/cgi/dicjr.cgi?mode=search&word=%s&page_max=50"
    utf-8 nil "$BOBO*<-E5!J%m%7%"8l!K(B")
   ("RJ-gigadict"
    "http://cgi.geocities.jp/abelinternational/cgi/dicrj.cgi?mode=search&word=%s&page_max=50"
    utf-8 nil "$BO*OB<-E5!J%m%7%"8l!K(B")
   ("JC-gigadict"
    "http://cgi.geocities.jp/abelinternational/cgi/dicjc.cgi?mode=search&word=%s&page_max=50"
    utf-8 nil "$BF|Cf<-E5!JCf9q8l4JBN!K(B")
   ("CJ-gigadict"
    "http://cgi.geocities.jp/abelinternational/cgi/diccj.cgi?mode=search&word=%s&page_max=50"
    utf-8 nil "$BCfF|<-E5!JCf9q8l4JBN!K(B")
   ("JN-gigadict"
    "http://cgi.geocities.jp/abelinternational/cgi/dicjn.cgi?mode=search&word=%s&page_max=50"
    utf-8 nil "$BOBMv<-E5!J%*%i%s%@8l!K(B")
   ("NJ-gigadict"
    "http://cgi.geocities.jp/abelinternational/cgi/dicnj.cgi?mode=search&word=%s&page_max=50"
    utf-8 nil "$BMvOB<-E5!J%*%i%s%@8l!K(B")
   ("JH-gigadict"
    "http://cgi.geocities.jp/abelinternational/cgi/dicjh.cgi?mode=search&word=%s&page_max=50"
    utf-8 nil "$BF|K\8l(B-$B%X%V%i%$8l<-E5(B")
   ("HJ-gigadict"
    "http://cgi.geocities.jp/abelinternational/cgi/dichj.cgi?mode=search&word=%s&page_max=50"
    utf-8 nil "$B%X%V%i%$8l(B-$BF|K\8l<-E5(B")
   ("JAr-gigadict"
    "http://cgi.geocities.jp/abelinternational/cgi/dicjar.cgi?mode=search&word=%s&page_max=50"
    utf-8 nil "$BF|K\8l(B-$B%"%i%S%"8l<-E5(B")
   ("ArJ-gigadict"
    "http://cgi.geocities.jp/abelinternational/cgi/dicarj.cgi?mode=search&word=%s&page_max=50"
    utf-8 nil "$B%"%i%S%"8l(B-$BF|K\8l<-E5(B")
   ("JE-gigadict"
    "http://cgi.geocities.jp/abelinternational/cgi/dicje2.cgi?mode=search&word=%s&page_max=50"
    utf-8 nil "$BOB1Q<-E5!J1Q8l!K(B")
   ("EJ-gigadict"
    "http://cgi.geocities.jp/abelinternational/cgi/dicej.cgi?mode=search&word=%s&page_max=50"
    utf-8 nil "$BOB1Q<-E5!J1Q8l!K(B")
   ("JFa-gigadict"
    "http://cgi.geocities.jp/abelinternational/cgi/dicjfa.cgi?mode=search&word=%s&page_max=50"
    utf-8 nil "$BF|K\8l(B-$B%Z%k%7%c8l<-E5(B")
   ("FaJ-gigadict"
    "http://cgi.geocities.jp/abelinternational/cgi/dicfaj.cgi?mode=search&word=%s&page_max=50"
    utf-8 nil "$B%Z%k%7%c8l(B-$BF|K\8l<-E5(B")
   ("JPol-gigadict"
    "http://cgi.geocities.jp/abelinternational/cgi/dicjpol.cgi?mode=search&word=%s&page_max=50"
    utf-8 nil "$BOBGH<-E5!J%](B-$B%i%s%I8l!K(B")
   ("PolJ-gigadict"
    "http://cgi.geocities.jp/abelinternational/cgi/dicpolj.cgi?mode=search&word=%s&page_max=50"
    utf-8 nil "$BGHOB<-E5!J%](B-$B%i%s%I8l!K(B")
   ("JU-gigadict"
    "http://cgi.geocities.jp/abelinternational/cgi/dicju.cgi?mode=search&word=%s&page_max=50"
    utf-8 nil "$BF|K\8l(B-$B%&%/%i%$%J8l<-E5(B")
   ("UJ-gigadict"
    "http://cgi.geocities.jp/abelinternational/cgi/dicuj.cgi?mode=search&word=%s&page_max=50"
    utf-8 nil "$B%&%/%i%$%J8l(B-$BF|K\8l<-E5(B")
   ("JIdn-gigadict"
    "http://cgi.geocities.jp/abelinternational/cgi/dicJIdn.cgi?mode=search&word=%s&page_max=50"
    utf-8 nil "$BF|K\8l(B-$B%$%s%I%M%7%"8l<-E5(B")
   ("IndJ-gigadict"
    "http://cgi.geocities.jp/abelinternational/cgi/dicIdnJ.cgi?mode=search&word=%s&page_max=50"
    utf-8 nil "$B%$%s%I%M%7%"8l(B-$BF|K\8l<-E5(B")
   ("Kanji-gigadict"
    "http://cgi.geocities.jp/abelinternational/cgi/kanjidic.cgi?mode=search&word=%s&page_max=50"
    utf-8 nil "$B@$3&4A;z;zE5!JF|K\!&Cf9q!&4Z9q$NA44A;z4^$`!K(B")
   ("KKanji-gigadict"
    "http://cgi.geocities.jp/abelinternational/cgi/jkdic.cgi?mode=search&word=%s&page_max=50"
    utf-8 nil "$BF|K\8l650i4A;z=O8l;zE5(B")

   ;; $BKL<-O:(B $BCfF|(B
   ("cj-kitajiro" "http://www.ctrans.org/cjdic/search.php?word=%s&opts=fw"
    utf-8 nil "$BKL<-O:(B $BCfF|<-=q(B")
   ("jc-kitajiro" "http://www.ctrans.org/cjdic/search.php?word=%s&opts=jp"
    utf-8 nil "$BKL<-O:(B $BF|Cf<-=q(B")
   ("pinyin-ctrans" "http://www.ctrans.org/pinconv.cgi"
    utf-8 "content=%s&submit=Pinconv&mode=pcv&chk=$BF|K\8l(B" "$BKL<-O:(B $B%T%s%$%s(B")

   ;; BitEx $BCfF|(B
   ("cj-bitex"
    "http://bitex-cn.com/search_result.php?match=contains&keyword=%s&imageField.x=0&imageField.y=0&deal_type=cn2jp"
    utf-8 nil "BitEx $BCfF|<-=q(B")
   ("jc-bitex"
    "http://bitex-cn.com/search_result.php?match=contains&keyword=%s&imageField.x=0&imageField.y=0&deal_type=jp2cn"
    utf-8 nil "BitEx $BF|Cf<-=q(B")

   ;; $BFX_j<-3$(B $BCfF|(B
   ("cj-tonko-jikai"
    "http://www.onlinedic.com/search.php?searchtext=%s&lang=1" utf-8 nil
    "$BFX_j<-3$(B $BCfF|<-=q(B")
   ("jc-tonko-jikai"
    "http://www.onlinedic.com/search.php?searchtext=%s&lang=0" utf-8 nil
    "$BFX_j<-3$(B $BF|Cf<-=q(B")
   ("cj-tonko-jikai-post" "http://www.onlinedic.com/search.php"
    utf-8 "searchtext=%s&lang=1" "$BFX_j<-3$(B $BCfF|<-=q(B")
   ("jc-tonko-jikai-post" "http://www.onlinedic.com/search.php"
    utf-8 "searchtext=%s&lang=0" "$BFX_j<-3$(B $BF|Cf<-=q(B")

   ;; $B3ZLuCf9q8l<-=q(B
   ("jc-jcdic" "http://www.jcdic.com/search.php?searchtext=%s&lang=0"
    utf-8 nil "$B3ZLuCf9q8l<-=q(B $BF|Cf(B")
   ("cj-jcdic" "http://www.jcdic.com/search.php?searchtext=%s&lang=1"
    utf-8 nil "$B3ZLuCf9q8l<-=q(B $BCfF|(B")

   ;; hjenglish $BCfF|(B
   ("cj-hjenglish" "http://dict.hjenglish.com/jp/w/%s&type=cj" utf-8 nil
    "$A;q$BF@>.(BD$B1QF|AP3K3$NL$(DC[$BLL$A4J$BE5(B $BCfF|(B")
   ("jc-hjenglish" "http://dict.hjenglish.com/jp/w/%s&type=jc" utf-8 nil
    "$A;q$BF@>.(BD$B1QF|AP3K3$NL$(DC[$BLL$A4J$BE5(B $BF|Cf(B")

   ;; wiktionary
   ("jj-wiktionary" "http://ja.wiktionary.org/wiki/%s" utf-8 nil
    "$B%&%#%/%7%g%J%j!<F|K\8lHG(B(Wiktionary)")

   ;; $B=qCn(B pinyin
   ("pinyin-frelax" "http://www.frelax.com/cgi-local/pinyin/hz2py.cgi"
    utf-8 "hanzi=%s&mark=3&jthz=3" "$B=qCn(B $B%T%s%$%s(B")

   ;; $B@.l~Bg3X(B $BCf9q8l2;@<650i%G!<%?%Y!<%9%7%9%F%`(B $BMW%f!<%6EPO?(B
   ;; http://chinese.jim.seikei.ac.jp/chinese/LoginInit.do?ap=&zh=
   ("pinyin-seikei"
    "http://chinese.jim.seikei.ac.jp/chinese/SearchList_chiInit.do" utf-8
    "Act=1&txtSearch=%s&searchButton=$B8!:w(B&action_cl=1" "$B@.l~Bg3X(B $B%T%s%$%s(B")

   ;; pinyin chinese1
   ("pinyin-chinese1"
    "http://www.chinese1.jp/pinyin/gb2312/jp.asp?wenzi=%s" gb2312 nil
    "$BCfJ89->l(B $B%T%s%$%s(B")

   ;; pinyin cazoo
   ("pinyin-cazoo" "http://www.cazoo.jp/cgi-bin/pinyin/index.html?hanzi=%s"
    utf-8 nil "Cazoo $B%T%s%$%s(B")

   ;; dokochina pinyin
   ("pinyin-dokochina" "http://dokochina.com/simplified.php"
    utf-8 "text1=%s&kbn1=1&chk1=0" "$B$I$s$HMh$$!"Cf9q8l(B $B%T%s%$%s(B")

   ;; $B;0=$<R(B $BFHOB<-E5(B
   ("gj-sanshusha" "http://www5.mediagalaxy.co.jp/CGI/sanshushadj/search.cgi"
    shift_jis "key_word=%s&cmd=list" "$B;0=$<R(B $BFHOB<-E5(B")
   ("gj-sanshusha-get"
    "http://www5.mediagalaxy.co.jp/CGI/sanshushadj/search.cgikey_word=%s&cmd=list"
    shift_jis nil "$B;0=$<R(B $BFHOB<-E5(B")

   ;; spellcheck.net spell checker
   ("spell-spellcheck" "http://www.spellcheck.net/cgi-bin/spell.exe" nil
    "action=CHECKPG&string=%s" "$B1Q8l%9%Z%k%A%'%C%+!<(B")
   ("spell-spellcheck-get"
    "http://www.spellcheck.net/cgi-bin/spell.exe?action=CHECKPG&string=%s"
    nil nil "$B1Q8l%9%Z%k%A%'%C%+!<(B")

   ;; $BDL?.MQ8l$N4pACCN<1(B
   ("tsuushinyougo-wdic.org" "http://www.wdic.org/search?word=%s"
    utf-8 nil "$BDL?.MQ8l$N4pACCN<1(B")

   ;; $B%A%e%&B@$N(Bweb$B<-=q(B
   ("jj-chuuta" "http://marmot.chuta.jp/edit1/Dic.aspx?Search=%s&lang=ja"
    utf-8 nil "ED$BEE;R2=<-=q(B")
   ("je-chuuta" "http://marmot.chuta.jp/edit1/Dic.aspx?Search=%s&lang=en"
    utf-8 nil "EDR$BF|1QBPLu<-=q(B")
   ("jc-chuuta" "http://marmot.chuta.jp/edit1/Dic.aspx?Search=%s&lang=zh"
    utf-8 nil "EDR")
   ("jaaa-chuuta" "http://marmot.chuta.jp/edit1/Dic.aspx?Search=%s&lang=aa"
    utf-8 nil "Reading Tutor Afar")
   ("jaar-chuuta" "http://marmot.chuta.jp/edit1/Dic.aspx?Search=%s&lang=ar"
    utf-8 nil "Reading Tutor Arabic")
   ("jabg-chuuta" "http://marmot.chuta.jp/edit1/Dic.aspx?Search=%s&lang=bg"
    utf-8 nil "Reading Tutor Bulgarian")
   ("jacs-chuuta" "http://marmot.chuta.jp/edit1/Dic.aspx?Search=%s&lang=cs"
    utf-8 nil "Reading Tutor Czech")
   ("jafi-chuuta" "http://marmot.chuta.jp/edit1/Dic.aspx?Search=%s&lang=fi"
    utf-8 nil "Reading Tutor Finnish")
   ("jafr-chuuta" "http://marmot.chuta.jp/edit1/Dic.aspx?Search=%s&lang=fr"
    utf-8 nil "Reading Tutor French")
   ("jade-chuuta" "http://marmot.chuta.jp/edit1/Dic.aspx?Search=%s&lang=de"
    utf-8 nil "Reading Tutor German")
   ("jahu-chuuta" "http://marmot.chuta.jp/edit1/Dic.aspx?Search=%s&lang=hu"
    utf-8 nil "Reading Tutor Hungarian")
   ("jait-chuuta" "http://marmot.chuta.jp/edit1/Dic.aspx?Search=%s&lang=it"
    utf-8 nil "Reading Tutor Italian")
   ("jakir-chuuta" "http://marmot.chuta.jp/edit1/Dic.aspx?Search=%s&lang=kir"
    utf-8 nil "Reading Tutor Kirghiz")
   ("jako-chuuta" "http://marmot.chuta.jp/edit1/Dic.aspx?Search=%s&lang=ko"
    utf-8 nil "Reading Tutor Korean")
   ("jams-chuuta" "http://marmot.chuta.jp/edit1/Dic.aspx?Search=%s&lang=ms"
    utf-8 nil "Reading Tutor Malay")
   ("jamao-chuuta" "http://marmot.chuta.jp/edit1/Dic.aspx?Search=%s&lang=mao"
    utf-8 nil "Reading Tutor Maori")
   ("jamr-chuuta" "http://marmot.chuta.jp/edit1/Dic.aspx?Search=%s&lang=mr"
    utf-8 nil "Reading Tutor Marathi")
   ("janah-chuuta" "http://marmot.chuta.jp/edit1/Dic.aspx?Search=%s&lang=nah"
    utf-8 nil "Reading Tutor Nahuatl")
   ("japt-chuuta" "http://marmot.chuta.jp/edit1/Dic.aspx?Search=%s&lang=pt"
    utf-8 nil "Reading Tutor Portuguese")
   ("jaro-chuuta" "http://marmot.chuta.jp/edit1/Dic.aspx?Search=%s&lang=ro"
    utf-8 nil "Reading Tutor Romanian")
   ("jaru-chuuta" "http://marmot.chuta.jp/edit1/Dic.aspx?Search=%s&lang=ru"
    utf-8 nil "Reading Tutor Russian")
   ("jask-chuuta" "http://marmot.chuta.jp/edit1/Dic.aspx?Search=%s&lang=sk"
    utf-8 nil "Reading Tutor Slovak")
   ("jasl-chuuta" "http://marmot.chuta.jp/edit1/Dic.aspx?Search=%s&lang=sl"
    utf-8 nil "Reading Tutor Slovenian")
   ("jaes-chuuta" "http://marmot.chuta.jp/edit1/Dic.aspx?Search=%s&lang=es"
    utf-8 nil "Reading Tutor Spanish")
   ("jatl-chuuta" "http://marmot.chuta.jp/edit1/Dic.aspx?Search=%s&lang=tl"
    utf-8 nil "Reading Tutor Tagalog")
   ("jath-chuuta" "http://marmot.chuta.jp/edit1/Dic.aspx?Search=%s&lang=th"
    utf-8 nil "Reading Tutor Thai")
   ("jatr-chuuta" "http://marmot.chuta.jp/edit1/Dic.aspx?Search=%s&lang=tr"
    utf-8 nil "Reading Tutor Turkish")
   ("javi-chuuta" "http://marmot.chuta.jp/edit1/Dic.aspx?Search=%s&lang=vi"
    utf-8 nil "Reading Tutor Vietnamese")
   ("jj-chuuta2" "http://marmot.chuta.jp/jtool/jtool.cgi"
    utf-8 "SENTENCE=%s&DIC=Dictionary&lang=en&lang=ja&lang=zh"
    "ED$BEE;R2=<-=q(B")

   ;; WordReference.com
   ("enes-wordreference" "http://www.wordreference.com/enes/%s"
    utf-8 nil "English-Spanish")
   ("enfr-wordreference" "http://www.wordreference.com/enfr/%s"
    utf-8 nil "English-French")
   ("enit-wordreference" "http://www.wordreference.com/enit/%s"
    utf-8 nil "English-Italian")
   ("ende-wordreference" "http://www.wordreference.com/ende/%s"
    utf-8 nil "English-German")
   ("enru-wordreference" "http://www.wordreference.com/enru/%s"
    utf-8 nil "English-Russian")
   ("enpt-wordreference" "http://www.wordreference.com/enpt/%s"
    utf-8 nil "English-Portuguese")
   ("enpl-wordreference" "http://www.wordreference.com/enpl/%s"
    utf-8 nil "English-Polish")
   ("enro-wordreference" "http://www.wordreference.com/enro/%s"
    utf-8 nil "English-Romanian")
   ("encz-wordreference" "http://www.wordreference.com/encz/%s"
    utf-8 nil "English-Czech")
   ("engr-wordreference" "http://www.wordreference.com/engr/%s"
    utf-8 nil "English-Greek")
   ("entr-wordreference" "http://www.wordreference.com/entr/%s"
    utf-8 nil "English-Turkish")
   ("enzh-wordreference" "http://www.wordreference.com/enzh/%s"
    utf-8 nil "English-Chinese")
   ("zhen-wordreference" "http://www.wordreference.com/zhen/%s"
    utf-8 nil "Chinese-English")
   ("enja-wordreference" "http://www.wordreference.com/enja/%s"
    utf-8 nil "English-Japanese")
   ("jaen-wordreference" "http://www.wordreference.com/jaen/%s"
    utf-8 nil "Japanese-English")
   ("enko-wordreference" "http://www.wordreference.com/enko/%s"
    utf-8 nil "English-Korean")
   ("koen-wordreference" "http://www.wordreference.com/koen/%s"
    utf-8 nil "Korean-English")
   ("enar-wordreference" "http://www.wordreference.com/enar/%s"
    utf-8 nil "English-Arabic")
   ("enen-wordreference" "http://www.wordreference.com/definition/%s"
    utf-8 nil "English definition")
   ("esen-wordreference" "http://www.wordreference.com/esen/%s"
    utf-8 nil "Spanish-English")
   ("fren-wordreference" "http://www.wordreference.com/fren/%s"
    utf-8 nil "French-English")
   ("iten-wordreference" "http://www.wordreference.com/iten/%s"
    utf-8 nil "Italian-English")
   ("deen-wordreference" "http://www.wordreference.com/deen/%s"
    utf-8 nil "German-English")
   ("ruen-wordreference" "http://www.wordreference.com/ruen/%s"
    utf-8 nil "Russian-English")
   ("esfr-wordreference" "http://www.wordreference.com/esfr/%s"
    utf-8 nil "Spanish-French")
   ("espt-wordreference" "http://www.wordreference.com/espt/%s"
    utf-8 nil "Spanish-Portuguese")
   ("eses-wordreference" "http://www.wordreference.com/definicion/%s"
    utf-8 nil "Spanish definition")
   ("essin-wordreference" "http://www.wordreference.com/sinonimos/%s"
    utf-8 nil "Spanish synonyms")
   ("fres-wordreference" "http://www.wordreference.com/fres/%s"
    utf-8 nil "French-Spanish")
   ("ptes-wordreference" "http://www.wordreference.com/ptes/%s"
    utf-8 nil "Portuguese-Spanish")

   ;;
   ;; translators
   ;;

   ;; yahoo translator
   ("tr-ej-yahoo" "http://honyaku.yahoo.co.jp/transtext" utf-8
    "both=TH&text=%s&clearFlg=1&eid=CR-EJ" "Cross Language"
    dic-lookup-w3m-suitable-engine-pattern)
   ("tr-je-yahoo" "http://honyaku.yahoo.co.jp/transtext" utf-8
    "both=TH&text=%s&clearFlg=1&eid=CR-JE" "Cross Language")
   ("tr-cj-yahoo" "http://honyaku.yahoo.co.jp/transtext" utf-8
    "both=TH&text=%s&clearFlg=1&eid=CR-CJ" "Cross Language")
   ("tr-jc-yahoo" "http://honyaku.yahoo.co.jp/transtext" utf-8
    "both=TH&text=%s&clearFlg=1&eid=CR-JC-CN" "Cross Language")
   ("tr-kj-yahoo" "http://honyaku.yahoo.co.jp/transtext" utf-8
    "both=TH&text=%s&clearFlg=1&eid=CR-KJ" "Changshin Soft (CSLI)")
   ("tr-jk-yahoo" "http://honyaku.yahoo.co.jp/transtext" utf-8
    "both=TH&text=%s&clearFlg=1&eid=CR-JK" "Changshin Soft (CSLI)")

   ;; excite translator
   ,@(dic-lookup-w3m-search-engine-postget
      '(("tr-ej-excite" "http://www.excite.co.jp/world/english/"
	 shift_jis "wb_lp=ENJA&before=%s" "BizLingo (Accela Technology)"
	 dic-lookup-w3m-suitable-engine-pattern)
	("tr-je-excite" "http://www.excite.co.jp/world/english/"
	 shift_jis "wb_lp=JAEN&before=%s" "BizLingo (Accela Technology)")
	("tr-cj-excite" "http://www.excite.co.jp/world/chinese/"
	 utf-8 "wb_lp=CHJA&before=%s" "Kodensha")
	("tr-jc-excite" "http://www.excite.co.jp/world/chinese/"
	 utf-8 "wb_lp=JACH&before=%s" "Kodensha")
	("tr-kj-excite" "http://www.excite.co.jp/world/korean/"
	 utf-8 "wb_lp=KOJA&before=%s" "Amikai")
	("tr-jk-excite" "http://www.excite.co.jp/world/korean/"
	 utf-8 "wb_lp=JAKO&before=%s" "Amikai")
	("tr-fj-excite" "http://www.excite.co.jp/world/french/"
	 utf-8 "wb_lp=FRJA&before=%s")
	("tr-jf-excite" "http://www.excite.co.jp/world/french/"
	 utf-8 "wb_lp=JAFR&before=%s")
	("tr-gj-excite" "http://www.excite.co.jp/world/german/"
	 utf-8 "wb_lp=DEJA&before=%s")
	("tr-jg-excite" "http://www.excite.co.jp/world/german/"
	 utf-8 "wb_lp=JADE&before=%s")
	("tr-ij-excite" "http://www.excite.co.jp/world/italian/"
	 utf-8 "wb_lp=ITJA&before=%s")
	("tr-ji-excite" "http://www.excite.co.jp/world/italian/"
	 utf-8 "wb_lp=JAIT&before=%s")
	("tr-sj-excite" "http://www.excite.co.jp/world/spanish/"
	 utf-8 "wb_lp=ESJA&before=%s")
	("tr-js-excite" "http://www.excite.co.jp/world/spanish/"
	 utf-8 "wb_lp=JAES&before=%s")
	("tr-pj-excite" "http://www.excite.co.jp/world/portuguese/"
	 utf-8 "wb_lp=PTJA&before=%s")
	("tr-jp-excite" "http://www.excite.co.jp/world/portuguese/"
	 utf-8 "wb_lp=JAPT&before=%s")
	))

   ;; yahoo.com translator
   ;; Accept-Charset$B$K(Butf-8$B$,I,MW(B
   ;; (setq w3m-command-arguments
   ;;       '("-header" "Accept-Charset: ISO-2022-JP, EUC-JP, Shift-JIS, UTF-8;q=0.8, *;q=0.1"))
   ,@(dic-lookup-w3m-search-engine-postget
      '(("tr-ej-yahoo.com" "http://babelfish.yahoo.com/translate_txt" utf-8
	 "ei=UTF-8&doit=done&intl=1&tt=urltext&trtext=%s&lp=en_ja&btnTrTxt=Translate"
	 "babelfish" dic-lookup-w3m-suitable-engine-pattern)
	("tr-je-yahoo.com" "http://babelfish.yahoo.com/translate_txt" utf-8
	 "ei=UTF-8&doit=done&intl=1&tt=urltext&trtext=%s&lp=ja_en&btnTrTxt=Translate"
	 "babelfish")
	("tr-ennl-yahoo.com" "http://babelfish.yahoo.com/translate_txt" utf-8
	 "ei=UTF-8&doit=done&intl=1&tt=urltext&trtext=%s&lp=en_nl&btnTrTxt=Translate"
	 "babelfish")
	("tr-nlen-yahoo.com" "http://babelfish.yahoo.com/translate_txt" utf-8
	 "ei=UTF-8&doit=done&intl=1&tt=urltext&trtext=%s&lp=nl_en&btnTrTxt=Translate"
	 "babelfish")
	("tr-enfr-yahoo.com" "http://babelfish.yahoo.com/translate_txt" utf-8
	 "ei=UTF-8&doit=done&intl=1&tt=urltext&trtext=%s&lp=en_fr&btnTrTxt=Translate"
	 "babelfish")
	("tr-fren-yahoo.com" "http://babelfish.yahoo.com/translate_txt" utf-8
	 "ei=UTF-8&doit=done&intl=1&tt=urltext&trtext=%s&lp=fr_en&btnTrTxt=Translate"
	 "babelfish")
	("tr-ende-yahoo.com" "http://babelfish.yahoo.com/translate_txt" utf-8
	 "ei=UTF-8&doit=done&intl=1&tt=urltext&trtext=%s&lp=en_de&btnTrTxt=Translate"
	 "babelfish")
	("tr-deen-yahoo.com" "http://babelfish.yahoo.com/translate_txt" utf-8
	 "ei=UTF-8&doit=done&intl=1&tt=urltext&trtext=%s&lp=de_en&btnTrTxt=Translate"
	 "babelfish")
	("tr-enel-yahoo.com" "http://babelfish.yahoo.com/translate_txt" utf-8
	 "ei=UTF-8&doit=done&intl=1&tt=urltext&trtext=%s&lp=en_el&btnTrTxt=Translate"
	 "babelfish")
	("tr-elen-yahoo.com" "http://babelfish.yahoo.com/translate_txt" utf-8
	 "ei=UTF-8&doit=done&intl=1&tt=urltext&trtext=%s&lp=el_en&btnTrTxt=Translate"
	 "babelfish")
	("tr-enit-yahoo.com" "http://babelfish.yahoo.com/translate_txt" utf-8
	 "ei=UTF-8&doit=done&intl=1&tt=urltext&trtext=%s&lp=en_it&btnTrTxt=Translate"
	 "babelfish")
	("tr-iten-yahoo.com" "http://babelfish.yahoo.com/translate_txt" utf-8
	 "ei=UTF-8&doit=done&intl=1&tt=urltext&trtext=%s&lp=it_en&btnTrTxt=Translate"
	 "babelfish")
	("tr-enko-yahoo.com" "http://babelfish.yahoo.com/translate_txt" utf-8
	 "ei=UTF-8&doit=done&intl=1&tt=urltext&trtext=%s&lp=en_ko&btnTrTxt=Translate"
	 "babelfish")
	("tr-koen-yahoo.com" "http://babelfish.yahoo.com/translate_txt" utf-8
	 "ei=UTF-8&doit=done&intl=1&tt=urltext&trtext=%s&lp=ko_en&btnTrTxt=Translate"
	 "babelfish")
	("tr-enpt-yahoo.com" "http://babelfish.yahoo.com/translate_txt" utf-8
	 "ei=UTF-8&doit=done&intl=1&tt=urltext&trtext=%s&lp=en_pt&btnTrTxt=Translate"
	 "babelfish")
	("tr-pten-yahoo.com" "http://babelfish.yahoo.com/translate_txt" utf-8
	 "ei=UTF-8&doit=done&intl=1&tt=urltext&trtext=%s&lp=pt_en&btnTrTxt=Translate"
	 "babelfish")
	("tr-enru-yahoo.com" "http://babelfish.yahoo.com/translate_txt" utf-8
	 "ei=UTF-8&doit=done&intl=1&tt=urltext&trtext=%s&lp=en_ru&btnTrTxt=Translate"
	 "babelfish")
	("tr-ruen-yahoo.com" "http://babelfish.yahoo.com/translate_txt" utf-8
	 "ei=UTF-8&doit=done&intl=1&tt=urltext&trtext=%s&lp=ru_en&btnTrTxt=Translate"
	 "babelfish")
	("tr-enes-yahoo.com" "http://babelfish.yahoo.com/translate_txt" utf-8
	 "ei=UTF-8&doit=done&intl=1&tt=urltext&trtext=%s&lp=en_es&btnTrTxt=Translate"
	 "babelfish")
	("tr-esen-yahoo.com" "http://babelfish.yahoo.com/translate_txt" utf-8
	 "ei=UTF-8&doit=done&intl=1&tt=urltext&trtext=%s&lp=es_en&btnTrTxt=Translate"
	 "babelfish")
	("tr-nlfr-yahoo.com" "http://babelfish.yahoo.com/translate_txt" utf-8
	 "ei=UTF-8&doit=done&intl=1&tt=urltext&trtext=%s&lp=nl_fr&btnTrTxt=Translate"
	 "babelfish")
	("tr-frnl-yahoo.com" "http://babelfish.yahoo.com/translate_txt" utf-8
	 "ei=UTF-8&doit=done&intl=1&tt=urltext&trtext=%s&lp=fr_nl&btnTrTxt=Translate"
	 "babelfish")
	("tr-frde-yahoo.com" "http://babelfish.yahoo.com/translate_txt" utf-8
	 "ei=UTF-8&doit=done&intl=1&tt=urltext&trtext=%s&lp=fr_de&btnTrTxt=Translate"
	 "babelfish")
	("tr-defr-yahoo.com" "http://babelfish.yahoo.com/translate_txt" utf-8
	 "ei=UTF-8&doit=done&intl=1&tt=urltext&trtext=%s&lp=de_fr&btnTrTxt=Translate"
	 "babelfish")
	("tr-frel-yahoo.com" "http://babelfish.yahoo.com/translate_txt" utf-8
	 "ei=UTF-8&doit=done&intl=1&tt=urltext&trtext=%s&lp=fr_el&btnTrTxt=Translate"
	 "babelfish")
	("tr-elfr-yahoo.com" "http://babelfish.yahoo.com/translate_txt" utf-8
	 "ei=UTF-8&doit=done&intl=1&tt=urltext&trtext=%s&lp=el_fr&btnTrTxt=Translate"
	 "babelfish")
	("tr-frit-yahoo.com" "http://babelfish.yahoo.com/translate_txt" utf-8
	 "ei=UTF-8&doit=done&intl=1&tt=urltext&trtext=%s&lp=fr_it&btnTrTxt=Translate"
	 "babelfish")
	("tr-itfr-yahoo.com" "http://babelfish.yahoo.com/translate_txt" utf-8
	 "ei=UTF-8&doit=done&intl=1&tt=urltext&trtext=%s&lp=it_fr&btnTrTxt=Translate"
	 "babelfish")
	("tr-frpt-yahoo.com" "http://babelfish.yahoo.com/translate_txt" utf-8
	 "ei=UTF-8&doit=done&intl=1&tt=urltext&trtext=%s&lp=fr_pt&btnTrTxt=Translate"
	 "babelfish")
	("tr-ptfr-yahoo.com" "http://babelfish.yahoo.com/translate_txt" utf-8
	 "ei=UTF-8&doit=done&intl=1&tt=urltext&trtext=%s&lp=pt_fr&btnTrTxt=Translate"
	 "babelfish")
	("tr-fres-yahoo.com" "http://babelfish.yahoo.com/translate_txt" utf-8
	 "ei=UTF-8&doit=done&intl=1&tt=urltext&trtext=%s&lp=fr_es&btnTrTxt=Translate"
	 "babelfish")
	("tr-esfr-yahoo.com" "http://babelfish.yahoo.com/translate_txt" utf-8
	 "ei=UTF-8&doit=done&intl=1&tt=urltext&trtext=%s&lp=es_fr&btnTrTxt=Translate"
	 "babelfish")
	("tr-ench-yahoo.com" "http://babelfish.yahoo.com/translate_txt" utf-8
	 "ei=UTF-8&doit=done&intl=1&tt=urltext&trtext=%s&lp=en_zh&btnTrTxt=Translate"
	 "babelfish")
	("tr-chen-yahoo.com" "http://babelfish.yahoo.com/translate_txt" utf-8
	 "ei=UTF-8&doit=done&intl=1&tt=urltext&trtext=%s&lp=zh_en&btnTrTxt=Translate"
	 "babelfish")
	("tr-entw-yahoo.com" "http://babelfish.yahoo.com/translate_txt" utf-8
	 "ei=UTF-8&doit=done&intl=1&tt=urltext&trtext=%s&lp=en_zt&btnTrTxt=Translate"
	 "babelfish")
	("tr-twen-yahoo.com" "http://babelfish.yahoo.com/translate_txt" utf-8
	 "ei=UTF-8&doit=done&intl=1&tt=urltext&trtext=%s&lp=zt_en&btnTrTxt=Translate"
	 "babelfish")
	))

   ;; freetranslation
   ,@(dic-lookup-w3m-search-engine-postget
      '(("tr-ej-freetranslation" "http://tets9.freetranslation.com" utf-8
	 "sequence=core&mode=html&charset=UTF-8&template=results_en-us.htm&language=English/Japanese&srctext=%s"
	 nil dic-lookup-w3m-suitable-engine-pattern)
	("tr-je-freetranslation" "http://tets9.freetranslation.com" utf-8
	 "sequence=core&mode=html&charset=UTF-8&template=results_en-us.htm&language=Japanese/English&srctext=%s")
	("tr-enes-freetranslation" "http://ets.freetranslation.com" utf-8
	 "sequence=core&mode=html&charset=UTF-8&template=results_en-us.htm&language=English/Spanish&srctext=%s")
	("tr-esen-freetranslation" "http://ets.freetranslation.com" utf-8
	 "sequence=core&mode=html&charset=UTF-8&template=results_en-us.htm&language=Spanish/English&srctext=%s")
	("tr-enfr-freetranslation" "http://ets.freetranslation.com" utf-8
	 "sequence=core&mode=html&charset=UTF-8&template=results_en-us.htm&language=English/French&srctext=%s")
	("tr-fren-freetranslation" "http://ets.freetranslation.com" utf-8
	 "sequence=core&mode=html&charset=UTF-8&template=results_en-us.htm&language=French/English&srctext=%s")
	("tr-ende-freetranslation" "http://ets.freetranslation.com" utf-8
	 "sequence=core&mode=html&charset=UTF-8&template=results_en-us.htm&language=English/German&srctext=%s")
	("tr-deen-freetranslation" "http://ets.freetranslation.com" utf-8
	 "sequence=core&mode=html&charset=UTF-8&template=results_en-us.htm&language=German/English&srctext=%s")
	("tr-enit-freetranslation" "http://ets.freetranslation.com" utf-8
	 "sequence=core&mode=html&charset=UTF-8&template=results_en-us.htm&language=English/Italian&srctext=%s")
	("tr-iten-freetranslation" "http://ets.freetranslation.com" utf-8
	 "sequence=core&mode=html&charset=UTF-8&template=results_en-us.htm&language=Italian/English&srctext=%s")
	("tr-ennl-freetranslation" "http://ets.freetranslation.com" utf-8
	 "sequence=core&mode=html&charset=UTF-8&template=results_en-us.htm&language=English/Dutch&srctext=%s")
	("tr-nlen-freetranslation" "http://ets.freetranslation.com" utf-8
	 "sequence=core&mode=html&charset=UTF-8&template=results_en-us.htm&language=Dutch/English&srctext=%s")
	("tr-enpt-freetranslation" "http://ets.freetranslation.com" utf-8
	 "sequence=core&mode=html&charset=UTF-8&template=results_en-us.htm&language=English/Portuguese&srctext=%s")
	("tr-pten-freetranslation" "http://ets.freetranslation.com" utf-8
	 "sequence=core&mode=html&charset=UTF-8&template=results_en-us.htm&language=Portuguese/English&srctext=%s")
	("tr-enru-freetranslation" "http://ets6.freetranslation.com" utf-8
	 "sequence=core&mode=html&charset=UTF-8&template=results_en-us.htm&language=English/Russian&srctext=%s")
	("tr-ruen-freetranslation" "http://ets6.freetranslation.com" utf-8
	 "sequence=core&mode=html&charset=UTF-8&template=results_en-us.htm&language=Russian/English&srctext=%s")
	("tr-ench-freetranslation" "http://ets6.freetranslation.com" utf-8
	 "sequence=core&mode=html&charset=UTF-8&template=results_en-us.htm&language=English/SimplifiedChinese&srctext=%s")
	("tr-entw-freetranslation" "http://ets6.freetranslation.com" utf-8
	 "sequence=core&mode=html&charset=UTF-8&template=results_en-us.htm&language=English/TraditionalChinese&srctext=%s")
	("tr-enno-freetranslation" "http://ets.freetranslation.com" utf-8
	 "sequence=core&mode=html&charset=UTF-8&template=results_en-us.htm&language=English/Norwegian&srctext=%s")
	))

   ;; ocn translator
   ("tr-ej-ocn" "http://cgi01.ocn.ne.jp/cgi-bin/translation/index.cgi"
    utf-8 "langpair=enja&sourceText=%s" "Kodensha")
   ("tr-je-ocn" "http://cgi01.ocn.ne.jp/cgi-bin/translation/index.cgi"
    utf-8 "langpair=jaen&sourceText=%s" "Kodensha")
   ("tr-kj-ocn" "http://cgi01.ocn.ne.jp/cgi-bin/translation/index.cgi"
    utf-8 "langpair=koja&sourceText=%s" "Kodensha")
   ("tr-jk-ocn" "http://cgi01.ocn.ne.jp/cgi-bin/translation/index.cgi"
    utf-8 "langpair=jako&sourceText=%s" "Kodensha")
   ("tr-cj-ocn" "http://cgi01.ocn.ne.jp/cgi-bin/translation/index.cgi"
    utf-8 "langpair=zhja&sourceText=%s" "Kodensha")
   ("tr-jc-ocn" "http://cgi01.ocn.ne.jp/cgi-bin/translation/index.cgi"
    utf-8 "langpair=jazh&sourceText=%s" "Kodensha")
   ;; ocn web page translaor
   ("tr-ej-url-ocn"
    "http://translate.ocn.ne.jp/LUCOCN/c3/hm_ex.cgi?SURL=%s&XTYPE=1&SEARCH=T&SLANG=en&TLANG=ja"
    utf-8 nil "Kodensha")
   ("tr-je-url-ocn"
    "http://translate.ocn.ne.jp/LUCOCN/c3/hm_ex.cgi?SURL=%s&XTYPE=1&SEARCH=T&SLANG=ja&TLANG=en"
    utf-8 nil "Kodensha")
   ("tr-kj-url-ocn"
    "http://translate.ocn.ne.jp/LUCOCN/c3/hm_ex.cgi?SURL=%s&XTYPE=1&SEARCH=T&SLANG=ko&TLANG=ja"
    utf-8 nil "Kodensha")
   ("tr-jk-url-ocn"
    "http://translate.ocn.ne.jp/LUCOCN/c3/hm_ex.cgi?SURL=%s&XTYPE=1&SEARCH=T&SLANG=ja&TLANG=ko"
    utf-8 nil "Kodensha")
   ("tr-cj-url-ocn"
    "http://translate.ocn.ne.jp/LUCOCN/c3/hm_ex.cgi?SURL=%s&XTYPE=1&SEARCH=T&SLANG=zh&TLANG=ja"
    utf-8 nil "Kodensha")
   ("tr-jc-url-ocn"
    "http://translate.ocn.ne.jp/LUCOCN/c3/hm_ex.cgi?SURL=%s&XTYPE=1&SEARCH=T&SLANG=ja&TLANG=zh"
    utf-8 nil "Kodensha")

   ;; livedoor translator
   ("tr-zhja-livedoor" "http://livedoor-translate.naver.jp/text/" utf-8
    "translateParams.slang=zh&translateParams.tlang=ja&translateParams.originalText=%s")
   ("tr-koja-livedoor" "http://livedoor-translate.naver.jp/text/" utf-8
    "translateParams.slang=ko&translateParams.tlang=ja&translateParams.originalText=%s")
   ("tr-ptja-livedoor" "http://livedoor-translate.naver.jp/text/" utf-8
    "translateParams.slang=pt&translateParams.tlang=ja&translateParams.originalText=%s")
   ("tr-esja-livedoor" "http://livedoor-translate.naver.jp/text/" utf-8
    "translateParams.slang=es&translateParams.tlang=ja&translateParams.originalText=%s")
   ("tr-itja-livedoor" "http://livedoor-translate.naver.jp/text/" utf-8
    "translateParams.slang=it&translateParams.tlang=ja&translateParams.originalText=%s")
   ("tr-frja-livedoor" "http://livedoor-translate.naver.jp/text/" utf-8
    "translateParams.slang=fr&translateParams.tlang=ja&translateParams.originalText=%s")
   ("tr-deja-livedoor" "http://livedoor-translate.naver.jp/text/" utf-8
    "translateParams.slang=de&translateParams.tlang=ja&translateParams.originalText=%s")
   ("tr-jazh-livedoor" "http://livedoor-translate.naver.jp/text/" utf-8
    "translateParams.slang=ja&translateParams.tlang=zh&translateParams.originalText=%s")
   ("tr-jako-livedoor" "http://livedoor-translate.naver.jp/text/" utf-8
    "translateParams.slang=ja&translateParams.tlang=ko&translateParams.originalText=%s")
   ("tr-japt-livedoor" "http://livedoor-translate.naver.jp/text/" utf-8
    "translateParams.slang=ja&translateParams.tlang=pt&translateParams.originalText=%s")
   ("tr-jaes-livedoor" "http://livedoor-translate.naver.jp/text/" utf-8
    "translateParams.slang=ja&translateParams.tlang=es&translateParams.originalText=%s")
   ("tr-jait-livedoor" "http://livedoor-translate.naver.jp/text/" utf-8
    "translateParams.slang=ja&translateParams.tlang=it&translateParams.originalText=%s")
   ("tr-jafr-livedoor" "http://livedoor-translate.naver.jp/text/" utf-8
    "translateParams.slang=ja&translateParams.tlang=fr&translateParams.originalText=%s")
   ("tr-jade-livedoor" "http://livedoor-translate.naver.jp/text/" utf-8
    "translateParams.slang=ja&translateParams.tlang=de&translateParams.originalText=%s")
   ("tr-je-livedoor" "http://livedoor-translate.naver.jp/text/" utf-8
    "translateParams.slang=ja&translateParams.tlang=en&translateParams.originalText=%s")
   ("tr-pten-livedoor" "http://livedoor-translate.naver.jp/text/" utf-8
    "translateParams.slang=pt&translateParams.tlang=en&translateParams.originalText=%s")
   ("tr-esen-livedoor" "http://livedoor-translate.naver.jp/text/" utf-8
    "translateParams.slang=es&translateParams.tlang=en&translateParams.originalText=%s")
   ("tr-iten-livedoor" "http://livedoor-translate.naver.jp/text/" utf-8
    "translateParams.slang=it&translateParams.tlang=en&translateParams.originalText=%s")
   ("tr-fren-livedoor" "http://livedoor-translate.naver.jp/text/" utf-8
    "translateParams.slang=fr&translateParams.tlang=en&translateParams.originalText=%s")
   ("tr-deen-livedoor" "http://livedoor-translate.naver.jp/text/" utf-8
    "translateParams.slang=de&translateParams.tlang=en&translateParams.originalText=%s")
   ("tr-enpt-livedoor" "http://livedoor-translate.naver.jp/text/" utf-8
    "translateParams.slang=en&translateParams.tlang=pt&translateParams.originalText=%s")
   ("tr-enes-livedoor" "http://livedoor-translate.naver.jp/text/" utf-8
    "translateParams.slang=en&translateParams.tlang=es&translateParams.originalText=%s")
   ("tr-enit-livedoor" "http://livedoor-translate.naver.jp/text/" utf-8
    "translateParams.slang=en&translateParams.tlang=it&translateParams.originalText=%s")
   ("tr-enfr-livedoor" "http://livedoor-translate.naver.jp/text/" utf-8
    "translateParams.slang=en&translateParams.tlang=fr&translateParams.originalText=%s")
   ("tr-ende-livedoor" "http://livedoor-translate.naver.jp/text/" utf-8
    "translateParams.slang=en&translateParams.tlang=de&translateParams.originalText=%s")
   ("tr-ej-livedoor" "http://livedoor-translate.naver.jp/text/" utf-8
    "translateParams.slang=en&translateParams.tlang=ja&translateParams.originalText=%s")

   ;; livedoor web page translator
   ("tr-ej-url-livedoor"
    "http://livedoor-translate.naver.jp/site/translate/enja/%s" utf-8)
   ("tr-ende-url-livedoor"
    "http://livedoor-translate.naver.jp/site/translate/ende/%s" utf-8)
   ("tr-enfr-url-livedoor"
    "http://livedoor-translate.naver.jp/site/translate/enfr/%s" utf-8)
   ("tr-enit-url-livedoor"
    "http://livedoor-translate.naver.jp/site/translate/enit/%s" utf-8)
   ("tr-enes-url-livedoor"
    "http://livedoor-translate.naver.jp/site/translate/enes/%s" utf-8)
   ("tr-enpt-url-livedoor"
    "http://livedoor-translate.naver.jp/site/translate/enpt/%s" utf-8)
   ("tr-deen-url-livedoor"
    "http://livedoor-translate.naver.jp/site/translate/deen/%s" utf-8)
   ("tr-fren-url-livedoor"
    "http://livedoor-translate.naver.jp/site/translate/fren/%s" utf-8)
   ("tr-iten-url-livedoor"
    "http://livedoor-translate.naver.jp/site/translate/iten/%s" utf-8)
   ("tr-esen-url-livedoor"
    "http://livedoor-translate.naver.jp/site/translate/esen/%s" utf-8)
   ("tr-pten-url-livedoor"
    "http://livedoor-translate.naver.jp/site/translate/pten/%s" utf-8)
   ("tr-je-url-livedoor"
    "http://livedoor-translate.naver.jp/site/translate/jaen/%s" utf-8)
   ("tr-jade-url-livedoor"
    "http://livedoor-translate.naver.jp/site/translate/jade/%s" utf-8)
   ("tr-jafr-url-livedoor"
    "http://livedoor-translate.naver.jp/site/translate/jafr/%s" utf-8)
   ("tr-jait-url-livedoor"
    "http://livedoor-translate.naver.jp/site/translate/jait/%s" utf-8)
   ("tr-jaes-url-livedoor"
    "http://livedoor-translate.naver.jp/site/translate/jaes/%s" utf-8)
   ("tr-japt-url-livedoor"
    "http://livedoor-translate.naver.jp/site/translate/japt/%s" utf-8)
   ("tr-jako-url-livedoor"
    "http://livedoor-translate.naver.jp/site/translate/jako/%s" utf-8)
   ("tr-jazh-url-livedoor"
    "http://livedoor-translate.naver.jp/site/translate/jazh/%s" utf-8)
   ("tr-deja-url-livedoor"
    "http://livedoor-translate.naver.jp/site/translate/deja/%s" utf-8)
   ("tr-frja-url-livedoor"
    "http://livedoor-translate.naver.jp/site/translate/frja/%s" utf-8)
   ("tr-itja-url-livedoor"
    "http://livedoor-translate.naver.jp/site/translate/itja/%s" utf-8)
   ("tr-esja-url-livedoor"
    "http://livedoor-translate.naver.jp/site/translate/esja/%s" utf-8)
   ("tr-ptja-url-livedoor"
    "http://livedoor-translate.naver.jp/site/translate/ptja/%s" utf-8)
   ("tr-koja-url-livedoor"
    "http://livedoor-translate.naver.jp/site/translate/koja/%s" utf-8)
   ("tr-zhja-url-livedoor"
    "http://livedoor-translate.naver.jp/site/translate/zhja/%s" utf-8)

   ;; fresheye translator
   ,@(dic-lookup-w3m-search-engine-postget
      '(("tr-ej-fresheye"
	 "http://mt.fresheye.com/ft_result.cgi"
	 utf-8 "gen_text=%s&e=EJ" "Toshiba (Amikai)")
	("tr-je-fresheye"
	 "http://mt.fresheye.com/ft_result.cgi"
	 utf-8 "gen_text=%s&e=JE" "Toshiba (Amikai)")
	("tr-jc-fresheye"
	 "http://mt.fresheye.com/ft_cjresult.cgi"
	 utf-8 "gen_text=%s&charset=gb2312&cjjc=jc" "Toshiba (Amikai)")
	("tr-cj-fresheye"
	 "http://mt.fresheye.com/ft_cjresult.cgi"
	 utf-8 "gen_text=%s&charset=gb2312&cjjc=cj" "Toshiba (Amikai)")
	("tr-jtw-fresheye"
	 "http://mt.fresheye.com/ft_cjresult.cgi"
	 utf-8 "gen_text=%s&charset=big5&cjjc=jc" "Toshiba (Amikai)")
	("tr-twj-fresheye"
	 "http://mt.fresheye.com/ft_cjresult.cgi"
	 utf-8 "gen_text=%s&charset=big5&cjjc=cj" "Toshiba (Amikai)")
	))

   ;; So-net translator
   ("tr-je-sonet" "http://so-net.web.transer.com/text_trans_sn.php"
    utf-8 "eid=CR-JE&text=%s" "Amikai")
   ("tr-ej-sonet" "http://so-net.web.transer.com/text_trans_sn.php"
    utf-8 "eid=CR-EJ&text=%s" "Amikai")
   ("tr-jct-sonet" "http://so-net.web.transer.com/text_trans_sn.php"
    utf-8 "eid=CR-JCT&text=%s")
   ("tr-jc-sonet" "http://so-net.web.transer.com/text_trans_sn.php"
    utf-8 "eid=CR-JC&text=%s")
   ("tr-cj-sonet" "http://so-net.web.transer.com/text_trans_sn.php"
    utf-8 "eid=CR-CJ&text=%s")
   ("tr-jk-sonet" "http://so-net.web.transer.com/text_trans_sn.php"
    utf-8 "eid=CR-JK&text=%s")
   ("tr-kj-sonet" "http://so-net.web.transer.com/text_trans_sn.php"
    utf-8 "eid=CR-KJ&text=%s")
   ;; So-net web page translator
   ("tr-je-url-sonet"
    "http://so-net.web.transer.com/url_trans_sn.php?url=%s&eid=CR-JE"
    utf-8 nil "Amikai")
   ("tr-ej-url-sonet"
    "http://so-net.web.transer.com/url_trans_sn.php?url=%s&eid=CR-EJ"
    utf-8 nil "Amikai")
   ("tr-jct-url-sonet"
    "http://so-net.web.transer.com/url_trans_sn.php?url=%s&eid=CR-JCT" utf-8)
   ("tr-jc-url-sonet"
    "http://so-net.web.transer.com/url_trans_sn.php?url=%s&eid=CR-JC" utf-8)
   ("tr-cj-url-sonet"
    "http://so-net.web.transer.com/url_trans_sn.php?url=%s&eid=CR-CJ" utf-8)
   ("tr-jk-url-sonet"
    "http://so-net.web.transer.com/url_trans_sn.php?url=%s&eid=CR-JK" utf-8)
   ("tr-kj-url-sonet"
    "http://so-net.web.transer.com/url_trans_sn.php?url=%s&eid=CR-KE" utf-8)

   ;; nifty translator
   ,@(dic-lookup-w3m-search-engine-postget
      '(("tr-ej-nifty"
	 "http://honyaku-result.nifty.com/LUCNIFTY/text/text.php"
	 utf-8 "SLANG=en&TLANG=ja&XMODE=0&SSRC=%s&txtDirection=enja"
	 "Amikai")
	("tr-je-nifty"
	 "http://honyaku-result.nifty.com/LUCNIFTY/text/text.php"
	 utf-8 "SLANG=ja&TLANG=en&XMODE=0&SSRC=%s&txtDirection=jaen"
	 "Amikai")
	("tr-cj-nifty"
	 "http://honyaku-result.nifty.com/LUCNIFTY/text/text.php"
	 utf-8 "SLANG=zh&TLANG=ja&XMODE=0&SSRC=%s&txtDirection=zhja"
	 "Amikai")
	("tr-jc-nifty"
	 "http://honyaku-result.nifty.com/LUCNIFTY/text/text.php"
	 utf-8 "SLANG=ja&TLANG=zh&XMODE=0&SSRC=%s&txtDirection=jazh"
	 "Amikai")
	("tr-twja-nifty"
	 "http://honyaku-result.nifty.com/LUCNIFTY/text/text.php"
	 utf-8 "SLANG=tw&TLANG=ja&XMODE=0&SSRC=%s&txtDirection=twja"
	 "Amikai")
	("tr-jatw-nifty"
	 "http://honyaku-result.nifty.com/LUCNIFTY/text/text.php"
	 utf-8 "SLANG=ja&TLANG=tw&XMODE=0&SSRC=%s&txtDirection=jatw"
	 "Amikai")
	("tr-kj-nifty"
	 "http://honyaku-result.nifty.com/LUCNIFTY/text/text.php"
	 utf-8 "SLANG=ko&TLANG=ja&XMODE=0&SSRC=%s&txtDirection=koja"
	 "Amikai")
	("tr-jk-nifty"
	 "http://honyaku-result.nifty.com/LUCNIFTY/text/text.php"
	 utf-8 "SLANG=ja&TLANG=ko&XMODE=0&SSRC=%s&txtDirection=jako"
	 "Amikai")
	))
   ;; nifty web page translator
   ("tr-ej-url-nifty"
    "http://honyaku-result.nifty.com/LUCNIFTY/ns/wt_ex.cgi"
    utf-8 "SLANG=en&TLANG=ja&XMODE=1&SURL=%s&webDirection=enja"
    "Amikai"
    )
   ("tr-je-url-nifty"
    "http://honyaku-result.nifty.com/LUCNIFTY/ns/wt_ex.cgi"
    utf-8 "SLANG=ja&TLANG=en&XMODE=1&SURL=%s&webDirection=jaen"
    "Amikai")
   ("tr-cj-url-nifty"
    "http://honyaku-result.nifty.com/LUCNIFTY/ns/wt_ex.cgi"
    utf-8 "SLANG=zh&TLANG=ja&XMODE=1&SURL=%s&webDirection=zhja"
    "Amikai")
   ("tr-jc-url-nifty"
    "http://honyaku-result.nifty.com/LUCNIFTY/ns/wt_ex.cgi"
    utf-8 "SLANG=ja&TLANG=zh&XMODE=1&SURL=%s&webDirection=jazh"
    "Amikai")
   ("tr-twja-url-nifty"
    "http://honyaku-result.nifty.com/LUCNIFTY/ns/wt_ex.cgi"
    utf-8 "SLANG=tw&TLANG=ja&XMODE=1&SURL=%s&webDirection=twja"
    "Amikai")
   ("tr-jatw-url-nifty"
    "http://honyaku-result.nifty.com/LUCNIFTY/ns/wt_ex.cgi"
    utf-8 "SLANG=ja&TLANG=tw&XMODE=1&SURL=%s&webDirection=jatw"
    "Amikai")
   ("tr-kj-url-nifty"
    "http://honyaku-result.nifty.com/LUCNIFTY/ns/wt_ex.cgi"
    utf-8 "SLANG=ko&TLANG=ja&XMODE=1&SURL=%s&webDirection=koja"
    "Amikai")
   ("tr-jk-url-nifty"
    "http://honyaku-result.nifty.com/LUCNIFTY/ns/wt_ex.cgi"
    utf-8 "SLANG=ja&TLANG=ko&XMODE=1&SURL=%s&webDirection=jako"
    "Amikai")

   ;; magicalgate translator
   ("tr-je-magicalgate" "http://221.243.5.2/impulse/TextTranslator" utf-8
    "init=init&srcText=%s&direction=1&srcLang=jp&dstLang=en")
   ("tr-jk-magicalgate" "http://221.243.5.2/impulse/TextTranslator" utf-8
    "init=init&srcText=%s&direction=1&srcLang=jp&dstLang=kr")
   ("tr-jc-magicalgate" "http://221.243.5.2/impulse/TextTranslator" utf-8
    "init=init&srcText=%s&direction=1&srcLang=jp&dstLang=cn")
   ("tr-jptw-magicalgate" "http://221.243.5.2/impulse/TextTranslator" utf-8
    "init=init&srcText=%s&direction=1&srcLang=jp&dstLang=tw")
   ("tr-jpbp-magicalgate" "http://221.243.5.2/impulse/TextTranslator" utf-8
    "init=init&srcText=%s&direction=1&srcLang=jp&dstLang=bp")
   ("tr-jpde-magicalgate" "http://221.243.5.2/impulse/TextTranslator" utf-8
    "init=init&srcText=%s&direction=1&srcLang=jp&dstLang=de")
   ("tr-jpfr-magicalgate" "http://221.243.5.2/impulse/TextTranslator" utf-8
    "init=init&srcText=%s&direction=1&srcLang=jp&dstLang=fr")
   ("tr-jpit-magicalgate" "http://221.243.5.2/impulse/TextTranslator" utf-8
    "init=init&srcText=%s&direction=1&srcLang=jp&dstLang=it")
   ("tr-jpes-magicalgate" "http://221.243.5.2/impulse/TextTranslator" utf-8
    "init=init&srcText=%s&direction=1&srcLang=jp&dstLang=es")
   ("tr-ej-magicalgate" "http://221.243.5.2/impulse/TextTranslator" utf-8
    "init=init&srcText=%s&direction=2&srcLang=jp&dstLang=en")
   ("tr-kj-magicalgate" "http://221.243.5.2/impulse/TextTranslator" utf-8
    "init=init&srcText=%s&direction=2&srcLang=jp&dstLang=kr")
   ("tr-cj-magicalgate" "http://221.243.5.2/impulse/TextTranslator" utf-8
    "init=init&srcText=%s&direction=2&srcLang=jp&dstLang=cn")
   ("tr-twjp-magicalgate" "http://221.243.5.2/impulse/TextTranslator" utf-8
    "init=init&srcText=%s&direction=2&srcLang=jp&dstLang=tw")
   ("tr-bpjp-magicalgate" "http://221.243.5.2/impulse/TextTranslator" utf-8
    "init=init&srcText=%s&direction=2&srcLang=jp&dstLang=bp")
   ("tr-dejp-magicalgate" "http://221.243.5.2/impulse/TextTranslator" utf-8
    "init=init&srcText=%s&direction=2&srcLang=jp&dstLang=de")
   ("tr-frjp-magicalgate" "http://221.243.5.2/impulse/TextTranslator" utf-8
    "init=init&srcText=%s&direction=2&srcLang=jp&dstLang=fr")
   ("tr-itjp-magicalgate" "http://221.243.5.2/impulse/TextTranslator" utf-8
    "init=init&srcText=%s&direction=2&srcLang=jp&dstLang=it")
   ("tr-esjp-magicalgate" "http://221.243.5.2/impulse/TextTranslator" utf-8
    "init=init&srcText=%s&direction=2&srcLang=jp&dstLang=es")

   ;; infoseek translator
   ,@(dic-lookup-w3m-search-engine-postget
      '(("tr-ej-infoseek" "http://translation.infoseek.co.jp/" utf-8
	 "ac=Text&lng=en&original=%s&selector=0&submit=$B!!K]Lu!!(B"
	 "Cross Language")
	("tr-je-infoseek" "http://translation.infoseek.co.jp/" utf-8
	 "ac=Text&lng=en&original=%s&selector=1&submit=$B!!K]Lu!!(B"
	 "Cross Language")
	("tr-kj-infoseek" "http://translation.infoseek.co.jp/" utf-8
	 "ac=Text&lng=ko&original=%s&selector=0&submit=$B!!K]Lu!!(B"
	 "Changshin Soft (CSLI)")
	("tr-jk-infoseek" "http://translation.infoseek.co.jp/" utf-8
	 "ac=Text&lng=ko&original=%s&selector=1&submit=$B!!K]Lu!!(B"
	 "Changshin Soft (CSLI)")
	("tr-cj-infoseek" "http://translation.infoseek.co.jp/" utf-8
	 "ac=Text&lng=zh&original=%s&selector=0&submit=$B!!K]Lu!!(B"
	 "Cross Language")
	("tr-jc-infoseek" "http://translation.infoseek.co.jp/" utf-8
	 "ac=Text&lng=zh&original=%s&selector=1&submit=$B!!K]Lu!!(B"
	 "Cross Language")
	("tr-frjp-infoseek" "http://translation.infoseek.co.jp/" utf-8
	 "ac=Text&lng=fr&original=%s&selector=0&submit=$B!!K]Lu!!(B")
	("tr-jpfr-infoseek" "http://translation.infoseek.co.jp/" utf-8
	 "ac=Text&lng=fr&original=%s&selector=1&submit=$B!!K]Lu!!(B")
	("tr-dejp-infoseek" "http://translation.infoseek.co.jp/" utf-8
	 "ac=Text&lng=de&original=%s&selector=0&submit=$B!!K]Lu!!(B")
	("tr-jpde-infoseek" "http://translation.infoseek.co.jp/" utf-8
	 "ac=Text&lng=de&original=%s&selector=1&submit=$B!!K]Lu!!(B")
	("tr-itjp-infoseek" "http://translation.infoseek.co.jp/" utf-8
	 "ac=Text&lng=it&original=%s&selector=0&submit=$B!!K]Lu!!(B")
	("tr-jpit-infoseek" "http://translation.infoseek.co.jp/" utf-8
	 "ac=Text&lng=it&original=%s&selector=1&submit=$B!!K]Lu!!(B")
	("tr-esjp-infoseek" "http://translation.infoseek.co.jp/" utf-8
	 "ac=Text&lng=es&original=%s&selector=0&submit=$B!!K]Lu!!(B")
	("tr-jpes-infoseek" "http://translation.infoseek.co.jp/" utf-8
	 "ac=Text&lng=es&original=%s&selector=1&submit=$B!!K]Lu!!(B")
	("tr-ptjp-infoseek" "http://translation.infoseek.co.jp/" utf-8
	 "ac=Text&lng=pt&original=%s&selector=0&submit=$B!!K]Lu!!(B")
	("tr-jppt-infoseek" "http://translation.infoseek.co.jp/" utf-8
	 "ac=Text&lng=pt&original=%s&selector=1&submit=$B!!K]Lu!!(B")
	))

   ;; $BLu$7$F$M$C$H(B web page translator
   ("tr-ej-url-yakushite.net"
    "http://www.yakushite.net/cgi-bin/WebObjects/YakushiteNet.woa/wa/TranslateDirectAction/defaultTrans?direction=LR&_COMMUNITY_ID=900002&textArea=%s&isRecommend=5.0.3.3.1.0.5.0.0.1.15&5.0.3.3.1.0.5.0.0.1.19.1=$BK]Lu(B" utf-8)
   ("tr-je-url-yakushite.net"
    "http://www.yakushite.net/cgi-bin/WebObjects/YakushiteNet.woa/wa/TranslateDirectAction/defaultTrans?direction=RL&_COMMUNITY_ID=900002&textArea=%s&isRecommend=5.0.3.3.1.0.5.0.0.1.15&5.0.3.3.1.0.5.0.0.1.19.1=$BK]Lu(B" utf-8)
   ("tr-cj-url-yakushite.net"
    "http://www.yakushite.net/cgi-bin/WebObjects/ChinaYakushiteNet.woa/wa/TranslateDirectAction/defaultTrans?direction=LR&_COMMUNITY_ID=900002&textArea=%s&isRecommend=5.0.3.3.1.0.5.0.0.1.15&5.0.3.3.1.0.5.0.0.1.19.1=$BK]Lu(B" utf-8)
   ("tr-jc-url-yakushite.net"
    "http://www.yakushite.net/cgi-bin/WebObjects/ChinaYakushiteNet.woa/wa/TranslateDirectAction/defaultTrans?direction=RL&_COMMUNITY_ID=900002&textArea=%s&isRecommend=5.0.3.3.1.0.5.0.0.1.15&5.0.3.3.1.0.5.0.0.1.19.1=$BK]Lu(B" utf-8)
   ("tr-ej-url-yakushite.net-put"
    "http://www.yakushite.net/cgi-bin/WebObjects/YakushiteNet.woa/wa/TranslateDirectAction/defaultTrans"
    utf-8 "direction=LR&_COMMUNITY_ID=900002&textArea=%s&isRecommend=5.0.3.3.1.0.5.0.0.1.15&5.0.3.3.1.0.5.0.0.1.19.1=$BK]Lu(B")
   ("tr-je-url-yakushite.net-put"
    "http://www.yakushite.net/cgi-bin/WebObjects/YakushiteNet.woa/wa/TranslateDirectAction/defaultTrans"
    utf-8 "direction=RL&_COMMUNITY_ID=900002&textArea=%s&isRecommend=5.0.3.3.1.0.5.0.0.1.15&5.0.3.3.1.0.5.0.0.1.19.1=$BK]Lu(B")
   ("tr-cj-url-yakushite.net-put"
    "http://www.yakushite.net/cgi-bin/WebObjects/ChinaYakushiteNet.woa/wa/TranslateDirectAction/defaultTrans"
    utf-8 "direction=LR&_COMMUNITY_ID=900002&textArea=%s&isRecommend=5.0.3.3.1.0.5.0.0.1.15&5.0.3.3.1.0.5.0.0.1.19.1=$BK]Lu(B")
   ("tr-jc-url-yakushite.net-put"
    "http://www.yakushite.net/cgi-bin/WebObjects/ChinaYakushiteNet.woa/wa/TranslateDirectAction/defaultTrans"
    utf-8 "direction=RL&_COMMUNITY_ID=900002&textArea=%s&isRecommend=5.0.3.3.1.0.5.0.0.1.15&5.0.3.3.1.0.5.0.0.1.19.1=$BK]Lu(B")
   ))

;; google translator
(defvar dic-lookup-w3m-google-translator-langs
  '(("ja") nil)
  ;;'(("ja" "en") ("en" "ko" "zh-CN" "es"))
  "*google$BK]Lu$GM-8z$K$9$k8@8l$N%j%9%H!#(B
\((LANGS1) (LANGS2))
LANGS1$B!"(BLANGS2$B$O8@8lL>$N%j%9%H!#(BLANGS1 X LANGS2$B$NAH$_9g$o$;$GK]Lu(B
$B$,$G$-$k$h$&$K$9$k!#(B
nil$B$N>l9g$O$9$Y$F$N8@8l$rBP>]$K$9$k!#(Bnil X nil$B$O5/F0$,CY$/$J$k!#(B")

(let* ((langs
	'(("ar" . "$B%"%i%S%"8l(B")
	  ("sq" . "$B%"%k%P%K%"8l(B")
	  ("it" . "$B%$%?%j%"8l(B")
	  ("id" . "$B%$%s%I%M%7%"8l(B")
	  ("uk" . "$B%&%/%i%$%J8l(B")
	  ("et" . "$B%(%9%H%K%"8l(B")
	  ("nl" . "$B%*%i%s%@8l(B")
	  ("ca" . "$B%+%?%m%K%"8l(B")
	  ("gl" . "$B%,%j%7%"8l(B")
	  ("el" . "$B%.%j%7%c8l(B")
	  ("hr" . "$B%/%m%"%A%"8l(B")
	  ("sv" . "$B%9%&%'!<%G%s8l(B")
	  ("es" . "$B%9%Z%$%s8l(B")
	  ("sk" . "$B%9%m%P%-%"8l(B")
	  ("sl" . "$B%9%m%Y%K%"8l(B")
	  ("sr" . "$B%;%k%S%"8l(B")
	  ("th" . "$B%?%$8l(B")
	  ("tl" . "$B%?%,%m%08l(B")
	  ("cs" . "$B%A%'%38l(B")
	  ("da" . "$B%G%s%^!<%/8l(B")
	  ("de" . "$B%I%$%D8l(B")
	  ("tr" . "$B%H%k%38l(B")
	  ("no" . "$B%N%k%&%'!<8l(B")
	  ("hu" . "$B%O%s%,%j!<8l(B")
	  ("hi" . "$B%R%s%G%#!<8l(B")
	  ("fi" . "$B%U%#%s%i%s%I8l(B")
	  ("fr" . "$B%U%i%s%98l(B")
	  ("bg" . "$B%V%k%,%j%"8l(B")
	  ("vi" . "$B%Y%H%J%`8l(B")
	  ("iw" . "$B%X%V%i%$8l(B")
	  ("pl" . "$B%]!<%i%s%I8l(B")
	  ("pt" . "$B%]%k%H%,%k8l(B")
	  ("mt" . "$B%^%k%?8l(B")
	  ("lv" . "$B%i%H%S%"8l(B")
	  ("lt" . "$B%j%H%"%K%"8l(B")
	  ("ro" . "$B%k!<%^%K%"8l(B")
	  ("ru" . "$B%m%7%"8l(B")
	  ("en" . "$B1Q8l(B")
	  ("ko" . "$B4Z9q8l(B")
	  ("zh-CN" . "$BCf9q8l(B($B4JBN(B)")
	  ("zh-TW" . "$BCf9q8l(B($BHKBN(B)")
	  ("ja" . "$BF|K\8l(B")
	  ))
       (langs1 (or (nth 0 dic-lookup-w3m-google-translator-langs)
		   (mapcar 'car langs)))
       (langs2 (or (nth 1 dic-lookup-w3m-google-translator-langs)
		   (mapcar 'car langs))))
  (dolist (l1 langs1)
    (unless (equal l1 "zh-TW")
      (dolist (l2 langs2)
	(unless (equal l2 l1)
	  (dolist (arg (list (list l1 l2) (list l2 l1)))
	    (apply
	     '(lambda (l1 l2)
		(add-to-list
		 'dic-lookup-w3m-search-engine-alist
		 (list
		  (format "tr-%s%s-google" l1 l2)
		  "http://translate.google.com/translate_t" 'utf-8
		  (format "langpair=%s|%s&ie=utf-8&oe=utf-8&text=%%s"
			  l1 l2)
		  (concat (assoc-default l1 langs)
			  "-" (assoc-default l2 langs))))
		(add-to-list
		 'dic-lookup-w3m-search-engine-alist
		 (list
		  (format "tr-%s%s-url-google" l1 l2)
		  (format
		   "http://translate.google.com/translate_t?langpair=%s|%s&ie=utf-8&oe=utf-8&text=%%s"
		   l1 l2)
		  'utf-8 nil
		  (concat (assoc-default l1 langs)
			  "-" (assoc-default l2 langs)))))
	     arg)))))))

;; google translator (aliases)
(mapc
 '(lambda (e) (add-to-list 'dic-lookup-w3m-search-engine-aliases e))
 '(("tr-ej-google" "tr-enja-google")
   ("tr-je-google" "tr-jaen-google")
   ("tr-cj-google" "tr-zh-CNja-google")
   ("tr-jc-google" "tr-jazh-CN-google")
   ("tr-kj-google" "tr-koja-google")
   ("tr-jk-google" "tr-jako-google")))

(defvar dic-lookup-w3m-filter-do-show-candidates-heading " $B8uJd(B: "
  "*$BC18l$N8uJd%j%9%H$NA0$KI=<($9$k8+=P$7!#(B")

(defvar dic-lookup-w3m-filter-related-links-heading " $B4XO"(B: "
  "*$B4XO"%5%$%H$N%j%9%H$NA0$KI=<($9$k8+=P$7!#(B")

(defvar dic-lookup-w3m-favorite-ej-engine "ej-excite")

(defvar dic-lookup-w3m-filter-disable-translation-anchor nil
  "*web$B%Z!<%8$KK]Lu%\%?%s$r$D$1$k$+$I$&$+$N%U%i%0!#(B
non-nil$B$J$i%Z!<%8K]Lu%\%?%s$rIU$1$J$$!#(B
nil$B$J$i(B`dic-lookup-w3m-filter-translation-anchor'$B$r8F$S=P$7$F(Bweb$B%Z!<%8(B
$B$KK]Lu%\%?%s$r$D$1$k!#(B")

(eval-after-load "w3m-filter"
  '(mapc
    '(lambda (elem)
       (add-to-list 'w3m-filter-rules elem))
    (reverse
     `(
       ,(unless dic-lookup-w3m-filter-disable-translation-anchor
	  '("" dic-lookup-w3m-filter-translation-anchor)) ; $B%Z!<%8K]Lu%\%?%s(B

       ;; yahoo dic
       ("\\`http://dic\\.yahoo\\.co\\.jp/dsearch"
	(w3m-filter-delete-regions "<body[^>]*>" "<div class=\"result-100\">" t t t)
	(w3m-filter-delete-regions "<!-- QR -->" "</body>" nil t)
	(w3m-filter-replace-regexp
	 "<img src=\"http://img.yahoo.co.jp/images/clear.gif\"[^>]*>" "")
	(w3m-filter-replace-regexp
	 "<img src=\"http://i.yimg.jp/images/clear.gif\"[^>]*>" "")
	(dic-lookup-w3m-filter-eword-anchor "ej-yahoo")
	)
       ("\\`http://dic\\.yahoo\\.co\\.jp/dsearch.*dtype=0"
	dic-lookup-w3m-filter-related-links "jj-yahoo" jj)
       ("\\`http://dic\\.yahoo\\.co\\.jp/dsearch.*dtype=5"
	dic-lookup-w3m-filter-related-links "thesaurus-j-yahoo"	jj)
       ("\\`http://dic\\.yahoo\\.co\\.jp/dsearch.*dtype=1"
	dic-lookup-w3m-filter-related-links "ej-yahoo" ej)
       ("\\`http://dic\\.yahoo\\.co\\.jp/dsearch.*dtype=[13]"
	dic-lookup-w3m-filter-convert-phonetic-symbol
	dic-lookup-w3m-filter-yahoo-ej2-symbol-alist
	"<img src=\"[^\"]+/\\([a-z0-9]+\\)\\.gif\"[^>]*>")
       ("\\`http://dic\\.yahoo\\.co\\.jp/dsearch.*dtype=[01]"
	dic-lookup-w3m-filter-convert-phonetic-symbol
	dic-lookup-w3m-filter-yahoo-ej1-symbol-alist
	"<img src=\"[^\"]+/\\([A-Z0-9_]+\\)\\.gif\"[^>]*>")
       ("\\`http://dic\\.yahoo\\.co\\.jp/dsearch.*dtype=3"
	dic-lookup-w3m-filter-related-links "je-yahoo" ej)
       ("\\`http://dic\\.yahoo\\.co\\.jp/dsearch"
	dic-lookup-w3m-filter-show-candidates "ej-yahoo")

       ;; excite dic
       ("\\`http://www\\.excite\\.co\\.jp/dictionary/.*search="
	(dic-lookup-w3m-filter-excite-jump-to-content
	 "http://www.excite.co.jp%s"
	 "<a href=\"\\(/dictionary/.*/\\?search=[^>]*\\(block\\|itemid\\|&id\\)=[^>]*\\)\">" 1)
	(w3m-filter-delete-regions "<body>" "<blockquote>" t)
	(w3m-filter-delete-regions "<body>" "</b> $B$N8!:w7k2L(B</p>" t)
	(w3m-filter-delete-regions "<table .*class=\"newsExtraBox\">" "</body>" nil t t)
	(w3m-filter-replace-regexp
	 "<img src=\"?http://image\.excite\.co\.jp/jp/1pt\.gif\"?[^>]*>" "")
	(dic-lookup-w3m-filter-eword-anchor "ej-excite")
	)
       ("\\`http://www\\.excite\\.co\\.jp/dictionary/.*english.*/.*search="
	(w3m-filter-replace-regexp
	 "</body>"
	 "<form action=\"/dictionary/english_japanese/\" method=\"get\" name=\"dictionary_form\">
<input name=\"search\" size=\"30\">
<input type=\"submit\" value=\"$B8!:w(B\" name=\"submit\">
</body>")
	(dic-lookup-w3m-filter-related-links "ej-excite" ej)
	(dic-lookup-w3m-filter-convert-phonetic-symbol
	 dic-lookup-w3m-filter-excite-ej-symbol-alist
	 "<img src=\"http://eiwa\\.excite\\.co\\.jp/images/\\(NEW_EJJE\\|COMP_EJ\\)/gaiji/\\([a-z0-9]+\\)\\.gif\"[^>]*>"
	 2)
	)
       ("\\`http://www\\.excite\\.co\\.jp/dictionary/japanese/\\?search="
	(w3m-filter-replace-regexp
	 "<span class=\"NetDicItemLink\" ItemID=\"\\([0-9]+\\)\">\\([^<]+\\)</span>"
	 "<a href=\"./?search=&itemid=\\1\">\\2</a>")
	(dic-lookup-w3m-filter-convert-phonetic-symbol
	 dic-lookup-w3m-filter-excite-jj-symbol-alist
	 "<img src=\"http://b2b\\.dejizo\\.jp/Resource.aspx\\?set=daijirin-gi&amp;name=\\([A-Z0-9]+\\)\"[^>]*>")
	(w3m-filter-replace-regexp
	 "<img src=\"http://b2b\\.dejizo\\.jp/Resource\\.aspx\\?set=unicode&amp;name=\\([^\"]+\\)\"[^>]*>" "&#x\\1\;")
	(dic-lookup-w3m-filter-related-links "jj-excite" jj)
	)
       ("\\`http://www\\.excite\\.co\\.jp/dictionary/chinese_japanese/\\?search="
	(dic-lookup-w3m-filter-related-links "cj-excite" cj)
	(dic-lookup-w3m-filter-convert-phonetic-symbol
	 dic-lookup-w3m-filter-excite-cj-symbol-alist
	 "<img src=\"?http://image\\.excite\\.co\\.jp/jp/dictionary/\\(pinyin\\|chinese_japanese\\)/\\([a-z_0-9]+\\)\\.gif\"?[^>]*>"
	 2)
	)
       ("\\`http://www\\.excite\\.co\\.jp/dictionary/japanese_chinese/\\?search="
	(dic-lookup-w3m-filter-related-links "jc-excite" cj)
	(w3m-filter-replace-regexp
	 "\\(<img src=\"http://image\\.excite\\.co\\.jp/jp/dictionary/japanese_chinese/\\(yakugo\\|youyaku\\)\\.gif\" width=16 height=16 border=0>\\)\\(.*\\)\\(&nbsp;\\)"
	 "\\1<a href=\"http://www.excite.co.jp/dictionary/chinese_japanese/?search=\\3\">\\3</a>\\4")
	(dic-lookup-w3m-filter-convert-phonetic-symbol
	 dic-lookup-w3m-filter-excite-cj-symbol-alist
	 "<img src=\"?http://image\\.excite\\.co\\.jp/jp/dictionary/\\(pinyin\\|japanese_chinese\\)/\\([a-z_0-9]+\\)\\.gif\"?[^>]*>"
	 2)
	)
       ("\\`http://www\\.excite\\.co\\.jp/dictionary/.*search="
	dic-lookup-w3m-filter-show-candidates "ej-excite")

       ;; alc
       ("\\`http://eow\\.alc\\.co\\.jp/[^/]+/UTF-8"
	(w3m-filter-delete-regions
	 "<body[^>]*>" "<div id=\"resultArea\">" t nil t t)
	(w3m-filter-delete-regions "<span class=\"kana\">" "</span>")
	(dic-lookup-w3m-filter-related-links "ej-alc" ej)
	)

       ;; alc business term dic
       ("\\`http://home\\.alc\\.co\\.jp/db/owa/bdicn_sch"
	w3m-filter-delete-regions
	"<body bgcolor=\"#FFFFFF\">" "<!--$B"%(Binput_form-->" t)

       ;; webster
       ("\\`http://www\\.merriam-webster\\.com/\\(dictionary\\|thesaurus\\)/.+"
	(w3m-filter-delete-regions
	 "<div id=\"page_wrapper\">" "<div class=\"page_content\">")
	(dic-lookup-w3m-filter-related-links "ee-webster" ej)
	)

       ;; cambridge
       ("\\`http://dictionary\\.cambridge\\.org/results\\.asp\\?searchword="
	w3m-filter-delete-regions "<body>" "<!-- Begin results area -->" t)

       ;; yahoo.com
       ("\\`http://education\\.yahoo\\.com/reference/dictionary/"
	(w3m-filter-delete-regions
	 "<body[^>]*>"
	 "<div id=\"yedusearchresultspaginationtop\"[^>]*>" t t t t)
	(w3m-filter-delete-regions
	 "<body[^>]*>" "<div id=\"yeduarticlenavigationtop\"[^>]*>" t t t t)
	)
       ("\\`http://education\\.yahoo\\.com/reference/dict_en_es/"
	(w3m-filter-delete-regions "<body[^>]*>" "Your search: " t t t)
	(w3m-filter-delete-regions
	 "<body[^>]*>" "<div id=\"yeduarticlenavigationtop\"[^>]*>" t t t t)
	)

       ;; kotonoha
       ("\\`http://www\\.kotonoha\\.gr\\.jp/demo/search_"
	(w3m-filter-delete-regions
	 "<div id=\"wrapper\">" "<!-- END of header -->")
	(w3m-filter-delete-regions
	 "<div id=\"headerB\">" "<p>$B8!:wJ8;zNs!'(B" t t)
	(w3m-filter-delete-regions
	 "<div id=\"headerB\">" "<h2>$B8!:w7k2L(B</h2>" t t)
	)
       ("\\`http://www\\.kotonoha\\.gr\\.jp/demo/search_result"
	(w3m-filter-replace-regexp "class=\"cell01\"" "align=\"right\"")
	(w3m-filter-replace-regexp
	 "<td class=\"cell02\">\\([^<]*\\)</td>"
	 "<td class=\"cell02\"><strong>\\1</strong></td>")
	(w3m-filter-replace-regexp "<td\\([ >]\\)" "<td nowrap\\1")
	)
       ("http://www\\.kotonoha\\.gr\\.jp/demo"
	dic-lookup-w3m-filter-refresh-url
	"http://www.kotonoha.gr.jp/demo/search_form?viaTopPage=1")

       ;; $B@D6uJ88K(B $BF|K\8lMQNc8!:w(B
       ("http://www.tokuteicorpus.jp/team/jpling/kwic/search.cgi"
	(w3m-filter-replace-regexp "<font color=\"crimson\">" "<strong>")
	(w3m-filter-replace-regexp "</font>" "</strong>")
	)

       ;; erek corpus
       ("\\`http://erek\\.ta2o\\.net/"
	(w3m-filter-replace-regexp
	 "<div class=\"kwicright\">\\([^<]*\\)</div>" "<span>\\1</span>")
	(w3m-filter-replace-regexp
	 "<div class=\"kwiccenter\"\\(.*\n.*\\)</div>" "<span\\1</span>")
	(w3m-filter-replace-regexp
	 "<div class=\"kwicleft\">\\([^<]*\\)</div>" "<span>\\1</span>")
	)

       ;; bnc corpus
       ("\\`http://sara\\.natcorp\\.ox\\.ac\\.uk/cgi-bin/saraWeb\\?qy=.*"
	dic-lookup-w3m-filter-eword-anchor dic-lookup-w3m-favorite-ej-engine)

       ;; Dictionary.com
       ("http://\\(thesaurus\\|dictionary\\)\\.reference\\.com/browse/"
	(w3m-filter-delete-regions
	 "<body onload=\"initpage();\">" "<div id=\"contentResults\">" t t)
	(dic-lookup-w3m-filter-related-links "thesaurus-rogets" ej)
	)

       ;; lsd
       ("\\`http://lsd\\.pharm\\.kyoto-u\\.ac\\.jp/cgi-bin/lsdproj/etoj-cgi04\\.pl"
	dic-lookup-w3m-filter-eword-anchor "ej-lsd")

       ;; RNN$B;~;v1Q8l<-E5(B
       ("\\`http://rnnnews\\.jp/"
	(w3m-filter-delete-regions
	 "<body>" "<div id=\"body\">" t t)
	(w3m-filter-replace-regexp
	 "<img src=\"../../img/related.gif\"[^>]*>" "$B4XO"(B:")
	(dic-lookup-w3m-filter-eword-anchor dic-lookup-w3m-favorite-ej-engine)
	)

       ;; bitex
       ("\\`http://bitex-cn\\.com/search_result\\.php"
	(w3m-filter-delete-regions
	 "<body>" "<div class=\"center03\">" t t)
	(dic-lookup-w3m-filter-related-links "cj-bitex" cj)
	)

       ;; $BFX_j<-3$(B
       ("\\`http://www\\.onlinedic\\.com/search\\.php"
	(w3m-filter-delete-regions
	 "<body[^>]*>" "<!-- Main -->" t t t)
	(w3m-filter-delete-regions
	 "<td width=\"250\" bgcolor=\"#E5F2FB\" valign=\"top\">"
	 "</body>" nil t)
	(dic-lookup-w3m-filter-related-links "cj-tonko-jikai" cj)
	(dic-lookup-w3m-filter-convert-phonetic-symbol
	 dic-lookup-w3m-filter-onlinedic-symbol-alist
	 "<img [^>]+images/\\([a-z0-9_]+\\)\\.gif[^>]*>")
	(w3m-filter-replace-regexp
	 "\\(<\\(table\\|td\\) [^>]*\\)\\(width=\"[0-9]+\"\\)\\([^>]*>\\)"
	 "\\1\\4")
	(w3m-filter-replace-regexp "</?font[^>]*>" "")
	(w3m-filter-replace-regexp
	 "\\(<td class=\"line1\">$BCf9q8l!'(B</td><td class=\"line2\">\\)\\([^<]+\\)</td>"
	 "\\1\\2 $B"M(B<a href=\"http://www.cazoo.jp/cgi-bin/pinyin/index.html?hanzi=\\2\">pinyin</a></td>")
	)

       ;; $B3ZLuCf9q8l<-=q(B
       ("\\`http://www\\.jcdic\\.com/search\\.php"
	(w3m-filter-delete-regions
	 "<body[^>]*>" "<div class='result'>" t t t)
	(w3m-filter-delete-regions
	 "<!--Adsense$B3+;O(B-->" "<!-- Footer -->")
	(dic-lookup-w3m-filter-related-links "cj-tonko-jikai" cj)
	(dic-lookup-w3m-filter-convert-phonetic-symbol
	 dic-lookup-w3m-filter-onlinedic-symbol-alist
	 "<img [^>]+images/\\([a-z0-9_]+\\)\\.gif[^>]*>")
	(dic-lookup-w3m-filter-conv-pinyin "(\\(.*\\))")
	)

       ;; hjenglish $BCfF|(B
       ("\\`http://dict\\.hjenglish\\.com/.*type=cj"
	dic-lookup-w3m-filter-related-links "cj-hjenglish" cj)
       ("\\`http://dict\\.hjenglish\\.com/.*type=jc"
	dic-lookup-w3m-filter-related-links "jc-hjenglish" cj)
       ("\\`http://dict\\.hjenglish\\.com/"
	dic-lookup-w3m-filter-convert-phonetic-symbol
	dic-lookup-w3m-filter-hjenglish-symbol-alist
	"<img [^>]+/images/\\([a-z0-9_]+\\)\\.gif[^>]*>")

       ;; inforseek dic
       ("\\`http://dictionary\\.infoseek\\.ne\\.jp/"
       	w3m-filter-delete-regions
       	"<body[^>]*>"
       	"\\(<ul class=\"search_list\">\\|<div class=\"word_block\">\\)"
       	t t t t)
       ("\\`http://dictionary\\.infoseek\\.ne\\.jp/"
	(dic-lookup-w3m-filter-show-candidates "ej-infoseek")
	(dic-lookup-w3m-filter-eword-anchor "ej-infoseek")
	)
       ("\\`http://dictionary\\.infoseek\\.ne\\.jp/ejword"
       	dic-lookup-w3m-filter-related-links
	"ej-infoseek" ej "http://dictionary.infoseek.ne.jp/ejword/%s")
       ("http://dictionary\\.infoseek\\.ne\\.jp/jeword"
       	dic-lookup-w3m-filter-related-links
	"je-infoseek" ej "http://dictionary.infoseek.ne.jp/jeword/%s")
       ("\\`http://dictionary\\.infoseek\\.ne\\.jp/word"
       	dic-lookup-w3m-filter-related-links
	"jj-infoseek" jj "http://dictionary.infoseek.ne.jp/word/%s")

       ("\\`http://dictionary\\.infoseek\\.ne\\.jp/"
	(dic-lookup-w3m-filter-convert-phonetic-symbol
	 dic-lookup-w3m-filter-yahoo-ej1-symbol-alist
	 "<img name=\"[^\"]+\" src=\"/lang/g/pej4/\\([A-Z0-9_]+\\).png\"/>")
       	)

       ;; gigadict
       ("\\`http://cgi\\.geocities\\.jp/abelinternational/cgi/kanjidic\\.cgi"
	dic-lookup-w3m-filter-related-links "Kanji-gigadict" kanji)
       ("\\`http://cgi\\.geocities\\.jp/abelinternational/cgi/jkdic\\.cgi"
	dic-lookup-w3m-filter-related-links "KKanji-gigadict" kanji)

       ;; FOKS Forgiving Online Kanji Search
       ("\\`http://foks\\.info/search/"
	dic-lookup-w3m-filter-related-links "kanji-foks" kanji)

       ;; kitajiro
       ("\\`http://www\\.ctrans\\.org/cjdic/search\\.php.*&opts=fw"
	dic-lookup-w3m-filter-related-links "cj-kitajiro" cj)
       ("\\`http://www\\.ctrans\\.org/cjdic/search\\.php.*&opts=jp"
	dic-lookup-w3m-filter-related-links "jc-kitajiro" cj)
       ("\\`http://www\\.ctrans\\.org/cjdic/"
	(w3m-filter-delete-regions "<p class=\"edit\">" "</p>")
	(w3m-filter-replace-regexp
	 "<span class=\"cn\" xml:lang=\"zh\" lang=\"zh\">\\(.*\\)</span>"
	 "$B!&(B \\1 $B"M(B<a href=\"http://www.cazoo.jp/cgi-bin/pinyin/index.html?hanzi=\\1\">pinyin</a>")
	(dic-lookup-w3m-filter-conv-pinyin
	 "<span class=\"pyn\">\\(.*\\)</span>")
	)

       ;; weblio thesaurus
       ("\\`http://thesaurus\\.weblio\\.jp/content/"
	(w3m-filter-delete-regions "<div ID=base>" "<form[^>]*>" nil t nil t)
	(w3m-filter-delete-regions "<div ID=formBoxWrp>" "<div ID=formBoxL>")
	(w3m-filter-delete-regions "<div ID=formBoxR>" "</div>")
	(w3m-filter-delete-regions "</form>" "<div class=kiji>" t t)
	(dic-lookup-w3m-filter-related-links "thesaurus-j-weblio" jj)
	)

       ;; weblio
       ("\\`http://ejje\\.weblio\\.jp/content/"
	(w3m-filter-delete-regions "<body[^>]*>" "<div ID=topic>" t nil t)
	(w3m-filter-delete-regions
	 "<!-- START Espritline Affiliate CODE -->"
	 "<!-- END Espritline Affiliate CODE -->")
	(w3m-filter-delete-regions "<div class=adBoxHE>" "</body>" nil t)
	(w3m-filter-replace-regexp "<span>$BMQNc(B</span>" "[$BMQNc(B]")
	(w3m-filter-replace-regexp "<div class=KejjeYrTtl>$BMQNc(B</div>" "[$BMQNc(B]")
	(dic-lookup-w3m-filter-convert-phonetic-symbol
	 dic-lookup-w3m-filter-weblio-ej-symbol-alist
	 "<img [^>]*src=\"http://www\\.weblio\\.jp/[^>]*/\\([^/\" ]+\\)\\.\\(gif\\|png\\)\"[^>]*>")
       	(dic-lookup-w3m-filter-related-links "ej-weblio" ej)
	(dic-lookup-w3m-filter-show-candidates "ej-weblio")
	(w3m-filter-delete-regions
	 "<!-- begin ad tag-->" "<!-- End ad tag -->")
	)

       ;; yahoo encyclopedia
       ("\\`http://100\\.yahoo.co\\.jp/"
	(w3m-filter-delete-regions "<body>" "<!-- /header -->" t)
	(dic-lookup-w3m-filter-related-links "encyclopedia-yahoo" jj)
	)

       ;; dokochina pinyin
       ("\\`http://dokochina\\.com/simplified\\.php"
	w3m-filter-delete-regions
	"<body[^>]*>"
	"<DIV STYLE='overflow-x:scroll; width:600px'><table border=0 cellspacing=0 cellpadding=0 bgcolor=#FFFFFF>" t t t)

       ;; pinyin chinese1
       ("\\`http://www\\.chinese1\\.jp/pinyin/gb2312/jp\\.asp"
	(w3m-filter-delete-regions
	 "<body[^>]*>" "<table border=\"0\" cellpadding=\"0\" cellspacing=\"10\">" t nil t)
	(w3m-filter-delete-regions
	 "^<div align=\"right\">" "</body>" nil t t)
	(dic-lookup-w3m-filter-related-links "pinyin-chinese1" pinyin)
	)

       ;; pinyin cazoo
       ("http://www\\.cazoo\\.jp/cgi-bin/pinyin/index\\.html\\?hanzi="
	dic-lookup-w3m-filter-related-links "pinyin-cazoo" pinyin
	nil nil "</head>")

       ;; goo
       ("\\`http://ext\\.dictionary\\.goo\\.ne\\.jp/"
	(w3m-filter-delete-regions "<body[^>]*>" "<!--CONTENTS-->" t t t)
	(w3m-filter-delete-regions "<!--c34-->" "</body>" nil t)
	(w3m-filter-delete-regions "<!--/result-->" "</body>" nil t)
	(dic-lookup-w3m-filter-eword-anchor "ej-goo")
	(dic-lookup-w3m-filter-convert-phonetic-symbol
	 dic-lookup-w3m-filter-ocn-ej-symbol-alist
	 "<img src=\"[^>]*/img[^>]*/\\([a-z_0-9]+\\)\\.gif\"[^>]*>")
	)
       ("\\`http://ext\\.dictionary\\.goo\\.ne\\.jp/srch/ej/"
	dic-lookup-w3m-filter-related-links "ej-goo" ej)
       ("\\`http://ext\\.dictionary\\.goo\\.ne\\.jp/leaf/ej/"
	dic-lookup-w3m-filter-related-links "ej-goo" ej
	"http://ext.dictionary.goo.ne.jp/leaf/ej/%s/m0u/"
	)
       ("\\`http://ext\\.dictionary\\.goo\\.ne\\.jp/srch/je/"
	dic-lookup-w3m-filter-related-links "je-goo" ej)
       ("\\`http://ext\\.dictionary\\.goo\\.ne\\.jp/leaf/je/"
	dic-lookup-w3m-filter-related-links "je-goo" ej	"/m0u/%s/")
       ("\\`http://ext\\.dictionary\\.goo\\.ne\\.jp/srch/jn/"
	dic-lookup-w3m-filter-related-links "jj-goo" jj)
       ("\\`http://ext\\.dictionary\\.goo\\.ne\\.jp/leaf/jn/"
	dic-lookup-w3m-filter-related-links "jj-goo" jj	"/m0u/%s/")
       ("\\`http://ext\\.dictionary\\.goo\\.ne\\.jp/"
	dic-lookup-w3m-filter-show-candidates "ej-goo")

       ;; ocn goo
       ("\\`http://ocndictionary\\.goo\\.ne\\.jp/search\\.php"
	(w3m-filter-delete-regions "<body[^>]*>" "<!--/tab_navi-->" t t t)
	(w3m-filter-delete-regions "<!--l14_4-->\r" "<!--/result-->")
	(w3m-filter-delete-regions "<!--/rbox-->" "</body>" nil t)
	(w3m-filter-delete-regions "<div id=\"rside\">" "</body>" nil t)
	(dic-lookup-w3m-filter-eword-anchor "ej-ocn")
	(dic-lookup-w3m-filter-convert-phonetic-symbol
	 dic-lookup-w3m-filter-ocn-ej-symbol-alist
	 "<img src=\"[^>]*/img[^>]*/\\([a-z_0-9]+\\)\\.gif\"[^>]*>")
	)
       ("\\`http://ocndictionary\\.goo\\.ne\\.jp/search\\.php.*kind=\\(ej\\|je\\)"
	dic-lookup-w3m-filter-related-links "ej-ocn" ej)
       ("\\`http://ocndictionary\\.goo\\.ne\\.jp/search\\.php.*kind=jn"
	dic-lookup-w3m-filter-related-links "jj-ocn" jj)
       ("\\`http://ocndictionary\\.goo\\.ne\\.jp/search\\.php"
	dic-lookup-w3m-filter-show-candidates "ej-ocn")

       ;;
       ;; translators
       ;;

       ;; yahoo translator
       ("\\`http://honyaku\\.yahoo\\.co\\.jp/transtext"
	(w3m-filter-delete-regions 
	 "<body>" "<textarea [^>]*id=\"textText\"" t t nil t)
	(w3m-filter-delete-regions
	 "</textarea>" "<textarea [^>]*id=\"trn_textText\"" t t nil t)
	(w3m-filter-replace-regexp
	 "<textarea [^>]*id=\"textText\"[^>]*>\\([^<]*\\)</textarea>"
	 "<p>\\1</p>")
	(w3m-filter-replace-regexp
	 "<textarea [^>]*id=\"trn_textText\"[^>]*>\\([^<]*\\)</textarea>"
	 "<hr><p>\\1</p>")
	(w3m-filter-delete-regions "<wbr" ">")
	(dic-lookup-w3m-filter-eword-anchor dic-lookup-w3m-favorite-ej-engine)
	(w3m-filter-replace-regexp "\n" "<br>\n")
	(w3m-filter-delete-regions "</div><!-- /#transafter -->" "</body>"
				   nil t)
	)

       ;; excite translator
       ("\\`http://www\\.excite\\.co\\.jp/world/"
	(w3m-filter-delete-regions
	 "<body[^>]*>" "<textarea [^>]*name=\"before\"[^>]*>" t nil t t)
	(w3m-filter-replace-regexp
	 "\\(<textarea [^>]*name=\"after\"[^>]*>\\)" "\\1<br>")
	(w3m-filter-delete-regions
	 "</textarea>" "<textarea [^>]*name=\"after\"[^>]*>" nil nil t t)
	(w3m-filter-delete-regions "</textarea>" "</body>" nil t)
	(w3m-filter-replace-regexp "\r\\([\n]\r\\)+" "</p><p>")
	(w3m-filter-replace-regexp "\r" "<br>")
	)
       ("\\`http://www\\.excite\\.co\\.jp/world/english/"
	dic-lookup-w3m-filter-eword-anchor "ej-excite")

       ;; google translator
       ("\\`http://translate\\.google\\.com/translate_t"
	(w3m-filter-delete-regions
	 "<body[^>]*>" "<textarea [^>]*name=text[^>]*>" t nil t t)
	(w3m-filter-replace-regexp
	 "\\(</textarea>\\)" "<hr>\\1")
	(w3m-filter-delete-regions
	 "</textarea>" "<span id=result_box " nil t)
	(w3m-filter-replace-regexp "\r\\([\n]\r\\)+" "</p><p>")
	(w3m-filter-delete-regions "<div id=res-translit" "</body>" nil t)
	(dic-lookup-w3m-filter-eword-anchor dic-lookup-w3m-favorite-ej-engine)
	)

       ;; yahoo.com translator
       ("http://babelfish\\.yahoo\\.com/translate_txt"
	(w3m-filter-delete-regions
	 "<body[^>]*>" "<div id=\"result\">" t t t)
	(w3m-filter-replace-regexp
	 "\\(<textarea [^>]*name=\"trtext\"[^>]*>\\)" "\\1<hr>")
	(w3m-filter-delete-regions
	 "</div></div>" "<textarea [^>]*name=\"trtext\"[^>]*>" nil nil t t)
	(w3m-filter-delete-regions "</textarea>" "</body>" nil t)
	(w3m-filter-replace-regexp "\\([^\r]\\)$" "\\1<br>")
	(w3m-filter-replace-regexp "\r\\([\n]\r\\)+" "<p>")
	(w3m-filter-replace-regexp "\r" "<br>")
	(dic-lookup-w3m-filter-eword-anchor dic-lookup-w3m-favorite-ej-engine)
	)

       ;; freetranslation translator
       ("\\`http://.*\\.freetranslation\\.com"
	(w3m-filter-delete-regions
	 "<body[^>]*>" "<textarea [^>]*name=\"dsttext\"[^>]*>" t nil t t)
	(w3m-filter-replace-regexp
	 "\\(<textarea [^>]*name=\"srctext\"[^>]*>\\)" "\\1<hr>")
	(w3m-filter-delete-regions
	 "</textarea>" "<textarea [^>]*name=\"srctext\"[^>]*>" nil nil t t)
	(w3m-filter-delete-regions "</textarea>" "</body>" nil t)
	(w3m-filter-replace-regexp "\r\\([\n]\r\\)+" "</p><p>")
	(w3m-filter-replace-regexp "\r" "<br>")
	)
       ("\\`http://tets9\\.freetranslation\\.com/"
	dic-lookup-w3m-filter-eword-anchor dic-lookup-w3m-favorite-ej-engine)

       ;; ocn translator
       ("\\`http://cgi01\\.ocn\\.ne\\.jp/cgi-bin/translation/index\\.cgi"
	(w3m-filter-delete-regions
	 "<body[^>]*>" "<textarea [^>]*name=\"sourceText\"[^>]*>" t nil t t)
	(w3m-filter-replace-regexp
	 "\\(<textarea [^>]*name=\"responseText\"[^>]*>\\)" "\\1<hr>")
	(w3m-filter-delete-regions
	 "</textarea>" "<textarea [^>]*name=\"responseText\"[^>]*>" nil nil t t)
	(w3m-filter-delete-regions "</textarea>" "</body>" nil t)
	(w3m-filter-replace-regexp "\r\\([\n]\r\\)+" "</p><p>")
	(w3m-filter-replace-regexp "\r" "<br>")
	(dic-lookup-w3m-filter-eword-anchor "ej-ocn")
	)

       ;; livedoor translator
       ("http://livedoor-translate\\.naver\\.jp/"
	(w3m-filter-delete-regions
	 "<body[^>]*>" "<textarea [^>]*name=\"translateParams.originalText\"[^>]*>" t nil t t)
	(w3m-filter-replace-regexp
	 "\\(<textarea [^>]*name=\"text02\"[^>]*>\\)" "\\1<hr>")
	(w3m-filter-delete-regions
	 "</textarea>" "<textarea [^>]*name=\"text02\"[^>]*>" nil nil t t)
	(w3m-filter-delete-regions "</textarea>" "</body>" nil t)
	(w3m-filter-delete-regions "<!--/MdAd01-->" "</html>")
	(w3m-filter-delete-regions "<!--/MdAd02-->" "</html>")
	(w3m-filter-replace-regexp "\\(\\. \\|$B!#(B\\)" "\\1<br>")
	)
       ("\\`http://livedoor-translate\\.naver\\.jp/"
	dic-lookup-w3m-filter-eword-anchor dic-lookup-w3m-favorite-ej-engine)

       ;; fresheye translator
       ("\\`http://mt\\.fresheye\\.com/ft_.*result.cgi"
	(w3m-filter-delete-regions
	 "<body[^>]*>" "<textarea [^>]*name=\"gen_text\"[^>]*>" t nil t t)
	(w3m-filter-replace-regexp
	 "\\(<textarea [^>]*name=\"gen_text2\"[^>]*>\\)" "\\1<hr>")
	(w3m-filter-delete-regions
	 "</textarea>" "<textarea [^>]*name=\"gen_text2\"[^>]*>" nil nil t t)
	(w3m-filter-delete-regions "</textarea>" "</body>" nil t nil t)
	(w3m-filter-replace-regexp "\n" "<br>")
	(dic-lookup-w3m-filter-eword-anchor dic-lookup-w3m-favorite-ej-engine)
	)

       ;; So-net translator
       ("\\`http://so-net\\.web\\.transer\\.com/text_trans_sn\\.php"
	(w3m-filter-delete-regions
	 "<body[^>]*>" "<textarea [^>]*name=\"text\"[^>]*>" t nil t t)
	(w3m-filter-replace-regexp
	 "\\(<textarea [^>]*name=\"translatedText\"[^>]*>\\)" "\\1<hr>")
	(w3m-filter-delete-regions
	 "</textarea>"
	 "<textarea [^>]*name=\"translatedText\"[^>]*>" nil nil t t)
	(w3m-filter-delete-regions "</textarea>" "</body>" nil t)
	(w3m-filter-replace-regexp "\n" "<br>")
	(dic-lookup-w3m-filter-eword-anchor dic-lookup-w3m-favorite-ej-engine)
	)

       ;; nifty translator
       ("\\`http://honyaku-result\\.nifty\\.com/LUCNIFTY/text/text.php"
	(w3m-filter-delete-regions
	 "<body[^>]*>" "<textarea [^>]*id=\"txtTransArea\"[^>]*>" t nil t t)
	(w3m-filter-replace-regexp
	 "\\(<textarea [^>]*id=\"txtTransArea2\"[^>]*>\\)" "\\1<hr>")
	(w3m-filter-delete-regions
	 "</textarea>"
	 "<textarea [^>]*id=\"txtTransArea2\"[^>]*>" nil nil t t)
	(w3m-filter-delete-regions "</textarea>" "</body>" nil t)
	(w3m-filter-replace-regexp "\n" "<br>")
	(dic-lookup-w3m-filter-eword-anchor dic-lookup-w3m-favorite-ej-engine)
	)

       ;; magicalgate translator
       ;; http://ag.magicalgate.net
       ("http://221\\.243\\.5\\.2/impulse/TextTranslator"
	(w3m-filter-delete-regions
	 "<body[^>]*>" "<textarea [^>]*name=\"srcText\"[^>]*>" t nil t t)
	(w3m-filter-replace-regexp
	 "\\(<textarea[^>]*name=\"resultText\"[^>]*>\\)" "\\1<hr>")
	(w3m-filter-delete-regions
	 "</textarea>"
	 "<textarea[^>]*name=\"resultText\"[^>]*>" nil nil t t)
	(w3m-filter-delete-regions "</textarea>" "</body>" nil t)
	(w3m-filter-replace-regexp "\n" "<br>")
	(dic-lookup-w3m-filter-eword-anchor dic-lookup-w3m-favorite-ej-engine)
	)

       ;; infoseek translator
       ("\\`http://translation\\.infoseek\\.co\\\.jp/"
	(w3m-filter-delete-regions
	 "<body[^>]*>" "<textarea [^>]*name=\"original\"[^>]*>" t nil t t)
	(w3m-filter-replace-regexp
	 "\\(<textarea [^>]*name=\"converted\"[^>]*>\\)" "\\1<hr>")
	(w3m-filter-delete-regions
	 "</textarea>"
	 "<textarea [^>]*name=\"converted\"[^>]*>" nil nil t t)
	(w3m-filter-delete-regions "</textarea>" "</body>" nil t)
	(w3m-filter-replace-regexp "\n" "<br>")
	(dic-lookup-w3m-filter-eword-anchor dic-lookup-w3m-favorite-ej-engine)
	)
       ))))

(defvar dic-lookup-w3m-inline-image-rules '())

(mapc
 '(lambda (elem) (add-to-list 'dic-lookup-w3m-inline-image-rules elem))
 '(("\\`http://www\\.excite\\.co\\.jp/dictionary/english_japanese/\\?search=" . t)
   ("\\`http://www\\.excite\\.co\\.jp/dictionary/japanese/\\?search=" . t)
   ("\\`http://www\\.excite\\.co\\.jp/dictionary/chinese_japanese/\\?search=" . t)
   ("\\`http://www\\.excite\\.co\\.jp/dictionary/japanese_chinese/\\?search=" . t)
   ("\\`http://dic\\.yahoo\\.co\\.jp/dsearch\\?" . t)
   ("\\`http://eow\\.alc\\.co\\.jp/.*/UTF-8/" . turnoff)
   ("\\`http://home\\.alc\\.co\\.jp/db/owa/bdicn_sch" . turnoff)
   ("\\`http://www\\.merriam-webster\\.com/dictionary/" . turnoff)
   ("\\`http://dictionary\\.cambridge\\.org/results.asp\\?searchword=" . turnoff)
   ("\\`http://sara\\.natcorp\\.ox\\.ac\\.uk/cgi-bin/saraWeb\\?qy=" . turnoff)
   ("\\`http://www\\.collins\\.co\\.uk/Corpus/CorpusPopUp\\.aspx\\?query=" . turnoff)
   ("\\`http://erek\\.ta2o\\.net/" . turnoff)
   ("\\`http://www\\.kotonoha\\.gr\\.jp/demo/search_result\\?query_string=" . turnoff)
   ;;("\\`http://www\\.kotonoha\\.gr\\.jp/demo" . turnoff)
   ("\\`http://www\\.excite\\.co\\.jp/world/" . turnoff)
   ("\\`http://honyaku\\.yahoo\\.co\\.jp/transtext" . turnoff)
   ("\\`http://translate\\.google\\.com/translate_t" . turnoff)
   ("\\`http://babelfish\\.yahoo\\.com/translate_txt" . turnoff)
   ("\\`http://tets9\\.freetranslation\\.com" . turnoff)
   ("\\`http://.*\\.weblio\\.jp/" . turnoff)
   ("\\`http://thesaurus\\.reference\\.com/browse/" . turnoff)
   ("\\`http://lsd-project\\.jp/weblsd/" . t)
   ("\\`http://lsd\\.pharm\\.kyoto-u\\.ac\\.jp/cgi-bin/lsdproj/etoj-cgi04\\.pl" . turnoff)
   ("\\`http://www\\.ctrans\\.org/cjdic/search\\.php" . turnoff)
   ("\\`http://bitex-cn\\.com/search_result\\.php" . turnoff)
   ("\\`http://cgi\\.geocities\\.jp/abelinternational/cgi/diccj\\.cgi" . turnoff)
   ("\\`http://dict\\.hjenglish\\.com/jp/w/" . turnoff)
   ("\\`http://dictionary\\.infoseek\\.ne\\.jp/word" . t)
   ("\\`http://dictionary\\.infoseek\\.ne\\.jp/.+word" . turnoff)
   ("\\`http://www\\.onlinedic\\.com/search\\.php" . turnoff)
   ("\\`http://www\\.frelax\\.com/cgi-local/pinyin/hz2py\\.cgi" . turnoff)
   ("\\`http://www\\.babylon\\.com/definition/" . turnoff)
   ("\\`http://100\\.yahoo\\.co\\.jp/" . turnoff)
   ("\\`http://ext\\.dictionary\\.goo\\.ne\\.jp/" . t)
   ("\\`http://ocndictionary\\.goo\\.ne\\.jp/search\\.php" . t)
   ("\\`http://www5\\.mediagalaxy\\.co\\.jp/CGI/sanshushadj/search\\.cgi" . t)
   ("\\`http://ejje\\.weblio\\.jp/content/" . t)
   ("\\`http://www\\.winttk\\.com/kakijun/dbf/profile\\.cgi" t)
   ))

(add-to-list
 'dic-lookup-w3m-related-site-list
 '(ej
   (("ej-yahoo" . "Y!")
    ("ej-excite" . "excite")
    ("ej-alc" . "alc")
    ("ej-infoseek" . "infoseek")
    ("ej-goo" . "goo")
    ("ej-ocn" . "ocn")
    ("ej-weblio" . "weblio")
    ("ee-webster" . "webster")
    ("corpus-erek" . "$B%3%Q(Berek")
    ("corpus-bnc" . "$B%3%Q(Bbnc")
    ("thesaurus-webster" . "$B%7%=(Bwebster")
    ("thesaurus-rogets" . "$B%7%=(Brogets")
    ("ej-jijieigo" . "$B;~;v(B")
    ("thesaurus-j-yahoo" . "J$BN`8l(B")
    ("thesaurus-j-weblio" . "J$B%7%=(B")
    ("corpus-j-kotonoha" . "J$B%3%Q(B")
    ("jj-yahoo" . "$B9q8l(B"))))


(add-to-list
 'dic-lookup-w3m-related-site-list
 '(jj
   (("jj-excite" . "$B9q(Bexcite")
    ("jj-yahoo" . "$B9q(BY!")
    ("jj-goo" . "$B9q(Bgoo")
    ("jj-all-weblio" . "$B9q(Bweblio")
    ("jj-chuuta" . "$B9q%A%e%&(B")
    ("kanji-infoseek" . "$B4A(B")
    ("jj-katakana-infoseek" . "$B%+%?%+%J(B")
    ("jj-yojijukugo-goo" . "$B;M=O(B")
    ("thesaurus-j-yahoo" . "$BN`8l(BY!")
    ("thesaurus-j-weblio" . "$BN`8l(Bweblio")
    ("corpus-j-kotonoha" . "J$B%3%Q(B")
    ("corpus-j-caseframe-get" . "$B3J(B")
    ("encyclopedia-yahoo" . "$BI42J(B")
    ("ja.wikipedia" . "Wikipedia")
    ("jj-wiktionary" . "Wiktionary")
    ("ej-excite" . "JE-excite")
    ("je-yahoo" . "JE-Y!")
    ("jc-excite" . "$BCf(B")
    ("JK-gigadict" . "$B4Z(B"))))

(add-to-list
 'dic-lookup-w3m-related-site-list
 '(kanji
   (("kanji-infoseek" . "$B4A(Binfoseek")
    ("Kanji-gigadict" . "$B4A(Bgigadict")
    ("KKanji-gigadict" . "$B650i4A;z(Bgigadict")
    ("kanji-foks" . "$B4A(Bfoks")
    ("jj-excite" . "$B9q(Bexcite")
    ("cj-excite" . "$BCfF|(B")
    ("jc-excite" . "$BF|Cf(B"))))

(add-to-list
 'dic-lookup-w3m-related-site-list
 '(cj
   (("cj-excite" . "CJ-excite")
    ("cj-kitajiro" . "CJ$BKL(B")
    ("cj-bitex" . "CJ-bitex")
    ("cj-tonko-jikai" . "CJ$BFX_j(B")
    ("cj-jcdic" . "CJ-jcdic")
    ("cj-hjenglish" . "CJ-hjenglish")
    ("jc-excite" . "JC-excite")
    ("jc-kitajiro" . "JC$BKL(B")
    ("jc-bitex" . "JC-bitex")
    ("jc-tonko-jikai" . "JC$BFX_j(B")
    ("jc-jcdic" . "JC-jcdic")
    ("jc-hjenglish" . "JC-hjenglish")
    ("pinyin-cazoo" . "pinyin-cazoo")
    ("jj-yahoo" . "$B9q8l(B"))))

(add-to-list
 'dic-lookup-w3m-related-site-list
 '(pinyin
   (("pinyin-cazoo" . "py-cazoo")
    ("pinyin-chinese1" . "py-chinese1")
    ("pinyin-frelax" . "py-frelax")
    ("pinyin-ctrans" . "py-ctrans")
    ("pinyin-dokochina" . "py-dokochina")
    ("pinyin-seikei" . "py-seikei")
    ("cj-excite" . "$BCfF|(B")
    ("jc-excite" . "$BF|Cf(B"))))

(defvar dic-lookup-w3m-suitable-engine-pattern
  '("[^\000-\177]" "\\(^\\|-\\)\\(ej-\\)" "\\1je-")
  "*$B8!:wJ8;zNs$K$h$C$F<-=q$r<+F0E*$K@Z$jBX$($k$?$a$N5,B'!#(B
$BNc$($P1QOB<-E5$GF|K\8lJ8;zNs$r8!:w$7$h$&$H$7$?>l9g$KOB1Q<-E5$K@Z$jBX$($F(B
$B8!:w$9$k!#(B`dic-lookup-w3m-suitable-engine'$B$G;HMQ!#(B")

(defvar dic-lookup-w3m-filter-excite-always-show-first-entry t
  "*excite$B<-=q$G:G=i$N8+=P$78l$NFbMF$rI=<($9$k!#(B
excite$B$N<-=q8!:w$GJ#?t$N8+=P$78l$,8+$D$+$C$?>l9g$G$b!":G=i$N8+=P$78l$N(B
$BFbMF$rI=<($9$k!#(B")

(defun dic-lookup-w3m-filter-excite-jump-to-content
  (url new-url &optional regexp subexp)
  "$B8!:w7k2L$N:G=i$N8+=P$78l$N@bL@$N%Z!<%8$K0\F0$9$k!#(B"
  (goto-char (point-min))
  (if (or (and dic-lookup-w3m-filter-excite-always-show-first-entry
	       (re-search-forward "$B$N8!:w7k2L(B \\[1 $B!A(B .*$B7oCf(B\\]" nil t))
	  (re-search-forward "$B$N8!:w7k2L(B \\[1 $B!A(B 1 / 1$B7oCf(B\\]" nil t))
      (dic-lookup-w3m-filter-refresh-url url new-url regexp subexp)))

(defvar dic-lookup-w3m-filter-excite-ej-symbol-alist
  '(
    ("a121" . "<a href=\"./?search=&match=&dictionary=NEW_EJJE&block=00078134&offset=0522&frommenu=true\">&#x2020;</a> ") ; $B%@%,!<(B
    ("a122" . "<a href=\"./?search=&match=&dictionary=NEW_EJJE&block=00078134&offset=0522&frommenu=true\">&#x2021;</a> ") ; $B%@%V%k%@%,!<(B
    ("a123" . "<a href=\"./?search=&match=&dictionary=NEW_EJJE&block=00078134&offset=0522&frommenu=true\">&#x2021;&#x2021;</a> ") ; $B%@%V%k%@%,!<(B x2
    ("a124" . "<a href=\"./?search=&match=&dictionary=NEW_EJJE&block=00078134&offset=0522&frommenu=true\">&#x2DA;</a>")	; $B>e4](B
    ("a125" . "&#x306;")		; $B%V%j!<%t(B($BC;2;Id(B)
    ("a126" . "$B"c(B")
    ("a127" . "$B"d(B")
    ("a128" . "<strong>$B!L(B</strong>")
    ("a129" . "<strong>$B!M(B</strong>")
    ("a12a" . "~")
    ("a12b" . "&#x2013; ")		; -
    ("a12c" . "&#x2013;&#x301; ")	; -'
    ("a12d" . "&#x2013;&#x300; ")	; -`
    ("a12e" . "&#x101;&#x301;")		; a-'
    ("a12f" . "&#x113;&#x301;")		; e-'
    ("a130" . "&#x12B;&#x301;")		; i-'
    ("a131" . "&#x361;")		; $B>eItO"7k@~(B
    ("a132" . "&#x306;")		; $B%V%j!<%t(B($BC;2;Id(B)
    ("a133" . "&#x0B8;")		; $B%;%G%#!<%f(B
    ("a134" . "&#x0E7;")		; $B%;%G%#!<%fIU$-$N(BC
    ("a135" . "&#x259;&#x301;")		; $B%7%e%o!<(B'
    ("a136" . "&#x25A;&#x301;")		; $B1&nlIU$-$N%7%e%o!<(B'
    ("a137" . "&#x0CD;")  		; I'
    ("a138" . "&#x254;&#x301;")		; $B3+$$$?(BO'
    ("a139" . "&#x28A;&#x301;")		; $B%f%W%7%m%s(B'
    ("a13a" . "&#x251;&#x301;")		; $BI.5-BN$N(BA'
    ("a13b" . "&#x301;")		; $B%"%]%9%H%m%U%#!<(B'
    ("a13c" . "&#x0C9;")		; E'
    ("a13d" . "&#x0E1;")		; a'
    ("a13e" . "&#x0E9;")  		; e'
    ("a13f" . "&#x0ED;")  		; i'
    ("a140" . "&#x0F3;")  		; o'
    ("a141" . "&#x0FA;")  		; u'
    ("a142" . "&#x28C;&#x301;")		; $B5U$5$N(BV'
    ("a143" . "&#x259;&#x300;")		; $B%7%e%o!<(B`
    ("a144" . "&#x25A;&#x300;")		; $B1&nlIU$-$N%7%e%o!<(B`
    ("a145" . "&#x0CC;")  		; I`
    ("a146" . "&#x254;&#x300;")		; $B3+$$$?(BO`
    ("a147" . "&#x28A;&#x300;")		; $B%f%W%7%m%s(B`
    ("a148" . "&#x251;&#x300;")		; $BI.5-BN$N(BA`
    ("a149" . "&#x300;")		; $B5U8~$-$N%"%]%9%H%m%U%#!<(B`
    ("a14a" . "&#x0E0;")  		; a`
    ("a14b" . "&#x0E8;")  		; e`
    ("a14c" . "&#x0EC;")  		; i`
    ("a14d" . "&#x0F2;")		; o`
    ("a14e" . "&#x0F9;")  		; u`
    ("a14f" . "&#x28C;&#x300;")		; $B5U$5$N(BV`
    ("a150" . "&#x28C;")		; $B5U$5$N(BV
    ("a151" . "&#x0C1;")		; A'
    ("a152" . "B&#x301;")		; B'
    ("a153" . "C&#x301;")		; C'
    ("a154" . "D&#x301;")		; D'
    ("a155" . "&#x0C9;")		; E'
    ("a156" . "F&#x301;")		; F'
    ("a157" . "G&#x301;")		; G'
    ("a158" . "H&#x301;")		; H'
    ("a159" . "&#x0CD;")		; I'
    ("a15a" . "L&#x301;")		; L'
    ("a15b" . "M&#x301;")		; M'
    ("a15c" . "&#x0D3;")		; O'
    ("a15d" . "P&#x301;")		; P'
    ("a15e" . "Q&#x301;")		; Q'
    ("a15f" . "R&#x301;")		; R'
    ("a160" . "S&#x301;")		; S'
    ("a161" . "T&#x301;")		; T'
    ("a162" . "&#x0DA;")		; U'
    ("a163" . "V&#x301;")		; V'
    ("a164" . "X&#x301;")		; X'
    ("a165" . "Y&#x301;")		; Y'
    ("a166" . "Z&#x301;")		; Z'
    ("a167" . "&#x0E1;")  		; a'
    ("a168" . "&#x0E9;")  		; e'
    ("a169" . "&#x0ED;")  		; i'
    ("a16a" . "&#x0F3;")  		; o'
    ("a16b" . "&#x0FA;")  		; u'
    ("a16c" . "&#x0FD;")		; y'
    ("a16d" . "&#x0C0;")		; A`
    ("a16e" . "&#x0C8;")		; E`
    ("a16f" . "&#x0CC;")		; I`
    ("a170" . "&#x0D2;")		; O`
    ;;("a171" . "&#x259;&#x301;")	; $B%7%e%o!<(B'  a171,a172 ae'
    ;;("a171a172" . "&#x0E6;&#x301;")	; $B%"%C%7%e(B; $B>.J8;z(BA$B$H(BE$B$N9g;z(B'
    ;;("a171a172" . "&#x1FD;")		; $B%"%C%7%e(B; $B>.J8;z(BA$B$H(BE$B$N9g;z(B'
    ("a171" . "")			; a171,a172 ae'
    ("a172" . "&#x1FD;")		; $B%"%C%7%e(B; $B>.J8;z(BA$B$H(BE$B$N9g;z(B'
    ("a172" . "&#x0E9;")		; e'
    ;;("a173" . "&#x259;&#x300;")	; $B%7%e%o!<(B`
    ;;("a174" . "&#x0E8;")		; e`
    ;;("a173a174" . "&#x0E6;&#x300;")	; $B%"%C%7%e(B; $B>.J8;z(BA$B$H(BE$B$N9g;z(B`
    ("a173" . "")			; a173,a174 ae`
    ("a174" . "&#x0E6;&#x300;")		; $B%"%C%7%e(B; $B>.J8;z(BA$B$H(BE$B$N9g;z(B`
    ;;("a175" . "&#x259;")		; $B%7%e%o!<(B a175,a176 ae
    ;;("a176" . "&#x065;")  		; $B>.J8;z$N(BE
    ;;("a175a176" . "&#x0E6;")		; $B%"%C%7%e(B; $B>.J8;z(BA$B$H(BE$B$N9g;z(B
    ("a175" . "")			; a175,a176 ae
    ("a176" . "&#x0E6;")		; $B%"%C%7%e(B; $B>.J8;z(BA$B$H(BE$B$N9g;z(B
    ("a177" . "S&#x300;")		; S`
    ("a178" . "T&#x300;")		; T`
    ("a179" . "&#x0D9;")		; U`
    ("a17a" . "V&#x300;")		; V`
    ("a17b" . "&#x0E0;")  		; a`
    ("a17c" . "&#x0E8;")  		; e`
    ("a17d" . "&#x0EC;")  		; i`
    ("a17e" . "&#x0F2;")  		; o`
    ;; a17f-a220$B$J$7(B
    ("a221" . "&#x0F9;")  		; u`
    ("a222" . "y&#x300;")		; y`
    ("a223" . "$B!y(B")
    ("a224" . "$B!y(B")
    ("a225" . "$B!y(B")
    ("a226" . "&#x259;")  		; $B%7%e%o!<(B
    ("a227" . "&#x25A;")  		; $B1&nlIU$-$N%7%e%o!<(B
    ("a228" . "&#x26A;")		; $B>.7?BgJ8;z$N(BI
    ("a229" . "&#x254;")		; $B3+$$$?(BO
    ("a22a" . "&#x28A;")  		; $B%f%W%7%m%s(B
    ("a22b" . "&#x3B8;")  		; $B%F!<%?(B($B%7!<%?(B)
    ("a22c" . "&#x0F0;")  		; $B%(%:(B
    ("a22d" . "&#x283;")  		; $B%(%C%7%e(B
    ("a22e" . "&#x292;")  		; $B%(%C%8%e(B; $BHxIU$-$N(BZ
    ("a22f" . "&#x14B;")  		; $B%(%s%0(B
    ("a230" . "$B!y(B")
    ("a231" . "$B!y(B")
    ("a232" . "&#x294;")		; ?
    ("a233" . "&#x2D0;")  		; $BD92;Id(B
    ("a234" . "&#x251;")		; $BI.5-BN$N(BA
    ("a235" . "$B!y(B")
    ("a236" . "$B!y(B")
    ("a237" . "&#x0E3;")		; a~
    ("a238" . "&#x0F1;")		; n~
    ("a239" . "$B!y(B")
    ("a23a" . "$B!y(B")
    ("a23b" . "&#x1AB;")  		; $B:88~$-nlIU$-$N(BT
    ("a23c" . "$B!y(B")
    ("a23d" . "$B!y(B")
    ("a23e" . "$B!y(B")
    ("a23f" . "$B!y(B")
    ("a240" . "$B!y(B")
    ("a241" . "$B!y(B")
    ("a242" . "$B!y(B")
    ("a243" . "$B!y(B")
    ("a244" . "$B!y(B")
    ("a245" . "$B!y(B")
    ("a246" . "$B!y(B")
    ("a247" . "$B!y(B")
    ("a248" . "$B!y(B")
    ("a249" . "$B!y(B")
    ;;("a24a" . "&#x251;&#x304;")		; $BI.5-BN$N(BA-
    ("a24a" . "&#x101;")		; a-
    ("a24b" . "&#x113;")		; e-
    ("a24c" . "&#x12B;")		; i-
    ("a24d" . "&#x14D;")		; o-
    ("a24e" . "&#x16B;")		; u-
    ("a24f" . "$B!y(B")
    ("a250" . "$B!y(B")
    ("a251" . "$B!y(B")
    ("a252" . "$B!y(B")
    ("a253" . "$B!y(B")
    ("a254" . "$B!y(B")
    ("a255" . "$B!y(B")
    ("a256" . "$B!y(B")
    ("a257" . "$B!y(B")
    ("a258" . "$B!y(B")
    ("a259" . "$B!y(B")
    ("a25a" . "$B!y(B")
    ("a25b" . "$B!y(B")
    ("a25c" . "$B!y(B")
    ("a25d" . "$B!y(B")
    ("a25e" . "$B!y(B")
    ("a25f" . "$B!y(B")
    ("a260" . "$B!y(B")
    ("a261" . "$B!y(B")
    ("a262" . "$B!y(B")
    ("a263" . "$B!y(B")
    ("a264" . "$B!y(B")
    ("a265" . "$B!y(B")
    ("a266" . "$B!y(B")
    ("a267" . "$B!y(B")
    ("a268" . "$B!y(B")
    ("a269" . "$B!y(B")
    ("a26a" . "$B!y(B")
    ("a26b" . "$B!&(B")
    ("a26c" . "&#x0D1;")		; N~
    ("a26d" . "E&#x300;")		; E`
    ("a26e" . "C&#x300;")		; C`
    ("a26f" . "D&#x300;")		; D`
    ("a270" . "G&#x300;")		; G`
    ("a271" . "N&#x300;")		; N`
    ("a272" . "P&#x300;")		; P`
    ("a273" . "Q&#x300;")		; Q`
    ("a274" . "$B!y(B")
    ("a275" . "$B!y(B")
    ("a276" . "$B!y(B")
    ("a277" . "$B!y(B")
    ("a278" . "$B!y(B")
    ("a279" . "$B!y(B")
    ("a27a" . "<sup>&#x259;</sup>")	; $B%7%e%o!<(B
    ("a321" . "<a href=\"./?search=&match=&dictionary=NEW_EJJE&block=00078138&offset=1038&frommenu=true\"><strong>[$BL>(B]</strong></a>")
    ("a322" . "<a href=\"./?search=&match=&dictionary=NEW_EJJE&block=00078138&offset=1038&frommenu=true\"><strong>[$BBe(B]</strong></a>")
    ("a323" . "<a href=\"./?search=&match=&dictionary=NEW_EJJE&block=00078138&offset=1038&frommenu=true\"><strong>[$B7A(B]</strong></a>")
    ("a324" . "<a href=\"./?search=&match=&dictionary=NEW_EJJE&block=00078138&offset=1038&frommenu=true\"><strong>[$BF0(B]</strong></a>")
    ("a325" . "<a href=\"./?search=&match=&dictionary=NEW_EJJE&block=00078138&offset=1038&frommenu=true\"><strong>[$BI{(B]</strong></a>")
    ("a326" . "<a href=\"./?search=&match=&dictionary=NEW_EJJE&block=00078138&offset=1038&frommenu=true\"><strong>[$B@\(B]</strong></a>")
    ("a327" . "<a href=\"./?search=&match=&dictionary=NEW_EJJE&block=00078138&offset=1038&frommenu=true\"><strong>[$BA0(B]</strong></a>")
    ("a328" . "<a href=\"./?search=&match=&dictionary=NEW_EJJE&block=00078138&offset=1038&frommenu=true\"><strong>[$B4'(B]</strong></a>")
    ("a329" . "<a href=\"./?search=&match=&dictionary=NEW_EJJE&block=00078138&offset=1038&frommenu=true\"><strong>[$B4V(B]</strong></a>")
    ("a32a" . "<a href=\"./?search=&match=&dictionary=NEW_EJJE&block=00078138&offset=1038&frommenu=true\"><strong>[$B=u(B</strong></a>")
    ("a32b" . "<a href=\"./?search=&match=&dictionary=NEW_EJJE&block=00078138&offset=1038&frommenu=true\"><strong>$BF0(B]</strong></a>")
    ("a32c" . "<a href=\"./?search=&match=&dictionary=NEW_EJJE&block=00078138&offset=1038&frommenu=true\"><strong>[$B@\(B</strong></a>")
    ("a32d" . "<a href=\"./?search=&match=&dictionary=NEW_EJJE&block=00078138&offset=1038&frommenu=true\"><strong>$BF,(B]</strong></a>")
    ("a32e" . "<a href=\"./?search=&match=&dictionary=NEW_EJJE&block=00078138&offset=1038&frommenu=true\"><strong>$BHx(B]</strong></a>")
    ("a32f" . "<a href=\"./?search=&match=&dictionary=NEW_EJJE&block=00078142&offset=1398&frommenu=true\"><strong>[U]</strong></a>")
    ("a330" . "<a href=\"./?search=&match=&dictionary=NEW_EJJE&block=00078142&offset=1398&frommenu=true\"><strong>[C]</strong></a>")
    ("a331" . "<a href=\"?search=&match=&dictionary=NEW_EJJE&block=00078138&offset=1464&frommenu=true\">($BC1(B)</a>")
    ("a332" . "<a href=\"?search=&match=&dictionary=NEW_EJJE&block=00078138&offset=1464&frommenu=true\">($BJ#(B)</a>")
    ("a333" . "<a href=\"./?search=&match=&dictionary=NEW_EJJE&block=00078142&offset=0478&frommenu=true\"><strong>[A]</strong></a>")
    ("a334" . "<a href=\"./?search=&match=&dictionary=NEW_EJJE&block=00078142&offset=0478&frommenu=true\"><strong>[P]</strong></a>")
    ("a335" . "<a href=\"./?search=&match=&dictionary=NEW_EJJE&block=00078138&offset=1038&frommenu=true\"><strong>($B<+(B)</strong></a>")
    ("a336" . "<a href=\"./?search=&match=&dictionary=NEW_EJJE&block=00078138&offset=1038&frommenu=true\"><strong>($BB>(B)</strong></a>")
    ("a337" . "<a href=\"./?search=&match=&dictionary=NEW_EJJE&block=00078148&offset=1848&frommenu=true\"><strong>[$B@.(B</strong></a>")
    ("a338" . "<a href=\"./?search=&match=&dictionary=NEW_EJJE&block=00078148&offset=1848&frommenu=true\"><strong>$B6g(B]</strong></a>")
    ("a339" . "$B"v(B")
    ("a33a" . "$BMQNc(B")
    ("a33b" . "$B!y(B")
    ("a33c" . "$BIJ;l0lMw(B")
    ("a33d" . "||")
    ("a33e" . "|| ")
    ("a33f" . "$B"M(B")
    ("a340" . "&#x334;&#x301;")		; ~'
    ("a341" . "&#x334;&#x300;")		; ~`
    ("a342" . "$B!y(B")
    ("a343" . "&#x2935;")		; $B<P$a2<8~$-Lp0u(B
    ("a344" . "&#x2934;")		; $B<P$a>e8~$-Lp0u(B
    ("a345" . "$B!y(B")
    ("a346" . "$B!y(B")
    ("a347" . "$B!y(B")
    ("a348" . "$B!y(B")
    ("a349" . "$B!y(B")
    ("a34a" . "$B!y(B")
    ("a34b" . "$B!y(B")
    ("a34c" . "$B!y(B")
    ("a34d" . "&#x2026;&#x301;")	; $B!D(B'
    ("a34e" . "$B!=(B")
    ("a34f" . "$B"N(B")

    ;; computer
    ("b125" . "$B!=(B")
    ("b128" . "[$BL>(B]")
    ("b12b" . "[$BF0(B]")
    )
  "excite$B1QOB<-E5$NH/2;5-9f$H%U%)%s%H$NJQ49%F!<%V%k!#(B
Fix me!"
  ;; http://yue.sakura.ne.jp/melody/ware/iso88591.html
  ;; http://yue.sakura.ne.jp/melody/ware/all-code-list.html
  ;; http://www.geocities.jp/mura_yosi/js/
  ;; http://www.fiberbit.net/user/hobbit-t/html/uniipad.html
  ;; http://ja.wikipedia.org/wiki/$B9q:]2;@<5-9f$NJ8;z0lMw(B
  ;; http://ja.wikipedia.org/wiki/Unicode#.E4.B8.80.E8.A6.A7
  )

(defvar dic-lookup-w3m-filter-excite-jj-symbol-alist
  '(
    ("GE040" . "&#x3280;")		; $B4]0l(B
    ("GE041" . "&#x3281;")		; $B4]Fs(B
    ("G6971" . "&#x2776;")		; $B4](B1
    ("G6972" . "&#x2777;")		; $B4](B2
    ("G6973" . "&#x2778;")		; $B4](B3
    ("G6974" . "&#x2779;")		; $B4](B4
    ("G6975" . "&#x277A;")		; $B4](B5
    ("G6976" . "&#x277B;")		; $B4](B6
    ("G6977" . "&#x277C;")		; $B4](B7
    ("G6978" . "&#x277D;")		; $B4](B8
    ("G6979" . "&#x277E;")		; $B4](B9
    )
  "excite$B9q8l<-E5$NH/2;5-9f$H%U%)%s%H$NJQ49%F!<%V%k!#(B")

(defvar dic-lookup-w3m-filter-excite-cj-symbol-alist
  '(
    ("shisei_1" . "&#x304;")		; -
    ("shisei_2" . "&#x301;")		; /
    ("shisei_3" . "&#x30C;")		; v
    ("shisei_4" . "&#x300;")		; \
    ("tanyou_fuka" . "&#x2297;")	; otimes
    ("bunri" . "&#x2666;")		; diams
    ("yakugo" . "&#x25BA;")		; $B1&8~$-9u;03Q(B
    ("youyaku" . "&#x2666;")		; $B9u$R$77A(B
    ("yourei" . "($BMQNc(B) ")
    )
  "excite$BCfF|$NH/2;5-9f$H%U%)%s%H$NJQ49%F!<%V%k!#(B")

(defvar dic-lookup-w3m-filter-yahoo-ej1-symbol-alist
  '(
    ("AC0" . "&#x0C0;")		      ; A`
    ("AC1" . "&#x0C1;")		      ; A'
    ("AC4" . "&#x1CD;")		      ; Av
    ("AC8" . "&#x0C8;")		      ; E`
    ("AC9" . "&#x0C9;")		      ; E'
    ("ACD" . "&#x0CD;")		      ; I'
    ("ACE" . "&#x0CE;")		      ; I^
    ("AD2" . "&#x0D2;")		      ; O`
    ("AD3" . "&#x0D3;")		      ; O'
    ("AD4" . "&#x0D4;")		      ; O^
    ("AD6" . "&#x14E;")		      ; Ov
    ("AD9" . "&#x0D9;")		      ; U`
    ("ADA" . "&#x0DA;")		      ; U'
    ("ADC" . "&#x0DC;")		      ; U..
    ("AE0" . "&#x0E0;")		      ; a`
    ("AE1" . "&#x0E1;")		      ; a'
    ("AE8" . "&#x0E8;")		      ; e`
    ("AE9" . "&#x0E9;")		      ; e'
    ("AEC" . "&#x0EC;")		      ; i`
    ("AED" . "&#x0ED;")		      ; i'
    ("AF0" . "&#x0F0;")		      ; $B%(%:(B
    ("AF2" . "&#x0F2;")		      ; o`
    ("AF3" . "&#x0F3;")		      ; o'
    ("AF9" . "&#x0F9;")		      ; u`
    ("AFA" . "&#x0FA;")		      ; u'
    ;;("AFD" . "y&#x301;")      ; y'
    ("AFD" . "&#x0FD;")			; y'
    ("C98" . "&#x283;")			; $B%(%C%7%e(B
    ("D24" . "&#x1CE;")			; av
    ("D26" . "&#x101;")			; a-
    ("D2A" . "&#x103;")			; au
    ("D2D" . "&#x105;")			; a,
    ("D30" . "&#x251;")			; $BI.5-BN$N(BA
    ("D31" . "&#x251;&#x300;")		; $BI.5-BN$N(BA`
    ("D32" . "&#x251;&#x301;")		; $BI.5-BN$N(BA'
    ("D40" . "&#x0E6;")			; $B%"%C%7%e(B; $B>.J8;z(BA$B$H(BE$B$N9g;z(B
    ("D41" . "&#x0E6;&#x300;")		; $B%"%C%7%e(B; $B>.J8;z(BA$B$H(BE$B$N9g;z(B`
    ;;("D42" . "&#x0E6;&#x301;")	; $B%"%C%7%e(B; $B>.J8;z(BA$B$H(BE$B$N9g;z(B'
    ("D42" . "&#x1FD;")			; $B%"%C%7%e(B; $B>.J8;z(BA$B$H(BE$B$N9g;z(B'
    ("D5D" . "&#x254;&#x301;")		; $B3+$$$?(BO'
    ("D5E" . "&#x254;&#x300;")		; $B3+$$$?(BO`
    ("D6D" . "&#x254;")			; $B3+$$$?(BO
    ("D84" . "&#x11B;")			; ev
    ("D86" . "&#x113;")			; e-
    ("D87" . "&#x0E8;")			; e`
    ("D90" . "&#x259;")			; $B%7%e%o!<(B
    ("D91" . "&#x259;&#x300;")		; $B%7%e%o!<(B`
    ("D92" . "&#x259;&#x301;")		; $B%7%e%o!<(B'
    ("E5B" . "&#x14B;")  		; $B%(%s%0(B
    ("F2A" . "&#x28C;&#x301;")		; $B5U$5$N(BV'
    ("F2B" . "&#x28C;&#x300;")		; $B5U$5$N(BV`
    ("F2C" . "&#x28C;")			; $B5U$5$N(BV
    ("F51" . "y&#x300;")		; y`
    ("FB1" . "&#x25B;&#x300;")		; $B%(%W%7%m%s(B`
    ("FB2" . "&#x25B;&#x301;")		; $B%(%W%7%m%s(B'
    ("FBE" . " &#x2013;&#x301; ")	; -'
    ("FBF" . " &#x2013;&#x300; ")	; -`
    ("FC3" . "&#x292;")  		; $B%(%C%8%e(B; $BHxIU$-$N(BZ
    ("G41" . "&#x261;")			; $B3+$$$?Hx$N(BG
    ("_817C" . "&#x2D0;")		; $BD92;Id(B
    ("Z8616" . "$B!Z(B1$B![(B")
    ("Z6AFA" . "$B!Z(B2$B![(B")
    ("Z6B50" . "$B!Z(B1$B![(B")
    ("Z6B59" . "$B!Z(B2$B![(B")
    ("ar_next" . "&#x25BA;")		; $B1&8~$-9u;03Q(B
    ("T2460" . "&#x2460;")		; $B4](B1
    ("T2461" . "&#x2461;")		; $B4](B2
    ("T2462" . "&#x2462;")		; $B4](B3
    ("T2463" . "&#x2463;")		; $B4](B4
    ("T2464" . "&#x2464;")		; $B4](B5
    ("T2465" . "&#x2465;")		; $B4](B6
    ("T2466" . "&#x2466;")		; $B4](B7
    ("Z6B83" . "&#x2467;")		; $B4](B8
    ("Z6B8D" . "&#x2468;")		; $B4](B9
    ("Z6B98" . "&#x2469;")		; $B4](B10
    )
  "yahoo$B%W%m%0%l%C%7%V1QOBCf<-E5$NH/2;5-9f$H%U%)%s%H$NJQ49%F!<%V%k!#(B
Fix me!"
  ;; http://yue.sakura.ne.jp/melody/ware/iso88591.html
  ;; http://yue.sakura.ne.jp/melody/ware/all-code-list.html
  ;; http://www.geocities.jp/mura_yosi/js/
  ;; http://www.fiberbit.net/user/hobbit-t/html/uniipad.html
  ;; http://ja.wikipedia.org/wiki/$B9q:]2;@<5-9f$NJ8;z0lMw(B
  ;; http://ja.wikipedia.org/wiki/Unicode#.E4.B8.80.E8.A6.A7
  )

(defvar dic-lookup-w3m-filter-yahoo-ej2-symbol-alist
  '(
    ("g10d4" . "&#x2020;")		; $B%@%,!<(B
    ("g111a" . "$B"c(B")
    ("g111b" . "$B"d(B")
    ("g111c" . "&#x2021;")		; $B%@%V%k%@%,!<(B
    ("g111d" . "*")
    ("g111e" . "($BF1(B)")
    ("g1128" . "($B0\(B)")
    ("g1129" . "($B<+(B)")
    ("g112a" . "($BB>(B)")
    ("g112b" . "($BC1(B)")
    ("g112d" . "($BJ#(B)")
    ("g112e" . "[C/]")
    ("g112f" . "[C]")
    ("g1130" . "[U]")
    ("g1131" . "[UC]")
    ("g1132" . "[aU]")
    ("g1133" . "[e]")
    ("g1134" . "[m]")
    ("g1135" . "[$B2a(B]")
    ("g1136" . "[$B2aJ,(B]")
    ("g1137" . "[$B4V(B]")
    ("g1138" . "[$B7A(B]")
    ("g1139" . "[$B=u(B]")
    ("g113b" . "[$B@\(B]")
    ("g113e" . "[$BA0(B]")
    ("g113f" . "[$BBe(B]")
    ("g1142" . "[$BF0(B]")
    ("g1144" . "[$BI{(B]")
    ("g1145" . "[$BL>(B]")
    ("g1147" . "&#x2194;")		; $B"N(B
    ("g1198" . "&#x2021;&#x2021;")	; $B%@%V%k%@%,!<(B x2
    ("g119a" . "&#x25B9;")		; $B1&8~$-GrH4$-;03Q(B
    ("g11b9" . "$B!L(B")
    ("g11ba" . "$B!M(B")
    ("g11da" . "&#x2013; ")		; -
    ("g11db" . "&#x2013;&#x301; ")	; -'
    ("g11dc" . "&#x2013;&#x300; ")	; -`
    ("g11f1" . "$B!=(B")
    ("g11f5" . "&#x251;")		; $BI.5-BN$N(BA
    ("g11fd" . "&#x251;&#x301;")	; $BI.5-BN$N(BA'
    ("g11fe" . "&#x251;&#x300;")	; $BI.5-BN$N(BA`
    ("g120f" . "&#x261;")		; $B3+$$$?Hx$N(BG
    ("g122b" . "&#x27e;")		; $BD`?K$N(BR
    ("g1294" . "&#x254;")		; $B3+$$$?(BO
    ("g1295" . "&#x28C;")		; $B5U$5$N(BV
    ("g1296" . "&#x0F0;")  		; $B%(%:(B
    ("g1298" . "&#x3B8;")  		; $B%F!<%?(B($B%7!<%?(B)
    ("g1297" . "&#x14B;")  		; $B%(%s%0(B
    ("g129a" . "&#x292;")  		; $B%(%C%8%e(B; $BHxIU$-$N(BZ
    ("g129b" . "&#x259;")  		; $B%7%e%o!<(B
    ("g129c" . "&#x283;")  		; $B%(%C%7%e(B
    ("g129e" . "&#x1FD;")		; $B%"%C%7%e(B; $B>.J8;z(BA$B$H(BE$B$N9g;z(B'
    ("g129f" . "&#x0E6;&#x300;")	; $B%"%C%7%e(B; $B>.J8;z(BA$B$H(BE$B$N9g;z(B`
    ("g12a0" . "&#x254;&#x301;")	; $B3+$$$?(BO'
    ("g12a1" . "&#x254;&#x300;")	; $B3+$$$?(BO`
    ("g12a2" . "&#x28C;&#x301;")	; $B5U$5$N(BV'
    ("g12a3" . "&#x28C;&#x300;")	; $B5U$5$N(BV`
    ("g12a4" . "&#x259;&#x301;")	; $B%7%e%o!<(B'
    ("g12a5" . "&#x259;&#x300;")	; $B%7%e%o!<(B`
    ("g12a6" . "&#x25B;")		; $B%(%W%7%m%s(B
    ("g12a7" . "&#x0E6;")		; $B%"%C%7%e(B; $B>.J8;z(BA$B$H(BE$B$N9g;z(B
    ("g12c9" . "&#x2020;")		; $B%@%,!<(B
    ("g12cf" . "&#x2D0;")		; $BD92;Id(B
    ("agrave" . "&#x0E0;")		; a`
    ("aacute" . "&#x0E1;")		; a'
    ("egrave" . "&#x0E8;")		; e`
    ("eacute" . "&#x0E9;")		; e'
    ("igrave" . "&#x0EC;")		; i`
    ("iacute" . "&#x0ED;")  		; i'
    ("ograve" . "&#x0F2;")  		; o`
    ("oacute" . "&#x0F3;")  		; o'
    ("ugrave" . "&#x0F9;")  		; u`
    ("uacute" . "&#x0FA;")  		; u'
    ("Agrave" . "&#x0C0;")		; A`
    ("Aacute" . "&#x0C1;")		; A'
    ("Egrave" . "&#x0C8;")		; E`
    ("Eacute" . "&#x0C9;")		; E'
    ("Igrave" . "&#x0CC;")		; I`
    ("Iacute" . "&#x0CD;")		; I'
    ("Ograve" . "&#x0D2;")		; O`
    ("Oacute" . "&#x0D3;")		; O'
    ("Ugrave" . "&#x0D9;")		; U`
    ("Uacute" . "&#x0DA;")		; U'
    ("audio" . "$B"v(B")
    )
  "yahoo$B?7%0%m!<%P%k1QOB<-E5$NH/2;5-9f$H%U%)%s%H$NJQ49%F!<%V%k!#(B
Fix me!")

(defvar dic-lookup-w3m-filter-ocn-ej-symbol-alist
  '(
    ;;("fukugou" . "$B"M(B")
    ("fukugou" . "&#x25BA;")		; $B1&8~$-9u;03Q(B
    ;;("seiku" . "$B"*(B")
    ("seiku" . "&#x25B9;")		; $B1&8~$-GrH4$-;03Q(B
    ;;("hasei" . "[$BGI(B]")
    ("hasei" . "&#x2666;")
    ("mp3" . "[MP3]")
    ("wav" . "[WAV]")
    ("voice" . "$B"c"v(B")
    ("ej_btn" . "[$B1QOB(B]")
    ("je_btn" . "[$BOB1Q(B]")
    ("jn_btn" . "[$B9q8l(B]")
    ("nw" . "<strong>[$B?78l(B]</strong>")
    ("i_01s" . "$B!&(B")
    ("clear" . "$B!=(B")
    ("e1000" . "&#x0E6;")		; $B%"%C%7%e(B; $B>.J8;z(BA$B$H(BE$B$N9g;z(B
    ("e1001" . "b")
    ("e1002" . "s")
    ("e1003" . "t")
    ("e1004" . "&#x259;&#x301;")	; $B%7%e%o!<(B'
    ("e1005" . "&#x2D0;")		; $BD92;Id(B
    ("e1006" . "<em>r</em>")
    ("e1007" . "d")
    ("e1008" . "&#x292;")  		; $B%(%C%8%e(B; $BHxIU$-$N(BZ
    ("e1009" . "&#x259;")  		; $B%7%e%o!<(B
    ("e100a" . "n")
    ("e100b" . "/")
    ("e100c" . "-")
    ("e100d" . "a")
    ("e100e" . "c")
    ("e100f" . "e")
    ("e1010" . "f")
    ("e1011" . "j")
    ("e1012" . "h")
    ("e1013" . "i")
    ("e1014" . "g")
    ("e1015" . "k")
    ("e1016" . "l")
    ("e1017" . "m")
    ("e1018" . "o")
    ("e1019" . "p")
    ("e101a" . "q")
    ("e101b" . "r")
    ("e101c" . "u")
    ("e101d" . "v")
    ("e101e" . "w")
    ("e101f" . "x")
    ("e1020" . "y")
    ("e1021" . "z")
    ("e1022" . "&#x1FD;")		; $B%"%C%7%e(B; $B>.J8;z(BA$B$H(BE$B$N9g;z(B'
    ("e1023" . "&#x0E6;&#x300;")	; $B%"%C%7%e(B; $B>.J8;z(BA$B$H(BE$B$N9g;z(B`
    ("e1024" . "&#x0E6;&#x303;")	; $B%"%C%7%e(B; $B>.J8;z(BA$B$H(BE$B$N9g;z(B~
    ("e1025" . "&#x0E6;&#x303;&#x301;") ; $B%"%C%7%e(B; $B>.J8;z(BA$B$H(BE$B$N9g;z(B~'
    ;;("e1026" . "&#x25A;")		; $B1&nlIU$-$N%7%e%o!<(B
    ;;("e1026" . "&#x259;")		; $B%7%e%o!<(B
    ("e1026" . "<em>&#x259;</em>")	; $B%7%e%o!<(B
    ("e1027" . "&#x259;&#x300;")	; $B%7%e%o!<(B`
    ("e1028" . "&#x251;")		; $BI.5-BN$N(BA
    ("e1029" . "&#x251;&#x301;")	; $BI.5-BN$N(BA'
    ("e102a" . "&#x251;&#x300;")	; $BI.5-BN$N(BA`
    ("e102b" . "&#x251;&#x303;")	; $BI.5-BN$N(BA~
    ("e102c" . "&#x251;&#x303;&#x301;")	; $BI.5-BN$N(BA~'
    ("e102d" . "&#x251;&#x303;&#x300;")	; $BI.5-BN$N(BA~`
    ("e102e" . "&#x25B;")		; $B%(%W%7%m%s(B
    ("e102f" . "&#x25B;&#x301;")	; $B%(%W%7%m%s(B'
    ("e1030" . "&#x25B;&#x300;")	; $B%(%W%7%m%s(B`
    ("e1031" . "&#x25B;&#x303;")	; $B%(%W%7%m%s(B~
    ("e1032" . "&#x25B;&#x303;&#x301;")	; $B%(%W%7%m%s(B~'
    ("e1033" . "&#x25B;&#x303;&#x300;")	; $B%(%W%7%m%s(B`
    ("e1034" . "&#x1E3E;")		; M'
    ;;("e1034" . "M&#x301;")		; M'
    ("e1035" . "&#x0ED;")		; I'
    ("e1036" . "&#x14B;")  		; $B%(%s%0(B
    ("e1037" . "&#x254;")		; $B3+$$$?(BO
    ("e1038" . "&#x254;&#x301;")	; $B3+$$$?(BO'
    ("e1039" . "&#x254;&#x300;")	; $B3+$$$?(BO`
    ("e103a" . "&#x254;&#x303;")	; $B3+$$$?(BO~
    ("e103b" . "&#x254;&#x303;&#x301;")	; $B3+$$$?(BO~'
    ("e103c" . "&#x254;&#x303;&#x300;")	; $B3+$$$?(BO~`
    ("e103d" . "&#x0F0;")  		; $B%(%:(B
    ("e103e" . "T&#x301;")		; T'
    ("e103f" . "&#x0DA;")		; U'
    ("e1040" . "V&#x301;")		; V'
    ("e1041" . "&#x0DD;")		; Y'
    ("e1042" . "&#x0294;")		; ?
    ("e1043" . "&#x28C;")		; $B5U$5$N(BV
    ("e1044" . "&#x28C;&#x301;")	; $B5U$5$N(BV'
    ("e1045" . "&#x28C;&#x303;")	; $B5U$5$N(BV`
    ("e1046" . "&#x28C;&#x303;")	; $B5U$5$N(BV~
    ("e1047" . "&#x0E1;")		; a'
    ("e1048" . "&#x0E0;")  		; a`
    ("e1049" . "&#x0E2;")		; a^
    ("e104a" . "&#x0E3;")		; a~
    ("e104b" . "&#x0E3;&#x301;")	; a~'
    ("e104c" . "&#x0E3;&#x300;")	; a~`
    ("e104d" . "&#x0E5;")		; a$B!#(B
    ("e104e" . "&#x0E4;")		; a..
    ("e104f" . "&#x101;")		; a-
    ("e1050" . "&#x0E7;")		; $B%;%G%#!<%fIU$-$N(BC
    ;;("e1051" . "&#x297;&#x0B8;")	; $B=DD9$N(BC $B%;%G%#!<%f(B
    ("e1051" . "<em>&#x0E7;</em>")	; $B=DD9$N(BC $B%;%G%#!<%f(B
    ("e1052" . "&#x0F0;")  		; $B%(%:(B
    ("e1053" . "&#x0E9;")		; e'
    ("e1054" . "&#x0E8;")		; e`
    ("e1055" . "&#x0EA;")		; e^
    ("e1056" . "&#x0EB;")		; e..
    ("e1057" . "&#x113;")		; e-
    ("e1058" . "<em>&#x261;</em>")	; g
    ;;e1059$B$J$7(B
    ("e105a" . "&#x0CD;")		; I'
    ("e105b" . "&#x0CC;")		; I`
    ("e105c" . "&#x0CE;")		; I^
    ("e105d" . "&#x0CF;")		; I..
    ("e105e" . "<em>j</em>")
    ("e105f" . "m&#x325;")		; m$B2<4](B
    ("e1060" . "m&#x325;&#x301;")	; m$B2<4](B'
    ("e1061" . "&#x0F1;")		; n~
    ("e1062" . "&#x0F3;")  		; o'
    ("e1063" . "&#x0F2;")  		; o`
    ("e1064" . "&#x0F4;")		; o^
    ("e1065" . "&#x0F6;")		; o..
    ("e1066" . "r&#x302;")		; r^
    ("e1067" . "&#x3B8;")  		; $B%F!<%?(B($B%7!<%?(B)
    ("e1068" . "&#x0FA;")		; u'
    ("e1069" . "&#x0F9;")		; u`
    ("e106a" . "&#x0FB;")		; u^
    ("e106b" . "&#x0FC;")		; u..
    ("e106c" . "&#x0FD;")		; y'
    ("e106d" . "y&#x300;")		; y`
    ("e106e" . "&#x334;&#x301;")	; ~'
    ("e106f" . "&#x334;&#x300;")	; ~`
    ("e1070" . "&#x2013;")		; -
    ("e1071" . "&#x2013;&#x301;")	; -'
    ("e1072" . "&#x2013;&#x300;")	; -`
    ("e1073" . "$B!L(B")
    ("e1074" . "$B!M(B")
    ("e1075" . "$B6/(B")
    ("e1076" . "<em>Sp.</em>")
    ("e1077" . "<em>Flem.</em>")
    ("e1078" . "<em>Port.</em>")
    ("e1079" . "<em>It.</em>")
    ("e107a" . "<em>F.</em>")
    ("e107b" . "<em>G.</em>")
    ("e107c" . "&#x265;")		; $B5U$5$N(BH
    ("e107d" . "&#x272;")		; ($B:8B&$K(B)$B:88~$-HxIU$-$N(BN
    ("e107e" . "&#x153;")		; $B>.J8;z$N(BO$B$H(BE$B$N9g;z(B
    ("e107f" . "&#x0F8;")		; o/
    ("e1080" . "&#x153;&#x303;")	; $B>.J8;z$N(BO$B$H(BE$B$N9g;z(B~
    ("e1081" . "&#x0F8;&#x301;")	; o/'
    ("e1082" . "&#x1D2;")		; ov
    ("e1083" . "&#x1D0;")		; iv
    ("e1084" . "&#x1CE;")		; av
    ("e1085" . "n&#x304;")		; n-
    ("e1086" . "&#x0C5;")		; A$B!#(B
    ;;("e1087" . "&#x276;")		; $B>.7?BgJ8;z(BO$B$H(BE$B$N9g;z(B
    ("e1087" . "&#x152;")		; $B>.7?BgJ8;z(BO$B$H(BE$B$N9g;z(B
    ("e1088" . "&#x163;")		; t,
    ("e1089" . "<em>b</em>")
    ("e108a" . "<em>d</em>")
    ("e108b" . "<em>f</em>")
    ("e108c" . "<em>h</em>")
    ("e108d" . "<em>i</em>")
    ("e108e" . "<em>k</em>")
    ("e108f" . "<em>p</em>")
    ("e1090" . "<em>t</em>")
    ("e1091" . "<em>u</em>")
    )
  "OCN EXCEED$B1QOB<-E5$NH/2;5-9f$H%U%)%s%H$NJQ49%F!<%V%k!#(B
Fix me!")

(defvar dic-lookup-w3m-filter-infoseek-ej-symbol-alist
  '(
    ("GRA0001" . "&#x0E6;")		; $B%"%C%7%e(B; $B>.J8;z(BA$B$H(BE$B$N9g;z(B
    ("GRA0002" . "&#x1FD;")		; $B%"%C%7%e(B; $B>.J8;z(BA$B$H(BE$B$N9g;z(B'
    ("GRA0003" . "&#x0E6;&#x300;")	; $B%"%C%7%e(B; $B>.J8;z(BA$B$H(BE$B$N9g;z(B`
    ("GRA0004" . "&#x259;")  		; $B%7%e%o!<(B
    ("GRA0005" . "&#x259;&#x301;")	; $B%7%e%o!<(B'
    ("GRA0006" . "&#x259;&#x300;")	; $B%7%e%o!<(B`
    ("GRA0007" . "&#x153;")		; $B>.J8;z$N(BO$B$H(BE$B$N9g;z(B
    ("GRA0008" . "&#x153;&#x301;")	; $B>.J8;z$N(BO$B$H(BE$B$N9g;z(B'
    ("GRA0009" . "&#x153;&#x300;")	; $B>.J8;z$N(BO$B$H(BE$B$N9g;z(B`
    ("GRA0010" . "&#x153;&#x303;")	; $B>.J8;z$N(BO$B$H(BE$B$N9g;z(B~
    ("GRA0011" . "&#x3B2;")		; $B%Y!<%?(B
    ("GRA0012" . "&#x251;")		; $BI.5-BN$N(BA
    ("GRA0013" . "&#x251;&#x301;")	; $BI.5-BN$N(BA'
    ("GRA0014" . "&#x251;&#x300;")	; $BI.5-BN$N(BA`
    ("GRA0015" . "&#x251;&#x303;")	; $BI.5-BN$N(BA~
    ("GRA0016" . "&#x25B;")		; $B%(%W%7%m%s(B
    ("GRA0017" . "&#x25B;&#x303;")	; $B%(%W%7%m%s(B~
    ("GRA0018" . "&#x265;")		; $B5U$5$N(BH
    ("GRA0019" . "&#x14B;")  		; $B%(%s%0(B
    ("GRA0021" . "&#x254;")		; $B3+$$$?(BO
    ("GRA0022" . "&#x254;&#x301;")	; $B3+$$$?(BO'
    ("GRA0023" . "&#x254;&#x300;")	; $B3+$$$?(BO`
    ("GRA0024" . "&#x254;&#x303;")	; $B3+$$$?(BO~
    ("GRA0025" . "&#x283;")  		; $B%(%C%7%e(B
    ("GRA0026" . "&#x28C;")		; $B5U$5$N(BV
    ("GRA0027" . "&#x28C;&#x301;")	; $B5U$5$N(BV'
    ("GRA0028" . "&#x28C;&#x300;")	; $B5U$5$N(BV`
    ("GRA0029" . "&#x0E1;")		; a'
    ("GRA0030" . "&#x0E0;")		; a`
    ("GRA0031" . "&#x0E3;")		; a~
    ("GRA0032" . "&#x0E7;")		; $B%;%G%#!<%fIU$-$N(BC
    ("GRA0033" . "&#x0F0;")  		; $B%(%:(B
    ("GRA0034" . "&#x0E9;")		; e'
    ("GRA0035" . "&#x0E8;")		; e`
    ("GRA0036" . "e&#x303;")		; e~
    ("GRA0037" . "&#x261;")		; $B3+$$$?Hx$N(BG
    ("GRA0038" . "&#x292;")  		; $B%(%C%8%e(B; $BHxIU$-$N(BZ
    ("GRA0039" . "&#x0ED;")  		; i'
    ("GRA0040" . "&#x0EC;")  		; i`
    ("GRA0041" . "&#x142;")		; l/
    ("GRA0042" . "&#x0F3;")  		; o'
    ("GRA0043" . "&#x0F2;")		; o`
    ("GRA0044" . "&#x0F5;")		; o~
    ("GRA0045" . "&#x0F8;")		; $B<P@~IU$-$N(BO
    ("GRA0046" . "&#x01FF;")		; $B<P@~IU$-$N(BO'
    ("GRA0047" . "&#x3B8;")  		; $B%F!<%?(B($B%7!<%?(B)
    ("GRA0048" . "&#x0FA;")		; u'
    ("GRA0049" . "&#x0F9;")		; u`
    ("GRA0050" . "&#x0FD;")		; y'
    ("GRA0051" . "&#x2013; ")		; -
    ("GRA0052" . "&#x2013;&#x301; ")	; -'
    ("GRA0053" . "&#x2013;&#x300; ")	; -`
    ("GRA0054" . "&#x0294;")		; ?
    ("ic_eiwa" . "<strong>[E]</strong>")
    ("ic_waei" . "<strong>[J]</strong>")
    ("ic_kokugo" . "<strong>[$BBg(B]</strong>")
    ("icon02" ."[*]")
    ("icon_honyaku" . "[$BLu(B]")
    ("icon_kanji" . "[$B4A(B]")
    ("icon_all" . "[$BA4(B]")
    ("icon_eiwa" . "[EJ]")
    ("icon_waei" . "[JE]")
    ("icon_kokugo" . "[$BBg(B]")
    ("icon_kana" . "[$B%+(B]")
    )
  "infoseek $B1QOB<-E5$NH/2;5-9f$H%U%)%s%H$NJQ49%F!<%V%k!#(B
Fix me!")

(defvar dic-lookup-w3m-filter-weblio-ej-symbol-alist
  `(
    ,@(mapcar
       '(lambda (elem)
	  (cons (concat "N16-" (upcase (car elem)) "_F-000000_B-FFFFFF")
		(cdr elem)))
       dic-lookup-w3m-filter-excite-ej-symbol-alist)

    ("W16-A343_F-000000_B-FFFFFF" . "&#x2198;") ; $B<P$a2<8~$-Lp0u(B
    ("W16-A344_F-000000_B-FFFFFF" . "&#x2197;") ; $B<P$a>e8~$-Lp0u(B
    ("W16-A34D_F-000000_B-FFFFFF" . " &#x2026;&#x301; ") ; $B!D(B'
    ("W16-A328_F-000000_B-FFFFFF" . "[$B4'(B]")

    ("iconEjjeWav" . "$B"v(B")
    ("lg_liscj" . "")
    ("lg_kejje" . "")
    ("lg_kejcy" . "")
    ("hand" . "&#x261E;")
    ("link_out" . "$B"N(B")
    ("icon_bulb" . "$B!&(B")
    ("bulb5" . "[*****]")
    ("bulb4" . "[****&nbsp;]")
    ("bulb3" . "[***&nbsp;&nbsp;]")
    ("bulb2" . "[**&nbsp;&nbsp;&nbsp;]")
    ("bulb1" . "[*&nbsp;&nbsp;&nbsp;&nbsp;]")
    ("bulb0" . "[&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;]")
    ("IconCircleGr" . "$B!}(B")
    ("IconArrGry" . "$B!&(B")
    ("iconArrGryR" . "$B"d(B")
    ("spacer" . "")
    ("subCategoryPlus" . "")
    ("iconCclBl" . "- ")
    )
  "weblio $B1QOB<-E5$NH/2;5-9f$H%U%)%s%H$NJQ49%F!<%V%k!#(B
Fix me!")

(defvar dic-lookup-w3m-filter-onlinedic-symbol-alist
  '(("title_1" . "")
    ("title_l1" . "")
    ("title_r1" . "")
    ("bg_1" . "")
    ("end_1" . "<hr>")
    ("arrow3" . "$B"*(B")
    ("spacer" . " ")
    ("lucky" . "")
    )
  "$BFX_j<-3$$N5-9f$H%U%)%s%H$NJQ49%F!<%V%k!#(B")

(defvar dic-lookup-w3m-filter-hjenglish-symbol-alist
  '(("icon_star" . "* ")
    ("spacer" . "")
    ("btn_myword_add" . "(+)")
    ("btn_newword" . "<strong>[new]</strong>")
    ("btn_noresult" . "<strong>[??]</strong>")
    )
  "hjenglish$B$N5-9f$H%U%)%s%H$NJQ49%F!<%V%k!#(B")

(defvar dic-lookup-w3m-filter-kitajiro-pinyin-alist
  '(("ang1" . "&#257;ng") ("ang2" . "&#225;ng")
    ("ang3" . "&#462;ng") ("ang4" . "&#224;ng")
    ("eng1" . "&#275;ng") ("eng2" . "&#233;ng")
    ("eng3" . "&#283;ng") ("eng4" . "&#232;ng")
    ("ing1" . "&#299;ng") ("ing2" . "&#237;ng")
    ("ing3" . "&#464;ng") ("ing4" . "&#236;ng")
    ("ong1" . "&#333;ng") ("ong2" . "&#243;ng")
    ("ong3" . "&#466;ng") ("ong4" . "&#242;ng")
    ("ai1" . "&#257;i") ("ai2" . "&#225;i")
    ("ai3" . "&#462;i") ("ai4" . "&#224;i")
    ("an1" . "&#257;n") ("an2" . "&#225;n")
    ("an3" . "&#462;n") ("an4" . "&#224;n")
    ("ao1" . "&#257;o") ("ao2" . "&#225;o")
    ("ao3" . "&#462;o") ("ao4" . "&#224;o")
    ("ei1" . "&#275;i") ("ei2" . "&#233;i")
    ("ei3" . "&#283;i") ("ei4" . "&#232;i")
    ("en1" . "&#275;n") ("en2" . "&#233;n")
    ("en3" . "&#283;n") ("en4" . "&#232;n")
    ("er1" . "&#275;r") ("er2" . "&#233;r")
    ("er3" . "&#283;r") ("er4" . "&#232;r")
    ("ie1" . "i&#275;") ("ie2" . "i&#233;")
    ("ie3" . "i&#283;") ("ie4" . "i&#232;")
    ("in1" . "&#299;n") ("in2" . "&#237;n")
    ("in3" . "&#464;n") ("in4" . "&#236;n")
    ("ng2" . "&#324;g") ("ng3" . "&#328;g") ("ng4" . "&#505;g")
    ("ou1" . "&#333;u") ("ou2" . "&#243;u")
    ("ou3" . "&#466;u") ("ou4" . "&#242;u")
    ("un1" . "&#363;n") ("un2" . "&#250;n")
    ("un3" . "&#468;n") ("un4" . "&#249;n")
    ("ve3" . "&#252;&#283;") ("ve4" . "&#252;&#232;")
    ("a1" . "&#257;") ("a2" . "&#225;") ("a3" . "&#462;") ("a4" . "&#224;")
    ("e1" . "&#275;") ("e2" . "&#233;") ("e3" . "&#283;") ("e4" . "&#232;")
    ("i1" . "&#299;") ("i2" . "&#237;") ("i3" . "&#464;") ("i4" . "&#236;")
    ("o1" . "&#333;") ("o2" . "&#243;") ("o3" . "&#466;") ("o4" . "&#242;")
    ("u1" . "&#363;") ("u2" . "&#250;") ("u3" . "&#468;") ("u4" . "&#249;")
    ("v1" . "&#470;") ("v2" . "&#472;") ("v3" . "&#474;") ("v4" . "&#476;"))
  "pinyin$BJQ49%F!<%V%k(B")

(defun dic-lookup-w3m-filter-conv-pinyin (url regexp)
  (goto-char (point-min))
  (while (re-search-forward regexp nil t)
    (save-excursion
      (save-restriction
	(narrow-to-region (match-beginning 0) (match-end 0))
	(goto-char (point-min))
	(while
	    (re-search-forward
	     "\\(ang\\|eng\\|ing\\|ong\\|ai\\|an\\|ao\\|ei\\|en\\|er\\|ie\\|in\\|ng\\|ou\\|un\\|ve\\|a\\|e\\|i\\|u\\|o\\|v\\)[1-4]"
	     nil t)
	  (replace-match
	   (assoc-default (match-string 0)
			  dic-lookup-w3m-filter-kitajiro-pinyin-alist)
	   t nil))))))

(defvar dic-lookup-w3m-translator-site-list
  '((ej
     (("tr-ej-url-ocn" . "ocn")
      ("tr-ej-url-livedoor" . "livedoor")
      ("tr-ej-url-nifty" . "nifty")
      ("tr-ej-url-sonet" . "sonet")
      ("tr-ej-url-yakushite.net" . "yakushite.net")
      ("tr-enja-url-google" . "google")))
    (jx
     (("tr-je-url-nifty" . "$B1Q(Bnifty")
      ("tr-je-url-ocn" . "$B1Q(Bocn")
      ("tr-je-url-livedoor" . "$B1Q(Blivedoor")
      ("tr-je-url-sonet" . "$B1Q(Bsonet")
      ("tr-je-url-yakushite.net" . "$B1Q(B-yakushite.net")
      ("tr-jaen-url-google" . "google")
      ("tr-jc-url-ocn" . "$BCf(Bocn")
      ("tr-jc-url-nifty" . "$BCf(Bnifty")
      ("tr-jk-url-ocn" . "$B4Z(Bocn")))
    (cj
     (("tr-cj-url-nifty" . "nifty")
      ("tr-cj-url-ocn" . "ocn")
      ("tr-cj-url-sonet" . "sonet")
      ("tr-cj-url-yakushite.net" . "yakushite.net")
      ("tr-zh-CNja-url-google" . "google")))
    (kj
     (("tr-kj-url-nifty" . "nifty")
      ("tr-kj-url-ocn" . "ocn")
      ("tr-kj-url-sonet" . "sonet")
      ("tr-koja-url-google" . "google"))))
    "*web$B%Z!<%8$rK]Lu$9$k(Btranslator$B$N%j%9%H!#(B
web$B%Z!<%8$KK]Lu%\%?%s$r$D$1$F!"3F(Btranslator$B$K%j%s%/$9$k!#(B
`dic-lookup-w3m-filter-translation-anchor'$B$G;HMQ!#(B")

(defun dic-lookup-w3m-filter-translation-anchor (url &optional regexp before)
  "web$B%Z!<%8$KK]Lu%\%?%s$r$D$1$k!#(B"
  (goto-char (point-min))
  ;; $B$$$$2C8:$J8@8l$NH=Dj!#(B Fix me!
  (cond
   ((or
     (not
      (save-excursion
	(re-search-forward "[^\000-\177]" nil t)))
     (save-excursion
       (re-search-forward
	"<html [^>]*lang=\"en\"\\|<meta [^>]*http-equiv=\"content-language\"[^>]*content=\"en\"\\|<meta [^>]*http-equiv=\"content-type\"[^>]*content=\"text/html; +charset=\\(iso-8859-1\\|us-ascii\\)\"" nil t)))
    (dic-lookup-w3m-filter-translation-anchor2
     url 'ej "$B1QF|K]Lu(B: " regexp before))
   ((save-excursion
      (re-search-forward "\\ch" nil t))
    (dic-lookup-w3m-filter-translation-anchor2
     url 'kj "$B4ZF|K]Lu(B: " regexp before))
   ((or
     (save-excursion
       (re-search-forward
	"<html [^>]*lang=\"zh-cn\"\\|<meta [^>]*http-equiv=\"content-language\"[^>]*content=\"zh-cn\"\\|<meta [^>]*http-equiv=\"content-type\"[^>]*content=\"text/html; +charset=gb2312\"" nil t))
     (save-excursion
       (re-search-forward "\\cc" nil t)))
    (dic-lookup-w3m-filter-translation-anchor2
     url 'cj "$BCfF|K]Lu(B: " regexp before))
   ((save-excursion
      (re-search-forward "[$B$"(B-$B$s(B]" nil t))
    (dic-lookup-w3m-filter-translation-anchor2
     url 'jx "$BF|(B*$BK]Lu(B: " regexp before))
   ))

(defun dic-lookup-w3m-filter-translation-anchor2
  (url category heading &optional regexp before)
  (w3m-filter-replace-regexp
   url
   (concat "\\(" (or regexp "<body[^>]*>") "\\)")
   (concat
    (unless before "\\1")
    "<div id=\"dic-lookup-w3m-translation-anchor\">"
    heading
    (mapconcat
     (lambda (s)
       (if (assoc (car s) w3m-search-engine-alist)
	   (format
	    "<a href=\"%s\">%s</a>"
	    (w3m-encode-specials-string
	     (format (nth 1 (assoc (car s) w3m-search-engine-alist))
		     (w3m-url-encode-string
		      url
		      (nth 2 (assoc (car s) w3m-search-engine-alist)))))
	    (w3m-encode-specials-string (cdr s)))
	 (concat (car s) "??")))
     (cadr (assoc category dic-lookup-w3m-translator-site-list))
     ", ")
    "</div><!-- /dic-lookup-w3m-translation-anchor -->"
    (if before "\\1")
    )))

;; http://dic.yahoo.co.jp/ $B%W%m%0%l%C%7%V1QOBCf<-E5(B |  $B?7%0%m!<%P%k1QOB<-E5(B
;; http://www.sanseido.net/ $B%G%$%j!<%3%s%5%$%9%7%j!<%:(B
;; http://www.excite.co.jp/dictionary/ $B?71QOBCf<-E5(B $BBh#6HG(B $B!J8&5f<R!K(B
;; http://dictionary.goo.ne.jp/  EXCEED $B1QOB<-E5(B
;; http://ocndictionary.goo.ne.jp/ EXCEED $B1QOB<-E5(B
;; http://dictionary.infoseek.ne.jp/
;; http://www.alc.co.jp/ $B1Q<-O/(B
;; http://dic.livedoor.com/ EXCEED$B1QOB<-E5(B
;; http://www.merriam-webster.com/dictionary/ webster
;; http://sara.natcorp.ox.ac.uk/cgi-bin/saraWeb corpus
;; http://www.collins.co.uk/Corpus/CorpusSearch.aspx corpus
;; http://erek.ta2o.net/news/%s.html" corpus
;; http://www.kotonoha.gr.jp/demo/ $BF|K\8l%3!<%Q%9(B
;; http://www.ctrans.org/cjdic/index.php $BCfF|(B ($BF|Cf(B)
;; http://www.gengokk.co.jp/thesaurus/ $BF|K\8l%7%=!<%i%9(B
;; http://ruigo.jp/ $BF|K\8l%7%=!<%i%9(B
;; http://www.dictjuggler.net/tamatebako/ $BF|K\8l%7%=!<%i%9(B
;; http://thesaurus.weblio.jp/ $BF|K\8l%7%=!<%i%9(B
;; http://thesaurus.reference.com/ english thesaurus
;; http://dmoz.atpedia.jp/Reference/Thesauri links to thesaurus sites
;; http://lsd.pharm.kyoto-u.ac.jp/ja/service/weblsd/ $B%i%$%U%5%$%(%s%9<-=q(B
;; http://www.tfd.com/
;; http://www.onlinedic.com/search.php
;; http://www.bitex-cn.com/
;; http://www.yakushite.net/
;; http://www.sanseido.net/User/Dic/Index.aspx
;; http://www.stars21.asia/dictionary/Japanese-Chinese_dictionary.html
;; http://www.frelax.com/sc/service/pinyin/ $B4A;z(Bpinyin$BJQ49(B
;; http://rnnnews.jp/ $B;~;v1Q8l<-E5(B
;; http://www.tranexp.com:2000/Translate/result.shtml
;; http://www.kotoba.ne.jp/ $BK]Lu$N$?$a$N%$%s%?!<%M%C%H%j%=!<%9(B
;; http://www.hir-net.com/link/dic/ $B%*%s%i%$%s<-=q!&<-E5%j%s%/=8(B
;; http://www.linksyu.com/p32.htm $B<-=q!&J8Nc=8(B
;; http://so-net.web.transer.com/
;; http://homepage2.nifty.com/m_kamada/l_translation.htm
;; http://www.diigo.com/tag/$BK]Lu(B
;; http://7go.biz/translation/
;; http://lhsp.s206.xrea.com/misc/translation.html
;; http://www.langtolang.com/
;; http://www.kooss.com/honyaku/
;; http://language.tiu.ac.jp/ 
;; http://lucene.jugem.jp/?eid=305
;; http://www.takke.jp/pss/additional_questions.php
;; http://www.linkage-club.co.jp/ExamInfo&Data/BNC lemma Web.txt

(provide 'dic-lookup-w3m-ja)

;;; dic-lookup-w3m-ja.el ends here.
