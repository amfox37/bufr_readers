program read_directory_files
    implicit none
    
    character(100), dimension(:), allocatable :: fnames
    integer :: i, N_files
    character(100) :: directory = '/Users/amfox/Desktop/bufr_reader/Metop_C/Y2023/M03' ! Replace with your directory path
    character(300) :: cmd
    character(300) :: tmpfname, tmpfname2
    
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
    
    if (N_files>0) then
       
       allocate(fnames(N_files))
       
       do i=1,N_files
          read(10,'(a)') fnames(i)
          write(*,*) fnames(i)
       end do
       
    end if
    
    close(10,status='delete')
    
end program read_directory_files