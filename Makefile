# -----------------------------------------------------------------------------
# Setup...
# -----------------------------------------------------------------------------

# Executables...
EXC = retrieval

# Library directories...
LIBDIR = -L ../lib/build/lib -L $(HOME)/lib

# Include directories...
INCDIR = -I ../lib/build/include -I $(HOME)/include

# Linking...
#STATIC = 1

# Profiling...
#PROF = 1

# -----------------------------------------------------------------------------
# Set flags for GNU compiler...
# -----------------------------------------------------------------------------

# Compiler...
CC = gcc
MPICC = mpicc

# CFLAGS...
CFLAGS = $(INCDIR) -DHAVE_INLINE -DGSL_DISABLE_DEPRACTED $(DEFS) -pedantic -Werror -Wall -W -Wmissing-prototypes -Wstrict-prototypes -Wconversion -Wshadow -Wpointer-arith -Wcast-qual -Wcast-align -Wnested-externs -Wno-long-long -Wmissing-declarations -Wredundant-decls -Winline -fno-common -fshort-enums -fopenmp

# LDFLAGS...
LDFLAGS = $(LIBDIR) -lgsl -lgslcblas -lm -lairs -lhdfeos -lGctp -lmfhdf -ldf -lz -ljpeg -lnsl -lnetcdf -lm

# LDFLAGS fpr retrieval...
LDFLAGS_RET = $(LIBDIR) -lgsl -lgslcblas -lm -lnetcdf -lm

# Profiling...
ifdef PROF
  CFLAGS += -O2 -g -pg 
else
  CFLAGS += -O3
endif

# Linking...
ifdef STATIC
  CFLAGS += -static
endif

# -----------------------------------------------------------------------------
# Targets...
# -----------------------------------------------------------------------------

all: $(EXC)
	rm -f *~

$(EXC): %: %.c jurassic.o
	$(MPICC) $(CFLAGS) -o $@ $< jurassic.o $(LDFLAGS_RET)

jurassic.o: jurassic.c jurassic.h Makefile
	$(CC) $(CFLAGS) -c -o jurassic.o jurassic.c

bak:
	tar chzf airs_`date +"%y%m%d%H%M"`.tgz Makefile *.c *.h

clean:
	rm -f $(EXC) *.o *~

indent:
	indent -br -brf -brs -bfda -ce -cdw -lp -npcs -npsl *.c *.h
