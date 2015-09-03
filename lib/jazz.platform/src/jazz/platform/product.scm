;;;==============
;;;  JazzScheme
;;;==============
;;;
;;;; Platform Product
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
;;;  Portions created by the Initial Developer are Copyright (C) 1996-2015
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


(unit jazz.platform.product


;;;
;;;; Build
;;;


(define (jazz:parse-dot-version version)
  (let ((version (map string->number (jazz:split-string version #\.))))
    (let ((major (%%car version))
          (minor (%%cadr version))
          (build (caddr version)))
      (values major minor build))))


(cond-expand
  (mac
    (define jazz:custom-cc
      "/usr/bin/gcc")
    
    (define jazz:custom-cc-options
      '("-O1" "-Wno-unused" "-Wno-write-strings" "-fno-math-errno" "-fno-strict-aliasing" "-fwrapv" "-fomit-frame-pointer" "-fPIC" "-fno-common")))
  (else))


(cond-expand
  (mac
    (define jazz:types-units
      `((jazz.platform.types-syntax)
        (jazz.platform.types custom-cc: ,jazz:custom-cc custom-cc-options: ,jazz:custom-cc-options))))
  (else
   (define jazz:types-units
     '((jazz.platform.types-syntax)
       (jazz.platform.types)))))


(define (jazz:guess-cairo-name)
  (if (jazz:pkg-config-exists? "cairo-ft")
      "cairo-ft"
    "cairo"))


(cond-expand
  (cocoa
    (define jazz:cairo-units
      (let ((cairo-include-path      (jazz:quote-jazz-pathname "foreign/mac/cairo/include/cairo"))
            (pixman-include-path     (jazz:quote-jazz-pathname "foreign/mac/pixman/include"))
            (fontconfig-include-path (jazz:quote-jazz-pathname "foreign/mac/fontconfig/include"))
            (freetype-include-path   (jazz:quote-jazz-pathname "foreign/mac/freetype/include"))
            (png-include-path        (jazz:quote-jazz-pathname "foreign/mac/png/include"))
            (cairo-lib-path          (jazz:quote-jazz-pathname "foreign/mac/cairo/lib"))
            (pixman-lib-path         (jazz:quote-jazz-pathname "foreign/mac/pixman/lib"))
            (fontconfig-lib-path     (jazz:quote-jazz-pathname "foreign/mac/fontconfig/lib"))
            (freetype-lib-path       (jazz:quote-jazz-pathname "foreign/mac/freetype/lib"))
            (png-lib-path            (jazz:quote-jazz-pathname "foreign/mac/png/lib")))
        (let ((cc-flags (string-append "-I" cairo-include-path " -I" pixman-include-path " -I" fontconfig-include-path " -I" freetype-include-path " -I" png-include-path))
              (ld-flags (string-append "-L" cairo-lib-path " -L" pixman-lib-path " -L" fontconfig-lib-path " -L" freetype-lib-path " -L" png-lib-path " -lcairo.2")))
          `((jazz.platform.cairo                cc-options: ,cc-flags ld-options: ,ld-flags)
            (jazz.platform.cairo.cairo-base     cc-options: ,cc-flags ld-options: ,ld-flags)
            (jazz.platform.cairo.cairo-quartz   cc-options: ,cc-flags ld-options: ,ld-flags custom-cc: ,jazz:custom-cc custom-cc-options: ,jazz:custom-cc-options)
            (jazz.platform.cairo.cairo-freetype cc-options: ,cc-flags ld-options: ,ld-flags))))))
  (windows
    (define jazz:cairo-units
      (let ((cairo-include-path      (jazz:quote-jazz-pathname "foreign/windows/cairo/include"))
            (pixman-include-path     (jazz:quote-jazz-pathname "foreign/windows/pixman/include"))
            (fontconfig-include-path (jazz:quote-jazz-pathname "foreign/windows/fontconfig/include"))
            (freetype-include-path   (jazz:quote-jazz-pathname "foreign/windows/freetype/include"))
            (expat-include-path      (jazz:quote-jazz-pathname "foreign/windows/expat/include"))
            (png-include-path        (jazz:quote-jazz-pathname "foreign/windows/png/include"))
            (zlib-include-path       (jazz:quote-jazz-pathname "foreign/windows/zlib/include"))
            (cairo-lib-path          (jazz:quote-jazz-pathname "foreign/windows/cairo/lib"))
            (pixman-lib-path         (jazz:quote-jazz-pathname "foreign/windows/pixman/lib"))
            (fontconfig-lib-path     (jazz:quote-jazz-pathname "foreign/windows/fontconfig/lib"))
            (freetype-lib-path       (jazz:quote-jazz-pathname "foreign/windows/freetype/lib"))
            (expat-lib-path          (jazz:quote-jazz-pathname "foreign/windows/expat/lib"))
            (png-lib-path            (jazz:quote-jazz-pathname "foreign/windows/png/lib"))
            (zlib-lib-path           (jazz:quote-jazz-pathname "foreign/windows/zlib/lib")))
        (let ((cc-flags (string-append "-I" cairo-include-path " -I" pixman-include-path " -I" fontconfig-include-path " -I" freetype-include-path " -I" expat-include-path " -I" png-include-path " -I" zlib-include-path))
              (ld-flags (string-append "-L" cairo-lib-path " -L" pixman-lib-path " -L" fontconfig-lib-path " -L" freetype-lib-path " -L" expat-lib-path " -L" png-lib-path " -L" zlib-lib-path " -mwindows -lcairo -lfreetype")))
          `((jazz.platform.cairo                cc-options: ,cc-flags ld-options: ,ld-flags)
            (jazz.platform.cairo.cairo-base     cc-options: ,cc-flags ld-options: ,ld-flags)
            (jazz.platform.cairo.cairo-freetype cc-options: ,cc-flags ld-options: ,ld-flags)
            (jazz.platform.cairo.cairo-logfont  cc-options: ,cc-flags ld-options: ,ld-flags)
            (jazz.platform.cairo.cairo-windows  cc-options: ,cc-flags ld-options: ,(string-append ld-flags " -lMsimg32")))))))
  (x11
    (define jazz:cairo-units
      (let ((cairo-name (jazz:guess-cairo-name)))
        (receive (major minor build) (jazz:parse-dot-version (jazz:pkg-config-version cairo-name))
          (if (%%fx< minor 4)
              (jazz:error "Cairo 1.4 or higher needed")
            (let ((cc-flags (jazz:pkg-config-cflags cairo-name))
                  (ld-flags (jazz:pkg-config-libs cairo-name)))
              `((jazz.platform.cairo                cc-options: ,cc-flags ld-options: ,ld-flags)
                (jazz.platform.cairo.cairo-base     cc-options: ,cc-flags ld-options: ,ld-flags)
                (jazz.platform.cairo.cairo-x11      cc-options: ,cc-flags ld-options: ,ld-flags)
                (jazz.platform.cairo.cairo-freetype cc-options: ,cc-flags ld-options: ,ld-flags)))))))))


(define jazz:windows-units
  (let ((pdh-include-path   (jazz:quote-jazz-pathname "foreign/windows/pdh/include"))
        (pdh-lib-path       (jazz:quote-jazz-pathname "foreign/windows/pdh/lib"))
        (base-windows-cc-options "-DUNICODE -D_WIN32_WINNT=0x0502"))
    `((jazz.platform.windows)
      (jazz.platform.windows.WinDef      cc-options: ,base-windows-cc-options ld-options: "-mwindows")
      (jazz.platform.windows.WinTypes    cc-options: ,base-windows-cc-options ld-options: "-mwindows")
      (jazz.platform.windows.WinBase     cc-options: ,base-windows-cc-options ld-options: "-mwindows")
      (jazz.platform.windows.WinNT       cc-options: ,base-windows-cc-options ld-options: "-mwindows")
      (jazz.platform.windows.WinKernel   cc-options: ,base-windows-cc-options ld-options: "-mwindows")
      (jazz.platform.windows.WinGDI      cc-options: ,base-windows-cc-options ld-options: "-mwindows")
      (jazz.platform.windows.WinIDL      cc-options: ,base-windows-cc-options ld-options: "-mwindows")
      (jazz.platform.windows.WinMM       cc-options: ,base-windows-cc-options ld-options: "-mwindows -lwinmm")
      (jazz.platform.windows.WinUser     cc-options: ,base-windows-cc-options ld-options: "-mwindows")
      (jazz.platform.windows.WinShell    cc-options: ,base-windows-cc-options ld-options: "-mwindows")
      (jazz.platform.windows.WinCtrl     cc-options: ,base-windows-cc-options ld-options: "-mwindows")
      (jazz.platform.windows.WinDlg      cc-options: ,base-windows-cc-options ld-options: "-mwindows")
      (jazz.platform.windows.WinPerf     cc-options: ,(string-append "-I" pdh-include-path " " base-windows-cc-options) ld-options: ,(string-append "-L" pdh-lib-path " -mwindows -lpdh"))
      (jazz.platform.windows.WinPSAPI    cc-options: ,(string-append "-I" pdh-include-path " " base-windows-cc-options) ld-options: ,(string-append "-L" pdh-lib-path " -mwindows -lpsapi")))))


(define jazz:com-units
  '((jazz.platform.windows.com cc-options: "-DUNICODE -D___SINGLE_HOST" ld-options: "-mwindows -lole32 -loleaut32")))


(cond-expand
  (x11
   (define jazz:x11-units
     (let ((cc-flags (jazz:pkg-config-cflags "x11"))
           (ld-flags (jazz:pkg-config-libs "x11")))
       `((jazz.platform.x11 cc-options: ,cc-flags ld-options: ,ld-flags)
         (jazz.platform.x11.x11-types)))))
   (else))


(cond-expand
  (cocoa
   (define jazz:cocoa-units
     (let ((opengl-include-path (jazz:quote-jazz-pathname "foreign/opengl/include")))
       `((jazz.platform.cocoa.foreign cc-options: ,(string-append "-I" opengl-include-path) ld-options: "-framework Cocoa -framework OpenGL -framework IOKit" custom-cc: ,jazz:custom-cc custom-cc-options: ,jazz:custom-cc-options output-language: objc)))))
  (else))


(cond-expand
  (cocoa
   (define jazz:platform-files
     (list (cons "foreign/mac/cairo/lib/libcairo.2.dylib" "libcairo.2.dylib")
           (cons "foreign/mac/pixman/lib/libpixman-1.0.dylib" "libpixman-1.0.dylib")
           (cons "foreign/mac/png/lib/libpng16.16.dylib" "libpng16.16.dylib"))))
  (windows
   (define jazz:platform-files
     (list (cons "foreign/windows/gcc/lib/libgcc_s_dw2-1.dll" "libgcc_s_dw2-1.dll")
           (cons "foreign/windows/cairo/lib/libcairo-2.dll" "libcairo-2.dll")
           (cons "foreign/windows/pixman/lib/libpixman-1-0.dll" "libpixman-1-0.dll")
           (cons "foreign/windows/expat/lib/libexpat-1.dll" "libexpat-1.dll")
           (cons "foreign/windows/png/lib/libpng16-16.dll" "libpng16-16.dll")
           (cons "foreign/windows/zlib/lib/zlib1.dll" "zlib1.dll"))))
  (else
   (define jazz:platform-files
     '())))


(define (jazz:copy-platform-files)
  (let ((source jazz:kernel-source)
        (build (%%get-repository-directory jazz:Build-Repository)))
    (define (source-file path)
      (string-append source path))
    
    (define (build-file path)
      (string-append build path))
    
    (for-each (lambda (info)
                (let ((source (car info))
                      (build (cdr info)))
                  (jazz:copy-file (source-file source) (build-file build) feedback: jazz:feedback)))
              jazz:platform-files)))


(cond-expand
  (cocoa
    (define (jazz:build-platform descriptor #!key (unit #f) (force? #f))
      (let ((unit-specs `((jazz.platform)
                          ,@jazz:types-units
                          ,@jazz:cairo-units
                          ,@jazz:cocoa-units)))
        (jazz:custom-compile/build unit-specs unit: unit pre-build: jazz:copy-platform-files force?: force?)
        (if (or (not unit) (not (assq unit unit-specs)))
            (jazz:build-product-descriptor descriptor)))))
  (windows
    (define (jazz:build-platform descriptor #!key (unit #f) (force? #f))
      (let ((unit-specs `((jazz.platform)
                          ,@jazz:types-units
                          ,@jazz:cairo-units
                          ,@jazz:windows-units
                          ,@jazz:windows-odbc-units
                          ,@jazz:com-units)))
        (jazz:custom-compile/build unit-specs unit: unit pre-build: jazz:copy-platform-files force?: force?)
        (if (or (not unit) (not (assq unit unit-specs)))
            (jazz:build-product-descriptor descriptor)))))
  (x11
    (define (jazz:build-platform descriptor #!key (unit #f) (force? #f))
      (let ((unit-specs `((jazz.platform)
                          ,@jazz:types-units
                          ,@jazz:cairo-units
                          ,@jazz:x11-units
                          ,@jazz:unix-odbc-units)))
        (jazz:custom-compile/build unit-specs unit: unit pre-build: jazz:copy-platform-files force?: force?)
        (if (or (not unit) (not (assq unit unit-specs)))
            (jazz:build-product-descriptor descriptor unit: unit force?: force?))))))


;;;
;;;; Register
;;;


(jazz:register-product 'jazz.platform
  build: jazz:build-platform))
