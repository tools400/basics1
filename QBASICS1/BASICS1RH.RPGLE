      *=====================================================================*
      *  BASICS1RH  - SrvPgm: Basic Routines - MemoryBufferRdrWtr           *
      *=====================================================================*
      *  Author  :  Thomas Raddatz                                          *
      *  Date    :  16.07.2011                                              *
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
     H NOMAIN BNDDIR('QSNAPI')
      *  Standard H-Specs
      /COPY QBASICS1,H_SPEC
      /COPY QBASICS1,COPYRIGHT
      *=====================================================================*
      *
      * -----------------------------------------
      *  Exported functions
      * -----------------------------------------
      /COPY QBASICS1,PBASICS1RH
      *
      * -----------------------------------------
      *  Reference fields
      * -----------------------------------------
      /COPY QBASICS1,BASICS1R0
      *
     D reader_t        DS                  qualified               based(pDummy)
     D  fd                           10I 0
     D  offset                       10I 0
     D  size                         10I 0
     D  pData                          *
      *
     D writer_t        DS                  qualified               based(pDummy)
     D  fd                           10I 0
     D  offset                       10I 0
     D  size                         10I 0
     D  pData                          *
      *
      * -----------------------------------------
      *  Private prototypes
      * -----------------------------------------
      *
      * -----------------------------------------
      *  Imported prototypes
      * -----------------------------------------
      /COPY QBASICS1,CLIB                          C Runtime Library
      *
      /COPY QBASICS1,PBASICS1R2                    API Error Handling
      /COPY QBASICS1,PBASICS1R8                    Handle/Memory
      *
      * -----------------------------------------
      *  Global constants
      * -----------------------------------------
     D HANDLE_TYPE_WRITER...
     D                 C                   '*MEMORY_WRITER'
     D HANDLE_TYPE_READER...
     D                 C                   '*MEMORY_READER'
      *
      * -----------------------------------------
      *  Global fields
      * -----------------------------------------
      *
      *=========================================================================
      *  Creates a memory buffer writer.
      *=========================================================================
      *  Parameters:
      *   i_pBuffer     - Buffer data is written to.
      *   i_maxSize     - Maximum size of the buffer.
      *
      *  Returns:
      *   fd            - Buffer descriptor on success, else -1.
      *=========================================================================
     P MemoryWriter_new...
     P                 B                   export
      *
     D MemoryWriter_new...
     D                 PI                         like(memWtr_handle_t)
     D  i_pBuffer                      *   value
     D  i_maxSize                          value  like(size_t         )
      *
      *  Return value
     D fd              S             10I 0 inz(RC_ERROR)
      *
      *  Local fields
      *
      *  Handle
     D hWriter         DS                  likeds(writer_t ) based(pHWriter)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         fd = HANDLE_new(HANDLE_TYPE_WRITER: %size(hWriter));

         pHWriter = HANDLE_getPointer(fd);

         clear hWriter;
         hWriter.fd     = fd;
         hWriter.offset = 0;
         hWriter.size   = i_maxSize;
         hWriter.pData  = i_pBuffer;

         return fd;

      /END-FREE
      *
     P MemoryWriter_new...
     P                 E
      *
      *=========================================================================
      *  Write to a given memory buffer descriptor.
      *=========================================================================
      *  Parameters:
      *   i_fd          - Descriptor as created by MemoryWriter_new().
      *   i_pBuffer     - Buffer that is written to the descriptor.
      *   i_buflen      - Length of the buffer.
      *
      *  Returns:
      *   fd            - Number of bytes written to the descriptor on
      *                   success, else -1.
      *=========================================================================
     P MemoryWriter_write...
     P                 B                   export
      *
     D MemoryWriter_write...
     D                 PI                         like(ssize_t        )
     D  i_fd                               value  like(memWtr_handle_t)
     D  i_pBuffer                      *   value
     D  i_buflen                           value  like(size_t         )
      *
      *  Return value
     D rc              S                   like(ssize_t ) inz(RC_ERROR)
      *
      *  Local fields
     D size            S                   like(rc      ) inz
     D pDest           S               *   inz
      *
      *  Handle
     D hWriter         DS                  likeds(writer_t ) based(pHWriter)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         if (not HANDLE_isTypeOf(i_fd: HANDLE_TYPE_WRITER));
            f_setErrno(EBADF_C);
            return RC_ERROR;
         endif;

         pHWriter = HANDLE_getPointer(i_fd);

         if (hWriter.offset + i_buflen > hWriter.size);
            f_setErrno(ENOBUFS_C);
            return RC_ERROR;
         endif;

         size = i_buflen;
         pDest = memcpy(hWriter.pData + hWriter.offset: i_pBuffer: size);
         if (pDest <> hWriter.pData + hWriter.offset);
            f_setErrno(ENOBUFS_C);
            return RC_ERROR;
         endif;

         hWriter.offset = hWriter.offset + size;

         rc = size;

         return rc;

      /END-FREE
      *
     P MemoryWriter_write...
     P                 E
      *
      *=========================================================================
      *  Deletes a given memory buffer writer.
      *=========================================================================
      *  Parameters:
      *   io_fd         - Descriptor as created by MemoryWriter_new().
      *
      *  Returns:
      *   void
      *=========================================================================
     P MemoryWriter_delete...
     P                 B                   export
      *
     D MemoryWriter_delete...
     D                 PI
     D  io_fd                                     like(memWtr_handle_t)
      *
      *  Local fields
      *
      *  Handle
     D hWriter         DS                  likeds(writer_t ) based(pHWriter)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         if (not HANDLE_isTypeOf(io_fd: HANDLE_TYPE_WRITER));
            f_setErrno(EBADF_C);
            return;
         endif;

         pHWriter = HANDLE_getPointer(io_fd);

         clear hWriter;

         HANDLE_delete(io_fd);

         return;

      /END-FREE
      *
     P MemoryWriter_delete...
     P                 E
      *
      *=========================================================================
      *  Returns the 'write' procedure of a MemoryWriter.
      *=========================================================================
      *  Parameters:
      *   void
      *
      *  Returns:
      *   pWriteProc    - Procedure pointer of the 'write' procedure
      *                   of a MemoryWriter.
      *=========================================================================
     P MemoryWriter_writeProc...
     P                 B                   export
      *
     D MemoryWriter_writeProc...
     D                 PI              *          procptr
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         return %paddr('BASICS1RH_MemoryWriter_write');

      /END-FREE
      *
     P MemoryWriter_writeProc...
     P                 E
      *
      *=========================================================================
      *  Creates a memory buffer reader.
      *=========================================================================
      *  Parameters:
      *   i_pBuffer     - Buffer data is read from.
      *   i_size        - Size of the buffer.
      *
      *  Returns:
      *   fd            - Buffer descriptor on success, else -1.
      *=========================================================================
     P MemoryReader_new...
     P                 B                   export
      *
     D MemoryReader_new...
     D                 PI                         like(memRdr_handle_t)
     D  i_pBuffer                      *   value
     D  i_size                             value  like(size_t         )
      *
      *  Return value
     D fd              S             10I 0 inz(RC_ERROR)
      *
      *  Local fields
      *
      *  Handle
     D hReader         DS                  likeds(reader_t ) based(pHReader)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         fd = HANDLE_new(HANDLE_TYPE_READER: %size(hReader));

         pHReader = HANDLE_getPointer(fd);

         clear hReader;
         hReader.fd     = fd;
         hReader.offset = 0;
         hReader.size   = i_size;
         hReader.pData  = i_pBuffer;

         return fd;

      /END-FREE
      *
     P MemoryReader_new...
     P                 E
      *
      *=========================================================================
      *  Reads from a given memory buffer descriptor.
      *=========================================================================
      *  Parameters:
      *   i_fd          - Descriptor as created by MemoryReader_new().
      *   i_pBuffer     - Buffer used to store the data taht was read
      *                   from the descriptor.
      *   i_nByte       - Length of the buffer.
      *
      *  Returns:
      *   fd            - Number of bytes read from the descriptor on
      *                   success, else -1.
      *=========================================================================
     P MemoryReader_read...
     P                 B                   export
      *
     D MemoryReader_read...
     D                 PI                         like(ssize_t        )
     D  i_fd                               value  like(memRdr_handle_t)
     D  i_pBuffer                      *   value
     D  i_nByte                            value  like(size_t         )
      *
      *  Return value
     D rc              S                   like(ssize_t ) inz(RC_ERROR)
      *
      *  Local fields
     D size            S                   like(rc      ) inz
     D pDest           S               *   inz
      *
      *  Handle
     D hReader         DS                  likeds(reader_t ) based(pHReader)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         if (not HANDLE_isTypeOf(i_fd: HANDLE_TYPE_READER));
            f_setErrno(EBADF_C);
            return RC_ERROR;
         endif;

         pHReader = HANDLE_getPointer(i_fd);

         if (hReader.offset + i_nByte > hReader.size);
            size = hReader.size - hReader.offset;
         else;
            size = i_nByte;
         endif;

         pDest = memcpy(i_pBuffer: hReader.pData + hReader.offset: size);
         if (pDest <> i_pBuffer);
            return RC_ERROR;
         endif;

         hReader.offset = hReader.offset + size;

         rc = size;

         return rc;

      /END-FREE
      *
     P MemoryReader_read...
     P                 E
      *
      *=========================================================================
      *  Deletes a given memory buffer reader.
      *=========================================================================
      *  Parameters:
      *   io_fd         - Descriptor as created by MemoryReader_new().
      *
      *  Returns:
      *   void
      *=========================================================================
     P MemoryReader_delete...
     P                 B                   export
      *
     D MemoryReader_delete...
     D                 PI
     D  io_fd                                     like(memRdr_handle_t)
      *
      *  Local fields
      *
      *  Handle
     D hReader         DS                  likeds(reader_t ) based(pHReader)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         if (not HANDLE_isTypeOf(io_fd: HANDLE_TYPE_READER));
            f_setErrno(EBADF_C);
            return;
         endif;

         pHReader = HANDLE_getPointer(io_fd);

         clear hReader;

         HANDLE_delete(io_fd);

         return;

      /END-FREE
      *
     P MemoryReader_delete...
     P                 E
      *
      *=========================================================================
      *  Returns the 'read' procedure of a MemoryReader.
      *=========================================================================
      *  Parameters:
      *   void
      *
      *  Returns:
      *   pWriteProc    - Procedure pointer of the 'read' procedure
      *                   of a MemoryReader.
      *=========================================================================
     P MemoryReader_readProc...
     P                 B                   export
      *
     D MemoryReader_readProc...
     D                 PI              *          procptr
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         return %paddr('BASICS1RH_MemoryReader_read');

      /END-FREE
      *
     P MemoryReader_readProc...
     P                 E
      *
