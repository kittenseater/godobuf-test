extends Node

const P = preload("res://pbtest2.gd")

func _ready():
	exec_all(false)
	#exec(false, [["f_double", 	P.Test1]])
	#exec(false, [["f_float", 	P.Test1]])
	pass

func exec_all(save_to_file):
	exec(save_to_file, [
		["f_double", 	P.Test1], 
		["f_float", 	P.Test1], 
		["f_int32", 	P.Test1], 
		["f_int64", 	P.Test1], 
		["f_uint32", 	P.Test1], 
		["f_uint64", 	P.Test1], 
		["f_sint32", 	P.Test1], 
		["f_sint64", 	P.Test1],
		["f_fixed32", 	P.Test1], 
		["f_fixed64", 	P.Test1], 
		["f_sfixed32", 	P.Test1], 
		["f_sfixed64", 	P.Test1], 
		["f_bool", 		P.Test1], 
		["f_string", 	P.Test1], 
		["f_bytes", 	P.Test1], 
		["f_map", 		P.Test1], 
		["f_oneof_f1", 	P.Test1], 
		["f_oneof_f2", 	P.Test1],		
		["f_empty_out", 	P.Test1],
		["f_enum_out", 		P.Test1],
		["f_empty_inner", 	P.Test1],
		["f_enum_inner", 	P.Test1],
		
		["rf_double", 	P.Test1], 
		["rf_float", 	P.Test1], 
		["rf_int32", 	P.Test1], 
		["rf_int64", 	P.Test1], 
		["rf_uint32", 	P.Test1], 
		["rf_uint64", 	P.Test1], 
		["rf_sint32", 	P.Test1], 
		["rf_sint64", 	P.Test1],
		["rf_fixed32", 	P.Test1], 
		["rf_fixed64", 	P.Test1], 
		["rf_sfixed32", P.Test1], 
		["rf_sfixed64", P.Test1], 
		["rf_bool", 	P.Test1], 
		["rf_string", 	P.Test1], 
		["rf_bytes", 	P.Test1], 
		["rf_empty_out", 	P.Test1],
		["rf_enum_out", 	P.Test1],
		["rf_empty_inner", 	P.Test1],
		["rf_enum_inner", 	P.Test1],
		
		["rf_double_empty", 	P.Test1], 
		["rf_float_empty", 		P.Test1], 
		["rf_int32_empty", 		P.Test1], 
		["rf_int64_empty", 		P.Test1], 
		["rf_uint32_empty", 	P.Test1], 
		["rf_uint64_empty", 	P.Test1],
		["rf_sint32_empty", 	P.Test1], 
		["rf_sint64_empty", 	P.Test1], 
		["rf_fixed32_empty", 	P.Test1], 
		["rf_fixed64_empty", 	P.Test1], 
		["rf_sfixed32_empty", 	P.Test1], 
		["rf_sfixed64_empty",	P.Test1],
		["rf_bool_empty", 		P.Test1], 
		["rf_string_empty", 	P.Test1], 
		["rf_bytes_empty", 		P.Test1],
		
		["rfu_double", 		P.Test1], 
		["rfu_float", 		P.Test1], 
		["rfu_int32", 		P.Test1], 
		["rfu_int64", 		P.Test1], 
		["rfu_uint32", 		P.Test1], 
		["rfu_uint64", 		P.Test1], 
		["rfu_sint32", 		P.Test1], 
		["rfu_sint64", 		P.Test1],
		["rfu_fixed32",		P.Test1], 
		["rfu_fixed64",		P.Test1], 
		["rfu_sfixed32", 	P.Test1], 
		["rfu_sfixed64", 	P.Test1], 
		["rfu_bool", 		P.Test1], 
		
		["f_int32_default", 	P.Test1], 
		["f_string_default", 	P.Test1], 
		["f_bytes_default", 	P.Test1], 
		["test2_testinner3_testinner32", 		P.Test2.TestInner3.TestInner3_2], 
		["test2_testinner3_testinner32_empty", 	P.Test2.TestInner3.TestInner3_2], 
		["rf_inner_ene", 		P.Test1], 
		["rf_inner_nen", 		P.Test1], 
		
		["simple_all", 	P.Test1],

		["test2_1",		P.Test2],
		["test2_2",		P.Test2],
		["test2_3",		P.Test2],
		["test2_4",		P.Test2],
		
		["test4",			P.Test4],
		["test4_map",		P.Test4],
		["test4_map_dup",	P.Test4],
	])


const FUNC_NAME = 0
const CLASS_NAME = 1
func exec(save_to_file, test_names):
	print("======================= BEGIN TESTS v2 =======================")
	var tests_counter = 0
	var success_pack_counter = 0
	var godot_success_unpack_counter = 0
	var erlang_success_unpack_counter = 0
	for test_name in test_names:
		tests_counter += 1
		print("----- ", test_name[FUNC_NAME], " -----")
		var test_func = funcref(self, test_name[FUNC_NAME])
		var packed_object = test_name[CLASS_NAME].new()
		var godot_rv = test_func.call_func(packed_object)
		if save_to_file:
			var out_file_name = "res://testout2/" + test_name[FUNC_NAME] + ".v2godobuf";
			var out_file = File.new(out_file_name)
			if out_file.open(out_file_name, out_file.WRITE) == 0:
				out_file.store_buffer(godot_rv)
				out_file.close()
			else:
				print("failed write out file: ", out_file_name)
		# compare bin dumps
		var compare_result
		var erl_result = "<<no data>>"
		var erl_file = File.new()
		var erl_file_path = "res://testout2/" + test_name[FUNC_NAME] + ".v2ref";
		var erl_rv = null
		if erl_file.file_exists(erl_file_path):
			if erl_file.open(erl_file_path, erl_file.READ) == 0:
				erl_rv = erl_file.get_buffer(erl_file.get_len())
				erl_result = str_raw_array(erl_rv)
				if godot_rv.size() == erl_rv.size():
					var equal = true
					var fail_index
					for index in range(godot_rv.size()):
						if godot_rv[index] != erl_rv[index]:
							equal = false
							fail_index = index
							break
					if equal:
						success_pack_counter += 1
						compare_result = "OK"
					else:
						compare_result = "FAIL: test data for '" + test_name[FUNC_NAME] + "' not equal at " + str(fail_index)
				else:
					compare_result = "FAIL: test data length for '" + test_name[FUNC_NAME] + "' not equal"
			else:
				compare_result = "FAIL: can't read '" + erl_file_path + "'"
		else:
			compare_result = "FAIL: '" + erl_file_path + "' not exist"
		print("[bin godobuf    ] ", str_raw_array(godot_rv))
		print("[bin protobuf   ] ", erl_result)
		print("[bin compare    ] ", compare_result)
		
		var restored_object_godot = test_name[CLASS_NAME].new()
		var error_godot = restored_object_godot.from_bytes(godot_rv)
		if object_equal(packed_object, restored_object_godot):
			godot_success_unpack_counter += 1
			if error_godot == P.PB_ERR.NO_ERRORS:
				print("[unpack godobuf ] OK")
			else:
				print("[unpack godobuf ] FAIL: ", err_to_str(error_godot))
		else:
			print("[unpack godobuf ] FAIL: packed_object & restored_object not equals")
		
		if erl_rv != null:
			var restored_object_erl = test_name[CLASS_NAME].new()
			var error_erl = restored_object_erl.from_bytes(erl_rv)
			if object_equal(packed_object, restored_object_erl):
				erlang_success_unpack_counter += 1
				if error_erl == P.PB_ERR.NO_ERRORS:
					print("[unpack protobuf] OK")
				else:
					print("[unpack protobuf] FAIL: ", err_to_str(error_erl))
			else:
				print("[unpack protobuf] FAIL: packed_object & restored_object not equals")
		else:
			print("[unpack protobuf] FAIL: no protobuf binary")
		print("")
	print("----- DONE -----")
	print("godobuf & protobuf compare success done " + str(success_pack_counter) + " of " + str(tests_counter))
	print("godobuf unpack success done " + str(godot_success_unpack_counter) + " of " + str(tests_counter))
	print("protobuf unpack success done " + str(erlang_success_unpack_counter) + " of " + str(tests_counter))

func object_equal(packed_object, restored_object):
	for data_key in packed_object.data:
		# проверяем наличие ключа
		if !restored_object.data.has(data_key):
			return false
		
		var po_rule = packed_object.data[data_key].field.rule
		var ro_rule = restored_object.data[data_key].field.rule
		
		var po_value = packed_object.data[data_key].field.value
		var ro_value = restored_object.data[data_key].field.value
		
		if po_value == null && ro_value == null:
			return true
		
		if (po_value == null && ro_value != null) \
			|| (po_value != null && ro_value == null):
			return false
		
		var po_type = packed_object.data[data_key].field.type
		var ro_type = restored_object.data[data_key].field.type
		
		# проверяем наличие repeated
		if po_rule != ro_rule:
			return false
		# проверяем совпадение типа
		if po_type != ro_type:
			return false
			
		# в зависимости от типа разные проверки
		if po_type == P.PB_DATA_TYPE.INT32 			\
			|| po_type == P.PB_DATA_TYPE.SINT32 	\
			|| po_type == P.PB_DATA_TYPE.UINT32 	\
			|| po_type == P.PB_DATA_TYPE.INT64 		\
			|| po_type == P.PB_DATA_TYPE.SINT64 	\
			|| po_type == P.PB_DATA_TYPE.UINT64 	\
			|| po_type == P.PB_DATA_TYPE.BOOL 		\
			|| po_type == P.PB_DATA_TYPE.ENUM 		\
			|| po_type == P.PB_DATA_TYPE.FIXED32	\
			|| po_type == P.PB_DATA_TYPE.SFIXED32	\
			|| po_type == P.PB_DATA_TYPE.FLOAT		\
			|| po_type == P.PB_DATA_TYPE.FIXED64	\
			|| po_type == P.PB_DATA_TYPE.SFIXED64	\
			|| po_type == P.PB_DATA_TYPE.DOUBLE		\
			|| po_type == P.PB_DATA_TYPE.STRING:
			
			# проверяем значение объектов...
			if po_rule == P.PB_RULE.REPEATED:
				# ...для repeated полей
				if po_value.size() != ro_value.size():
					return false
				for i in range(po_value.size()):
					if po_value[i] != ro_value[i]:
						return false
			else:
				# ...для не-repeated полей
				if po_value != ro_value:
					return false
		elif po_type == P.PB_DATA_TYPE.BYTES:
			if po_rule == P.PB_RULE.REPEATED:
				# ...для repeated полей
				if po_value.size() != ro_value.size():
					return false
				for i in range(po_value.size()):
					for j in range(po_value[i].size()):
						if po_value[i][j] != ro_value[i][j]:
							return false
			else:
				# ...для не-repeated полей
				if po_value.size() != ro_value.size():
					return false
				for i in range(po_value.size()):
					if po_value[i] != ro_value[i]:
						return false
		elif po_type == P.PB_DATA_TYPE.MESSAGE:
			if po_rule == P.PB_RULE.REPEATED:
				# ...для repeated полей
				if po_value.size() != ro_value.size():
					return false
				for i in range(po_value.size()):
					if !object_equal(po_value[i], ro_value[i]):
						return false
			else:
				# ...для не-repeated полей
				if !object_equal(po_value, ro_value):
					return false
		elif po_type == P.PB_DATA_TYPE.MAP:
			var po_map = P.PBPacker.construct_map(po_value)
			var ro_map = P.PBPacker.construct_map(ro_value)
			if po_map.size() != po_map.size():
				return false
			
			for key in po_map.keys():
				var po_found = -1
				for i in range(po_value.size() - 1, -1, -1):
					if key == po_value[i].get_key():
						if !ro_map.has(key):
							return false
						po_found = i
						break
				
				if po_found == -1:
					return false
					
				var ro_found = -1
				for i in range(ro_value.size() - 1, -1, -1):
					if key == ro_value[i].get_key():
						ro_found = i
						break
				
				if ro_found == -1:
					return false
				
				if !object_equal(po_value[po_found], ro_value[ro_found]):
					return false
		elif po_type == P.PB_DATA_TYPE.ONEOF:
			return object_equal(po_value, ro_value)
	return true

#######################
######## Test1 ########
#######################

# single values #
func f_double(t):
	t.set_f_double(1.2340000152587890625e1)
	return t.to_bytes()

func f_float(t):
	t.set_f_float(1.2340000152587890625e1)
	return t.to_bytes()

func f_int32(t):
	t.set_f_int32(1234)
	return t.to_bytes()

func f_int64(t):
	t.set_f_int64(1234)
	return t.to_bytes()

func f_uint32(t):
	t.set_f_uint32(1234)
	return t.to_bytes()

func f_uint64(t):
	t.set_f_uint64(1234)
	return t.to_bytes()

func f_sint32(t):
	t.set_f_sint32(1234)
	return t.to_bytes()

func f_sint64(t):
	t.set_f_sint64(1234)
	return t.to_bytes()

func f_fixed32(t):
	t.set_f_fixed32(1234)
	return t.to_bytes()

func f_fixed64(t):
	t.set_f_fixed64(1234)
	return t.to_bytes()

func f_sfixed32(t):
	t.set_f_sfixed32(1234)
	return t.to_bytes()

func f_sfixed64(t):
	t.set_f_sfixed64(1234)
	return t.to_bytes()

func f_bool(t):
	t.set_f_bool(false)
	return t.to_bytes()

func f_string(t):
	t.set_f_string("string value")
	return t.to_bytes()

func f_bytes(t):
	t.set_f_bytes([1, 2, 3, 4])
	return t.to_bytes()

func f_map(t):
	t.add_f_map(1, 2)
	t.add_f_map(1000, 2000)
	return t.to_bytes()

func f_oneof_f1(t):
	t.set_f_oneof_f1("oneof value")
	return t.to_bytes()

func f_oneof_f2(t):
	t.set_f_oneof_f2(1234)
	return t.to_bytes()

func f_empty_out(t):
	t.new_f_empty_out()
	return t.to_bytes()

func f_enum_out(t):
	t.set_f_enum_out(P.Enum0.ONE)
	return t.to_bytes()

func f_empty_inner(t):
	t.new_f_empty_inner()
	return t.to_bytes()

func f_enum_inner(t):
	t.set_f_enum_inner(P.Test2.TestEnum.VALUE_1)
	return t.to_bytes()

# repeated values #
func rf_double(t):
	t.add_rf_double(1.2340000152587890625e1)
	t.add_rf_double(5.6779998779296875e1)
	return t.to_bytes()

func rf_float(t):
	t.add_rf_float(1.2340000152587890625e1)
	t.add_rf_float(5.6779998779296875e1)
	return t.to_bytes()

func rf_int32(t):
	t.add_rf_int32(1234)
	t.add_rf_int32(5678)
	return t.to_bytes()

func rf_int64(t):
	t.add_rf_int64(1234)
	t.add_rf_int64(5678)
	return t.to_bytes()

func rf_uint32(t):
	t.add_rf_uint32(1234)
	t.add_rf_uint32(5678)
	return t.to_bytes()

func rf_uint64(t):
	t.add_rf_uint64(1234)
	t.add_rf_uint64(5678)
	return t.to_bytes()

func rf_sint32(t):
	t.add_rf_sint32(1234)
	t.add_rf_sint32(5678)
	return t.to_bytes()

func rf_sint64(t):
	t.add_rf_sint64(1234)
	t.add_rf_sint64(5678)
	return t.to_bytes()

func rf_fixed32(t):
	t.add_rf_fixed32(1234)
	t.add_rf_fixed32(5678)
	return t.to_bytes()

func rf_fixed64(t):
	t.add_rf_fixed64(1234)
	t.add_rf_fixed64(5678)
	return t.to_bytes()

func rf_sfixed32(t):
	t.add_rf_sfixed32(1234)
	t.add_rf_sfixed32(5678)
	return t.to_bytes()

func rf_sfixed64(t):
	t.add_rf_sfixed64(1234)
	t.add_rf_sfixed64(5678)
	return t.to_bytes()

func rf_bool(t):
	t.add_rf_bool(false)
	t.add_rf_bool(true)
	t.add_rf_bool(false)
	return t.to_bytes()

func rf_string(t):
	t.add_rf_string("string value one")
	t.add_rf_string("string value two")
	return t.to_bytes()

func rf_bytes(t):
	t.add_rf_bytes([1, 2, 3, 4])
	t.add_rf_bytes([5, 6, 7, 8])
	return t.to_bytes()

func rf_empty_out(t):
	t.add_rf_empty_out()
	t.add_rf_empty_out()
	t.add_rf_empty_out()
	return t.to_bytes()

func rf_enum_out(t):
	t.add_rf_enum_out(P.Enum0.ONE)
	t.add_rf_enum_out(P.Enum0.TWO)
	t.add_rf_enum_out(P.Enum0.THREE)
	return t.to_bytes()

func rf_empty_inner(t):
	t.add_rf_empty_inner()
	t.add_rf_empty_inner()
	t.add_rf_empty_inner()
	return t.to_bytes()

func rf_enum_inner(t):
	t.add_rf_enum_inner(P.Test2.TestEnum.VALUE_1)
	t.add_rf_enum_inner(P.Test2.TestEnum.VALUE_2)
	t.add_rf_enum_inner(P.Test2.TestEnum.VALUE_3)
	return t.to_bytes()

func rf_double_empty(t):
	return t.to_bytes()

func rf_float_empty(t):
	return t.to_bytes()

func rf_int32_empty(t):
	return t.to_bytes()

func rf_int64_empty(t):
	return t.to_bytes()

func rf_uint32_empty(t):
	return t.to_bytes()

func rf_uint64_empty(t):
	return t.to_bytes()

func rf_sint32_empty(t):
	return t.to_bytes()

func rf_sint64_empty(t):
	return t.to_bytes()

func rf_fixed32_empty(t):
	return t.to_bytes()

func rf_fixed64_empty(t):
	return t.to_bytes()

func rf_sfixed32_empty(t):
	return t.to_bytes()

func rf_sfixed64_empty(t):
	return t.to_bytes()

func rf_bool_empty(t):
	return t.to_bytes()

func rf_string_empty(t):
	return t.to_bytes()

func rf_bytes_empty(t):
	return t.to_bytes()

func rfu_double(t):
	t.add_rfu_double(1.2340000152587890625e1)
	t.add_rfu_double(5.6779998779296875e1)
	return t.to_bytes()

func rfu_float(t):
	t.add_rfu_float(1.2340000152587890625e1)
	t.add_rfu_float(5.6779998779296875e1)
	return t.to_bytes()

func rfu_int32(t):
	t.add_rfu_int32(1234)
	t.add_rfu_int32(5678)
	return t.to_bytes()

func rfu_int64(t):
	t.add_rfu_int64(1234)
	t.add_rfu_int64(5678)
	return t.to_bytes()

func rfu_uint32(t):
	t.add_rfu_uint32(1234)
	t.add_rfu_uint32(5678)
	return t.to_bytes()

func rfu_uint64(t):
	t.add_rfu_uint64(1234)
	t.add_rfu_uint64(5678)
	return t.to_bytes()

func rfu_sint32(t):
	t.add_rfu_sint32(1234)
	t.add_rfu_sint32(5678)
	return t.to_bytes()

func rfu_sint64(t):
	t.add_rfu_sint64(1234)
	t.add_rfu_sint64(5678)
	return t.to_bytes()

func rfu_fixed32(t):
	t.add_rfu_fixed32(1234)
	t.add_rfu_fixed32(5678)
	return t.to_bytes()

func rfu_fixed64(t):
	t.add_rfu_fixed64(1234)
	t.add_rfu_fixed64(5678)
	return t.to_bytes()

func rfu_sfixed32(t):
	t.add_rfu_sfixed32(1234)
	t.add_rfu_sfixed32(5678)
	return t.to_bytes()

func rfu_sfixed64(t):
	t.add_rfu_sfixed64(1234)
	t.add_rfu_sfixed64(5678)
	return t.to_bytes()

func rfu_bool(t):
	t.add_rfu_bool(false)
	t.add_rfu_bool(true)
	t.add_rfu_bool(false)
	return t.to_bytes()

func f_int32_default(t):
	t.set_f_int32(0)
	return t.to_bytes()

func f_string_default(t):
	t.set_f_string("")
	return t.to_bytes()

func f_bytes_default(t):
	t.set_f_bytes([])
	return t.to_bytes()

func test2_testinner3_testinner32(t):
	t.set_f1(12)
	t.set_f2(34)
	return t.to_bytes()

func test2_testinner3_testinner32_empty(t):
	return t.to_bytes()

func rf_inner_ene(t):
	var i0 = t.add_rf_inner()
	var i1 = t.add_rf_inner()
	var i2 = t.add_rf_inner()
	
	i1.set_f1(12)
	i1.set_f2(34)
	
	return t.to_bytes()

func rf_inner_nen(t):
	var i0 = t.add_rf_inner()
	var i1 = t.add_rf_inner()
	var i2 = t.add_rf_inner()
	
	i0.set_f1(12)
	i0.set_f2(34)
	i2.set_f1(12)
	i2.set_f2(34)
		
	return t.to_bytes()

func simple_all(t):
	t.set_f_double(1.2340000152587890625e1)
	t.set_f_float(1.2340000152587890625e1)
	t.set_f_int32(1234)
	t.set_f_int64(1234)
	t.set_f_uint32(1234)
	t.set_f_uint64(1234)
	t.set_f_sint32(1234)
	t.set_f_sint64(1234)
	t.set_f_fixed32(1234)
	t.set_f_fixed64(1234)
	t.set_f_sfixed32(1234)
	t.set_f_sfixed64(1234)
	t.set_f_bool(false)
	t.set_f_string("string value")
	t.set_f_bytes([1, 2, 3, 4])	
	t.add_f_map(1, 2)
	t.add_f_map(1000, 2000)
	t.set_f_oneof_f1("oneof value")
	t.new_f_empty_out()
	t.set_f_enum_out(P.Enum0.ONE)
	t.new_f_empty_inner()
	t.set_f_enum_inner(P.Test2.TestEnum.VALUE_1)
	# -----
	t.add_rf_double(1.2340000152587890625e1)
	t.add_rf_double(5.6779998779296875e1)
	
	t.add_rf_float(1.2340000152587890625e1)
	t.add_rf_float(5.6779998779296875e1)
	
	t.add_rf_int32(1234)
	t.add_rf_int32(5678)
	
	t.add_rf_int64(1234)
	t.add_rf_int64(5678)
	
	t.add_rf_uint32(1234)
	t.add_rf_uint32(5678)
	
	t.add_rf_uint64(1234)
	t.add_rf_uint64(5678)
	
	t.add_rf_sint32(1234)
	t.add_rf_sint32(5678)
	
	t.add_rf_sint64(1234)
	t.add_rf_sint64(5678)
	
	t.add_rf_fixed32(1234)
	t.add_rf_fixed32(5678)
	
	t.add_rf_fixed64(1234)
	t.add_rf_fixed64(5678)
	
	t.add_rf_sfixed32(1234)
	t.add_rf_sfixed32(5678)
	
	t.add_rf_sfixed64(1234)
	t.add_rf_sfixed64(5678)
	
	t.add_rf_bool(false)
	t.add_rf_bool(true)
	t.add_rf_bool(false)
	
	t.add_rf_string("string value one")
	t.add_rf_string("string value two")
	
	t.add_rf_bytes([1, 2, 3, 4])
	t.add_rf_bytes([5, 6, 7, 8])
	
	t.add_rf_empty_out()
	t.add_rf_empty_out()
	t.add_rf_empty_out()
	
	t.add_rf_enum_out(P.Enum0.ONE)
	t.add_rf_enum_out(P.Enum0.TWO)
	t.add_rf_enum_out(P.Enum0.THREE)
	
	t.add_rf_empty_inner()
	t.add_rf_empty_inner()
	t.add_rf_empty_inner()
	
	t.add_rf_enum_inner(P.Test2.TestEnum.VALUE_1)
	t.add_rf_enum_inner(P.Test2.TestEnum.VALUE_2)
	t.add_rf_enum_inner(P.Test2.TestEnum.VALUE_3)
	# -----
	t.add_rfu_double(1.2340000152587890625e1)
	t.add_rfu_double(5.6779998779296875e1)
	
	t.add_rfu_float(1.2340000152587890625e1)
	t.add_rfu_float(5.6779998779296875e1)
	
	t.add_rfu_int32(1234)
	t.add_rfu_int32(5678)
	
	t.add_rfu_int64(1234)
	t.add_rfu_int64(5678)
	
	t.add_rfu_uint32(1234)
	t.add_rfu_uint32(5678)
	
	t.add_rfu_uint64(1234)
	t.add_rfu_uint64(5678)
	
	t.add_rfu_sint32(1234)
	t.add_rfu_sint32(5678)
	
	t.add_rfu_sint64(1234)
	t.add_rfu_sint64(5678)
	
	t.add_rfu_fixed32(1234)
	t.add_rfu_fixed32(5678)
	
	t.add_rfu_fixed64(1234)
	t.add_rfu_fixed64(5678)
	
	t.add_rfu_sfixed32(1234)
	t.add_rfu_sfixed32(5678)
	
	t.add_rfu_sfixed64(1234)
	t.add_rfu_sfixed64(5678)
	
	t.add_rfu_bool(false)
	t.add_rfu_bool(true)
	t.add_rfu_bool(false)
	
	return t.to_bytes()

#######################
######## Test2 ########
#######################

func test2_1(t):
	
	# repeated string
	t.add_f1("test text-1")
	t.add_f1("test text-2")
	t.add_f1("test text-3")
	
	# fixed64
	t.set_f2(1234)
	
	# oneof string
	t.set_f3("yet another text")
	
	# empty message
	t.new_f5()
	
	return t.to_bytes()

func test2_2(t):
	
	# Test2.TestInner3
	var f6 = t.new_f6()
	var f6_f1 = f6.add_f1("one")
	f6_f1.set_f1(111)
	f6_f1.set_f2(1111)
	f6_f1 = f6.add_f1("two")
	f6_f1.set_f1(222)
	f6_f1.set_f2(2222)
	f6_f1 = f6.add_f1("three")
	f6_f1.set_f1(333)
	f6_f1.set_f2(3333)
	f6_f1 = f6.add_f1("four")
	f6_f1.set_f1(444)
	f6_f1.set_f2(4444)
	
	f6.set_f2(P.Test2.TestEnum.VALUE_1)
	
	f6.new_f3()
	
	return t.to_bytes()

func test2_3(t):
	# repeated string
	t.add_f1("test text-1")
	t.add_f1("test text-2")
	t.add_f1("test text-3")
	
	# fixed64
	t.set_f2(1234)
	
	# oneof 
	var f4 = t.new_f4()
	var f4_f1 = f4.add_f1("one")
	f4_f1.set_f1(111)
	f4_f1.set_f2(1111)
	f4_f1 = f4.add_f1("two")
	f4_f1.set_f1(222)
	f4_f1.set_f2(2222)
	f4_f1 = f4.add_f1("three")
	f4_f1.set_f1(333)
	f4_f1.set_f2(3333)
	f4_f1 = f4.add_f1("four")
	f4_f1.set_f1(444)
	f4_f1.set_f2(4444)
	
	f4.set_f2(t.TestEnum.VALUE_1)
	f4.new_f3()
	
	# empty message
	t.new_f5()
	
	# Test2.TestInner3
	var f6 = t.new_f6()
	var f6_f1 = f6.add_f1("one")
	f6_f1.set_f1(111)
	f6_f1.set_f2(1111)
	f6_f1 = f6.add_f1("two")
	f6_f1.set_f1(222)
	f6_f1.set_f2(2222)
	f6_f1 = f6.add_f1("three")
	f6_f1.set_f1(333)
	f6_f1.set_f2(3333)
	f6_f1 = f6.add_f1("four")
	f6_f1.set_f1(444)
	f6_f1.set_f2(4444)
	
	f6.set_f2(t.TestEnum.VALUE_1)
	
	f6.new_f3()
	
	# Test2.TestInner1
	var f7 = t.new_f7()
	f7.add_f1(1.2340000152587890625e1)
	f7.add_f1(5.6779998779296875e1)
	
	f7.set_f2(1.2340000152587890625e1)
	
	f7.set_f3("sample text")
	
	return t.to_bytes()

func test2_4(t):	
	# Test2.TestInner3
	var f6 = t.new_f6()
	var f6_f1 = f6.add_f1("one")
	f6_f1.set_f1(111)
	f6_f1.set_f2(1111)
	f6_f1 = f6.add_f1("two")
	f6_f1.set_f1(222)
	f6_f1.set_f2(2222)
	f6_f1 = f6.add_f1("one")
	f6_f1.set_f1(333)
	f6_f1.set_f2(3333)
	f6_f1 = f6.add_f1("two")
	f6_f1.set_f1(444)
	f6_f1.set_f2(4444)
	
	return t.to_bytes()

func test4(t):
	t.set_f1(1234)
	t.set_f2("hello")
	t.set_f3(1.2340000152587890625e1)
	t.set_f4(1.2340000152587890625e1)
	return t.to_bytes()

func test4_map(t):
	t.add_f5(5, 6)
	t.add_f5(1, 2)
	t.add_f5(3, 4)
	return t.to_bytes()

func test4_map_dup(t): # 1, 10}, {2, 20}, {1, 20}, {2, 200
	t.add_f5(1, 10)
	t.add_f5(2, 20)
	t.add_f5(1, 20)
	t.add_f5(2, 200)
	return t.to_bytes()


################
# private func #
################
static func str_raw_array(arr):
	if arr.size() == 0:
		return "<<>>"
		
	var res = "<<"
	for i in range(arr.size()):
		if i == (arr.size() - 1):
			res += str(arr[i]) + ">>"
		else:
			res += str(arr[i]) + ","
	return res

static func err_to_str(err_code):
	if err_code == P.PB_ERR.NO_ERRORS:
		return "NO_ERRORS(" + str(err_code) + ")"
	elif err_code == P.PB_ERR.VARINT_NOT_FOUND:
		return "VARINT_NOT_FOUND(" + str(err_code) + ")"
	elif err_code == P.PB_ERR.REPEATED_COUNT_NOT_FOUND:
		return "REPEATED_COUNT_NOT_FOUND(" + str(err_code) + ")"
	elif err_code == P.PB_ERR.REPEATED_COUNT_MISMATCH:
		return "REPEATED_COUNT_MISMATCH(" + str(err_code) + ")"
	elif err_code == P.PB_ERR.LENGTHDEL_SIZE_NOT_FOUND:
		return "LENGTHDEL_SIZE_NOT_FOUND(" + str(err_code) + ")"
	elif err_code == P.PB_ERR.LENGTHDEL_SIZE_MISMATCH:
		return "LENGTHDEL_SIZE_MISMATCH(" + str(err_code) + ")"
	elif err_code == P.PB_ERR.PACKAGE_SIZE_MISMATCH:
		return "PACKAGE_SIZE_MISMATCH(" + str(err_code) + ")"
	elif err_code == P.PB_ERR.UNDEFINED_STATE:
		return "UNDEFINED_STATE(" + str(err_code) + ")"
	else:
		return "UNKNOWN(" + str(err_code) + ")"
