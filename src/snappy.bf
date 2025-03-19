/*
 * Copyright 2011 Martin Gieseking <martin.gieseking@uos.de>.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 *
 *     * Redistributions of source code must retain the above copyright
 * notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above
 * copyright notice, this list of conditions and the following disclaimer
 * in the documentation and/or other materials provided with the
 * distribution.
 *     * Neither the name of Google Inc. nor the names of its
 * contributors may be used to endorse or promote products derived from
 * this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * Plain C interface (a wrapper around the C++ implementation).
 */

using System;
using System.Interop;

namespace snappy;

public static class snappy
{
    typealias char = c_char;
    typealias size_t = uint;
    
    /*
    * Return values; see the documentation for each function to know
    * what each can return.
    */
    public enum snappy_status {
        SNAPPY_OK = 0,
        SNAPPY_INVALID_INPUT = 1,
        SNAPPY_BUFFER_TOO_SMALL = 2
    } ;

    /*
    * Takes the data stored in "input[0..input_length-1]" and stores
    * it in the array pointed to by "compressed".
    *
    * <compressed_length> signals the space available in "compressed".
    * If it is not at least equal to "snappy_max_compressed_length(input_length)",
    * SNAPPY_BUFFER_TOO_SMALL is returned. After successful compression,
    * <compressed_length> contains the true length of the compressed output,
    * and SNAPPY_OK is returned.
    *
    * Example:
    *   size_t output_length = snappy_max_compressed_length(input_length);
    *   char* output = (char*)malloc(output_length);
    *   if (snappy_compress(input, input_length, output, &output_length)
    *       == SNAPPY_OK) {
    *     ... Process(output, output_length) ...
    *   }
    *   free(output);
    */
    [CLink] public static extern snappy_status snappy_compress(char* input, size_t input_length, char* compressed, size_t* compressed_length);

    /*
    * Given data in "compressed[0..compressed_length-1]" generated by
    * calling the snappy_compress routine, this routine stores
    * the uncompressed data to
    *   uncompressed[0..uncompressed_length-1].
    * Returns failure (a value not equal to SNAPPY_OK) if the message
    * is corrupted and could not be decrypted.
    *
    * <uncompressed_length> signals the space available in "uncompressed".
    * If it is not at least equal to the value returned by
    * snappy_uncompressed_length for this stream, SNAPPY_BUFFER_TOO_SMALL
    * is returned. After successful decompression, <uncompressed_length>
    * contains the true length of the decompressed output.
    *
    * Example:
    *   size_t output_length;
    *   if (snappy_uncompressed_length(input, input_length, &output_length)
    *       != SNAPPY_OK) {
    *     ... fail ...
    *   }
    *   char* output = (char*)malloc(output_length);
    *   if (snappy_uncompress(input, input_length, output, &output_length)
    *       == SNAPPY_OK) {
    *     ... Process(output, output_length) ...
    *   }
    *   free(output);
    */
    [CLink] public static extern snappy_status snappy_uncompress(char* compressed, size_t compressed_length, char* uncompressed, size_t* uncompressed_length);

    /*
    * Returns the maximal size of the compressed representation of
    * input data that is "source_length" bytes in length.
    */
    [CLink] public static extern size_t snappy_max_compressed_length(size_t source_length);

    /*
    * REQUIRES: "compressed[]" was produced by snappy_compress()
    * Returns SNAPPY_OK and stores the length of the uncompressed data in
    * *result normally. Returns SNAPPY_INVALID_INPUT on parsing error.
    * This operation takes O(1) time.
    */
    [CLink] public static extern snappy_status snappy_uncompressed_length(char* compressed, size_t compressed_length, size_t* result);

    /*
    * Check if the contents of "compressed[]" can be uncompressed successfully.
    * Does not return the uncompressed data; if so, returns SNAPPY_OK,
    * or if not, returns SNAPPY_INVALID_INPUT.
    * Takes time proportional to compressed_length, but is usually at least a
    * factor of four faster than actual decompression.
    */
    [CLink] public static extern snappy_status snappy_validate_compressed_buffer(char* compressed, size_t compressed_length);
}