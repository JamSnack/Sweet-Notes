/// @description
//GUI
if (imguigml_ready())
{
	imguigml_set_next_window_pos();
	imguigml_begin(menu_state);
	
	switch (menu_state)
	{
		case "Workspace":
		{
			if (imguigml_button("Create Node"))
				menu_state = "Create Node";
				
			if (imguigml_button("Save"))
				save_project();
		}
		break;
		
		case "Create Node":
		{
			node_name = imguigml_input_text("Node Name", node_name, 32)[1];
			node_note = imguigml_input_text_multiline("Node Note", node_note, 512, 64, 80)[1];
			
			if (imguigml_button("Create Node"))
			{
				//Create the node	
				var _c = instance_create_layer(100, 100, "Instances", obj_genericNode);
				_c.label = node_name;
				_c.note_text = node_note;
				
				//Reset
				node_name = "";
				node_note = "";
				
				menu_state = "Workspace";
			}
		}
		break;
	}
	
	imguigml_end();
	
	//Selected node menu
	imguigml_begin("Selected Node");
	
	if (instance_exists(selected_node))
	{
		imguigml_text(selected_node.label);
		imguigml_text(selected_node.note_text);
	}
	else imguigml_text("No Node Selected");
	
	imguigml_end();
}


//NODE INTERACTION
if (!instance_exists(obj_genericNode))
	exit;
	
var nearest_node = instance_nearest(mouse_x, mouse_y, obj_genericNode);

if (mouse_check_button(mb_left))
{
	with (nearest_node)
	{		
		var _x1 = x;
		var _y1 = y;
		var _x2 = x + string_width(label);
		var _y2 = y + string_width(label);
		
		if (point_in_rectangle(mouse_x, mouse_y, _x1, _y1, _x2, _y2))
		{			
			other.selected_node = id;
			
			if (!locked)
				other.dragging = id;
		}
	}
	
	
	//Selected node functions
	if (instance_exists(selected_node))
	{
		if (dragging = selected_node && !selected_node.locked)
		{
			selected_node.x = mouse_x;
			selected_node.y = mouse_y;
		}
	
		//Lock nodes
		if (keyboard_check_released(vk_space))
			selected_node.locked = !selected_node.locked;
	}
}
else dragging = -4;

//show_debug_message(string(selected_node));