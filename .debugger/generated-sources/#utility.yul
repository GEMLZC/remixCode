{

    function abi_decode_t_address(offset, end) -> value {
        value := calldataload(offset)
        validator_revert_t_address(value)
    }

    function abi_decode_t_bool(offset, end) -> value {
        value := calldataload(offset)
        validator_revert_t_bool(value)
    }

    function abi_decode_t_bytes4(offset, end) -> value {
        value := calldataload(offset)
        validator_revert_t_bytes4(value)
    }

    function abi_decode_t_bytes4_fromMemory(offset, end) -> value {
        value := mload(offset)
        validator_revert_t_bytes4(value)
    }

    // bytes
    function abi_decode_t_bytes_calldata_ptr(offset, end) -> arrayPos, length {
        if iszero(slt(add(offset, 0x1f), end)) { revert(0, 0) }
        length := calldataload(offset)
        if gt(length, 0xffffffffffffffff) { revert(0, 0) }
        arrayPos := add(offset, 0x20)
        if gt(add(arrayPos, mul(length, 0x01)), end) { revert(0, 0) }
    }

    function abi_decode_t_uint256(offset, end) -> value {
        value := calldataload(offset)
        validator_revert_t_uint256(value)
    }

    function abi_decode_tuple_t_address(headStart, dataEnd) -> value0 {
        if slt(sub(dataEnd, headStart), 32) { revert(0, 0) }

        {

            let offset := 0

            value0 := abi_decode_t_address(add(headStart, offset), dataEnd)
        }

    }

    function abi_decode_tuple_t_addresst_address(headStart, dataEnd) -> value0, value1 {
        if slt(sub(dataEnd, headStart), 64) { revert(0, 0) }

        {

            let offset := 0

            value0 := abi_decode_t_address(add(headStart, offset), dataEnd)
        }

        {

            let offset := 32

            value1 := abi_decode_t_address(add(headStart, offset), dataEnd)
        }

    }

    function abi_decode_tuple_t_addresst_addresst_uint256(headStart, dataEnd) -> value0, value1, value2 {
        if slt(sub(dataEnd, headStart), 96) { revert(0, 0) }

        {

            let offset := 0

            value0 := abi_decode_t_address(add(headStart, offset), dataEnd)
        }

        {

            let offset := 32

            value1 := abi_decode_t_address(add(headStart, offset), dataEnd)
        }

        {

            let offset := 64

            value2 := abi_decode_t_uint256(add(headStart, offset), dataEnd)
        }

    }

    function abi_decode_tuple_t_addresst_addresst_uint256t_bytes_calldata_ptr(headStart, dataEnd) -> value0, value1, value2, value3, value4 {
        if slt(sub(dataEnd, headStart), 128) { revert(0, 0) }

        {

            let offset := 0

            value0 := abi_decode_t_address(add(headStart, offset), dataEnd)
        }

        {

            let offset := 32

            value1 := abi_decode_t_address(add(headStart, offset), dataEnd)
        }

        {

            let offset := 64

            value2 := abi_decode_t_uint256(add(headStart, offset), dataEnd)
        }

        {

            let offset := calldataload(add(headStart, 96))
            if gt(offset, 0xffffffffffffffff) { revert(0, 0) }

            value3, value4 := abi_decode_t_bytes_calldata_ptr(add(headStart, offset), dataEnd)
        }

    }

    function abi_decode_tuple_t_addresst_bool(headStart, dataEnd) -> value0, value1 {
        if slt(sub(dataEnd, headStart), 64) { revert(0, 0) }

        {

            let offset := 0

            value0 := abi_decode_t_address(add(headStart, offset), dataEnd)
        }

        {

            let offset := 32

            value1 := abi_decode_t_bool(add(headStart, offset), dataEnd)
        }

    }

    function abi_decode_tuple_t_addresst_uint256(headStart, dataEnd) -> value0, value1 {
        if slt(sub(dataEnd, headStart), 64) { revert(0, 0) }

        {

            let offset := 0

            value0 := abi_decode_t_address(add(headStart, offset), dataEnd)
        }

        {

            let offset := 32

            value1 := abi_decode_t_uint256(add(headStart, offset), dataEnd)
        }

    }

    function abi_decode_tuple_t_bytes4(headStart, dataEnd) -> value0 {
        if slt(sub(dataEnd, headStart), 32) { revert(0, 0) }

        {

            let offset := 0

            value0 := abi_decode_t_bytes4(add(headStart, offset), dataEnd)
        }

    }

    function abi_decode_tuple_t_bytes4_fromMemory(headStart, dataEnd) -> value0 {
        if slt(sub(dataEnd, headStart), 32) { revert(0, 0) }

        {

            let offset := 0

            value0 := abi_decode_t_bytes4_fromMemory(add(headStart, offset), dataEnd)
        }

    }

    function abi_decode_tuple_t_uint256(headStart, dataEnd) -> value0 {
        if slt(sub(dataEnd, headStart), 32) { revert(0, 0) }

        {

            let offset := 0

            value0 := abi_decode_t_uint256(add(headStart, offset), dataEnd)
        }

    }

    function abi_encode_t_address_to_t_address_fromStack(value, pos) {
        mstore(pos, cleanup_t_address(value))
    }

    function abi_encode_t_bool_to_t_bool_fromStack(value, pos) {
        mstore(pos, cleanup_t_bool(value))
    }

    // bytes -> bytes
    function abi_encode_t_bytes_calldata_ptr_to_t_bytes_memory_ptr_fromStack(start, length, pos) -> end {
        pos := array_storeLengthForEncoding_t_bytes_memory_ptr_fromStack(pos, length)

        copy_calldata_to_memory(start, pos, length)
        end := add(pos, round_up_to_mul_of_32(length))
    }

    function abi_encode_t_stringliteral_0afb279d9a1a98b2d733e83e6fcae9c1f53dc51b7016130bc7bfa96327add76f_to_t_string_memory_ptr_fromStack(pos) -> end {
        pos := array_storeLengthForEncoding_t_string_memory_ptr_fromStack(pos, 16)
        store_literal_in_memory_0afb279d9a1a98b2d733e83e6fcae9c1f53dc51b7016130bc7bfa96327add76f(pos)
        end := add(pos, 32)
    }

    function abi_encode_t_stringliteral_0bff6f3a72b53c3711fa32821e88a755f48bbc46a2fa4369eae46b80ceee7b64_to_t_string_memory_ptr_fromStack(pos) -> end {
        pos := array_storeLengthForEncoding_t_string_memory_ptr_fromStack(pos, 12)
        store_literal_in_memory_0bff6f3a72b53c3711fa32821e88a755f48bbc46a2fa4369eae46b80ceee7b64(pos)
        end := add(pos, 32)
    }

    function abi_encode_t_stringliteral_10f0f021079116b66b443be002b0732b7d232519e423c58a12b8751cda1d5bdd_to_t_string_memory_ptr_fromStack(pos) -> end {
        pos := array_storeLengthForEncoding_t_string_memory_ptr_fromStack(pos, 39)
        store_literal_in_memory_10f0f021079116b66b443be002b0732b7d232519e423c58a12b8751cda1d5bdd(pos)
        end := add(pos, 64)
    }

    function abi_encode_t_stringliteral_1585b0c58e7ad09da3131636ddfb3eeffcba8ec35b826d026fb596b1af4cb94a_to_t_string_memory_ptr_fromStack(pos) -> end {
        pos := array_storeLengthForEncoding_t_string_memory_ptr_fromStack(pos, 17)
        store_literal_in_memory_1585b0c58e7ad09da3131636ddfb3eeffcba8ec35b826d026fb596b1af4cb94a(pos)
        end := add(pos, 32)
    }

    function abi_encode_t_stringliteral_27d1be3120c04e1a1b6ee1f071d35c08f81c02af7910a800f13c416f22374c11_to_t_string_memory_ptr_fromStack(pos) -> end {
        pos := array_storeLengthForEncoding_t_string_memory_ptr_fromStack(pos, 27)
        store_literal_in_memory_27d1be3120c04e1a1b6ee1f071d35c08f81c02af7910a800f13c416f22374c11(pos)
        end := add(pos, 32)
    }

    function abi_encode_t_stringliteral_43cb400ed1a72442ecd1f4f64a04d3ab190774effbaa471a769e4fc41bfbd125_to_t_string_memory_ptr_fromStack(pos) -> end {
        pos := array_storeLengthForEncoding_t_string_memory_ptr_fromStack(pos, 19)
        store_literal_in_memory_43cb400ed1a72442ecd1f4f64a04d3ab190774effbaa471a769e4fc41bfbd125(pos)
        end := add(pos, 32)
    }

    function abi_encode_t_stringliteral_817468d55cee9c1cd3f82e581d88dffdc9c47c34c304b52ccb5b5a5cd234b15a_to_t_string_memory_ptr_fromStack(pos) -> end {
        pos := array_storeLengthForEncoding_t_string_memory_ptr_fromStack(pos, 32)
        store_literal_in_memory_817468d55cee9c1cd3f82e581d88dffdc9c47c34c304b52ccb5b5a5cd234b15a(pos)
        end := add(pos, 32)
    }

    function abi_encode_t_stringliteral_8aed0440c9cacb4460ecdd12f6aff03c27cace39666d71f0946a6f3e9022a4a1_to_t_string_memory_ptr_fromStack(pos) -> end {
        pos := array_storeLengthForEncoding_t_string_memory_ptr_fromStack(pos, 14)
        store_literal_in_memory_8aed0440c9cacb4460ecdd12f6aff03c27cace39666d71f0946a6f3e9022a4a1(pos)
        end := add(pos, 32)
    }

    function abi_encode_t_stringliteral_b835402f0effce9a0de3431de81ff6b318438318464e5739ab39297b47756a41_to_t_string_memory_ptr_fromStack(pos) -> end {
        pos := array_storeLengthForEncoding_t_string_memory_ptr_fromStack(pos, 18)
        store_literal_in_memory_b835402f0effce9a0de3431de81ff6b318438318464e5739ab39297b47756a41(pos)
        end := add(pos, 32)
    }

    function abi_encode_t_stringliteral_c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470_to_t_bytes_memory_ptr_fromStack(pos) -> end {
        pos := array_storeLengthForEncoding_t_bytes_memory_ptr_fromStack(pos, 0)
        store_literal_in_memory_c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470(pos)
        end := add(pos, 0)
    }

    function abi_encode_t_stringliteral_c7f89e38fd8d9e3b0fcdc59bc52c4e4690d04b24b926c1b43bc05e4e0f0cf868_to_t_string_memory_ptr_fromStack(pos) -> end {
        pos := array_storeLengthForEncoding_t_string_memory_ptr_fromStack(pos, 22)
        store_literal_in_memory_c7f89e38fd8d9e3b0fcdc59bc52c4e4690d04b24b926c1b43bc05e4e0f0cf868(pos)
        end := add(pos, 32)
    }

    function abi_encode_t_stringliteral_cc9f608000740c07015cbbfe008493e36d846d2853fa320983fd6206bed160c9_to_t_string_memory_ptr_fromStack(pos) -> end {
        pos := array_storeLengthForEncoding_t_string_memory_ptr_fromStack(pos, 16)
        store_literal_in_memory_cc9f608000740c07015cbbfe008493e36d846d2853fa320983fd6206bed160c9(pos)
        end := add(pos, 32)
    }

    function abi_encode_t_stringliteral_f2881edc58d5a08d0243d7f8afdab31d949d85825e628e4b88558657a031f74e_to_t_string_memory_ptr_fromStack(pos) -> end {
        pos := array_storeLengthForEncoding_t_string_memory_ptr_fromStack(pos, 9)
        store_literal_in_memory_f2881edc58d5a08d0243d7f8afdab31d949d85825e628e4b88558657a031f74e(pos)
        end := add(pos, 32)
    }

    function abi_encode_t_stringliteral_f5aa7bfad8d1b3b8b52f30173e69d7f14a3f4d81f6d0b9bd282ea95db890ea68_to_t_string_memory_ptr_fromStack(pos) -> end {
        pos := array_storeLengthForEncoding_t_string_memory_ptr_fromStack(pos, 13)
        store_literal_in_memory_f5aa7bfad8d1b3b8b52f30173e69d7f14a3f4d81f6d0b9bd282ea95db890ea68(pos)
        end := add(pos, 32)
    }

    function abi_encode_t_uint256_to_t_uint256_fromStack(value, pos) {
        mstore(pos, cleanup_t_uint256(value))
    }

    function abi_encode_tuple_t_address__to_t_address__fromStack_reversed(headStart , value0) -> tail {
        tail := add(headStart, 32)

        abi_encode_t_address_to_t_address_fromStack(value0,  add(headStart, 0))

    }

    function abi_encode_tuple_t_address_t_address_t_uint256_t_bytes_calldata_ptr__to_t_address_t_address_t_uint256_t_bytes_memory_ptr__fromStack_reversed(headStart , value4, value3, value2, value1, value0) -> tail {
        tail := add(headStart, 128)

        abi_encode_t_address_to_t_address_fromStack(value0,  add(headStart, 0))

        abi_encode_t_address_to_t_address_fromStack(value1,  add(headStart, 32))

        abi_encode_t_uint256_to_t_uint256_fromStack(value2,  add(headStart, 64))

        mstore(add(headStart, 96), sub(tail, headStart))
        tail := abi_encode_t_bytes_calldata_ptr_to_t_bytes_memory_ptr_fromStack(value3, value4,  tail)

    }

    function abi_encode_tuple_t_address_t_address_t_uint256_t_stringliteral_c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470__to_t_address_t_address_t_uint256_t_bytes_memory_ptr__fromStack_reversed(headStart , value2, value1, value0) -> tail {
        tail := add(headStart, 128)

        abi_encode_t_address_to_t_address_fromStack(value0,  add(headStart, 0))

        abi_encode_t_address_to_t_address_fromStack(value1,  add(headStart, 32))

        abi_encode_t_uint256_to_t_uint256_fromStack(value2,  add(headStart, 64))

        mstore(add(headStart, 96), sub(tail, headStart))
        tail := abi_encode_t_stringliteral_c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470_to_t_bytes_memory_ptr_fromStack( tail)

    }

    function abi_encode_tuple_t_bool__to_t_bool__fromStack_reversed(headStart , value0) -> tail {
        tail := add(headStart, 32)

        abi_encode_t_bool_to_t_bool_fromStack(value0,  add(headStart, 0))

    }

    function abi_encode_tuple_t_stringliteral_0afb279d9a1a98b2d733e83e6fcae9c1f53dc51b7016130bc7bfa96327add76f__to_t_string_memory_ptr__fromStack_reversed(headStart ) -> tail {
        tail := add(headStart, 32)

        mstore(add(headStart, 0), sub(tail, headStart))
        tail := abi_encode_t_stringliteral_0afb279d9a1a98b2d733e83e6fcae9c1f53dc51b7016130bc7bfa96327add76f_to_t_string_memory_ptr_fromStack( tail)

    }

    function abi_encode_tuple_t_stringliteral_0bff6f3a72b53c3711fa32821e88a755f48bbc46a2fa4369eae46b80ceee7b64__to_t_string_memory_ptr__fromStack_reversed(headStart ) -> tail {
        tail := add(headStart, 32)

        mstore(add(headStart, 0), sub(tail, headStart))
        tail := abi_encode_t_stringliteral_0bff6f3a72b53c3711fa32821e88a755f48bbc46a2fa4369eae46b80ceee7b64_to_t_string_memory_ptr_fromStack( tail)

    }

    function abi_encode_tuple_t_stringliteral_10f0f021079116b66b443be002b0732b7d232519e423c58a12b8751cda1d5bdd__to_t_string_memory_ptr__fromStack_reversed(headStart ) -> tail {
        tail := add(headStart, 32)

        mstore(add(headStart, 0), sub(tail, headStart))
        tail := abi_encode_t_stringliteral_10f0f021079116b66b443be002b0732b7d232519e423c58a12b8751cda1d5bdd_to_t_string_memory_ptr_fromStack( tail)

    }

    function abi_encode_tuple_t_stringliteral_1585b0c58e7ad09da3131636ddfb3eeffcba8ec35b826d026fb596b1af4cb94a__to_t_string_memory_ptr__fromStack_reversed(headStart ) -> tail {
        tail := add(headStart, 32)

        mstore(add(headStart, 0), sub(tail, headStart))
        tail := abi_encode_t_stringliteral_1585b0c58e7ad09da3131636ddfb3eeffcba8ec35b826d026fb596b1af4cb94a_to_t_string_memory_ptr_fromStack( tail)

    }

    function abi_encode_tuple_t_stringliteral_27d1be3120c04e1a1b6ee1f071d35c08f81c02af7910a800f13c416f22374c11__to_t_string_memory_ptr__fromStack_reversed(headStart ) -> tail {
        tail := add(headStart, 32)

        mstore(add(headStart, 0), sub(tail, headStart))
        tail := abi_encode_t_stringliteral_27d1be3120c04e1a1b6ee1f071d35c08f81c02af7910a800f13c416f22374c11_to_t_string_memory_ptr_fromStack( tail)

    }

    function abi_encode_tuple_t_stringliteral_43cb400ed1a72442ecd1f4f64a04d3ab190774effbaa471a769e4fc41bfbd125__to_t_string_memory_ptr__fromStack_reversed(headStart ) -> tail {
        tail := add(headStart, 32)

        mstore(add(headStart, 0), sub(tail, headStart))
        tail := abi_encode_t_stringliteral_43cb400ed1a72442ecd1f4f64a04d3ab190774effbaa471a769e4fc41bfbd125_to_t_string_memory_ptr_fromStack( tail)

    }

    function abi_encode_tuple_t_stringliteral_817468d55cee9c1cd3f82e581d88dffdc9c47c34c304b52ccb5b5a5cd234b15a__to_t_string_memory_ptr__fromStack_reversed(headStart ) -> tail {
        tail := add(headStart, 32)

        mstore(add(headStart, 0), sub(tail, headStart))
        tail := abi_encode_t_stringliteral_817468d55cee9c1cd3f82e581d88dffdc9c47c34c304b52ccb5b5a5cd234b15a_to_t_string_memory_ptr_fromStack( tail)

    }

    function abi_encode_tuple_t_stringliteral_8aed0440c9cacb4460ecdd12f6aff03c27cace39666d71f0946a6f3e9022a4a1__to_t_string_memory_ptr__fromStack_reversed(headStart ) -> tail {
        tail := add(headStart, 32)

        mstore(add(headStart, 0), sub(tail, headStart))
        tail := abi_encode_t_stringliteral_8aed0440c9cacb4460ecdd12f6aff03c27cace39666d71f0946a6f3e9022a4a1_to_t_string_memory_ptr_fromStack( tail)

    }

    function abi_encode_tuple_t_stringliteral_b835402f0effce9a0de3431de81ff6b318438318464e5739ab39297b47756a41__to_t_string_memory_ptr__fromStack_reversed(headStart ) -> tail {
        tail := add(headStart, 32)

        mstore(add(headStart, 0), sub(tail, headStart))
        tail := abi_encode_t_stringliteral_b835402f0effce9a0de3431de81ff6b318438318464e5739ab39297b47756a41_to_t_string_memory_ptr_fromStack( tail)

    }

    function abi_encode_tuple_t_stringliteral_c7f89e38fd8d9e3b0fcdc59bc52c4e4690d04b24b926c1b43bc05e4e0f0cf868__to_t_string_memory_ptr__fromStack_reversed(headStart ) -> tail {
        tail := add(headStart, 32)

        mstore(add(headStart, 0), sub(tail, headStart))
        tail := abi_encode_t_stringliteral_c7f89e38fd8d9e3b0fcdc59bc52c4e4690d04b24b926c1b43bc05e4e0f0cf868_to_t_string_memory_ptr_fromStack( tail)

    }

    function abi_encode_tuple_t_stringliteral_cc9f608000740c07015cbbfe008493e36d846d2853fa320983fd6206bed160c9__to_t_string_memory_ptr__fromStack_reversed(headStart ) -> tail {
        tail := add(headStart, 32)

        mstore(add(headStart, 0), sub(tail, headStart))
        tail := abi_encode_t_stringliteral_cc9f608000740c07015cbbfe008493e36d846d2853fa320983fd6206bed160c9_to_t_string_memory_ptr_fromStack( tail)

    }

    function abi_encode_tuple_t_stringliteral_f2881edc58d5a08d0243d7f8afdab31d949d85825e628e4b88558657a031f74e__to_t_string_memory_ptr__fromStack_reversed(headStart ) -> tail {
        tail := add(headStart, 32)

        mstore(add(headStart, 0), sub(tail, headStart))
        tail := abi_encode_t_stringliteral_f2881edc58d5a08d0243d7f8afdab31d949d85825e628e4b88558657a031f74e_to_t_string_memory_ptr_fromStack( tail)

    }

    function abi_encode_tuple_t_stringliteral_f5aa7bfad8d1b3b8b52f30173e69d7f14a3f4d81f6d0b9bd282ea95db890ea68__to_t_string_memory_ptr__fromStack_reversed(headStart ) -> tail {
        tail := add(headStart, 32)

        mstore(add(headStart, 0), sub(tail, headStart))
        tail := abi_encode_t_stringliteral_f5aa7bfad8d1b3b8b52f30173e69d7f14a3f4d81f6d0b9bd282ea95db890ea68_to_t_string_memory_ptr_fromStack( tail)

    }

    function abi_encode_tuple_t_uint256__to_t_uint256__fromStack_reversed(headStart , value0) -> tail {
        tail := add(headStart, 32)

        abi_encode_t_uint256_to_t_uint256_fromStack(value0,  add(headStart, 0))

    }

    function array_storeLengthForEncoding_t_bytes_memory_ptr_fromStack(pos, length) -> updated_pos {
        mstore(pos, length)
        updated_pos := add(pos, 0x20)
    }

    function array_storeLengthForEncoding_t_string_memory_ptr_fromStack(pos, length) -> updated_pos {
        mstore(pos, length)
        updated_pos := add(pos, 0x20)
    }

    function cleanup_t_address(value) -> cleaned {
        cleaned := cleanup_t_uint160(value)
    }

    function cleanup_t_bool(value) -> cleaned {
        cleaned := iszero(iszero(value))
    }

    function cleanup_t_bytes4(value) -> cleaned {
        cleaned := and(value, 0xffffffff00000000000000000000000000000000000000000000000000000000)
    }

    function cleanup_t_uint160(value) -> cleaned {
        cleaned := and(value, 0xffffffffffffffffffffffffffffffffffffffff)
    }

    function cleanup_t_uint256(value) -> cleaned {
        cleaned := value
    }

    function copy_calldata_to_memory(src, dst, length) {
        calldatacopy(dst, src, length)
        // clear end
        mstore(add(dst, length), 0)
    }

    function decrement_t_uint256(value) -> ret {
        value := cleanup_t_uint256(value)
        if eq(value, 0x00) { panic_error_0x11() }
        ret := sub(value, 1)
    }

    function increment_t_uint256(value) -> ret {
        value := cleanup_t_uint256(value)
        if eq(value, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff) { panic_error_0x11() }
        ret := add(value, 1)
    }

    function panic_error_0x11() {
        mstore(0, 35408467139433450592217433187231851964531694900788300625387963629091585785856)
        mstore(4, 0x11)
        revert(0, 0x24)
    }

    function round_up_to_mul_of_32(value) -> result {
        result := and(add(value, 31), not(31))
    }

    function store_literal_in_memory_0afb279d9a1a98b2d733e83e6fcae9c1f53dc51b7016130bc7bfa96327add76f(memPtr) {

        mstore(add(memPtr, 0), "unsafe recipient")

    }

    function store_literal_in_memory_0bff6f3a72b53c3711fa32821e88a755f48bbc46a2fa4369eae46b80ceee7b64(memPtr) {

        mstore(add(memPtr, 0), "tokenId zero")

    }

    function store_literal_in_memory_10f0f021079116b66b443be002b0732b7d232519e423c58a12b8751cda1d5bdd(memPtr) {

        mstore(add(memPtr, 0), "owner of tokenId not match fromA")

        mstore(add(memPtr, 32), "ddress ")

    }

    function store_literal_in_memory_1585b0c58e7ad09da3131636ddfb3eeffcba8ec35b826d026fb596b1af4cb94a(memPtr) {

        mstore(add(memPtr, 0), "to = zero address")

    }

    function store_literal_in_memory_27d1be3120c04e1a1b6ee1f071d35c08f81c02af7910a800f13c416f22374c11(memPtr) {

        mstore(add(memPtr, 0), "ERC721: address zero is not")

    }

    function store_literal_in_memory_43cb400ed1a72442ecd1f4f64a04d3ab190774effbaa471a769e4fc41bfbd125(memPtr) {

        mstore(add(memPtr, 0), "address zero is not")

    }

    function store_literal_in_memory_817468d55cee9c1cd3f82e581d88dffdc9c47c34c304b52ccb5b5a5cd234b15a(memPtr) {

        mstore(add(memPtr, 0), "address or toAddress zero is not")

    }

    function store_literal_in_memory_8aed0440c9cacb4460ecdd12f6aff03c27cace39666d71f0946a6f3e9022a4a1(memPtr) {

        mstore(add(memPtr, 0), "not authorized")

    }

    function store_literal_in_memory_b835402f0effce9a0de3431de81ff6b318438318464e5739ab39297b47756a41(memPtr) {

        mstore(add(memPtr, 0), "ERC, address is  0")

    }

    function store_literal_in_memory_c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470(memPtr) {

    }

    function store_literal_in_memory_c7f89e38fd8d9e3b0fcdc59bc52c4e4690d04b24b926c1b43bc05e4e0f0cf868(memPtr) {

        mstore(add(memPtr, 0), "operator address is  0")

    }

    function store_literal_in_memory_cc9f608000740c07015cbbfe008493e36d846d2853fa320983fd6206bed160c9(memPtr) {

        mstore(add(memPtr, 0), "address is  zero")

    }

    function store_literal_in_memory_f2881edc58d5a08d0243d7f8afdab31d949d85825e628e4b88558657a031f74e(memPtr) {

        mstore(add(memPtr, 0), "not owner")

    }

    function store_literal_in_memory_f5aa7bfad8d1b3b8b52f30173e69d7f14a3f4d81f6d0b9bd282ea95db890ea68(memPtr) {

        mstore(add(memPtr, 0), "not authrized")

    }

    function validator_revert_t_address(value) {
        if iszero(eq(value, cleanup_t_address(value))) { revert(0, 0) }
    }

    function validator_revert_t_bool(value) {
        if iszero(eq(value, cleanup_t_bool(value))) { revert(0, 0) }
    }

    function validator_revert_t_bytes4(value) {
        if iszero(eq(value, cleanup_t_bytes4(value))) { revert(0, 0) }
    }

    function validator_revert_t_uint256(value) {
        if iszero(eq(value, cleanup_t_uint256(value))) { revert(0, 0) }
    }

}
