/// @description
//GUI
if (imguigml_ready())
{
	imguigml_set_next_window_pos(global.display_width - 240, 2);
	imguigml_set_next_window_size(240, 260);
	imguigml_begin(menu_state);
	
	//Back button
	if (menu_state != "Workspace")
	{
		if (imguigml_button("Back"))
			menu_state = "Workspace";
	}
	
	//"Workspace" menu
	switch (menu_state)
	{
		case "Workspace":
		{
			if (imguigml_button("Create Node") || keyboard_check_released(vk_enter) && !instance_exists(selected_node))
				menu_state = "Create Node";
			
			if (imguigml_button("Delete Selected Node") || keyboard_check_released(vk_delete))
			{
				if (instance_exists(selected_node) && selected_node.locked == false)
				{
					instance_destroy(selected_node);
					selected_node = noone;
				}
			}
			
			if (imguigml_button("Clear All"))
				if (instance_exists(obj_genericNode)) with obj_genericNode instance_destroy();
				
			if (imguigml_button("Save"))
				save_project(get_string("Enter Filename", current_filename) + ".txt");
				
			if (imguigml_button("Load"))
				load_project(get_open_filename("text file|*.txt", ""));
		}
		break;
		
		case "Create Node":
		{
			node_name = imguigml_input_text("", node_name, maximum_node_label_length)[1];
			node_note = imguigml_input_text_multiline("Node Note", node_note, maximum_node_note_text_length, 200, 160)[1];
			
			if (imguigml_button("Create Node"))
			{
				//Create the node	
				if (node_name != "")
				{
					var _c = instance_create_layer(100, 100, "Instances", obj_genericNode);
					_c.label = node_name;
					_c.note_text = node_note;
				}
				
				//Reset
				node_name = "";
				node_note = "";
				
				menu_state = "Workspace";
			}
		}
		break;
	}
	
	imguigml_end();
	
	//---Selected node menu---
	imguigml_set_next_window_pos(global.display_width - 240, 270);
	imguigml_set_next_window_size(240, 220);
	imguigml_begin("Selected Node");
	
	if (instance_exists(selected_node))
	{
		/*if (selected_node.locked == false)
		{
			selected_node.label = imguigml_input_text("Label", selected_node.label, maximum_node_label_length)[1];
			selected_node.note_text = imguigml_input_text_multiline("Desc.", selected_node.note_text, maximum_node_label_length, 200, 160)[1];
		}
		else
		{
			imguigml_text(selected_node.label);
			imguigml_text(selected_node.note_text);
		}*/
		
		selected_node.label = imguigml_input_text("Label", selected_node.label, maximum_node_label_length)[1];
		selected_node.note_text = imguigml_input_text_multiline("Desc.", selected_node.note_text, maximum_node_note_text_length, 200, 160)[1];
	}
	else imguigml_text("No Node Selected");
	
	imguigml_end();
}


//NODE INTERACTION
if (instance_exists(obj_genericNode))
{
	if (mouse_check_button(mb_left))
	{
		with (obj_genericNode)
		{
			var _x1 = x - 2;
			var _y1 = y - 2;
			var _x2 = x + string_width(label) + 2;
			var _y2 = y + string_height(label) + 2;
		
			if (point_in_rectangle(mouse_x, mouse_y, _x1, _y1, _x2, _y2) || other.dragging == id)
			{			
				other.selected_node = id;
			
				if (!locked)
					other.dragging = id;
			
				if (other.mouse_node_offset_x = -1337)
				{
					other.mouse_node_offset_x = (mouse_x - x);
					other.mouse_node_offset_y = (mouse_y - y);
				}
			}
			else continue;
			
			//Mouse locking
			if (mouse_check_button_pressed(mb_right))
				locked = !locked;
				
			break;
		}
	
	
		//Selected node functions
		if (instance_exists(selected_node))
		{
			if (dragging = selected_node && !selected_node.locked)
			{
				selected_node.x = mouse_x - mouse_node_offset_x;
				selected_node.y = mouse_y - mouse_node_offset_y;
			}	
		}
	}
	else
	{
		dragging = -4;
		mouse_node_offset_x = -1337;
		mouse_node_offset_y = -1337;
	}
}


//--WINDOW RESIZING
if (window_has_focus() && (global.display_width != window_get_width() || global.display_height != window_get_height()))
{
	global.display_width = window_get_width();
	global.display_height = window_get_height();
	
	surface_resize(application_surface, global.display_width, global.display_height);
}