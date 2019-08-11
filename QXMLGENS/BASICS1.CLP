/* --------------------------------------------------------------- */
/* BASICS1    - SCRIPT MEMBER                                      */
/* Use commands  xmlgenINC (generate text for install pgm)         */
/*               xmlgenMBR (to define source members               */
/*               xmlgenCMD (execute qcmdexc at run time            */
/* Put &TOLIB where you want user selected lib at run time.        */
   DCL &TOLIB *CHAR 10
/* --------------------------------------------------------------- */
             XMLGENINC  XINCLUDE(*YES)

             XMLGENVRS XSRCFILE(QBASICS1) XSRCLIB(TOOLS400) XSRCMBR(COPYRIGHT)

             XMLGENCND  XMSG('Create sample programs? (YES, NO)') +
                          XVALUES(YES NO) XVAR(&CRTTSTPGM)

             XMLGENCND  XMSG('C-Compiler available? (C_YES, C_NO)') +
                          XVALUES(C_YES C_NO) XVAR(&C_COMP)

             XMLGENSET  XVAR(&SRCFILE  ) XVALUE(QBASICS1)

/* ---------------------------------- */
/*  Deploy source member              */
/* ---------------------------------- */
             XMLGENMBR  XMBR(A_INSTALL ) XMBRATR(CLLE  ) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(A_README   ) XMBRATR(TXT  ) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(BASICS1   ) XMBRATR(BND  ) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(BASICS1C7 ) XMBRATR(CLE  ) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(BASICS1RA ) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(BASICS1RB ) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(BASICS1RC ) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(BASICS1RD ) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(BASICS1RE ) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(BASICS1RF ) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(BASICS1RG ) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(BASICS1RH ) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(BASICS1R0 ) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(BASICS1R1 ) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(BASICS1R2 ) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(BASICS1R3 ) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(BASICS1R4 ) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(BASICS1R5 ) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(BASICS1R6 ) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(BASICS1R7 ) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(BASICS1R8 ) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(BASICS1R9 ) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(CEELIB    ) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(CLIB      ) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(COPYRIGHT ) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(FDENVVAR  ) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(FDERRCODE ) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(FDINFDS   ) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(FDMBRD0100) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(FDMBRD0200) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(FDMSG     ) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(FDOBJD0100) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(FDQFILE   ) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(FDQOBJ    ) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(FDQQSYSOBJ) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(FDRCVM0200) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(FDRCVM0300) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(FDRTVM0100) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(FDRTVM0300) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(FDRTVM0400) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(FDURL     ) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(H_SPEC    ) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(HEAPAPI   ) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(MEMMGR    ) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(MILIB     ) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(PBASICS1  ) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(PBASICS1C7) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(PBASICS1RA) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(PBASICS1RB) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(PBASICS1RC) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(PBASICS1RD) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(PBASICS1RE) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(PBASICS1RF) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(PBASICS1RG) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(PBASICS1RH) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(PBASICS1R1) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(PBASICS1R2) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(PBASICS1R3) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(PBASICS1R4) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(PBASICS1R5) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(PBASICS1R6) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(PBASICS1R7) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(PBASICS1R8) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(PBASICS1R9) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(QP0LCVTPAT) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(QUSRSPC   ) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(QWCCVTDT  ) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(QWCRSVAL  ) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(TEST_F000 ) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(TEST_RA_01) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(TEST_RA_02) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(TEST_RA_03) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(TEST_RB_01) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(TEST_RC_01) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(TEST_RC_02) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(TEST_RC_03) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(TEST_RC_04) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(TEST_RC_05) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(TEST_RD_01) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(TEST_RE_01) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(TEST_RH_01) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(TEST_R1_01) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(TEST_R1_02) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(TEST_R1_03) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(TEST_R2_01) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(TEST_R3_01) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(TEST_R3_02) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(TEST_R3_03) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(TEST_R3_04) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(TEST_R3_05) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(TEST_R3_06) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(TEST_R3_07) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(TEST_R3_08) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(TEST_R3_09) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(TEST_R3_10) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(TEST_R3_11) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(TEST_R3_12) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(TEST_R3_13) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(TEST_R3_14) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(TEST_R4_01) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(TEST_R5_01) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(TEST_R5_02) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(TEST_R5_03) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(TEST_R5_04) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(TEST_R5_05) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(TEST_R6_01) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(TEST_R6_02) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(TEST_R7_01) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(TEST_R7_02) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(TEST_R7_03) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(TEST_R7_04) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(TEST_R7_05) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(TEST_R7_06) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(TEST_R7_07) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(TEST_R7_08) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(TEST_R7_09) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(TEST_R8_01) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(TEST_R8_02) XMBRATR(RPGLE) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(ZCONF     ) XMBRATR(H    ) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(ZLIB      ) XMBRATR(H    ) +
                          XFROMSRCF(QBASICS1  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QBASICS1  ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

/* ---------------------------------- */
/*  Create objects                    */
/* ---------------------------------- */
             XMLGENCMD  XCMD(CRTBNDCL PGM(&TOLIB/A_INSTALL) +
                          SRCFILE(&TOLIB/&SRCFILE) SRCMBR(*PGM) +
                          DFTACTGRP(*NO) ACTGRP(*NEW) +
                          DBGVIEW(*LIST)) XDLTSPLF(A_INSTALL)

             XMLGENCMD  XCMD(CALL PGM(&TOLIB/A_INSTALL) +
                             PARM('&TGTRLS' '&SRCFILE' '&TOLIB' '&CRTTSTPGM' '&C_COMP' ))
             XMLGENCMD  XCMD(DLTPGM PGM(&TOLIB/A_INSTALL))

