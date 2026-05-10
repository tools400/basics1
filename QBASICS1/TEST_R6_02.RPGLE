**free
//===============================================================*
//    CALL PGM(TEST_R6_02) PARM('de.tools400.test_r6_02.')       *
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

dcl-pr PGM_ENTRY_POINT extpgm('TEST_R6_02');
  gi_prefix char(32) options(*nopass) const;
end-pr;

dcl-pr main;
  i_prefix varchar(32) const;
end-pr;

//===============================================================*
//  Program Entry Point
//===============================================================*
dcl-pi PGM_ENTRY_POINT;
  gi_prefix char(32) options(*nopass) const;
end-pi;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if (%parms() >= %parmNum(gi_prefix));
  main(%trim(gi_prefix));
else;
  main('TEST_R6_02_');
endif;

*inlr = *on;

return;


//===============================================================*
//  Main procedure
//===============================================================*
dcl-proc main;
  dcl-pi *n;
    i_prefix varchar(32) const;
  end-pi;

  //  Helper fields
  dcl-s isError ind inz(cFalse);
  dcl-s x int(10) inz;
  dcl-s numEnvVar int(10) inz;
  dcl-ds envVar likeds(envVar_t) inz;
  dcl-ds msg likeds(msg_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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


end-proc main;
