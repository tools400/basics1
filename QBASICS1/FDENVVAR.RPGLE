      /IF NOT DEFINED(envVar_t  )
      /DEFINE envVar_t
      * ============================================================= *
      *   Environment variable.                                       *
      * ============================================================= *
      *
     D envVar_t        DS                  qualified           based(pDummy)
     D  name                        128A   varying
     D  value                      1024A   varying
      *
      /ENDIF
