/// @description Insert description here
// You can write your code in this editor

//Init ImGuiGML
imguigml_activate();

menu_state = "Workspace";
node_name = "";
node_note = "";

selected_node = noone;
dragging = noone;

function save_project()
{
	//datamap
	var data_map = ds_map_create();
	
	//loop through every node, appending its data to the datamap
	with (obj_genericNode)
	{
		var data = ds_map_create();
		var variables = variable_instance_get_names(id);
		
		//append each variable and its value to the datamap
		for (var i = 0; i < array_length(variables); i++)
		{
			data[? variables[i]] = variable_instance_get(id, variables[i]);
		}
		
		//Append the constructed data to data_map
		show_debug_message(string(data));
		ds_map_add_map(data_map, string(id), data);
	}
	
	//Save data_map to a text file
	var json_map = json_encode(data_map);
	//show_debug_message(json_map);
	var save_buffer = buffer_create(string_byte_length(json_map) + 1, buffer_fixed, 1);
	
	buffer_write(save_buffer, buffer_string, json_map);
	buffer_save(save_buffer, "genericFile.txt");
	
	//cleanup
	buffer_delete(save_buffer);
	ds_map_destroy(data_map);
}


//Load
function load_project()
{	
	show_debug_message("Loading project...");
	//get every node in the file, creating a duplicate version
	var file = buffer_load("genericFile.txt");
	var file = buffer_read(file, buffer_string);
	var json_struct = json_parse(file);
	var nodes = variable_struct_get_names(json_struct);
	
	for (var j = 0; j < array_length(nodes); j++)
	{
		var variables = variable_struct_get(json_struct, nodes[j]);
		instance_create_layer(299, 100, "Instances", obj_genericNode, variables);
	}
}

load_project();

//