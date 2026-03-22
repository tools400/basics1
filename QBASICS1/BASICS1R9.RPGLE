      *=====================================================================*
      *  BASICS1R9  - SrvPgm: Basic Routines - Display Information          *
      *=====================================================================*
      *  Author  :  Thomas Raddatz                                          *
      *  Date    :  22.06.2005                                              *
      *  E-mail  :  thomas.raddatz@tools400.de                              *
      *  Homepage:  www.tools400.de                                         *
      *=====================================================================*
      *                                                                     *
      *  This software is free software, you can redistribute it and/or     *
      *  modify it under the terms of the GNU General Public License (GPL)  *
      *  as published by the Free Software Foundation.                      *
      *                                                                     *
      *  See GNU General Public License for details.                        *
      *          http://www.opensource.org                                  *
      *          http://www.opensource.org/licenses/gpl-license.html        *
      *                                                                     *
      *=====================================================================*
      *  History:                                                           *
      *                                                                     *
      *  Datum       Name          Änderung                                 *
      *  ----------  ------------  ---------------------------------------  *
      *  23.01.2009  Th.Raddatz    Renamed f_getDisplayMode() to            *
      *                            Display_getMode().                       *
      *                            Added Display_supportsDS4().             *
      *                                                                     *
      *  26.01.2009  Th.Raddatz    Added Display_getRows() and              *
      *                            Display_getColumns().                    *
      *                                                                     *
      *=====================================================================*
      *   >>PRE-COMPILER<<                                                  *
      *                                                                     *
      *     >>CRTCMD<<  CRTRPGMOD    MODULE(&LI/&OB) +                      *
      *                              SRCFILE(&SL/&SF) +                     *
      *                              SRCMBR(&SM);                           *
      *                                                                     *
      *     >>COMPILE<<                                                     *
      *       >>PARM<< TRUNCNBR(*NO);                                       *
      *       >>PARM<< DBGVIEW(*LIST);                                      *
      *       >>PARM<< TGTRLS(V7R3M0);                                      *
      *     >>END-COMPILE<<                                                 *
      *                                                                     *
      *     >>EXECUTE<<                                                     *
      *                                                                     *
      *   >>END-PRE-COMPILER<<                                              *
      *=====================================================================*
     H NOMAIN BNDDIR('QSNAPI')
      *  Standard H-Specs
      /COPY QBASICS1,H_SPEC
      /COPY QBASICS1,COPYRIGHT
      *=====================================================================*
      *
      * -----------------------------------------
      *  Exported functions
      * -----------------------------------------
      /COPY QBASICS1,PBASICS1R9
      *
      * -----------------------------------------
      *  Reference fields
      * -----------------------------------------
      /COPY QBASICS1,BASICS1R0
      *
      * -----------------------------------------
      *  Private prototypes
      * -----------------------------------------
      *
      * -----------------------------------------
      *  Imported prototypes
      * -----------------------------------------
      *
      *  Retrieve Display Mode       Return value: Display Mode
     D QsnRtvMod...
     D                 PR             1A          extproc('QsnRtvMod')
     D  o_dspMode                     1A          options(*omit)
     D  i_hLowLvlEnv                 10I 0 const  options(*omit)
     D  io_errCode                32767A          options(*omit: *varsize)
      *
      *  Query 5250 (QsnQry5250) API Return value: return code 0=succes, -1=error
     D QsnQry5250...
     D                 PR            10I 0        extproc('QsnQry5250')
     D  o_rcvVar                  32767A          options(*varsize)
     D  i_lenRcvVar                  10I 0 const
     D  io_errCode                32767A          options(*omit: *varsize)
      *
      *  Data structure of QsnQry5250 API.
     D QSN_Q5250_t     DS                  based(pDummy)  qualified
     D  bytRet                 1      4I 0
     D  bytAvl                 5      8I 0
     D  qrySts                 9      9A
     D  wrksCtlUnit           10     11I 0
     D  codeLevel             12     14A
     D  reserved_1            15     30A
     D  wrksTypCde            31     31A
     D  mschnTypCde           32     35A
     D  mdlNbr                36     38A
     D  kbd_ID                39     39A
     D  extKbd_ID             40     40A
     D  PC_kbd_ID             41     41A
     D  srlNbr                42     45A
     D  maxInpFlds            46     47I 0
     D  ctlUnitCust           49     50A
     D  reserved_2            51     51A
     D  devCpblts             51     62A
     D   devCpblts_0                  1A   overlay(devCpblts)
     D   devCpblts_1                  1A   overlay(devCpblts: *next)
     D   devCpblts_2                  1A   overlay(devCpblts: *next)
     D   devCpblts_3                  1A   overlay(devCpblts: *next)
     D   devCpblts_4                  1A   overlay(devCpblts: *next)
     D   devCpblts_5                  1A   overlay(devCpblts: *next)
     D   devCpblts_6                  1A   overlay(devCpblts: *next)
     D   devCpblts_7                  1A   overlay(devCpblts: *next)
     D   devCpblts_8                  1A   overlay(devCpblts: *next)
     D   devCpblts_9                  1A   overlay(devCpblts: *next)
     D   devCpblts_10                 1A   overlay(devCpblts: *next)
     D   devCpblts_11                 1A   overlay(devCpblts: *next)
     D  gridBufs              63     63A
     D  typGrdLnSup           64     64A
     D  reserved_3            65     65A
     D  imgFax                66     66A
     D  imgFaxScl             67     67A
     D  imgFaxRtg             68     68A
     D  imgFaxSpt             69     69A
     D  invTags               70     70A
     D  reserved_4            71     72A
      *
      * -----------------------------------------
      *  Global constants
      * -----------------------------------------
      *
      * -----------------------------------------
      *  Global fields
      * -----------------------------------------
      *
      *=========================================================================
      *  Returns the current display mode.
      *=========================================================================
      *  Parameters:
      *   void
      *
      *  Returns:
      *   dspMode       - Current display mode:
      *                   cDISPLAY_MODE_DS3   24x80
      *                   cDISPLAY_MODE_DS4   27x132
      *=========================================================================
     P Display_getMode...
     P                 B                   export
      *
     D Display_getMode...
     D                 PI                         like(display_mode_t)
      *
      *  Return value
     D dspMode         S                   like(display_mode_t) inz
      *
      *  Local fields
     D dspModeRaw      S              1A                        inz
     D errCode         DS                  likeds(errCode_t   ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         clear errCode;
         QsnRtvMod(dspModeRaw: *omit: errCode);

         if dspModeRaw = '3';
            dspMode = cDISPLAY_MODE_DS3;
         else;
            dspMode = cDISPLAY_MODE_DS4;
         endif;

         return dspMode;

      /END-FREE
      *
     P Display_getMode...
     P                 E
      *
      *=========================================================================
      *  Returns cTrue if the display device support 27x132 mode.
      *=========================================================================
      *  Parameters:
      *   void
      *
      *  Returns:
      *   isDS4         - cTrue if the device support 27x132 mode, else cFalse.
      *=========================================================================
     P Display_supportsDS4...
     P                 B                   export
      *
     D Display_supportsDS4...
     D                 PI              N
      *
      *  Return value
     D isDS4           S               N   inz(cFalse)
      *
      *  Local fields
     D rc              S             10I 0 inz
     D QSN_Q5250       DS                  likeds(QSN_Q5250_t ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         rc = QsnQry5250(QSN_Q5250: %size(QSN_Q5250): *omit);
         if (%bitand(QSN_Q5250.devCpblts_1: x'20') = x'20');
            isDS4 = cTrue;
         else;
            isDS4 = cFalse;
         endif;

         return isDS4;

      /END-FREE
      *
     P Display_supportsDS4...
     P                 E
      *
      *=========================================================================
      *  Returns cTrue if the display device supports GUI characters.
      *=========================================================================
      *  Parameters:
      *   void
      *
      *  Returns:
      *   isGUI         - cTrue if the device support GUI characters,
      *                   else cFalse.
      *=========================================================================
     P Display_supportsGUI...
     P                 B                   export
      *
     D Display_supportsGUI...
     D                 PI              N
      *
      *  Return value
     D isGUI           S               N   inz(cFalse)
      *
      *  Local fields
     D rc              S             10I 0 inz
     D QSN_Q5250       DS                  likeds(QSN_Q5250_t ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         rc = QsnQry5250(QSN_Q5250: %size(QSN_Q5250): *omit);
         if (%bitand(QSN_Q5250.devCpblts_4: x'04') = x'04');
            isGUI = cTrue;
         else;
            isGUI = cFalse;
         endif;

         return isGUI;

      /END-FREE
      *
     P Display_supportsGUI...
     P                 E
      *
      *=========================================================================
      *  Returns the number of rows that can be displayed on the screen.
      *=========================================================================
      *  Parameters:
      *   dspMode       - Display mode.
      *                   Default: current display mode
      *                   cDISPLAY_MODE_DS3   24x80
      *                   cDISPLAY_MODE_DS4   27x132
      *
      *  Returns:
      *   rows          - Number of rows that can be displayed.
      *=========================================================================
     P Display_getRows...
     P                 B                   export
      *
     D Display_getRows...
     D                 PI             5I 0
     D  i_dspMode                          const  like(display_mode_t)
     D                                            options(*nopass)
      *
      *  Parameter positions
     D p_dspMode       C                   1
      *
      *  Fields for optional parameters
     D dspMode         S                   like(i_dspMode ) inz
      *
      *  Return value
     D rows            S              5I 0 inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
      *
     P Display_getRows...
     P                 E
      *
      *=========================================================================
      *  Returns the number of columns that can be displayed on the screen.
      *=========================================================================
      *  Parameters:
      *   dspMode       - Display mode.
      *                   Default: current display mode
      *                   cDISPLAY_MODE_DS3   24x80
      *                   cDISPLAY_MODE_DS4   27x132
      *
      *  Returns:
      *   columns       - Number of columns that can be displayed.
      *=========================================================================
     P Display_getColumns...
     P                 B                   export
      *
     D Display_getColumns...
     D                 PI             5I 0
     D  i_dspMode                          const  like(display_mode_t)
     D                                            options(*nopass)
      *
      *  Parameter positions
     D p_dspMode       C                   1
      *
      *  Fields for optional parameters
     D dspMode         S                   like(i_dspMode ) inz
      *
      *  Return value
     D columns         S              5I 0 inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
      *
     P Display_getColumns...
     P                 E
      *
