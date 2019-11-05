      *=====================================================================*
      *  BASICS1R4  - SrvPgm: Basic Routines - Assert/This/Caller           *
      *=====================================================================*
      *  Author  :  Thomas Raddatz                                          *
      *  Date    :  08.10.2003                                              *
      *  E-mail  :  thomas.raddatz@Tools400.de                              *
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
      *  12.07.2006  Th.Raddatz    Changed f_caller() and f_this() to       *
      *                            return the statement ID as the next      *
      *                            optional parameter.                      *
      *                                                                     *
      *  12.07.2006  Th.Raddatz    Changed p_assert(), f_this() and         *
      *                            f_caller() to use a static buffer of     *
      *                            2048 byte to receive the test message    *
      *                            for better performance.                  *
      *                                                                     *
      *  13.06.2008  Th.Raddatz    Added parameter 'offset' to f_caller().  *
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
      *       >>PARM<< TGTRLS(V7R1M0);                                      *
      *     >>END-COMPILE<<                                                 *
      *                                                                     *
      *     >>EXECUTE<<                                                     *
      *                                                                     *
      *   >>END-PRE-COMPILER<<                                              *
      *=====================================================================*
     H NOMAIN
      *  Standard H-Specs
      /COPY QBASICS1,H_SPEC
      /COPY QBASICS1,COPYRIGHT
      * =================================================================== *
      *
      * -----------------------------------------
      *  Exported functions
      * -----------------------------------------
      /COPY QBASICS1,PBASICS1R4
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
      *  Global constants
      * -----------------------------------------
      *
      * -----------------------------------------
      *  Global fields
      * -----------------------------------------
      *
      *=========================================================================
      *  RPG equivalent of the C Assert macro.
      *=========================================================================
      *  Parameters:
      *   i_condition   - The condition that must be TRUE.
      *   i_msgText     - The message text that is sent in case that
      *                   i_condition is FALSE.
      *                   Default:        *BLANKS
      *
      *  Returns:
      *   void
      *=========================================================================
     P p_assert...
     P                 B                   export
      *
     D p_assert...
     D                 PI
     D  i_condition                    N   const
     D  i_msgText                   128A   const  options(*nopass)
      *
      *  Make sure that the p_assert procedure is not included
      *  when the condition name COMPILE_NO_DEBUG is specified at
      *  the CRTRPGMOD command.
      /IF NOT DEFINED (COMPILE_NO_DEBUG)
      *
      *  Positions of optional parameters
     D p_msgText       C                   const(2)
      *
      *  Fields for optional parameters
     D msgText         S                   like(i_msgText ) inz
      *
      *  Local constants
     D cTEXT_MSG       C                   const('Who is before me?')
      *
      *  Helper fields QMHSNDPM/QMHRCVPM
     D qMsgF           DS                  likeds(qObj_t     )  inz
     D msgKey          S              4A   inz
     D errCode         DS                  likeds(errCode_t  )  inz
     D callStkEQ       DS                  qualified
     D  module                 1     10A                      inz
     D  program               11     20A                      inz
      *
      *  Helper fields QMHRCVPM
     D memSize         S             10I 0 inz
     D sndInf          DS                  likeds(sndInf_t  ) based(pSndInf  )
     D rcvm0300        DS                  likeds(rcvm0300_t) based(pRcvm0300)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         if   not i_condition;

            // Process optional parameters
            if   %parms >= p_msgText;
               msgText = i_msgText;
            else;
               msgText = '*N';
            endif;

            // Send a test message
            clear   qMsgF;
            qMsgF.name   = 'QCPFMSG';
            qMsgF.lib    = '*LIBL';
            errCode      = f_newApiErrCode(cTrue);
            callStkEQ.module  = '*NONE';
            callStkEQ.program = '*NONE';
            qmhsndpm('CPF9897': qMsgF: cTEXT_MSG: %size(cTEXT_MSG): '*INFO':
                     '*': 1: msgKey: errCode: 1: callStkEQ: 0);

            if   not f_isApiError(errCode);
               memSize   = 2048;
               pRcvm0300 = %alloc(memSize);
               errCode   = f_newApiErrCode(cTrue);
               callStkEQ.module  = '*NONE';
               callStkEQ.program = '*NONE';
               qmhrcvpm(rcvm0300: memSize: 'RCVM0300':
                        '*': 1: '*INFO': msgKey: 0: '*REMOVE': errCode:
                        1: callStkEQ);
            endif;

            // If everything worked as designed, ...
            if   not f_isApiError(errCode) and
                     rcvm0300.bytAvl <= memSize;
               // ... then retrieve sender information
               pSndInf = pRcvm0300 + %size(rcvm0300)
                                   + rcvm0300.lenRplDataR
                                   + rcvm0300.lenMsgR
                                   + rcvm0300.lenMsgHlpR;
            else;
               // ... else set sender information to "not available"
               pSndInf = %alloc(%size(sndInf));
               clear   sndInf;
               sndInf.rcvPgm     = '*N';
               sndInf.rcvModule  = '*N';
               sndInf.rcvProc    = '*N';
               sndInf.rcvPgmStmtNbr(1) = '*N';
            endif;

            // Create "assert" message
            msgText = %trimr(sndInf.rcvPgm    ) + '/'  +
                      %trimr(sndInf.rcvModule ) + '.'  +
                      %trimr(sndInf.rcvProc   ) + ' (' +
                      'Stmt: '                         +
                      %trimr(sndInf.rcvPgmStmtNbr(1)) + ') ' +
                      ': ' + %trim(msgText);

            // Free memory
            if   pRcvm0300 <> *NULL;
               dealloc(N)   pRcvm0300;
            else;
               if   pSndInf <> *NULL;
                  dealloc(N) pSndInf;
               endif;
            endif;

            // Send "assert" *ESCAPE message
            msgKey  = ' ';
            errCode = f_newApiErrCode(cTrue);
            callStkEQ.module  = '*NONE';
            callStkEQ.program = '*NONE';
            qmhsndpm('CPF9898': qMsgF: msgText: %size(msgText): '*ESCAPE':
                     '*': 1: msgKey: errCode: 1: callStkEQ: 0);

         endif;

      /END-FREE
      /ENDIF
      *
     C                   return
      *
     P p_assert...
     P                 E
      *
      *=========================================================================
      *  Returns the procedure, module and program name
      *  of the current procedure.
      *=========================================================================
      *  Parameters:
      *   o_module      - The module that contains the procedure.
      *   o_program     - The program that contains the module.
      *
      *  Returns:
      *   procedure     - The name of the procedure that called f_this.
      *=========================================================================
     P f_this...
     P                 B                   export
      *
     D f_this...
     D                 PI           256A          varying
     D  o_module                     10A          options(*nopass: *omit)
     D  o_program                    10A          options(*nopass: *omit)
     D  o_stmtID                     10A          options(*nopass: *omit)
      *
      *  Return value
     D procedure       S            256A   inz    varying
      *
      *  Positions of optional parameters
     D p_module        C                   const(1)
     D p_program       C                   const(2)
     D p_stmtID        C                   const(3)
      *
      *  Fields for optional parameters
     D module          S                   like(o_module  ) inz
     D program         S                   like(o_program ) inz
     D stmtID          S                   like(o_stmtID  ) inz
      *
      *  Local constants
     D cTEXT_MSG       C                   const('Who is before me?')
      *
      *  Helper fields QMHSNDPM/QMHRCVPM
     D qMsgF           DS                  likeds(qObj_t     )  inz
     D msgKey          S              4A   inz
     D errCode         DS                  likeds(errCode_t  )  inz
     D callStkEQ       DS                  qualified
     D  module                 1     10A                      inz
     D  program               11     20A                      inz
      *
      *  Helper fields QMHRCVPM
     D memSize         S             10I 0 inz
     D sndInf          DS                  likeds(sndInf_t  ) based(pSndInf  )
     D rcvm0300        DS                  likeds(rcvm0300_t) based(pRcvm0300)
      *
      *  Helper fields CEETSTA
     D isPresent       S             10I 0                  inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // Send a test message
         clear   qMsgF;
         qMsgF.name   = 'QCPFMSG';
         qMsgF.lib    = '*LIBL';
         errCode      = f_newApiErrCode(cTrue);
         callStkEQ.module  = '*NONE';
         callStkEQ.program = '*NONE';
         qmhsndpm('CPF9897': qMsgF: cTEXT_MSG: %size(cTEXT_MSG): '*INFO':
                  '*': 1: msgKey: errCode: 1: callStkEQ: 0);

         if   not f_isApiError(errCode);
            memSize   = 2048;
            pRcvm0300 = %alloc(memSize);
            errCode   = f_newApiErrCode(cTrue);
            callStkEQ.module  = '*NONE';
            callStkEQ.program = '*NONE';
            qmhrcvpm(rcvm0300: memSize: 'RCVM0300':
                     '*': 1: '*INFO': msgKey: 0: '*REMOVE': errCode:
                     1: callStkEQ);
         endif;

         // If everything worked as designed, ...
         if   not f_isApiError(errCode) and
                  rcvm0300.bytAvl <= memSize;
            // ... then retrieve sender information
            pSndInf = pRcvm0300 + %size(rcvm0300)
                                + rcvm0300.lenRplDataR
                                + rcvm0300.lenMsgR
                                + rcvm0300.lenMsgHlpR;
            procedure = %trimR(sndInf.rcvProc);
            module    = sndInf.rcvModule;
            program   = sndInf.rcvPgm;
            stmtID    = sndInf.rcvPgmStmtNbr(1);
         else;
            procedure = '*N';
            module    = '*N';
            program   = '*N';
            stmtID    = '*N';
         endif;

         // Free memory
         if   pRcvm0300 <> *NULL;
            dealloc(N)   pRcvm0300;
         endif;

         // Process optional output parameters ...
         // .. o_module
         if   %parms >= p_module;
            CEETSTA(isPresent: p_module: *omit);
         else;
            isPresent = 0;
         endif;

         if   isPresent = 1;
            o_module = module;
         endif;

         // .. o_program
         if   %parms >= p_program;
            CEETSTA(isPresent: p_program: *omit);
         else;
            isPresent = 0;
         endif;

         if   isPresent = 1;
            o_program = program;
         endif;

         // .. o_stmtID
         if   %parms >= p_stmtID;
            CEETSTA(isPresent: p_stmtID: *omit);
         else;
            isPresent = 0;
         endif;

         if   isPresent = 1;
            o_stmtID = stmtID;
         endif;

         return   procedure;

      /END-FREE
      *
     P f_this...
     P                 E
      *
      *=========================================================================
      *  Returns the procedure, module and program name
      *  that called the current procedure.
      *=========================================================================
      *  Parameters:
      *   o_module      - The module that contains the procedure.
      *   o_program     - The program that contains the module.
      *
      *  Returns:
      *   procedure     - The name of the caller of the procedure
      *                   that called f_caller.
      *=========================================================================
     P f_caller...
     P                 B                   export
      *
     D f_caller...
     D                 PI           256A          varying
     D  o_module                     10A          options(*nopass: *omit)
     D  o_program                    10A          options(*nopass: *omit)
     D  o_stmtID                     10A          options(*nopass: *omit)
     D  i_offset                      3I 0 const  options(*nopass: *omit)
      *
      *  Return value
     D procedure       S            256A   inz    varying
      *
      *  Positions of optional parameters
     D p_module        C                   const(1)
     D p_program       C                   const(2)
     D p_stmtID        C                   const(3)
     D p_offset        C                   const(4)
      *
      *  Fields for optional parameters
     D module          S                   like(o_module  ) inz
     D program         S                   like(o_program ) inz
     D stmtID          S                   like(o_stmtID  ) inz
     D offset          S                   like(i_offset  ) inz(0)
      *
      *  Local constants
     D cTEXT_MSG       C                   const('Who is before me?')
      *
      *  Helper fields QMHSNDPM/QMHRCVPM
     D qMsgF           DS                  likeds(qObj_t     )  inz
     D msgKey          S              4A   inz
     D errCode         DS                  likeds(errCode_t  )  inz
     D callStkEQ       DS                  qualified
     D  module                 1     10A                      inz
     D  program               11     20A                      inz
      *
      *  Helper fields QMHRCVPM
     D memSize         S             10I 0 inz
     D sndInf          DS                  likeds(sndInf_t  ) based(pSndInf  )
     D rcvm0300        DS                  likeds(rcvm0300_t) based(pRcvm0300)
      *
      *  Helper fields CEETSTA
     D isPresent       S             10I 0                  inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // Get optional input parameters ...
         // .. i_offset
         if (%parms() >= p_offset and %addr(i_offset) <> *NULL);
            offset = i_offset;
         endif;

         // Send a test message
         clear   qMsgF;
         qMsgF.name   = 'QCPFMSG';
         qMsgF.lib    = '*LIBL';
         errCode      = f_newApiErrCode(cTrue);
         callStkEQ.module  = '*NONE';
         callStkEQ.program = '*NONE';
         qmhsndpm('CPF9897': qMsgF: cTEXT_MSG: %size(cTEXT_MSG): '*INFO':
                  '*': 2+offset: msgKey: errCode: 1: callStkEQ: 0);

         if   not f_isApiError(errCode);
            // Receive and remove test message
            memSize   = 2048;
            pRcvm0300 = %alloc(memSize);
            errCode   = f_newApiErrCode(cTrue);
            callStkEQ.module  = '*NONE';
            callStkEQ.program = '*NONE';
            qmhrcvpm(rcvm0300: memSize: 'RCVM0300':
                     '*': 2+offset: '*INFO': msgKey: 0: '*REMOVE': errCode:
                     1: callStkEQ);
         endif;

         // If everything worked as designed, ...
         if   not f_isApiError(errCode) and
                  rcvm0300.bytAvl <= memSize;
            // ... then retrieve sender information
            pSndInf = pRcvm0300 + %size(rcvm0300)
                                + rcvm0300.lenRplDataR
                                + rcvm0300.lenMsgR
                                + rcvm0300.lenMsgHlpR;
            procedure = %trimR(sndInf.rcvProc);
            module    = sndInf.rcvModule;
            program   = sndInf.rcvPgm;
            stmtID    = sndInf.rcvPgmStmtNbr(1);
         else;
            procedure = '*N';
            module    = '*N';
            program   = '*N';
            stmtID    = '*N';
         endif;

         // Free memory
         if   pRcvm0300 <> *NULL;
            dealloc(N)   pRcvm0300;
         endif;

         // Process optional output parameters ...
         // .. o_module
         if   %parms >= p_module;
            CEETSTA(isPresent: p_module: *omit);
         else;
            isPresent = 0;
         endif;

         if   isPresent = 1;
            o_module = module;
         endif;

         // .. o_program
         if   %parms >= p_program;
            CEETSTA(isPresent: p_program: *omit);
         else;
            isPresent = 0;
         endif;

         if   isPresent = 1;
            o_program = program;
         endif;

         // .. o_stmtID
         if   %parms >= p_stmtID;
            CEETSTA(isPresent: p_stmtID: *omit);
         else;
            isPresent = 0;
         endif;

         if   isPresent = 1;
            o_stmtID = stmtID;
         endif;

         return   procedure;

      /END-FREE
      *
     P f_caller...
     P                 E
      *
