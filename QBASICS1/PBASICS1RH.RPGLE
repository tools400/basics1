      /IF NOT DEFINED(BASICS1RH)
      /DEFINE BASICS1RH
      *
      /COPY QBASICS1,CLIB                          C Runtime Library
      *
     D memWtr_handle_t...
     D                 S             10I 0                    based(pDummy)
     D memRdr_handle_t...
     D                 S             10I 0                    based(pDummy)
      *
      *  Creates a memory buffer writer.
     D MemoryWriter_new...
     D                 PR                         like(memWtr_handle_t)
     D                                     extproc('BASICS1RH+
     D                                     _MemoryWriter_new+
     D                                     ')
     D  i_pBuffer                      *   value
     D  i_maxSize                          value  like(size_t         )
      *
      *  Write to a given memory buffer descriptor.
     D MemoryWriter_write...
     D                 PR                          like(ssize_t       )         = ssize_t
     D                                     extproc('BASICS1RH+
     D                                     _MemoryWriter_write+
     D                                     ')
     D  i_fd                               value  like(memWtr_handle_t)         = int
     D  i_pBuffer                      *   value                                = *buf
     D  i_buflen                           value  like(size_t         )         = size_t
      *
      *  Deletes a given memory buffer writer.
     D MemoryWriter_delete...
     D                 PR
     D                                     extproc('BASICS1RH+
     D                                     _MemoryWriter_delete+
     D                                     ')
     D  io_fd                                     like(memWtr_handle_t)
      *
      *  Returns the 'write' procedure of a MemoryWriter.
     D MemoryWriter_writeProc...
     D                 PR              *          procptr
     D                                     extproc('BASICS1RH+
     D                                     _MemoryWriter_writeProc+
     D                                     ')
      *
      *  Creates a memory buffer reader.
     D MemoryReader_new...
     D                 PR                         like(memRdr_handle_t)
     D                                     extproc('BASICS1RH+
     D                                     _MemoryReader_new+
     D                                     ')
     D  i_pBuffer                      *   value
     D  i_size                             value  like(size_t         )
      *
      *  Reads from a given memory buffer descriptor.
     D MemoryReader_read...
     D                 PR                         like(ssize_t        )         = ssize_t
     D                                     extproc('BASICS1RH+
     D                                     _MemoryReader_read+
     D                                     ')
     D  i_fd                               value  like(memRdr_handle_t)         = int
     D  i_pBuffer                      *   value                                = *buf
     D  i_nByte                            value  like(size_t    )              = size_t
      *
      *  Deletes a given memory buffer Reader.
     D MemoryReader_delete...
     D                 PR
     D                                     extproc('BASICS1RH+
     D                                     _MemoryReader_delete+
     D                                     ')
     D  io_fd                                     like(memRdr_handle_t)
      *
      *  Returns the 'read' procedure of a MemoryReader.
     D MemoryReader_readProc...
     D                 PR              *          procptr
     D                                     extproc('BASICS1RH+
     D                                     _MemoryReader_readProc+
     D                                     ')
      *
      * -----------------------------------------
      *  Imported prototypes
      * -----------------------------------------
      *
      /ENDIF
