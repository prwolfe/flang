/*
 * Copyright (c) 1996-2018, NVIDIA CORPORATION.  All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

/*
 * This module is for SMP systems.  It assumes that all processors share
 * a common system buffer pool and that the buffers are kept consistent.
 * It also works for some other systems such as the Paragon.
 */

#include <fcntl.h>

#include <sys/types.h>
#include "fioMacros.h"
#include <stdioInterf.h>

#if !defined(FD_SETSIZE)
#define FD_SETSIZE 1024
#endif

/* more internal flags */

#define I_READ 0x0100  /* reading */
#define I_WRITE 0x0200 /* writing */

/* data per fd */

static struct {
  int flags; /* flags */
  long pof;  /* physical offset in file */
  long vof;  /* virtual offset in file */
  long eof;  /* end of file */
} fds[FD_SETSIZE];

/* open file */

int
__fort_par_open(char *fn, char *par)
{
  int nflags;
  int mode;
  int fd;
  char *p;

  nflags = 0;
  mode = 0666;
  p = par;
  if (p == NULL) {
    p = "";
  }
  while (*p != '\0') { /* process system-specific options */
    if (strncmp(p, "rdonly", 6) == 0) {
      p += 6;
      nflags |= O_RDONLY;
    } else if (strncmp(p, "wronly", 6) == 0) {
      p += 6;
      nflags |= O_WRONLY;
    } else if (strncmp(p, "rdwr", 4) == 0) {
      p += 4;
      nflags |= O_RDWR;
    } else if (strncmp(p, "creat", 5) == 0) {
      p += 5;
      nflags |= O_CREAT;
      if (*p == '=') {
        p++;
        mode = strtol(p, &p, 0);
      }
    } else if (strncmp(p, "trunc", 5) == 0) {
      p += 5;
      nflags |= O_TRUNC;
    } else if (strncmp(p, "sync", 4) == 0) {
      p += 4;
      nflags |= O_SYNC;
    }
    while ((*p != '\0') && (*p != ',')) {
      p++;
    }
    if (*p == ',') {
      p++;
    }
  }

  fd = open(fn, nflags, mode);
  if (fd == -1) {
    __fort_abortp(fn);
  }
  fds[fd].flags = 0;
  fds[fd].pof = 0;
  fds[fd].vof = 0;
  fds[fd].eof = lseek(fd, 0, 2);
  lseek(fd, 0, 0);
  __fort_barrier();
  return (fd);
}

/* read from file */

__CLEN_T
__fort_par_read(int fd, char *adr, __CLEN_T cnt, int str, int typ,
                __CLEN_T ilen, int own)
{
  long l;
  int s;

  if (fds[fd].flags & I_WRITE) {
    __fort_barrier();
    fds[fd].eof = lseek(fd, 0, 2);
    lseek(fd, fds[fd].pof, 0);
    fds[fd].flags &= ~I_WRITE;
  }
  fds[fd].flags |= I_READ;
  if (fds[fd].pof >= fds[fd].eof) {
    return (0);
  }
  if (adr != (char *)0) {
    s = read(fd, adr, cnt * ilen);
    if (s == -1) {
      __fort_abortp("parallel i/o");
    }
    if (s != (cnt * ilen)) {
      __fort_abort("parallel i/o: partial read");
    }
  } else {
    s = lseek(fd, cnt * ilen, 1);
    if (s == -1) {
      __fort_abortp("parallel i/o");
    }
  }
  fds[fd].pof += cnt * ilen;
  return (cnt * ilen);
}

/* write to file */

__CLEN_T
__fort_par_write(int fd, char *adr, __CLEN_T cnt, int str, int typ,
                 __CLEN_T ilen, int own)
{
  int s;

  if (fds[fd].flags & I_READ) {
    __fort_barrier();
    fds[fd].flags &= ~I_READ;
  }
  fds[fd].flags |= I_WRITE;

  if (GET_DIST_LCPU == own) {
    s = write(fd, adr, cnt * ilen);
  } else {
    s = lseek(fd, cnt * ilen, 1);
  }
  if (s == -1) {
    __fort_abortp("parallel i/o");
  }
  fds[fd].pof += cnt * ilen;
  return (cnt * ilen);
}

/* seek in file */

void
__fort_par_seek(int fd, long off[2], int whence)
{
  long s;

  s = lseek(fd, off[1], whence);
  if (s == -1) {
    __fort_abortp("parallel i/o");
  }
  off[0] = 0;
  off[1] = s;
  fds[fd].pof = s;
}

/* close file */

void
__fort_par_close(int fd)
{
  int s;

  __fort_barrier();
  s = close(fd);
  if (s == -1) {
    __fort_abortp("parallel i/o");
  }
}

/* unlink file */

void
__fort_par_unlink(char *fn)
{
  __fort_barrier();
  if (GET_DIST_LCPU == 0) {
    if (unlink(fn) == -1) {
      __fort_abortp(fn);
    }
  }
  __fort_barrier();
}

