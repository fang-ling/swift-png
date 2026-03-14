#!/bin/zsh

##
##  update-libpng.zsh
##  swift-png
##
##  Created by Fang Ling on 2026/3/14.
##
##  Licensed under the Apache License, Version 2.0 (the "License");
##  you may not use this file except in compliance with the License.
##  You may obtain a copy of the License at
##
##    http://www.apache.org/licenses/LICENSE-2.0
##
##  Unless required by applicable law or agreed to in writing, software
##  distributed under the License is distributed on an "AS IS" BASIS,
##  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
##  See the License for the specific language governing permissions and
##  limitations under the License.
##

# This script creates a copy of libpng that is suitable for building with the
# Swift Package Manager.
#
# Usage:
#   Run this script in the package root. It will place a local copy of the
#   libpng sources in Sources/CPNG.
#   Any prior contents of Sources/CPNG will be deleted.
#

set -euo pipefail

CURRENT_WORKING_DIRECTORY=$(pwd)
TEMPORARY_DIRECTORY=$(mktemp -d /tmp/swift-png-XXXXXX)
SOURCE_DIRECTORY="${TEMPORARY_DIRECTORY}/Sources/libpng"
DESTINATION_DIRECTORY="Sources/CPNG"
TRASH_DIRECTORY="${TEMPORARY_DIRECTORY}/Trash"
SOURCES=(
  "*.c"
  "*.h"
  "arm/*.c"
  "arm/*.S"
  "intel/*.c"
  "loongarch/*.c"
  "mips/*.c"
  "powerpc/*.c"
  "riscv/*.c"
)
EXCLUDES=(
  "example.c"
  "pngtest.c"
)
PUBLIC_HEADERS=(
  "png.h"
  "pngconf.h"
)

# Libpng revision must be passed as the first argument to this script.
if [ "$#" -gt 0 ]; then
  LIBPNG_REVISION="$1"
else
  echo "Usage: $0 <libpng-revision>"
  exit 1
fi

echo "=========================================="
echo "TRASHING any previously-copied libpng code"
echo "=========================================="
mkdir -p "${TRASH_DIRECTORY}/CPNG"
mv "${DESTINATION_DIRECTORY}/"* "${TRASH_DIRECTORY}/CPNG" || true

echo "================"
echo "PREPARING libpng"
echo "================"
mkdir -p "${SOURCE_DIRECTORY}"
git clone https://github.com/pnggroup/libpng.git "${SOURCE_DIRECTORY}"
cd "${SOURCE_DIRECTORY}"
git checkout "${LIBPNG_REVISION}"
cd "${CURRENT_WORKING_DIRECTORY}"

echo "=============="
echo "COPYING libpng"
echo "=============="
mkdir -p "${DESTINATION_DIRECTORY}/libpng"
for SOURCE in "${SOURCES[@]}"
do
  for FILE in "${SOURCE_DIRECTORY}/"${~SOURCE}
  do
    FILE_PATH=${FILE#"$SOURCE_DIRECTORY"}
    DESTINATION="${DESTINATION_DIRECTORY}/libpng${FILE_PATH}"
    mkdir -p $(dirname "${DESTINATION}")

    cp "${FILE}" "${DESTINATION}"
  done
done
for EXCLUDE in "${EXCLUDES[@]}"
do
  rm -rf "${DESTINATION_DIRECTORY}/libpng/"${~EXCLUDE}
done
mkdir -p "${DESTINATION_DIRECTORY}/include"
for PUBLIC_HEADER in "${PUBLIC_HEADERS[@]}"
do
  mv \
    "${DESTINATION_DIRECTORY}/libpng/${PUBLIC_HEADER}" \
    "${DESTINATION_DIRECTORY}/include"
done
cp "${SOURCE_DIRECTORY}/LICENSE" "${DESTINATION_DIRECTORY}/LICENSE.txt"

echo "======================="
echo "WRITING generated files"
echo "======================="
cat << EOF > "${DESTINATION_DIRECTORY}/include/pnglibconf.h"
/* pnglibconf.h - library build configuration */

/* libpng version 1.6.55 */

/* Copyright (c) 2018-2026 Cosmin Truta */
/* Copyright (c) 1998-2002,2004,2006-2018 Glenn Randers-Pehrson */

/* This code is released under the libpng license. */
/* For conditions of distribution and use, see the disclaimer */
/* and license in png.h */

/* pnglibconf.h */
/* Machine generated file: DO NOT EDIT */
/* Derived from: scripts/pnglibconf.dfa */
#ifndef PNGLCONF_H
#define PNGLCONF_H
/* options */
#define PNG_16BIT_SUPPORTED
#define PNG_ALIGNED_MEMORY_SUPPORTED
/*#undef PNG_ARM_NEON_API_SUPPORTED*/
/*#undef PNG_ARM_NEON_CHECK_SUPPORTED*/
#define PNG_BENIGN_ERRORS_SUPPORTED
#define PNG_BENIGN_READ_ERRORS_SUPPORTED
/*#undef PNG_BENIGN_WRITE_ERRORS_SUPPORTED*/
#define PNG_bKGD_SUPPORTED
#define PNG_BUILD_GRAYSCALE_PALETTE_SUPPORTED
#define PNG_CHECK_FOR_INVALID_INDEX_SUPPORTED
#define PNG_cHRM_SUPPORTED
#define PNG_cICP_SUPPORTED
#define PNG_cLLI_SUPPORTED
#define PNG_COLORSPACE_SUPPORTED
#define PNG_CONSOLE_IO_SUPPORTED
#define PNG_CONVERT_tIME_SUPPORTED
/*#undef PNG_DISABLE_ADLER32_CHECK_SUPPORTED*/
#define PNG_EASY_ACCESS_SUPPORTED
/*#undef PNG_ERROR_NUMBERS_SUPPORTED*/
#define PNG_ERROR_TEXT_SUPPORTED
#define PNG_eXIf_SUPPORTED
#define PNG_FIXED_POINT_SUPPORTED
#define PNG_FLOATING_ARITHMETIC_SUPPORTED
#define PNG_FLOATING_POINT_SUPPORTED
#define PNG_FORMAT_AFIRST_SUPPORTED
#define PNG_FORMAT_BGR_SUPPORTED
#define PNG_gAMA_SUPPORTED
#define PNG_GAMMA_SUPPORTED
#define PNG_GET_PALETTE_MAX_SUPPORTED
#define PNG_HANDLE_AS_UNKNOWN_SUPPORTED
#define PNG_hIST_SUPPORTED
#define PNG_iCCP_SUPPORTED
#define PNG_INCH_CONVERSIONS_SUPPORTED
#define PNG_INFO_IMAGE_SUPPORTED
#define PNG_IO_STATE_SUPPORTED
#define PNG_iTXt_SUPPORTED
#define PNG_mDCV_SUPPORTED
/*#undef PNG_MIPS_MMI_API_SUPPORTED*/
/*#undef PNG_MIPS_MMI_CHECK_SUPPORTED*/
/*#undef PNG_MIPS_MSA_API_SUPPORTED*/
/*#undef PNG_MIPS_MSA_CHECK_SUPPORTED*/
#define PNG_MNG_FEATURES_SUPPORTED
#define PNG_oFFs_SUPPORTED
#define PNG_pCAL_SUPPORTED
#define PNG_pHYs_SUPPORTED
#define PNG_POINTER_INDEXING_SUPPORTED
/*#undef PNG_POWERPC_VSX_API_SUPPORTED*/
/*#undef PNG_POWERPC_VSX_CHECK_SUPPORTED*/
#define PNG_PROGRESSIVE_READ_SUPPORTED
#define PNG_READ_16BIT_SUPPORTED
#define PNG_READ_ALPHA_MODE_SUPPORTED
#define PNG_READ_ANCILLARY_CHUNKS_SUPPORTED
#define PNG_READ_BACKGROUND_SUPPORTED
#define PNG_READ_BGR_SUPPORTED
#define PNG_READ_bKGD_SUPPORTED
#define PNG_READ_CHECK_FOR_INVALID_INDEX_SUPPORTED
#define PNG_READ_cHRM_SUPPORTED
#define PNG_READ_cICP_SUPPORTED
#define PNG_READ_cLLI_SUPPORTED
#define PNG_READ_COMPOSITE_NODIV_SUPPORTED
#define PNG_READ_COMPRESSED_TEXT_SUPPORTED
#define PNG_READ_eXIf_SUPPORTED
#define PNG_READ_EXPAND_16_SUPPORTED
#define PNG_READ_EXPAND_SUPPORTED
#define PNG_READ_FILLER_SUPPORTED
#define PNG_READ_gAMA_SUPPORTED
#define PNG_READ_GAMMA_SUPPORTED
#define PNG_READ_GET_PALETTE_MAX_SUPPORTED
#define PNG_READ_GRAY_TO_RGB_SUPPORTED
#define PNG_READ_hIST_SUPPORTED
#define PNG_READ_iCCP_SUPPORTED
#define PNG_READ_INT_FUNCTIONS_SUPPORTED
#define PNG_READ_INTERLACING_SUPPORTED
#define PNG_READ_INVERT_ALPHA_SUPPORTED
#define PNG_READ_INVERT_SUPPORTED
#define PNG_READ_iTXt_SUPPORTED
#define PNG_READ_mDCV_SUPPORTED
#define PNG_READ_oFFs_SUPPORTED
#define PNG_READ_OPT_PLTE_SUPPORTED
#define PNG_READ_PACK_SUPPORTED
#define PNG_READ_PACKSWAP_SUPPORTED
#define PNG_READ_pCAL_SUPPORTED
#define PNG_READ_pHYs_SUPPORTED
#define PNG_READ_QUANTIZE_SUPPORTED
#define PNG_READ_RGB_TO_GRAY_SUPPORTED
#define PNG_READ_sBIT_SUPPORTED
#define PNG_READ_sCAL_SUPPORTED
#define PNG_READ_SCALE_16_TO_8_SUPPORTED
#define PNG_READ_SHIFT_SUPPORTED
#define PNG_READ_sPLT_SUPPORTED
#define PNG_READ_sRGB_SUPPORTED
#define PNG_READ_STRIP_16_TO_8_SUPPORTED
#define PNG_READ_STRIP_ALPHA_SUPPORTED
#define PNG_READ_SUPPORTED
#define PNG_READ_SWAP_ALPHA_SUPPORTED
#define PNG_READ_SWAP_SUPPORTED
#define PNG_READ_tEXt_SUPPORTED
#define PNG_READ_TEXT_SUPPORTED
#define PNG_READ_tIME_SUPPORTED
#define PNG_READ_TRANSFORMS_SUPPORTED
#define PNG_READ_tRNS_SUPPORTED
#define PNG_READ_UNKNOWN_CHUNKS_SUPPORTED
#define PNG_READ_USER_CHUNKS_SUPPORTED
#define PNG_READ_USER_TRANSFORM_SUPPORTED
#define PNG_READ_zTXt_SUPPORTED
#define PNG_SAVE_INT_32_SUPPORTED
#define PNG_SAVE_UNKNOWN_CHUNKS_SUPPORTED
#define PNG_sBIT_SUPPORTED
#define PNG_sCAL_SUPPORTED
#define PNG_SEQUENTIAL_READ_SUPPORTED
#define PNG_SET_OPTION_SUPPORTED
#define PNG_SET_UNKNOWN_CHUNKS_SUPPORTED
#define PNG_SET_USER_LIMITS_SUPPORTED
#define PNG_SETJMP_SUPPORTED
#define PNG_SIMPLIFIED_READ_AFIRST_SUPPORTED
#define PNG_SIMPLIFIED_READ_BGR_SUPPORTED
#define PNG_SIMPLIFIED_READ_SUPPORTED
#define PNG_SIMPLIFIED_WRITE_AFIRST_SUPPORTED
#define PNG_SIMPLIFIED_WRITE_BGR_SUPPORTED
#define PNG_SIMPLIFIED_WRITE_STDIO_SUPPORTED
#define PNG_SIMPLIFIED_WRITE_SUPPORTED
#define PNG_sPLT_SUPPORTED
#define PNG_sRGB_SUPPORTED
#define PNG_STDIO_SUPPORTED
#define PNG_STORE_UNKNOWN_CHUNKS_SUPPORTED
#define PNG_tEXt_SUPPORTED
#define PNG_TEXT_SUPPORTED
#define PNG_TIME_RFC1123_SUPPORTED
#define PNG_tIME_SUPPORTED
#define PNG_tRNS_SUPPORTED
#define PNG_UNKNOWN_CHUNKS_SUPPORTED
#define PNG_USER_CHUNKS_SUPPORTED
#define PNG_USER_LIMITS_SUPPORTED
#define PNG_USER_MEM_SUPPORTED
#define PNG_USER_TRANSFORM_INFO_SUPPORTED
#define PNG_USER_TRANSFORM_PTR_SUPPORTED
#define PNG_WARNINGS_SUPPORTED
#define PNG_WRITE_16BIT_SUPPORTED
#define PNG_WRITE_ANCILLARY_CHUNKS_SUPPORTED
#define PNG_WRITE_BGR_SUPPORTED
#define PNG_WRITE_bKGD_SUPPORTED
#define PNG_WRITE_CHECK_FOR_INVALID_INDEX_SUPPORTED
#define PNG_WRITE_cHRM_SUPPORTED
#define PNG_WRITE_cICP_SUPPORTED
#define PNG_WRITE_cLLI_SUPPORTED
#define PNG_WRITE_COMPRESSED_TEXT_SUPPORTED
#define PNG_WRITE_CUSTOMIZE_COMPRESSION_SUPPORTED
#define PNG_WRITE_CUSTOMIZE_ZTXT_COMPRESSION_SUPPORTED
#define PNG_WRITE_eXIf_SUPPORTED
#define PNG_WRITE_FILLER_SUPPORTED
#define PNG_WRITE_FILTER_SUPPORTED
#define PNG_WRITE_FLUSH_SUPPORTED
#define PNG_WRITE_gAMA_SUPPORTED
#define PNG_WRITE_GET_PALETTE_MAX_SUPPORTED
#define PNG_WRITE_hIST_SUPPORTED
#define PNG_WRITE_iCCP_SUPPORTED
#define PNG_WRITE_INT_FUNCTIONS_SUPPORTED
#define PNG_WRITE_INTERLACING_SUPPORTED
#define PNG_WRITE_INVERT_ALPHA_SUPPORTED
#define PNG_WRITE_INVERT_SUPPORTED
#define PNG_WRITE_iTXt_SUPPORTED
#define PNG_WRITE_mDCV_SUPPORTED
#define PNG_WRITE_oFFs_SUPPORTED
#define PNG_WRITE_OPTIMIZE_CMF_SUPPORTED
#define PNG_WRITE_PACK_SUPPORTED
#define PNG_WRITE_PACKSWAP_SUPPORTED
#define PNG_WRITE_pCAL_SUPPORTED
#define PNG_WRITE_pHYs_SUPPORTED
#define PNG_WRITE_sBIT_SUPPORTED
#define PNG_WRITE_sCAL_SUPPORTED
#define PNG_WRITE_SHIFT_SUPPORTED
#define PNG_WRITE_sPLT_SUPPORTED
#define PNG_WRITE_sRGB_SUPPORTED
#define PNG_WRITE_SUPPORTED
#define PNG_WRITE_SWAP_ALPHA_SUPPORTED
#define PNG_WRITE_SWAP_SUPPORTED
#define PNG_WRITE_tEXt_SUPPORTED
#define PNG_WRITE_TEXT_SUPPORTED
#define PNG_WRITE_tIME_SUPPORTED
#define PNG_WRITE_TRANSFORMS_SUPPORTED
#define PNG_WRITE_tRNS_SUPPORTED
#define PNG_WRITE_UNKNOWN_CHUNKS_SUPPORTED
#define PNG_WRITE_USER_TRANSFORM_SUPPORTED
#define PNG_WRITE_WEIGHTED_FILTER_SUPPORTED
#define PNG_WRITE_zTXt_SUPPORTED
#define PNG_zTXt_SUPPORTED
/* end of options */
/* settings */
#define PNG_API_RULE 0
#define PNG_DEFAULT_READ_MACROS 1
#define PNG_GAMMA_THRESHOLD_FIXED 5000
#define PNG_IDAT_READ_SIZE PNG_ZBUF_SIZE
#define PNG_INFLATE_BUF_SIZE 1024
#define PNG_LINKAGE_API extern
#define PNG_LINKAGE_CALLBACK extern
#define PNG_LINKAGE_DATA extern
#define PNG_LINKAGE_FUNCTION extern
#define PNG_MAX_GAMMA_8 11
#define PNG_QUANTIZE_BLUE_BITS 5
#define PNG_QUANTIZE_GREEN_BITS 5
#define PNG_QUANTIZE_RED_BITS 5
#define PNG_sCAL_PRECISION 5
#define PNG_sRGB_PROFILE_CHECKS 2
#define PNG_TEXT_Z_DEFAULT_COMPRESSION (-1)
#define PNG_TEXT_Z_DEFAULT_STRATEGY 0
#define PNG_USER_CHUNK_CACHE_MAX 1000
#define PNG_USER_CHUNK_MALLOC_MAX 8000000
#define PNG_USER_HEIGHT_MAX 1000000
#define PNG_USER_WIDTH_MAX 1000000
#define PNG_Z_DEFAULT_COMPRESSION (-1)
#define PNG_Z_DEFAULT_NOFILTER_STRATEGY 0
#define PNG_Z_DEFAULT_STRATEGY 1
#define PNG_ZBUF_SIZE 8192
#define PNG_ZLIB_VERNUM 0x12c0
/* end of settings */
#endif /* PNGLCONF_H */
EOF

echo "========================="
echo "RECORDING libpng revision"
echo "========================="
cat << EOF > "${DESTINATION_DIRECTORY}/revision.txt"
This directory is derived from libpng
  cloned from https://github.com/pnggroup/libpng.git
EOF
echo "at revision ${LIBPNG_REVISION}" >> "${DESTINATION_DIRECTORY}/revision.txt"

echo "============================"
echo "CLEANING temporary directory"
echo "============================"
rm -rf "${TEMPORARY_DIRECTORY}"
