      *=====================================================================*
      *  BASICS1R5  - SrvPgm: Basic Routines - Objects                      *
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
      *  17.12.2008  Th.Raddatz    Added f_getObjLib().                     *
      *                            Changed parameter i_text of procedure    *
      *                            f_crtUsrSpc() from 10A to 50A.           *
      *                                                                     *
      *  13.01.2009  Th.Raddatz    Added procedures:                        *
      *                            - f_chgUsrSpcSize()                      *
      *                            - f_getUsrSpcSize()                      *
      *                            - f_chgUsrSpcAutoExt()                   *
      *                            - f_getUsrSpcAutoExt()                   *
      *                            - f_chgUsrSpcInitValue()                 *
      *                            - f_getUsrSpcInitValue()                 *
      *                                                                     *
      *  26.04.2016  Th.Raddatz    Replaced %trimR(... : x'00') with        *
      *                            %str(%addr(...)) to get compatible with  *
      *                            V5R2.                                    *
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
     H NOMAIN
      *  Standard H-Specs
      /COPY QBASICS1,H_SPEC
      /COPY QBASICS1,COPYRIGHT
      *=====================================================================*
      *
      * -----------------------------------------
      *  Exported functions
      * -----------------------------------------
      /COPY QBASICS1,PBASICS1R5
      *
      * -----------------------------------------
      *  Reference fields
      * -----------------------------------------
      /COPY QBASICS1,BASICS1R0
      *
      * -----------------------------------------
      *  Imported prototypes
      * -----------------------------------------
      /COPY QBASICS1,QUSRSPC                       User Space APIs
      /COPY QBASICS1,CEELIB                        CEE APIs
      /COPY QBASICS1,QP0LCVTPAT                    Qp0lCvtPathToQSYSObjName()--Resolve Path
      *
      * -----------------------------------------
      *  Private prototypes
      * -----------------------------------------
      *
      *  Retrieves the attributes of a given user space.
     D rtvUsrSpcAttr...
     D                 PR                         likeds(spca0100_t )
     D  i_usrSpc                     10A   const
     D  i_lib                        10A   const  options(*nopass: *omit)
     D  o_msg                                     likeds(msg_t    )
     D                                            options(*nopass: *omit)
      *
      *  Changes an attribute of a given user space.
     D chgUsrSpcAttr...
     D                 PR              N
     D  i_usrSpc                     10A   const
     D  i_lib                        10A   const  options(*omit)
     D  i_attr                      128A   const
     D  o_msg                                     likeds(msg_t    )
     D                                            options(*nopass: *omit)
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
      *  Checks object existance.
      *=========================================================================
      *  Parameters:
      *   i_obj         - The object to check for existance.
      *   i_lib         - The library that contains the object.
      *                   Default:        *LIBL
      *   i_type        - The type of the object.
      *   i_mbr         - The member that is checked in case of that
      *                   the object is a file.
      *                   Default:        *NONE
      *
      *  Returns:
      *   doesExists    - Returns cTrue when the object exists.
      *=========================================================================
      *
     P f_exist...
     P                 B                   export
      *
     D f_exist...
     D                 PI              N
     D  i_obj                        10A   const
     D  i_lib                        10A   const  options(*omit)
     D  i_type                       10A   const
     D  i_mbr                        10A   const  options(*nopass)
      *
      *  Return value
     D doesExist       S               N   inz(cFalse)
      *
      *  Parameter positions
     D p_lib           C                   const(2)
     D p_mbr           C                   const(4)
      *
      *  Optional parameter fields
     D lib             S                   like(i_lib       ) inz
     D mbr             S                   like(i_mbr       ) inz
      *
      *  Local fields
     D objd0100        DS                  likeds(objd0100_t) inz
     D mbrd0100        DS                  likeds(mbrd0100_t) inz
     D msg             DS                  likeds(msg_t     ) inz
      *
      *  Helper fields CEETSTA
     D isPresent       S             10I 0                  inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // Process optional parameter values ...
         // ... i_lib
         if   %parms >= p_lib;
            CEETSTA(isPresent: p_lib: *omit);                                              //R
         else;
            isPresent = 0;
         endif;

         if   isPresent = 1;
            lib = i_lib;
         else;
            lib = '*LIBL';
         endif;

         // ... i_mbr
         if   %parms >= p_mbr;
            mbr = i_mbr;
         else;
            mbr = '*NONE';
         endif;

         // Retrieve the object description
         objd0100 = f_rtvObjD(i_obj: lib: i_type: 'OBJD0100': msg);

         // Retrieve member description if object is a file
         // and a member name was given
         if   (msg.ID = cMSG_ID_OK) and (mbr <> '*NONE');
            mbrd0100 = f_rtvMbrD(i_obj: lib: i_mbr: 'MBRD0100': msg);
         endif;

         // Set return value
         if   msg.ID = cMSG_ID_OK;
            doesExist = cTrue;
         else;
            doesExist = cFalse;
         endif;

         return   doesExist;

      /END-FREE
      *
     P f_exist...
     P                 E
      *
      *=========================================================================
      *  Retrieve object description.
      *=========================================================================
      *  Parameters:
      *   i_obj         - The object to retrieve information from.
      *   i_lib         - The library that contains the object.
      *                   Default:        *LIBL
      *   i_type        - The type of the object.
      *   i_format      - The format of the object description.
      *                   Default:        OBJD0100
      *   o_msg         - The API error message.
      *
      *  Returns:
      *   object descr. - Returns the member description of the file member.
      *=========================================================================
      *
     P f_rtvObjD...
     P                 B                   export
      *
     D f_rtvObjD...
     D                 PI          1024A
     D  i_obj                        10A   const
     D  i_lib                        10A   const  options(*omit)
     D  i_type                       10A   const
     D  i_format                      8A   const  options(*nopass: *omit)
     D  o_msg                                     likeds(msg_t    )
     D                                            options(*nopass: *omit)
      *
      *  Return value
     D objD            DS          1024    inz    qualified
     D  bytRet                 1      4I 0
     D  bytAvl                 1      4I 0
      *
      *  Parameter positions
     D p_lib           C                   const(2)
     D p_format        C                   const(4)
     D p_msg           C                   const(5)
      *
      *  Optional parameter fields
     D lib             S                   like(i_lib       ) inz
     D format          S                   like(i_format    ) inz
     D msg             DS                  likeds(o_msg     ) inz
      *
      *  Local fields
     D qObj            DS                  likeds(qObj_t    ) inz
     D errCode         DS                  likeds(errCode_t ) inz
      *
      *  Helper fields CEETSTA
     D isPresent       S             10I 0                  inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // Process optional parameter values ...
         // ... i_lib
         if   %parms >= p_lib;
            CEETSTA(isPresent: p_lib: *omit);                                              //R
         else;
            isPresent = 0;
         endif;

         if   isPresent = 1;
            lib = i_lib;
         else;
            lib = '*LIBL';
         endif;

         // ... i_format
         if   %parms >= p_lib;
            CEETSTA(isPresent: p_format: *omit);
         else;
            isPresent = 0;
         endif;

         if   isPresent = 1;
            format = i_format;
         else;
            format = 'OBJD0100';
         endif;

         // Call the retrieve object description API
         qObj.name = i_obj;
         qObj.lib  = i_lib;
         errCode   = f_newApiErrCode(cTrue);
         QUSROBJD(objD: %size(objD): format: qObj: i_type: errCode);

         // Set message value
         msg = f_cvtApiErrCodeToMsg(errCode);

         // Check length of receiver variable
         if   not f_isApiError(errCode);
            p_assert(objD.bytRet <= objD.bytAvl:
                     'Length of receiver variable objD is +
                      to small to hold result');
         endif;

         // Process optional/omissible message parameter
         if   %parms >= p_msg;
            CEETSTA(isPresent: p_msg: *omit);
            if   isPresent = 1;
               o_msg = msg;
            endif;
         else;
            if   msg.ID <> cMSG_ID_OK;
               f_sndPgmMsg(msg: cMsg_Prv);
            endif;
         endif;

         return   objD;

      /END-FREE
      *
     P f_rtvObjD...
     P                 E
      *
      *=========================================================================
      *  Retrieve member description.
      *=========================================================================
      *  Parameters:
      *   i_file        - The file that contains the member to retrieve
      *                   information from.
      *   i_lib         - The library that contains the file.
      *                   Default:        *LIBL
      *   i_mbr         - The name of the member to retrieve information from.
      *   i_format      - The format of the object description.
      *                   Default:        OBJD0100
      *
      *  Returns:
      *   object descr. - Returns the object description of the object.
      *=========================================================================
      *
     P f_rtvMbrD...
     P                 B                   export
      *
     D f_rtvMbrD...
     D                 PI          1024A
     D  i_file                       10A   const
     D  i_lib                        10A   const  options(*omit)
     D  i_mbr                        10A   const
     D  i_format                      8A   const  options(*nopass: *omit)
     D  o_msg                                     likeds(msg_t    )
     D                                            options(*nopass: *omit)
      *
      *  Return value
     D mbrD            DS          1024    inz    qualified
     D  bytRet                 1      4I 0
     D  bytAvl                 1      4I 0
      *
      *  Parameter positions
     D p_lib           C                   const(2)
     D p_format        C                   const(4)
     D p_msg           C                   const(5)
      *
      *  Optional parameter fields
     D lib             S                   like(i_lib       ) inz
     D format          S                   like(i_format    ) inz
     D msg             DS                  likeds(o_msg     ) inz
      *
      *  Local fields
     D qFile           DS                  likeds(qObj_t    ) inz
     D errCode         DS                  likeds(errCode_t ) inz
      *
      *  Helper fields CEETSTA
     D isPresent       S             10I 0                  inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // Process optional parameter values ...
         // ... i_lib
         if   %parms >= p_lib;
            CEETSTA(isPresent: p_lib: *omit);                                              //R
         else;
            isPresent = 0;
         endif;

         if   isPresent = 1;
            lib = i_lib;
         else;
            lib = '*LIBL';
         endif;

         // ... i_format
         if   %parms >= p_lib;
            CEETSTA(isPresent: p_format: *omit);
         else;
            isPresent = 0;
         endif;

         if   isPresent = 1;
            format = i_format;
         else;
            format = 'OBJD0100';
         endif;

         // Call the retrieve object description API
         qFile.name = i_file;
         qFile.lib  = i_lib;
         errCode   = f_newApiErrCode(cTrue);
         QUSRMBRD(mbrD: %size(mbrD): format: qFile: i_mbr: '0': errCode);

         // Set message value
         msg = f_cvtApiErrCodeToMsg(errCode);

         // Check length of receiver variable
         if   not f_isApiError(errCode);
            p_assert(mbrD.bytRet <= mbrD.bytAvl:
                     'Length of receiver variable mbrD is +
                      to small to hold result');
         endif;

         // Process optional/omissible message parameter
         if   %parms >= p_msg;
            CEETSTA(isPresent: p_msg: *omit);
            if   isPresent = 1;
               o_msg = msg;
            endif;
         else;
            if   msg.ID <> cMSG_ID_OK;
               f_sndPgmMsg(msg: cMsg_Prv);
            endif;
         endif;

         return   mbrD;

      /END-FREE
      *
     P f_rtvMbrD...
     P                 E
      *
      *=========================================================================
      *  Produces a temporary object name.
      *=========================================================================
      *  Parameters:
      *   void
      *
      *  Returns:
      *   qTmpObj       - Returns a qualified temporary object name.
      *=========================================================================
      *
     P f_getTmpName...
     P                 B                   export
      *
     D f_getTmpName...
     D                 PI                         like(qObj_t     )
      *
      *  Return value
     D qTmpObj         DS                  likeds(qObj_t    ) inz
      *
      *  Local fields
     D pTmpNam         S               *   inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // Produce temporary object name
         pTmpNam = tmpnam(*NULL);

         if   pTmpNam <> *NULL;
            qTmpObj.lib  = %str(strtok(pTmpNam: '/'));
            qTmpObj.name = %str(strtok(*NULL  : '/'));
         else;
            clear   qTmpObj;
         endif;

         return   qTmpObj;

      /END-FREE
      *
     P f_getTmpName...
     P                 E
      *
      *=========================================================================
      *  Produces a unique object name.  (experimental)
      *=========================================================================
      *  Parameters:
      *   i_type        - The type of the object.
      *   i_lib         - The library that will contain the object.
      *
      *  Returns:
      *   qUnqObj       - Returns a qualified unique object name.
      *=========================================================================
      *
     P f_getUniqueName...
     P                 B                   export
      *
     D f_getUniqueName...
     D                 PI                         like(qObj_t     )
     D  i_type                       10A   const
     D  i_lib                        10A   const
      *
      *  Return value
     D qUnqObj         DS                  likeds(qObj_t    ) inz
      *
      *  Helper fields
     D tmStmp          S               Z   inz
     D date            S               D   inz
     D time            S               T   inz
     D timeout         S               Z   inz
     D x               S             10I 0 inz
     D name            DS                  qualified
     D  longNbr                      14S 0
     D   julDate                      5S 0 overlay(longNbr: *next)
     D   time                         6S 0 overlay(longNbr: *next)
     D   mSec                         3S 0 overlay(longNbr: *next)
      *
     D                 DS
     D chars                               inz('ABCDEFGHIJKLMNOPQRSTUVWXYZ+
     D                                          0123456789')
     D  char                          1A   dim(36) overlay(chars: *next)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // Initialize return value
         clear   qUnqObj;

         // Produce unique object name (max. 1 minute):
         timeout = %timestamp() + %minutes(1);

         dou   (qUnqObj.name <> '') or (%timestamp >= timeOut);

            // Produce unique object name from:
            // Julian date + Time + mSeconds
            tmStmp = %timestamp();
            time   = %time(tmStmp);
            date   = %date(tmStmp);

            name.julDate = %dec(f_val(
                                %char(date: *JUL0)): %size(name.julDate): 0);
            name.time    = %dec(f_val(
                                %char(time: *HMS0)): %size(name.time)   : 0);
            name.mSec    = %subdt(tmStmp: *MSECONDS) / 1000;

            // Set library name
            qUnqObj.lib = i_lib;

            // Encode object name to base 36
            %subst(qUnqObj.name: 1: 1) = 'Z';
            x = 2;
            dou   name.longNbr = 0;
               %subst(qUnqObj.name: x: 1) = char(%rem(name.longNbr: 36) + 1);
               name.longNbr = name.longNbr / 36;
               x = x + 1;
            enddo;

            // Check, if object exists
            if   f_exist(qUnqObj.name: qUnqObj.lib: i_type);
               // Create new name if object exists
               clear   qUnqObj;
            endif;

         enddo;

         p_assert(qUnqObj.name <> '':
                  'Unique object name of type ' + %trim(i_type) +
                  ' could not be produced'                      );

         return   qUnqObj;

      /END-FREE
      *
     P f_getUniqueName...
     P                 E
      *
      *=========================================================================
      *  Creates a user space.
      *=========================================================================
      *  Parameters:
      *   i_usrSpc      - The name of the user space.
      *   i_lib         - The library that contains the user space.
      *   i_text        - The text description of the user space.
      *                   Default:        *BLANKS
      *   i_size        - The initial size of the user space.
      *                   Default:        65536 (64 kB)
      *   i_extAtr      - The extended attribute of the user space.
      *                   Default:        *BLANKS
      *   i_pubAuth     - The public authority of the user space.
      *                   Default:        *USE
      *   o_msg         - The API error message.
      *
      *  Returns:
      *   isCreated     - Returns cTrue on success, else cFalse.
      *=========================================================================
      *
     P f_crtUsrSpc...
     P                 B                   export
      *
     D f_crtUsrSpc...
     D                 PI              N
     D  i_usrSpc                     10A   const
     D  i_lib                        10A   const
     D  i_text                       50A   const  options(*omit: *nopass)
     D  i_size                       10U 0 const  options(*omit: *nopass)
     D  i_extAtr                     10A   const  options(*omit: *nopass)
     D  i_pubAuth                    10A   const  options(*omit: *nopass)
     D  o_msg                                     likeds(msg_t    )
     D                                            options(*nopass: *omit)
      *
      *  Return value
     D isCreated       S               N   inz(cFalse)
      *
      *  Parameter positions
     D p_text          C                   const(3)
     D p_size          C                   const(4)
     D p_extAtr        C                   const(5)
     D p_pubAuth       C                   const(6)
     D p_msg           C                   const(7)
      *
      *  Optional parameter fields
     D text            S                   like(i_text      ) inz
     D size            S                   like(i_size      ) inz
     D extAtr          S                   like(i_extAtr    ) inz
     D pubAuth         S                   like(i_pubAuth   ) inz
     D msg             DS                  likeds(o_msg     ) inz
      *
      *  Local fields
     D qUsrSpc         DS                  likeds(qObj_t    ) inz
     D errCode         DS                  likeds(errCode_t ) inz
      *
      *  Helper fields CEETSTA
     D isPresent       S             10I 0                  inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // Initialize return value
         isCreated = cFalse;

         // Process optional parameter values ...
         // ... i_text
         if   %parms >= p_text;
            CEETSTA(isPresent: p_text: *omit);
         else;
            isPresent = 0;
         endif;

         if   isPresent = 1;
            text = i_text;
         else;
            text = '';
         endif;

         // ... i_size
         if   %parms >= p_size;
            CEETSTA(isPresent: p_size: *omit);
         else;
            isPresent = 0;
         endif;

         if   isPresent = 1;
            size = i_size;
         else;
            size = 64 * 1024;
         endif;

         // ... i_extAtr
         if   %parms >= p_extAtr;
            CEETSTA(isPresent: p_extAtr: *omit);
         else;
            isPresent = 0;
         endif;

         if   isPresent = 1;
            extAtr = i_extAtr;
         else;
            extAtr = '';
         endif;

         // ... i_pubAuth
         if   %parms >= p_pubAuth;
            CEETSTA(isPresent: p_pubAuth: *omit);
         else;
            isPresent = 0;
         endif;

         if   isPresent = 1;
            pubAuth = i_pubAuth;
         else;
            pubAuth = '*USE';
         endif;

         // Create user space
         qUsrSpc.name = i_usrSpc;
         qUsrSpc.lib  = i_lib;
         errCode      = f_newApiErrCode(cTrue);
         QUSCRTUS(qUsrSpc: extAtr: size: x'00': pubAuth: text: '*NO': errCode);

         // Set return value
         if   f_isApiError(errCode);
            isCreated = cFalse;
            msg       = f_cvtApiErrCodeToMsg(errCode);
         else;
            isCreated = cTrue;
            msg       = f_newMsg(cMSG_ID_OK);
         endif;

         // Process optional/omissible message parameter
         if   %parms >= p_msg;
            CEETSTA(isPresent: p_msg: *omit);
            if   isPresent = 1;
               o_msg = msg;
            endif;
         else;
            if   msg.ID <> cMSG_ID_OK;
               f_sndPgmMsg(msg: cMsg_Prv);
            endif;
         endif;

         return   isCreated;

      /END-FREE
      *
     P f_crtUsrSpc...
     P                 E
      *
      *=========================================================================
      *  Retrieves a pointer to the content of a user space.
      *=========================================================================
      *  Parameters:
      *   i_usrSpc      - The name of the user space.
      *   i_lib         - The library that contains the user space.
      *                   Default:        *LIBL
      *   o_msg         - The API error message.
      *
      *  Returns:
      *   pUsrSpc       - Returns a pointer to the content of a user space
      *                   on success, else a NULL pointer.
      *=========================================================================
      *
     P f_rtvUsrSpcPtr...
     P                 B                   export
      *
     D f_rtvUsrSpcPtr...
     D                 PI              *
     D  i_usrSpc                     10A   const
     D  i_lib                        10A   const  options(*nopass: *omit)
     D  o_msg                                     likeds(msg_t    )
     D                                            options(*nopass: *omit)
      *
      *  Return value
     D pUsrSpc         S               *   inz
      *
      *  Parameter positions
     D p_lib           C                   const(2)
     D p_msg           C                   const(3)
      *
      *  Optional parameter fields
     D lib             S                   like(i_lib       ) inz
     D msg             DS                  likeds(o_msg     ) inz
      *
      *  Local fields
     D qUsrSpc         DS                  likeds(qObj_t    ) inz
     D errCode         DS                  likeds(errCode_t ) inz
      *
      *  Helper fields CEETSTA
     D isPresent       S             10I 0                  inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // Initialize return value
         pUsrSpc = *NULL;

         // Process optional parameter values ...
         // ... i_lib
         if   %parms >= p_lib;
            CEETSTA(isPresent: p_lib: *omit);
         else;
            isPresent = 0;
         endif;

         if   isPresent = 1;
            lib = i_lib;
         else;
            lib = '*LIBL';
         endif;

         // Retrive pointer to content of user space
         qUsrSpc.name = i_usrSpc;
         qUsrSpc.lib  = i_lib;
         errCode      = f_newApiErrCode(cTrue);
         QUSPTRUS(qUsrSpc: pUsrSpc: errCode);

         // Set return value
         if   f_isApiError(errCode);
            pUsrSpc = *NULL;
            msg     = f_cvtApiErrCodeToMsg(errCode);
         else;
            msg     = f_newMsg(cMSG_ID_OK);
         endif;

         // Process optional/omissible message parameter
         if   %parms >= p_msg;
            CEETSTA(isPresent: p_msg: *omit);
            if   isPresent = 1;
               o_msg = msg;
            endif;
         else;
            if   msg.ID <> cMSG_ID_OK;
               f_sndPgmMsg(msg: cMsg_Prv);
            endif;
         endif;

         return   pUsrSpc;

      /END-FREE
      *
     P f_rtvUsrSpcPtr...
     P                 E
      *
      *=========================================================================
      *  Returns the current size of a given user space.
      *=========================================================================
      *  Parameters:
      *   i_usrSpc      - The name of the user space.
      *   i_lib         - The library that contains the user space.
      *                   Default:        *LIBL
      *   o_msg         - The API error message.
      *
      *  Returns:
      *   size          - Returns the size of a given user space on success,
      *                   else -1.
      *=========================================================================
      *
     P f_getUsrSpcSize...
     P                 B                   export
      *
     D f_getUsrSpcSize...
     D                 PI            10I 0
     D  i_usrSpc                     10A   const
     D  i_lib                        10A   const  options(*nopass: *omit)
     D  o_msg                                     likeds(msg_t    )
     D                                            options(*nopass: *omit)
      *
      *  Return value
     D size            S             10I 0 inz(-1)
      *
      *  Parameter positions
     D p_lib           C                   const(2)
     D p_msg           C                   const(3)
      *
      *  Optional parameter fields
     D lib             S                   like(i_lib       ) inz
     D msg             DS                  likeds(o_msg     ) inz
      *
      *  Helper fields
     D spca0100        DS                  likeds(SPCA0100_t) inz
      *
      *  Helper fields CEETSTA
     D isPresent       S             10I 0                  inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // Initialize return value
         size = -1;

         // Process optional parameter values ...
         // ... i_lib
         if   %parms >= p_lib;
            CEETSTA(isPresent: p_lib: *omit);
         else;
            isPresent = 0;
         endif;

         if   isPresent = 1;
            lib = i_lib;
         else;
            lib = '*LIBL';
         endif;

         // Retrieve user space attributes
         spca0100 = rtvUsrSpcAttr(i_usrSpc: lib: msg);

         // Set return value
         if (msg.ID <> cMSG_ID_OK);
            size = -1;
         else;
            size = spca0100.size;
         endif;

         // Process optional/omissible message parameter
         if (%parms() >= p_msg);
            CEETSTA(isPresent: p_msg: *omit);
            if (isPresent = 1);
               o_msg = msg;
            endif;
         else;
            if (msg.ID <> cMSG_ID_OK);
               f_sndPgmMsg(msg: cMsg_Prv);
            endif;
         endif;

         return size;

      /END-FREE
      *
     P f_getUsrSpcSize...
     P                 E
      *
      *=========================================================================
      *  Returns cTrue if the user space is extended automatically by the
      *  system when the end of the space is encountered.
      *=========================================================================
      *  Parameters:
      *   i_usrSpc      - The name of the user space.
      *   i_lib         - The library that contains the user space.
      *                   Default:        *LIBL
      *   o_msg         - The API error message.
      *
      *  Returns:
      *   isAutoExt     - Returns the automatic extendibility attribute
      *                   of the user space.
      *=========================================================================
      *
     P f_getUsrSpcAutoExt...
     P                 B                   export
      *
     D f_getUsrSpcAutoExt...
     D                 PI              N
     D  i_usrSpc                     10A   const
     D  i_lib                        10A   const  options(*nopass: *omit)
     D  o_msg                                     likeds(msg_t    )
     D                                            options(*nopass: *omit)
      *
      *  Return value
     D isAutoExt       S               N   inz(cFalse)
      *
      *  Parameter positions
     D p_lib           C                   const(2)
     D p_msg           C                   const(3)
      *
      *  Optional parameter fields
     D lib             S                   like(i_lib       ) inz
     D msg             DS                  likeds(o_msg     ) inz
      *
      *  Helper fields
     D spca0100        DS                  likeds(SPCA0100_t) inz
      *
      *  Helper fields CEETSTA
     D isPresent       S             10I 0                  inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // Initialize return value
         isAutoExt = cFalse;

         // Process optional parameter values ...
         // ... i_lib
         if (%parms() >= p_lib);
            CEETSTA(isPresent: p_lib: *omit);
         else;
            isPresent = 0;
         endif;

         if (isPresent = 1);
            lib = i_lib;
         else;
            lib = '*LIBL';
         endif;

         // Retrieve user space attributes
         spca0100 = rtvUsrSpcAttr(i_usrSpc: lib: msg);

         // Set return value
         if (msg.ID <> cMSG_ID_OK);
            isAutoExt = cFalse;
         else;
            if (spca0100.autoExtend = '0');
               isAutoExt = cFalse;
            else;
               isAutoExt = cTrue;
            endif;
         endif;

         // Process optional/omissible message parameter
         if (%parms() >= p_msg);
            CEETSTA(isPresent: p_msg: *omit);
            if (isPresent = 1);
               o_msg = msg;
            endif;
         else;
            if (msg.ID <> cMSG_ID_OK);
               f_sndPgmMsg(msg: cMsg_Prv);
            endif;
         endif;

         return isAutoExt;

      /END-FREE
      *
     P f_getUsrSpcAutoExt...
     P                 E
      *
      *=========================================================================
      *  Returns the initial value of a given user space.
      *=========================================================================
      *  Parameters:
      *   i_usrSpc      - The name of the user space.
      *   i_lib         - The library that contains the user space.
      *                   Default:        *LIBL
      *   o_msg         - The API error message.
      *
      *  Returns:
      *   initValue     - Returns the initialvalue of a given user space.
      *=========================================================================
      *
     P f_getUsrSpcInitValue...
     P                 B                   export
      *
     D f_getUsrSpcInitValue...
     D                 PI             1A          varying
     D  i_usrSpc                     10A   const
     D  i_lib                        10A   const  options(*nopass: *omit)
     D  o_msg                                     likeds(msg_t    )
     D                                            options(*nopass: *omit)
      *
      *  Return value
     D initValue       S              1A   inz
      *
      *  Parameter positions
     D p_lib           C                   const(2)
     D p_msg           C                   const(3)
      *
      *  Optional parameter fields
     D lib             S                   like(i_lib       ) inz
     D msg             DS                  likeds(o_msg     ) inz
      *
      *  Helper fields
     D spca0100        DS                  likeds(SPCA0100_t) inz
      *
      *  Helper fields CEETSTA
     D isPresent       S             10I 0                  inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // Initialize return value
         initValue = '';

         // Process optional parameter values ...
         // ... i_lib
         if (%parms() >= p_lib);
            CEETSTA(isPresent: p_lib: *omit);
         else;
            isPresent = 0;
         endif;

         if (isPresent = 1);
            lib = i_lib;
         else;
            lib = '*LIBL';
         endif;

         // Retrieve user space attributes
         spca0100 = rtvUsrSpcAttr(i_usrSpc: lib: msg);

         // Set return value
         if (msg.ID <> cMSG_ID_OK);
            initValue = '';
         else;
            initValue = spca0100.initValue;
         endif;

         // Process optional/omissible message parameter
         if (%parms() >= p_msg);
            CEETSTA(isPresent: p_msg: *omit);
            if (isPresent = 1);
               o_msg = msg;
            endif;
         else;
            if (msg.ID <> cMSG_ID_OK);
               f_sndPgmMsg(msg: cMsg_Prv);
            endif;
         endif;

         return initValue;

      /END-FREE
      *
     P f_getUsrSpcInitValue...
     P                 E
      *
      *=========================================================================
      *  Changes the size of a given user space.
      *=========================================================================
      *  Parameters:
      *   i_usrSpc      - The name of the user space.
      *   i_lib         - The library that contains the user space.
      *                   Default:        *LIBL
      *   i_size        - The new size of the user space.
      *   o_msg         - The API error message.
      *
      *  Returns:
      *   size          - Returns the new size of the user space.
      *=========================================================================
      *
     P f_chgUsrSpcSize...
     P                 B                   export
      *
     D f_chgUsrSpcSize...
     D                 PI            10I 0
     D  i_usrSpc                     10A   const
     D  i_lib                        10A   const  options(*omit)
     D  i_size                       10I 0 const
     D  o_msg                                     likeds(msg_t    )
     D                                            options(*nopass: *omit)
      *
      *  Return value
     D size            S             10I 0 inz(-1)
      *
      *  Parameter positions
     D p_lib           C                   const(2)
     D p_msg           C                   const(4)
      *
      *  Optional parameter fields
     D lib             S                   like(i_lib       ) inz
     D msg             DS                  likeds(o_msg     ) inz
      *
      *  Helper fields CEETSTA
     D isPresent       S             10I 0                  inz
      *
      *  Helper fields QUSCUSAT: size attribute
     D sizeAttr        DS                  likeds(QUSRSPC_attr_size_t) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // Initialize return value
         size = -1;

         // Process optional parameter values ...
         // ... i_lib
         if (%parms() >= p_lib);
            CEETSTA(isPresent: p_lib: *omit);
         else;
            isPresent = 0;
         endif;

         if (isPresent = 1);
            lib = i_lib;
         else;
            lib = '*LIBL';
         endif;

         // Change the size attribute of the given user space
         sizeAttr.key     = QUSRSPC_ATTR_SIZE;
         sizeAttr.dataLen = %size(sizeAttr.size);
         sizeAttr.size    = i_size;

         chgUsrSpcAttr(i_usrSpc: lib: sizeAttr: msg);

         size = f_getUsrSpcSize(i_usrSpc: lib: *omit);

         // Process optional/omissible message parameter
         if (%parms() >= p_msg);
            CEETSTA(isPresent: p_msg: *omit);
            if (isPresent = 1);
               o_msg = msg;
            endif;
         else;
            if (msg.ID <> cMSG_ID_OK);
               f_sndPgmMsg(msg: cMsg_Prv);
            endif;
         endif;

         return size;

      /END-FREE
      *
     P f_chgUsrSpcSize...
     P                 E
      *
      *=========================================================================
      *  Changes the automatic extendibility of a given user space.
      *=========================================================================
      *  Parameters:
      *   i_usrSpc      - The name of the user space.
      *   i_lib         - The library that contains the user space.
      *                   Default:        *LIBL
      *   i_isAutoExt   - cTrue, if the user space is automatically
      *                   extended by the system when the end of the space
      *                   is encountered.
      *   o_msg         - The API error message.
      *
      *  Returns:
      *   isAutoExt     - New state of the automatic extendibility attribute
      *                   of the user space.
      *=========================================================================
      *
     P f_chgUsrSpcAutoExt...
     P                 B                   export
      *
     D f_chgUsrSpcAutoExt...
     D                 PI              N
     D  i_usrSpc                     10A   const
     D  i_lib                        10A   const  options(*omit)
     D  i_isAutoExt                    N   const
     D  o_msg                                     likeds(msg_t    )
     D                                            options(*nopass: *omit)
      *
      *  Return value
     D isAutoExt       S               N   inz(cFalse)
      *
      *  Parameter positions
     D p_lib           C                   const(2)
     D p_msg           C                   const(4)
      *
      *  Optional parameter fields
     D lib             S                   like(i_lib       ) inz
     D msg             DS                  likeds(o_msg     ) inz
      *
      *  Helper fields CEETSTA
     D isPresent       S             10I 0                  inz
      *
      *  Helper fields QUSCUSAT: automatic extendibility
     D autoExtAttr     DS                  likeds(QUSRSPC_auto_extend_t) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // Initialize return value
         isAutoExt = cFalse;

         // Process optional parameter values ...
         // ... i_lib
         if (%parms() >= p_lib);
            CEETSTA(isPresent: p_lib: *omit);
         else;
            isPresent = 0;
         endif;

         if (isPresent = 1);
            lib = i_lib;
         else;
            lib = '*LIBL';
         endif;

         // Change the automatic extendibility of the given user space
         autoExtAttr.key     = QUSRSPC_ATTR_AUTO_EXTEND;
         autoExtAttr.dataLen = %size(autoExtAttr.autoExtend);
         if (i_isAutoExt);
            autoExtAttr.autoExtend = '1';
         else;
            autoExtAttr.autoExtend = '0';
         endif;

0        chgUsrSpcAttr(i_usrSpc: lib: autoExtAttr: msg);

         isAutoExt = f_getUsrSpcAutoExt(i_usrSpc: lib: *omit);

         // Process optional/omissible message parameter
         if (%parms() >= p_msg);
            CEETSTA(isPresent: p_msg: *omit);
            if (isPresent = 1);
               o_msg = msg;
            endif;
         else;
            if (msg.ID <> cMSG_ID_OK);
               f_sndPgmMsg(msg: cMsg_Prv);
            endif;
         endif;

         return isAutoExt;

      /END-FREE
      *
     P f_chgUsrSpcAutoExt...
     P                 E
      *
      *=========================================================================
      *  Changes the initial value of a given user space.
      *=========================================================================
      *  Parameters:
      *   i_usrSpc      - The name of the user space.
      *   i_lib         - The library that contains the user space.
      *                   Default:        *LIBL
      *   i_initValue   - The initial value of the user space.
      *   o_msg         - The API error message.
      *
      *  Returns:
      *   initValue     - Returns the new size of the user space on success,
      *                   else -1.
      *=========================================================================
      *
     P f_chgUsrSpcInitValue...
     P                 B                   export
      *
     D f_chgUsrSpcInitValue...
     D                 PI             1A          varying
     D  i_usrSpc                     10A   const
     D  i_lib                        10A   const  options(*omit)
     D  i_initValue                   1A   const
     D  o_msg                                     likeds(msg_t    )
     D                                            options(*nopass: *omit)
      *
      *  Return value
     D initValue       S              1A   varying inz
      *
      *  Parameter positions
     D p_lib           C                   const(2)
     D p_msg           C                   const(4)
      *
      *  Optional parameter fields
     D lib             S                   like(i_lib       ) inz
     D msg             DS                  likeds(o_msg     ) inz
      *
      *  Helper fields CEETSTA
     D isPresent       S             10I 0                  inz
      *
      *  Helper fields QUSCUSAT: initial value
     D initValueAttr   DS                  likeds(QUSRSPC_initial_value_t) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // Initialize return value
         initValue = '';

         // Process optional parameter values ...
         // ... i_lib
         if (%parms() >= p_lib);
            CEETSTA(isPresent: p_lib: *omit);
         else;
            isPresent = 0;
         endif;

         if (isPresent = 1);
            lib = i_lib;
         else;
            lib = '*LIBL';
         endif;

         // Change the initial value of the given user space
         initValueAttr.key     = QUSRSPC_ATTR_INITIAL_VALUE;
         initValueAttr.dataLen = %size(initValueAttr.value);
         initValueAttr.value   = i_initValue;

         chgUsrSpcAttr(i_usrSpc: lib: initValueAttr: msg);

         initValue = f_getUsrSpcInitValue(i_usrSpc: lib: *omit);

         // Process optional/omissible message parameter
         if (%parms() >= p_msg);
            CEETSTA(isPresent: p_msg: *omit);
            if (isPresent = 1);
               o_msg = msg;
            endif;
         else;
            if (msg.ID <> cMSG_ID_OK);
               f_sndPgmMsg(msg: cMsg_Prv);
            endif;
         endif;

         return initValue;

      /END-FREE
      *
     P f_chgUsrSpcInitValue...
     P                 E
      *
      *=========================================================================
      *  Deletes a given user space.
      *=========================================================================
      *  Parameters:
      *   i_usrSpc      - The name of the user space.
      *   i_lib         - The library that contains the user space.
      *                   Default:        *LIBL
      *   o_msg         - The API error message.
      *
      *  Returns:
      *   isDeleted     - Returns cTrue on success, else cFalse.
      *=========================================================================
      *
     P f_dltUsrSpc...
     P                 B                   export
      *
     D f_dltUsrSpc...
     D                 PI              N
     D  i_usrSpc                     10A   const
     D  i_lib                        10A   const  options(*nopass: *omit)
     D  o_msg                                     likeds(msg_t    )
     D                                            options(*nopass: *omit)
      *
      *  Return value
     D isDeleted       S               N   inz(cFalse)
      *
      *  Parameter positions
     D p_lib           C                   const(2)
     D p_msg           C                   const(3)
      *
      *  Optional parameter fields
     D lib             S                   like(i_lib       ) inz
     D msg             DS                  likeds(o_msg     ) inz
      *
      *  Local fields
     D qUsrSpc         DS                  likeds(qObj_t    ) inz
     D errCode         DS                  likeds(errCode_t ) inz
      *
      *  Helper fields CEETSTA
     D isPresent       S             10I 0                  inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // Initialize return value
         isDeleted = cFalse;

         // Process optional parameter values ...
         // ... i_lib
         if   %parms >= p_lib;
            CEETSTA(isPresent: p_lib: *omit);
         else;
            isPresent = 0;
         endif;

         if   isPresent = 1;
            lib = i_lib;
         else;
            lib = '*LIBL';
         endif;

         // Delete user space
         qUsrSpc.name = i_usrSpc;
         qUsrSpc.lib  = i_lib;
         errCode      = f_newApiErrCode(cTrue);
         QUSDLTUS(qUsrSpc: errCode);

         // Set return value
         if   f_isApiError(errCode);
            isDeleted = cFalse;
            msg       = f_cvtApiErrCodeToMsg(errCode);
         else;
            isDeleted = cTrue;
            msg       = f_newMsg(cMSG_ID_OK);
         endif;

         // Process optional/omissible message parameter
         if   %parms >= p_msg;
            CEETSTA(isPresent: p_msg: *omit);
            if   isPresent = 1;
               o_msg = msg;
            endif;
         else;
            if   msg.ID <> cMSG_ID_OK;
               f_sndPgmMsg(msg: cMsg_Prv);
            endif;
         endif;

         return   isDeleted;

      /END-FREE
      *
     P f_dltUsrSpc...
     P                 E
      *
      *=========================================================================
      *  Activates a service program.
      *=========================================================================
      *  Parameters:
      *   i_srvPgm      - The name of the service program.
      *   i_lib         - The library that contains the service program.
      *                   Default:        *LIBL
      *   o_msg         - The API error message.
      *
      *  Returns:
      *   actSrvPgm     - Returns a structure that contains the
      *                   system pointer to the service program and
      *                   the activation mark.
      *=========================================================================
      *
     P f_activateSrvPgm...
     P                 B                   export
      *
     D f_activateSrvPgm...
     D                 PI                         likeds(actSrvPgm_t )
     D  i_srvPgm                     10A   const
     D  i_lib                        10A   const  options(*nopass: *omit)
     D  o_msg                                     likeds(msg_t    )
     D                                            options(*nopass: *omit)
      *
      *  Return value
     D actSrvPgm       DS                  likeds(actSrvPgm_t ) inz
      *
      *  Parameter positions
     D p_lib           C                   const(2)
     D p_msg           C                   const(3)
      *
      *  Optional parameter fields
     D lib             S                   like(i_lib       ) inz
     D msg             DS                  likeds(o_msg     ) inz
      *
      *  Local fields
     D actMark         S                   like(actInf_t.actMark ) inz
     D pSrvPgm         S               *   inz  procptr
     D actInf          DS                  likeds(actInf_t       ) inz
     D errCode         DS                  likeds(errCode_t      ) inz
      *
      *  Helper fields CEETSTA
     D isPresent       S             10I 0 inz
      *
      *  Helper fields
     D rcvm0200        DS                  likeds(rcvm0200_t     ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // Initialize return value
         clear actSrvPgm;
         msg = f_newMsg(cMSG_ID_OK);

         // Process optional parameter values ...
         // ... i_lib
         if   %parms >= p_lib;
            CEETSTA(isPresent: p_lib: *omit);
         else;
            isPresent = 0;
         endif;

         if   isPresent = 1;
            lib = i_lib;
         else;
            lib = '*LIBL';
         endif;

         // Check object exist

         // Get system pointer
         monitor;
            pSrvPgm = rslvsp(WLI_SRVPGM: i_srvPgm: lib: AUTH_OBJ_MGMT);
         on-error;
            rcvm0200 = f_rcvPgmMsg(cMsg_Any: '': cMsg_Act_Rmv);
            msg = f_newMsg('CPF9898': 'Object ' + %trim(lib) + '/'
                                                + %trim(i_srvPgm)
                                                + ' not found');
         endmon;

         // Actiate service program
         if pSrvPgm <> *NULL;
            errCode = f_newApiErrCode(cTrue);
            QleActBndPgm(pSrvPgm: actMark: actInf: %size(actInf): errCode);

            if f_isAPIError(errCode);
               msg = f_cvtApiErrCodeToMsg(errCode);
            endif;
         endif;

         if pSrvPgm <> *NULL;
            actSrvPgm.procptr = pSrvPgm;
            actSrvPgm.actMark = actMark;
            actSrvPgm.name    = i_srvPgm;
            actSrvPgm.lib     = lib;
         endif;

         // Process optional/omissible message parameter
         if   %parms >= p_msg;
            CEETSTA(isPresent: p_msg: *omit);
            if   isPresent = 1;
               o_msg = msg;
            endif;
         else;
            if   msg.ID <> cMSG_ID_OK;
               f_sndPgmMsg(msg: cMsg_Prv);
            endif;
         endif;

         return actSrvPgm;

      /END-FREE
      *
     P f_activateSrvPgm...
     P                 E
      *
      *=========================================================================
      *  Gets a procedure pointer by name.
      *=========================================================================
      *  Parameters:
      *   i_srvPgm      - The name of the service program.
      *   i_lib         - The library that contains the service program.
      *                   Default:        *LIBL
      *   i_proc        - The name of the procedure.
      *   o_msg         - The API error message.
      *
      *  Returns:
      *   procptr       - Returns a pointer to the procedure on success
      *                   else *NULL.
      *=========================================================================
      *
     P f_getProcPtrByName...
     P                 B                   export
      *
     D f_getProcPtrByName...
     D                 PI                         likeds(actProc_t  )
     D  i_proc                      256A   const
     D  i_actSrvPgm                        const  likeds(actSrvPgm_t)
     D  o_msg                                     likeds(msg_t    )
     D                                            options(*nopass: *omit)
      *
      *  Return value
     D actProc         DS                  likeds(actProc_t ) inz
      *
      *  Parameter positions
     D p_msg           C                   const(3)
      *
      *  Optional parameter fields
     D msg             DS                  likeds(o_msg     ) inz
      *
      *  Local fields
     D typeExpItem     S             10I 0 inz
     D pExpItem        S               *   inz  procptr
     D errCode         DS                  likeds(errCode_t      ) inz
      *
      *  Helper fields CEETSTA
     D isPresent       S             10I 0                  inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // Initialize return value
         clear actProc;
         msg = f_newMsg(cMSG_ID_OK);

         // Get procedure pointer by name
         errCode = f_newApiErrCode(cTrue);
         QleGetExp(i_actSrvPgm.actMark: *omit: %len(%trimR(i_proc))
                   : %trimR(i_proc): pExpItem: typeExpItem: errCode);
         if f_isAPIError(errCode);
            msg = f_cvtApiErrCodeToMsg(errCode);
         endif;

         if pExpItem <> *NULL;
            actproc.procptr = pExpItem;
            actproc.actMark = i_actSrvPgm.actMark;
            actproc.name    = i_proc;
            actproc.srvPgm  = i_actSrvPgm.name;
            actproc.lib     = i_actSrvPgm.lib;
         endif;

         // Process optional/omissible message parameter
         if   %parms >= p_msg;
            CEETSTA(isPresent: p_msg: *omit);
            if   isPresent = 1;
               o_msg = msg;
            endif;
         else;
            if   msg.ID <> cMSG_ID_OK;
               f_sndPgmMsg(msg: cMsg_Prv);
            endif;
         endif;

         return actProc;

      /END-FREE
      *
     P f_getProcPtrByName...
     P                 E
      *
      *=========================================================================
      *  Returns the name of the library that contains a given object.
      *=========================================================================
      *  Parameters:
      *   i_obj         - The name of the object whose library is resolved.
      *   i_lib         - The special value of the library name that contains
      *                   the object.
      *                   Default:        *LIBL
      *   i_type        - The type of the object.
      *
      *  Returns:
      *   rtnLib        - Name of the library that contains the object.
      *=========================================================================
      *
     P f_getObjLib...
     P                 B                   export
      *
     D f_getObjLib...
     D                 PI            10A
     D  i_obj                        10A   const
     D  i_lib                        10A   const  options(*omit)
     D  i_type                       10A   const
      *
      *  Return value
     D rtnLib          S             10A   inz
      *
      *  Parameter positions
     D p_lib           C                   const(2)
      *
      *  Optional parameter fields
     D lib             S                   like(i_lib       ) inz
      *
      *  Local fields
     D objd0100        DS                  likeds(objd0100_t) inz
     D msg             DS                  likeds(msg_t     ) inz
      *
      *  Helper fields CEETSTA
     D isPresent       S             10I 0                  inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // Process optional parameter values ...
         // ... i_lib
         if   %parms >= p_lib;
            CEETSTA(isPresent: p_lib: *omit);                                              //R
         else;
            isPresent = 0;
         endif;

         if   isPresent = 1;
            lib = i_lib;
         else;
            lib = '*LIBL';
         endif;

         // Retrieve the object description
         objd0100 = f_rtvObjD(i_obj: lib: i_type: 'OBJD0100': msg);

         // Set return value
         if (msg.ID = cMSG_ID_OK);
            rtnLib = objd0100.rtnLib;
         else;
            f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToMyself);
         endif;

         return rtnLib;

      /END-FREE
      *
     P f_getObjLib...
     P                 E
      *
      *=========================================================================
      *  Converts a QSYS object name to a path.
      *=========================================================================
      *  Parameters:
      *   i_obj         - The name of the object.
      *   i_lib         - The name of the object library.
      *                   Default:        *LIBL
      *   i_mbr         - The name of the member, when the object is a file.
      *
      *  Returns:
      *   path          - IFS path name.
      *=========================================================================
      *  Examples:
      *   f_cvtQSYSObjNameToPath(qFile)
      *   f_cvtQSYSObjNameToPath(qObj: '*DTAARA');
      *   f_cvtQSYSObjNameToPath(library: '*LIB');
      *   f_cvtQSYSObjNameToPath(object: '*OUTQ');
      *   f_cvtQSYSObjNameToPath(object: library: '*MSGQ');
      *   f_cvtQSYSObjNameToPath(object: library: member: '*FILE');
      *=========================================================================
     P f_cvtQSYSObjNameToPath...
     P                 B                   export
     D                 PI          5000A   varying opdesc
     D  i_obj                        40A   const  options(*varsize)
     D  i_libOrType                  10A   const  options(*nopass: *omit)
     D  i_mbrOrType                  10A   const  options(*nopass: *omit)
     D  i_objType                    10A   const  options(*nopass: *omit)
      *
      *  Return value
     D path            S           5000A   varying inz
      *
      *  Parameter positions
     D p_obj           C                   const(1)
     D p_libOrType     C                   const(2)
     D p_mbrOrType     C                   const(3)
     D p_objType       C                   const(4)
      *
      *  Optional parameter fields
     D libOrType       S                   like(i_libOrType ) inz
     D mbrOrType       S                   like(i_mbrOrType ) inz
     D objType         S                   like(i_objType   ) inz
      *
      *  Local fields
     D objInf          DS                  likeds(strInf_t  ) inz
     D qQSYSObj        DS                  likeds(qQSYSObj_t) inz
     D qFile           DS                  likeds(qFile_t   ) inz
     D qObj            DS                  likeds(qFile_t   ) inz
      *
     D object          S             10A   inz
     D library         S             10A   inz
     D member          S             10A   inz
     D type            S             10A   inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // Process optional parameter values ...
         if (%parms() >= p_libOrType and %addr(i_libOrType) <> *null);
            libOrType = i_libOrType;
         else;
            libOrType = '';
         endif;

         if (%parms() >= p_mbrOrType and %addr(i_mbrOrType) <> *null);
            mbrOrType = i_mbrOrType;
         else;
            mbrOrType = '';
         endif;

         if (%parms() >= p_objType and %addr(i_objType) <> *null);
            objType = i_objType;
         else;
            objType = '';
         endif;

         CEEGSI(p_obj: objInf.dataType: objInf.curlen: objInf.maxlen: *omit);

         select;
         when (objInf.curlen = 40);   // 1 parameter
            p_assert(%parms() = 1
                     : 'Expected number of parameters: 1');
            qQSYSObj = i_obj;
            object = qQSYSObj.name;
            library = qQSYSObj.lib;
            member = qQSYSObj.mbr;
            type = qQSYSObj.type;

         when (objInf.curlen = 30);   // 2 parameters
            p_assert(%parms() = 1 or %parms() = 2
                     : 'Expected number of parameters: 1 or 2');
            p_assert(%parms() = 1 or (%parms() = 2 and libOrType = '*FILE')
                     : 'Expected number of parameters: 1 or (2 and *FILE)');
            qFile = i_obj;
            object = qFile.name;
            library = qFile.lib;
            member = qFile.mbr;
            if (%parms() = 1);
               type = '*FILE';
            else;
               type = libOrType;
            endif;

         when (objInf.curlen = 20);   // 2 parameters
            p_assert(%parms() = 2
                     : 'Expected number of parameters: 2');
            qObj = i_obj;
            object = qObj.name;
            library = qObj.lib;
            member = '';
            type = libOrType;

         other;                       // 3 or 4 parameters, eg:
            p_assert(%parms() = 2 or %parms() = 3 or
                     (%parms() = 4 and objType = '*FILE')
                     : 'Expected number of parameters: 2, 3 or (4 and *FILE)');
            object = i_obj;
            select;
            when (%parms() = 2);
               library = '';
               member = '';
               type = libOrType;
            when (%parms() = 3);
               library = libOrType;
               member = '';
               type = mbrOrType;
            other;
               library = libOrType;
               member = mbrOrType;
               type = objType;
            endsl;
         endsl;

         if (type = '*LIB');
            library = object;
            object = '';
         else;
            if (library = '');
               library = '*LIBL';
            endif;
         endif;

         path = '/QSYS.LIB';

         if (library <> '' and library <> 'QSYS');
            path += '/';

            select;
            when (library = '*ALL');
               path += '%ALL%';
            when (library = '*ALLUSR');
               path += '%ALLUSR%';
            when (library = '*CURLIB');
               path += '%CURLIB%';
            when (library = '*LIBL');
               path += '%LIBL%';
            when (library = '*USRLIBL');
               path += '%USRLIBL%';
            other;
               path += %trim(library);
            endsl;

            path += '.LIB';
         endif;

         if (object <> '');
            path += '/';

            select;
            when (object = '*ALL');
               path += '%ALL%';
            other;
               path += %trim(object);
            endsl;

            path += '.' + %trimR(%subst(type: 2));
         endif;

         if (member <> '');
            path += '/';

            path += %trim(member);

            path += '.MBR';
         endif;

         return path;

      /END-FREE
     P                 E
      *
      *=========================================================================
      *  Resolve Integrated File System Path Name into
      *  QSYS Object Name
      *=========================================================================
      *  Parameters:
      *   i_path        - Path of the object.
      *
      *  Returns:
      *   qQSYSObj      - resolved QSYS object name.
      *=========================================================================
     P f_cvtPathToQSYSObjName...
     P                 B                   export
     D                 PI                  likeds(qQSYSObj_t)
     D  i_path                     5000A   const  varying options(*varsize)
      *
      *  Return value
     D qQSYSObj        DS                  likeds(qQSYSObj_t)
      *
      *  Local fields
     D pathName        ds                  likeds(Qlg_Path_Name_t) inz
     D qsys_info       ds                  likeds(qsys0100_t) inz
     D errCode         ds                  likeds(errCode_t) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         pathName = *ALLx'00';
         pathName.CCSID = QLG_PATH_JOB_CCSID;
         pathName.Country_ID = QLG_PATH_JOB_COUNTRYID;
         pathName.Language_ID = QLG_PATH_JOB_LANGUAGEID;
         pathName.Reserved = *ALLx'00';
         pathName.Path_Type = QLG_CHAR_SINGLE;
         pathName.Path_Length = %len(%trimR(i_path));
         pathName.Path_Name_Delimiter = '/';
         pathName.Reserved2 = *ALLx'00';
         pathName.Path_Name = i_path;
         errCode = f_newApiErrCode(cFalse);

         Qp0lCvtPathToQSYSObjName(
            pathName: qsys_info: 'QSYS0100': %size(qsys_info): 0: errCode);

         if (%str(%addr(qsys_info.obj_type)) = '' and
             %str(%addr(qsys_info.lib_type)) = '*LIB');
            qQSYSObj.name = %str(%addr(qsys_info.lib_name));
            qQSYSObj.lib = '';
            qQSYSObj.mbr = '';
            qQSYSObj.type = %str(%addr(qsys_info.lib_type));
         else;
            qQSYSObj.name = %str(%addr(qsys_info.obj_name));
            qQSYSObj.lib = %str(%addr(qsys_info.lib_name));
            qQSYSObj.mbr = %str(%addr(qsys_info.mbr_name));
            qQSYSObj.type = %str(%addr(qsys_info.obj_type));
         endif;

         select;
         when (qQSYSObj.lib = '%ALL%');
            qQSYSObj.lib = '*ALL';
         when (qQSYSObj.lib = '%ALLUSR%');
            qQSYSObj.lib = '*ALLUSR';
         when (qQSYSObj.lib = '%CURLIB%');
            qQSYSObj.lib = '*CURLIB';
         when (qQSYSObj.lib = '%LIBL%');
            qQSYSObj.lib = '*LIBL';
         when (qQSYSObj.lib = '%USRLIBL%');
            qQSYSObj.lib = '*USRLIBL';
         endsl;

         select;
         when (qQSYSObj.name = '%ALL%');
            qQSYSObj.name = '*ALL';
         endsl;

         return qQSYSObj;

      /END-FREE
     P                 E
      *
      *=========================================================================
    R *  *** private ***
      *  Retrieves the attributes of a given user space.
      *=========================================================================
      *  Parameters:
      *   i_usrSpc      - The name of the user space.
      *   i_lib         - The library that contains the user space.
      *                   Default:        *LIBL
      *   o_msg         - The API error message.
      *
      *  Returns:
      *   attrs         - Returns the attributes of a given user space.
      *=========================================================================
      *
     P rtvUsrSpcAttr...
     P                 B
      *
     D rtvUsrSpcAttr...
     D                 PI                         likeds(spca0100_t )
     D  i_usrSpc                     10A   const
     D  i_lib                        10A   const  options(*nopass: *omit)
     D  o_msg                                     likeds(msg_t    )
     D                                            options(*nopass: *omit)
      *
      *  Return value
     D spca0100        DS                  likeds(spca0100_t ) inz
      *
      *  Parameter positions
     D p_lib           C                   const(2)
     D p_msg           C                   const(3)
      *
      *  Optional parameter fields
     D lib             S                   like(i_lib       ) inz
     D msg             DS                  likeds(o_msg     ) inz
      *
      *  Local fields
     D qUsrSpc         DS                  likeds(qObj_t    ) inz
     D errCode         DS                  likeds(errCode_t ) inz
      *
      *  Helper fields CEETSTA
     D isPresent       S             10I 0                  inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // Initialize return value
         clear spca0100;

         // Process optional parameter values ...
         // ... i_lib
         if (%parms() >= p_lib);
            CEETSTA(isPresent: p_lib: *omit);
         else;
            isPresent = 0;
         endif;

         if (isPresent = 1);
            lib = i_lib;
         else;
            lib = '*LIBL';
         endif;

         // Retrive user space attributes
         qUsrSpc.name = i_usrSpc;
         qUsrSpc.lib  = i_lib;
         errCode      = f_newApiErrCode(cTrue);
         QUSRUSAT(spca0100: %size(spca0100): 'SPCA0100': qUsrSpc: errCode);

         // Set return value
         if (f_isApiError(errCode));
            clear spca0100;
            msg = f_cvtApiErrCodeToMsg(errCode);
         else;
            msg = f_newMsg(cMSG_ID_OK);
         endif;

         // Process optional/omissible message parameter
         if (%parms() >= p_msg);
            CEETSTA(isPresent: p_msg: *omit);
            if (isPresent = 1);
               o_msg = msg;
            endif;
         else;
            if (msg.ID <> cMSG_ID_OK);
               f_sndPgmMsg(msg: cMsg_Prv);
            endif;
         endif;

         return spca0100;

      /END-FREE
      *
     P rtvUsrSpcAttr...
     P                 E
      *
      *=========================================================================
    R *  *** private ***
      *  Changes an attribute of a given user space.
      *=========================================================================
      *  Parameters:
      *   i_usrSpc      - The name of the user space.
      *   i_lib         - The library that contains the user space.
      *                   Default:        *LIBL
      *   i_attr        - The attribute to change.
      *   o_msg         - The API error message.
      *
      *  Returns:
      *   isChanged     - Returns cTrue on success, else cFalse.
      *=========================================================================
      *
     P chgUsrSpcAttr...
     P                 B
      *
     D chgUsrSpcAttr...
     D                 PI              N
     D  i_usrSpc                     10A   const
     D  i_lib                        10A   const  options(*omit)
     D  i_attr                      128A   const
     D  o_msg                                     likeds(msg_t    )
     D                                            options(*nopass: *omit)
      *
      *  Return value
     D isChanged       S               N   inz(cFalse)
      *
      *  Parameter positions
     D p_lib           C                   const(2)
     D p_msg           C                   const(4)
      *
      *  Optional parameter fields
     D lib             S                   like(i_lib       ) inz
     D msg             DS                  likeds(o_msg     ) inz
      *
      *  Local fields
     D rtnLib          S             10A                      inz
     D qUsrSpc         DS                  likeds(qObj_t    ) inz
     D errCode         DS                  likeds(errCode_t ) inz
      *
      *  Helper fields CEETSTA
     D isPresent       S             10I 0 inz
      *
      *  Helper fields QUSCUSAT
     D userSpaceAttr   DS                  qualified
     D  numAttrs                     10I 0 inz
     D  attrToChg                   128A   inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // Initialize return value
         isChanged = cFalse;

         // Process optional parameter values ...
         // ... i_lib
         if (%parms() >= p_lib);
            CEETSTA(isPresent: p_lib: *omit);
         else;
            isPresent = 0;
         endif;

         if (isPresent = 1);
            lib = i_lib;
         else;
            lib = '*LIBL';
         endif;

         // Change the attribute of the given user space
         qUsrSpc.name = i_usrSpc;
         qUsrSpc.lib  = lib;
         userSpaceAttr.numAttrs  = 1;
         userSpaceAttr.attrToChg = i_attr;
         errCode = f_newApiErrCode(cTrue);
         QUSCUSAT(rtnLib: qUsrSpc: userSpaceAttr: errCode);

         // Set return value
         if (f_isApiError(errCode));
            isChanged = cFalse;
            msg       = f_cvtApiErrCodeToMsg(errCode);
         else;
            isChanged = cTrue;
            msg       = f_newMsg(cMSG_ID_OK);
         endif;

         // Process optional/omissible message parameter
         if (%parms() >= p_msg);
            CEETSTA(isPresent: p_msg: *omit);
            if (isPresent = 1);
               o_msg = msg;
            endif;
         else;
            if (msg.ID <> cMSG_ID_OK);
               f_sndPgmMsg(msg: cMsg_Prv);
            endif;
         endif;

         return isChanged;

      /END-FREE
      *
     P chgUsrSpcAttr...
     P                 E
      *
