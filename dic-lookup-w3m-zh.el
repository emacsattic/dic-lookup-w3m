;;; dic-lookup-w3m-zh.el --- look up dictionaries on the Internet

;; Copyright (C) 2009, 2010, 2011  mcprvmec

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

;; 实例

(mapc
 '(lambda (elem) (add-to-list 'dic-lookup-w3m-search-engine-alist elem))
 '(
   ;; 百度
   ("cc-baidu"
    "http://baike.baidu.com/w?ct=17&lm=0&tn=baiduWikiSearch&pn=0&rn=10&word=%s&submit=search" gb2312)

   ;; 5156edu.com
   ("cc-5156edu-post" "http://xh.5156edu.com/index.php" gb2312
    "f_key=%s&f_type=zi")
   ("cc-5156edu" "http://xh.5156edu.com/index.php?f_key=%s&f_type=zi" gb2312)

   ;; the free dictionary
   ("cc-thefreedictionary"
    "http://zh.thefreedictionary.com/e/%s" utf-8)
   ;;("cc-thefreedictionary"
   ;; "http://www.thefreedictionary.com/_/search.aspx?tab=-11&charset=utf-8&SearchBy=0&TFDBy=2&Word=%s" utf-8)

   ;; iciba.com
   ("ce-ichiba" "http://www.iciba.com/%s" utf-8)
   ("ec-ichiba" "http://www.iciba.com/%s" utf-8)

   ;; ZDIC.NET【汉典】
   ("cc-hanzi-zdic-post" "http://www.zdic.net/zd/search/default.asp" utf-8
    "lb=1&q=%s")
   ("cc-hanzi-zdic"
    "http://www.zdic.net/zd/search/default.asp?lb=1&q=%s" utf-8)

   ;; dict.cn 海词
   ("ce-haici" "http://dict.cn/%s" chinese-gbk)
   ("ec-haici" "http://dict.cn/%s" chinese-gbk)

   ;; StarDict.cn
   ("ce-stardict" "http://www.stardict.cn/query.php?q=%s" utf-8)
   ("ec-stardict" "http://www.stardict.cn/query.php?q=%s" utf-8)
   ))


(defvar dic-lookup-w3m-filter-do-show-candidates-heading " 候补: ")

(defvar dic-lookup-w3m-filter-related-links-heading " 关联: ")

(defvar dic-lookup-w3m-favorite-ej-engine "ec-ichiba")

(eval-after-load "w3m-filter"
  '(mapc
    '(lambda (elem)
       (add-to-list 'w3m-filter-rules elem))
    (reverse
     `(
       ("\\`http://baike\\.baidu\\.com/"
	dic-lookup-w3m-filter-related-links "cc-baidu" cc)

       ("\\`http://www\\.thefreedictionary\\.com/"
	dic-lookup-w3m-filter-related-links "cc-thefreedictionary" cc)

       ("\\`http://www\\.iciba\\.com/"
	(w3m-filter-delete-regions "<body[^>]*>" "<div id=\"content\">" t t t)
	(dic-lookup-w3m-filter-related-links "ce-ichiba" cc)
	(dic-lookup-w3m-filter-show-candidates "ec-ichiba")
       	(dic-lookup-w3m-filter-eword-anchor dic-lookup-w3m-favorite-ej-engine)
	(dic-lookup-w3m-filter-convert-phonetic-symbol
	 dic-lookup-w3m-filter-ichiba-symbol-alist
	 "<img src=\"/images/\\([a-z0-9_]+\\)\\.gif\"[^>]*>")
	)

       ("\\`http://www\\.zdic\\.net/"
	(w3m-filter-replace-regexp "<img src=\"/images/logo.gif\">" "")
	)
       ))))

(add-to-list
 'dic-lookup-w3m-related-site-list
 '(cc
   (("cc-baidu" . "baidu")
    ("cc-5156edu" . "5156edu")
    ("cc-thefreedictionary" . "thefreedictionary")
    ("ce-ichiba" . "ichiba")
    ("cc-hanzi-zdic" . "zdic"))))

(defvar dic-lookup-w3m-filter-ichiba-symbol-alist
  '(("dict_icon" . "-")
    ("close" . "")
    ("open" . "")
    ("display" . "")
    ("display1" . "")
    ("dot" . "*")))

(defvar dic-lookup-w3m-inline-image-rules '())

(mapc
 '(lambda (elem) (add-to-list 'dic-lookup-w3m-inline-image-rules elem))
 '(("\\`http://www\\.zdic\\.net/" . t)))

;; http://baike.baidu.com/ 现代汉语词典 第五版。中国社会科学院言語研究所編，商務印書館出版
;; http://xh.5156edu.com/
;; http://zh.thefreedictionary.com/
;; http://www.iciba.com/
;; http://www.zdic.net/

(provide 'dic-lookup-w3m-zh)

;;; dic-lookup-w3m-zh.el ends here.
