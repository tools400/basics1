      /IF NOT DEFINED(mbrd0200_t)
      /DEFINE mbrd0200_t
      *===============================================================*
      *  QUSRMBRD API - MBRD0200                                      *
      *===============================================================*
     D mbrd0200_t      DS                  qualified           based(pDummy)
     D  bytePrv                      10I 0
     D  byteAvl                      10I 0
     D  filNme                       10A
     D  filLib                       10A
     D  mbr                          10A
     D  attr                         10A
     D  srcTyp                       10A
     D  crtDatTim                    13A
     D  chgDatTim                    13A
     D  text                         50A
     D  isSrcFile                     1A
      * - - - - - - - - - - - - - - - - -
     D rmtFile                        1A
     D lglFile                        1A
     D odpSharing                     1A
     D reserved_1                     2A
     D numRcdAllMbr                  10I 0
     D numDltRcd                     10I 0
     D dtaSpcSize                    10I 0
     D accPthSize                    10I 0
     D numPhyMbrs                    10I 0
     D mbrChgDatTim                  13A
     D mbrSavDatTim                  13A
     D mbrRstDatTim                  13A
     D mbrExpDate                     7A
     D reserved_2                     6A
     D numDaysUsed                   10I 0
     D dateLastUsed                   7A
     D useResetDate                   7A
     D reserved_3                     2A
     D dtaSpcSizeMult                10I 0
     D accPthSizeMult                10I 0
     D mbrTextCCSID                  10I 0
     D ofsAddInf                     10I 0
     D lenAddInf                     10I 0
     D numRcdAllMbrU                 10U 0
     D numDltRcdU                    10U 0
     D reserved_4                     6A
      *
      /ENDIF
