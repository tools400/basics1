      *===============================================================*
      *  CALL PGM(TEST_R5_05)                                         *
      *===============================================================*
      *   >>PRE-COMPILER<<                                            *
      *                                                               *
      *     >>CRTCMD<<  CRTRPGMOD    MODULE(&LI/&OB) +                *
      *                              SRCFILE(&SL/&SF) +               *
      *                              SRCMBR(&SM);                     *
      *                                                               *
      *     >>COMPILE<<                                               *
      *       >>PARM<< TRUNCNBR(*NO);                                 *
      *       >>PARM<< DBGVIEW(*LIST);                                *
      *       >>PARM<< TGTRLS(*CURRENT);                              *
      *     >>END-COMPILE<<                                           *
      *                                                               *
      *     >>EXECUTE<<                                               *
      *                                                               *
      *     >>CMD<<     CRTPGM       PGM(&LI/&OB) +                   *
      *                              MODULE(&LI/&OB) +                *
      *                              ACTGRP(*NEW) +                   *
      *                              BNDSRVPGM(&LI/BASICS1) +         *
      *                              TGTRLS(*CURRENT) +               *
      *                              DETAIL(*BASIC);                  *
      *                                                               *
      *   >>END-PRE-COMPILER<<                                        *
      *===============================================================*
     H DEBUG
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H DECEDIT('0,') DATEDIT(*DMY.)
     H DATFMT(*ISO )  TIMFMT(*ISO )
     H EXPROPTS(*RESDECPOS)
     H EXTBININT(*YES)
      *===============================================================*
      *
      * ------------------------------------
      *  Type Definitions
      * ------------------------------------
      *
      * ------------------------------------
      *  External Prototypes
      * ------------------------------------
      /COPY QBASICS1,PBASICS1
      *
      * ------------------------------------
      *  Global Fields
      * ------------------------------------
      *
      * ------------------------------------
      *  Global Constants
      * ------------------------------------
      *
      * ------------------------------------
      *  Prototypes
      * ------------------------------------
      *
     D PGM_ENTRY_POINT...
     D                 PR                         extpgm('TEST_R5_05')
      *
     D main...
     D                 PR
      *
     D kill...
     D                 PR                         extproc('kill')
     D  i_text                      128A   value  varying
      *
      *===============================================================*
      *  Program Entry Point
      *===============================================================*
      *
     D PGM_ENTRY_POINT...
     D                 PI
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         main();

         *inlr = *on;

         return;

      /END-FREE
      *
      *===============================================================*
      *  Kills the program.
      *===============================================================*
     P kill...
     P                 B
     D                 PI
     D  i_text                      128A   value  varying
      *
      *  Return value
     D pBuffer         S               *   inz
      *
      *  Local fields
     D msgKey          S              4A                        inz
      *
     D qMsgF           DS                  qualified            inz
     D  name                         10A
     D  lib                          10A
      *
     D errCode         DS                  qualified            inz
     D  bytPrv                       10I 0
     D  bytAvl                       10I 0
     D  excID                         7A
     D  reserved                      1A
     D  excDta                      256A
      *
      *  Send Program Message (QMHSNDPM) API
     D QMHSNDPM        PR                         extpgm('QMHSNDPM')
     D   i_msgID                      7A   const
     D   i_qMsgF                     20A   const
     D   i_msgData                32767A   const  options(*varsize )
     D   i_length                    10I 0 const
     D   i_msgType                   10A   const
     D   i_callStkE               32767A   const  options(*varsize )
     D   i_callStkC                  10I 0 const
     D   o_msgKey                     4A
     D   io_ErrCode               32767A          options(*varsize )
     D   i_lenStkE                   10I 0 const  options(*nopass  )
     D   i_callStkEQ                 20A   const  options(*nopass  )
     D   i_wait                      10I 0 const  options(*nopass  )
     D   i_callStkEDT                10A   const  options(*nopass  )
     D   i_ccsid                     10I 0 const  options(*nopass  )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         clear qMsgF;
         qMsgF.name = 'QCPFMSG';
         qMsgF.lib  = '*LIBL';

         clear errCode;
         errCode.bytPrv = %size(errCode);

         QMHSNDPM('CPF9897': qMsgF: i_text: %len(i_text): '*ESCAPE'
                  : '*CTLBDY': 1
                  : msgKey: errCode);

         return;

      /END-FREE
     P                 E
      *
      *===============================================================*
      *  Main procedure
      *===============================================================*
     P main...
     P                 B
      *
     D main...
     D                 PI
      *
      *  Helper fields
     D qQSYSObj        ds                  likeds(qQSYSObj_t) inz
     D qFile           ds                  likeds(qFile_t) inz
     D qObj            ds                  likeds(qObj_t) inz
     D qQSYSObj2       ds                  likeds(qQSYSObj_t) inz
     D library         s             10a
     D object          s             10a
     D member          s             10a
     D path            s           5000a   varying
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         qQSYSObj.name = 'QBASICS1';
         qQSYSObj.lib = 'QGPL';
         qQSYSObj.mbr = 'PBASICS1';
         qQSYSObj.type = '*FILE';

         path = f_cvtQSYSObjNameToPath(qQSYSObj);
         if (path <> '/QSYS.LIB/QGPL.LIB/QBASICS1.FILE/PBASICS1.MBR');
            kill('Error with qQSYSObj (*FILE)');
         endif;

         qQSYSObj.name = 'QMHSNDPM';
         qQSYSObj.lib = 'QSYS';
         qQSYSObj.mbr = '';
         qQSYSObj.type = '*PGM';

         path = f_cvtQSYSObjNameToPath(qQSYSObj);
         if (path <> '/QSYS.LIB/QMHSNDPM.PGM');
            kill('Error with qQSYSObj (*PGM)');
         endif;

         qQSYSObj.name = 'BASICS1';
         qQSYSObj.lib = 'UBMSYS';
         qQSYSObj.mbr = '';
         qQSYSObj.type = '*SRVPGM';

         path = f_cvtQSYSObjNameToPath(qQSYSObj);
         if (path <> '/QSYS.LIB/UBMSYS.LIB/BASICS1.SRVPGM');
            kill('Error with qQSYSObj (*SRVPGM)');
         endif;

         qFile.name = 'QBASICS1';
         qFile.lib = 'QGPL';
         qFile.mbr = 'PBASICS1';

         qObj.name = 'QBASICS1';
         qObj.lib = 'QGPL';

         object = 'QBASICS1';
         library = 'QGPL';
         member = 'PBASICS1';

         path = f_cvtQSYSObjNameToPath(qFile);
         if (path <> '/QSYS.LIB/QGPL.LIB/QBASICS1.FILE/PBASICS1.MBR');
            kill('Error with qFile');
         endif;

         qQSYSObj2 = f_cvtPathToQSYSObjName(path);
         if (qQSYSObj2.name <> object or
             qQSYSObj2.lib <> library or
             qQSYSObj2.mbr <> member or
             qQSYSObj2.type <> '*FILE');
            kill('Error with qQSYSObj2 from qFile');
         endif;

         path = f_cvtQSYSObjNameToPath(qFile: '*FILE');
         if (path <> '/QSYS.LIB/QGPL.LIB/QBASICS1.FILE/PBASICS1.MBR');
            kill('Error with qFile and object type *FILE');
         endif;

         qQSYSObj2 = f_cvtPathToQSYSObjName(path);
         if (qQSYSObj2.name <> object or
             qQSYSObj2.lib <> library or
             qQSYSObj2.mbr <> member or
             qQSYSObj2.type <> '*FILE');
            kill('Error with qQSYSObj2 from qFile');
         endif;

         monitor;
            path = f_cvtQSYSObjNameToPath(qFile: '*PGM');
            kill('Error with qFile and object type *PGM');
         on-error;
            // Exception seen
         endmon;

         path = f_cvtQSYSObjNameToPath(qObj: '*DTAARA');
         if (path <> '/QSYS.LIB/QGPL.LIB/QBASICS1.DTAARA');
            kill('Error with qObj and object type *DTAARA');
         endif;

         qQSYSObj2 = f_cvtPathToQSYSObjName(path);
         if (qQSYSObj2.name <> object or
             qQSYSObj2.lib <> library or
             qQSYSObj2.mbr <> '' or
             qQSYSObj2.type <> '*DTAARA');
            kill('Error with qQSYSObj2 from qObj and object type *DTAARA');
         endif;

         path = f_cvtQSYSObjNameToPath(library: '*LIB');
         if (path <> '/QSYS.LIB/QGPL.LIB');
            kill('Error with library and object type *LIB');
         endif;

         qQSYSObj2 = f_cvtPathToQSYSObjName(path);
         if (qQSYSObj2.name <> library or
             qQSYSObj2.lib <> '' or
             qQSYSObj2.mbr <> '' or
             qQSYSObj2.type <> '*LIB');
            kill('Error with qQSYSObj2 from library and object type *LIB');
         endif;

         path = f_cvtQSYSObjNameToPath(object: '*OUTQ');
         if (path <> '/QSYS.LIB/%LIBL%.LIB/QBASICS1.OUTQ');
            kill('Error with object and object type *OUTQ');
         endif;

         qQSYSObj2 = f_cvtPathToQSYSObjName(path);
         if (qQSYSObj2.name <> object or
             qQSYSObj2.lib <> '*LIBL' or
             qQSYSObj2.mbr <> '' or
             qQSYSObj2.type <> '*OUTQ');
            kill('Error with qQSYSObj2 from object and object type *OUTQ');
         endif;

         path = f_cvtQSYSObjNameToPath(object: library: '*MSGQ');
         if (path <> '/QSYS.LIB/QGPL.LIB/QBASICS1.MSGQ');
            kill('Error with object/library and object type *MSGQ');
         endif;

         qQSYSObj2 = f_cvtPathToQSYSObjName(path);
         if (qQSYSObj2.name <> object or
             qQSYSObj2.lib <> library or
             qQSYSObj2.mbr <> '' or
             qQSYSObj2.type <> '*MSGQ');
            kill('Error with qQSYSObj2 from object, library and +
                  object type *MSGQ');
         endif;

         path = f_cvtQSYSObjNameToPath(object: library: member: '*FILE');
         if (path <> '/QSYS.LIB/QGPL.LIB/QBASICS1.FILE/PBASICS1.MBR');
            kill('Error with object/library/member and object type *FILE');
         endif;

         monitor;
            path = f_cvtQSYSObjNameToPath(object: library: member: '*PGM');
            kill('Error with qFile and object type *PGM');
         on-error;
            // Exception seen
         endmon;

         return;

      /END-FREE
      *
     P main...
     P                 E
      *
