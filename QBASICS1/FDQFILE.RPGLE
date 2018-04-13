      /IF NOT DEFINED(qFile_t   )
      /DEFINE qFile_t
      * ============================================================= *
      *   Qualified file name                                         *
      *===============================================================*
      *
     D qFile_t         DS                  qualified           based(pDummy)
     D  name                         10A
     D  lib                          10A
     D  mbr                          10A
      *
      /ENDIF
