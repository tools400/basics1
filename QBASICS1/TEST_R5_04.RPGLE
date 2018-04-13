      *===============================================================*
      *  CALL PGM(TEST_R5_04)                                         *
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
     D                 PR                         extpgm('TEST_R5_04')
      *
     D main...
     D                 PR
      *
      *  Returns the user space size choosen by the i5/OS based on
      *  an given size.
     D OS_getUsrSpcSize...
     D                 PR            10I 0
     D i_size                        10I 0 const
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
      *  Returns the user space size choosen by the i5/OS based on
      *  an given size.
      *===============================================================*
     P OS_getUsrSpcSize...
     P                 B
      *
     D OS_getUsrSpcSize...
     D                 PI            10I 0
     D i_size                        10I 0 const
      *
      *  Return value
     D size            S             10I 0 inz
      *
      *  Disk page size
     D cPAGE_SIZE      C                   4096
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         size = %int(i_size / cPAGE_SIZE) * cPAGE_SIZE;

         if (size <> i_size);
            size = size + cPAGE_SIZE;
         endif;

         size = size - 512;   // User space administration attributes

         return size;

      /END-FREE
      *
     P OS_getUsrSpcSize...
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
     D size            S             10I 0 inz
     D isAutoExt       S               N   inz
     D initValue       S              1A   inz
     D qUsrSpc         DS                  likeds(qObj_t    ) inz
     D msg             DS                  likeds(msg_t     ) inz
     D tmpMsg          DS                  likeds(msg_t     ) inz
      *
     D cDEFAULT_SIZE   C                   512
     D cBIG_SIZE       C                   7200
     D cDEFAULT_AUTO_EXT...
     D                 C                   '0'
     D cDEFAULT_INIT_VALUE...
     D                 S              1A   inz(x'00')
     D cNEW_INIT_VALUE...
     D                 S              1A   inz('X')
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         msg = f_newMsg(cMSG_ID_OK);

         qUsrSpc = f_getTmpName();

         dou '1';

            // create user space
            if (not f_crtUsrSpc(qUsrSpc.name: qUsrSpc.lib
                                : 'Test BASICS1: user space'
                                : cDEFAULT_SIZE
                                : 'TEST'
                                : '*USE'
                                : msg));
               leave;
            endif;

            // check user space size
            size = f_getUsrSpcSize(qUsrSpc.name: qUsrSpc.lib: msg);
            if (size < 0);
               leave;
            endif;

            if (size <> OS_getUsrSpcSize(cDEFAULT_SIZE));
               msg = f_newMsg('CPF9898': 'User space size ' + %char(size) +
                              ' does not match expected value ' +
                              %char(OS_getUsrSpcSize(cDEFAULT_SIZE)));
               leave;
            endif;

            // change user space size
            size = f_chgUsrSpcSize(qUsrSpc.name: qUsrSpc.lib: cBIG_SIZE: msg);
            if (size < 0);
               leave;
            endif;

            // check new user space size which was returned by f_chgUsrSpcSize()
            if (size <> OS_getUsrSpcSize(cBIG_SIZE));
               msg = f_newMsg('CPF9898': 'User space size ' + %char(size) +
                              ' does not match expected value ' +
                              %char(OS_getUsrSpcSize(cDEFAULT_SIZE)));
               leave;
            endif;

            // check user space automatic extendibility attribute
            isAutoExt = f_getUsrSpcAutoExt(qUsrSpc.name: qUsrSpc.lib: msg);
            if (msg.ID <> cMSG_ID_OK);
               leave;
            endif;

            if (isAutoExt <> cDEFAULT_AUTO_EXT);
               msg = f_newMsg('CPF9898'
                              : 'User space automatic extendibility ''' +
                                isAutoExt +
                                ''' does not match expected value ' +
                                cDEFAULT_AUTO_EXT);
               leave;
            endif;

            // change user space automatic extendibility
            isAutoExt = f_chgUsrSpcAutoExt(qUsrSpc.name: qUsrSpc.lib
                                           : not cDEFAULT_AUTO_EXT: msg);

            // check new user space automatic extendibility which
            // was returned by f_chgUsrSpcAutoExt()
            if (isAutoExt <> not cDEFAULT_AUTO_EXT);
               msg = f_newMsg('CPF9898'
                              : 'User space automatic extendibility ''' +
                                 isAutoExt +
                                 ''' does not match expected value ''' +
                                 not cDEFAULT_AUTO_EXT + '''');
               leave;
            endif;

            // check user space initial value
            initValue = f_getUsrSpcInitValue(qUsrSpc.name: qUsrSpc.lib: msg);
            if (msg.ID <> cMSG_ID_OK);
               leave;
            endif;

            if (initValue <> cDEFAULT_INIT_VALUE);
               msg = f_newMsg('CPF9898'
                    : 'User space initial value x''' +
                      f_cvtBufferToHexString(%addr(initValue): 1) +
                      ''' does not match expected value x''' +
                      f_cvtBufferToHexString(%addr(cDEFAULT_INIT_VALUE): 1) +
                      '''');
               leave;
            endif;

            // change user space initial value
            initValue = f_chgUsrSpcInitValue(qUsrSpc.name: qUsrSpc.lib
                                             : cNEW_INIT_VALUE: msg);

            // check new user space initual value which
            // was returned by f_chgUsrSpcInitValue()
            if (initValue <> cNEW_INIT_VALUE);
               msg = f_newMsg('CPF9898'
                        : 'User space initial value x''' +
                          f_cvtBufferToHexString(%addr(initValue): 1) +
                          ''' does not match expected value x''' +
                          f_cvtBufferToHexString(%addr(cNEW_INIT_VALUE): 1) +
                          '''');
               leave;
            endif;

         enddo;

            // delete user space
         if (f_exist(qUsrSpc.name: qUsrSpc.lib: '*USRSPC'));
            if (not f_dltUsrSpc(qUsrSpc.name: qUsrSpc.lib: tmpMsg));
               tmpMsg.ID = cMSG_DIAG;
               f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
            endif;
         endif;

         if (msg.ID <> cMSG_ID_OK);
            msg.type = cMSG_ESCAPE;
            f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
         endif;

         return;

      /END-FREE
      *
     P main...
     P                 E
      *
