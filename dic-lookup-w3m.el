;;; dic-lookup-w3m.el --- look up dictionaries on the Internet

;; Copyright (C) 2008, 2009, 2010, 2011  mcprvmec

;; Author: mcprvmec

;; Keywords: emacs-w3m, w3m, dictionary

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

;; Requirements:
;; emacs-w3m
;; http://emacs-w3m.namazu.org/
;; w3m
;; http://w3m.sourceforge.net/
;;
;; Recommended:
;; stem.el in sdic
;; http://www.namazu.org/~tsuchiya/sdic/
;;
;; ~/.emacs:
;; ;;; w3m$B$G<-=q$r0z$/(B
;; (autoload 'dic-lookup-w3m "dic-lookup-w3m" "w3m$B$G<-=q$r0z$/(B" t)
;; or
;; (require 'dic-lookup-w3m)
;;
;; Key binding examples:
;; (global-set-key "\C-cd" 'dic-lookup-w3m)
;; (global-set-key "\C-cc" '(lambda () "excite $B1QOB(B,$BOB1Q(B" (interactive)
;; 			   (dic-lookup-w3m "ej-excite")))
;; (global-set-key "\C-ct" '(lambda () "nifty $B1QOBK]Lu(B" (interactive)
;; 			   (dic-lookup-w3m "tr-ej-nifty" 'sentence)))
;; (global-set-key "\C-cT" 'dic-lookup-w3m--tr-ej-yahoo-paragraph)
;;
;; Key translations:
;; w3m$B$N%P%C%U%!Fb$G(B
;; z     w3m$B%P%C%U%!$r1#$7$F!"(Bw3m$B$r5/F0$9$kA0$N%&%$%s%I%&$N%l%$%"%&%H$KLa$9!#(B
;; x     w3m$B$r8F$S=P$9A0$KI=<($7$F$$$?%&%$%s%I%&$rA*Br$9$k!#(B
;; f     w3m$B$N(Bfilter$B$NM-8z!"L58z$r@Z$jBX$($k!#(B
;; F     $BH/2;5-9f$N(Binline image$B$r%U%)%s%H$KJQ49$7$FI=<($9$k$+$I$&$+$r@Z(B
;;       $B$jBX$($k!#(B
;; C-c l $B1QC18l$i$7$$J8;zNs$K<-=q8!:wMQ$N%"%s%+!<$rIU$1$k%U%#%k%?$r%H%0%k$9$k!#(B

;;; Code:

(require 'w3m)
(require 'w3m-search)
(require 'w3m-filter)
(setq w3m-use-filter t)

(defconst dic-lookup-w3m-version "1.0"
  "Version string of this package.")

(defvar dic-lookup-w3m-config-files
  '(dic-lookup-w3m-ja
    dic-lookup-w3m-zh
    ;;dic-lookup-w3m-text-translator
    )
  "*$B<-=q%5%$%H$NDj5A$r5-=R$7$?%U%!%$%k$N%j%9%H!#(B
dic-lookup-w3m.el$B$,%m!<%I$5$l$?$H$-!"$3$N%j%9%H$K$"$k%7%s%\%k$,(Brequire$B$5$l$k!#(B
$B%7%s%\%k$O<-=q%5%$%H$NDj5A%U%!%$%k$G(Bprovide$B$7$F$*$/I,MW$,$"$k!#(B
$B$?$H$($PJl8l$4$H$K<-=q%5%$%H$N%;%C%H$rDj5A$9$k$3$H$rA[Dj!#(B
$B%j%9%H$r5-=R$9$k=gHV$KCm0U!#%U%!%$%k$r%m!<%I$9$k=gHV$K$h$C$F(B
`w3m-filter-rules'$B$GDj5A$5$l$k%U%#%k%?$N<B9T=g=x$,JQ$o$k!#F10l%5%$%H$K(B
$BBP$9$k%k!<%k$,J#?t$N%U%!%$%k$K=q$+$l$F$$$k>l9g!"%m!<%I$9$k=gHV$G7k2L$,(B
$BJQ$o$k2DG=@-$,$"$k!#(B")


(defvar dic-lookup-w3m-search-engine-alist '()
  "*$B8!:w%(%s%8%s$N%j%9%H!#(B
$B:G=i$N(B4$B8D$N%a%s%P!<$O(B`w3m-search-engine-alist'$B;2>H!#(B

5$BHVL\$O$=$N8!:w%(%s%8%s$N@bL@!#(B
6$BHVL\$O(B`dic-lookup-w3m-suitable-engine'$B$KEO$9>pJs!#(B
$BCM$O(Blist$B$^$?$O(Bsymbol$B!#(Blist$B$N$H$-$O(B(query-pattern engine-regexp replacement)$B!#(B
query$B$,(BQUERY-REGEXP$B$K0lCW$7$?$i<-=q(Bengine$B$NL>A0$N(BENGINE-REGEXP$B$K%^%C%A(B
$B$7$?ItJ,$r(BREPLACEMENT$B$KCV$-49$($?$b$N$r?7$7$$<-=q%(%s%8%s$K$9$k!#(B
symbol$B$N$H$-$O4X?tL>$H$_$J$7$F(B`dic-lookup-w3m-suitable-engine'$B$,<u$1<h$C$?(B
$B0z?t(Bsearch-engine query search-engine-alist$B$G8F$S=P$9!#(B
$B4X?t$O8!:w$K;H$&<-=q%(%s%8%sL>$rJV$5$J$1$l$P$J$i$J$$!#(B")

(defvar dic-lookup-w3m-enable-search-engine-list nil
  "*$B;HMQ$9$k8!:w%(%s%8%s$N%j%9%H!#(B
`w3m-search-engine-alist' $B$K$"$k8!:w%(%s%8%s$N$&$A!";HMQ$7$?(B
$B$$%(%s%8%s$NL>A0$r@55,I=8=$G5-=R$9$k!#40A4$K0lCW$5$;$k$K$O%Q%?!<%s(B
$B$NA08e$K(B`^', `$'$B$,I,MW!#%Q%?!<%s$N$I$l$+$K%^%C%A$7$?8!:w%(%s%8%s$@(B
$B$1$,(B`w3m-search-engine-alist'$B$KDI2C$5$l!"<-=qA*Br$NJd408uJd$K8=$l$k!#(B
nil$B$J$i(B`w3m-search-engine-alist'$B$K$"$k$9$Y$F$N%(%s%8%s$r;H$&!#(B")

(defvar dic-lookup-w3m-search-engine-aliases '()
  "*search engine$B$NJLL>$N%j%9%H!#(B
search engine$B$rJL$N3P$($d$9$$L>A0$GEPO?$9$k!#(B
`((ALIAS ENGINE-NAME)..)")

(defvar dic-lookup-w3m-related-site-list '()
  "*query$B$K4XO"$7$?8!:w$r$7$d$9$/$9$k$?$a$KI=<($9$k%5%$%H$N%j%9%H!#(B
`(category
  ((search-engine . display-name)..))
 ..
`dic-lookup-w3m-filter-related-links'$B;2>H!#(B")

(mapc 'require dic-lookup-w3m-config-files)

(dolist (elem dic-lookup-w3m-search-engine-aliases)
  (let ((engine (assoc (cadr elem) dic-lookup-w3m-search-engine-alist)))
    (if engine
	(add-to-list 'dic-lookup-w3m-search-engine-alist
		     `(,(car elem) ,@(cdr engine))))))

(dolist (elem dic-lookup-w3m-search-engine-alist)
  (if (or (null dic-lookup-w3m-enable-search-engine-list)
	  (assoc-default (car elem) dic-lookup-w3m-enable-search-engine-list
			 'string-match t))
      (add-to-list 'w3m-search-engine-alist elem)))

(defvar dic-lookup-w3m-autodef-func t
  "$B3F(Bsearch engine$B$r8F$S=P$9$?$a$N4X?t$r@8@.$9$k!#(B
non-nil$B$J$i3F(Bsearch engin$B$4$H$K(Bdic-lookup-w3m--ENGINNAME,
dic-lookup-w3m--ENGINENAME-region, dic-lookup-w3m--ENGINENAME-sentense
$B$N$h$&$J4X?t$r<+F0@8@.$9$k!#%-!<%P%$%s%I$7$F;HMQ$9$k$3$H$rA[Dj!#(B")

(if dic-lookup-w3m-autodef-func
    (dolist (elem dic-lookup-w3m-search-engine-alist)
      (when (or (null dic-lookup-w3m-enable-search-engine-list)
		(assoc-default (car elem)
			       dic-lookup-w3m-enable-search-engine-list
			       'string-match t))
	(fset (intern (format "dic-lookup-w3m--%s" (car elem)))
	      `(lambda (&optional query)
		 ,(format "Call `dic-lookup-w3m' with argment \"%s\".\n(See `dic-lookup-w3m-search-engine-alist')"
			  (car elem))
		 (interactive)
		 (funcall 'dic-lookup-w3m ,(car elem) query)))
	(dolist (thing '(word region line sentence paragraph buffer))
	  (fset (intern (format "dic-lookup-w3m--%s-%s" (car elem) thing))
		`(lambda ()
		   ,(format "Call `dic-lookup-w3m' with arguments \"%s\", '%s.\n(See `dic-lookup-w3m-search-engine-alist')"
			    (car elem) thing)
		   (interactive)
		   (funcall 'dic-lookup-w3m ,(car elem) ',thing)))
	  ))))

;; $B$I$N%-!<$K$b%P%$%s%I$5$l$F$$$J$$>l9g$N$_%P%$%s%I$9$k(B
(dolist (elem
	 '(("z" dic-lookup-w3m-bury-buffer) ; or rebind `q'
	   ("f" dic-lookup-w3m-toggle-filter)
	   ("x" dic-lookup-w3m-select-last-window)
	   ("F" dic-lookup-w3m-toggle-phonetic-image)
	   ("\C-cl" dic-lookup-w3m-filter-toggle-eword-anchor)))
  (unless (where-is-internal (cadr elem) w3m-mode-map)
    (apply 'define-key w3m-mode-map elem)))

(defun dic-lookup-w3m-select-last-window ()
  "w3m$B$r8F$S=P$9A0$KI=<($7$F$$$?%&%$%s%I%&$rA*Br$9$k!#(B"
  (interactive)
  (other-window -1))

(defvar dic-lookup-w3m-window-configuration nil
  "w3m$B$+$iLa$C$?$H$-$K85$N%&%$%s%I%&$rI=<($9$k$?$a$K3P$($F$*$/!#(B")

(defun dic-lookup-w3m-bury-buffer ()
  "w3m$B%P%C%U%!$r1#$7$F!"(B`w3m'$B$r5/F0$9$kA0$N%&%$%s%I%&$N%l%$%"%&%H$KLa$9!#(B"
  (interactive)
  (unless w3m-display-inline-images
    (w3m-toggle-inline-images 'turnoff))
  (if (window-configuration-p dic-lookup-w3m-window-configuration)
      (progn
	(set-window-configuration dic-lookup-w3m-window-configuration)
	(setq dic-lookup-w3m-window-configuration nil))
    (switch-to-buffer (other-buffer))))

;; w3m-search.el$B$N(Bw3m-search-read-variables$B$rJQ99(B
(defun dic-lookup-w3m-read-search-engine (&optional search-engine arg)
  (if (or (null search-engine)
	  (eq arg '-)
	  (and (numberp arg) (< arg 0))
	  (and (listp arg) (numberp (car arg)) (< (car arg) 0)))
      (let ((default (or (car w3m-search-engine-history)
			 w3m-search-default-engine))
	    (completion-ignore-case t))
	(completing-read (format "Which engine? (default %s): "
				 default)
			 w3m-search-engine-alist nil t nil
			 'w3m-search-engine-history default))
    (if (car (assoc search-engine w3m-search-engine-alist))
	search-engine
      (dic-lookup-w3m-read-search-engine nil arg))))

(defvar dic-lookup-w3m-read-query-prefix-arg-alist
  '((2 . line)				; C-u 2
    (4 . sentence)			; C-u
    (3 . region)			; C-u 3
    (16 . region)			; C-u C-u
    (5 . paragraph)			; C-u 5
    (64 . paragraph)			; C-u C-u C-u
    (6 . buffer)			; C-u 6
    (256 . buffer)			; C-u C-u C-u C-u
    )
  "*`dic-lookup-w3m'$B$NA0CV0z?t$H%F%-%9%H$NA*BrHO0O$NBP1~!#(B")

;; w3m-search.el$B$N(Bw3m-search-read-variables$B$rJQ99(B
(defun dic-lookup-w3m-read-query (search-engine query &optional arg)
  (cond ((numberp arg)
	 (setq arg (abs arg)))
	((and (listp arg) (numberp (car arg)))
	 (setq arg (abs (car arg)))))
  (setq arg (assoc-default arg dic-lookup-w3m-read-query-prefix-arg-alist))
  (cond
   ((eq arg 'line)
    (setq query (thing-at-point 'line)))
   ((eq arg 'sentence)
    (setq query (thing-at-point 'sentence)))
   ((eq arg 'region)
    (setq query (buffer-substring (region-beginning) (region-end))))
   ((eq arg 'paragraph)
    (setq query (thing-at-point 'paragraph)))
   ((eq arg 'buffer)
    (setq query (thing-at-point 'buffer)))
   ((eq arg 'word)
    (setq query
	  (or (thing-at-point 'word)
	      (save-excursion
		(re-search-forward "\\S-" nil t) (thing-at-point 'word)))))
   ((eq query 'line)
    (setq query (thing-at-point 'line)))
   ((eq query 'sentence)
    (setq query (thing-at-point 'sentence)))
   ((eq query 'region)
    (setq query (buffer-substring (region-beginning) (region-end))))
   ((eq query 'paragraph)
    (setq query (thing-at-point 'paragraph)))
   ((eq query 'buffer)
    (setq query (thing-at-point 'buffer)))
   ((eq query 'word)
    (setq query
	  (or (thing-at-point 'word)
	      (save-excursion
		(re-search-forward "\\S-" nil t) (thing-at-point 'word)))))
   ((eq query nil)
    (setq query
	  (w3m-search-read-query
	   (format "%s search: " search-engine)
	   (format "%s search (default %%s): " search-engine))))
   (t query))

  (if (and query (string-match "\n" query)) ; $BK]Lu%5%$%HMQ(B
      (while (string-match "^[ \t]+\\|[ \t]+$" query)
	(setq query (replace-match "" t nil query))))
  query)

;; w3m-search.el$B$N(Bw3m-search-escape-query-string$B$r=$@5(B
(defadvice w3m-search-escape-query-string
  (around do-not-modify-query-string-just-encode-it (str &optional coding))
  "query string$B$r6uGrJ8;z$GJ,3d$7$J$$!#(B"
  (setq ad-return-value
	(w3m-url-encode-string str (or coding w3m-default-coding-system))))

(defvar dic-lookup-w3m-buffer-name ""
  "*$B<-=q$N8!:w7k2L$rI=<($9$k$?$a$N(Bw3m$B%P%C%U%!$NL>A0!#(B
non-nil$B$J$i!"(Bw3m$B%;%C%7%g%s$N%P%C%U%!L>!#J#?t$N(Bw3m$B%;%C%7%g%s$,$"$k(B
$B$H$-!">o$K$3$N%P%C%U%!$G8!:w$r9T$&!#$b$7%P%C%U%!L>$N%;%C%7%g%s$,B8(B
$B:_$7$J$$$H$-$O?7$7$$(Bw3m$B%;%C%7%g%s$r3+;O$7$F!"$=$N%P%C%U%!L>$r$3$N(B
$BJQ?t$KJ];}$9$k!#(B
nil$B$J$i(B`w3m-goto-url'$B$,A*Br$9$k%;%C%7%g%s$G8!:w$r9T$&!#(B(w3m$B$N%G%U%)(B
$B%k%H$NF0:n!#(B)
$BFs$D$N(Bw3m$B%;%C%7%g%s$NJRJ}$KFI$_$?$$(Bweb$B%5%$%H$rI=<($7$F!"$b$&0lJ}$K(B
$B<-=q$rI=<($9$k$H$$$&;H$$J}$rA[Dj!#(B")

(defvar dic-lookup-w3m-query "" "query string. $B:n6HMQ0l;~%G!<%?(B")

(defun dic-lookup-w3m (&optional search-engine query)
  "w3m$B$r;H$C$F%$%s%?!<%M%C%H>e$N<-=q$r0z$/!#$^$?$OK]Lu$9$k!#(B

search-engine$B$,(Bnon-nil$B$J$i$=$N(Bsearch-engine$B$r;H$&!#(Bnil$B$J$i%_%K%P%C(B
$B%U%!$+$iFI$_<h$k!#(Bsearch-engine$B$O(B
`dic-lookup-w3m-search-engine-alist'$B$KB8:_$9$k$b$N!#(B

query$B$,J8;zNs$J$i$=$NJ8;zNs$r(Bsearch-engine$B$KAw$k!#%7%s%\%k$J$i%+%l(B
$B%s%H%P%C%U%!$+$iJ8;zNs$rA*Br$7$F(Bsearch-engine$B$KAw$k!#%7%s%\%k$NCM(B
$B$K$h$C$FA*BrHO0O$r;XDj$9$k!#;XDj$G$-$k%7%s%\%k$O(Bline, sentence,
region, paragraph, buffer$B!#(Bregion$B0J30$O(B`thing-at-point'$B$r;HMQ$7$F(B
$BJ8;zNs$rA*Br$9$k!#(Bquery$B$,(Bnil$B$J$i%_%K%P%C%U%!$+$iFI$_<h$k!#(B

$BA0CV0z?t$rM?$($k$H!"$=$NCM$K$h$C$FJ8;zNs$NA*BrHO0O$r;XDj$9$k!#HO0O(B
$B;XDj$N<oN`$O(Bquery$B$KM?$($k%7%s%\%k$HF1$8!#A0CV0z?t$NCM$HHO0O;XDj$N(B
$BAH$_9g$o$;$O(B`dic-lookup-w3m-read-query-prefix-arg-alist'$B$G;XDj$9$k!#(B
$B$?$H$($P(BC-u$B$G(Bsentense$B!"(BC-u C-u$B$G(Bregion$B$J$I!#(B

$BA0CV0z?t$O(Bquery$B$NCM$KM%@h$9$k!#$?$H$($P(Bsentence$B$r;XDj$7$?(B
dic-lookup-w3m$B$N8F$S=P$7$r%-!<%P%$%s%I$7$F$*$-!">l9g$K$h$C$FA0CV0z(B
$B?t$G(Bregion$B$d(Bparagraph$B$r;XDj$9$k$h$&$K$9$k$H!"%-!<%P%$%s%I$N?t$H%-!<(B
$B%9%H%m!<%/$r@aLs$G$-$k!#(B
query$B$X$N%7%s%\%k$N;XDj$HA0CV0z?t$N;XDj$OK]Lu%5%$%H$G$N;HMQ$rA[Dj(B
$B$7$F$$$k!#(B"
  (interactive)
  (setq search-engine
	(dic-lookup-w3m-read-search-engine search-engine current-prefix-arg))
  (setq query
	(dic-lookup-w3m-read-query search-engine query current-prefix-arg))
  (when query
    (unless			       ; looks like a sentence or more
	(string-match "[^ \t\n]+[ \t\n]+[^ \t\n]+[ \t\n]+[^ \t\n]" query)
      (setq dic-lookup-w3m-query query))
    (setq search-engine
	  (dic-lookup-w3m-suitable-engine search-engine query))
    (unless dic-lookup-w3m-window-configuration
      (setq dic-lookup-w3m-window-configuration
	    (current-window-configuration)))
    (when dic-lookup-w3m-buffer-name
      (pop-to-buffer (get-buffer dic-lookup-w3m-buffer-name))
      (unless (get-buffer dic-lookup-w3m-buffer-name)
	(w3m nil t)
	(setq dic-lookup-w3m-buffer-name (buffer-name))))
    (ad-activate 'w3m-search-escape-query-string)
    (w3m-search search-engine query)
    (ad-deactivate 'w3m-search-escape-query-string)))

(defun dic-lookup-w3m-last-engine (&optional query)
  "$B:G8e$K%_%K%P%C%U%!$+$iFI$_9~$s$G;HMQ$7$?%5%$%H$r;HMQ$7$F8!:w$9$k!#(B
$B%-!<%P%$%s%I$+$i5/F0$7$?%5%$%H$O!":G8e$K%_%K%P%C%U%!$+$iFI$_9~$s$G(B
$B;HMQ$7$?%5%$%H$K$J$i$J$$!#(B"
  (interactive)
  (dic-lookup-w3m (car w3m-search-engine-history) query))

(defun dic-lookup-w3m-suitable-engine (search-engine query)
  "$BE,@Z$J<-=q$K@Z$jBX$($k!#(B
$B$?$H$($P1QOB<-E5$GF|K\8l$r8!:w$7$h$&$H$7$?>l9g$KOB1Q<-E5$K@Z$jBX$((B
$B$F8!:w$9$k!#@Z$jBX$($k5,B'$O(B`dic-lookup-w3m-search-engine-alist'$B$N(B
6$BHVL\$NCM$r;HMQ!#CM$O%j%9%H!"%7%s%\%k$^$?$O4X?t!#%j%9%H$J(B
$B$i(B(REGEXP FROM TO)$B!#(Bquery$B$,(BREGEXP$B$K%^%C%A$7$?$i!"(Bsearch-engine$B$N@5(B
$B5,I=8=(BFROM$B$K%^%C%A$7$?ItJ,$r(BTO$B$KCV49$7$?%(%s%8%sL>$rJV$9!#%7%s%\%k(B
$B$J$i$=$NCM$r%j%9%H$H$7$F;HMQ$7$FF1MM$KCV49$9$k!#4X?t$J$i(B
search-engine, query$B$r0z?t$H$7$F8F$S=P$9!#(B
"
  (let ((rule
	 (nth 5 (assoc search-engine dic-lookup-w3m-search-engine-alist))))
    (if (functionp rule)
	(funcall rule search-engine query)
      (if (symbolp rule)
	  (setq rule (symbol-value rule)))
      (if (consp rule)
	  (or
	   (and (string-match (car rule) query)
		(string-match (nth 1 rule) search-engine)
		(car
		 (assoc (replace-match (nth 2 rule) t nil search-engine)
			dic-lookup-w3m-search-engine-alist)))
	   search-engine)
	search-engine))))

(defvar dic-lookup-w3m-inline-image-rules '()
  "*w3m$B$G(Binline image$B$rI=<($9$k$+$I$&$+$r%5%$%H$4$H$K;XDj$9$k%j%9%H!#(B
 ((REGEXP . FLAG) ...)
FLAG$B$,(B'turnoff$B$J$i@55,I=8=$K%^%C%A$7$?%5%$%H$G$O(Binline image$B$rI=<($7$J$$!#(B
turnoff, nil$B0J30$J$iI=<($9$k!#(B
FLAG$B$,(Bnil$B$G$"$k$+!"$^$?$O%5%$%H$,$I$N@55,I=8=$K$b%^%C%A$7$J$+$C$?>l9g$O(B
`dic-lookup-w3m-inline-image-inherit'$B$N;XDj$K=>$&!#(B
`w3m-toggle-inline-images'$B;2>H!#(B")

(defvar dic-lookup-w3m-inline-image-inherit nil
  "*inline image$B$NI=<((B/$BHsI=<(@Z$jBX$(5,B'!#(B
inline image$B$NI=<(%k!<%k$,(B`dic-lookup-w3m-inline-image-rules'$B$KDj(B
$B5A$5$l$F$$$J$$%5%$%H$N%G%U%)%k%H$NF0:n$N;XDj!#(B
non-nil$B$J$i(Binline image$B$NI=<(!?HsI=<($N>uBV$r@Z$jBX$($J$$!#(B($B$=$NA0(B
$B$KI=<($7$?%Z!<%8$HF1$8!#(B)
nil$B$J$i(B`w3m-default-display-inline-images'$B$NCM$K=>$&!#(B")

(defun dic-lookup-w3m-decide-inline-image ()
  "$B%5%$%H$4$H$K(Binline image$B$rI=<($9$k$+$I$&$+$r@Z$jBX$($k!#(B"
  (when (w3m-display-graphic-p)
    (let ((flag
	   (assoc-default w3m-current-url dic-lookup-w3m-inline-image-rules
			  'string-match)))
      (if flag
	  (w3m-toggle-inline-images flag)
	(unless dic-lookup-w3m-inline-image-inherit
	  (w3m-toggle-inline-images
	   (or w3m-default-display-inline-images 'turnoff)))))))

;;(add-hook 'w3m-display-hook 'dic-lookup-w3m-decide-inline-image)
(add-hook 'w3m-fontify-after-hook 'dic-lookup-w3m-decide-inline-image)

(defun dic-lookup-w3m-toggle-filter ()
  "w3m$B$N(Bfilter$B$N(Bon/off$B$r@Z$jBX$($k!#(B"
  (interactive)
  (setq w3m-use-filter (null w3m-use-filter))
  (w3m-redisplay-this-page)
  (if w3m-use-filter
      (w3m-message "w3m-filter is on.")
    (w3m-message "w3m-filter is off.")))

;; w3m-filter.el$B$N(Bw3m-filter$B$r=$@5(B
(defadvice w3m-filter
  (around multi-filters (url))
  "Apply filtering rule of URL against a content in this buffer."
  (save-match-data
    (dolist (elem w3m-filter-rules)
      (when (string-match (car elem) url)
	(if (listp (cadr elem))
	    (dolist (elem2 (cdr elem))
	      (apply (car elem2) url (cdr elem2)))
	  (apply (cadr elem) url (cddr elem)))))))

(ad-activate 'w3m-filter)

;; w3m-filter.el$B$N(Bw3m-filter-delete-regions$B$r=$@5(B
(defadvice w3m-filter-delete-regions
  (around exclude-matched-strings (url start end &optional exclude-s exclude-e
				       regexp-s regexp-e))
  "Delete regions surrounded with a START pattern and an END pattern."
  (goto-char (point-min))
  (let (p (i 0))
    (while (and (if regexp-s (re-search-forward start nil t)
		  (search-forward start nil t))
		(setq p (if exclude-s (match-end 0) (match-beginning 0)))
		(if regexp-e (re-search-forward end nil t)
		  (search-forward end nil t)))
      (delete-region p (if exclude-e (match-beginning 0) (match-end 0)))
      (+ i 1))
    (setq ad-return-value (> i 0))))

(ad-activate 'w3m-filter-delete-regions)

;; w3m-filter.el$B$N(Bw3m-filter-replace-regexp$B$r=$@5(B
(defadvice w3m-filter-replace-regexp
  (around replace-match-without-case-conversion (url regexp to-string))
  "Replace all occurrences of REGEXP with TO-STRING."
  (goto-char (point-min))
  (while (re-search-forward regexp nil t)
    (replace-match to-string t)))

(ad-activate 'w3m-filter-replace-regexp)

(defun dic-lookup-w3m-filter-eword-anchor (url search-engine &optional
					       min-length coding)
  "web$B%Z!<%8Cf$N1QC18l$i$7$$J8;zNs$KBP$7$F!"<-=q8!:wMQ$N%"%s%+!<$r:n@.$9$k!#(B
min-length$B$h$jC;$$J8;zNs$K$O%"%s%+!<$r:n@.$7$J$$!#(B"
  (let ((search-engine (if (symbolp search-engine)
			   (symbol-value search-engine)
			 search-engine))
	(min-length (or min-length 3))
	s e (inhref nil) word)
    (goto-char (point-min))
    (re-search-forward "<body[^>]+>\\|<body>" nil t)
    (goto-char (match-beginning 0))
    (while (re-search-forward "\\(<[^>]+>\\)\\([^>]*\\)<" nil t)
      (setq s (match-beginning 2) e (match-end 2))
      (cond ((string-match "^<a[^a-z]" (match-string 1)) (setq inhref t))
	    ((string-match "^</a[^a-z]" (match-string 1)) (setq inhref nil)))
      (goto-char e)
      (unless inhref
	(save-excursion
	  (save-restriction
	    (narrow-to-region s e)
	    (goto-char (point-min))
	    (while (re-search-forward
		    (format
		     "\\([^-a-zA-Z'&]\\|\\`\\)\\([-a-zA-Z']\\{%s,\\}\\)"
		     min-length) nil t)
	      (setq word (match-string 2))
	      (delete-region (match-beginning 2) (match-end 2))
	      (insert
	       (format "<a href=\"%s\">%s</a>"
		       (format
			(nth 1 (assoc search-engine w3m-search-engine-alist))
			(w3m-url-encode-string word coding))
		       (w3m-encode-specials-string word)))
	      )))))))

(defvar dic-lookup-w3m-favorite-ej-engine "ej-excite"
  "*$B1QC18l$+$i%j%s%/$rD%$k%G%U%)%k%H$N(Bsearch engine.
`dic-lookup-w3m-filter-toggle-eword-anchor'$B;2>H!#(B")

(defun dic-lookup-w3m-filter-toggle-eword-anchor (&optional flag)
  "$B1QC18l$i$7$$J8;zNs$K<-=q8!:wMQ$N%"%s%+!<$rIU$1$k%U%#%k%?$r%H%0%k$9$k!#(B
$B0z?t$J$7$G8F$S=P$9$H%U%#%k%?$r%H%0%k$9$k!#(Bflag$B$NCM$,(Bturnoff$B$J$i%U%#(B
$B%k%?$rL58z$K$9$k!#(Bturnoff$B$G$b(Bnil$B$G$b$J$1$l$P%U%#%k%?$rM-8z$K$9$k!#(B
$B%U%#%k%?$rM-8z$K$9$k$H!"%Z!<%8Cf$K$"$k$9$Y$F$N1QC18l$i$7$$J8;zNs$K(B
$B8!:w%(%s%8%s(B``dic-lookup-w3m-favorite-ej-engine''$B$r8!:w$9$k%j%s%/(B
$B$r$D$1$k!#(B"
  (interactive)
  (let ((rule '("\\`\\(https?\\|file\\)://" dic-lookup-w3m-filter-eword-anchor
		dic-lookup-w3m-favorite-ej-engine)))
    (cond
     ((eq flag 'turnoff)
      (setq w3m-filter-rules (delete rule w3m-filter-rules)))
     ((not (null flag))
      (add-to-list 'w3m-filter-rules rule t))
     ((member rule w3m-filter-rules)
      (setq w3m-filter-rules (delete rule w3m-filter-rules)))
     (t
      (add-to-list 'w3m-filter-rules rule t)))
    (w3m-redisplay-this-page)))

(require 'url-parse)
(require 'url-util)
(defun dic-lookup-w3m-get-query-from-url (url baseurl &optional coding)
  "url$B$+$i(Bquery$BJ8;zNs$r<h$j=P$9!#(B"
  (let (str)
    (if (string-match ".*\\?.*%s" baseurl)
	(let ((base-query
	       (replace-regexp-in-string
		".*\\?" "" (url-filename (url-generic-parse-url baseurl)) t))
	      (query
	       (replace-regexp-in-string
		".*\\?" "" (url-filename (url-generic-parse-url url)) t)))
	  (setq str
		(cadr
		 (assoc
		  (car (rassoc '("%s") (url-parse-query-string base-query)))
		  (url-parse-query-string query)))))
      (string-match "\\(.*\\)%s\\(.*\\)" baseurl)
      (if (string-match (format "%s\\([^&;?]+\\)%s"
				(regexp-quote (match-string 1 baseurl))
				(regexp-quote (match-string 2 baseurl)))
			url)
	  (setq str (match-string 1 url))))
    (if str
	(replace-regexp-in-string
	 "+" " " (w3m-url-decode-string str coding) t)
      "")))

(defvar dic-lookup-w3m-filter-do-show-candidates-heading " Possibly: "
  "*$BC18l$N8uJd%j%9%H$NA0$KI=<($9$k8+=P$7!#(B
`dic-lookup-w3m-filter-show-candidates'$B;2>H!#(B")

(defun dic-lookup-w3m-filter-show-candidates (url search-engine
						  &optional regexp before)
  "query$B$+$i1Q8l$N3hMQ8lHx$r<h$j=|$$$F8+=P$78l$N8uJd$rI=<($9$k!#(B
$B$3$N5!G=$r;H$&$K$O(Bstem.el$B$,I,MW!#(B
stem.el$B$O(Bsdic$B$K4^$^$l$F$$$^$9!#$^$?(Blookup$B$K(Bstem-english.el$B$H$$$&L>A0$G(B
$B4^$^$l$F$$$^$9!#(B"
  (let* ((baseurl (nth 1 (assoc search-engine w3m-search-engine-alist)))
	 (coding (nth 2 (assoc search-engine w3m-search-engine-alist)))
	 (candidates (stem:stripping-suffix
		      (dic-lookup-w3m-get-query-from-url url baseurl coding)))
	 (candidates2 (stem:stripping-suffix dic-lookup-w3m-query)))
    (mapc '(lambda (s) (setq candidates2 (delete s candidates2)))
	  candidates)
    (if (or candidates candidates2)
	(w3m-filter-replace-regexp
	 url
	 (concat "\\(" (or regexp "<body[^>]*>") "\\)")
	 (concat
	  (unless before "\\1")
	  "<span id=\"dic-lookup-w3m-candidates\">"
	  dic-lookup-w3m-filter-do-show-candidates-heading
	  (mapconcat
	   (lambda (s)
	     (format "<a href=\"%s\">%s</a>"
		     (format baseurl (w3m-url-encode-string s coding))
		     (w3m-encode-specials-string s)))
	   candidates ", ")
	  (if (and candidates candidates2) " | ")
	  (mapconcat
	   (lambda (s)
	     (format "<a href=\"%s\">%s</a>"
		     (format baseurl (w3m-url-encode-string s coding))
		     (w3m-encode-specials-string s)))
	   candidates2 ", ")
	  "</span><!-- /dic-lookup-w3m-candidates -->"
	  (if before "\\1")
	  )))
    ))

(condition-case nil
    (require 'stem)
  (error
   (fset 'dic-lookup-w3m-filter-show-candidates
	 '(lambda (url search-engine &optional regexp before)
	    "dummy. do nothing."))))

(defvar dic-lookup-w3m-filter-related-links-heading " Relevant: "
  "*$B4XO"%5%$%H$N%j%9%H$NA0$KI=<($9$k8+=P$7!#(B")

(defun dic-lookup-w3m-filter-related-links
  (url search-engine category &optional baseurl coding regexp before)
  "query$B$K4XO"$9$k%j%s%/$rI=<($9$k!#(B
$B$"$k<-=q$G8!:w$7$?C18l$rB>$N<-=q$G$b4JC1$K8!:w$G$-$k$h$&$K!"B>$N<-(B
$B=q$X%j%s%/$rD%$k!#(B"
  (let ((query (dic-lookup-w3m-get-query-from-url
		url
		(or baseurl
		    (nth 1 (assoc search-engine w3m-search-engine-alist)))
		(or coding
		    (nth 2 (assoc search-engine w3m-search-engine-alist)))))
	(site-list (cadr (assoc category dic-lookup-w3m-related-site-list))))
    (unless (equal query "")
      (w3m-filter-replace-regexp
       url
       (concat "\\(" (or regexp "<body[^>]*>") "\\)")
       (concat
	(unless before "\\1")
	"<span id=\"dic-lookup-w3m-related-links\">"
	dic-lookup-w3m-filter-related-links-heading
	(mapconcat
	 (lambda (s)
	   (if (assoc (car s) w3m-search-engine-alist)
	       (format
		"<a href=\"%s\">%s</a>"
		(format (nth 1 (assoc (car s) w3m-search-engine-alist))
			(w3m-url-encode-string
			 query
			 (nth 2 (assoc (car s) w3m-search-engine-alist))))
		(w3m-encode-specials-string (cdr s)))
	     (concat (car s) "??")))
	 (delete (assoc search-engine site-list) (copy-sequence site-list))
	 ", ")
	"</span><!-- /dic-lookup-w3m-related-links -->"
	(if before "\\1")
	)))))

(defun dic-lookup-w3m-filter-refresh-url (url new-url &optional regexp subexp)
  "html$B$N(B<meta http-equiv=\"refresh\" ...>$B$r;H$C$F?7$7$$%Z!<%8$K0\F0$9$k!#(B
$B<-=q$N8+=P$78l$N0lMw$N%Z!<%8$+$i!":G=i$N8+=P$78l$N@bL@$N%Z!<%8$K<+(B
$BF0E*$K0\F0$9$k$N$K;H$&!#(B"
  (goto-char (point-min))
  (w3m-filter-replace-regexp
   url
   "\\(<head[^>]*>\\)"
   (format
    "\\1<meta http-equiv=\"refresh\" content=\"0; url=%s\">"
    (format new-url
	    (or (and regexp (re-search-forward regexp nil t)
		     (match-string (or subexp 0)))
		"")))))

(defvar dic-lookup-w3m-filter-convert-phonetic-symbol t
  "*$BH/2;5-9f$N(Binline image$B$r%U%)%s%H$KJQ49$7$FI=<($9$k$+$I$&$+$N%U%i%0!#(B
non-nil$B$J$i!"2DG=$J>l9g$O%U%)%s%H$KJQ49$9$k!#(B
nil$B$J$i(Binline image$B$N$^$^!#(B
`dic-lookup-w3m-toggle-phonetic-image'$B$G;HMQ!#(B")

(defun dic-lookup-w3m-toggle-phonetic-image ()
  "$BH/2;5-9f$N(Binline image$B$r%U%)%s%H$KJQ49$7$FI=<($9$k$+$I$&$+$r@Z$jBX$($k!#(B
inline image$B$rI=<($9$k$H;~4V$,$+$+$k$?$a%U%)%s%H$KCV$-49$($k!#(B
``w3m-filter''$B$K%U%)%s%H$KJQ49$9$k$?$a$N%U%#%k%?!<$,Dj5A$5$l$F$$$k%5%$(B
$B%H$N$_M-8z!#(B
$B%U%#%k%?!<$O4X?t(B`dic-lookup-w3m-filter-convert-phonetic-symbol'$B$r8F$S(B
$B=P$9$h$&$K$J$C$F$$$J$1$l$P$J$i$J$$!#(B"
  (interactive)
  (setq dic-lookup-w3m-filter-convert-phonetic-symbol
	(null dic-lookup-w3m-filter-convert-phonetic-symbol))
  (w3m-redisplay-this-page)
  (if dic-lookup-w3m-filter-convert-phonetic-symbol
      (w3m-message "display phonetic symbols using fonts.")
    (w3m-message "display phonetic symbols using inline images.")))

(defun dic-lookup-w3m-filter-convert-phonetic-symbol
  (url phonetic-symbol-table image-regexp &optional subexp)
  "$BH/2;5-9f$J$I$N(Binline image$B$r%U%)%s%H$KCV$-49$($k!#(B
$BJQ?t(B`dic-lookup-w3m-filter-convert-phonetic-symbol'$B$,(Bnil$B$N>l9g$OJQ(B
$B49$7$J$$!#(B"
  (when dic-lookup-w3m-filter-convert-phonetic-symbol
    (goto-char (point-min))
    (while (re-search-forward image-regexp nil t)
      (let ((code (assoc-default
		   (match-string (or subexp 1))
		   (if (symbolp phonetic-symbol-table)
		       (symbol-value  phonetic-symbol-table)
		     phonetic-symbol-table))))
	(if code
	    (replace-match code t))))))

(define-minor-mode dic-lookup-w3m-mode
  "Toggle dic-lookup-w3m mode.
See the command \\[dic-lookup-w3m]."
  nil
  " dic-w3m"
  '()
  :group 'dic-lookup-w3m)

(defun dic-lookup-w3m-search-engine-menu (arg)
  "search engine$B$N0lMw$rI=<($9$k!#(B
$BI=<($O(B``dic-lookup-w3m-search-engine-alist''$B$K=P8=$9$k=g!#(B
C-u$B$GL>A0$G%=!<%H!"(BC-u C-u$B$G@bL@$G%=!<%H!#(B"
  (interactive "p")
  (let ((buffer (get-buffer-create " *dic-lookup-w3m-work*")))
    (save-current-buffer
      (set-buffer buffer)
      (delete-region (point-min) (point-max))
      (insert
       "<html><head><title>search engine list</title></head><body><table>\n")
      (mapc
       '(lambda (e)
	  (insert
	   (format "<tr><td><a href=\"%s\">%s</a></td><td>%s</td></tr>\n"
		   (if (string-match "%s" (cadr e))
		       (replace-match "" t nil (cadr e))
		     (cadr e))
		   (car e)
		   (or (nth 4 e) ""))))
       (cond
	((eq arg 4)
	 (sort (copy-sequence dic-lookup-w3m-search-engine-alist)
	       '(lambda (a b) (string< (car a) (car b)))))
	((eq arg 16)
	 (sort (copy-sequence dic-lookup-w3m-search-engine-alist)
	       '(lambda (a b) (string< (nth 4 a) (nth 4 b)))))
	(t (reverse dic-lookup-w3m-search-engine-alist))))
      (insert "</table></body></html>\n"))
    (ad-activate 'w3m-about)
    (w3m-gohome)
    (w3m-redisplay-this-page)))

(defun dic-lookup-w3m-txt2html (&optional search-engine min-length)
  "$B%+%l%s%H%P%C%U%!$N%F%-%9%H$r4J0W$J(Bhtml$B$KJQ49$9$k!#(B
$B%P%C%U%!Fb$N3F1QC18l$i$7$$J8;zNs$+$i<-=q$X$N%j%s%/$rD%$k!#(B
$BJQ497k2L$O(Bemacs$B$N?75,%P%C%U%!$K=PNO$9$k!#%U%!%$%k$KJ]B8$7$FJL$N(Bweb$B%V%i(B
$B%&%6$GI=<(=PMh$k!#(B"
  (interactive)
  (let ((org-buffer (current-buffer))
	(search-engine (dic-lookup-w3m-read-search-engine search-engine)))
    (find-file
     (concat
      (make-temp-name (expand-file-name "dic-lookup-w3m-")) ".html"))
    (delete-region (point-min) (point-max))
    (insert-buffer-substring org-buffer)
    (dic-lookup-w3m-htmlize search-engine (buffer-name) min-length)))

(defvar dic-lookup-w3m-temp-buffer " *dic-lookup-w3m-work*" "temp buffer")

(defun dic-lookup-w3m-txt2w3m (&optional search-engine min-length)
  "$B%+%l%s%H%P%C%U%!$N%F%-%9%H$r4J0W$J(Bhtml$B$KJQ49$7$F(Bw3m$B$G3+$/!#(B
$B%P%C%U%!Fb$N3F1QC18l$+$i<-=q$X$N%j%s%/$rD%$k!#(B"
  (interactive)
  (let ((oldbuf (current-buffer)))
    (save-current-buffer
      (set-buffer (get-buffer-create dic-lookup-w3m-temp-buffer))
      (delete-region (point-min) (point-max))
      (insert-buffer-substring oldbuf)
      (dic-lookup-w3m-htmlize
       (dic-lookup-w3m-read-search-engine search-engine)
       (buffer-name) min-length))
    (ad-activate 'w3m-about)
    (w3m-gohome)
    (w3m-redisplay-this-page)
    ;;(ad-deactivate 'w3m-about)
    ))

;; w3m.el$B$N(Bw3m-about$B$r=$@5(B
(defadvice w3m-about
  (around override (url &rest args))
  (insert-buffer-substring dic-lookup-w3m-temp-buffer)
  (setq ad-return-value "text/html"))

;;(ad-activate 'w3m-about)

(defun dic-lookup-w3m-htmlize (baseurl &optional buffer-name min-length)
  (goto-char (point-min))
  (insert
   (w3m-encode-specials-string (buffer-substring (point-min) (point-max))))
  (delete-region (point) (point-max))
  (goto-char (point-min))
  (while (re-search-forward "\n" nil t)
    (replace-match "<br>\n" t))
  (goto-char (point-min))
  (insert "<html><head><title>"
	  (w3m-encode-specials-string (or buffer-name (buffer-name)))
	  "</title></head><body><p>")
  (goto-char (point-max))
  (insert "</p></body></html>")
  (dic-lookup-w3m-filter-eword-anchor "" baseurl min-length))

(defvar dic-lookup-w3m-morpheme-cmd "c:/Program Files/MeCab/bin/mecab"
  "*$B7ABVAG2r@O%(%s%8%s$N%3%^%s%I!#(B")
(defvar dic-lookup-w3m-morpheme-args
  '("-b81920" "--eos-format="
    "--node-format=%m\t%f[7]\t%f[6]\t%F-[0,1,2,3]\t%f[4]\t%f[5]\n"
    "--unk-format=%m\t%m\t%m\t%F-[0,1,2,3]\t\t\n"
    "--eos-format=EOS\n")
  "*$B7ABVAG2r@O%(%s%8%s$N0z?t!#(B")
(defvar dic-lookup-w3m-morpheme-coding-system 'shift_jis-dos ;'euc-jp-unix
  "*$B7ABVAG2r@O%(%s%8%s$NJ8;z%3!<%I!#(B")
(defvar dic-lookup-w3m-morpheme-eos "EOS"
  "*$B7ABVAG2r@O%(%s%8%s$N=PNO$NJ8KvI=<(J8;zNs!#(B")

;; (defvar dic-lookup-w3m-morpheme-cmd "c:/Program Files/ChaSen/chasen.exe"
;;   "*$B7ABVAG2r@O%(%s%8%s$N%3%^%s%I!#(B")
;; (defvar dic-lookup-w3m-morpheme-args '()
;;   "*$B7ABVAG2r@O%(%s%8%s$N0z?t!#(B")
;; (defvar dic-lookup-w3m-morpheme-coding-system 'shift_jis
;;   "*$B7ABVAG2r@O%(%s%8%s$NJ8;z%3!<%I!#(B")
;; (defvar dic-lookup-w3m-morpheme-eos "EOS"
;;   "*$B7ABVAG2r@O%(%s%8%s$N=PNO$NJ8KvI=<(J8;zNs!#(B")

(defun dic-lookup-w3m-jtxt2w3m (&optional search-engine query)
  "$BF|K\8l$N%F%-%9%H$r!"3FC18l$K<-=q$X$N%j%s%/$rIU$1$?(Bhtml$B$KJQ49$7$F(Bw3m$B$G3+$/!#(B
$B%_%K%P%C%U%!$KF~NO$7$?%F%-%9%H$^$?$O%+%l%s%H%P%C%U%!$N%F%-%9%H$r4J(B
$B0W$J(Bhtml$B$KJQ49$7$F(Bw3m$B$G3+$/!#F|K\8l$N3FC18l$+$i<-=q$X%j%s%/$rD%$k!#(B
$B<-=q$O9q8l<-E5$N$[$+OB1Q$dF|Cf<-E5$J$IF|K\8l$,8+=P$78l$K$J$C$F$$$l$P;H$($k!#(B
`dic-lookup-w3m'$B$HF1$8$h$&$K!"A0CV0z?t$GJQ49$9$k%F%-%9%H$NHO0O$r;X(B
$BDj$G$-$k!#A0CV0z?t$J$7$G!"(Bquery$B$,6u$N>l9g$O%+%l%s%H%P%C%U%!A4BN$r(B
$BJQ49$9$k!#(B
$B7ABVAG2r@O%(%s%8%s(B(MeCab, ChaSen)$B$N@_Dj$r(B
`dic-lookup-w3m-morpheme-cmd'$B!"(B`dic-lookup-w3m-morpheme-args'$B!"(B
`dic-lookup-w3m-morpheme-coding-system'$B!"(B
`dic-lookup-w3m-morpheme-eos'$B$G$*$3$J$&!#(B
$BE,@Z$J7ABVAG2r@O4o$,$"$l$PF|K\8l0J30$N8@8l$K$b;H$($k!#(B"
  (interactive)
  (let* ((search-engine
	  (dic-lookup-w3m-read-search-engine search-engine current-prefix-arg))
	 (query
	  (dic-lookup-w3m-read-query search-engine query current-prefix-arg))
	 (engine (nth 1 (assoc search-engine w3m-search-engine-alist)))
	 (coding (nth 2 (assoc search-engine w3m-search-engine-alist)))
	 (org-buffer (current-buffer))
	 (src-tmp (get-buffer-create " *dic-lookup-w3m-work1*"))
	 (morpheme-out (get-buffer-create " *dic-lookup-w3m-work2*"))
	 (html-tmp (get-buffer-create dic-lookup-w3m-temp-buffer))
	 (morpheme))
    (with-current-buffer morpheme-out
      (delete-region (point-min) (point-max)))
    (with-current-buffer src-tmp
      (delete-region (point-min) (point-max))
      (if (equal query "")
	  (insert-buffer-substring org-buffer)
	(insert query))
      (goto-char (point-min))
      (while (re-search-forward "^[ $B!!(B\t]+\\|[ $B!!(B\t]+$" nil t)
	(replace-match ""))
      (goto-char (point-min))
      (while (re-search-forward "\n\\(.\\)" nil t)
	(replace-match " \\1"))
      (goto-char (point-min))
      (while (re-search-forward "\\(\\cj\\) +\\(\\cj\\)" nil t)
	(replace-match "\\1\\2"))
      (goto-char (point-min))
      (while (re-search-forward "$B!#(B" nil t)
	(replace-match "$B!#(B\n"))
      (let ((coding-system-for-write dic-lookup-w3m-morpheme-coding-system)
	    (coding-system-for-read dic-lookup-w3m-morpheme-coding-system))
	(apply
	 'call-process-region
	 (point-min) (point-max)
	 dic-lookup-w3m-morpheme-cmd nil morpheme-out nil
	 dic-lookup-w3m-morpheme-args)))
    (with-current-buffer html-tmp
      (delete-region (point-min) (point-max))
      (if (equal query "")
	  (insert-buffer-substring org-buffer)
	(insert query))
      (goto-char (point-min)))
    (with-current-buffer morpheme-out
      (goto-char (point-min))
      (while (re-search-forward "^.+$" nil t)
	(unless (equal (match-string 0) dic-lookup-w3m-morpheme-eos)
	  (setq morpheme (split-string (match-string 0) "\t"))
	  (with-current-buffer html-tmp
	    (if (and
		 (re-search-forward
		  (mapconcat
		   '(lambda (c)
		      (regexp-quote (string c)))
		   (car morpheme) "\\([ $B!!(B\t\n]\\)*")
		  nil t)
		 (not (equal (nth 2 morpheme) "")))
		(replace-match
		 (format
		  "<a href=\"%s\">%s</a>"
		  (format
		   engine
		   (save-match-data
		     (w3m-url-encode-string (nth 2 morpheme) coding)))
		  (save-match-data
		    (w3m-encode-specials-string (match-string 0))))
		 t))))))
    (with-current-buffer html-tmp
      (goto-char (point-min))
      (insert
       "<html><head><title>"
       (w3m-encode-specials-string
	(if (equal query "")
	    (buffer-name org-buffer)
	  (with-current-buffer src-tmp
	    (goto-char (point-min))
	    (re-search-forward "^.+$" nil t)
	    (buffer-substring (match-beginning 0) (min 17 (match-end 0))))))
       "</title></head><body><pre>\n")
      (goto-char (point-max))
      (insert "</pre></body></html>\n"))
    (ad-activate 'w3m-about)
    (w3m-gohome)
    (w3m-redisplay-this-page)))

(defun dic-lookup-w3m-next-anchor-line ()
  "$B%]%$%s%H$N$"$k9T$h$j8e$N9T$N:G=i$N%"%s%+!<$K%]%$%s%H$r0\F0$9$k!#(B
$B0l9T$KJ#?t$N%"%s%+!<$,$"$C$F$b:G=i$N$R$H$D$K$7$+0\F0$7$J$$$N$G!"1s$/$K(B
$B$"$k%"%s%+!<$KAa$/$?$I$jCe$1$k!#(B`dic-lookup-w3m-previous-anchor-line'$B$b;2>H!#(B"
  (interactive)
  (end-of-line)
  (w3m-next-anchor))

(defun dic-lookup-w3m-previous-anchor-line ()
  "$B%]%$%s%H$N$"$k9T$h$jA0$N9T$N:G8e$N%"%s%+!<$K%]%$%s%H$r0\F0$9$k!#(B
$B0l9T$KJ#?t$N%"%s%+!<$,$"$C$F$b:G=i$N$R$H$D$K$7$+0\F0$7$J$$$N$G!"1s$/$K(B
$B$"$k%"%s%+!<$KAa$/$?$I$jCe$1$k!#(B`dic-lookup-w3m-next-anchor-line'$B$b;2>H!#(B"
  (interactive)
  (beginning-of-line)
  (w3m-previous-anchor))

(provide 'dic-lookup-w3m)

(defvar dic-lookup-w3m-load-hook nil
  "*Hook run after loading the dic-lookup-w3m module.")

(run-hooks 'dic-lookup-w3m-load-hook)

;;; dic-lookup-w3m.el ends here
