#ifndef SIMPLE_CLASS_H
#define SIMPLE_CLASS_H

#include <Godot.hpp>
#include <Reference.hpp>

class SimpleClass : public godot::Reference
{
	GODOT_CLASS(SimpleClass, godot::Reference)

public:
	SimpleClass();

	/* _init must exist as it is called by Godot */
	void _init();

	void test_void_method();

	godot::Variant method(godot::Variant arg);

	static void _register_methods();

	godot::String _name;
	int _value;

	void set_value(int p_value);

	int get_value() const;
};

#endif  // SIMPLE_CLASS_H
