/// @description
var _sw = string_width(label);

var x1 = x - 2;
var y1 = y - 5;
var x2 = x + _sw + 2;
var y2 = y + 20 + 5;

//node selected
if (workspaceControl.selected_node == id)
{
	draw_set_color(c_green);
	draw_rectangle(x1-3, y1-3, x2+3, y2+3, false);	
}

//node body
draw_set_color(c_blue);
draw_rectangle( x1, y1, x2, y2, false);

//node locked
if (locked)
{
	draw_set_color(c_red);
	draw_rectangle(x1, y1, x2, y2, true);
}

//node label
draw_set_color(c_white);
draw_text(x, y, label);
