**free
//=====================================================================*
//  BASICS1RH  - SrvPgm: Basic Routines - MemoryBufferRdrWtr           *
//=====================================================================*
//  Author  :  Thomas Raddatz                                          *
//  Date    :  16.07.2011                                              *
//  E-mail  :  thomas.raddatz@tools400.de                              *
//  Homepage:  www.tools400.de                                         *
//=====================================================================*
//                                                                     *
//  This software is free software, you can redistribute it and/or     *
//  modify it under the terms of the GNU General Public License (GPL)  *
//  as published by the Free Software Foundation.                      *
//                                                                     *
//  See GNU General Public License for details.                        *
//          http://www.opensource.org                                  *
//          http://www.opensource.org/licenses/gpl-license.html        *
//                                                                     *
//=====================================================================*
//  History:                                                           *
//                                                                     *
//  Datum       Name          Änderung                                 *
//  ----------  ------------  ---------------------------------------  *
//                                                                     *
//=====================================================================*
//   >>PRE-COMPILER<<                                                  *
//                                                                     *
//     >>CRTCMD<<  CRTRPGMOD    MODULE(&LI/&OB) +                      *
//                              SRCFILE(&SL/&SF) +                     *
//                              SRCMBR(&SM);                           *
//                                                                     *
//     >>COMPILE<<                                                     *
//       >>PARM<< OPTION(*EVENTF);                                     *
//       >>PARM<< TRUNCNBR(*NO);                                       *
//       >>PARM<< DBGVIEW(*LIST);                                      *
//       >>PARM<< TGTRLS(V7R3M0);                                      *
//     >>END-COMPILE<<                                                 *
//                                                                     *
//     >>EXECUTE<<                                                     *
//                                                                     *
//   >>END-PRE-COMPILER<<                                              *
//=====================================================================*
ctl-opt nomain bnddir('QSNAPI');
//  Standard H-Specs
/copy QBASICS1,H_SPEC
/copy QBASICS1,COPYRIGHT
//=====================================================================*

// -----------------------------------------
//  Exported functions
// -----------------------------------------
/copy QBASICS1,PBASICS1RH

// -----------------------------------------
//  Reference fields
// -----------------------------------------
/copy QBASICS1,BASICS1R0

dcl-ds reader_t qualified based(pDummy);
  fd     int(10);
  offset int(10);
  size   int(10);
  pData  pointer;
end-ds;

dcl-ds writer_t qualified based(pDummy);
  fd     int(10);
  offset int(10);
  size   int(10);
  pData  pointer;
end-ds;

// -----------------------------------------
//  Private prototypes
// -----------------------------------------

// -----------------------------------------
//  Imported prototypes
// -----------------------------------------
/copy QBASICS1,CLIB                          C Runtime Library

/copy QBASICS1,PBASICS1R2                    API Error Handling
/copy QBASICS1,PBASICS1R8                    Handle/Memory

// -----------------------------------------
//  Global constants
// -----------------------------------------
dcl-c HANDLE_TYPE_WRITER '*MEMORY_WRITER';
dcl-c HANDLE_TYPE_READER '*MEMORY_READER';

// -----------------------------------------
//  Global fields
// -----------------------------------------

//=========================================================================
//  Creates a memory buffer writer.
//=========================================================================
//  Parameters:
//   i_pBuffer     - Buffer data is written to.
//   i_maxSize     - Maximum size of the buffer.
//
//  Returns:
//   fd            - Buffer descriptor on success, else -1.
//=========================================================================
dcl-proc MemoryWriter_new export;
  dcl-pi *n like(memWtr_handle_t);
    i_pBuffer pointer value;
    i_maxSize like(size_t) value;
  end-pi;

  //  Return value
  dcl-s fd int(10) inz(RC_ERROR);

  //  Local fields

  //  Handle
  dcl-ds hWriter likeds(writer_t) based(pHWriter);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  fd = HANDLE_new(HANDLE_TYPE_WRITER: %size(hWriter));

  pHWriter = HANDLE_getPointer(fd);

  clear hWriter;
  hWriter.fd     = fd;
  hWriter.offset = 0;
  hWriter.size   = i_maxSize;
  hWriter.pData  = i_pBuffer;

  return fd;


end-proc;

//=========================================================================
//  Write to a given memory buffer descriptor.
//=========================================================================
//  Parameters:
//   i_fd          - Descriptor as created by MemoryWriter_new().
//   i_pBuffer     - Buffer that is written to the descriptor.
//   i_buflen      - Length of the buffer.
//
//  Returns:
//   fd            - Number of bytes written to the descriptor on
//                   success, else -1.
//=========================================================================
dcl-proc MemoryWriter_write export;
  dcl-pi *n like(ssize_t);
    i_fd      like(memWtr_handle_t) value;
    i_pBuffer pointer value;
    i_buflen  like(size_t) value;
  end-pi;

  //  Return value
  dcl-s rc like(ssize_t) inz(RC_ERROR);

  //  Local fields
  dcl-s size like(rc) inz;
  dcl-s pDest pointer inz;

  //  Handle
  dcl-ds hWriter likeds(writer_t) based(pHWriter);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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


end-proc;

//=========================================================================
//  Deletes a given memory buffer writer.
//=========================================================================
//  Parameters:
//   io_fd         - Descriptor as created by MemoryWriter_new().
//
//  Returns:
//   void
//=========================================================================
dcl-proc MemoryWriter_delete export;
  dcl-pi *n;
    io_fd like(memWtr_handle_t);
  end-pi;

  //  Local fields

  //  Handle
  dcl-ds hWriter likeds(writer_t) based(pHWriter);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (not HANDLE_isTypeOf(io_fd: HANDLE_TYPE_WRITER));
    f_setErrno(EBADF_C);
    return;
  endif;

  pHWriter = HANDLE_getPointer(io_fd);

  clear hWriter;

  HANDLE_delete(io_fd);

  return;


end-proc;

//=========================================================================
//  Returns the 'write' procedure of a MemoryWriter.
//=========================================================================
//  Parameters:
//   void
//
//  Returns:
//   pWriteProc    - Procedure pointer of the 'write' procedure
//                   of a MemoryWriter.
//=========================================================================
dcl-proc MemoryWriter_writeProc export;
  dcl-pi *n pointer(*proc);
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  return %paddr('BASICS1RH_MemoryWriter_write');


end-proc;

//=========================================================================
//  Creates a memory buffer reader.
//=========================================================================
//  Parameters:
//   i_pBuffer     - Buffer data is read from.
//   i_size        - Size of the buffer.
//
//  Returns:
//   fd            - Buffer descriptor on success, else -1.
//=========================================================================
dcl-proc MemoryReader_new export;
  dcl-pi *n like(memRdr_handle_t);
    i_pBuffer pointer value;
    i_size    like(size_t) value;
  end-pi;

  //  Return value
  dcl-s fd int(10) inz(RC_ERROR);

  //  Local fields

  //  Handle
  dcl-ds hReader likeds(reader_t) based(pHReader);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  fd = HANDLE_new(HANDLE_TYPE_READER: %size(hReader));

  pHReader = HANDLE_getPointer(fd);

  clear hReader;
  hReader.fd     = fd;
  hReader.offset = 0;
  hReader.size   = i_size;
  hReader.pData  = i_pBuffer;

  return fd;


end-proc;

//=========================================================================
//  Reads from a given memory buffer descriptor.
//=========================================================================
//  Parameters:
//   i_fd          - Descriptor as created by MemoryReader_new().
//   i_pBuffer     - Buffer used to store the data taht was read
//                   from the descriptor.
//   i_nByte       - Length of the buffer.
//
//  Returns:
//   fd            - Number of bytes read from the descriptor on
//                   success, else -1.
//=========================================================================
dcl-proc MemoryReader_read export;
  dcl-pi *n like(ssize_t);
    i_fd      like(memRdr_handle_t) value;
    i_pBuffer pointer value;
    i_nByte   like(size_t) value;
  end-pi;

  //  Return value
  dcl-s rc like(ssize_t) inz(RC_ERROR);

  //  Local fields
  dcl-s size like(rc) inz;
  dcl-s pDest pointer inz;

  //  Handle
  dcl-ds hReader likeds(reader_t) based(pHReader);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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


end-proc;

//=========================================================================
//  Deletes a given memory buffer reader.
//=========================================================================
//  Parameters:
//   io_fd         - Descriptor as created by MemoryReader_new().
//
//  Returns:
//   void
//=========================================================================
dcl-proc MemoryReader_delete export;
  dcl-pi *n;
    io_fd like(memRdr_handle_t);
  end-pi;

  //  Local fields

  //  Handle
  dcl-ds hReader likeds(reader_t) based(pHReader);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (not HANDLE_isTypeOf(io_fd: HANDLE_TYPE_READER));
    f_setErrno(EBADF_C);
    return;
  endif;

  pHReader = HANDLE_getPointer(io_fd);

  clear hReader;

  HANDLE_delete(io_fd);

  return;


end-proc;

//=========================================================================
//  Returns the 'read' procedure of a MemoryReader.
//=========================================================================
//  Parameters:
//   void
//
//  Returns:
//   pWriteProc    - Procedure pointer of the 'read' procedure
//                   of a MemoryReader.
//=========================================================================
dcl-proc MemoryReader_readProc export;
  dcl-pi *n pointer(*proc);
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  return %paddr('BASICS1RH_MemoryReader_read');


end-proc;