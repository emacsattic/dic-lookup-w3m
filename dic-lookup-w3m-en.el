;;; dic-lookup-w3m-en.el --- look up dictionary on the Internet

;; Copyright (C) 2009  mcprvmec

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

(mapc
 '(lambda (elem) (add-to-list 'dic-lookup-w3m-search-engine-alist elem))
 '(("ee-longman" "http://www.ldoceonline.com/search/?q=%s" utf-8)
   ("ee-oxford"
    "http://www.oup.com/oald-bin/web_getald7index1a.plsearch_word=%s" utf-8)
   ("ee-cambridge" "http://dictionary.cambridge.org/results.asp?searchword=%s")
   ))

(eval-after-load "w3m-filter"
  '(mapc
    '(lambda (elem)
       (add-to-list 'w3m-filter-rules elem))
    (reverse
     `(
       ))))

(provide 'dic-lookup-w3m-en)

;;; dic-lookup-w3m-en.el ends here
