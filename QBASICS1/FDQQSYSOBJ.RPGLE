      /IF NOT DEFINED(qQSYSObj_t)
      /DEFINE qQSYSObj_t
      * ============================================================= *
      *   Qualified QSYS object name                                  *
      *===============================================================*
      *
     D qQSYSObj_t      DS                  qualified           based(pDummy)
     D  name                         10A
     D  lib                          10A
     D  mbr                          10A
     D  type                         10A
      *
      /ENDIF
