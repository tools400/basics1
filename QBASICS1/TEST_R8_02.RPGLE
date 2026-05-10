**free
//===============================================================*
//    CALL PGM(TEST_R8_02)                                       *
//===============================================================*
//   >>PRE-COMPILER<<                                            *
//                                                               *
//     >>CRTCMD<<  CRTRPGMOD    MODULE(&LI/&OB) +                *
//                              SRCFILE(&SL/&SF) +               *
//                              SRCMBR(&SM);                     *
//                                                               *
//     >>COMPILE<<                                               *
//       >>PARM<< TRUNCNBR(*NO);                                 *
//       >>PARM<< DBGVIEW(*LIST);                                *
//       >>PARM<< TGTRLS(*CURRENT);                              *
//     >>END-COMPILE<<                                           *
//                                                               *
//     >>EXECUTE<<                                               *
//                                                               *
//     >>CMD<<     CRTPGM       PGM(&LI/&OB) +                   *
//                              MODULE(&LI/&OB) +                *
//                              ACTGRP(*NEW) +                   *
//                              BNDSRVPGM(&LI/BASICS1) +         *
//                              BNDDIR(QC2LE) +                  *
//                              TGTRLS(*CURRENT) +               *
//                              DETAIL(*BASIC);                  *
//                                                               *
//   >>END-PRE-COMPILER<<                                        *
//===============================================================*
ctl-opt debug option(*srcstmt: *nodebugio);
ctl-opt decedit('0,') datedit(*DMY.);
ctl-opt datfmt(*iso) timfmt(*iso);
ctl-opt expropts(*resdecpos);
ctl-opt extbinint(*yes);
//===============================================================*

// ------------------------------------
//  Type Definitions
// ------------------------------------

// ------------------------------------
//  External Prototypes
// ------------------------------------
/copy QBASICS1,PBASICS1

// ------------------------------------
//  Global Fields
// ------------------------------------

// ------------------------------------
//  Global Constants
// ------------------------------------

// ------------------------------------
//  Prototypes
// ------------------------------------

dcl-pr PGM_ENTRY_POINT extpgm('TEST_R8_02');
end-pr;

dcl-pr main;
end-pr;

//  Show cells
dcl-pr showCells;
  i_aMemList pointer value;
end-pr;

//===============================================================*
//  Program Entry Point
//===============================================================*
dcl-pi PGM_ENTRY_POINT;
end-pi;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main();

*inlr = *on;

return;


//===============================================================*
//  Main procedure
//===============================================================*
dcl-proc main;
  dcl-pi *n;
  end-pi;

  //  Helper fields
  dcl-s aMemList pointer inz;
  dcl-s pTheMemCell pointer inz dim(5);
  dcl-s aCellPayload char(20) based(pACellPayload);

  dcl-ds msg likeds(msg_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Create first memory cell
  pTheMemCell(1) = MEMORY_allocate(aMemList: %size(aCellPayload));
  pACellPayload = pTheMemCell(1);
  aCellPayload  = 'first cell';

  // Create second memory cell
  pTheMemCell(2) = MEMORY_allocate(aMemList: %size(aCellPayload));
  pACellPayload = pTheMemCell(2);
  aCellPayload  = 'second cell';

  // Create third memory cell
  pTheMemCell(3) = MEMORY_allocate(aMemList: %size(aCellPayload));
  pACellPayload = pTheMemCell(3);
  aCellPayload  = 'third cell';

  // Create fourth memory cell
  pTheMemCell(4) = MEMORY_allocate(aMemList: %size(aCellPayload));
  pACellPayload = pTheMemCell(4);
  aCellPayload  = 'fourth cell';

  // Create fifth memory cell
  pTheMemCell(5) = MEMORY_allocate(aMemList: %size(aCellPayload));
  pACellPayload = pTheMemCell(5);
  aCellPayload  = 'fifth cell';

  // Show cells:
  msg = f_newMsg(cMSG_ID_NONE: '*** Start list of memory cells ***');
  f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
  showCells(aMemList);

  // Free third cell
  msg = f_newMsg(cMSG_ID_NONE: '--> Free third cell');
  f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
  MEMORY_free(aMemList: pTheMemCell(3));

  // Show cells:
  msg = f_newMsg(cMSG_ID_NONE: '*** Start list of memory cells (4) ***');
  f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
  showCells(aMemList);

  // Free fith cell
  msg = f_newMsg(cMSG_ID_NONE: '--> Free fifth cell');
  f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
  MEMORY_free(aMemList: pTheMemCell(5));

  // Show cells:
  msg = f_newMsg(cMSG_ID_NONE: '*** Start list of memory cells (3) ***');
  f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
  showCells(aMemList);

  // Free first cell
  msg = f_newMsg(cMSG_ID_NONE: '--> Free first cell');
  f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
  MEMORY_free(aMemList: pTheMemCell(1));

  // Show cells:
  msg = f_newMsg(cMSG_ID_NONE: '*** Start list of memory cells (2) ***');
  f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
  showCells(aMemList);

  // Free memory
  MEMORY_freeAll(aMemList);

  return;


end-proc main;

//===============================================================*
//  Show cells
//===============================================================*
dcl-proc showCells;
  dcl-pi *n;
    i_aMemList pointer value;
  end-pi;

  //  Helper fields
  dcl-s cellPayload char(20) based(pCellPayload);

  dcl-ds cell qualified based(pCell);
    pPrvCell pointer;
    size     int(10);
  end-ds;

  dcl-ds msg likeds(msg_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  pCell = i_aMemList;

  dou pCell = *NULL;
    pCellPayload = pCell - cell.size;

    msg = f_newMsg(cMSG_ID_NONE: cellPayload);
    f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

    pCell = cell.pPrvCell;
  enddo;

  return;


end-proc;
