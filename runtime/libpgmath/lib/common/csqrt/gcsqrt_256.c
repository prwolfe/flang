/*
 * Copyright (c) 2017-2018, NVIDIA CORPORATION.  All rights reserved.
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
#include "mth_intrinsics.h"

vcs4_t
__gc_sqrt_4(vcs4_t x)
{
  return (__ZGVyN4v__mth_i_vc4(x, csqrtf));
}

vcd2_t
__gz_sqrt_2(vcd2_t x)
{
  return (__ZGVyN2v__mth_i_vc8(x, csqrt));
}
