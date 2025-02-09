! DART software - Copyright UCAR. This open source software is provided
! by UCAR, "as is", without charge, subject to all terms of use at
! http://www.image.ucar.edu/DAReS/DART/DART_download
!
! $Id: file_utils_test.f90 11289 2017-03-10 21:56:06Z hendric@ucar.edu $

program file_utils_test

use     types_mod,     only : r8
use utilities_mod,     only : register_module, error_handler, E_ERR, E_MSG, E_ALLMSG, &
                              find_namelist_in_file, check_namelist_read,             &
                              do_nml_file, do_nml_term, nmlfileunit
use mpi_utilities_mod, only : initialize_mpi_utilities, finalize_mpi_utilities,       &
                              task_sync, my_task_id

implicit none

! version controlled file description for error handling, do not edit
character(len=256), parameter :: source   = &
   "$URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/recam/developer_tests/utilities/file_utils_test.f90 $"
character(len=32 ), parameter :: revision = "$Revision: 11289 $"
character(len=128), parameter :: revdate  = "$Date: 2017-03-10 14:56:06 -0700 (Fri, 10 Mar 2017) $"

logical, save :: module_initialized = .false.

character(len=128) :: msgstring
integer :: iunit, io
character(len=8) :: task_id
integer  :: test1
logical  :: test2
real(r8) :: test3

! namelist items we are going to create/overwrite
namelist /file_utils_test_nml/  test1, test2, test3

! main code here
 

!----------------------------------------------------------------------
! mkdir test; cd test; then:
!  touch dart_log.out; chmod 0 dart_log.out
!  chmod 0 input.nml
!  rm input.nml (no nml file)
!  rm input.nml; touch input.nml (0 length nml file)
!  rm input.nml; echo &bob > input.nml  (no trailing / )
!  rm input.nml; echo &utilities_nml > input.nml  (no trailing / )
!  rm input.nml; echo &file_utils_test_nml > input.nml
!                echo / > input.nml (no &utilities_nml )
! and run this test
!----------------------------------------------------------------------

! initialize the dart libs
call initialize_mpi_utilities('file_utils_test')
call register_module(source, revision, revdate)

! Read the namelist entry
call find_namelist_in_file("input.nml", "file_utils_test_nml", iunit)
read(iunit, nml = file_utils_test_nml, iostat = io)
call check_namelist_read(iunit, io, "file_utils_test_nml")

! Record the namelist values used for the run ...
if (do_nml_file()) write(nmlfileunit, nml=file_utils_test_nml)
if (do_nml_term()) write(     *     , nml=file_utils_test_nml)

write(task_id, '(i5)' ) my_task_id()

! finalize file_utils_test
call error_handler(E_MSG,'file_utils_test','Finished successfully.',source,revision,revdate)
call finalize_mpi_utilities()

! end of main code

!----------------------------------------------------------------------

end program

! <next few lines under version control, do not edit>
! $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/recam/developer_tests/utilities/file_utils_test.f90 $
! $Id: file_utils_test.f90 11289 2017-03-10 21:56:06Z hendric@ucar.edu $
! $Revision: 11289 $
! $Date: 2017-03-10 14:56:06 -0700 (Fri, 10 Mar 2017) $
