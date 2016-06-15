(defun c:test (/ count)
  (setq count Nil)
  (+ count 2)
  (princ count)
  (princ)
 )

(defun c:test1 ()
  (test)
  )

(DEFUN AddSupportPath (dir / tmp Cpath)
  (VL-LOAD-COM)
  (SETQ	Cpath (GETENV "ACAD") tmp (STRCAT ";" dir ";"))
  (IF (NOT (VL-STRING-SEARCH dir cpath)) (SETENV "ACAD" (STRCAT Cpath ";" dir)))
  (PRINC)
  )
(AddSupportPath "I:\\Office Utilities\\AutoCAD\\Resources\\Hatches")
(vl-load-com)
(setq acadObj (vlax-get-acad-object))
(setq preferences (vla-get-Preferences acadObj))
(vla-put-PrinterConfigPath (vla-get-files preferences) "i:\\office utilities\\autocad\\plotters" )


