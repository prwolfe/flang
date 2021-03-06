!** Copyright (c) 1989, NVIDIA CORPORATION.  All rights reserved.
!**
!** Licensed under the Apache License, Version 2.0 (the "License");
!** you may not use this file except in compliance with the License.
!** You may obtain a copy of the License at
!**
!**     http://www.apache.org/licenses/LICENSE-2.0
!**
!** Unless required by applicable law or agreed to in writing, software
!** distributed under the License is distributed on an "AS IS" BASIS,
!** WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
!** See the License for the specific language governing permissions and
!** limitations under the License.

!* Tests for runtime library MATMUL routines

program p

  parameter(NbrTests=1414)
  
  integer*1, dimension(3) :: arr1
  integer*1, dimension(3,4) :: arr2
  integer*1, dimension(4) :: arr3
  integer*1, dimension(4,4) :: arr4
  integer*1, dimension(0:3,-1:1) :: arr5
  integer*1, dimension(-3:-1) :: arr6
  integer*1, dimension(-1:2,0:3) :: arr7
  integer*1, dimension(3) :: arr8
  integer*1, dimension(2:4,4) :: arr9
  integer*1, dimension(4) :: arr10
  integer*1, dimension(3,2:5) :: arr11
  integer*1, dimension(4) :: arr12
  integer*1, dimension(11) :: arr20
  integer*1, dimension(11) :: arr13
  integer*1, dimension(11,11) :: arr14
  integer*1, dimension(2,11) :: arr15
  integer*1, dimension(389) :: arr16
  integer*1, dimension(389,387) :: arr17
  integer*1, dimension(387) :: arr18
  integer*1, dimension(2,387) :: arr19

  
  data arr1 /0,1,2/
  data arr5 /0,1,2,3,4,5,6,7,8,9,10,11/
  data arr2 /0,1,2,3,4,5,6,7,8,9,10,11/
  data arr6 /0,1,2/
  data arr3 /0,1,2,3/
  data arr4 /0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15/
  data arr7 /0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15/
  data arr8 /0,1,2/
  data arr9 /0,1,2,3,4,5,6,7,8,9,10,11/
  data arr11 /0,1,2,3,4,5,6,7,8,9,10,11/
  data arr10 /0,1,2,3/
  
  integer*4 :: expect(NbrTests)
  integer*4 :: results(NbrTests)
  
  data expect / &
  ! tests 1-4
      5, 14, 23, 32, &
  ! tests 5-8
      0, 14, 23, 32, &
  ! tests 9-12
      14, 23, 32, 0, &
  ! tests 13-16
      0, 5, 14, 23, &
  ! tests 17-20
      0, 4, 7, 10, &
  ! tests 21-24
      2, 5, 8, 11, &
  ! tests 25-28
      2, 11, 20, 29, &
  ! tests 29-32
      0, 2, 11, 20, &
  ! tests 33-36
      5, 8, 11, 0, &
  ! tests 37-40
      10, 16, 22, 0, &
  ! tests 41-44
      0, 2, 0, 20, &
  ! tests 45-48
      5, 0, 11, 0, &
  ! tests 49-64
      0, 5, 0, 0, 0, 0, 0, 0, 0, &
      11, 0, 0, 0, 0, 0, 0, &
  ! tests 65-80
      0, 0, 0, 0, 0, 0, 0, 0, 5, &
      0, 11, 0, 0, 0, 0, 0, &
  ! tests 81-96
    0, 7, 0, 0, 0, 0, 0, 0, 0, &
    11, 0, 0, 0, 0, 0, 0, &
  ! tests 97-112
      0, 0, 0, 0, 0, 0, 0, 0, 19, &
      0, 31, 0, 0, 0, 0, 0, &
  ! tests 113-116
      18, 12, 6, 0, &
  ! tests 117-120
      0, 1, 0, 19, &
  ! tests 121-136
      0, 4, 0, 0, 0, 0, 0, 0, 0, &
      10, 0, 0, 0, 0, 0, 0, &
  ! tests 137-152
      0, 0, 0, 0, 0, 0, 0, 0, 11, &
      0, 5, 0, 0, 0, 0, 0, &
  ! tests 153-168
    0, 11, 0, 0, 0, 0, 0, 0, 0, &
    7, 0, 0, 0, 0, 0, 0, &
  ! tests 169-184
      0, 0, 0, 0, 0, 0, 0, 0, 31, &
      0, 19, 0, 0, 0, 0, 0, &
  ! tests 185-188
      5, 14, 23, 32, &
  ! tests 187-192
      5, 14, 23, 32, &
 ! tests 193-196
      14, 23, 32, 0, &
  ! tests 197-200
      0, 5, 14, 23, &
  ! tests 201-204
      0, 4, 7, 10, &
  ! tests 205-208
      2, 5, 8, 11, &
  ! tests 209-212
      2, 11, 20, 29, &
  ! tests 213-216
      0, 2, 11, 20, &
  ! tests 217-220
      5, 8, 11, 0, &
 ! test 225,235
     6, 0, 6, 0, 6, 0, 6, 0, 6, 0, 6, &
 ! test 236,257
     6, 0, 0, 0, 6, 0, 0, 0, 6, 0, 0, 0, 6, &
     0, 0, 0, 6, 0, 0, 0, 6, 0, &
 ! test 258,644
  -110, 36, -74, 72, -38, 108, 0, -110, 36, -74, 72, -38, 108, &
     0, -110, 36, -74, 72, -38, 108, 0, -110, 36, -74, 72, -38, &
   108, 0, -110, 36, -74, 72, -38, 108, 0, -110, 36, -74, 72, &
   -38, 108, 0, -110, 36, -74, 72, -38, 108, 0, -110, 36, -74, &
    72, -38, 108, 0, -110, 36, -74, 72, -38, 108, 0, -110, 36, &
   -74, 72, -38, 108, 0, -110, 36, -74, 72, -38, 108, 0, -110, &
    36, -74, 72, -38, 108, 0, -110, 36, -74, 72, -38, 108, 0, &
  -110, 36, -74, 72, -38, 108, 0, -110, 36, -74, 72, -38, 108, &
     0, -110, 36, -74, 72, -38, 108, 0, -110, 36, -74, 72, -38, &
   108, 0, -110, 36, -74, 72, -38, 108, 0, -110, 36, -74, 72, &
   -38, 108, 0, -110, 36, -74, 72, -38, 108, 0, -110, 36, -74, &
    72, -38, 108, 0, -110, 36, -74, 72, -38, 108, 0, -110, 36, &
   -74, 72, -38, 108, 0, -110, 36, -74, 72, -38, 108, 0, -110, &
    36, -74, 72, -38, 108, 0, -110, 36, -74, 72, -38, 108, 0, &
  -110, 36, -74, 72, -38, 108, 0, -110, 36, -74, 72, -38, 108, &
     0, -110, 36, -74, 72, -38, 108, 0, -110, 36, -74, 72, -38, &
   108, 0, -110, 36, -74, 72, -38, 108, 0, -110, 36, -74, 72, &
   -38, 108, 0, -110, 36, -74, 72, -38, 108, 0, -110, 36, -74, &
    72, -38, 108, 0, -110, 36, -74, 72, -38, 108, 0, -110, 36, &
   -74, 72, -38, 108, 0, -110, 36, -74, 72, -38, 108, 0, -110, &
    36, -74, 72, -38, 108, 0, -110, 36, -74, 72, -38, 108, 0, &
  -110, 36, -74, 72, -38, 108, 0, -110, 36, -74, 72, -38, 108, &
     0, -110, 36, -74, 72, -38, 108, 0, -110, 36, -74, 72, -38, &
   108, 0, -110, 36, -74, 72, -38, 108, 0, -110, 36, -74, 72, &
   -38, 108, 0, -110, 36, -74, 72, -38, 108, 0, -110, 36, -74, &
    72, -38, 108, 0, -110, 36, -74, 72, -38, 108, 0, -110, 36, &
   -74, 72, -38, 108, 0, -110, 36, -74, 72, -38, 108, 0, -110, &
    36, -74, 72, -38, 108, 0, -110, 36, -74, 72, -38, 108, 0, &
  -110, 36, -74, 72, -38, 108, 0, -110, 36, -74, 72, -38, 108, &
     0, -110, 36, -74, 72, -38, 108, 0, -110, 36, &
 ! test 645,1418
  -110, 0, 36, 0, -74, 0, 72, 0, -38, 0, 108, 0, 0, &
     0, -110, 0, 36, 0, -74, 0, 72, 0, -38, 0, 108, 0, &
     0, 0, -110, 0, 36, 0, -74, 0, 72, 0, -38, 0, 108, &
     0, 0, 0, -110, 0, 36, 0, -74, 0, 72, 0, -38, 0, &
   108, 0, 0, 0, -110, 0, 36, 0, -74, 0, 72, 0, -38, &
     0, 108, 0, 0, 0, -110, 0, 36, 0, -74, 0, 72, 0, &
   -38, 0, 108, 0, 0, 0, -110, 0, 36, 0, -74, 0, 72, &
     0, -38, 0, 108, 0, 0, 0, -110, 0, 36, 0, -74, 0, &
    72, 0, -38, 0, 108, 0, 0, 0, -110, 0, 36, 0, -74, &
     0, 72, 0, -38, 0, 108, 0, 0, 0, -110, 0, 36, 0, &
   -74, 0, 72, 0, -38, 0, 108, 0, 0, 0, -110, 0, 36, &
     0, -74, 0, 72, 0, -38, 0, 108, 0, 0, 0, -110, 0, &
    36, 0, -74, 0, 72, 0, -38, 0, 108, 0, 0, 0, -110, &
     0, 36, 0, -74, 0, 72, 0, -38, 0, 108, 0, 0, 0, &
  -110, 0, 36, 0, -74, 0, 72, 0, -38, 0, 108, 0, 0, &
     0, -110, 0, 36, 0, -74, 0, 72, 0, -38, 0, 108, 0, &
     0, 0, -110, 0, 36, 0, -74, 0, 72, 0, -38, 0, 108, &
     0, 0, 0, -110, 0, 36, 0, -74, 0, 72, 0, -38, 0, &
   108, 0, 0, 0, -110, 0, 36, 0, -74, 0, 72, 0, -38, &
     0, 108, 0, 0, 0, -110, 0, 36, 0, -74, 0, 72, 0, &
   -38, 0, 108, 0, 0, 0, -110, 0, 36, 0, -74, 0, 72, &
     0, -38, 0, 108, 0, 0, 0, -110, 0, 36, 0, -74, 0, &
    72, 0, -38, 0, 108, 0, 0, 0, -110, 0, 36, 0, -74, &
     0, 72, 0, -38, 0, 108, 0, 0, 0, -110, 0, 36, 0, &
   -74, 0, 72, 0, -38, 0, 108, 0, 0, 0, -110, 0, 36, &
     0, -74, 0, 72, 0, -38, 0, 108, 0, 0, 0, -110, 0, &
    36, 0, -74, 0, 72, 0, -38, 0, 108, 0, 0, 0, -110, &
     0, 36, 0, -74, 0, 72, 0, -38, 0, 108, 0, 0, 0, &
  -110, 0, 36, 0, -74, 0, 72, 0, -38, 0, 108, 0, 0, &
     0, -110, 0, 36, 0, -74, 0, 72, 0, -38, 0, 108, 0, &
     0, 0, -110, 0, 36, 0, -74, 0, 72, 0, -38, 0, 108, &
     0, 0, 0, -110, 0, 36, 0, -74, 0, 72, 0, -38, 0, &
   108, 0, 0, 0, -110, 0, 36, 0, -74, 0, 72, 0, -38, &
     0, 108, 0, 0, 0, -110, 0, 36, 0, -74, 0, 72, 0, &
   -38, 0, 108, 0, 0, 0, -110, 0, 36, 0, -74, 0, 72, &
     0, -38, 0, 108, 0, 0, 0, -110, 0, 36, 0, -74, 0, &
    72, 0, -38, 0, 108, 0, 0, 0, -110, 0, 36, 0, -74, &
     0, 72, 0, -38, 0, 108, 0, 0, 0, -110, 0, 36, 0, &
   -74, 0, 72, 0, -38, 0, 108, 0, 0, 0, -110, 0, 36, &
     0, -74, 0, 72, 0, -38, 0, 108, 0, 0, 0, -110, 0, &
    36, 0, -74, 0, 72, 0, -38, 0, 108, 0, 0, 0, -110, &
     0, 36, 0, -74, 0, 72, 0, -38, 0, 108, 0, 0, 0, &
  -110, 0, 36, 0, -74, 0, 72, 0, -38, 0, 108, 0, 0, &
     0, -110, 0, 36, 0, -74, 0, 72, 0, -38, 0, 108, 0, &
     0, 0, -110, 0, 36, 0, -74, 0, 72, 0, -38, 0, 108, &
     0, 0, 0, -110, 0, 36, 0, -74, 0, 72, 0, -38, 0, &
   108, 0, 0, 0, -110, 0, 36, 0, -74, 0, 72, 0, -38, &
     0, 108, 0, 0, 0, -110, 0, 36, 0, -74, 0, 72, 0, &
   -38, 0, 108, 0, 0, 0, -110, 0, 36, 0, -74, 0, 72, &
     0, -38, 0, 108, 0, 0, 0, -110, 0, 36, 0, -74, 0, &
    72, 0, -38, 0, 108, 0, 0, 0, -110, 0, 36, 0, -74, &
     0, 72, 0, -38, 0, 108, 0, 0, 0, -110, 0, 36, 0, &
   -74, 0, 72, 0, -38, 0, 108, 0, 0, 0, -110, 0, 36, &
     0, -74, 0, 72, 0, -38, 0, 108, 0, 0, 0, -110, 0, &
    36, 0, -74, 0, 72, 0, -38, 0, 108, 0, 0, 0, -110, &
     0, 36, 0, -74, 0, 72, 0, -38, 0, 108, 0, 0, 0, &
  -110, 0, 36, 0, -74, 0, 72, 0, -38, 0, 108, 0, 0, &
     0, -110, 0, 36, 0, -74, 0, 72, 0, -38, 0, 108, 0, &
     0, 0, -110, 0, 36, 0, -74, 0, 72, 0, -38, 0, 108, &
     0, 0, 0, -110, 0, 36, 0 /
  
  ! tests 1-4
  arr3=0
  arr3 = matmul(arr1,arr2)
  call assign_result(1,4,arr3,results)
  !print *,arr3
  
  ! tests 5-8
  arr3=0
  arr3(2:4) = matmul(arr1,arr2(:, 2:4))
  call assign_result(5,8,arr3,results)
  !print *,arr3
  
  ! tests 9-12
  arr3=0
  arr3(1:3) = matmul(arr1,arr2(:,2:4))
  call assign_result(9,12,arr3,results)
  !print *,arr3
  
  !tests 13-16
  arr3=0
  arr3(2:4) = matmul(arr1,arr2(:, 1:3))
  call assign_result(13,16,arr3,results)
  !print *,arr3
  
  !tests 17-20
  arr3=0
  arr3(2:4) = matmul(arr1(1:2),arr2(1:2,2:4))
  call assign_result(17,20,arr3,results)
  !print *,arr3
  
  !tests 21-24
  arr3=0
  arr3 = matmul(arr1(1:2),arr2(2:3,:))
  call assign_result(21,24,arr3,results)
  !print *,arr3
  
  !tests 25-28
  arr3=0
  arr3 = matmul(arr1(2:3),arr2(1:2,:))
  call assign_result(25,28,arr3,results)
  !print *,arr3
  
  !tests 29-32
  arr3=0
  arr3(2:4)  = matmul(arr1(2:3),arr2(1:2,1:3))
  call assign_result(29,32,arr3,results)
  !print *,arr3
  
  !tests 33-36
  arr3=0
  arr3(1:3)  = matmul(arr1(1:2),arr2(2:3,2:4))
  call assign_result(33,36,arr3,results)
  !print *,arr3
  
  !tests 37-40
  arr3=0
  arr3(1:3) = matmul(arr1(1:3:2),arr2(1:3:2,2:4))
  call assign_result(37,40,arr3,results)
  !print *,arr3
  
  !tests 41-44
  arr3=0
  arr3(2:4:2)  = matmul(arr1(2:3),arr2(1:2,1:3:2))
  call assign_result(41,44,arr3,results)
  !print *,arr3
  
  !tests 45-48
  arr3=0
  arr3(1:3:2)  = matmul(arr1(1:2),arr2(2:3,2:4:2))
  call assign_result(45,48,arr3,results)
  !print *,arr3
  
  !tests 49-64
  arr4=0
  arr4(2,1:3:2)  = matmul(arr1(1:2),arr2(2:3,2:4:2))
  call assign_result(49,64,arr4,results)
  !print *,arr4
  
  !tests 65-80
  arr4=0
  arr4(1:3:2,3)  = matmul(arr1(1:2),arr2(2:3,2:4:2))
  call assign_result(65,80,arr4,results)
  !print *,arr4
  
  !tests 81-96
  arr7=0
  arr7(0,0:2:2)  = matmul(arr6(-3:-2),arr5(1:3:2,0:1))
  call assign_result(81,96,arr7,results)
  !print *,arr7
  
  !tests 97-112
  arr7=0
  arr7(-1:1:2,2)  = matmul(arr6(-2:-1),arr5(1:3:2,0:1))
  call assign_result(97,112,arr7,results)
  !print *,arr7
  
  !tests 113-116
  arr3=0
  arr3(3:1:-1) = matmul(arr1(3:1:-2),arr2(1:3:2,2:4))
  call assign_result(113,116,arr3,results)
  !print *,arr3
  
  !tests 117-120
  arr3=0
  arr3(4:2:-2)  = matmul(arr1(3:2:-1),arr2(1:2,3:1:-2))
  call assign_result(117,120,arr3,results)
  !print *,arr3
  
  !tests 121-136
  arr4=0
  arr4(2,3:1:-2)  = matmul(arr1(1:2),arr2(3:2:-1,4:2:-2))
  call assign_result(121,136,arr4,results)
  !print *,arr4
  
  !tests 137-152
  arr4=0
  arr4(3:1:-2,3)  = matmul(arr1(2:1:-1),arr2(3:2:-1,2:4:2))
  call assign_result(137,152,arr4,results)
  !print *,arr4
  
  !tests 153-168
  arr7=0
  arr7(0,2:0:-2)  = matmul(arr6(-3:-2),arr5(1:3:2,0:1))
  call assign_result(153,168,arr7,results)
  !print *,arr7
  
  !tests 169-184
  arr7=0
  arr7(1:-1:-2,2)  = matmul(arr6(-1:-2:-1),arr5(3:1:-2,0:1))
  call assign_result(169,184,arr7,results)
  !print *,arr7
  
  arr12 = 0

  ! tests 185-188
  arr10=0
  arr10 = arr12 + matmul(arr8,arr9)
  call assign_result(185,188,arr10,results)
  !print *,arr10

  ! tests 189-192
  arr10=0
  arr10 = arr12 +  matmul(arr8,arr11)
  call assign_result(189,192,arr10,results)
  !print *,arr10

  ! tests 193-196
  arr10=0
  arr10(1:3) = arr12(1:3)  + matmul(arr8,arr9(:,2:4))
  call assign_result(193,196,arr10,results)
  !print *,arr10
  
  !tests 197-200
  arr10=0 
  arr10(2:4) = arr12(2:4) + matmul(arr8,arr9(:, 1:3))
  call assign_result(197,200,arr10,results)
  !print *,arr10
  
  !tests 201-204
  arr10=0 
  arr10(2:4) = arr12(2:4) + matmul(arr8(1:2),arr9(2:3,2:4))
  call assign_result(201,204,arr10,results)
  !print *,arr10
  
  !tests 205-208
  arr10=0 
  arr10 = arr12 + matmul(arr8(1:2),arr9(3:4,:))
  call assign_result(205,208,arr10,results)
  !print *,arr10

  !tests 209-212
  arr10=0
  arr10 = arr12 + matmul(arr8(2:3),arr9(2:3,:))
  call assign_result(209,212,arr10,results)
  !print *,arr10

  !tests 213-216
  arr10=0
  arr10(2:4)  = arr12(2:4) + matmul(arr8(2:3),arr9(2:3,1:3))
  call assign_result(213,216,arr10,results)
  !print *,arr10

  !tests 217-220
  arr10=0
  arr10(1:3)  = arr12(1:3) + matmul(arr8(1:2),arr9(3:4,2:4))
  call assign_result(217,220,arr10,results)
  !print *,arr10

   do i = 1,11
     m2 = mod(i,2)
     if (m2 .eq. 0 ) then
         arr13(i) = 0
     else
         arr13(i) = mod(1,3)
     endif
     do j = 1,11
         arr14(i,j) = mod(j,2);
     enddo
  enddo

  ! test 221-231
  arr20=0
  arr20 = matmul(arr13,arr14)
  call assign_result(221,231,arr20,results)
  !print *,"test 221,231"
  !print *,arr20

  ! test 232-253
  arr15=0
  arr15(1,:) = matmul(arr13,arr14)
  call assign_result(232,253,arr15,results)
  !print *,"test 232,253"
  !print *,arr15

   do i = 1,389
     m2 = mod(i,2)
     if (m2 .eq. 0 ) then
         arr16(i) = 0
     else
         arr16(i) = mod(i,13)
     endif
     do j = 1,387
         arr17(i,j) = mod(j,7)
     enddo
  enddo

  ! test 254-640
  arr18=0
  arr18 = matmul(arr16,arr17)
  call assign_result(254,640,arr18,results)
  !print *,"test 254,640"
  !print *,arr18

  ! test 641-1414
  arr19=0
  arr19(1,:) = matmul(arr16,arr17)
  call assign_result(641,1414,arr19,results)
  !print *,"test 641,1414"
  !print *,arr19


  call check(results, expect, NbrTests)

end program

subroutine assign_result(s_idx, e_idx , arr, rslt)
  integer*1, dimension(1:e_idx-s_idx+1) :: arr
  integer*4, dimension(e_idx) :: rslt
  integer:: s_idx, e_idx

  rslt(s_idx:e_idx) = arr

end subroutine

