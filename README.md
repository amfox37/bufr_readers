# bufr_readers

## Example compilation and linking on Macbook
gfortran -c encode_temperature.f90  
gfortran -o encode_temperature.exe encode_temperature.o -L/Users/amfox/Desktop/bufr_reader/NCEPLIBS-bufr-bufr_v12.0.0/lib/lib -lbufr_4

## Example on Discover
gfortran -c  decode_temperature.f90  
gfortran -o decode_temperature.exe decode_temperature.o -L/discover/nobackup/amfox/NCEPLIBS-bufr-bufr_v12.0.0/lib/lib64 -lbufr_4

