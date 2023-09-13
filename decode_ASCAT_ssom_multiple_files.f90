program decode_ASCAT_ssom_multiple_files

    implicit none
    
    character(300), dimension(:), allocatable :: fnames
    character(300) :: directory = '/Users/amfox/Desktop/bufr_reader/Metop_C/Y2023/M03' ! Replace with your directory path
    character(300) :: cmd
    character(300) :: tmpfname, tmpfname2

    integer :: i, N_files
    integer :: clock_start, clock_end, clock_rate

    real(8) :: elapsed_time
    
    tmpfname = trim(directory) // '/' // 'tmp.output'

    cmd = '/bin/rm -f ' // trim(tmpfname) 

    call Execute_command_line(trim(cmd))
    
    ! Build the command to list files in the directory
    cmd = 'ls ' // trim(directory) // '/*'

    cmd = trim(cmd) // ' >> ' // trim(tmpfname)

    call Execute_command_line(trim(cmd))
   
! find out how many need to be read
    
    tmpfname2 = trim(tmpfname) // '.wc'
    
    cmd = 'wc -w ' // trim(tmpfname) // ' >> ' // trim(tmpfname2)
    
    call Execute_command_line(trim(cmd))
    
    open(10, file=tmpfname2, form='formatted', action='read')
    
    read(10,*) N_files
    
    close(10,status='delete')
    
    ! load file names into "fnames"
    
    open(10, file=tmpfname,  form='formatted', action='read')

    call system_clock(clock_start) ! Start timing
    
    if (N_files>0) then
       
       allocate(fnames(N_files))
       
       do i=1,N_files
          read(10,'(a)') fnames(i)
          write(*,*) fnames(i)
          call decode_ASCAT_ssom(fnames(i))
       end do
       
    end if
    
    close(10,status='delete')

    call system_clock(clock_end, clock_rate) ! Stop timing
    elapsed_time=(real(clock_end-clock_start)/real(clock_rate))
    
    write (*,*) ' '
    write (*,*) '**** Elapsed time in decode_ASCAT_ssom: ', elapsed_time, ' seconds ****'

    contains 
    
    subroutine decode_ASCAT_ssom(fname)

        real*8, dimension(15) :: tmp_vdata
        real*8, dimension(:,:), allocatable :: tmp_data
    
        integer, parameter :: lnbufr = 50
        integer, parameter :: max_obs = 250000
        integer :: idate,iret
        integer :: ireadmg,ireadsb
        integer :: N_obs
    
        character(8)    :: subset
        character(300)  :: mastertable_path

        character(300), intent(in)  :: fname

    
    ! -------------------------------------------------------------------------
    
        mastertable_path = '/Users/amfox/Desktop/bufr_reader'
    
    !   Allocate the tmp_data array
        allocate(tmp_data(max_obs, 15))
    
        open(lnbufr, file=trim(fname), action='read',form='unformatted')
    
        call openbf(lnbufr,'SEC3', lnbufr)
        call mtinfo( trim(mastertable_path) // '/BUFR_mastertable/', 51, 52)
        call datelen(10)
    
        N_obs = 0        
        msg_report: do while(ireadmg(lnbufr,subset,idate) ==0)
            loop_report: do while(ireadsb(lnbufr) == 0)
                call ufbint(lnbufr,tmp_vdata,15,1,iret, & 
                'YEAR MNTH DAYS HOUR MINU SECO SSOM DOMO SMPF SMCF ALFR TPCX IWFR CLATH CLONH')
                N_obs = N_obs + 1
                tmp_data(N_obs,:) = tmp_vdata
            end do loop_report
        end do msg_report
    
        write(*,*) 'N_obs = ', N_obs
        write(*,*) tmp_vdata
    
        call closbf(lnbufr)
        close(lnbufr)

    end subroutine decode_ASCAT_ssom

end program decode_ASCAT_ssom_multiple_files