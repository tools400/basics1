**FREE
//===============================================================*
//  CALL PGM(TEST_R5_04)                                         *
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
//                              TGTRLS(*CURRENT) +               *
//                              DETAIL(*BASIC);                  *
//                                                               *
//   >>END-PRE-COMPILER<<                                        *
//===============================================================*
ctl-opt DEBUG OPTION(*SRCSTMT : *NODEBUGIO);
ctl-opt DECEDIT('0,') DATEDIT(*DMY.);
ctl-opt DATFMT(*ISO )  TIMFMT(*ISO );
ctl-opt EXPROPTS(*RESDECPOS);
ctl-opt EXTBININT(*YES);
//===============================================================*

// ------------------------------------
//  Type Definitions
// ------------------------------------

// ------------------------------------
//  External Prototypes
// ------------------------------------
/COPY QBASICS1,PBASICS1

// ------------------------------------
//  Global Fields
// ------------------------------------

// ------------------------------------
//  Global Constants
// ------------------------------------

// ------------------------------------
//  Prototypes
// ------------------------------------

dcl-pr PGM_ENTRY_POINT
       extpgm('TEST_R5_04');
end-pr;

dcl-pr main;
end-pr;

//  Returns the user space size choosen by the i5/OS based on
//  an given size.
dcl-pr OS_getUsrSpcSize
       int(10);
  i_size          int(10) const;
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
//  Returns the user space size choosen by the i5/OS based on
//  an given size.
//===============================================================*
dcl-proc OS_getUsrSpcSize;

dcl-pi OS_getUsrSpcSize
       int(10);
  i_size          int(10) const;
end-pi;

//  Return value
dcl-s size            int(10) inz;

//  Disk page size
dcl-c cPAGE_SIZE 4096;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

size = %int(i_size / cPAGE_SIZE) * cPAGE_SIZE;

if (size <> i_size);
   size = size + cPAGE_SIZE;
endif;

// Not valid on 7.3
// size = size - 512;   // User space administration attributes

return size;


end-proc OS_getUsrSpcSize;

//===============================================================*
//  Main procedure
//===============================================================*
dcl-proc main;

dcl-pi main;
end-pi;

//  Helper fields
dcl-s size            int(10) inz;
dcl-s isAutoExt       ind inz;
dcl-s initValue       char(1) inz;
dcl-ds qUsrSpc likeds(qObj_t    ) inz;
dcl-ds msg likeds(msg_t     ) inz;
dcl-ds tmpMsg likeds(msg_t     ) inz;

dcl-c cDEFAULT_SIZE 512;
dcl-c cBIG_SIZE 7200;
dcl-c cDEFAULT_AUTO_EXT
      '0';
dcl-s cDEFAULT_INIT_VALUE
      char(1) inz(x'00');
dcl-s cNEW_INIT_VALUE
      char(1) inz('X');
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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


end-proc main;

