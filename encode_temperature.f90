program bufr_encode_temperature

    implicit none
    real(8) :: obs
    integer :: iret
   
    obs=10.15
   
   ! encode
    open(20,file='bufrtable.txt')
    open(10,file='t.bufr',action='write',form='unformatted')
    call openbf(10,'OUT',20)
      call openmb(10, 'ADPUPA', 08120100)
        call ufbint(10,obs,1,1,iret,'TOB')
        call writsb(10)
      call closmg(10)
    call closbf(10)
   
   end program