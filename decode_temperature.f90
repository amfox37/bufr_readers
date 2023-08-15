program bufr_decode_temperature
    implicit none
    real(8) :: obs
    character(8) subset
    integer :: idate,iret
   
   ! decode
    open(10,file='t.bufr',action='read',form='unformatted')
    call openbf(10,'IN',10)
      call readmg(10,subset,idate,iret) 
        call readsb(10,iret)
        call ufbint(10,obs,1,1,iret,'TOB')
        write(*,*) obs
    call closbf(10)
   
   end program