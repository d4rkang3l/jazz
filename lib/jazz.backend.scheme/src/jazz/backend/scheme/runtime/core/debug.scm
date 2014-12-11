;;;==============
;;;  JazzScheme
;;;==============
;;;
;;;; Debugging
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
;;;  Portions created by the Initial Developer are Copyright (C) 1996-2012
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


(unit protected jazz.backend.scheme.runtime.core.debug


;; inspect a Jazz object
(define (inspect obj)
  (jazz:inspect-object (if (integer? obj) (jazz:serial->object obj) obj)))


;; run the message loop
(define (run-loop)
  (let ((get-process (jazz:global-ref 'jazz.system.access:get-process))
        (run-loop (jazz:global-ref 'jazz.system.process.Process:Process:run-loop)))
    (run-loop (get-process))))


;; resume the message loop
(define (resume)
  (let ((get-process (jazz:global-ref 'jazz.system.access:get-process))
        (invoke-resume-loop (jazz:global-ref 'jazz.system.process.Process:Process:invoke-resume-loop)))
    (invoke-resume-loop (get-process))))


;; start a scheme repl
(define (start-scheme-repl #!key (select? #t))
  (jazz:load-unit 'jazz)
  (jazz:load-unit 'jazz.debuggee)
  ((jazz:module-ref 'jazz.debuggee 'set-default-context) #f)
  ((jazz:module-ref 'jazz 'start-repl) readtable: jazz:scheme-readtable select?: select?)))
