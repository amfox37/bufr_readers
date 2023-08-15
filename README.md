# bufr_readers

## Example compilation and linking
gfortran -c encode_temperature.f90  
gfortran -o encode_temperature.exe encode_temperature.o -L/Users/amfox/Desktop/bufr_reader/NCEPLIBS-bufr-bufr_v12.0.0/lib/lib -lbufr_4
