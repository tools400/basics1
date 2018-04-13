      *===============================================================*
      *    CALL PGM(TEST_R6_02) PARM('de.tools400.test_r6_02.')       *
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
     D                 PR                         extpgm('TEST_R6_02')
     D  gi_prefix                    32A   const
      *
     D main...
     D                 PR
     D  i_prefix                     32A   const  varying
      *
      *===============================================================*
      *  Program Entry Point
      *===============================================================*
      *
     D PGM_ENTRY_POINT...
     D                 PI
     D  gi_prefix                    32A   const
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         main(%trim(gi_prefix));

         *inlr = *on;

         return;

      /END-FREE
      *
      *===============================================================*
      *  Main procedure
      *===============================================================*
     P main...
     P                 B
      *
     D main...
     D                 PI
     D  i_prefix                     32A   const varying
      *
      *  Helper fields
     D isError         S               N                     inz(cFalse)
     D x               S             10I 0                   inz
     D numEnvVar       S             10I 0                   inz
     D envVar          DS                  likeds(envVar_t ) inz
     D msg             DS                  likeds(msg_t    ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // Get number of environment variables
         numEnvVar = f_getNumEnvVar();

         // Check environment variables for prefix
         for x = 1 to numEnvVar;
            envVar = f_getEnvVarByIndex(x);

            // If an existing variable starts with the
            // given prefix ...
            if %len(envVar.name) >= %len(i_prefix);
               if f_left(envVar.name: %len(i_prefix)) =
                                               f_left(i_prefix: %len(i_prefix));
                  // ... then tell the user that we can't proceed.
                  msg = f_newMsg('CPF9897':
                                 'ERROR - Found variable starting with: ' +
                                 envVar.name + '. Can''t proceed!');
                  f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
                  isError = cTrue;
               endif;
            endif;
         endfor;

         // If there is no variable that starts with the
         // given prefix ...
         if not isError;

            // ... add some variables to the environment
            f_setEnvVar(i_prefix + 'var1': 'Hello World');
            f_setEnvVar(i_prefix + 'var2': 'A Spaceman came travelling ...');

            // ... spinn through all of the variables
            numEnvVar = f_getNumEnvVar();

            for x = 1 to numEnvVar;
               envVar = f_getEnvVarByIndex(x);
               // ... and show them
               msg = f_newMsg('CPF9897': 'Found variable: ' + envVar.name +
                                                      ' = ' + envVar.value);
               f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
            endfor;

            // ... finally remove the environment variables we
            //     just added before.
            f_delEnvVar(i_prefix + 'var1');
            f_delEnvVar(i_prefix + 'var2');

         endif;

         return;

      /END-FREE
      *
     P main...
     P                 E
      *
