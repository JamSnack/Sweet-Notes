/// @description Insert description here
// You can write your code in this editor

//Init ImGuiGML
imguigml_activate();

menu_state = "Workspace";
node_name = "";
node_note = "";

selected_node = noone;
dragging = noone;

function save_project(filename)
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
		
		//Add some other variables to the data list
		//data[? "object_index"] = object_index;
		data[? "x"] = x;
		data[? "y"] = y;
		
		//Append the constructed data to data_map
		//show_debug_message(string(data));
		ds_map_add_map(data_map, string(id), data);
	}
	
	//Save data_map to a text file
	var json_map = json_encode(data_map);
	//show_debug_message(json_map);
	var save_buffer = buffer_create(string_byte_length(json_map) + 1, buffer_fixed, 1);
	
	buffer_write(save_buffer, buffer_string, json_map);
	buffer_save(save_buffer, filename);
	
	//cleanup
	buffer_delete(save_buffer);
	ds_map_destroy(data_map);
	
	current_filename = string_replace(filename, ".txt", "");
}


//Load
function load_project(filename)
{	
	if (file_exists(filename))
	{
		show_debug_message("Loading project...");
		//get every node in the file, creating a duplicate version
		var file = buffer_load(filename);
		var file = buffer_read(file, buffer_string);
		var json_struct = json_parse(file);
		var nodes = variable_struct_get_names(json_struct);
	
		for (var j = 0; j < array_length(nodes); j++)
		{
			
			var variables = variable_struct_get(json_struct, nodes[j]);
			instance_create_layer(299, 100, "Instances", obj_genericNode, variables);
		}
	}
}

//Variables
global.display_width = display_get_gui_width();
global.display_height = display_get_gui_height();

current_filename = "file";

maximum_node_label_length = 64;
maximum_node_note_text_length = 255;
mouse_node_offset_x = -1337;
mouse_node_offset_y = -1337;