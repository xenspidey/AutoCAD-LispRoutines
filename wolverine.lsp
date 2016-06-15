# TODO add easy way to control layer states
(princ "\nJob Directory = " )
(princ (getvar "DWGPREFIX"))
(princ "\n")
(command "IMAGEFRAME" "2")
(command "VISRETAIN" "1")
(command "EPDFSHX" "0")
;;(command "DIMSCALE" "48")
;;Add additional directories to the support file search path
(DEFUN AddSupportPath (dir / tmp Cpath)
  (VL-LOAD-COM)
  (SETQ	Cpath (GETENV "ACAD") tmp (STRCAT ";" dir ";"))
  (IF (NOT (VL-STRING-SEARCH dir cpath)) (SETENV "ACAD" (STRCAT Cpath ";" dir)))
  (PRINC)
  )
(AddSupportPath "I:\\Office Utilities\\AutoCAD\\Resources\\Hatches")]
(AddSupportPath "I:\\Office Utilities\\AutoCAD\\fonts")]
;;Add printer support path
(vl-load-com)
(setq acadObj (vlax-get-acad-object))
(setq preferences (vla-get-Preferences acadObj))
(vla-put-PrinterConfigPath (vla-get-files preferences) "i:\\Office Utilities\\AutoCAD\\plotters" )
(vla-put-PrinterStyleSheetPath (vla-get-files preferences) "I:\\Office Utilities\\AutoCAD\\Plot Styles")


(defun c:removedlink ()
  (dictremove (namedobjdict) "ACAD_DATALINK")
  )

;change units to Architectural
(defun change_units()
  (command "LUNITS" "4")
  (princ)
)(change_units)

(defun c:vra ()
(command "VISRETAIN" "0")
(command "-xref" "reload" "*")
(command "VISRETAIN" "1")
)

(defun c:vrt ()
(command "VISRETAIN" "0")
(command "-xref" "reload" "titleblock")
(command "VISRETAIN" "1")
)

(defun c:vrx ()
(command "VISRETAIN" "0")
(command "-xref" "reload" "xref")
(command "VISRETAIN" "1")
)

(defun c:zz ()
(command "select" pause)
(command "change" "p" "" "p" "e" "0" "")
)
(defun c:2back ()
(command "select" pause)
(command "draworder" "all" "remove" "previous" "" "front")
)

(defun c:2back_lay ()
(c:getsel)
(command "draworder" "all" "remove" "previous" "" "front")
)

(defun c:2back2 ()
(sssetfirst nil (ssget "_X" '((0 . "INSERT"))))
)

(defun c:ht ()
(command "_qsave")
(command "_bhatch")
)

;convert mtext to mleader
(defun c:m2ml ()
  (setq	pt1	(getpoint "\nPick leader point")	; pick leader
	mtext	(entsel "\nPick Text")	; pick text
	mtext2	(entget (car mtext))
	pt2	(dxf 10 mtext2)		; get point of text
	text	(dxf 1 mtext2)		; get
  )					; setq

  (command "mleader" pt1 pt2 text)	; start mleader command
  (COMMAND "ERASE" mtext "")		; erase text picked

)					; defun

(defun dxf(code elist)		; define dxf function
  (cdr (assoc code elist))     ;Finds the association pair, strips 1st element
);defun

(defun c:sx ()
  (command "PDMODE" "0")
  (command "PDSIZE" "0")
  (COMMAND "ZOOM" "E")
  (command "ltscale" ".375")
  (command ^C^C)
  (command "tilemode" 0)
  (command "zoom" "e")
  (command "-layer" "s" 0)
  (command ^C^C)
  (COMMAND "-PURGE" "A" "" "N")
  (command "-purge" "r" "" "n")
  (command "_qsave")
)

(defun c:ssc ()
  (command "_qsave")
  (command "close")
)

(defun c:sxc ()
	(command "PDMODE" "0")
	(command "PDSIZE" "0")
	(command "ZOOM" "E")
	(command "ltscale" ".375")
	(command ^C^C)
	(command "tilemode" 0)
	(command "zoom" "e")
	(command "-layer" "s" 0)
	(command ^C^C)
	(command "-PURGE" "A" "" "N")
	(command "-purge" "r" "" "n")
	(command "_qsave")
	(command "close")
)

(defun c:mx ()
	(COMMAND "ZOOM" "E")
	(command "ltscale" ".375")
	(command ^C^C)
	(command "-layer" "s" 0)
	(command ^C^C)
	(COMMAND "-PURGE" "A" "" "N")
	(command "-purge" "r" "" "n")
	(command "_qsave")
)

(defun SELLAY2 (/ EN)
	(setvar "cmdecho" 0)
	(while (not EN)
		(setq EN (car (nentsel "\nPick NESTED Entity: ")))
		(if (not EN) (prompt "\nNo Entity selected--Try again!"))
	)
	(setq LAY (cdr (assoc 8 (entget EN))))
)

(defun c:nfc (/ LAY)
		(SETVAR "CLAYER" "0")
        (prompt "\nChange color of selected layer")
	(SELLAY2)
	(if (eq LAY (getvar "CLAYER"))
		(progn
			(
				(setq n2f1 NIL)
				(setq n2f2 NIL)
				(setq n2f1 (car (cadddr (nentsel "\nLayer is nested, reselect Layer to change color :"))))
				(setq n2f2 (cdr (assoc 8 (entget n2f1))))
				(if (eq n2f2 "0")
				(prompt "\nLayer is zero... command aborted")

				(progn
				(
				(princ "\nColor to change layer to: ")
				(command "layer" "color" pause n2f2 "")
				(prompt (strcat "\nLayer <" n2f2 "> color is changed"))
				)))
			)
		)
		(progn
		(princ "\nColor to change layer to: ")
		(command "LAYER" "color" pause LAY "")
		(prompt (strcat "\nLayer <" LAY "> color is changed!"))
    )
  )
	(princ)
)

(defun c:ft ()
  (command "fillet")
)

(defun c:fn ()
  (command "fillet" "t" "n")
)

(defun c:cn ()
  (command "chamfer" "t" "n")
)

(defun c:brp ()
  (command "_break" pause "_f" pause "@")
)

(DEFUN C:cxc (/ osm ln)
  ;(SETVAR "osmode" 16384)
  (SETQ ln (cdr (assoc 8 (entget (car (nentselp (getpoint "Select object: ")))))))
  (PROMPT "Select Color: ")
  (COMMAND "LAYER" "C" pause ln "")
  ;(SETVAR "osmode" 2087) (PRINC)
  )

(defun c:xx ()
  (command "-xref" "reload" "*")
  )

(defun c:sf ()
  (command "-layer" "t" "*furn*" "on" "*furn*" "")
  )

(defun c:ff ()
  (command "-layer" "f" "*furn*" "off" "*furn*" "")
  )

(defun c:lto ()
  (command "-layer" "t" "*light*" "on" "*light*" "t" "*ceiling*" "on" "*ceiling*" "t" "*clg grid*" "on" "*clg grid*" "t" "*-can*" "on" "*-can*" "")
  )

(defun c:ltoff ()
  (command "-layer" "f" "*light*" "off" "*light*" "f" "*ceiling*" "off" "*ceiling*" "f" "*clg grid*" "off" "*clg grid*" "f" "*-can*" "off" "*-can*" "")
  )

(defun c:go ()
  (command "-layer" "t" "*grid*" "on" "*grid*" "t" "*ceiling*" "on" "*ceiling*" "t" "*clg grid*" "on" "*clg grid*" "")
)

(defun c:goff ()
  (command "-layer" "f" "*grid*" "off" "*grid*" "f" "*ceiling" "off" "*ceiling*" "f" "*clg grid*" "off" "*clg grid*" "")
)

(defun C:FH ()
  (COMMAND "-LAYER" "F" "*HATCH*" "T" "*nic" "t" "*n.i.c.*" "")
)

(defun c:fxd ()
  (command "-layer" "F" "*xref*|*demo*" "F" "*xref*|*relocate" "F" "*xref*|*relocate-*" "")
  )

(defun c:sxd ()
  (command "-layer" "T" "*xref*|*demo*" "T" "*xref*|*relocate" "T" "*xref*|*relocate-*" "")
  )

  (defun c:fd ()
  (command "-layer" "F" "*demo*" "F" "*relocate" "F" "*relocate-*" "")
  )

(defun c:sd ()
  (command "-layer" "T" "*demo*" "T" "*relocate" "T" "*relocate-*" "")
  )

  (defun TB_THAW ()
  (COMMAND "-LAYER" "T" "*TB*|*" "T" "*Titleblock*" "")
  )

(defun C:TB_CS ()
  (TB_THAW)
  (COMMAND "-LAYER" "OFF" "*TB*|*" "off" "*Titleblock*" "ON" "*CHECK SET*" "ON" "*|TEXT*" "ON" "*|BORDER*" "ON" "*CLIENT*" "")
  )

(defun C:TB_BP ()
  (TB_THAW)
  (COMMAND "-LAYER" "OFF" "*TB*|*" "off" "*Titleblock*" "ON" "*BID & PERMIT*" "ON" "*|TEXT*" "ON" "*|BORDER*" "ON" "*CLIENT*" "")
  )

(defun c:TB_CT ()
  (TB_THAW)
  (command "-layer" "OFF" "*TB*|*" "off" "*Titleblock*" "ON" "*REVISION*" "on" "*CONSTRUCTION*" "ON" "*|*TEXT*" "ON" "*|BORDER*" "ON" "*CLIENT*" "")
  )

(defun c:TB_P ()
  (TB_THAW)
  (command "-layer" "off" "*TB*|*" "off" "*Titleblock*" "ON" "*REVISION*" "on" "*PRELIMINARY*" "ON" "*|*TEXT*" "ON" "*|*BORDER*" "ON" "*CLIENT*" "ON" "*8*" "ON" "*NONE*" "ON" "*NOTE*" "")
  )

(defun C:TBS ()
  (TB_THAW)
  (COMMAND "-LAYER" "OFF" "*TB*|*" "off" "*Titleblock*" "ON" "*REVISION*" "ON" "*SJV*" "ON" "*|*TEXT*" "ON" "*|*BORDER*" "ON" "*CLIENT*" "ON" "*Outline-NP*" "ON" "*8*" "ON" "*NONE*" "ON" "*NOTE*" "")
  )

  (defun C:TBZ ()
  (TB_THAW)
  (COMMAND "-LAYER" "OFF" "*TB*|*" "off" "*Titleblock*" "ON" "*REVISION*" "ON" "*ZSV*" "ON" "*|*TEXT*" "ON" "*|*BORDER*" "ON" "*CLIENT*" "ON" "*Outline-NP*" "ON" "*8*" "ON" "*NONE*" "ON" "*NOTE*" "")
  )

(defun C:TBI ()
  (TB_THAW)
  (COMMAND "-LAYER" "OFF" "*TB*|*" "off" "*Titleblock*" "ON" "*REVISION*" "ON" "*INTERTECH*" "ON" "*|*TEXT*" "ON" "*|*BORDER*" "ON" "*CLIENT*" "ON" "*Outline-NP*" "ON" "*8*" "ON" "*NONE*" "ON" "*NOTE*" "")
  )

 (defun c:TBP ()
	(TB_THAW)
	(COMMAND "-LAYER" "ON" "*PRELIMINARY*" "")
)

(defun c:pm ()
  (command "tilemode" 1)
  )

(defun c:mp ()
  (command "tilemode" 0)
  )

(defun Get_Line( / OBJ )
  (while (not OBJ)
    (setq OBJ(car(entsel "\nSelect Line")))
    (if (/= (cdr(assoc 0(entget OBJ))) "LINE")
     (progn (prompt "\nEntity selected was not a line. Try again")
            (setq OBJ nil)
     )
     OBJ
   )
  )
)
(defun Newerr()
   (setvar "cmdecho" CE)
   (setvar "osmode" UOS)
   (setvar "orthomode" UORTH)
   (setq *error* olderr )
   (command ".redraw")
   (princ)
)

(defun c:Heal( / ENT1 ENT2 NLINE 1PT10 2PT10 OLD10
                 1PT11 2PT11 OLD11 DIST1 DIST2 DIST3 DIST4
                 DSTLST MAXDST PT1 PT10 PT11)
   (setq olderr *error*
         *error* Newerr
         CE(getvar "cmdecho")
         UOS(getvar "osmode")
         UORTH(getvar "orthomode"))
   (setvar "cmdecho" 0)
   ;(setvar "osmode" 0)
   ;(setvar "orthomode" 1)
   (setq ENT1(Get_Line)
         ENT2 ENT1
   )
   (redraw ENT1 3)
   (while (eq ENT1 ENT2)
     (setq ENT2(Get_Line))
   )
   (setq NLINE (entget ENT1)
         1PT10(cdr(setq OLD10(assoc 10 NLINE)))
         1PT11(cdr(setq OLD11(assoc 11 NLINE)))
         PARAMS2(entget ENT2)
         2PT10(cdr(assoc 10 PARAMS2))
         2PT11(cdr(assoc 11 PARAMS2))
         DIST1(distance 1PT10 2PT10)
         DIST2(distance 1PT10 2PT11)
         DIST3(distance 1PT11 2PT10)
         DIST4(distance 1PT11 2PT11)
         DSTLST(list(list DIST1 1PT10 2PT10)(list DIST2 1PT10 2PT11)
                    (list DIST3 1PT11 2PT10)(list DIST4 1PT11 2PT11)
               )
         MAXDST(max DIST1 DIST2 DIST3 DIST4)
         PTS(cdr(assoc MAXDST DSTLST))
         PT10(car PTS)
         PT11(cadr PTS)
         NLINE(subst(cons 10 PT10) OLD10 NLINE)
         NLINE(subst(cons 11 PT11) OLD11 NLINE)
   )
   (entdel ENT2)
   (entmod NLINE)
   (entupd ENT1)
   (Newerr)
   (setq *error* olderr olderr nil)
   (princ)
)

;// break splines into poly lines
(defun C:S2P (/ SPLINES PLINETYPE OSMODE I SPL ED CODEPAIR)
  (if
    (setq SPLINES (ssget (list (cons 0 "spline"))))
     (progn
       (if
         (zerop (setq PLINETYPE (getvar "plinetype")))
          (setvar "plinetype" 1)
          ) ;if
       (setq OSMODE (getvar "osmode"))
       (setvar "osmode" 0)
       (setq I 0)
       (while
         (setq SPL (ssname SPLINES I))
          (setq    I  (1+ I)
                ED (entget SPL)
                ) ;setq
          (command ".pline")
          (foreach
               CODEPAIR
                       ED
            (if
              (= 10 (car CODEPAIR))
               (command (cdr CODEPAIR))
               ) ;if
            ) ;foreach
          (command "")
          (command ".pedit" "l" "s" "")
          ) ;while
       (if PLINETYPE
         (setvar "plinetype" PLINETYPE)
         )
       (setvar "osmode" OSMODE)
       ) ;progn
     ) ;if
  (princ)
  ) ;defun



(defun c:qc ( / Purge-it) ;create the short keys and declare a local variable
  (prompt "\nMacro: Purge, Save, Close all Open Drawings Loaded!...") ;tell the user what is going on
  (vl-load-com) ;make sure the vlisp editor is awake
  (setq Purge-it (strcat (findfile "Purgeall.dvb") "!ThisDrawing.Close_N_PurgeAll")) ;store the loading string

(vl-vbarun Purge-it) ;using visual lisp call the macro and run it
  (princ) ;prevent the word nil from appearing at the command line
)

(defun c:layshow ()
  (command "-layer" "on" "*" "t" "*" "")
  )

(defun c:auto ()
  (command "lts" "1" "")
  (command "qsave" "")
  (command "close")
  )

  (defun c:sle ()
  (command "-scalelistedit" "R" "Y" "E")
  )

  (defun C:NF(/ LAY)
        (prompt "\nFreeze NESTED layer by pick")
	(SELLAY2)
	(if (eq LAY (getvar "CLAYER"))
		(prompt "\nCannot freeze current layer.")
    (progn
    (if (eq LAY "0")
	(progn
        (prompt "\nCannot freeze layer < 0 >.  Using NFF.")
		(NFF)
		)
    (progn
		(command "LAYER" "FREEZE" LAY "")
		(prompt (strcat "\nLayer <" LAY "> is now FROZEN!"))
    )
    ) ) )
	(princ)
)
;-------------NFF ------------- NEsted Nested Freeze
(defun c:nff ()
        (setq n2f1 NIL)
        (setq n2f2 NIL)
        (setq n2f1 (car (cadddr (nentsel "\nSelect Layer to Freeze :"))))
        (setq n2f2 (cdr (assoc 8 (entget n2f1))))
        (command "layer" "freeze" n2f2 "")
        (prompt (strcat "Layer <" n2f2 "> is now Frozen"))
)

;------------MVA------------ Move all objects. This will fix the unselectable object problem
(defun c:mva ()
	(setq sel1 (ssget "_A"))
	(command "move" sel1 "" "0,0,0" "24,0,0")
	(setq sel1 (ssget "_A"))
	(command "move" sel1 "" "24,0,0" "0,0,0")
)

;START bk Break line offset
(defun C:bk (/ line line1 pt1 pt2 pt3 pt4 angl )
    (setq osold (getvar "Osmode"))
    (setvar "osmode" 0)
    (command "undo" "mark")
    (princ "\nPick the line to to be hidden.")
    (setq line (car (entsel))
          line1 (entget line)
          pt1 (cdr (assoc 10 line1 ))
          pt2 (cdr (assoc 11 line1 ))
          ANGL (angle pt1 pt2 )
    )
    (setvar "Osmode" 32)
    (setq pt1 (getpoint "\nPick the first break point <Intersection>: "))
    (setq pt3 (polar pt1 ANGL 2))
    (setq pt4 (polar pt1 (- ANGL pi) 2))
    (command ".break" line pt3 pt4 )
    (setvar "osmode" 0)
    (setvar "Osmode" osold)
(princ)
)
(princ)
;END bk

(defun c:rc12 ()
  (command "revcloud" "a" "12" "12" "o" pause)
  )
