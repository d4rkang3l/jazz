;;;==============
;;;  JazzScheme
;;;==============
;;;
;;;; Jazz Reader
;;;
;;;  The contents of this file are subject to the Mozilla Public License Version
;;;  1.1 (the "License"); you may not use this file except in compliance with
;;;  the License. You may obtain a copy of the License at
;;;  http://www.mozilla.org/MPL/
;;;
;;;  Software distributed under the License is distributed on an "AS IS" basis,
;;;  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
;;;  for the specific language governing rights and limitations under the
;;;  License.
;;;
;;;  The Original Code is JazzScheme.
;;;
;;;  The Initial Developer of the Original Code is Guillaume Cartier.
;;;  Portions created by the Initial Developer are Copyright (C) 1996-2006
;;;  the Initial Developer. All Rights Reserved.
;;;
;;;  Contributor(s):
;;;
;;;  Alternatively, the contents of this file may be used under the terms of
;;;  the GNU General Public License Version 2 or later (the "GPL"), in which
;;;  case the provisions of the GPL are applicable instead of those above. If
;;;  you wish to allow use of your version of this file only under the terms of
;;;  the GPL, and not to allow others to use your version of this file under the
;;;  terms of the MPL, indicate your decision by deleting the provisions above
;;;  and replace them with the notice and other provisions required by the GPL.
;;;  If you do not delete the provisions above, a recipient may use your version
;;;  of this file under the terms of any one of the MPL or the GPL.
;;;
;;;  See www.jazzscheme.org for details.


(module jazz.dialect.core.reader


(cond-expand
  (gambit
    (include "~~/src/lib/header.scm")
    
    
    (define (jazz.make-jazz-readtable)
      (let ((readtable (##readtable-copy ##main-readtable)))
        (jazz.jazzify-readtable! readtable)
        readtable))
    
    
    (define (jazz.jazzify-readtable! readtable)
      (macro-readtable-named-char-table-set! readtable (append (macro-readtable-named-char-table readtable) jazz.named-chars))
      (##readtable-char-class-set! readtable #\{ #t jazz.read-literal)
      (##readtable-char-class-set! readtable #\[ #t jazz.read-reference)
      (##readtable-char-class-set! readtable #\@ #t jazz.read-comment))
    
    
    (define jazz.named-chars
      '(("nul"                  . #\x00)
        ("home"                 . #\x01)
        ("enter"                . #\x03)
        ("end"                  . #\x04)
        ("info"                 . #\x05)
        ("backspace"            . #\x08)
        ("tab"                  . #\x09)
        ("line-feed"            . #\x0A)
        ("page-up"              . #\x0B)
        ("page-down"            . #\x0C)
        ("return"               . #\x0D)
        ("escape"               . #\x1B)
        ("left-arrow"           . #\x1C)
        ("right-arrow"          . #\x1D)
        ("up-arrow"             . #\x1E)
        ("down-arrow"           . #\x1F)
        ("space"                . #\x20)
        ("exclamation-mark"     . #\x21)
        ("double-quote"         . #\x22)
        ("sharp"                . #\x23)
        ("ampersand"            . #\x26)
        ("quote"                . #\x27)
        ("open-parenthesis"     . #\x28)
        ("close-parenthesis"    . #\x29)
        ("times"                . #\x2A)
        ("plus"                 . #\x2B)
        ("comma"                . #\x2C)
        ("minus"                . #\x2D)
        ("period"               . #\x2E)
        ("slash"                . #\x2F)
        ("colon"                . #\x3A)
        ("semi-colon"           . #\x3B)
        ("equal"                . #\x3D)
        ("question-mark"        . #\x3F)
        ("at"                   . #\x40)
        ("open-bracket"         . #\x5B)
        ("backslash"            . #\x5C)
        ("close-bracket"        . #\x5D)
        ("exponential"          . #\x5E)
        ("underscore"           . #\x5F)
        ("backquote"            . #\x60)
        ("open-brace"           . #\x7B)
        ("close-brace"          . #\x7D)
        ("tilde"                . #\x7E)
        ("delete"               . #\x7F)
        ("copyright"            . #\xA9)
        ;; quick fix to be rethought
        ("eof"                  . #\xFF)))
    
    
    (define jazz.in-expression-comment? (make-parameter #f))
    
    
    (define (jazz.read-literal re c)
      (let ((start-pos (##readenv-current-filepos re)))
        (read-char (macro-readenv-port re))
        (let ((lst (##build-list re #t start-pos #\})))
          (macro-readenv-wrap re
            (if (or (jazz.parse-read?) (jazz.in-expression-comment?))
                #f
              (jazz.construct-literal (map ##desourcify lst)))))))
    
    
    (define (jazz.read-reference re c)
      (let ((start-pos (##readenv-current-filepos re)))
        (read-char (macro-readenv-port re))
        (let ((lst (%%reverse (##build-list re #t start-pos #\]))))
          (let loop ((ref (##desourcify (%%car lst)))
                     (scan (%%cdr lst)))
            (if (%%not (%%null? scan))
                (loop (jazz.new-reference (##desourcify (%%car scan)) ref) (%%cdr scan))
              (macro-readenv-wrap re ref))))))
    
    
    (define (jazz.read-comment re c)
      (let ((port (macro-readenv-port re)))
        (parameterize ((jazz.in-expression-comment? #t))
          (read-char port)
          (read port)   ; comment name
          (read port))  ; commented expr
        (##read-datum-or-label-or-none-or-dot re)))
    
    
    (define jazz.jazz-readtable
      (jazz.make-jazz-readtable))
    
    
    (define (jazz.char-symbol char)
      (let ((table (macro-readtable-named-char-table jazz.jazz-readtable)))
        (let ((res (jazz.rassq char table)))
          (and res (%%car res))))))
  
  
  (else)))
