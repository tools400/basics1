**free
//=====================================================================*
//  BASICS1R9  - SrvPgm: Basic Routines - Display Information          *
//=====================================================================*
//  Author  :  Thomas Raddatz                                          *
//  Date    :  22.06.2005                                              *
//  E-mail  :  thomas.raddatz@tools400.de                              *
//  Homepage:  www.tools400.de                                         *
//=====================================================================*
//                                                                     *
//  This software is free software, you can redistribute it and/or     *
//  modify it under the terms of the GNU General Public License (GPL)  *
//  as published by the Free Software Foundation.                      *
//                                                                     *
//  See GNU General Public License for details.                        *
//          http://www.opensource.org                                  *
//          http://www.opensource.org/licenses/gpl-license.html        *
//                                                                     *
//=====================================================================*
//  History:                                                           *
//                                                                     *
//  Datum       Name          Änderung                                 *
//  ----------  ------------  ---------------------------------------  *
//  23.01.2009  Th.Raddatz    Renamed f_getDisplayMode() to            *
//                            Display_getMode().                       *
//                            Added Display_supportsDS4().             *
//                                                                     *
//  26.01.2009  Th.Raddatz    Added Display_getRows() and              *
//                            Display_getColumns().                    *
//                                                                     *
//=====================================================================*
//   >>PRE-COMPILER<<                                                  *
//                                                                     *
//     >>CRTCMD<<  CRTRPGMOD    MODULE(&LI/&OB) +                      *
//                              SRCFILE(&SL/&SF) +                     *
//                              SRCMBR(&SM);                           *
//                                                                     *
//     >>COMPILE<<                                                     *
//       >>PARM<< OPTION(*EVENTF);                                     *
//       >>PARM<< TRUNCNBR(*NO);                                       *
//       >>PARM<< DBGVIEW(*LIST);                                      *
//       >>PARM<< TGTRLS(V7R3M0);                                      *
//     >>END-COMPILE<<                                                 *
//                                                                     *
//     >>EXECUTE<<                                                     *
//                                                                     *
//   >>END-PRE-COMPILER<<                                              *
//=====================================================================*
ctl-opt nomain bnddir('QSNAPI');
//  Standard H-Specs
/copy QBASICS1,H_SPEC
/copy QBASICS1,COPYRIGHT
//=====================================================================*

// -----------------------------------------
//  Exported functions
// -----------------------------------------
/copy QBASICS1,PBASICS1R9

// -----------------------------------------
//  Reference fields
// -----------------------------------------
/copy QBASICS1,BASICS1R0

// -----------------------------------------
//  Private prototypes
// -----------------------------------------

// -----------------------------------------
//  Imported prototypes
// -----------------------------------------

//  Retrieve Display Mode       Return value: Display Mode
dcl-pr QsnRtvMod char(1) extproc('QsnRtvMod');
  o_dspMode    char(1) options(*omit);
  i_hLowLvlEnv int(10) options(*omit) const;
  io_errCode   char(32767) options(*omit: *varsize);
end-pr;

//  Query 5250 (QsnQry5250) API Return value: return code 0=succes, -1=error
dcl-pr QsnQry5250 int(10) extproc('QsnQry5250');
  o_rcvVar    char(32767) options(*varsize);
  i_lenRcvVar int(10) const;
  io_errCode  char(32767) options(*omit: *varsize);
end-pr;

//  Data structure of QsnQry5250 API.
dcl-ds QSN_Q5250_t based(pDummy) qualified;
  bytRet       int(10) pos(1);
  bytAvl       int(10) pos(5);
  qrySts       char(1) pos(9);
  wrksCtlUnit  int(5) pos(10);
  codeLevel    char(3) pos(12);
  reserved_1   char(16) pos(15);
  wrksTypCde   char(1) pos(31);
  mschnTypCde  char(4) pos(32);
  mdlNbr       char(3) pos(36);
  kbd_ID       char(1) pos(39);
  extKbd_ID    char(1) pos(40);
  PC_kbd_ID    char(1) pos(41);
  srlNbr       char(4) pos(42);
  maxInpFlds   int(5) pos(46);
  ctlUnitCust  char(2) pos(49);
  reserved_2   char(1) pos(51);
  devCpblts    char(12) pos(51);
  devCpblts_0  char(1) overlay(devCpblts);
  devCpblts_1  char(1) overlay(devCpblts: *next);
  devCpblts_2  char(1) overlay(devCpblts: *next);
  devCpblts_3  char(1) overlay(devCpblts: *next);
  devCpblts_4  char(1) overlay(devCpblts: *next);
  devCpblts_5  char(1) overlay(devCpblts: *next);
  devCpblts_6  char(1) overlay(devCpblts: *next);
  devCpblts_7  char(1) overlay(devCpblts: *next);
  devCpblts_8  char(1) overlay(devCpblts: *next);
  devCpblts_9  char(1) overlay(devCpblts: *next);
  devCpblts_10 char(1) overlay(devCpblts: *next);
  devCpblts_11 char(1) overlay(devCpblts: *next);
  gridBufs     char(1) pos(63);
  typGrdLnSup  char(1) pos(64);
  reserved_3   char(1) pos(65);
  imgFax       char(1) pos(66);
  imgFaxScl    char(1) pos(67);
  imgFaxRtg    char(1) pos(68);
  imgFaxSpt    char(1) pos(69);
  invTags      char(1) pos(70);
  reserved_4   char(2) pos(71);
end-ds;

// -----------------------------------------
//  Global constants
// -----------------------------------------

// -----------------------------------------
//  Global fields
// -----------------------------------------

//=========================================================================
//  Returns the current display mode.
//=========================================================================
//  Parameters:
//   void
//
//  Returns:
//   dspMode       - Current display mode:
//                   cDISPLAY_MODE_DS3   24x80
//                   cDISPLAY_MODE_DS4   27x132
//=========================================================================
dcl-proc Display_getMode export;
  dcl-pi *n like(display_mode_t);
  end-pi;

  //  Return value
  dcl-s dspMode like(display_mode_t) inz;

  //  Local fields
  dcl-s dspModeRaw char(1) inz;
  dcl-ds errCode likeds(errCode_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  clear errCode;
  QsnRtvMod(dspModeRaw: *omit: errCode);

  if dspModeRaw = '3';
    dspMode = cDISPLAY_MODE_DS3;
  else;
    dspMode = cDISPLAY_MODE_DS4;
  endif;

  return dspMode;


end-proc;

//=========================================================================
//  Returns cTrue if the display device support 27x132 mode.
//=========================================================================
//  Parameters:
//   void
//
//  Returns:
//   isDS4         - cTrue if the device support 27x132 mode, else cFalse.
//=========================================================================
dcl-proc Display_supportsDS4 export;
  dcl-pi *n ind;
  end-pi;

  //  Return value
  dcl-s isDS4 ind inz(cFalse);

  //  Local fields
  dcl-s rc int(10) inz;
  dcl-ds QSN_Q5250 likeds(QSN_Q5250_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  rc = QsnQry5250(QSN_Q5250: %size(QSN_Q5250): *omit);
  if (%bitand(QSN_Q5250.devCpblts_1: x'20') = x'20');
    isDS4 = cTrue;
  else;
    isDS4 = cFalse;
  endif;

  return isDS4;


end-proc;

//=========================================================================
//  Returns cTrue if the display device supports GUI characters.
//=========================================================================
//  Parameters:
//   void
//
//  Returns:
//   isGUI         - cTrue if the device support GUI characters,
//                   else cFalse.
//=========================================================================
dcl-proc Display_supportsGUI export;
  dcl-pi *n ind;
  end-pi;

  //  Return value
  dcl-s isGUI ind inz(cFalse);

  //  Local fields
  dcl-s rc int(10) inz;
  dcl-ds QSN_Q5250 likeds(QSN_Q5250_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  rc = QsnQry5250(QSN_Q5250: %size(QSN_Q5250): *omit);
  if (%bitand(QSN_Q5250.devCpblts_4: x'04') = x'04');
    isGUI = cTrue;
  else;
    isGUI = cFalse;
  endif;

  return isGUI;


end-proc;

//=========================================================================
//  Returns the number of rows that can be displayed on the screen.
//=========================================================================
//  Parameters:
//   dspMode       - Display mode.
//                   Default: current display mode
//                   cDISPLAY_MODE_DS3   24x80
//                   cDISPLAY_MODE_DS4   27x132
//
//  Returns:
//   rows          - Number of rows that can be displayed.
//=========================================================================
dcl-proc Display_getRows export;
  dcl-pi *n int(5);
    i_dspMode like(display_mode_t) options(*nopass) const;
  end-pi;

  //  Parameter positions
  dcl-c p_dspMode 1;

  //  Fields for optional parameters
  dcl-s dspMode like(i_dspMode) inz;

  //  Return value
  dcl-s rows int(5) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (%parms() >= p_dspMode);
    dspMode = i_dspMode;
  else;
    dspMode = Display_getMode();
  endif;

  if (dspMode = cDISPLAY_MODE_DS3);
    rows = 24;
  else;
    rows = 27;
  endif;

  return rows;


end-proc;

//=========================================================================
//  Returns the number of columns that can be displayed on the screen.
//=========================================================================
//  Parameters:
//   dspMode       - Display mode.
//                   Default: current display mode
//                   cDISPLAY_MODE_DS3   24x80
//                   cDISPLAY_MODE_DS4   27x132
//
//  Returns:
//   columns       - Number of columns that can be displayed.
//=========================================================================
dcl-proc Display_getColumns export;
  dcl-pi *n int(5);
    i_dspMode like(display_mode_t) options(*nopass) const;
  end-pi;

  //  Parameter positions
  dcl-c p_dspMode 1;

  //  Fields for optional parameters
  dcl-s dspMode like(i_dspMode) inz;

  //  Return value
  dcl-s columns int(5) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (%parms() >= p_dspMode);
    dspMode = i_dspMode;
  else;
    dspMode = Display_getMode();
  endif;

  if (dspMode = cDISPLAY_MODE_DS3);
    columns = 80;
  else;
    columns = 132;
  endif;

  return columns;


end-proc;