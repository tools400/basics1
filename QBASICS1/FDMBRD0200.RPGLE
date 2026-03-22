**FREE
/IF NOT DEFINED(mbrd0200_t)
/DEFINE mbrd0200_t
//===============================================================*
//  QUSRMBRD API - MBRD0200                                      *
//===============================================================*
dcl-ds mbrd0200_t qualified           based(pDummy);
  bytePrv         int(10);
  byteAvl         int(10);
  filNme          char(10);
  filLib          char(10);
  mbr             char(10);
  attr            char(10);
  srcTyp          char(10);
  crtDatTim       char(13);
  chgDatTim       char(13);
  text            char(50);
  isSrcFile       char(1);
  // - - - - - - - - - - - - - - - - -
  rmtFile         char(1);
  lglFile         char(1);
  odpSharing      char(1);
  reserved_1      char(2);
  numRcdAllMbr    int(10);
  numDltRcd       int(10);
  dtaSpcSize      int(10);
  accPthSize      int(10);
  numPhyMbrs      int(10);
  mbrChgDatTim    char(13);
  mbrSavDatTim    char(13);
  mbrRstDatTim    char(13);
  mbrExpDate      char(7);
  reserved_2      char(6);
  numDaysUsed     int(10);
  dateLastUsed    char(7);
  useResetDate    char(7);
  reserved_3      char(2);
  dtaSpcSizeMult  int(10);
  accPthSizeMult  int(10);
  mbrTextCCSID    int(10);
  ofsAddInf       int(10);
  lenAddInf       int(10);
  numRcdAllMbrU   uns(10);
  numDltRcdU      uns(10);
  reserved_4      char(6);
end-ds;

/ENDIF
